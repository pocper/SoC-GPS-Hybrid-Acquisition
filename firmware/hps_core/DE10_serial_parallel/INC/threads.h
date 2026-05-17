// allocate.h: Header file for the allocate.c file
// Copyright (C) 2005  Andrew Greenberg
// Distributed under the GNU GENERAL PUBLIC LICENSE (GPL) Version 2 (June 1991).
// See the "COPYING" file distributed with this software for more information.

#ifndef __THREADS_H
#define __THREADS_H

#include "cmsis_os2.h"

/*******************************************************************************
 * Definitions
 ******************************************************************************/

// Note: Thread flags are thread-specific and independent
#define FLAG_UPDATE (0x01U << 0)
#define FLAG_START  (0x01U << 1)
#define FLAG_DONE   (0x01U << 2)

/*******************************************************************************
 * Declarations
 ******************************************************************************/

// NONE

/*******************************************************************************
 * Externs
 ******************************************************************************/

extern osThreadId_t allocate_thread_id;
extern osThreadId_t display_thread_id;
extern osThreadId_t message_thread_id;
extern osThreadId_t measure_thread_id;
extern osThreadId_t parallel_search_thread_id;
extern osThreadId_t tick_capture_thread_id;
extern osThreadId_t parallel_search_debug_thread_id;

#endif // __THREADS_H
