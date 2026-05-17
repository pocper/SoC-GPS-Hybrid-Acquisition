// Notice: num_channel DO NOT greater than 13
module gps_baseband_bridge
#(parameter num_channel = 8)
(
    // Avalon Bus
    clk,
    hw_rst_n,
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
    ctrl_parallel_search,
    // Output
    LED
);
// ===============================================================
// Input & Output
// ===============================================================
input clk, hw_rst_n;

// Avalon Bus
input  [7:0] address;
input         write;
input  [31:0] writedata;
input             read;
output reg [31:0] readdata;
output reg irq;

// Input
input in_valid;
input [1:0] I, Q;

// ctrl_parallel_search[0] := start
// ctrl_parallel_search[1] := end
input [1:0] ctrl_parallel_search;

// Output
output [7:0] LED;
// ===============================================================
// Parameter & Integer
// ===============================================================
integer i, j;
//================================================================
// Register & Wire
//================================================================
// gps_baseband
reg [23:0] tic_divide;
reg [23:0] accum_divide;

wire        tic_enable;
wire        accum_enable;
wire [23:0] tic_count;
wire [23:0] accum_count;

reg       prn_key_enable [num_channel-1:0];
reg [9:0] prn_key        [num_channel-1:0];
reg [1:0] chip_select    [num_channel-1:0];

reg  [28:0] carr_nco [num_channel-1:0];
reg  [27:0] code_nco [num_channel-1:0];

wire [31:0] carrier_val [num_channel-1:0];
wire [20:0] code_val    [num_channel-1:0];

reg slew_enable      [num_channel-1:0];
reg [10:0] code_slew [num_channel-1:0];

reg         epoch_enable [num_channel-1:0];
reg  [10:0] epoch_load   [num_channel-1:0];
wire [10:0] epoch        [num_channel-1:0];
wire [10:0] epoch_check  [num_channel-1:0];

wire        dump_enable [num_channel-1:0];
wire [15:0] i_early     [num_channel-1:0];
wire [15:0] q_early     [num_channel-1:0];
wire [15:0] i_prompt    [num_channel-1:0];
wire [15:0] q_prompt    [num_channel-1:0];
wire [15:0] i_late      [num_channel-1:0];
wire [15:0] q_late      [num_channel-1:0];

wire [11:0] debug_hc_count2  [num_channel-1:0];
wire [10:0] debug_hc_count3  [num_channel-1:0];
wire [11:0] debug_max_count2 [num_channel-1:0];
wire [10:0] debug_slew       [num_channel-1:0];

// code phase compensator
reg syn_ch_enable[1:0];
reg [3:0] set_serial_ch[1:0];

// Bridge
wire [3:0] block, name;
wire is_block_eq_channel, is_block_eq_code_delay, is_block_eq_status, is_block_eq_control;

wire state_read;
reg [1:0] state;

reg                   new_data_read;
reg [num_channel-1:0] new_data;

wire rst_n;
reg  sw_rst;

// Debug
reg [11:0] ch0_hc_count2_start, ch0_hc_count2_end;
reg [11:0] ch0_hc_count2_q;
wire [11:0] ch0_hc_count2_d;
reg [10:0] ch0_hc_count3_start, ch0_hc_count3_end;
reg [10:0] ch1_hc_count3_start, ch1_hc_count3_end;
reg [10:0] ch0_hc_count3_q;
reg [10:0] ch1_hc_count3_q;
wire [10:0] ch0_hc_count3_d;
wire [10:0] ch1_hc_count3_d;


reg [10:0] ch2_hc_count3_start, ch2_hc_count3_end;
reg [10:0] ch2_hc_count3_q;
wire [10:0] ch2_hc_count3_d;

wire ctrl_start_parallel_search_d;
reg ctrl_start_parallel_search_q, ctrl_start_parallel_search_q_q;

//================================================================
// Memory Map
//================================================================
// This module connects to the Avalon bus

// X := 4-bits Hexadecimal
// R := Read
// W := Write

// Address Table - Block
/* | Address | Block                |
 * |---------|----------------------|
 * |  0x0X   | Channel 0            |
 * |  0x1X   | Channel 1            |
 * |  0x2X   | Channel 2            |
 * |  0x3X   | Channel 3            |
 * |  0x4X   | Channel 4            |
 * |  0x5X   | Channel 5            |
 * |  0x6X   | Channel 6            |
 * |  0x7X   | Channel 7            |
 * |  0x8X   | Channel 8            |
 * |  0xCX   | Channel 12 (Maximum) |
 * |  0xDX   | Code Delay           |
 * |  0xEX   | Status               |
 * |  0xFX   | Control              |
 */

// Address Table - Block(Channel)
/* | Address | Name        | Access Type |
 * |---------|-------------|-------------|
 * |  0xX0   | prn_key     | R/W         |
 * |  0xX1   | carrier_nco | R/W         |
 * |  0xX2   | code_nco    | R/W         |
 * |  0xX3   | code_slew   | R/W         |
 * |  0xX4   | I_early     | R           |
 * |  0xX5   | Q_early     | R           |
 * |  0xX6   | I_prompt    | R           |
 * |  0xX7   | Q_prompt    | R           |
 * |  0xX8   | I_late      | R           |
 * |  0xX9   | Q_late      | R           |
 * |  0xXA   | carrier_val | R           |
 * |  0xXB   | code_val    | R           |
 * |  0xXC   | epoch       | R           |
 * |  0xXD   | epoch_check | R           |
 * |  0xXE   | epoch_load  | R/W         |
 * |  0xXF   | chip_select | R/W         |
 */

// Address Table - Code Delay
/* | Address | Name                 | Access Type |
 * |---------|--------------------- |-------------|
 * |  0xD0   | set_serial_ch[0]     | R/W         |
 * |  0xD1   | set_serial_ch[1]     | R/W         |
 * |  0xD2   | ch0_hc_count2_start  | R           | *debug*
 * |  0xD3   | ch0_hc_count3_start  | R           | *debug*
 * |  0xD4   | ch0_hc_count2_end    | R           | *debug*
 * |  0xD5   | ch0_hc_count3_end    | R           | *debug*
 * |  0xD6   | ch0_hc_count2_q      | R           | *debug*
 * |  0xD7   | ch0_hc_count3_q      | R           | *debug*
 * |  0xD8   | ch1_hc_count3_start  | R           | *debug*
 * |  0xD9   | ch1_hc_count3_end    | R           | *debug*
 * |  0xDa   | ch1_hc_count3_q      | R           | *debug*
 * |  0xDb   | ch2_hc_count3_start  | R           | *debug*
 * |  0xDc   | ch2_hc_count3_end    | R           | *debug*
 * |  0xDd   | ch2_hc_count3_q      | R           | *debug*
 */

// Address Table - Block(Status)
/* | Address | Name        | Access Type |
 * |---------|-------------|-------------|
 * |  0xE0   | status      | R           |
 * |  0xE1   | new_data    | R           |
 * |  0xE2   | tic_count   | R           |
 * |  0xE3   | accum_count | R           |
 */

// Address Table - Block(Control)
/* | Address | Name           | Access Type |
 * |---------|----------------|-------------|
 * |  0xF0   | reset          | W           |
 * |  0xF1   | prog_tic       | W           |
 * |  0xF2   | prog_accum_int | W           |
 */

typedef enum reg [3:0] {
    CHANNEL,          // 0
    CODE_DELAY=4'd13, // 13
    STATUS,           // 14
    CONTROL           // 15
} block_t;

typedef enum reg [3:0] {
    PRN_KEY,     // 0
    CARR_NCO,    // 1
    CODE_NCO,    // 2
    CODE_SLEW,   // 3
    I_EARLY,     // 4
    Q_EARLY,     // 5
    I_PROMPT,    // 6
    Q_PROMPT,    // 7
    I_LATE,      // 8
    Q_LATE,      // 9
    CARR_VAL,    // 10
    CODE_VAL,    // 11
    EPOCH,       // 12
    EPOCH_CHECK, // 13
    EPOCH_LOAD,  // 14
    CHIP_SELECT  // 15
} channel_t;

typedef enum reg [3:0] {
    STATE,      // 0
    NEW_DATA,   // 1
    TIC_COUNT,  // 2
    ACCUM_COUNT // 3
} status_t;

typedef enum reg [3:0] {
    SW_RESET,      // 0
    PROG_TIC,      // 1
    PROG_ACCUM_INT // 2
} control_t;

//================================================================
// Instance
//================================================================
gps_baseband #(.num_channel(num_channel))
u_gps_baseband (
    .clk           (clk),
    .rst_n         (rst_n),
    // Input
    .in_valid      (in_valid),
    .I             (I),
    .Q             (Q),
    // time_base
    .tic_divide    (tic_divide),
    .accum_divide  (accum_divide),
    .tic_enable    (tic_enable),
    .accum_enable  (accum_enable),
    .tic_count     (tic_count),
    .accum_count   (accum_count),
    // tracking_channel
    .prn_key_enable(prn_key_enable),
    .prn_key       (prn_key),
    .chip_select   (chip_select),
    .carr_nco      (carr_nco),
    .code_nco      (code_nco),
    .carrier_val   (carrier_val),
    .code_val      (code_val),
    .slew_enable   (slew_enable),
    .code_slew     (code_slew),
    .epoch_enable  (epoch_enable),
    .epoch_load    (epoch_load),
    .epoch         (epoch),
    .epoch_check   (epoch_check),
    .dump_enable   (dump_enable),
    .i_early       (i_early),
    .q_early       (q_early),
    .i_prompt      (i_prompt),
    .q_prompt      (q_prompt),
    .i_late        (i_late),
    .q_late        (q_late),
    .debug_hc_count2(debug_hc_count2),
    .debug_hc_count3(debug_hc_count3),
    .debug_max_count2(debug_max_count2),
    .debug_slew(debug_slew)
);

//================================================================
// Design
//================================================================
// Reset
assign rst_n = (hw_rst_n & ~sw_rst);

// Avalon Bus
assign block = address[4+:4];
assign name  = address[0+:4];
assign is_block_eq_channel    = (block<num_channel);
assign is_block_eq_code_delay = (block==CODE_DELAY);
assign is_block_eq_status     = (block==STATUS);
assign is_block_eq_control    = (block==CONTROL);

// Block-Channel(Write)
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i=0;i<num_channel;i=i+1) begin
            prn_key_enable[i] <= 'b0;
            prn_key[i]        <= 'b0;
            chip_select[i]    <= 'b0;
            carr_nco[i]       <= 'b0;
            code_nco[i]       <= 'b0;
            slew_enable[i]    <= 'b0;
            code_slew[i]      <= 'b0;
            epoch_enable[i]   <= 'b0;
            epoch_load[i]     <= 'b0;
        end
    end
    else begin
        if(write && is_block_eq_channel) begin
            case(name)
                PRN_KEY: begin
                    prn_key_enable[block] <= 'b1;
                    prn_key[block] <= writedata[9:0];
                end
                CARR_NCO: begin
                    carr_nco[block] <= writedata[28:0];
                end
                CODE_NCO: begin
                    code_nco[block] <= writedata[27:0];
                end
                CODE_SLEW: begin
                    slew_enable[block] <= 'b1;
                    code_slew[block] <= writedata[10:0];
                end
                EPOCH_LOAD: begin
                    epoch_enable[block] <= 'b1;
                    epoch_load[block] <= writedata[10:0];
                end
                CHIP_SELECT: begin
                    chip_select[block] <= writedata[1:0];
                end
            endcase
        end

        // prn_key_enable, slew_enable, epoch_enable are pulse signal, only last for 1 cycle
        for(i=0;i<num_channel;i=i+1) begin
            if(prn_key_enable[i]) begin
                prn_key_enable[i] <= 'b0;
            end
            if(slew_enable[i]) begin
                slew_enable[i] <= 'b0;
            end
            if(epoch_enable[i]) begin
                epoch_enable[i] <= 'b0;
            end
        end

        // Code Delay - synchronize 3 serial channel
        if( ctrl_parallel_search[0] && 
            syn_ch_enable[0] && syn_ch_enable[1]) begin
            prn_key_enable[set_serial_ch[0]] <= 'b1;
            prn_key_enable[set_serial_ch[1]] <= 'b1;
        end
    end
end

// Block-Code delay(Write)
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        set_serial_ch[0] <= 'b0;
        set_serial_ch[1] <= 'b0;

        syn_ch_enable[0] <= 'b0;
        syn_ch_enable[1] <= 'b0;
    end
    else begin
        if(write && is_block_eq_code_delay) begin
            case(name)
                'h0: begin
                    syn_ch_enable[0] <= 'b1;
                    set_serial_ch[0] <= writedata[3:0];
                end
                'h1: begin
                    syn_ch_enable[1] <= 'b1;
                    set_serial_ch[1] <= writedata[3:0];
                end
            endcase
        end

        if(ctrl_parallel_search[0]) begin
            syn_ch_enable[0] <= 'b0;
            syn_ch_enable[1] <= 'b0;
            
        end
    end
end

// Block-Control(Write)
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        sw_rst       <= 'b0;
        tic_divide   <= 24'd4999999;
        accum_divide <= 24'd24999;
    end
    else begin
        if(write && is_block_eq_control) begin
            case(name)
                SW_RESET: begin
                    // We don't need to clear sw_rst, due to rst_n trigger everything to reset
                    sw_rst <= 'b1;
                end
                PROG_TIC: begin
                    tic_divide <= writedata[23:0];
                end
                PROG_ACCUM_INT: begin
                    accum_divide <= writedata[23:0];
                end
            endcase
        end
    end
end

// Read
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        readdata <= 'b0;
    end
    else begin
        if(read && is_block_eq_channel) begin
            case(name)
                PRN_KEY:     readdata <= {22'b0, prn_key[block]};
                CARR_NCO:    readdata <= {3'b0, carr_nco[block]};
                CODE_NCO:    readdata <= {4'b0, code_nco[block]};
                CODE_SLEW:   readdata <= {21'b0, code_slew[block]};
                I_EARLY:     readdata <= {16'b0, i_early[block]};
                Q_EARLY:     readdata <= {16'b0, q_early[block]};
                I_PROMPT:    readdata <= {16'b0, i_prompt[block]};
                Q_PROMPT:    readdata <= {16'b0, q_prompt[block]};
                I_LATE:      readdata <= {16'b0, i_late[block]};
                Q_LATE:      readdata <= {16'b0, q_late[block]};
                CARR_VAL:    readdata <= carrier_val[block];
                CODE_VAL:    readdata <= {11'b0, code_val[block]};
                EPOCH:       readdata <= {21'b0, epoch[block]};
                EPOCH_CHECK: readdata <= {21'b0, epoch_check[block]};
                EPOCH_LOAD:  readdata <= {21'b0, epoch_load[block]};
                CHIP_SELECT: readdata <= {30'b0, chip_select[block]};
                default:     readdata <= 'b0;
            endcase
        end

        if(read && is_block_eq_code_delay) begin
            case(name)
                'h0: readdata <= {28'b0, set_serial_ch[0]};
                'h1: readdata <= {28'b0, set_serial_ch[1]};
                'h2: readdata <= {20'b0, ch0_hc_count2_start};
                'h3: readdata <= {21'b0, ch0_hc_count3_start};
                'h4: readdata <= {20'b0, ch0_hc_count2_end};
                'h5: readdata <= {21'b0, ch0_hc_count3_end};
                'h6: readdata <= {20'b0, ch0_hc_count2_q};
                'h7: readdata <= {21'b0, ch0_hc_count3_q};
                'h8: readdata <= {21'b0, ch1_hc_count3_start};
                'h9: readdata <= {21'b0, ch1_hc_count3_end};
                'ha: readdata <= {21'b0, ch1_hc_count3_q};
                'hb: readdata <= {21'b0, ch2_hc_count3_start};
                'hc: readdata <= {21'b0, ch2_hc_count3_end};
                'hd: readdata <= {21'b0, ch2_hc_count3_q};
                default:  readdata <= 'b0;
            endcase
        end

        if(read && is_block_eq_status) begin
            case(name)
                STATE:       readdata <= {30'b0, state};
                NEW_DATA:    readdata <= {{(32-num_channel){1'b0}}, new_data};
                TIC_COUNT:   readdata <= {8'b0, tic_count};
                ACCUM_COUNT: readdata <= {8'b0, accum_count};
                default:     readdata <= 'b0;
            endcase
        end

        if(read && !(is_block_eq_channel || is_block_eq_status || is_block_eq_code_delay)) begin
            readdata <= 'b0;
        end
    end
end
// ---------------------------------------------------------------
// IRQ
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        irq <= 'b0;
    end
    else begin
        if(state_read) begin
            irq <= 'b0;
        end
        else if(accum_enable)begin
            irq <= 'b1;
        end
    end
end

// State
assign state_read = (read && is_block_eq_status && name==STATE);
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        state <= 'b0;
    end
    else begin
        if(state_read) begin
            state <= 'b0;
        end
        else begin
            if(tic_enable) begin
                state[0] <= 'b1;
            end
            if(accum_enable) begin
                state[1] <= 'b1;
            end
        end
    end
end

// new_data
assign new_data_read = (read && is_block_eq_status && name==NEW_DATA);
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        new_data <= 'b0;
    end
    else begin
        // dump_enable has priority over new_data_read; if both are 1, dump_enable must be preserved.
        for(j=0;j<num_channel;j=j+1) begin
            if(dump_enable[j]) begin
                new_data[j] <= 'b1;
            end
            else if(new_data_read) begin
                new_data[j] <= 'b0;
            end

        end
    end
end

// LED
assign LED = {6'b0, state};

// Debug
assign ctrl_start_parallel_search_d = ctrl_parallel_search[0];
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        ctrl_start_parallel_search_q <= 'b0;
        ctrl_start_parallel_search_q_q <= 'b0;
    end
    else begin
        ctrl_start_parallel_search_q <= ctrl_start_parallel_search_d;
        ctrl_start_parallel_search_q_q <= ctrl_start_parallel_search_q;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        ch0_hc_count2_start <= 'b0;
        ch0_hc_count2_end <= 'b0;

        ch0_hc_count3_start <= 'b0;
        ch0_hc_count3_end <= 'b0;

        ch1_hc_count3_start <= 'b0;
        ch1_hc_count3_end <= 'b0;

        ch2_hc_count3_start <= 'b0;
        ch2_hc_count3_end <= 'b0;
    end
    else begin
        if(ctrl_start_parallel_search_q_q) begin
            // 0T -> ctrl_parallel_search[0] = 1;
            // 1T -> prn_key_enable = 1;
            // 2T -> hc_count3 = 0; hc_count2 = 0;
            ch0_hc_count2_start <= ch0_hc_count2_d;

            ch0_hc_count3_start <= ch0_hc_count3_d;
            ch1_hc_count3_start <= ch1_hc_count3_d;
            ch2_hc_count3_start <= ch2_hc_count3_d;
        end
        
        if(ctrl_parallel_search[1]) begin
            ch0_hc_count2_end <= ch0_hc_count2_d;

            ch0_hc_count3_end <= ch0_hc_count3_d;
            ch1_hc_count3_end <= ch1_hc_count3_d;
            ch2_hc_count3_end <= ch2_hc_count3_d;
        end
    end
end
// FIXME: 要看slew完的CH[2]與CH[0]的code phase
assign ch0_hc_count2_d = debug_hc_count2[0];

assign ch0_hc_count3_d = debug_hc_count3[0];
assign ch1_hc_count3_d = debug_hc_count3[1];
assign ch2_hc_count3_d = debug_hc_count3[2];

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        ch0_hc_count2_q <= 'b0;
        ch0_hc_count3_q <= 'b0;
        ch1_hc_count3_q <= 'b0;
        ch2_hc_count3_q <= 'b0;
    end
    else begin
        if(state_read) begin
            ch0_hc_count2_q  <= ch0_hc_count2_d;
            ch0_hc_count3_q  <= ch0_hc_count3_d;
            ch1_hc_count3_q  <= ch1_hc_count3_d;
            ch2_hc_count3_q  <= ch2_hc_count3_d;
        end
    end
end
endmodule