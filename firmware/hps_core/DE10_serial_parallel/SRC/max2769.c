#include "max2769.h"

void max2769_init(){
    uint8_t addr_4;
    uint32_t data_27, data_32;

    // MAX2769
    // 1. Enable Q-Channel PGA
    addr_4 = 0x02;
    data_27 = 0xEAFF1DC | (1<<12); // PGAQEN = 1
    data_32 = (data_27 << 4) | addr_4; // D = 0x8550288 (32-bits)
    alt_avalon_spi_write_word(SPI_BASE, 0x00, data_32, 0);

    // 2. Enable IQ Signal
    addr_4 = 0x01;
    data_27 = 0x0550288 | (1<<27); // CHIPEN = 1
    data_32 = (data_27 << 4) | addr_4; // D = 0x8550288 (32-bits)
    alt_avalon_spi_write_word(SPI_BASE, 0x00, data_32, 0);
}
