/******************************************************************************
 *                                                                             *
 * License Agreement                                                           *
 *                                                                             *
 * Copyright (c) 2003 Altera Corporation, San Jose, California, USA.           *
 * All rights reserved.                                                        *
 *                                                                             *
 * Permission is hereby granted, free of charge, to any person obtaining a     *
 * copy of this software and associated documentation files (the "Software"),  *
 * to deal in the Software without restriction, including without limitation   *
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,    *
 * and/or sell copies of the Software, and to permit persons to whom the       *
 * Software is furnished to do so, subject to the following conditions:        *
 *                                                                             *
 * The above copyright notice and this permission notice shall be included in  *
 * all copies or substantial portions of the Software.                         *
 *                                                                             *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  *
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,    *
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE *
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER      *
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING     *
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER         *
 * DEALINGS IN THE SOFTWARE.                                                   *
 *                                                                             *
 * This agreement shall be governed in all respects by the laws of the State   *
 * of California and by the laws of the United States of America.              *
 *                                                                             *
 ******************************************************************************/
// #include <stdio.h>
// #include <unistd.h>
// #include <stdlib.h>

#include "altera_avalon_spi_regs.h"
#include "altera_avalon_spi.h"

#include "RTE_Components.h"
#include CMSIS_device_header

/* This is a very simple routine which performs one spi master transaction.
 * It would be possible to implement a more efficient version using interrupts
 * and sleeping threads but this is probably not worthwhile initially.
 */

typedef struct 
{
    __IM  uint32_t rxdata;
    __OM  uint32_t txdata;
    __IOM uint32_t status;
    __IOM uint32_t control;
    RESERVED(0, uint32_t)
    __IOM uint32_t slaveselect;
    __IOM uint32_t eop_value;
}altera_avalon_spi_t;


void alt_avalon_spi_write_word( uint32_t base, uint32_t slave,
                                uint32_t write_data, uint32_t flags)
{
    altera_avalon_spi_t *spi = (altera_avalon_spi_t *) base;
    
    /* Warning: this function is not currently safe if called in a multi-threaded
     * environment, something above must perform locking to make it safe if more
     * than one thread intends to use it.
     */
    spi->slaveselect = (1<<slave);

    /* Set the SSO bit (force chipselect) only if the toggle flag is not set */
    if ((flags & ALT_AVALON_SPI_COMMAND_TOGGLE_SS_N) == 0)
        spi->control = ALTERA_AVALON_SPI_CONTROL_SSO_MSK;

    /* Keep clocking until all the data has been processed. */
    while((spi->status & ALTERA_AVALON_SPI_STATUS_TRDY_MSK) == 0);

    spi->txdata = write_data;

    /* Wait until the interface has finished transmitting */
    while((spi->status & ALTERA_AVALON_SPI_STATUS_TMT_MSK) == 0);

    /* Clear SSO (release chipselect) unless the caller is going to
     * keep using this chip
     */
    if ((flags & ALT_AVALON_SPI_COMMAND_MERGE) == 0)
        spi->control = 0;
}
