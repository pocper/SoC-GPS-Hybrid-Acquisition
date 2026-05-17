/*
 * measure.c Take measurements each TIC interrupt (~100ms)
 * Copyright (C) 2005  Andrew Greenberg
 * Distributed under the GNU GENERAL PUBLIC LICENSE (GPL) Version 2 (June 1991).
 * See the "COPYING" file distributed with this software for more information.
 */
#include "cmsis_os2.h"
#include "RTE_Components.h"
#include CMSIS_device_header

#include "measure.h"
#include "constants.h"
#include "message.h"
#include "pseudorange.h"
#include "time.h"
#include "tracking.h"
#include "namuru.h"
#include "position.h"
#include "ephemeris.h"
#include "threads.h"
#include "DOP.h"

/******************************************************************************
 * Globals
 ******************************************************************************/
measurement_t meas[N_CHANNELS];
DOP_t receiver_DOP;

/******************************************************************************
 * Grab the time in bits from the tracking loops.
 *
 * Note, when the TIC comes right at the end of a message bit transition, then
 * an accum_int may increment a time_in_bits for one of the channels *while*
 * we're running in the measure_thread(). we handle that case by calling this
 * small routine directly from the accumulate DSR in interrupts.c .
 ******************************************************************************/
static void grab_bit_times(void)
{
    for (int ch = 0; ch < N_CHANNELS; ch++)
        meas[ch].meas_bit_time = CH[ch].time_in_bits;
}

/******************************************************************************
 * Grab the latched measurement data from the accumulators after a TIC.
 ******************************************************************************/
void measure_thread(void const *argument)
{
    static unsigned short channels_ready_prev;
    xyz_t ecef_temp;
    satinfo_t satinfo;
    gpstime_t meas_time;
    uint32_t channels_ready;
    uint8_t satnum;
    unsigned short pr_count;
    uint32_t raw_epoch;
    uint32_t tmp;
    while (1)
    {
        osThreadFlagsWait(FLAG_UPDATE, osFlagsWaitAny, osWaitForever);
        grab_bit_times();
        increment_time_with_tic();
        meas_time = get_time();
        channels_ready = 0;
        for (int ch = 0; ch < N_CHANNELS; ch++)
        {
            /*
             * If the channel is 1) locked and 2) the signal is good and 3) the
             * clock is set vaguely correctly and 4) we've set the epoch counter
             * for this channel, THEN grab the measurement data.
             */
            if (!((CH[ch].state == CHANNEL_LOCK) && (CH[ch].avg > LOCK_THRESHOLD) && (get_clock_state() >= SF1_CLOCK) && (messages[ch].set_epoch_flag)))
            {
                meas[ch].valid = 0;
                continue;
            }

            meas[ch].prn = CH[ch].prn;
            meas[ch].valid = 1;

            // epoch[4:0]  := cycle_count (0~19)
            // epoch[11:5] := bit_count   (0~49)
            raw_epoch = ch_block->channels[ch].epoch;
            // code_val[9:0]   := code_nco_phase
            // code_val[20:10] := code_gen_phase (0~2045)
            tmp = ch_block->channels[ch].code_val;
            meas[ch].code_phase = (tmp >> 10) & 0x7FF;
            meas[ch].code_nco_phase = (tmp & 0x3FF);

            // carrier_val[9:0]   := carrier_nco_phase
            // carrier_val[31:10] := carrier_cycle
            tmp = ch_block->channels[ch].carrier_val;
            meas[ch].carrier_cycles = (tmp >> 10);

            /*
             * If a TIC hits right before a dump, it's possible for the
             * code phase to latch 2046. In this case the epoch counter
             * won't be incrmented yet. If so, increment the epoch manually
             * (see the GP4020 design manual section 7.6.17). Of course, we
             * have to handle rollover of the epoch counter too.
             */
            if (meas[ch].code_phase < MAX_CODE_PHASE)
            {
                meas[ch].epoch_bits = raw_epoch >> 5;
                meas[ch].epoch_codes = raw_epoch & 0x1f;
            }
            else
            {
                meas[ch].code_phase -= MAX_CODE_PHASE;
                if ((raw_epoch & 0x1f) == 19)
                {
                    meas[ch].epoch_codes = 0;
                    meas[ch].epoch_bits = (raw_epoch >> 5) + 1;
                    if (meas[ch].epoch_bits > 49)
                        meas[ch].epoch_bits = 0;
                }
                else
                {
                    meas[ch].epoch_bits = raw_epoch >> 5;
                    meas[ch].epoch_codes = (raw_epoch & 0x1f) + 1;
                }
            }

            /*
             * Tell the pseudorange thread which measurements it can use.
             * Note that we don't want to just call the pr thread from here
             * because we're in a DSR and should get out ASAP
             */
            channels_ready |= (1 << ch);
        }

        /*
         * And finally, flag all the valid measurements to the pseudorange
         * thread and if there are none, but there were last TIC, then
         * explicitely clear the pseudoranges.
         */
        // We don't have new pseudorange data, only old pseudorange data, so clear the data
        if (channels_ready == 0 && channels_ready_prev != 0)
            clear_pseudoranges();
        channels_ready_prev = channels_ready;

        // nothing we can do
        if (channels_ready == 0)
            continue;

        pr_count = 0;
        pr_time = meas_time; // for calculate pseudorange between satellite and local time
        for (int ch = 0; ch < N_CHANNELS; ++ch)
        {
            if (channels_ready & (1 << ch))
            {
                calculate_pseudorange(ch);
                pr[ch].valid = 1;
                pr_count++;
            }
            else
                pr[ch].valid = 0;
        }

        satnum = 0;
        for (int ch = 0; ch < N_CHANNELS; ++ch)
        {
            if (ephemeris[ch].valid && pr[ch].valid)
            {
                sat_pos_by_ch_old[ch] = sat_pos_by_ch[ch];
                satinfo = SatPosEphemeris(ch);
                sat_pos_by_ch[ch] = satinfo.pos;
                sat_vel_by_ch[ch] = satinfo.vel;
                sat_vel_by_ch[ch].td = (sat_pos_by_ch[ch].tb - sat_pos_by_ch_old[ch].tb) * 10;
                sat_azel[ch] = satellite_azel(sat_pos_by_ch[ch]);

                /*
                 * Pack the satellite positions into an array for efficiency
                 * in the calculate_position function.
                 */
                sat_position[satnum].x = sat_pos_by_ch[ch].x;
                sat_position[satnum].y = sat_pos_by_ch[ch].y;
                sat_position[satnum].z = sat_pos_by_ch[ch].z;
                sat_position[satnum].vx = sat_vel_by_ch[ch].vx;
                sat_position[satnum].vy = sat_vel_by_ch[ch].vy;
                sat_position[satnum].vz = sat_vel_by_ch[ch].vz;
                sat_position[satnum].channel = ch;
                sat_position[satnum].prn = pr[ch].prn;

                /* Pseudorange measurement. No ionospheric delay correction. */
                m_rho[satnum] = pr[ch].range + (SPEED_OF_LIGHT * sat_pos_by_ch[ch].tb);
                m_rho_dot[satnum] = pr[ch].delta_range;
                satnum++;
            }
        }

        if (satnum < 4)
        {
            clear_position();
            continue;
        }

        /* If we've got 4 or more satellites, position! */
        positioning = 1;
        receiver_pvt = calculate_position(satnum);
        receiver_pvt_velocity = calculate_velocity(satnum);

        if (!receiver_pvt.valid)
            continue;

        /*
         * Correct the clock with the latest bias. But not that the
         * clock correction function may be smoothing the correction
         * and doing other funky things.
         */
        receiver_pvt.b /= SPEED_OF_LIGHT;
        set_clock_correction(receiver_pvt.b);

        ecef_temp.x = receiver_pvt.x;
        ecef_temp.y = receiver_pvt.y;
        ecef_temp.z = receiver_pvt.z;
        receiver_llh = ecef_to_llh(ecef_temp);
        receiver_DOP = calculate_DOP(satnum);
    }
}
