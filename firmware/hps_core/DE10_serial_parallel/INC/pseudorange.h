// pseudorange.h: Header file for the pseudorange.c file
// Copyright (C) 2005  Andrew Greenberg
// Distributed under the GNU GENERAL PUBLIC LICENSE (GPL) Version 2 (June 1991).
// See the "COPYING" file distributed with this software for more information.

#ifndef __PSEUDORANGE_H
#define __PSEUDORANGE_H

#include "time.h"
#include "namuru.h"

/*******************************************************************************
 * Definitions
 ******************************************************************************/

// NONE?

/*******************************************************************************
 * Declarations
 ******************************************************************************/

typedef struct
{
    unsigned short  prn;
    unsigned short  valid;
    double          sat_time;    // [sec], Time of transmission
    double          range;       // [m], the distance between statellite and receiver
    double          delta_range; // [m], the doppler shift distance
    // Debug
    unsigned long   bit_time;
    unsigned short  epoch_bits;
    unsigned short  epoch_ms;
} pseudorange_t;

void clear_pseudoranges(void);
void calculate_pseudorange(unsigned short ch);
/*******************************************************************************
 * Externs
 ******************************************************************************/
extern pseudorange_t pr[N_CHANNELS];
extern gpstime_t     pr_time;

#endif // __PSEUDORANGE_H
