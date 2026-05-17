// tracking.h header file for tracking.c
// Copyright (C) 2005  Andrew Greenberg
// Distributed under the GNU GENERAL PUBLIC LICENSE (GPL) Version 2 (June 1991).
// See the "COPYING" file distributed with this software for more information.

#ifndef __TRACKING_H
#define __TRACKING_H

#include <stdint.h>
#include "namuru.h" // N_CHANNELS
#include "parallel_search.h" // REFINE_USE_SERIAL_CH

/*******************************************************************************
 * Definitions
 ******************************************************************************/
// Clock info
#define FPGA_CLOCK 50e6 // FPGA clock frequency [Hz]

// Carrier NCO timing
#define IF_FREQ 4.092e6                        // Frontend data frequency [Hz]
#define CARR_FREQ_RES (FPGA_CLOCK / (1 << 30)) // 0.046566129 [Hz] (Carrier NCO is 30 bits)
#define CODE_FREQ_RES (FPGA_CLOCK / (1 << 29)) // 0.093132257 [Hz] (Code    NCO is 29 bits)

#define CODE_REF (uint32_t)(0.5 + HALF_CHIP_RATE / CODE_FREQ_RES) // 21968758 = ceil(2.046e6/(50e6/2^29))
#define CARRIER_REF (uint32_t)(0.5 + IF_FREQ / CARR_FREQ_RES)     // 87875031 = ceil(4.092e6/(50e6/2^30))
#define DOPPLERFREQ2CARRNCO(DOPPLER_FREQ) (uint32_t)(0.5 + (IF_FREQ + DOPPLER_FREQ) / CARR_FREQ_RES)
#define CARRIERNCO2DOPPLERFREQ(NCO) (float)(NCO*CARR_FREQ_RES-IF_FREQ)
#define CODENCO2CODEDOPPLERFREQ(NCO) (float)(NCO*CODE_FREQ_RES - HALF_CHIP_RATE)
// Each increment in CARRIER_REF represents an increase of 0.046566129 Hz in frequency (CARR_FREQ_RES)

// Threshold
#define ACQUIRE_THRESHOLD 2000
#define LOCK_THRESHOLD 2000

// Tracking parameter
#define CarrSrchWidth 96
#define CarrSrchStep 2684

typedef enum
{
    CHANNEL_OFF,
    CHANNEL_ACQUISITION_SERIAL,
    CHANNEL_ACQUISITION_PARALLEL,
    CHANNEL_REFINE,
    CHANNEL_CONFIRM,
    CHANNEL_PULL_IN,
    CHANNEL_LOCK
} TRACKING_ENUM;

typedef enum
{
    half_chip = 0,        // 0.5   [chip]
    quarter_chip = 1,     // 0.25  [chip]
    half_quarter_chip = 2 // 0.125 [chip]
} chip_select_t;

/*******************************************************************************
 * Structures
 ******************************************************************************/
typedef struct
{
    TRACKING_ENUM state;
    uint16_t prn;
    int32_t i_early, i_prompt, i_late;  // Track arms (signed!)
    int32_t q_early, q_prompt, q_late;  // Track arms (signed!)
    int32_t i_prompt_old, q_prompt_old; // for FLL
    uint32_t carrier_freq_nco;          // in NCO hex units
    uint32_t code_freq;                 // in NCO hex units
    uint16_t n_freq;                    // Carrier frequency search bin
    uint16_t codes;                     // Current code phase
    // (in 1/2 chips, 0 - 2044)

    // confirm
    uint16_t confirm_count;             // how many times enter confirm function
    uint16_t threshold_hits;            // how many times hit the threshold in confirm function
    
    // refine
    uint8_t is_group_master;
    uint8_t arr_group_idx[REFINE_USE_SERIAL_CH];
    float carrier_freq;   // info only master needs to know, in real frequency
    uint8_t iteration;    // info only master needs to know
    uint16_t debug_code_phase_fft;
    uint16_t debug_slew;
    float debug_freq;
    float correlation, correlation_avg;

    // PLL/DLL
    long early_mag, prompt_mag, late_mag;
    int32_t i_early_20, i_prompt_20, i_late_20;
    int32_t q_early_20, q_prompt_20, q_late_20;

    // pull-in
    uint16_t pullin_count; // how many times enter pull_in function
    long delta_code_phase, delta_code_phase_old;
    long delta_carrier_phase, delta_carrier_phase_old;
    long delta_carrier_freq, delta_carrier_freq_old;

    // lock
    uint16_t ms_count; // time in a aligned navigation data (0~19 [ms])
    long avg;
    uint16_t check_average;
    long sum;

    uint16_t bit_sync;
    uint16_t bit;

    unsigned short sync_20ms_epoch_count; // the epoch counters.

    uint32_t time_in_bits; // Number of bits used to calculate time within a week, based on navigation data transmission rate(50[Hz]).
                           // A week has 604,800 seconds, so the range of bits is 0 to 30,239,999 (604,800 seconds × 50 bits/second).

    uint16_t sign_flip_pos, sign_flip_pos_prev; // Record bits edges: current and previous.
    uint16_t sign_flip_count;                   // How many times bit edges distance is more then 19 ms!
    long doppler_freq;
} chan_t;

/*******************************************************************************
 * Prototypes (Globally visible functions)
 ******************************************************************************/

void tracking_IRQ(void);
void tick_capture_thread(void *argument);

/*******************************************************************************
 * Externs (globally visible variables)
 ******************************************************************************/
extern unsigned int channels_with_bits;
extern chan_t CH[N_CHANNELS];

#endif // __TRACKING_H
