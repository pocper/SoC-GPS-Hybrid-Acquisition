#ifndef __NAMURU_H
#define __NAMURU_H
#include <stdint.h>
#include "hps_0.h"
#include "socal/hps.h"

// channels
#define N_CHANNELS 13

// System Architecture
#define ACQ_MODE_SERIAL 0  // Serial Search
#define ACQ_MODE_HYBRID 1  // Parallel Code Phase Search + Serial Search
#define ACQ_MODE_SYSTEM ACQ_MODE_SERIAL

#define __I volatile const            /*!< \brief Defines 'read only' permissions */
#define __O volatile                  /*!< \brief Defines 'write only' permissions */
#define __IO volatile                 /*!< \brief Defines 'read / write' permissions */
#define RESERVED(N, T) T RESERVED##N; // placeholder struct members used for "reserved" areas

// epoch_load[4:0]  cycle_count := the number of ms within a 20ms period (0 to 19)
// epoch_load[10:5] bit_count   := the number of 20ms periods (0 to 49)
typedef struct
{
    __O uint32_t prn_key;
    __O uint32_t carr_nco;
    __O uint32_t code_nco;
    __O uint32_t code_slew;
    __I uint32_t i_early;
    __I uint32_t q_early;
    __I uint32_t i_prompt;
    __I uint32_t q_prompt;
    __I uint32_t i_late;
    __I uint32_t q_late;
    __I uint32_t carrier_val;
    __I uint32_t code_val;
    __I uint32_t epoch;
    __I uint32_t epoch_check;
    __O uint32_t epoch_load;
    __O uint32_t chip_select;
} channel_t;

typedef struct
{
    channel_t channels[N_CHANNELS];
#if (13 - N_CHANNELS) > 0
    RESERVED(0 [13 - N_CHANNELS], channel_t)
#endif
} ch_block_t;

typedef struct
{
    __IO uint32_t set_serial_ch_0;
    __IO uint32_t set_serial_ch_1;
    __I  uint32_t ch0_hc_count2_start;
    __I  uint32_t ch0_hc_count3_start;
    __I  uint32_t ch0_hc_count2_end;
    __I  uint32_t ch0_hc_count3_end;
    __I  uint32_t ch0_hc_count2;
    __I  uint32_t ch0_hc_count3;
    __I  uint32_t ch1_hc_count3_start;
    __I  uint32_t ch1_hc_count3_end;
    __I  uint32_t ch1_hc_count3;
    __I  uint32_t ch2_hc_count3_start;
    __I  uint32_t ch2_hc_count3_end;
    __I  uint32_t ch2_hc_count3;
    RESERVED(0 [2], uint32_t)
} code_delay_block_t;

typedef struct
{
    __I uint32_t status;
    __I uint32_t new_data;
    __I uint32_t tic_count;
    __I uint32_t accum_count;
    RESERVED(0 [12], uint32_t)
} status_block_t;

typedef struct
{
    __O uint32_t reset;
    __O uint32_t prog_tic;
    __O uint32_t prog_accum_int;
    RESERVED(0 [13], uint32_t)
} control_block_t;

typedef struct
{
    ch_block_t channels;
    code_delay_block_t code_delay;
    status_block_t status;
    control_block_t control;
} gps_baseband_t;

#define GPS_BASEBAND_BASE (ALT_LWFPGASLVS_OFST + GPS_BASEBAND_0_BASE)
#define ch_block (&(((gps_baseband_t *)GPS_BASEBAND_BASE)->channels))
#define code_delay_block (&(((gps_baseband_t *)GPS_BASEBAND_BASE)->code_delay))
#define status_block (&(((gps_baseband_t *)GPS_BASEBAND_BASE)->status))
#define control_block (&(((gps_baseband_t *)GPS_BASEBAND_BASE)->control))

#endif
