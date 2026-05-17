#include "cmsis_os2.h"

/* system header */
#include <stdlib.h>
#include <math.h>

/* HAL header */
#include "socal/socal.h"

/* User defined header */
#include "constants.h"
#include "tracking.h"
#include "namuru.h"
#include "measure.h"
#include "message.h"
#include "threads.h"
#include "position.h"

/* Later on, we scale 1 radian = 2^14 */
#define PI_SHIFT14 (long)(0.5 + PI * (1 << 14))
#define PI_OVER2_SHIFT14 (long)(0.5 + PI * (1 << 13))
#define sign(x) (x > 0 ? 1 : (x == 0) ? 0 \
                                      : -1)

#define chip_select_pullin quarter_chip
#define chip_select_lock half_quarter_chip

/*******************************************************************************
 * Global variables
 ******************************************************************************/
chan_t CH[N_CHANNELS];
unsigned int channels_with_bits;

// Convert 32-bit unsigned FPGA data to 32-bit signed, original data are 16-bit signed
static int signExtension(int instr)
{
    return (instr & 0x00008000) ? (instr | 0xFFFF0000) : instr;
}

// Timestamps for receiver metrics
uint32_t uptime_ms;
uint32_t position_ms;
uint8_t  satellite_locked_prn[4];
uint32_t satellite_locked_ms[4];

/******************************************************************************
 * Compute the approximate magnitude (square norm) of 2 numbers
 *
 * The "correct" function is naturally sqrt(a^2+b^2).
 * This computation is too slow for our application however.
 * We use the leading order approximation (mag = a+b/2) for b<a with sgn fixes.
 * This is probably as good as possible without a multiply.
 *
 * Haven't tried a fit, but based on endpoints a+(sqrt(2)-1)*b is a better
 * approximation. Everything else seems to have either a couple multiplies and
 * a divide, or an actual square root. It's a fact that if there's no hardware
 * multiply the binary square root is actually faster than a multiply on a GP
 * machine, but since the ARM7TDMI has a multiply the root is slower for us.
 ******************************************************************************/
static uint32_t mag_approx(int32_t a, int32_t b)
{
    if (a < 0)
        a = -a;
    if (b < 0)
        b = -b;

    if (a > b)
        return (a + (b >> 1));
    else
        return (b + (a >> 1));
}

/*******************************************************************************
FUNCTION fix_atan2( long y,long x)
RETURNS  long integer

PARAMETERS
        y  long   quadrature fixed point value
        x  long   in-phase fixed point value

PURPOSE
// This is the phase discriminator function.
    This function computes the fixed point arctangent represented by
    y and x in the parameter list
    1 radian = 2^14 = 16384
    based on the power series  2^14*( (y/x)-2/9*(y/x)^3 )

// This is not a particularly good approximation.
// In particular, 0.2332025325081921, rather than 2/9 is the best
// fit parameter. The next simplest thing to do is fit {x,x^3}
// I'm assuming the interval of validity is [0,1).
// Fitting {1,x,x^3} is bad because a discriminator must come smoothly to
// zero.
// I wonder, in the average math library, if it might be faster to do the
// division un-signed?
// It's not much more expensive to fit x+a*x^2+b*x^3 (one more add).
// The compiler may not properly optimize ()/9.

WRITTEN BY
    Clifford Kelley
    Fixed for y==x  added special code for x==0 suggested by Joel Barnes, UNSW
*******************************************************************************/
static long fix_atan2(long y, long x)
{
    long result = 0, n, n3;

    // 4 quadrants, one invalid case

    if ((x == 0) && (y == 0)) /* Invalid case */
        return (result);
    if (x > 0 && x >= labs(y))
    {
        n = (y << 14) / x;
        n3 = ((((n * n) >> 14) * n) >> 13) / 9;
        result = n - n3;
    }
    else if (x <= 0 && -x >= labs(y))
    {
        n = (y << 14) / x;
        n3 = ((((n * n) >> 14) * n) >> 13) / 9;
        if (y > 0)
            result = n - n3 + PI_SHIFT14;
        else if (y <= 0)
            result = n - n3 - PI_SHIFT14;
    }
    else if (y > 0 && y > labs(x))
    {
        n = (x << 14) / y;
        n3 = ((((n * n) >> 14) * n) >> 13) / 9;
        result = PI_OVER2_SHIFT14 - n + n3;
    }
    else if (y < 0 && -y > labs(x))
    {
        n = (x << 14) / y;
        n3 = ((((n * n) >> 14) * n) >> 13) / 9;
        result = -n + n3 - PI_OVER2_SHIFT14;
    }
    return (result);
}

/******************************************************************************
FUNCTION acquire( unsigned long ch)
RETURNS  None.

PARAMETERS
ch  char // Which correlator channel to use

PURPOSE  to perform initial acquire by searching code and frequency space
looking for a high correlation

WRITTEN BY
Clifford Kelley

 ******************************************************************************/
static void acquire(unsigned short ch)
{
    CH[ch].early_mag = mag_approx(CH[ch].i_early, CH[ch].q_early);
    CH[ch].prompt_mag = mag_approx(CH[ch].i_prompt, CH[ch].q_prompt);
    CH[ch].late_mag = mag_approx(CH[ch].i_late, CH[ch].q_late);

    if ((CH[ch].early_mag > ACQUIRE_THRESHOLD) || (CH[ch].prompt_mag > ACQUIRE_THRESHOLD) || (CH[ch].late_mag > ACQUIRE_THRESHOLD))
    {
        CH[ch].state = CHANNEL_CONFIRM;
        return;
    }

    ch_block->channels[ch].code_slew = 2;
    CH[ch].codes += 2;

    // The half-chip size is 2*1023, and when we reach 2044, we have reached the full chip length
    if (CH[ch].codes < 2044)
        return;

    CH[ch].codes = 0;
    /* Search carrier frequency bins */
    // 125 [Hz] = CarrSrchStep*(IF_FREQ / CARR_FREQ_RES)
    //  If n_freq = 0, then search 4.092 [MHz]
    //  If n_freq = 1, then search 4.092 [MHz] + (n_freq/2) * 125 [Hz]
    //  If n_freq = 2, then search 4.092 [MHz] - (n_freq/2) * 125 [Hz]
    if (CH[ch].n_freq & 1)
    {
        /* Odd search bins map to the "right" */
        CH[ch].carrier_freq_nco = CARRIER_REF + CarrSrchStep * (1 + (CH[ch].n_freq >> 1));
    }
    else
    {
        /* Even search bins are to the "left" of CARRIER_REF */
        CH[ch].carrier_freq_nco = CARRIER_REF - CarrSrchStep * (CH[ch].n_freq >> 1);
    }
    ch_block->channels[ch].carr_nco = CH[ch].carrier_freq_nco;

    CH[ch].n_freq++;

    // Search frequency range = 4.092 [MHz] +- (CarrSrchWidth/2) * 125 [Hz] = 4.092 [MHz] +- 6 [kHz]
    if (CH[ch].n_freq > CarrSrchWidth)
    {
        CH[ch].state = CHANNEL_OFF;
    }
}

/*******************************************************************************
*******************************************************************************/
static void refine(unsigned short n_ch)
{
    chan_t *ptr_g[REFINE_USE_SERIAL_CH];
    uint32_t arr_mag[REFINE_USE_SERIAL_CH];
    float freq_peak;
    // 1. check whether CH[n_ch] is master or not
    ptr_g[0] = &CH[n_ch];
    if (ptr_g[0]->arr_group_idx[0] != n_ch)
        return;
    // 2. check whether CH[n_ch]'s master is valid or not
    if (!ptr_g[0]->is_group_master)
        return;

    ptr_g[1] = &CH[ptr_g[0]->arr_group_idx[1]];

    for (int i = 0; i < REFINE_USE_SERIAL_CH; i++)
    {
        ptr_g[i]->early_mag = mag_approx(ptr_g[i]->i_early, ptr_g[i]->q_early);
        ptr_g[i]->prompt_mag = mag_approx(ptr_g[i]->i_prompt, ptr_g[i]->q_prompt);
        ptr_g[i]->late_mag = mag_approx(ptr_g[i]->i_late, ptr_g[i]->q_late);
        arr_mag[i] = ptr_g[i]->early_mag + ptr_g[i]->prompt_mag + ptr_g[i]->late_mag;
    }
    // pseudo code
    // f_low = ptr_g[0]->carrier_freq, f_high = ptr_g[1]->carrier_freq
    // Find correlation of f_low/f_high -> corr_low, corr_high
    // if(corr_low>corr_high)
    // then f_high_next = (f_low+f_high)/2, f_low_next = f_low
    // else f_low_next = (f_low+f_high)/2, f_high_next = f_high

    // 3. Change master & slave frequency and update parameter
    freq_peak = (ptr_g[0]->carrier_freq + ptr_g[1]->carrier_freq) / 2.0f;
    if (arr_mag[0] > arr_mag[1])
    {
        ptr_g[1]->carrier_freq = freq_peak;
        ptr_g[1]->carrier_freq_nco = DOPPLERFREQ2CARRNCO(ptr_g[1]->carrier_freq);
        ch_block->channels[ptr_g[0]->arr_group_idx[1]].carr_nco = ptr_g[1]->carrier_freq_nco;
    }
    else
    {
        ptr_g[0]->carrier_freq = freq_peak;
        ptr_g[0]->carrier_freq_nco = DOPPLERFREQ2CARRNCO(ptr_g[0]->carrier_freq);
        ch_block->channels[ptr_g[0]->arr_group_idx[0]].carr_nco = ptr_g[0]->carrier_freq_nco;
    }

    ptr_g[0]->iteration++;

    // 4. Check whether the process is done or not
    if (ptr_g[0]->iteration == 3)
    {
        for (int i = 0; i < REFINE_USE_SERIAL_CH; i++)
        {
            if (ptr_g[i]->is_group_master)
            {
                // ch_block->channels[n_ch].chip_select = chip_select_pullin;
                ptr_g[i]->state = CHANNEL_PULL_IN;
                ptr_g[i]->is_group_master = 0;
                ptr_g[i]->iteration = 0;
            }
            else
            {
                ptr_g[i]->state = CHANNEL_OFF;
            }

            ptr_g[i]->carrier_freq = 0;
            for (int j = 0; j < REFINE_USE_SERIAL_CH; j++)
            {
                ptr_g[i]->arr_group_idx[j] = 0;
            }
        }
    }
}
/*******************************************************************************
FUNCTION confirm(unsigned long ch)
RETURNS  None.

PARAMETERS
ch  char  channel number

PURPOSE  to lock the presence of a high correlation peak using an n of m
algorithm

WRITTEN BY
Clifford Kelley

*******************************************************************************/
static void confirm(unsigned short ch)
{
    CH[ch].early_mag = mag_approx(CH[ch].i_early, CH[ch].q_early);
    CH[ch].prompt_mag = mag_approx(CH[ch].i_prompt, CH[ch].q_prompt);
    CH[ch].late_mag = mag_approx(CH[ch].i_late, CH[ch].q_late);

    if ((CH[ch].early_mag > ACQUIRE_THRESHOLD) || (CH[ch].prompt_mag > ACQUIRE_THRESHOLD) || (CH[ch].late_mag > ACQUIRE_THRESHOLD))
        CH[ch].threshold_hits++;

    if (CH[ch].confirm_count < 5)
    {
        CH[ch].confirm_count++;
        return;
    }
    CH[ch].confirm_count = 0;

    if (CH[ch].threshold_hits >= 4)
    {
        // ch_block->channels[ch].chip_select = chip_select_pullin;
        CH[ch].state = CHANNEL_PULL_IN;
    }
    else
    {
        /* Keep searching - assumes search parameters are still ok */
        CH[ch].state = CHANNEL_ACQUISITION_SERIAL;
    }

    CH[ch].threshold_hits = 0;
}

/*******************************************************************************
FUNCTION pull_in( unsigned long ch)
RETURNS  None.

PARAMETERS
ch  char  channel number

PURPOSE
pull in the frequency by trying to track the signal with a
combination FLL and PLL
it will attempt to track for xxx ms, the last xxx ms of data will be
gathered to determine if we have both code and carrier lock
if so we will transition to track

WRITTEN BY
Clifford Kelley

*******************************************************************************/
static void pull_in(unsigned short ch)
{
    CH[ch].pullin_count++;

    CH[ch].early_mag = mag_approx(CH[ch].i_early, CH[ch].q_early);
    CH[ch].late_mag  = mag_approx(CH[ch].i_late, CH[ch].q_late);

    // Timeout over 3500 [ms]
    // if (CH[ch].pullin_count >= 3500)
    if (CH[ch].pullin_count >= 1600)
    {
#if (ACQ_MODE_SYSTEM == ACQ_MODE_HYBRID)
        CH[ch].state = CHANNEL_OFF;
#elif (ACQ_MODE_SYSTEM == ACQ_MODE_SERIAL)
        CH[ch].state = CHANNEL_ACQUISITION_SERIAL;
        CH[ch].codes += 2;
        CH[ch].code_freq = CODE_REF;
        ch_block->channels[ch].code_slew = 2;
        ch_block->channels[ch].code_nco = CH[ch].code_freq;
#endif
        CH[ch].pullin_count = 0;
        CH[ch].sign_flip_count = 0;
        CH[ch].sign_flip_pos = 0;
        CH[ch].sign_flip_pos_prev = 0;
        CH[ch].delta_code_phase_old = 0;
        CH[ch].delta_carrier_phase_old = 0;
        return;
    }

    long x, y;

    // PLL - code_nco
    // Noncoherent Discriminator
    // Prevent division by zero
    if (CH[ch].early_mag || CH[ch].late_mag)
    {
        // We magnify the integers (early_mag and late_mag) by a scale factor of 2^14,
        // perform as floating-point calculations for code_freq, and then scale the result back.
        CH[ch].delta_code_phase = (((CH[ch].early_mag - CH[ch].late_mag) << 14) / (CH[ch].early_mag + CH[ch].late_mag));
    }
    // PI Controller - magic number
    CH[ch].code_freq += ((429 * CH[ch].delta_code_phase - 421 * CH[ch].delta_code_phase_old) >> 14);
    CH[ch].delta_code_phase_old = CH[ch].delta_code_phase;
    ch_block->channels[ch].code_nco = CH[ch].code_freq;

    // PLL+FLL - carrier_nco
    // Frequency Discriminator
    y = CH[ch].i_prompt_old * CH[ch].q_prompt - CH[ch].i_prompt * CH[ch].q_prompt_old; // cross
    x = CH[ch].i_prompt * CH[ch].i_prompt_old + CH[ch].q_prompt * CH[ch].q_prompt_old; // dot
    CH[ch].delta_carrier_freq = fix_atan2(y, x);

    // Phase Discriminator
    y = CH[ch].q_prompt * sign(CH[ch].i_prompt);
    x = CH[ch].i_prompt;
    CH[ch].delta_carrier_phase = fix_atan2(y, x);

    // PI Controller - magic number
    CH[ch].carrier_freq_nco += ((725 * CH[ch].delta_carrier_phase - 655 * CH[ch].delta_carrier_phase_old + 50 * CH[ch].delta_carrier_freq) >> 14);
    CH[ch].delta_carrier_phase_old = CH[ch].delta_carrier_phase;
    ch_block->channels[ch].carr_nco = CH[ch].carrier_freq_nco;

    /* detect bits edges according to sign change of prompt in-phase correlator output. */
    if (sign(CH[ch].i_prompt) != -sign(CH[ch].i_prompt_old))
        return;
    
    CH[ch].sign_flip_pos_prev = CH[ch].sign_flip_pos;
    CH[ch].sign_flip_pos = CH[ch].pullin_count;

    // Navigation data rate is 50 bps, so bit edges are always multiples of 20 ms.
    if ((CH[ch].sign_flip_pos - CH[ch].sign_flip_pos_prev) < 20)
    {
        CH[ch].sign_flip_count = 0;
        return;
    }

    CH[ch].sign_flip_count++;

    // detect navigation data transition correctly more than 30 times
    // if (CH[ch].sign_flip_count > 30)
    if (CH[ch].sign_flip_count > 10)
    {
        // ch_block->channels[ch].chip_select = chip_select_lock;
        CH[ch].state = CHANNEL_LOCK;
        CH[ch].pullin_count = 0;
        CH[ch].sign_flip_count = 0;
        CH[ch].sign_flip_pos = 0;
        CH[ch].sign_flip_pos_prev = 0;

        CH[ch].bit_sync = 1;
        // the channel has achieved bit synchronization with 0 ms of navigation data.
        // it loads the start cycle_count with a 1 ms value.
        ch_block->channels[ch].epoch_load = 1;
    }
}

/*******************************************************************************
FUNCTION lock( unsigned long ch)
RETURNS  None.

PARAMETERS  char ch  , channel number

PURPOSE track carrier and code, and partially decode the navigation message
(to determine TOW, subframe etc.)

WRITTEN BY
Clifford Kelley
added Carrier Aiding as suggested by Jenna Cheng, UCR
*******************************************************************************/
static void lock(unsigned long ch)
{
    long x, y;
    CH[ch].ms_count++;

    // Integrated Signal for 20 ms
    CH[ch].i_early_20 += CH[ch].i_early;
    CH[ch].q_early_20 += CH[ch].q_early;
    CH[ch].i_prompt_20 += CH[ch].i_prompt;
    CH[ch].q_prompt_20 += CH[ch].q_prompt;
    CH[ch].i_late_20 += CH[ch].i_late;
    CH[ch].q_late_20 += CH[ch].q_late;

    // DLL - carrier_nco
    // Frequency Discriminator
    y = CH[ch].i_prompt_old * CH[ch].q_prompt - CH[ch].i_prompt * CH[ch].q_prompt_old; // cross
    x = CH[ch].i_prompt * CH[ch].i_prompt_old + CH[ch].q_prompt * CH[ch].q_prompt_old; // dot
    CH[ch].delta_carrier_freq = fix_atan2(y, x);

    // Phase Discriminator
    y = CH[ch].q_prompt * sign(CH[ch].i_prompt);
    x = CH[ch].i_prompt;
    CH[ch].delta_carrier_phase = fix_atan2(y, x);

    // PI Controller - magic number
    CH[ch].carrier_freq_nco += ((409 * CH[ch].delta_carrier_phase - 386 * CH[ch].delta_carrier_phase_old + 50 * CH[ch].delta_carrier_freq) >> 14);
    CH[ch].delta_carrier_phase_old = CH[ch].delta_carrier_phase;
    ch_block->channels[ch].carr_nco = CH[ch].carrier_freq_nco;

    CH[ch].doppler_freq += (CARRIER_REF - CH[ch].carrier_freq_nco);

    // Only work on sum of last 20ms of data
    if (CH[ch].ms_count < 20)
        return;
    CH[ch].ms_count = 0;

    CH[ch].early_mag = mag_approx(CH[ch].i_early_20, CH[ch].q_early_20);
    CH[ch].prompt_mag = mag_approx(CH[ch].i_prompt_20, CH[ch].q_prompt_20);
    CH[ch].late_mag = mag_approx(CH[ch].i_late_20, CH[ch].q_late_20);

    // Navigation Data bit
    CH[ch].bit = (CH[ch].i_prompt_20 > 0);

    CH[ch].i_early_20 = 0;
    CH[ch].q_early_20 = 0;
    CH[ch].i_prompt_20 = 0;
    CH[ch].q_prompt_20 = 0;
    CH[ch].i_late_20 = 0;
    CH[ch].q_late_20 = 0;

    // Notice message_thread in tracking() to work around
    channels_with_bits |= (1 << ch);

    // DLL - code_nco
    // Noncoherent Discriminator
    // Prevent division by zero
    if (CH[ch].early_mag || CH[ch].late_mag)
    {
        CH[ch].delta_code_phase = (((CH[ch].early_mag - CH[ch].late_mag) << 14) / (CH[ch].early_mag + CH[ch].late_mag));
    }
    // PI Controller - magic number
    CH[ch].code_freq += ((142 * CH[ch].delta_code_phase - 125 * CH[ch].delta_code_phase_old) >> 14);
    CH[ch].delta_code_phase_old = CH[ch].delta_code_phase;
    ch_block->channels[ch].code_nco = CH[ch].code_freq;

    /* Increment the time, in bits, since the week began. Used in
     * the measurement thread. Also set to the true time of
     * week when we get the TOW from a valid subframe in the
     * messages thread.
     */
    CH[ch].time_in_bits++;
    if (CH[ch].time_in_bits >= BITS_IN_WEEK)
        CH[ch].time_in_bits -= BITS_IN_WEEK;

    CH[ch].check_average++;
    CH[ch].sum += CH[ch].prompt_mag;
    
    if (CH[ch].check_average < 5)
        return;

    CH[ch].check_average = 0;
    CH[ch].avg = CH[ch].sum / 5;
    CH[ch].sum = 0;

    /* Signal loss. Clear channel. */
    if (CH[ch].avg < LOCK_THRESHOLD)
    {
        clear_messages(ch);
        CH[ch].state = CHANNEL_PULL_IN;

        CH[ch].bit_sync = 0;
        CH[ch].code_freq = CODE_REF;
    }
}
/*******************************************************************************
FUNCTION tracking( void)
RETURNS  None.

PARAMETERS  None

PURPOSE Main routine which runs on an accum_int.

WRITTEN BY
Clifford Kelley
added Carrier Aiding as suggested by Jenna Cheng, UCR
*******************************************************************************/
void tracking_IRQ(void)
{
    // Interrupt: 0.5 ms period
    // new_data: 1ms period
    uint32_t new_data = status_block->new_data;
    uint32_t status = status_block->status; // ack FPGA irq
    uint8_t to_allocate = 0;

    // Read data from FPGA
    for (int ch = 0; ch < N_CHANNELS; ch++)
    {
        if (new_data & (1 << ch))
        {
            CH[ch].i_prompt_old = CH[ch].i_prompt;
            CH[ch].q_prompt_old = CH[ch].q_prompt;

            CH[ch].i_early = signExtension(ch_block->channels[ch].i_early);
            CH[ch].q_early = signExtension(ch_block->channels[ch].q_early);
            CH[ch].i_prompt = signExtension(ch_block->channels[ch].i_prompt);
            CH[ch].q_prompt = signExtension(ch_block->channels[ch].q_prompt);
            CH[ch].i_late = signExtension(ch_block->channels[ch].i_late);
            CH[ch].q_late = signExtension(ch_block->channels[ch].q_late);

            /* We expect the 1ms epoch counter to always stay sync'd until
             * we lose lock. To sync the 20ms epoch counter (the upper bits)
             * we wait until we get a signal from the message thread that
             * we just got the TLM+HOW words; this means we're 60 bits into
             * the message. Since the damn epoch counter counts to *50* (?!)
             * we mod it with 60 which gives us 10 (0x140 when shifted 5).
             */
            if (CH[ch].sync_20ms_epoch_count)
            {
                ch_block->channels[ch].epoch_load =
                    (ch_block->channels[ch].epoch_check & 0x1f) | (0xA << 5);
                CH[ch].sync_20ms_epoch_count = 0;
            }
        }
    }
    
    for (int ch = 0; ch < N_CHANNELS; ch++)
    {
        if ((new_data & (1 << ch)) && (CH[ch].state != CHANNEL_OFF))
        {
            switch (CH[ch].state)
            {
                case CHANNEL_ACQUISITION_SERIAL:
                    acquire(ch);
                    break;
                case CHANNEL_ACQUISITION_PARALLEL:
                    break;
                case CHANNEL_REFINE:
                    refine(ch);
                    break;
                case CHANNEL_CONFIRM:
                    confirm(ch);
                    break;
                case CHANNEL_PULL_IN:
                    pull_in(ch);
                    break;
                case CHANNEL_LOCK:
                    lock(ch);
                    break;
                default:
                    // something wrong here
                    CH[ch].state = CHANNEL_OFF;
                    break;
            }
        }

        if(CH[ch].state == CHANNEL_OFF) {
            to_allocate = 1;
        }
    }
    
    if(to_allocate)
        osThreadFlagsSet(allocate_thread_id, FLAG_UPDATE);

    if (channels_with_bits)
        osThreadFlagsSet(message_thread_id, FLAG_UPDATE);

    // tic_enable, 0.1[s] interval
    if (status & 0x01)
    {
        osThreadFlagsSet(measure_thread_id, FLAG_UPDATE);
        osThreadFlagsSet(display_thread_id, FLAG_UPDATE);
    }

    // 0.5 [ms] interval
    osThreadFlagsSet(tick_capture_thread_id, FLAG_UPDATE);
}

void tick_capture_thread(void *argument)
{
    uint8_t is_registered;
    uint8_t cnt_lock = 0;
    uint8_t is_first_get_position_time = 0;

    while(1) 
    {
        osThreadFlagsWait(FLAG_UPDATE, osFlagsWaitAny, osWaitForever);
        uptime_ms = osKernelGetTickCount();

        if(cnt_lock >= 4 && is_first_get_position_time) {
            osThreadTerminate(osThreadGetId());
        }
        
        if(cnt_lock < 4)
        {
            for (int ch = 0; ch < N_CHANNELS; ch++)
            {
                if(CH[ch].state == CHANNEL_LOCK)
                {
                    is_registered = 0;
                    for (int i = 0; i < cnt_lock; i++)
                    {
                        if (satellite_locked_prn[i] == (CH[ch].prn + 1))
                        {
                            is_registered = 1;
                            break;
                        }
                    }
                    if (is_registered)
                        continue;
                    satellite_locked_prn[cnt_lock] = (CH[ch].prn + 1);
                    satellite_locked_ms[cnt_lock] = osKernelGetTickCount();
                    cnt_lock++;

                    if(cnt_lock >=4)
                        break;
                }
            }
        }

        if (receiver_pvt.valid && !is_first_get_position_time)
        {
            is_first_get_position_time = 1;
            position_ms = osKernelGetTickCount();
        }
    }
}