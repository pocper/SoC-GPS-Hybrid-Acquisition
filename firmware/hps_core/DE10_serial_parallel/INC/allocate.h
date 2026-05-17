// allocate.h: Header file for the allocate.c file
// Copyright (C) 2005  Andrew Greenberg
// Distributed under the GNU GENERAL PUBLIC LICENSE (GPL) Version 2 (June 1991).
// See the "COPYING" file distributed with this software for more information.

#ifndef __ALLOCATE_H
#define __ALLOCATE_H
/*******************************************************************************
 * Definitions
 ******************************************************************************/

// NONE

/*******************************************************************************
 * Declarations
 ******************************************************************************/
void allocate_thread(void const *argument);
void initialize_allocation(void);
void initialize_channel(unsigned short ch, unsigned short prn);


#endif // __ALLOCATE_H
