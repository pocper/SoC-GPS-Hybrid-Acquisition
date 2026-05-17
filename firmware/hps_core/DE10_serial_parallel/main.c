#include "cmsis_os2.h"
#include "RTE_Components.h"
#include CMSIS_device_header

#include "max2769.h"
#include "parallel_search.h"
#include "tracking.h"
#include "allocate.h"
#include "namuru.h"
#include "display.h"
#include "message.h"
#include "ephemeris.h"
#include "measure.h"
#include "position.h"
#include "uart.h"
#include "irq_ctrl.h" // Generic Interrupt Controller
#include <stdio.h>
#include <stdint.h>

osThreadId_t allocate_thread_id;
osThreadId_t display_thread_id;
osThreadId_t message_thread_id;
osThreadId_t measure_thread_id;
osThreadId_t tick_capture_thread_id;
osThreadId_t parallel_search_thread_id;
osThreadId_t parallel_search_debug_thread_id;


const osThreadAttr_t allocate_thread_attr = {
    .name = "allocate_thread",
    .priority = osPriorityAboveNormal,
    .stack_size = 2048};

const osThreadAttr_t display_thread_attr = {
    .name = "display_thread",
     .priority = osPriorityNormal,
    .stack_size = 2048};

const osThreadAttr_t message_thread_attr = {
    .name = "message_thread",
    .priority = osPriorityHigh,
    .stack_size = 2048};

const osThreadAttr_t measure_thread_attr = {
    .name = "measure_thread",
    .priority = osPriorityRealtime,
    .stack_size = 4096};

const osThreadAttr_t parallel_search_thread_attr = {
    .name = "parallel_search_thread",
    .priority = osPriorityAboveNormal,
    .stack_size = 2048};

const osThreadAttr_t tick_capture_thread_attr = {
    .name = "tick_capture_thread",
    .priority = osPriorityHigh,
    .stack_size = 2048};

void app_main()
{
    // Initialize frontend
    max2769_init();

    // Enable UART0 RX Interrupt
    uart0_init();

    // Display warning info - if you only program ARM CPU but not FPGA device
    display_startup_info();

#if (ACQ_MODE_SYSTEM == ACQ_MODE_SERIAL)
    initialize_allocation();
#endif
    control_block->prog_tic = 4999999;     // 0.1 [s]  update FPGA system
    control_block->prog_accum_int = 24999; // 0.5 [ms] update accumulator

    // Setup Interrupt Handler - received interrupt from FPGA
    IRQ_SetHandler(FPGA_IRQ0, tracking_IRQ); // Set level-sensitive (and N-N model)
    IRQ_SetHandler(FPGA_IRQ1, parallel_search_IRQ); // Set level-sensitive (and N-N model)
    // Setup Interrupt Handler - received interrupt from keyboard input (UART0 RX)
    IRQ_SetHandler(UART0_IRQ, set_display_command); // Set level-sensitive (and N-N model)
    
    IRQ_Enable(FPGA_IRQ0);
    IRQ_Enable(FPGA_IRQ1);
    IRQ_Enable(UART0_IRQ);
}

int main(void)
{
    // MPU Clock: 925 MHz (Configured by Preloader)
    // Private Timer Clock (mpu_periph_clk): 231.250 MHz (MPU Clock divided by 4)
    // Reference: Cyclone V Hard Processor System Technical Reference Manual
    SystemCoreClockUpdate();
    osKernelInitialize();
    allocate_thread_id = osThreadNew((osThreadFunc_t)allocate_thread, NULL, &allocate_thread_attr);
    display_thread_id  = osThreadNew((osThreadFunc_t)display_thread, NULL, &display_thread_attr);
    message_thread_id  = osThreadNew((osThreadFunc_t)message_thread, NULL, &message_thread_attr);
    measure_thread_id  = osThreadNew((osThreadFunc_t)measure_thread, NULL, &measure_thread_attr);
    tick_capture_thread_id = osThreadNew((osThreadFunc_t)tick_capture_thread, NULL, &tick_capture_thread_attr);
#if (ACQ_MODE_SYSTEM == ACQ_MODE_HYBRID)
    parallel_search_thread_id = osThreadNew((osThreadFunc_t)parallel_search_thread, NULL, &parallel_search_thread_attr);
    // parallel_search_debug_thread_id = osThreadNew((osThreadFunc_t)parallel_search_debug_thread, NULL, NULL);
#endif
    osThreadNew((osThreadFunc_t)app_main, NULL, NULL);
    osKernelStart();

    while (1)
        ;
}
