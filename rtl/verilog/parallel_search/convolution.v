module convolution(
    // System
    clk,
    rst_n,
    mode,
    // Input
    shift_start_signed,
    shift_end_signed,
    in_valid_RAM_signal,
    in_valid_RAM_CACode,
    in_valid_last,
    in_data_real,
    in_data_imag,
    // Output
    out_valid,
    out_data_real,
    out_data_imag,
    out_shift,
    // Control
    table_data_read_ack,
    // Debug
    debug_state
);
// ===============================================================
// Input & Output
// ===============================================================
// System
input clk;
input rst_n;

// Settings
input [1:0] mode;

// Input
input in_valid_RAM_signal;
input in_valid_RAM_CACode;
input in_valid_last;
input [31:0] in_data_real, in_data_imag;

// Output
output        out_valid;
output [31:0] out_data_real, out_data_imag;

input  signed [5:0] shift_start_signed, shift_end_signed;
output signed [5:0] out_shift;

// Control
input table_data_read_ack;

// Debug
output [1:0] debug_state;

//================================================================
// Parameters & Integer
//================================================================
localparam  shift_head = -6'd20, 
            shift_tail =  6'd20;

localparam  state_RAM_signal_CACode    = 2'd0,
            state_convolution          = 2'd1,
            state_correlation_wait_ack = 2'd2;

localparam  mode_all                       = 2'd0,
            mode_single_CACode_multi_shift = 2'd1,
            mode_debug                     = 2'd2;

integer i;
//================================================================
// Register & Wire
//================================================================
// Design - state
reg [1:0] state;

// Design - RAM_signal
wire [11:0] addr_RAM_signal;
wire        WE_RAM_signal;
wire [31:0] DI_RAM_real_signal, DI_RAM_imag_signal;
wire [31:0] DO_RAM_real_signal, DO_RAM_imag_signal;

// Design - RAM_CACode
wire [11:0] addr_RAM_CACode;
wire        WE_RAM_CACode;
wire [31:0] DI_RAM_real_CACode, DI_RAM_imag_CACode;
wire [31:0] DO_RAM_real_CACode, DO_RAM_imag_CACode;

// Design - Floating Point Complex Multiply
wire [31:0] A_real, A_imag, B_real, B_imag;
wire [31:0] Y_real, Y_imag;

// Design - FT
reg  [11:0] cnt_data;
wire is_cnt_data_eq_4095;
wire [11:0] idx_data_digitReverse;
wire [11:0] cnt_data_digitReverse;


// Design - Circular shift
reg signed [5:0] shift_signed;
reg signed [5:0] shift_signed_q [7:0];
wire signed [5:0] shift_signed_incr_1;

// Design - Delay
wire out_valid_d;
reg  out_valid_q[7:0];

//================================================================
// Instance
//================================================================
// Length : 32   [bits]  (32-bits FFT_signal real)
// Depth  : 4096 [words] (4096 data)
RAM_32x4096 u_RAM_signal_real(
	.clock(clk),
	.address(addr_RAM_signal),
	.wren(WE_RAM_signal),
	.data(DI_RAM_real_signal),
	.q(DO_RAM_real_signal)
);

// Length : 32   [bits]  (32-bits FFT_signal imag)
// Depth  : 4096 [words] (4096 data)
RAM_32x4096 u_RAM_signal_imag(
	.clock(clk),
	.address(addr_RAM_signal),
	.wren(WE_RAM_signal),
	.data(DI_RAM_imag_signal),
	.q(DO_RAM_imag_signal)
);

// Length : 32   [bits]  (32-bits FFT_CACode real)
// Depth  : 4096 [words] (4096 data)
RAM_32x4096 u_RAM_CACode_real(
	.clock(clk),
	.address(addr_RAM_CACode),
	.wren(WE_RAM_CACode),
	.data(DI_RAM_real_CACode),
	.q(DO_RAM_real_CACode)
);

// Length : 32   [bits]  (32-bits FFT_CACode imag)
// Depth  : 4096 [words] (4096 data)
RAM_32x4096 u_RAM_CACode_imag(
	.clock(clk),
	.address(addr_RAM_CACode),
	.wren(WE_RAM_CACode),
	.data(DI_RAM_imag_CACode),
	.q(DO_RAM_imag_CACode)
);

// Format:Single Floating Point, latency: 6 cycle
// (a+bi)*(c+di) = (q+ri)
FP_complex_mult u_FP_complex_mult(
		.clk(clk),
		.areset(!rst_n),
		.a(A_real),
		.b(A_imag),
		.c(B_real),
		.d(B_imag),
		.q(Y_real),
		.r(Y_imag)
	);

DigitReverse #(.WIDTH(12))
u_DigitReverse_cnt_data (
    .bits(cnt_data),
    .bitsReverse(cnt_data_digitReverse)
);
//================================================================
// Design
//================================================================
// Design - state
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        state <= state_RAM_signal_CACode;
    end
    else begin
        case(state)
            state_RAM_signal_CACode: begin
                if(in_valid_RAM_CACode && in_valid_last) begin
                    state <= state_convolution;
                end
            end
            state_convolution: begin
                if(is_cnt_data_eq_4095 && shift_signed==shift_end_signed && (mode==mode_all || mode==mode_single_CACode_multi_shift)) begin
                    state <= state_RAM_signal_CACode;
                end

                if(is_cnt_data_eq_4095 && mode==mode_debug) begin
                    state <= state_correlation_wait_ack;
                end
            end
            state_correlation_wait_ack: begin
                if(table_data_read_ack) begin
                    state <= (shift_signed==shift_end_signed)?state_RAM_signal_CACode:state_convolution;
                end
            end
        endcase
    end
end

//================================================================
// Altera FFT single-precision floating-point IP with butterfly architecture
// FFT: Input in natural order, output in digit-reversed order
// IFFT: Input in digit-reversed order, output in natural order
//================================================================
// Design - RAM_singal
// Single Floating Point(32-bits)
// Data[31]    = sign
// Data[23+:8] = exponent
// Data[0+:23] = fraction
assign WE_RAM_signal = in_valid_RAM_signal;
// Save FFT_Signal in digit-reversed Order
// Read FFT_Signal in digit-reversed Order to complex floating point multiplier
assign addr_RAM_signal = cnt_data_digitReverse;
assign DI_RAM_real_signal = in_data_real;
assign DI_RAM_imag_signal = in_data_imag;

// Design - RAM_CACode
assign idx_data_digitReverse = cnt_data_digitReverse + {{6{shift_signed[5]}}, shift_signed};

assign WE_RAM_CACode = in_valid_RAM_CACode;
// Save FFT_CACode in digit-reversed Order
// Read FFT_CACode in digit-reversed Order with doppler shift index to complex floating point multiplier
assign addr_RAM_CACode = in_valid_RAM_CACode?cnt_data_digitReverse:idx_data_digitReverse;
// To perform correlation in the frequency domain, we multiply the signal's spectrum
// with the complex conjugate of the C/A code's spectrum.
assign DI_RAM_real_CACode = in_data_real;
assign DI_RAM_imag_CACode = {~in_data_imag[31], in_data_imag[0+:31]};

//================================================================
// Design - Circular shift
// Doppler Shift : ±10 [KHz]
// Resolution    : 500 [ Hz]
// CA Code Shift : (2 x 10 [kHz]) / (500 [Hz]) + 0 [Hz] = 41 [times]
assign is_cnt_data_eq_4095 = (cnt_data==12'd4095);
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        cnt_data <= 'b0;
    end
    else begin
        if(in_valid_RAM_signal || in_valid_RAM_CACode || (state==state_convolution)) begin
            cnt_data <= cnt_data + 12'b1;
        end
    end
end

assign shift_signed_incr_1 = (shift_signed + 6'd1);
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        shift_signed <= shift_head;
    end
    else begin
        if(state==state_RAM_signal_CACode) begin
            shift_signed <= shift_start_signed;
        end
        else begin
            case(mode)
                mode_debug: begin
                    if(state==state_correlation_wait_ack && table_data_read_ack) begin
                        shift_signed <= (shift_signed==shift_end_signed)?shift_start_signed:shift_signed_incr_1;
                    end
                end
                default: begin
                    if(state==state_convolution && is_cnt_data_eq_4095) begin
                        shift_signed <= (shift_signed==shift_end_signed)?shift_start_signed:shift_signed_incr_1;
                    end
                end
            endcase
        end
    end
end

//================================================================
// Design - Floating Point Complex Multiply
assign A_real = DO_RAM_real_signal;
assign A_imag = DO_RAM_imag_signal;
assign B_real = DO_RAM_real_CACode;
assign B_imag = DO_RAM_imag_CACode;

//================================================================
// RAM input to RAM output delay 2T
// complex multilier input to complex multilier output delay 6T
assign out_valid_d = (state==state_convolution);
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i=0;i<8;i=i+1) begin
            out_valid_q[i] <= 'b0;
            shift_signed_q[i] <= 'b0;
        end
    end
    else begin
        out_valid_q[0] <= out_valid_d;
        shift_signed_q[0] <= shift_signed;
        for(i=0;i<7;i=i+1) begin
            out_valid_q[i+1] <= out_valid_q[i];
            shift_signed_q[i+1] <= shift_signed_q[i];
        end
    end
end

//================================================================
// Design - Output
assign out_valid = out_valid_q[7];
assign out_data_real  = Y_real;
assign out_data_imag  = Y_imag;

assign out_shift = shift_signed_q[7];

// Debug
assign debug_state = state;
endmodule