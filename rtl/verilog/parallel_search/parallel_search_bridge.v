 module parallel_search_bridge
(
    // Avalon Bus
    clk,
    rst_n,
    address,
    write,
    writedata,
    read,
    readdata,
    irq,
    // Input
    in_valid,
    I,
    Q,
    // Output
    LED,
    ctrl_parallel_search
);
// ===============================================================
// Input & Output
// ===============================================================
input clk;
input rst_n;

input  [7:0] address;
input  write;
input  [31:0] writedata;
input  read;
output reg [31:0] readdata;
output irq;

input in_valid;
input [1:0] I, Q;
output reg [7:0] LED;

// Pulse signal
output [1:0] ctrl_parallel_search;  // TO code_phase_compensator_bridge

// ===============================================================
// Register & wire
// ===============================================================
// status
wire [3:0] ctrl;
reg  ctrl_start; // assert when module needs process dataset, reset when module start proccessing
wire ctrl_done;  // assert when proccess of module is done. pulse last for 1 cycle to trigger HPS IRQ
wire ctrl_idle;  // assert when module is ready for receiving new dataset

// Status
wire [1:0] state;

// Settings
reg  [1:0] set_mode;
reg        set_condition;

// Input Record
reg  [11:0] table_CDC_in_address;
wire [31:0] table_CDC_out_data;

// Correlation Record
reg irq_ack;

// Correlation Record (Mode#0)
reg  [4:0]  table_in_CACode;
reg  [5:0]  table_in_shift;
wire [31:0] table_out_correlation;
wire [31:0] table_out_correlation_avg;
wire [11:0] table_out_chip_offset;
wire [31:0] table_max_valid;
reg  [4:0]  table_max_in_CACode;
wire [5:0]  table_max_out_shift;

// Correlation Record (Mode#1)
reg [4:0] set_CACode_id;
reg [5:0] set_shift_center;
reg [4:0] set_shift_width;

// Correlation Record (Mode#2)
reg  [11:0] table_data_in_index;
wire [4:0]  table_data_out_CACode;
wire [5:0]  table_data_out_shift;
wire [31:0] table_data_out_correlation;
reg         table_data_read_ack;

// Debug
wire [4:0]  debug_CACode;
wire [5:0]  debug_shift_unsigned;
wire [5:0]  debug_shift_end_unsigned;
wire [11:0] debug_cnt_data;
wire [1:0]  debug_state_ft_input;
wire [11:0] debug_cnt_FTIn_ft_input;
wire [1:0]  debug_state_conv;
wire debug_state_CACode_generator;
wire [11:0] debug_cnt_data_CACode_generator;

// ===============================================================
// Address Map
// ===============================================================
// Description
// 1. Input settings are valid at ctrl_start pulse raise, 
//    including set_mode/set_CACode_id/set_shift_center/set_shift_width
// 2. Out data are valid at system not busy
// ----------------
// Mode
// 1. Mode#0: calculate correlation of 32[CACode] x 41[shift]
// 2. Mode#1: calculate correlation of specific CACode, specific shift_center, specific shift_width
// 3. Mode#2: debug mode, calculate correlation of 32[CACode] x 41 [shift] x 4096 [data], 
//            need to send table_data_read_ack to continue for 32[CACode] x 41 [shift] times
/* | Address |           Name                     | R/W |
 * | ------- | ---------------------------------- | --- |
 * |   0x0-  | Status & Control                   |     |
 * | ------- | ---------------------------------- | --- |
 * |   0x-0  | ctrl_start(W)/ctrl(R)              | R/W |
 * |   0x-1  | state                              | R   |
 * |   0x-2  | irq_ack                            | W   |
 * |   0x-3  | set_mode                           | R/W |
 * |   0x-4  | set_condition                      | R/W |
 * | ------- | ---------------------------------- | --- |
 * |   0x1-  | Input Record                       |     |
 * | ------- | ---------------------------------- | --- |
 * |   0x-0  | table_CDC_in_address               | R/W |
 * |   0x-1  | table_CDC_out_data                 | R   |
 * | ------- | ---------------------------------- | --- |
 * |   0x2-  | Correlation Record (Mode#0)        |     |
 * | ------- | ---------------------------------- | --- |
 * |   0x-0  | table_in_CACode                    | R/W |
 * |   0x-1  | table_in_shift                     | R/W |
 * |   0x-2  | table_out_correlation_avg          | R   |
 * |   0x-3  | table_out_correlation              | R   |
 * |   0x-4  | table_out_chip_offset              | R   |
 * |   0x-5  | table_max_valid                    | R   |
 * |   0x-6  | table_max_in_CACode                | R/W |
 * |   0x-7  | table_max_out_shift                | R   |
 * | ------- | ---------------------------------- | --- |
 * |   0x3-  | Correlation Record (Mode#1)        |     |
 * | ------- | ---------------------------------- | --- |
 * |   0x-0  | set_CACode_id                      | R/W |
 * |   0x-1  | set_shift_center                   | R/W |
 * |   0x-2  | set_shift_width                    | R/W |
 * | ------- | ---------------------------------- | --- |
 * |   0x4-  | Correlation Record (Mode#2)        |     |
 * | ------- | ---------------------------------- | --- |
 * |   0x-0  | table_data_in_index                | R/W |
 * |   0x-1  | table_data_out_CACode              | R   |
 * |   0x-2  | table_data_out_shift               | R   |
 * |   0x-3  | table_data_out_correlation         | R   |
 * |   0x-4  | table_data_read_ack                | W   |
 * | ------- | ---------------------------------- | --- |
 * |   0x5-  | Debug Information                  |     |
 * | ------- | ---------------------------------- | --- |
 * |         | correlation_processing             |     |
 * | ------- | ---------------------------------- | --- |
 * |   0x-0  | CACode                             | R   |
 * |   0x-1  | shift_unsigned                     | R   |
 * |   0x-2  | shift_end_unsigned                 | R   |
 * |   0x-3  | cnt_data                           | R   |
 * | ------- | ---------------------------------- | --- |
 * |         | controller_ft_input                |     |
 * | ------- | ---------------------------------- | --- |
 * |   0x-4  | state                              | R   |
 * |   0x-5  | cnt_FTIn                           | R   |
 * | ------- | ---------------------------------- | --- |
 * |         | convolution                        |     |
 * | ------- | ---------------------------------- | --- |
 * |   0x-6  | state                              | R   |
 * | ------- | ---------------------------------- | --- |
 * |         | CACode Generator                   |     |
 * | ------- | ---------------------------------- | --- |
 * |   0x-7  | state                              | R   |
 * |   0x-8  | cnt_data                           | R   |
 */
// ===============================================================
// Design
// ===============================================================
assign ctrl = {ctrl_idle, ctrl_done, ctrl_start};
assign ctrl_parallel_search = {ctrl_done, ctrl_start & ctrl_idle};

// Write
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        ctrl_start <= 'b0;
        irq_ack <= 'b0;
        set_mode <= 'b0;
        set_condition <= 'b0;
        table_CDC_in_address <= 'b0;
        table_in_CACode <= 'b0;
        table_in_shift <= 'b0;
        set_CACode_id <= 'b0;
        set_shift_center <= 'b0;
        set_shift_width <= 'b0;
        table_max_in_CACode <= 'b0;
        table_data_in_index <= 'b0;
        table_data_read_ack <= 'b0;
    end
    else begin
        if(write) begin
            case(address)
                'h00: ctrl_start           <= writedata[0];
                'h02: irq_ack              <= writedata[0];
                'h03: set_mode             <= writedata[1:0];
                'h04: set_condition        <= writedata[0];
                // -------------------------------------------
                'h10: table_CDC_in_address <= writedata[11:0];
                // -------------------------------------------
                'h20: table_in_CACode      <= writedata[4:0];
                'h21: table_in_shift       <= writedata[5:0];
                'h26: table_max_in_CACode  <= writedata[4:0];
                // -------------------------------------------
                'h30: set_CACode_id        <= writedata[4:0];
                'h31: set_shift_center     <= writedata[5:0];
                'h32: set_shift_width      <= writedata[4:0];
                // -------------------------------------------
                'h40: table_data_in_index  <= writedata[11:0];
                'h44: table_data_read_ack  <= writedata[0];
            endcase
        end
        
        if(irq_ack) begin
            irq_ack <= 'b0;
        end

        if(table_data_read_ack) begin
            table_data_read_ack <= 'b0;
        end

        if(ctrl_start) begin
            ctrl_start <= 'b0;
        end
    end
end

// Read
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        readdata <= 'b0;
    end
    else begin
        if(read) begin
            case(address)
                'h00: readdata <= {28'b0, ctrl};
                'h01: readdata <= {30'b0, state};
                'h03: readdata <= {30'b0, set_mode};
                'h04: readdata <= {31'b0, set_condition};
                // -------------------------------------------
                'h10: readdata <= {20'b0, table_CDC_in_address};
                'h11: readdata <= table_CDC_out_data;
                // -------------------------------------------
                'h20: readdata <= {27'b0, table_in_CACode};
                'h21: readdata <= {26'b0, table_in_shift};
                'h22: readdata <= table_out_correlation_avg;
                'h23: readdata <= table_out_correlation;
                'h24: readdata <= {20'b0, table_out_chip_offset};
                'h25: readdata <= table_max_valid;
                'h26: readdata <= {27'b0, table_max_in_CACode};
                'h27: readdata <= {26'b0, table_max_out_shift};
                // -------------------------------------------
                'h30: readdata <= {27'b0, set_CACode_id};
                'h31: readdata <= {26'b0, set_shift_center};
                'h32: readdata <= {27'b0, set_shift_width};
                // -------------------------------------------
                'h40: readdata <= {20'b0, table_data_in_index};
                'h41: readdata <= {27'b0, table_data_out_CACode};
                'h42: readdata <= {26'b0, table_data_out_shift};
                'h43: readdata <= table_data_out_correlation;
                // -------------------------------------------
                'h50: readdata <= {27'b0, debug_CACode};
                'h51: readdata <= {26'b0, debug_shift_unsigned};
                'h52: readdata <= {26'b0, debug_shift_end_unsigned};
                'h53: readdata <= {20'b0, debug_cnt_data};
                'h54: readdata <= {30'b0, debug_state_ft_input};
                'h55: readdata <= {20'b0, debug_cnt_FTIn_ft_input};
                'h56: readdata <= {30'b0, debug_state_conv};
                'h57: readdata <= {31'b0, debug_state_CACode_generator};
                'h58: readdata <= {20'b0, debug_cnt_data_CACode_generator};
                default: readdata <= 'b0;
            endcase
        end
    end
end

// ===============================================================
// Module
// ===============================================================
parallel_search u_parallel_search(   
    // Clock -----------------------------------------
    .clk(clk),
    // Reset -----------------------------------------
    .rst_n(rst_n),
    // Input -----------------------------------------
    .in_valid(in_valid),
    .I(I),
    .Q(Q),
    // Ctrl ------------------------------------------
    .ctrl_start(ctrl_start),
    .ctrl_done(ctrl_done),
    .ctrl_idle(ctrl_idle),
    // Status ----------------------------------------
    .state(state),
    // Settings --------------------------------------
    .set_mode(set_mode),
    .set_condition(set_condition),
    // Input Record ----------------------------------
    .table_CDC_in_address(table_CDC_in_address),
    .table_CDC_out_data(table_CDC_out_data),
    // Correlation Record ----------------------------
    .irq(irq),
    .irq_ack(irq_ack),
    // Correlation Record(Mode#0) --------------------
    .table_in_CACode(table_in_CACode),
    .table_in_shift(table_in_shift),
    .table_out_correlation(table_out_correlation),
    .table_out_correlation_avg(table_out_correlation_avg),
    .table_out_chip_offset(table_out_chip_offset),
    .table_max_valid(table_max_valid),
    .table_max_in_CACode(table_max_in_CACode),
    .table_max_out_shift(table_max_out_shift),
    // Correlation Record(Mode#1) --------------------
    .set_CACode_id(set_CACode_id),
    .set_shift_center(set_shift_center),
    .set_shift_width(set_shift_width),
    // Correlation Record(Mode#2) --------------------
    .table_data_in_index(table_data_in_index),
    .table_data_out_CACode(table_data_out_CACode),
    .table_data_out_shift(table_data_out_shift),
    .table_data_out_correlation(table_data_out_correlation),
    .table_data_read_ack(table_data_read_ack),
    // Debug -----------------------------------------
    .debug_CACode(debug_CACode),
    .debug_shift_unsigned(debug_shift_unsigned),
    .debug_shift_end_unsigned(debug_shift_end_unsigned),
    .debug_cnt_data(debug_cnt_data),
    .debug_state_ft_input(debug_state_ft_input),
    .debug_cnt_FTIn_ft_input(debug_cnt_FTIn_ft_input),
    .debug_state_conv(debug_state_conv),
    .debug_state_CACode_generator(debug_state_CACode_generator),
    .debug_cnt_data_CACode_generator(debug_cnt_data_CACode_generator)
);

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        LED <= 'b0;
    end
    else begin
        LED <= {ctrl, state};
    end
end
endmodule