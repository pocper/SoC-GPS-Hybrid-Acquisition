#ifndef __PARALLEL_SEARCH_H
#define __PARALLEL_SEARCH_H

#include "RTE_Components.h"
#include CMSIS_device_header
#include "hps_0.h"
#include "socal/hps.h"

typedef struct
{                                 // HPS  <-> FPGA
    __IOM uint32_t ctrl;          //      <-> 0x00
    __IM uint32_t state;          //      <-> 0x01
    __OM uint32_t irq_ack;        //      <-> 0x02
    __IOM uint32_t set_mode;      //      <-> 0x03
    __IOM uint32_t set_condition; //      <-> 0x04
    RESERVED(0 [11], uint32_t)    //      <-> 0x05 ~ 0x0f
    // -----------------------------------------------------------------------
    __IOM uint32_t table_CDC_in_address; //      <-> 0x10
    __IM uint32_t table_CDC_out_data;    //      <-> 0x11
    RESERVED(1 [14], uint32_t)           //      <-> 0x12 ~ 0x1f
    // -----------------------------------------------------------------------
    __IOM uint32_t table_in_CACode;          //      <-> 0x20
    __IOM uint32_t table_in_shift;           //      <-> 0x21
    __IM uint32_t table_out_correlation_avg; //      <-> 0x22
    __IM uint32_t table_out_correlation;     //      <-> 0x23
    __IM uint32_t table_out_chip_offset;     //      <-> 0x24
    __IM uint32_t table_max_valid;           //      <-> 0x25
    __IOM uint32_t table_max_in_CACode;      //      <-> 0x26
    __IM uint32_t table_max_out_shift;       //      <-> 0x27
    RESERVED(2 [8], uint32_t)                //      <-> 0x28 ~ 0x2f
    // -----------------------------------------------------------------------
    __IOM uint32_t set_CACode_id;    //      <-> 0x30
    __IOM uint32_t set_shift_center; //      <-> 0x31
    __IOM uint32_t set_shift_width;  //      <-> 0x32
    RESERVED(3 [13], uint32_t)       //      <-> 0x33 ~ 0x3f
    // -----------------------------------------------------------------------
    __IOM uint32_t table_data_in_index;       //      <-> 0x40
    __IM uint32_t table_data_out_CACode;      //      <-> 0x41
    __IM uint32_t table_data_out_shift;       //      <-> 0x42
    __IM uint32_t table_data_out_correlation; //      <-> 0x43
    __OM uint32_t table_data_read_ack;        //      <-> 0x44
    RESERVED(4 [11], uint32_t)                //      <-> 0x45 ~ 0x4f
    // -----------------------------------------------------------------------
    __IM uint32_t debug_CACode;                    //      <-> 0x50
    __IM uint32_t debug_shift_unsigned;            //      <-> 0x51
    __IM uint32_t debug_shift_end_unsigned;        //      <-> 0x52
    __IM uint32_t debug_cnt_data;                  //      <-> 0x53
    __IM uint32_t debug_state_ft_input;            //      <-> 0x54
    __IM uint32_t debug_cnt_FTIn;                  //      <-> 0x55
    __IM uint32_t debug_state_conv;                //      <-> 0x56
    __IM uint32_t debug_state_CACode_generator;    //      <-> 0x57
    __IM uint32_t debug_cnt_data_CACode_generator; //      <-> 0x58
    RESERVED(5 [7], uint32_t)                      //      <-> 0x59 ~ 0x5f
} parallel_search_t;
#define Parallel_Search_BASE (ALT_LWFPGASLVS_OFST + PARALLEL_SEARCH_0_BASE)
#define Parallel_Search ((parallel_search_t *)Parallel_Search_BASE)


#define FREQ_RESOLUTION 500 // unit: Hz
#define REFINE_USE_SERIAL_CH 2

typedef struct
{
    uint8_t valid;
    uint8_t prn;
    uint8_t serial_ch[REFINE_USE_SERIAL_CH];
    uint16_t code_phase_fft; // unit:half-chip
    int16_t carrier_frequency; // unit:Hz
    float correlation;
    float correlation_avg;
} parallel_t;

typedef enum
{
    mode_all,
    mode_single_CACode_multi_shift,
    mode_debug
} mode_t;

typedef enum
{
    condition_3max,
    condition_max
} condition_t;


void parallel_search_thread(void const *argument);
void parallel_search_debug_thread(void const *argument);
void parallel_search_IRQ(void);
void parallel_search_start_single_satellite(uint8_t CACode, int8_t shift_center, uint8_t shift_width, uint8_t condition);
void parallel_search_start_all_satellite(uint8_t condition);
void parallel_search_start_all_satellite_debug(void);

#endif
