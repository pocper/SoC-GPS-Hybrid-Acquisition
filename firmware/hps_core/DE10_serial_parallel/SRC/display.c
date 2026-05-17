/*
 * display.c gpl-gps display output
 * Copyright (C) 2005  Andrew Greenberg
 * Distributed under the GNU GENERAL PUBLIC LICENSE (GPL) Version 2 (June 1991).
 * See the "COPYING" file distributed with this software for more information.
 */
#include "cmsis_os2.h"
#include "RTE_Components.h"
#include CMSIS_device_header

#include <stdio.h>
#include <math.h>

#include "uart.h"
#include "display.h"
#include "constants.h"
#include "ephemeris.h"
#include "message.h"
#include "position.h"
#include "pseudorange.h"
#include "time.h"
#include "tracking.h"
#include "measure.h"
#include "threads.h"

uint8_t display_command = DISPLAY_TRACKING;
static uint8_t ephemeris_mode;

// VT100 series command
static const uint8_t cmd_cursor_hide[] = "\033[?25l";
static const uint8_t cmd_clear_to_endline[] = "\033[K";
static const uint8_t cmd_clear_screen[] = "\033[2J";
static const uint8_t cmd_cursor_home[] = "\033[H";
static const uint8_t txt_green_prefix[] = "\033[32m";
static const uint8_t bg_blue_prefix[] = "\033[44m";
static const uint8_t txt_reset_color[] = "\033[0m";

// Timestamps for receiver metrics
extern uint32_t uptime_ms;
extern uint32_t position_ms;
extern uint8_t  satellite_locked_prn[4];
extern uint32_t satellite_locked_ms[4];

/******************************************************************************
 * Display position/clock info
 ******************************************************************************/
static uint8_t update_state_character(TRACKING_ENUM state)
{
    uint8_t c;
    switch (state)
    {
    case CHANNEL_ACQUISITION_SERIAL:
        c = 'A';
        break;
    case CHANNEL_ACQUISITION_PARALLEL:
        c = 'A';
        break;
    case CHANNEL_CONFIRM:
        c = 'C';
        break;
    case CHANNEL_PULL_IN:
        c = 'P';
        break;
    case CHANNEL_LOCK:
        c = 'L';
        break;
    case CHANNEL_REFINE:
        c = 'R';
        break;
    default:
        c = '-';
        break;
    }
    return c;
}

static void display_position(void)
{
    time_t std_time = get_standard_time();
    gpstime_t gps_time = get_time();
    unsigned short clock_state = get_clock_state();
    double lat = receiver_llh.lat * RADTODEG;
    double lon = receiver_llh.lon * RADTODEG;
    double degrees_abs, minutes;
    uint8_t degrees;
    char direction;

    uint8_t channel_state;

    // Print the Clock/Time info
    printf("%sDate/Time%s\n", txt_green_prefix, txt_reset_color);
    printf("valid = %1d\n", (clock_state == FIX_CLOCK || clock_state == SF1_CLOCK));
    printf("%4d/%02d/%02d %02d:%02d:%02d\n",
           std_time.years,
           std_time.months,
           std_time.days,
           std_time.hours,
           std_time.minutes,
           (int)std_time.seconds);
    printf("---\n\n");

    // Print the ECEF position/velocity info
    printf("%s%-16s | %-16s%s\n", txt_green_prefix, "Position (ECEF)", "Velocity (ECEF)", txt_reset_color);
    printf("valid = %1d\n", receiver_pvt.valid);
    printf("X %10.2f [m] | Vx %6.2f [m/s]\n", receiver_pvt.x, receiver_pvt_velocity.vx);
    printf("Y %10.2f [m] | Vy %6.2f [m/s]\n", receiver_pvt.y, receiver_pvt_velocity.vy);
    printf("Z %10.2f [m] | Vz %6.2f [m/s]\n", receiver_pvt.z, receiver_pvt_velocity.vz);
    printf("B %10.2f [m] | df %6.2f [m/s]\n", receiver_pvt.b, receiver_pvt_velocity.df);
    printf("error %10.2f [m] | %6.2f [m/s]\n", receiver_pvt.error, receiver_pvt_velocity.error);
    printf("---\n\n");

    // Print the LLH position info
    printf("%sPosition%s\n", txt_green_prefix, txt_reset_color);
    direction = (lat > 0) ? 'N' : ((lat == 0) ? ' ' : 'S');
    degrees_abs = fabs(lat);
    degrees = (int)degrees_abs;
    minutes = (degrees_abs - degrees) * 60.0;
    printf("%-9s %c %d° %.7f'\n", "Latitude", direction, degrees, minutes);

    direction = (lon > 0) ? 'E' : ((lon == 0) ? ' ' : 'W');
    degrees_abs = fabs(lon);
    degrees = (int)degrees_abs;
    minutes = (degrees_abs - degrees) * 60.0;
    printf("%-9s %c %d° %.7f'\n", "Longitude", direction, degrees, minutes);
    printf("%-9s %10.2f [m]\n", "Height", receiver_llh.hgt);
    printf("---\n\n");

    // Print DOP
    printf("%sDilution of Precision%s\n", txt_green_prefix, txt_reset_color);
    printf("valid = %d\n", receiver_DOP.valid);
    printf("HDOP = %.4f\n", receiver_DOP.HDOP);
    printf("PDOP = %.4f\n", receiver_DOP.PDOP);
    printf("GDOP = %.4f\n", receiver_DOP.GDOP);
    printf("---\n\n");

    // Now put out a summary of the receiver
    printf("%sCH PN C PrV EpV   Pseudorange%s\n", txt_green_prefix, txt_reset_color);

    // Send out data on all N_CHANNELS if there's no error
    for (int ch = 0; ch < N_CHANNELS; ch++)
    {
        channel_state = update_state_character(CH[ch].state);
        printf("%2d %2d %c   %d   %d",
               ch,
               CH[ch].prn,
               channel_state,
               pr[ch].valid,
               ephemeris[ch].valid);

        if (pr[ch].valid && ephemeris[ch].valid)
            printf("  %e", pr[ch].range);
        else
            printf("%s", cmd_clear_to_endline);
        printf("\n");
    }
}

/******************************************************************************
 * Display pseudorange info
 ******************************************************************************/
static void display_pseudorange(void)
{
    uint8_t channel_state;
    printf("%s%2s %2s %1s %8s %10s %8s %13s %7s%s\n",
           txt_green_prefix,
           "CH", "PN", "S", "bit_50", "epoch_bits", "epoch_ms", "Pseudorange", "Average",
           txt_reset_color);

    /* Send out data on all 12 channels if there's no error */
    for (int ch = 0; ch < N_CHANNELS; ch++)
    {
        channel_state = update_state_character(CH[ch].state);

        printf("%2d %2d %c",
               ch,
               pr[ch].prn,
               channel_state);

        if (pr[ch].valid)
            printf(" %8ld %10d %8d  %e %7ld",
                   pr[ch].bit_time,
                   pr[ch].epoch_bits,
                   pr[ch].epoch_ms,
                   pr[ch].range,
                   CH[ch].avg);
        else
            printf("%s", cmd_clear_to_endline);

        printf("\n");
    }
}

/******************************************************************************
 * Display ephemeris_thread info
 ******************************************************************************/
static void display_ephemeris(void)
{
    printf("ephemeris ID #%1d/5\n", ephemeris_mode);

    if (ephemeris_mode == 0)
    {
        printf("%sCH PN V SF UR HE IODC  ------tgd------ ------toc------%s\n", txt_green_prefix, txt_reset_color);

        for (int ch = 0; ch < N_CHANNELS; ch++)
        {
            printf("%2d %2d %d %2x %2d %2x",
                   ch,
                   ephemeris[ch].prn,
                   ephemeris[ch].valid,
                   ephemeris[ch].have_subframe,
                   ephemeris[ch].ura,
                   ephemeris[ch].health);

            if (ephemeris[ch].valid)
                printf(" %4d %15e %15e",
                       ephemeris[ch].iodc,
                       ephemeris[ch].tgd,
                       ephemeris[ch].toc);
            else
                printf("%s", cmd_clear_to_endline);
            printf("\n");
        }
    }
    else if (ephemeris_mode == 1)
    {
        printf("%sCH ------af2------ ------af1------ ------af0------%s\n", txt_green_prefix, txt_reset_color);

        for (int ch = 0; ch < N_CHANNELS; ch++)
        {
            printf("%2d", ch);
            if (ephemeris[ch].valid)
            {
                printf(" %15e %15e %15e",
                       ephemeris[ch].af2,
                       ephemeris[ch].af1,
                       ephemeris[ch].af0);
            }
            else
                printf("%s", cmd_clear_to_endline);
            printf("\n");
        }
    }
    else if (ephemeris_mode == 2)
    {
        printf("%sCH IODE ------Crs------ ------dn------- ------Mo------- ------Cuc------%s\n", txt_green_prefix, txt_reset_color);

        for (int ch = 0; ch < N_CHANNELS; ch++)
        {
            printf("%2d", ch);
            if (ephemeris[ch].valid)
            {
                printf(" %4d %15e %15e %15e %15e",
                       ephemeris[ch].iode,
                       ephemeris[ch].crs,
                       ephemeris[ch].dn,
                       ephemeris[ch].ma,
                       ephemeris[ch].cuc);
            }
            else
                printf("%s", cmd_clear_to_endline);
            printf("\n");
        }
    }
    else if (ephemeris_mode == 3)
    {
        printf("%sCH ------e-------- ------Cus------ ------sqA------ --toe--%s\n", txt_green_prefix, txt_reset_color);

        for (int ch = 0; ch < N_CHANNELS; ch++)
        {
            printf("%2d", ch);
            if (ephemeris[ch].valid)
            {
                printf(" %15e %15e %15e %6.1f",
                       ephemeris[ch].ety,
                       ephemeris[ch].cus,
                       ephemeris[ch].sqra,
                       ephemeris[ch].toe);
            }
            else
                printf("%s", cmd_clear_to_endline);
            printf("\n");
        }
    }
    else if (ephemeris_mode == 4)
    {
        printf("%sCH ------cic------ ------w0------- ------cis------ ------inc0-----%s\n", txt_green_prefix, txt_reset_color);

        for (int ch = 0; ch < N_CHANNELS; ch++)
        {
            printf("%2d", ch);
            if (ephemeris[ch].valid)
            {
                printf(" %15e %15e %15e %15e",
                       ephemeris[ch].cic,
                       ephemeris[ch].w0,
                       ephemeris[ch].cis,
                       ephemeris[ch].inc0);
            }
            else
                printf("%s", cmd_clear_to_endline);
            printf("\n");
        }
    }
    else if (ephemeris_mode == 5)
    {
        printf("%sCH ------crc------ ------w-------- ---omegadot---- ------idot-----%s\n", txt_green_prefix, txt_reset_color);

        for (int ch = 0; ch < N_CHANNELS; ch++)
        {
            printf("%2d", ch);
            if (ephemeris[ch].valid)
            {
                printf(" %15e %15e %15e %15e",
                       ephemeris[ch].crc,
                       ephemeris[ch].w,
                       ephemeris[ch].omegadot,
                       ephemeris[ch].idot);
            }
            else
                printf("%s", cmd_clear_to_endline);
            printf("\n");
        }
    }
}

/******************************************************************************
 * Display tracking_thread info
 ******************************************************************************/
static void display_tracking(void)
{
    uint8_t channel_state;
    uint8_t channel_bitsync;
    uint8_t channel_framesync;
    uint8_t min, sec, ms;
    uint32_t total_sec, total_ms;

    total_ms = uptime_ms;
    total_sec = (total_ms / 1000);

    ms = total_ms % 1000;
    sec = total_sec % 60;
    min = total_sec / 60;
    printf("Execution time:    %02d:%02d:%03d\n", min, sec, ms);

    for(int i=0;i<4;i++) {
        total_ms = satellite_locked_ms[i];
        total_sec = (total_ms / 1000);

        ms = total_ms % 1000;
        sec = total_sec % 60;
        min = total_sec / 60;

        printf("%1d: PRN[%02d],  time: %02d:%02d:%03d\n", i+1, satellite_locked_prn[i], min, sec, ms);
    }

    total_ms = position_ms;
    total_sec = (total_ms / 1000);

    ms = total_ms % 1000;
    sec = total_sec % 60;
    min = total_sec / 60;

    printf("Get position time: %02d:%02d:%03d\n", min, sec, ms);
    printf("\n");

    printf("%sCH PN  Iprmt  Qprmt State Average%s\n", txt_green_prefix, txt_reset_color);

    /* Send out data on all channels if there's no error */
    for (int ch = 0; ch < N_CHANNELS; ch++)
    {
        channel_state = update_state_character(CH[ch].state);

        channel_bitsync = (CH[ch].bit_sync) ? 'B' : '-';
        channel_framesync = (messages[ch].frame_sync) ? 'F' : '-';

        printf("%2d %2d %6d %6d %c(%c%c)",
               ch,
               CH[ch].prn + 1,
               CH[ch].i_prompt,
               CH[ch].q_prompt,
               channel_state,
               channel_bitsync,
               channel_framesync);
        if (CH[ch].state == CHANNEL_LOCK)
        {
            printf(" %7ld", CH[ch].avg);
        }
        else
            printf("%s", cmd_clear_to_endline);
        printf("\n");
    }
}

/******************************************************************************
 * Display message_thread info
 ******************************************************************************/
static void display_messages(void)
{
    uint8_t channel_state;
    uint8_t channel_bitsync;
    uint8_t channel_framesync;
    unsigned long TOW;
    printf("%s%2s %2s %6s %2s %4s %4s %4s %4s %4s %5s %7s%s\n",
           txt_green_prefix,
           "CH", "PN", "TOW", "SF", "SF1V", "SF2V", "SF3V", "SF4V", "SF5V", "State", "Average",
           txt_reset_color);

    for (int ch = 0; ch < N_CHANNELS; ch++)
    {
        channel_state = update_state_character(CH[ch].state);

        if (CH[ch].bit_sync == 1)
            channel_bitsync = 'B';
        else
            channel_bitsync = '-';

        if (messages[ch].frame_sync == 1)
            channel_framesync = 'F';
        else
            channel_framesync = '-';

        if (messages[ch].subframes[0].valid)
            TOW = messages[ch].subframes[0].TOW;
        else
            TOW = 0;

        printf("%2d %2d %6ld %2d %4lx %4lx %4lx %4lx %4lx %c(%c%c) %7ld\n",
               ch,
               CH[ch].prn,
               TOW,
               messages[ch].subframe + 1,
               messages[ch].subframes[0].valid,
               messages[ch].subframes[1].valid,
               messages[ch].subframes[2].valid,
               messages[ch].subframes[3].valid,
               messages[ch].subframes[4].valid,
               channel_state,
               channel_bitsync,
               channel_framesync,
               CH[ch].avg);
    }
}

static void display_ekfparameter(void)
{
    printf("Satellite Info, position(ECEF), velocity(ECEF)\n");
    printf("receiver position/velocity/time valid = %d\n", receiver_pvt.valid);
    printf("%s%3s %15s %15s %15s %15s %15s %15s %15s %15s%s\n",
           txt_green_prefix,
           "PRN", "x", "y", "z", "vx", "vy", "vz", "rho", "rho_dot",
           txt_reset_color);

    for (int i = 0; i < N_CHANNELS; i++)
    {
        if (i < receiver_pvt.n)
        {
            printf("%3d %15.4f %15.4f %15.4f %15.4f %15.4f %15.4f %15.4f %15.4f",
                   sat_position[i].prn,
                   sat_position[i].x,
                   sat_position[i].y,
                   sat_position[i].z,
                   sat_position[i].vx,
                   sat_position[i].vy,
                   sat_position[i].vz,
                   m_rho[i],
                   m_rho_dot[i]);
        }
        printf("\n");
    }
}

static void display_refine(void)
{
    uint8_t channel_state;
    printf("%s%2s %2s %5s %6s %9s %9s %12s %9s%s\n",
           txt_green_prefix,
           "CH", "PN", "State", "master", "ID_master", "ID_slave0", "carrier_freq", "iteration",
           txt_reset_color);

    for (int ch = 0; ch < N_CHANNELS; ch++)
    {
        channel_state = update_state_character(CH[ch].state);
        printf("%2d %2d %5c %6d %9d %9d %8.2f %9d\n",
               ch, CH[ch].prn + 1, channel_state, CH[ch].is_group_master, CH[ch].arr_group_idx[0], CH[ch].arr_group_idx[1], CH[ch].carrier_freq, CH[ch].iteration);
    }
}

static void display_acquisition()
{
    uint8_t channel_state;
    uint8_t channel_bitsync;
    uint8_t channel_framesync;
    uint16_t halfchip[3];
    
    uint8_t min, sec, ms;
    uint32_t total_sec, total_ms;

    total_ms = uptime_ms;
    total_sec = (total_ms / 1000);

    ms = total_ms % 1000;
    sec = total_sec % 60;
    min = total_sec / 60;
    printf("Execution time:    %02d:%02d:%03d\n", min, sec, ms);

    for(int i=0;i<4;i++) {
        total_ms = satellite_locked_ms[i];
        total_sec = (total_ms / 1000);

        ms = total_ms % 1000;
        sec = total_sec % 60;
        min = total_sec / 60;

        printf("%1d: PRN[%02d],  time: %02d:%02d:%03d\n", i+1, satellite_locked_prn[i], min, sec, ms);
    }

    total_ms = position_ms;
    total_sec = (total_ms / 1000);

    ms = total_ms % 1000;
    sec = total_sec % 60;
    min = total_sec / 60;

    printf("Get position time: %02d:%02d:%03d\n", min, sec, ms);
    printf("\n");

    printf("%sCH PN  Iprmt  Qprmt State carr_freq code_freq correlation correlation_avg codes%s\n", txt_green_prefix, txt_reset_color);

    /* Send out data on all channels if there's no error */
    for (int ch = 0; ch < N_CHANNELS; ch++)
    {
        channel_state = update_state_character(CH[ch].state);

        channel_bitsync = (CH[ch].bit_sync) ? 'B' : '-';
        channel_framesync = (messages[ch].frame_sync) ? 'F' : '-';

        printf("%2d %2d %6d %6d %c(%c%c)",
               ch,
               CH[ch].prn + 1,
               CH[ch].i_prompt,
               CH[ch].q_prompt,
               channel_state,
               channel_bitsync,
               channel_framesync);
        halfchip[ch] = ((ch_block->channels[ch].code_val & 0x1FFC00) >> 10);

        printf(" %+9.2f %+9.2f %11.2f %15.2f %4d\n", CARRIERNCO2DOPPLERFREQ(CH[ch].carrier_freq_nco), CODENCO2CODEDOPPLERFREQ(CH[ch].code_freq),
               CH[ch].correlation, CH[ch].correlation_avg,
               halfchip[ch]);
    }
    printf("\n");

    printf("parallel search calculated freq[Hz] = %7.2f, code phase[half-chip] = %4d\n", CH[0].debug_freq, CH[0].debug_code_phase_fft);
}

static void display_command_info()
{
    printf("\n\n");
    printf("Press Key:\n");
    printf("(t)racking, (m)essages, (e)phemeris, pseudo(r)ange, (p)osition, e(k)fpa, (x)refine, (o)utput\n");
}

void display_startup_info()
{
    printf("if you see this message,\n");
    printf("please ensure that %sthe FPGA device is programmed before flashing C program%s\n", bg_blue_prefix, txt_reset_color);
}

void display_thread(void const *argument)
{
    static uint8_t current_display = DISPLAY_NONE;
    static uint8_t current_ephemeris_mode = 0;
    while (1)
    {
        osThreadFlagsWait(FLAG_UPDATE, osFlagsWaitAny, osWaitForever);
        if ((current_display != display_command) ||
            (current_ephemeris_mode != ephemeris_mode))
        {
            current_display = display_command;
            current_ephemeris_mode = ephemeris_mode;
            printf("%s%s", cmd_clear_screen, cmd_cursor_hide);
        }
        printf("%s", cmd_cursor_home);
        switch (current_display)
        {
            case DISPLAY_TRACKING:
                display_tracking();
                break;
            case DISPLAY_MESSAGES:
                display_messages();
                break;
            case DISPLAY_EPHEMERIS:
                display_ephemeris();
                break;
            case DISPLAY_PSEUDORANGE:
                display_pseudorange();
                break;
            case DISPLAY_POSITION:
                display_position();
                break;
            case DISPLAY_EKFPa:
                display_ekfparameter();
                break;
            case DISPLAY_REFINE:
                display_refine();
                break;
            case DISPLAY_ACQUISITION:
                display_acquisition();
                break;
        }
        display_command_info();
    }
}

void set_display_command()
{
    char c = stdin_getchar();
    switch (c)
    {
    case 't':
        display_command = DISPLAY_TRACKING;
        break;
    case 'm':
        display_command = DISPLAY_MESSAGES;
        break;
    case 'e':
        if (display_command == DISPLAY_EPHEMERIS)
            ephemeris_mode = (ephemeris_mode == 5) ? 0 : (ephemeris_mode + 1);
        else
            display_command = DISPLAY_EPHEMERIS;
        break;
    case 'r':
        display_command = DISPLAY_PSEUDORANGE;
        break;
    case 'p':
        display_command = DISPLAY_POSITION;
        break;
    case 'k':
        display_command = DISPLAY_EKFPa;
        break;
    case 'x':
        display_command = DISPLAY_REFINE;
        break;
    case 'o':
        display_command = DISPLAY_ACQUISITION;
        break;
    default:
        break;
    }
}
