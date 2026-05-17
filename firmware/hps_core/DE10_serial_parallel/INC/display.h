// display.h: Header file for the display.c file
// Copyright (C) 2005  Andrew Greenberg
// Distributed under the GNU GENERAL PUBLIC LICENSE (GPL) Version 2 (June 1991).
// See the "COPYING" file distributed with this software for more information.

#ifndef __DISPLAY_H
#define __DISPLAY_H

typedef enum {
    DISPLAY_NONE,
    DISPLAY_TRACKING,
    DISPLAY_MESSAGES,
    DISPLAY_EPHEMERIS,
    DISPLAY_PSEUDORANGE,
    DISPLAY_POSITION,
	DISPLAY_EKFPa,
    DISPLAY_REFINE,
    DISPLAY_ACQUISITION
} display_t;

void set_display_command(void);
void display_startup_info(void);
void display_thread(void const *argument);

#endif // __DISPLAY_H
