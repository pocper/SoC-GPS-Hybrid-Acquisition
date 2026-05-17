module CACode_generator(
    clk,
    rst_n,
    in_valid,
    in_CACode,
    out_valid,
    out_data,
    debug_state,
    debug_cnt_data
);
// CACode rate are 1.023 [Mbps] -> 1 [ms] has 1023 [chips]
// input signal 1 [ms] has 2046 [data], we need to fit data size, so we split chip to half-chips
// 1 [ms] has 2046 [half-chips]
// Full-chips : 1, 0, 1, 1, 0, ...
// Half-chips : 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, ...
// ===============================================================
// Input & Output
// ===============================================================
// System
input clk;
input rst_n;

// Input
input       in_valid;
input [4:0] in_CACode;

// Output
output        out_valid;
output [31:0] out_data;

output debug_state;
output [11:0] debug_cnt_data;

//================================================================
// Parameters & Integer
//================================================================
localparam  state_idle = 1'd0,
            state_busy = 1'd1;

//================================================================
// Register & Wire
//================================================================
// state
reg state;

// RAM
wire [14:0] ar_RAM;
wire        DO_RAM;

// Delay
reg valid_q[1:0];

// Circular shift
reg [4:0]  CACode;
reg [9:0] halfchip;
wire [10:0] halfchip_gt_2046;
reg [11:0] cnt_data;
wire is_cnt_data_lt_2046_d;
wire is_cnt_data_lt_4092_d;
reg  is_cnt_data_lt_4092_q[1:0];
wire [31:0] uint1_convert_to_float32;
//================================================================
// Instance
//================================================================
// TODO: 空間不夠，可以用硬體來換，這邊並沒有省到時間
ROM_1x32768_CACode u_CACode(
	.clock(clk),
	.address(ar_RAM),
	.q(DO_RAM)
);

//================================================================
// Design
//================================================================
// Design - state
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        state <= state_idle;
    end
    else begin
        case(state)
            state_idle: begin
                if(in_valid) begin
                    state <= state_busy;
                end
            end
            state_busy: begin
                if(cnt_data==4095) begin
                    state <= state_idle;
                end
            end
        endcase
    end
end

// Design - RAM
assign halfchip_gt_2046 = (cnt_data[11:1]-11'd1023);
always @(*) begin
    if(is_cnt_data_lt_4092_d) begin
        halfchip = is_cnt_data_lt_2046_d?cnt_data[10:1]:halfchip_gt_2046[9:0];
    end
    else begin
        halfchip = 'b0;
    end
end
assign ar_RAM  = {CACode, halfchip};
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        CACode <= 'b0;
    end
    else begin
        if(in_valid) begin
            CACode <= in_CACode;
        end
    end
end

// Design - counter for RAM address
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        cnt_data <= 'b0;
    end
    else begin
        if(state==state_busy) begin
            cnt_data <= (cnt_data + 12'b1);
        end
    end
end

// Design - RAM delay
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        valid_q[0] <= 'b0;
        valid_q[1] <= 'b0;
    end
    else begin
        valid_q[0] <= (state==state_busy);
        valid_q[1] <= valid_q[0];
    end
end

// Notice : 4096 data(2046 CACode + 2046 CACode + 2050 zeros)
assign is_cnt_data_lt_2046_d = (cnt_data<2046);
assign is_cnt_data_lt_4092_d = (cnt_data<4092);
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        is_cnt_data_lt_4092_q[0] <= 'b0;
        is_cnt_data_lt_4092_q[1] <= 'b0;
    end
    else begin
        is_cnt_data_lt_4092_q[0] <= is_cnt_data_lt_4092_d;
        is_cnt_data_lt_4092_q[1] <= is_cnt_data_lt_4092_q[0];
    end
end

// Design - Output
assign out_valid = valid_q[1];
// Following the IEEE-754 Floating Point Converter
// Website: https://www.h-schmidt.net/FloatConverter/IEEE754.html
// value range converter : 0/1 -> -1/+1
assign uint1_convert_to_float32 = {~DO_RAM, 31'h3F80_0000};
assign out_data = is_cnt_data_lt_4092_q[1]?uint1_convert_to_float32:32'h0;

assign debug_state = state;
assign debug_cnt_data = cnt_data;
endmodule