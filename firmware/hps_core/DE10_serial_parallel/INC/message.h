// message.h: Header file for the message.c file
// Copyright (C) 2005  Andrew Greenberg
// Distributed under the GNU GENERAL PUBLIC LICENSE (GPL) Version 2 (June 1991).
// See the "COPYING" file distributed with this software for more information.

#ifndef __MESSAGE_H
#define __MESSAGE_H

#include <stdint.h>
#include "constants.h"
#include "namuru.h"
/*******************************************************************************
 * Definitions
 ******************************************************************************/

// NONE
 
/*******************************************************************************
 * Declarations
 ******************************************************************************/

typedef struct{
    uint32_t   word[10];
    unsigned long       TOW;            // "Truncated time Of Week"
                                        // That is, time since beginning of the
                                        // week in 6 second (subframe) increments
                                        // (0 ~ 100,799) * 6 [sec] = second of a week
    unsigned long       valid;          // 10 bits of word validity flags;
                                        // all good = 0x3ff 
 } subframe_t;    
 
typedef struct {
    unsigned short      prn;            // satellite prn
    unsigned short      frame_sync;
    unsigned short      set_epoch_flag; // only set the epoch counter once
                                        // per sync on a channel

    unsigned short      data_inverted;  // Used to indicate if data inversion is applied,
                                        // tested by ensuring HOW bits 0 and 1 are zero as per GPS specification
    unsigned short      bitcount;       // # of bits in the current word
    unsigned short      wordcount;      // # of words in the subframe so far
    unsigned long       wordbuf0;       // Current word (2+30 format)
    unsigned long       wordbuf1;       // previous word (2+30 format)
    
    unsigned short      subframe;       // Current subframe(0~4)
    subframe_t          subframes[5];   // Array of 5 subframes (1 frame), only 24-bits data
} message_t;
 
void message_thread(void const *argument);
void clear_messages(unsigned short ch);

/*******************************************************************************
 * Externs
 ******************************************************************************/

extern message_t  messages[N_CHANNELS];

#endif // __MESSAGE_H
