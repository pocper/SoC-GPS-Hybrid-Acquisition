module correlation(
    // System
    clk,
    rst_n,
    // Correlation(IFFT Output)
    in_valid,
    in_CACode,
    in_shift,
    in_data_real,
    in_data_imag,
    // Output
    out_valid,
    out_CACode,
    out_shift,
    out_correlation
);
// ===============================================================
// Input & Output
// ===============================================================
// System
input clk;
input rst_n;

// Correlation(IFFT Output)
input        in_valid;
input [4:0]  in_CACode;
input [5:0]  in_shift;
input [31:0] in_data_real, in_data_imag;

output        out_valid;
output [4:0]  out_CACode;
output [5:0]  out_shift;
output [31:0] out_correlation;

//================================================================
// Parameters & Integer
//================================================================
integer i;

//================================================================
// Register & Wire
//================================================================
// delay
reg in_valid_q[11:0];
reg [4:0] CACode_q[11:0];
reg [5:0] shift_q[11:0];

// Floating Point Multiplier
wire [31:0] mult1_A, mult1_B, mult1_Y;
wire [31:0] mult2_A, mult2_B, mult2_Y;

// Floating Point Hypotenuse
wire [31:0] hypo_A, hypo_B, hypo_C, hypo_Y;

//================================================================
// Instance
//================================================================
// Multiplier, Format:Single Floating Point, latency: 2 cycle
// q = a*b
FP_mult	u_FP_mult1 (
	.clk(clk),
    .areset(!rst_n),
	.a(mult1_A),
	.b(mult1_B),
	.q(mult1_Y)
);

// Multiplier, Format:Single Floating Point, latency: 2 cycle
// q = a*b
FP_mult	u_FP_mult2 (
	.clk(clk),
    .areset(!rst_n),
	.a(mult2_A),
	.b(mult2_B),
	.q(mult2_Y)
);

// 3D Hypotenuse, Format:Single Floating Point, latency: 10 cycle
// q = sqrt(a^2+b^2+c^2)
FP_hypotenuse u_FP_hypotenuse(
    .clk(clk),
    .areset(!rst_n),
    .a(hypo_A),
    .b(hypo_B),
    .c(hypo_C),
    .q(hypo_Y)
);

//================================================================
// Design
//================================================================
// Design - Delay
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i=0;i<12;i=i+1) begin
            in_valid_q[i] <= 'b0;
            CACode_q[i]   <= 'b0;
            shift_q[i]    <= 'b0;
        end
    end
    else begin
        in_valid_q[0] <= in_valid;
        CACode_q[0]   <= in_CACode;
        shift_q[0]    <= in_shift;
        for(i=0;i<11;i=i+1) begin
            in_valid_q[i+1] <= in_valid_q[i];
            CACode_q[i+1]   <= CACode_q[i];
            shift_q[i+1]    <= shift_q[i];
        end
    end
end

// Design - Multiplier
// Altera IFFT IP output is not scaled by N, so we multiply(1/N) here
// IEEE754 Floating Point : 32'h3980_0000 = 0.000244140625 = 1/4096
// FIXME: 這邊可以直接對exp -12
assign mult1_A = in_data_real;
assign mult1_B = 32'h3980_0000; 

assign mult2_A = in_data_imag;
assign mult2_B = 32'h3980_0000;

// Design - Hypotenuse
assign hypo_A = mult1_Y;
assign hypo_B = mult2_Y;
assign hypo_C = 32'h0;

// Design - Output
assign out_valid = in_valid_q[11];
assign out_CACode =  CACode_q[11];
assign out_shift = shift_q[11];
assign out_correlation = hypo_Y;
endmodule