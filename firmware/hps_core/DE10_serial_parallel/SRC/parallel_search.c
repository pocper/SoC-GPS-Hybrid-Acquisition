#include "parallel_search.h"
#include "cmsis_os2.h"
#include <stdio.h>

#include "threads.h"
#include "tracking.h"
#include "allocate.h"
#include <assert.h>

#define FLAG_IRQ_DONE 0x01

parallel_t parallel;

// Debug only
volatile uint32_t correlation[32][41][4096] __attribute__((section("correlation_section")));
volatile uint32_t data_CDC[4092] __attribute__((section("data_CDC_section")));
void parallel_search_IRQ()
{
    Parallel_Search->irq_ack = 0x1;
    osThreadFlagsSet(parallel_search_thread_id, FLAG_IRQ_DONE);
    osThreadFlagsSet(parallel_search_debug_thread_id, FLAG_IRQ_DONE);
}

void parallel_search_thread(void const *argument)
{
    uint32_t CACode_valid;
    int8_t max_shift;
    float uint32_to_float32;
    while (1)
    {
        // 1. Wait allocate thread's notification to work
        osThreadFlagsWait(FLAG_START, osFlagsWaitAny, osWaitForever);
        parallel.valid = 1;

        // 2. start parallel search's hardware
        parallel_search_start_single_satellite(parallel.prn, 0, 20, condition_3max);
        // parallel_search_start_single_satellite(parallel.prn, 0, 20, condition_max);

        // 3. wait parallel search's hardware done
        osThreadFlagsWait(FLAG_IRQ_DONE, osFlagsWaitAny, osWaitForever);

        // 4. Read parallel search satisfy the condition
        CACode_valid = Parallel_Search->table_max_valid;
        // TODO: 只有在single satellite mode 才會長這樣
        // Check condition
        if (!((CACode_valid & (1 << parallel.prn)) >> parallel.prn))
        {
            parallel.valid = 0;
        }
        // 5. Get the result
        // Get carrier frequency of the peak correlation
        Parallel_Search->table_max_in_CACode = parallel.prn;
        max_shift = Parallel_Search->table_max_out_shift;
        max_shift = (int8_t)(max_shift << 2) >> 2; // sign-extension

        // Get the correlation peak and its corresponding frequency and code delay index
        Parallel_Search->table_in_CACode = parallel.prn;
        Parallel_Search->table_in_shift = max_shift;

        // Read data of table_correlation, table_idx_halfchip
        uint32_to_float32 = *(float *)&Parallel_Search->table_out_correlation;
        parallel.correlation = uint32_to_float32;
        uint32_to_float32 = *(float *)&Parallel_Search->table_out_correlation_avg;
        parallel.correlation_avg = uint32_to_float32;

        // Check threshold
        if (parallel.correlation < parallel.correlation_avg * 1.5) {
            parallel.valid = 0;
        }

        parallel.code_phase_fft = Parallel_Search->table_out_chip_offset;
        parallel.carrier_frequency = (int16_t)(max_shift)*FREQ_RESOLUTION;

        // 6. Notify allocate thread to continue
        osThreadFlagsSet(allocate_thread_id, FLAG_DONE);
    }
}

void parallel_search_debug_thread(void const *argument)
{
    uint8_t CACode = 0;
    int8_t shift;
    uint8_t shift_unsigned;
    char c = 'a';
    float uint32_to_float32;
    while (1)
    {
        printf("\033[2J\033[H");
        printf("Start parallel search debug mode ---\n");
        parallel_search_start_all_satellite_debug();
        while (1)
        {
            osThreadFlagsWait(FLAG_IRQ_DONE, osFlagsWaitAny, osWaitForever);

            CACode = Parallel_Search->table_data_out_CACode;
            shift = Parallel_Search->table_data_out_shift;
            if (shift & 0x20)
                shift |= 0xC0;
            shift_unsigned = shift + 20;
            printf("Received CACode = %2d, shift = %+3d\n", CACode, shift);

            for (int i = 0; i < 4096; i++)
            {
                Parallel_Search->table_data_in_index = i;
                correlation[CACode][shift_unsigned][i] = Parallel_Search->table_data_out_correlation;
            }
            Parallel_Search->table_data_read_ack = 0x1;

            if (CACode == 31 && shift == 20)
                break;
        }

        printf("Reading CDC data...\n");
        for (int i = 0; i < 4092; i++)
        {
            Parallel_Search->table_CDC_in_address = i;
            data_CDC[i] = Parallel_Search->table_CDC_out_data;
        }
        printf("Done\n\n");

        // Only For Test
        printf("TEST\n");
        CACode = 0;
        Parallel_Search->table_max_in_CACode = CACode;
        shift = Parallel_Search->table_max_out_shift;
        shift = (int8_t)(shift << 2) >> 2; // sign-extension
        Parallel_Search->table_in_CACode = CACode;
        Parallel_Search->table_in_shift = shift;
        uint32_to_float32 = *(float *)&Parallel_Search->table_out_correlation;

        // Read data of table_correlation, table_idx_halfchip
        printf("shift = %d\n", shift);
        printf("CACode = %2d, carrier_frequency = %+7.2f [Hz], Code Delay = %4d [half-chip], correlation = %e\n", CACode, (float)(shift)*FREQ_RESOLUTION,
               Parallel_Search->table_out_chip_offset, uint32_to_float32);

        do
        {
            printf("(c)ontinue\n");
            printf("Enter character > ");
            c = getchar();
            printf("%c\n", c);
        } while (c != 'c');
    }
}

void parallel_search_start_single_satellite(uint8_t CACode, int8_t shift_center, uint8_t shift_width, uint8_t condition)
{
    Parallel_Search->set_mode = mode_single_CACode_multi_shift;
    Parallel_Search->set_CACode_id = CACode;
    Parallel_Search->set_shift_center = shift_center;
    Parallel_Search->set_shift_width = shift_width;
    Parallel_Search->set_condition = condition;
    Parallel_Search->ctrl = 1;
}

void parallel_search_start_all_satellite(uint8_t condition)
{
    Parallel_Search->set_mode = mode_all;
    Parallel_Search->set_condition = condition;
    Parallel_Search->ctrl = 1;
}

void parallel_search_start_all_satellite_debug()
{
    Parallel_Search->set_mode = mode_debug;
    Parallel_Search->set_condition = condition_3max; // We don't need to this to run debug mode
    Parallel_Search->ctrl = 1;
}
