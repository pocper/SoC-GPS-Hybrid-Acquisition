/*
** Copyright (c) 2011-2017 Arm Limited (or its affiliates). All rights reserved.
** Use, modification and redistribution of this file is subject to your possession of a
** valid End User License Agreement for the Arm Product of which these examples are part of 
** and your compliance with all applicable terms and conditions of such licence agreement.
*/

/* Simple polled UART driver for Cortex-A9 VE FVP model */

// Ensure uart_init() is called before any other functions in this file.
#include "uart.h"
#include <stdint.h>
#include "socal/hps.h"
#include "socal/alt_uart.h"


#define UART0_IO  (volatile unsigned char *) ALT_UART0_RBR_THR_DLL_ADDR
#define UART0_IER (volatile unsigned char *) ALT_UART0_IER_DLH_ADDR
#define UART0_LSR (volatile unsigned char *) ALT_UART0_LSR_ADDR

void uart0_init(void)
{
    // Enable RX Interrupt
    *UART0_IER |= 0x1;
}

void stdout_putchar(char c)
{
	while (!ALT_UART_LSR_THRE_GET(*UART0_LSR))
		;	// Wait for UART TX to become free. Note that FIFOs are not being used here
	*UART0_IO = c;
}

char stdin_getchar(void)
{
	while (!ALT_UART_LSR_DR_GET(*UART0_LSR))
		;	// Retrieve characters from UART0
	return *UART0_IO;
}
