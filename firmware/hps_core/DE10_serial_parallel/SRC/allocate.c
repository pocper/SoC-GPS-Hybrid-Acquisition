#include "cmsis_os2.h"
#include "RTE_Components.h"
#include CMSIS_device_header

#include "allocate.h"
#include "namuru.h"
#include "tracking.h"
#include "message.h"
#include "ephemeris.h"
#include "threads.h"
#include "parallel_search.h"

/*******************************************************************************
 * Static (module level) variables
 ******************************************************************************/
// We don't use standard CACode Generator (without phase selector), kind of coincidence
// PRN = 1, 10'O1440 = 10'b11_0010_0000 -> bit_reverse + bit_invert -> 10'b11_1110_1100 = 10'h3EC
static unsigned short PrnCode[37] =
    {
        0x3EC, 0x3D8, 0x3B0, 0x360, 0x096, 0x12C,
        0x196, 0x32C, 0x258, 0x374, 0x2E8, 0x3A0,
        0x340, 0x280, 0x100, 0x200, 0x226, 0x04C,
        0x098, 0x130, 0x260, 0x0C0, 0x0CE, 0x270,
        0x0E0, 0x1C0, 0x380, 0x300, 0x056, 0x0AC,
        0x158, 0x2B0, 0x160, 0x0B0, 0x316, 0x22C,
        0x0B0};

static uint8_t default_alloc_prn_map[N_CHANNELS] = {1, 2, 5, 8, 9, 11, 12, 18, 21, 23, 24, 25, 30};
static uint8_t emulator_target_prn_list[N_CHANNELS] = {4, 5, 13, 15, 17, 20, 21, 28, 29, 30, 0, 1, 2};

extern parallel_t parallel;

/******************************************************************************
 * Initialize a channel into acquition mode
 ******************************************************************************/
void initialize_channel(unsigned short ch, unsigned short prn)
{
    if (ch >= N_CHANNELS || prn >= N_SATELLITES)
        return;

    /* Allocate the free satellite and get ready to check/allocate the next */
    CH[ch].prn = prn;

    /* Set SATCNTL register for C/A code, and LATE for dither arm */
    ch_block->channels[ch].prn_key = PrnCode[prn];

    /* Set carrier NCO */
    CH[ch].carrier_freq_nco = CARRIER_REF;
    ch_block->channels[ch].carr_nco = CH[ch].carrier_freq_nco;

    /* Initialize the code and frequency search variables */
    CH[ch].codes = 0;
    CH[ch].n_freq = 0;

    /* Set code NCO */
    CH[ch].code_freq = CODE_REF;
    ch_block->channels[ch].code_nco = CH[ch].code_freq;

    // chip_select
    ch_block->channels[ch].chip_select = half_chip;

    // refine
    CH[ch].carrier_freq = 0;
    CH[ch].is_group_master = 0;
    CH[ch].iteration = 0;

    for (int i = 0; i < REFINE_USE_SERIAL_CH; i++)
    {
        CH[ch].arr_group_idx[i] = 0;
    }

    /* clear Bit sync flags */
    CH[ch].bit_sync = 0;

    /* Signal strength */
    CH[ch].sum = 0.0;
    CH[ch].avg = 0.0;

    /* Epoch counter set flags */
    CH[ch].sync_20ms_epoch_count = 0;

    /* Clear the number of bits since the week began */
    CH[ch].time_in_bits = 0;

    /* Clear the sat navigation message for this channel,
     * including the ephemeris since we're switching sats */
    clear_messages(ch);
    clear_ephemeris(ch);

    /* Update channel state */
#if (ACQ_MODE_SYSTEM == ACQ_MODE_HYBRID)
    CH[ch].state = CHANNEL_OFF;
#elif (ACQ_MODE_SYSTEM == ACQ_MODE_SERIAL)
    CH[ch].state = CHANNEL_ACQUISITION_SERIAL;
#endif
}

/******************************************************************************
 * We don't know anything about any satellite (cold power on with no memory)
 * so blindly go through satellites, one at a now through channels.
 ******************************************************************************/
static void cold_allocate_channel(unsigned short ch)
{
    static unsigned short next_satellite = 0; // Search satellites 1st to last

    unsigned short i;
    unsigned short already_allocated;
    do
    {
        next_satellite++;

        if (next_satellite >= 32)
            next_satellite = 0; // check satellites 1 to 32

        already_allocated = 0;
        for (i = 0; i < N_CHANNELS; i++)
        {
            if ((CH[i].prn == next_satellite) && (CH[i].state != CHANNEL_OFF))
            {
                already_allocated = 1;
                break; // Exit the for loop.
            }
        }
    } while (already_allocated);

    initialize_channel(ch, next_satellite);
}

/******************************************************************************
 * These satellites are currently aloft and operational as of 2005/04/26:
 *
 * PRN:   1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 13, 14, 15, 16
 * SLOT: F6, D7, C2, D4, B4, C1, C4, A3, A1, E3, D2, F3, F1, D5, B1
 *
 * PRN:  18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 31
 * SLOT: E4, C3, E1, D3, E2, F4, D1, A2, F2, A4, B3, F5, B2 C5
 *
 * Sorted by satellite orbit ("slot"), they are:
 *
 * A1: 09   B1: 16  C1: 06  D1: 24  E1: 20  F1: 14
 * A2: 25   B2: 30  C2: 03  D2: 11  E2: 22  F2: 26
 * A3: 08   B3: 28  C3: 19  D3: 21  E3: 10  F3: 13
 * A4: 27   B4: 04  C4: 07  D4: 04  E4: 18  F4: 23
 * A5:      B5:     C5: 31  D5: 15  E5:     F5: 29
 * A6:      B6:     C6:     D6:     E6:     F6: 01
 * A7:      B7:     C7:     D7: 02  E7:     F7:
 *
 * Randomly, we pick two satellites from each orbit configuration, #1 and #3.
 *
 * This means we start with: 08,09,16,28,06,19,24,21,20,10,14,13
 * which sorted by order is: 06,08,09,10,13,14,16,19,20,21,24,28
 ******************************************************************************/
void initialize_allocation(void)
{
    // for(int i=0;i<N_CHANNELS;++i)
    //     initialize_channel(i, default_alloc_prn_map[i]);

    for (int i = 0; i < N_CHANNELS; ++i)
        initialize_channel(i, emulator_target_prn_list[i]);
}

/******************************************************************************
 * We don't know anything about any satellite (cold power on with no memory)
 * so blindly go through satellites, one at a now through channels.
 ******************************************************************************/
void allocate_thread(void const *argument)
{
#if (ACQ_MODE_SYSTEM == ACQ_MODE_HYBRID)
    uint8_t arr_ch_off[REFINE_USE_SERIAL_CH];
    uint8_t cnt_ch_off;
    uint16_t adj_halfchip;
    float carrier_freq;
    uint8_t already_allocated;

    while (1)
    {
        // 1. tracking.c irq will notify this thread to work
        osThreadFlagsWait(FLAG_UPDATE, osFlagsWaitAny, osWaitForever);
        
        // 2. Find 2 idle channel and initialize them
        cnt_ch_off = 0;
        for (int ch = 0; ch < N_CHANNELS; ch++)
        {
            if (CH[ch].state == CHANNEL_OFF)
            {
                arr_ch_off[cnt_ch_off] = ch;
                cnt_ch_off++;
            }
            
            if (cnt_ch_off == REFINE_USE_SERIAL_CH)
                break;
        }
            
        if (cnt_ch_off < REFINE_USE_SERIAL_CH)
            continue;

        // 3. Find a CACode that we don't proccess yet
        do
        {
            parallel.prn = (parallel.prn == 31) ? 0 : (parallel.prn + 1);

            already_allocated = 0;
            for (int ch = 0; ch < N_CHANNELS; ch++)
            {
                if (CH[ch].state != CHANNEL_OFF && CH[ch].prn == parallel.prn)
                {
                    already_allocated = 1;
                    break;
                }
            }
        } while (already_allocated);

        // 4. Initialize Serial Search Channel with the CACode
        for (int i = 0; i < REFINE_USE_SERIAL_CH; i++)
            initialize_channel(arr_ch_off[i], parallel.prn);
        code_delay_block->set_serial_ch_0 = arr_ch_off[0];
        code_delay_block->set_serial_ch_1 = arr_ch_off[1];

        // 5. Notify parallel Search start working
        osThreadFlagsSet(parallel_search_thread_id, FLAG_START);

        // 6. Wait until parallel Search finish working
        osThreadFlagsWait(FLAG_DONE, osFlagsWaitAny, osWaitForever);
        
        // 7. Received the parallel search result
        if(!parallel.valid) {
            continue;
        }

        // 8. if valid, process them to serial search
        carrier_freq = (float)(parallel.carrier_frequency);

        CH[arr_ch_off[0]].is_group_master = 1;
        for (int i = 0; i < REFINE_USE_SERIAL_CH; i++)
        {
            CH[arr_ch_off[i]].arr_group_idx[0] = arr_ch_off[0];
            CH[arr_ch_off[i]].arr_group_idx[1] = arr_ch_off[1];
        }

        CH[arr_ch_off[0]].carrier_freq = carrier_freq - (float)(FREQ_RESOLUTION / 2);
        CH[arr_ch_off[1]].carrier_freq = carrier_freq + (float)(FREQ_RESOLUTION / 2);

        CH[arr_ch_off[0]].carrier_freq_nco = DOPPLERFREQ2CARRNCO(CH[arr_ch_off[0]].carrier_freq);
        CH[arr_ch_off[1]].carrier_freq_nco = DOPPLERFREQ2CARRNCO(CH[arr_ch_off[1]].carrier_freq);

        ch_block->channels[arr_ch_off[0]].carr_nco = CH[arr_ch_off[0]].carrier_freq_nco;
        ch_block->channels[arr_ch_off[1]].carr_nco = CH[arr_ch_off[1]].carrier_freq_nco;

        adj_halfchip = parallel.code_phase_fft % MAX_CODE_PHASE; // 0~4095 -> 0~2045
        if (adj_halfchip > MAX_CODE_PHASE)
            adj_halfchip -= (MAX_CODE_PHASE + 4);
        adj_halfchip -= 2;

        ch_block->channels[arr_ch_off[0]].code_slew = adj_halfchip;
        ch_block->channels[arr_ch_off[1]].code_slew = adj_halfchip;
        CH[arr_ch_off[0]].debug_freq = carrier_freq;
        CH[arr_ch_off[0]].debug_code_phase_fft = parallel.code_phase_fft;
        CH[arr_ch_off[0]].debug_slew = adj_halfchip;
        CH[arr_ch_off[0]].correlation = parallel.correlation;
        CH[arr_ch_off[0]].correlation_avg = parallel.correlation_avg;

        CH[arr_ch_off[0]].state = CHANNEL_REFINE;
        CH[arr_ch_off[1]].state = CHANNEL_REFINE;
    }
#elif (ACQ_MODE_SYSTEM == ACQ_MODE_SERIAL)
    while (1)
    {
        // 1. tracking.c irq will notify this thread to work
        osThreadFlagsWait(FLAG_UPDATE, osFlagsWaitAny, osWaitForever);

        // 2. Perform cold allocation for any inactive channels
        for (int ch = 0; ch < N_CHANNELS; ch++)
        {
            if (CH[ch].state == CHANNEL_OFF)
                cold_allocate_channel(ch);
        }
    }
#endif
}
