// measure.h: Header file for the measure.c file
// Copyright (C) 2005  Andrew Greenberg
// Distributed under the GNU GENERAL PUBLIC LICENSE (GPL) Version 2 (June 1991).
// See the "COPYING" file distributed with this software for more information.

#ifndef __MEASURE_H
#define __MEASURE_H

#include "constants.h"
#include "time.h"
#include "namuru.h"
#include "DOP.h"

/*******************************************************************************
 * Definitions
 ******************************************************************************/

// NONE
 
/*******************************************************************************
 * Declarations
 ******************************************************************************/

typedef struct // Raw data
{
    unsigned short valid;      // This channel's measurement is valid
    unsigned short prn;

    unsigned short epoch_codes; // cycle count(0~19 [ms])
    unsigned short epoch_bits;  // bit count (0~49 of 20[ms])
    
    unsigned short code_phase;
    unsigned short code_nco_phase;
    
    unsigned long  carrier_cycles;

    unsigned long  meas_bit_time; // copy of Time of Week(TOW)

} measurement_t;

void measure_thread(void const *argument);

/*******************************************************************************
 * Externs
 ******************************************************************************/
extern unsigned int channels_ready;
extern uint8_t satnum;
extern measurement_t meas[N_CHANNELS];
extern DOP_t receiver_DOP;

#endif // __MEASURE_H
