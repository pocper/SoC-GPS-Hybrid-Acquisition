// pseudorange.c Process measurements into pseudoranges
// Copyright (C) 2005  Andrew Greenberg
// Distributed under the GNU GENERAL PUBLIC LICENSE (GPL) Version 2 (June 1991).
// See the "COPYING" file distributed with this software for more information.
#include <math.h>
#include "constants.h"
#include "pseudorange.h"
#include "measure.h"
#include "position.h"
#include "time.h"

#include "tracking.h"

#define TOL 24 // 50/2 -1 // 5 is the largest seen in practice?

/******************************************************************************
 * Globals
 ******************************************************************************/
pseudorange_t pr[N_CHANNELS];
gpstime_t pr_time;

/******************************************************************************
 * Clear the pseudoranges (fast).
 ******************************************************************************/
void clear_pseudoranges(void)
{
    // Clear the valid flags
    for (int ch = 0; ch < N_CHANNELS; ch++)
    {
        pr[ch].valid = 0; // need to clear this flag, why do anything else?
        pr[ch].prn = 0;
        pr[ch].range = 0;
        pr[ch].delta_range = 0;
    }
    // If there are no pseudoranges, we can't position, so clear the
    // position as well
    clear_position(); // Still dislike this technique.
                      // Does it at least optimize properly?
}

/******************************************************************************
 * Calculate them pseudoranges.
 ******************************************************************************/
void calculate_pseudorange(unsigned short ch)
{
    unsigned short bit_count_remainder;
    unsigned long bit_count_modded;

    // The epoch counter is more accurate than our bit counter in tracking.c:
    // lock(), so make sure they agree. This means fixing up the least few
    // significant bits. We've seen them disagree by two, but no more.

    // Figure out how many "50 bit counts" are in the current bit counter.
    bit_count_remainder = meas[ch].meas_bit_time % 50;
    bit_count_modded = meas[ch].meas_bit_time - bit_count_remainder;

    // Fix up in case the epoch counter is on a different side of
    // a 50 bit "word" from us. Otherwise trust the almighty epoch counter.
    if ((bit_count_remainder < TOL) && (meas[ch].epoch_bits > (50 - TOL)))
        bit_count_modded -= 50;
    if ((bit_count_remainder > (50 - TOL)) && (meas[ch].epoch_bits < TOL))
        bit_count_modded += 50;

    // This can all be re-written to fixed point, don't know if we should.
    // sat_time = 20 [ms] * (epoch_bits[0~49] + bit_count_modded[0~(30239999-50)])
    //           + 1 [ms] * (epoch_codes[0~19] + 1/2046 [ms per half-chip] * (code_phase[0~2045] + code_nco_phase[0~1023]/1024))
    pr[ch].sat_time = .02 * (bit_count_modded + meas[ch].epoch_bits) +
                      CODE_TIME * ( meas[ch].epoch_codes + 
                        (1 / (double)MAX_CODE_PHASE) *
                        (meas[ch].code_phase + meas[ch].code_nco_phase / (double)(CODE_NCO_LENGTH)));

    // NO ionospheric corrections, no nuthin': mostly for debug
    // FIXME: What about GPS week for this calculation?! if time over saturday and sunday, we will have problem
    pr[ch].range = (pr_time.seconds - pr[ch].sat_time) * SPEED_OF_LIGHT;

    /*
     * Delta range measurement
     *
     * This part should be revisited to adopt the way we calculate the pseudorange.
     * Set a timer and check the NCO value in it.
     *
     * Please compensate for the loss during transmission
     */
    // Doppler distance = (Doppler frequency / L1 frequency) * speed of light * travel time (we estimate it as 0.01 [s])
    pr[ch].delta_range = ((double)(CH[ch].doppler_freq) * CARR_FREQ_RES) / L1 * SPEED_OF_LIGHT * 0.01;
    CH[ch].doppler_freq = 0;

    // Record the following information for debugging
    pr[ch].prn = meas[ch].prn;
    pr[ch].bit_time = bit_count_modded;
    pr[ch].epoch_bits = meas[ch].epoch_bits;
    pr[ch].epoch_ms = meas[ch].epoch_codes;
}

/******************************************************************************
 * Wake up on valid measurements and produce pseudoranges. Flag the navigation
 * thread if we have four or more valid pseudoranges
 ******************************************************************************/
