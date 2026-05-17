#**************************************************************
# This .sdc file is created by Terasic Tool.
# Users are recommended to modify this file to match users logic.
#**************************************************************

#**************************************************************
# Create Clock
#**************************************************************
create_clock -name clk_50M -period 20 [get_ports FPGA_CLK1_50]

# for enhancing USB BlasterII to be reliable, 25MHz
create_clock -name {altera_reserved_tck} -period 40 {altera_reserved_tck}
set_input_delay -clock altera_reserved_tck -clock_fall 3 [get_ports altera_reserved_tdi]
set_input_delay -clock altera_reserved_tck -clock_fall 3 [get_ports altera_reserved_tms]
set_output_delay -clock altera_reserved_tck 3 [get_ports altera_reserved_tdo]

# Front-End, clock, 16.368MHz
# Unbuffered
# create_clock -name clk_frontend -period 61.094 [get_ports GPIO_1[2]]
# set_input_delay -clock clk_frontend -min 0      [get_ports {GPIO_1[3] GPIO_1[5] GPIO_1[7] GPIO_1[9]}];  # hold time check 
# set_input_delay -clock clk_frontend -max 30.254 [get_ports {GPIO_1[3] GPIO_1[5] GPIO_1[7] GPIO_1[9]}];  # set_up time check
# set_false_path -from [get_ports GPIO_1[8]];  # clk_frontend PLL locked 

# Buffered
create_clock -name clk_frontend -period 61.094 [get_ports GPIO_1[19]]
set_input_delay -clock clk_frontend -min 0      [get_ports {GPIO_1[11] GPIO_1[13] GPIO_1[15] GPIO_1[17]}];  # hold time check 
set_input_delay -clock clk_frontend -max 30.254 [get_ports {GPIO_1[11] GPIO_1[13] GPIO_1[15] GPIO_1[17]}];  # set_up time check 

# Front-End, signal
set_false_path -from [get_ports GPIO_1[4]];  # connection_check
set_false_path -from [get_ports GPIO_1[18]]; # clk_frontend PLL locked
set_false_path -to [get_ports GPIO_1[6]];  # IDLE_B
set_false_path -to [get_ports GPIO_1[10]]; # SHDN_B


# Front-End, Serial Interface clock, 50kHz
set_false_path -to [get_ports GPIO_1[14]]; # CS_B
create_generated_clock -name sclk_50k -source [get_ports FPGA_CLK1_50] -divide_by 1000 [get_registers {soc_system:u0|soc_system_spi_0:spi_0|SCLK_reg}]
set_output_delay -clock sclk_50k -max  5 [get_ports {GPIO_1[12] GPIO_1[16]}]; # SCLK, SDATA
set_output_delay -clock sclk_50k -min  0 [get_ports {GPIO_1[12] GPIO_1[16]}]; # SCLK, SDATA

# CDC, front-end(16.368MHz) / FPGA(50MHz)
set_clock_groups -asynchronous -group clk_frontend -group clk_50M

# LED
set_false_path -to [get_ports LED[*]]

# UART Controller
set_false_path -from [get_ports HPS_UART_RX]
set_false_path -to   [get_ports HPS_UART_TX]
#**************************************************************
# Create Generated Clock
#**************************************************************
derive_pll_clocks



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************
derive_clock_uncertainty



#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************



#**************************************************************
# Set Load
#**************************************************************
