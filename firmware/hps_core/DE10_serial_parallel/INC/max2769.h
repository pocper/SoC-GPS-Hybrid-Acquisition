#include "RTE_Components.h"
#include CMSIS_device_header
#include "hps_0.h"
#include "socal/hps.h"
#include "altera_avalon_spi.h" // SPI(3-wire)  Controller

typedef struct
{                                                    // HPS  <-> FPGA
    __IOM uint32_t IDLE_B;                           //      <-> 0x00
    __IOM uint32_t SHDN_B;                           //      <-> 0x01
    __IM  uint32_t is_frontend_connected;            //      <-> 0x02
    __IM  uint32_t clk_frontend_locked;              //      <-> 0x03
} max2769_t;
#define MAX2769_BASE (ALT_LWFPGASLVS_OFST + MAX2769_0_BASE)
#define MAX2769 ((max2769_t*) MAX2769_BASE)

#define SPI_BASE (ALT_LWFPGASLVS_OFST + SPI_0_BASE)

void max2769_init(void);
