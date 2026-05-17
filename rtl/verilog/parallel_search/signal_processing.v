module signal_processing
(
    // System
    clk,
    rst_n,
    // Input
    in_valid,
    I,
    Q,
    // Output - FFT_Input
    out_valid,
    out_real,
    out_imag,
    // Singal
    signal_start,
    // Test - CPU
    ar_RAM_cpu,
    DO_RAM_cpu
);
// ===============================================================
// Input & Output
// ===============================================================
// System
input clk;
input rst_n;

// Input
input in_valid;
input [1:0] I, Q;

// Output - FFT_Input
output out_valid;
output reg [31:0] out_real, out_imag;

// Signal
input signal_start;

// Test - CPU
input  [11:0] ar_RAM_cpu;
output [31:0] DO_RAM_cpu;
//================================================================
// Parameters & Integer
//================================================================
localparam  state_idle   = 2'd0,
            state_input  = 2'd1,
            state_output = 2'd2;

//================================================================
// Register & Wire
//================================================================
// Input
wire [3:0] data;

// state
reg  [1:0] state;
wire is_state_eq_output_d;
reg  is_state_eq_output_q[2:0];

// RAM
reg [2:0] cnt_data;
wire is_addr_RAM_eq_4091;
wire is_addr_RAM_eq_4095;

reg  [11:0] addr_RAM;
wire [11:0] addr_RAM_incr_1;
reg  [31:0] DI_RAM;
wire [31:0] DO_RAM;
reg         WE_RAM;

// Downsampling
wire [15:0] DO_RAM_ds;

// Signal
wire [1:0] I_tmp[3:0], Q_tmp[3:0];
wire [1:0] DO_real[3:0], DO_imag[3:0];
wire signed [2:0] DO_real_signed[3:0], DO_imag_signed[3:0];
wire signed [4:0] sum_real, sum_imag;

// output
wire [31:0] out_real_d, out_imag_d;

//================================================================
// Instance
//================================================================
// Instance - RAM_32x4096(frontend_output)
// Length : 32   [bits]
// Depth  : 4096 [words] (4096 data)
// word_0[28+:4] - {2-bits I[7], 2bits Q[7]} (latest)
// word_0[24+:4] - {2-bits I[6], 2bits Q[6]}
// word_0[20+:4] - {2-bits I[5], 2bits Q[5]}
// word_0[16+:4] - {2-bits I[4], 2bits Q[4]}
// word_0[12+:4] - {2-bits I[3], 2bits Q[3]}
// word_0[8+:4]  - {2-bits I[2], 2bits Q[2]}
// word_0[4+:4]  - {2-bits I[1], 2bits Q[1]}
// word_0[0+:4]  - {2-bits I[0], 2bits Q[0]} (earliest)
// Depth : 4096 [words] (4092 data from frontend in 2ms)
RAM_32x4096 u_RAM_original_data(
	.clock(clk),
	.wren(WE_RAM),
	.address(addr_RAM),
	.data(DI_RAM),
	.q(DO_RAM)
);

//================================================================
// Design
//================================================================
// Design - Data
assign data = {I, Q};

// Design - state
assign is_state_eq_output_d = (state==state_output);
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        state <= state_idle;
    end
    else begin
        case(state)
            state_idle: begin
                if(signal_start) begin
                    state <= state_input;
                end
            end
            state_input: begin
                if(is_addr_RAM_eq_4091 & WE_RAM) begin
                    state <= state_output;
                end
            end
            state_output: begin
                if(is_addr_RAM_eq_4095) begin
                    state <= state_idle;
                end
            end
        endcase
    end
end

// Design - counter_data
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        cnt_data <= 'b0;
    end
    else begin
        if(state==state_input && in_valid) begin
            cnt_data <= cnt_data + 3'b1;
        end

        if(state==state_idle) begin
            cnt_data <= 'b0;
        end
    end
end

// Design - RAM(Front-End Output) - Write
// Front-End sampling rate are 16.368 [MHz]
// Actual GPS signal are 4.092 [MHz]
// 1 [ms] has 16368 [data] = down-sample(8-to-1) => 2046 [data]
// ( ) FFT(N=4096) | 2046 [data] + 2050 [zeros]
// (x) FFT(N=4096) | 2046 [data] + 2046 [data] + 4 [zeros]
assign is_addr_RAM_eq_4091 = (addr_RAM==12'd4091);
assign is_addr_RAM_eq_4095 = (addr_RAM==12'd4095);
assign addr_RAM_incr_1 = (addr_RAM + 12'd1);
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        addr_RAM <= 'b0;
    end
    else begin
        case(state)
            state_idle: begin
                addr_RAM <= signal_start?12'b0:ar_RAM_cpu;
            end
            state_input: begin
                if(WE_RAM) begin
                    addr_RAM <= is_addr_RAM_eq_4091?12'b0:addr_RAM_incr_1;
                end
            end
            state_output: begin
                addr_RAM <= is_addr_RAM_eq_4095?12'b0:addr_RAM_incr_1;
            end
        endcase
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        DI_RAM <= 'b0;
    end
    else begin
        if(state==state_input && in_valid) begin
            case(cnt_data)
                3'd0: DI_RAM[0+:4]  <= data;
                3'd1: DI_RAM[4+:4]  <= data;
                3'd2: DI_RAM[8+:4]  <= data;
                3'd3: DI_RAM[12+:4] <= data;
                3'd4: DI_RAM[16+:4] <= data;
                3'd5: DI_RAM[20+:4] <= data;
                3'd6: DI_RAM[24+:4] <= data;
                3'd7: DI_RAM[28+:4] <= data;
            endcase
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        WE_RAM <= 'b0;
    end
    else begin
        WE_RAM <= ((&cnt_data) && in_valid);
    end
end

// Design - RAM(Front-End Output) - Read

// Design - RAM_CDC(FPGA)
// 1. GPS Signal
// x(t) = a(t) * exp(-i * ((w_IF + w_D) * t + phi))
// -----------------------------------------------
// a(t) := complex signal
// x(t) := front-end output
// w_IF := 4.092 * 2 * PI [MHz], Intermediate Frequency angular frequency
// w_D  := Doppler angular frequency
// phi  := phase

// 2. Front-End Downsample to Intermediate Frequency
//  s(t) = x(t) * exp(j * w_IF * t)
//       = [x_I(t) + x_Q(t)] * [cos(w_IF * t) + i * sin(w_IF * t)]
//       =       [x_I(t) * cos(w_IF * t) - x_Q(t) * sin(w_IF * t)]
//         + i * [x_Q(t) * cos(w_IF * t) + x_I(t) * sin(w_IF * t)]

// 3. Digitize Front-End Output Signal
// s(k) =       [x_I(t) * cos(2 * PI * f_IF * t_s * k) - x_Q(t) * sin(2 * PI * f_IF * t_s * k)]
//        + i * [x_Q(t) * cos(2 * PI * f_IF * t_s * k) + x_I(t) * sin(2 * PI * f_IF * t_s * k)]
// -----------------------------------------------
// s(k)   := RAM_CDC Input
// x_I(t) := I, front-end Input
// x_Q(t) := Q, front-end Input
// f_IF   := 4.092  [MHz] front-end intermediate frequency(IF)
// ts     := 16.368 [MHz] front-end sampling time

// 4. Simplified Front-End Output Signal
// s(k) =        [x_I(t) * cos(k * PI / 2) - x_Q(t) * sin(k * PI / 2)]
//         + i * [x_Q(t) * cos(k * PI / 2) + x_I(t) * sin(k * PI / 2)]

// 5. For Example, k=0~3
// s(0) =  x_I(0) + j * x_Q(0)
// s(1) = -x_Q(1) + j * x_I(1)
// s(2) = -x_I(2) - j * x_Q(2)
// s(3) =  x_Q(3) - j * x_I(3)

// Design - Downsampling(2-to-1), s(7:0) -> s(3:0)
assign DO_RAM_ds = DO_RAM[0+:16];

// Design - Split 16-bits data to I[3:0], Q[3:0]
assign I_tmp[3] = DO_RAM_ds[14+:2];
assign Q_tmp[3] = DO_RAM_ds[12+:2];

assign I_tmp[2] = DO_RAM_ds[10+:2];
assign Q_tmp[2] = DO_RAM_ds[8+:2];

assign I_tmp[1] = DO_RAM_ds[6+:2];
assign Q_tmp[1] = DO_RAM_ds[4+:2];

assign I_tmp[0] = DO_RAM_ds[2+:2];
assign Q_tmp[0] = DO_RAM_ds[0+:2];

// preprocess the sign and value for the following step
assign DO_real[3] = Q_tmp[3];
assign DO_imag[3] = {~I_tmp[3][1], I_tmp[3][0]};

assign DO_real[2] = {~I_tmp[2][1], I_tmp[2][0]};
assign DO_imag[2] = {~Q_tmp[2][1], Q_tmp[2][0]};

assign DO_real[1] = {~Q_tmp[1][1], Q_tmp[1][0]};
assign DO_imag[1] = I_tmp[1];

assign DO_real[0] = I_tmp[0];
assign DO_imag[0] = Q_tmp[0];

// Design - 2-bits(sign/mag) to 3-bits(+-1, +-3)
// sign/mag = 2'b01(+3) -> 3'b011
// sign/mag = 2'b00(+1) -> 3'b001
// sign/mag = 2'b10(-1) -> 3'b111
// sign/mag = 2'b11(-3) -> 3'b101
genvar i;
generate
    for(i=0;i<4;i=i+1) begin:real_imag
        assign DO_real_signed[i] = DO_real[i][1]?{1'b1, ~DO_real[i][0], 1'b1}:{1'b0, DO_real[i][0], 1'b1};
        assign DO_imag_signed[i] = DO_imag[i][1]?{1'b1, ~DO_imag[i][0], 1'b1}:{1'b0, DO_imag[i][0], 1'b1};
    end
endgenerate

// Design - summation of s(3:0)
assign sum_real = ( {{2{DO_real_signed[3][2]}}, DO_real_signed[3]} +
                    {{2{DO_real_signed[2][2]}}, DO_real_signed[2]} +
                    {{2{DO_real_signed[1][2]}}, DO_real_signed[1]} +
                    {{2{DO_real_signed[0][2]}}, DO_real_signed[0]});

assign sum_imag = ( {{2{DO_imag_signed[3][2]}}, DO_imag_signed[3]} +
                    {{2{DO_imag_signed[2][2]}}, DO_imag_signed[2]} +
                    {{2{DO_imag_signed[1][2]}}, DO_imag_signed[1]} +
                    {{2{DO_imag_signed[0][2]}}, DO_imag_signed[0]});

// Design - int to float
int5_to_float32 u_int5_to_float32_real(.in_int5(sum_real), .out_float32(out_real_d));
int5_to_float32 u_int5_to_float32_imag(.in_int5(sum_imag), .out_float32(out_imag_d));

// Design - out_valid
assign out_valid = is_state_eq_output_q[2];
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        is_state_eq_output_q[0] <= 'b0;
        is_state_eq_output_q[1] <= 'b0;
        is_state_eq_output_q[2] <= 'b0;
    end
    else begin
        is_state_eq_output_q[0] <= is_state_eq_output_d;
        is_state_eq_output_q[1] <= is_state_eq_output_q[0];
        is_state_eq_output_q[2] <= is_state_eq_output_q[1];
    end
end

// Design - output
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        out_real <= 'b0;
        out_imag <= 'b0;
    end
    else begin
        out_real <= out_real_d;
        out_imag <= out_imag_d;
    end
end

//================================================================
// Test - CPU
assign DO_RAM_cpu = DO_RAM;
endmodule
module int5_to_float32(
    in_int5,
    out_float32
);
// Notice: only work in_int5 from -12 to +12
// ===============================================================
// Input & Output
// ===============================================================
input  [4:0]  in_int5;
output [31:0] out_float32;

//================================================================
// Register & Wire
//================================================================
// Input
wire [3:0] abs_num;

// Calculation
wire sign; // 0:positive, 1:negative
reg  [7:0] exp;
wire [22:0] mantissa;

//================================================================
// Design
//================================================================
// Input
assign abs_num = sign?(~in_int5[3:0]+4'b1):in_int5[3:0];

// Calculation
// Following the IEEE-754 Floating Point Converter
// Website: https://www.h-schmidt.net/FloatConverter/IEEE754.html
assign sign = in_int5[4];

always @(*) begin
    if(abs_num[3]) begin
        exp = 'd130;
    end
    else if(abs_num[2]) begin
        exp = 'd129;
    end
    else if(abs_num[1]) begin
        exp = 'd128;
    end
    else if(abs_num[0]) begin
        exp = 'd127;
    end
    else begin
        exp = 'b0;
    end
end

assign mantissa[22] = (abs_num==3 || abs_num==6 || abs_num==7 || abs_num==12);
assign mantissa[21] = (abs_num==5 || abs_num==7 || abs_num==10 || abs_num==11);
assign mantissa[20] = (abs_num==9 || abs_num==11);
assign mantissa[19:0] = 'b0;

// Output
assign out_float32 = {sign, exp, mantissa};
endmodule