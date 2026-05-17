module correlation_processing(
    // System
    clk,
    rst_n,
    ctrl_restart,
    // Settings
    mode,
    condition,
    shift_start_signed,
    shift_end_signed,
    // Input
    in_valid,
    in_CACode,
    in_shift,
    in_correlation,
    // Output
    out_CACode,
    out_shift,
    irq,
    irq_ack,
    irq_status,
    ar_data,
    DO_data,
    // CPU
    table_in_CACode,
    table_in_shift,
    DO_correlation,
    DO_correlation_avg,
    DO_idx_halfchip,
    valid_table_CACode,
    ar_shift_max_CACode,
    DO_shift_max,
    // Debug
    debug_CACode,
    debug_shift_unsigned,
    debug_shift_end_unsigned,
    debug_cnt_data
);
// ===============================================================
// Input & Output
// ===============================================================
// System
input clk;
input rst_n;
input ctrl_restart;

// Settings
input [1:0] mode;
input condition;
input signed [5:0] shift_start_signed, shift_end_signed;

// Input
input in_valid;
input [4:0] in_CACode;
input signed [5:0] in_shift;
input [31:0] in_correlation;

// Output
output [4:0] out_CACode;
output signed [5:0] out_shift;
output reg irq;
input irq_ack;
output reg [1:0] irq_status;
output [31:0] valid_table_CACode;

// CPU
input  [11:0] ar_data;
output [31:0] DO_data;

input  [4:0]  table_in_CACode;
input  signed [5:0] table_in_shift;
output [31:0] DO_correlation;
output [31:0] DO_correlation_avg;
output [11:0] DO_idx_halfchip;
input  [4:0] ar_shift_max_CACode;
output signed [5:0] DO_shift_max;

// Debug
output [4:0]  debug_CACode;
output [5:0]  debug_shift_unsigned;
output [5:0]  debug_shift_end_unsigned;
output [11:0] debug_cnt_data;

//================================================================
// Parameters & Integer
//================================================================
localparam  mode_all                       = 2'd0,
            mode_single_CACode_multi_shift = 2'd1,
            mode_debug                     = 2'd2;

localparam  condition_3max = 1'd0,
            condition_max  = 1'd1;

integer i, j;
//================================================================
// Register & Wire
//================================================================
// Input
wire [5:0] shift_unsigned;
wire [5:0] shift_start_unsigned, shift_end_unsigned;
wire [5:0] table_in_shift_unsigned;

// Input Delay
reg [4:0] CACode;
reg [5:0] shift_signed;
reg [4:0] CACode_q;
reg [5:0] shift_unsigned_q;

// IFFT Output Counter
reg  [11:0] cnt_data;
wire is_cnt_data_eq_0;
wire is_cnt_data_eq_4095;
reg is_cnt_data_eq_4095_q;
reg is_cnt_data_eq_4095_q_q;
reg is_cnt_data_eq_4095_q_q_q;

// comparator
// correlation_data_sorted[2] := 1st correlation in 4096 data
// correlation_data_sorted[1] := 2nd correlation in 4096 data
// correlation_data_sorted[0] := 3rd correlation in 4096 data
// Premise: 1st ≥ 2nd ≥ 3rd
reg  [31:0] correlation_sorted [2:0];
reg  [11:0] idx_halfchip [2:0];

// Comparator
wire [31:0] cmp_A[2:0], cmp_B[2:0];
wire iscmp_A_gt_B[2:0];

// Comparator Condition
wire is_chip_1st_gt_2nd, is_chip_2nd_gt_3rd, is_chip_1st_gt_3rd;
reg [11:0] chip_max, chip_mid, chip_min;
wire [11:0] diff_chip_max_mid, diff_chip_max_min, diff_chip_mid_min;
wire is_diff_chip_max_mid_valid, is_diff_chip_max_min_valid, is_diff_chip_mid_min_valid;
wire valid_3max;
reg  valid_condition;
wire [10:0] addr_RAM;
reg  [10:0] addr_RAM_q, addr_RAM_q_q, addr_RAM_q_q_q;

// table_data
wire [11:0] addr_RAM_data;
wire [31:0] DI_RAM_data;
wire [31:0] DO_RAM_data;
wire        WE_RAM_data;

// table_idx_halfchip
wire [10:0] addr_RAM_idx_halfchip;
reg  [11:0] DI_RAM_idx_halfchip;
wire [11:0] DO_RAM_idx_halfchip;
wire        WE_RAM_idx_halfchip;

// table_correlation
wire [10:0] ar_correlation;
wire [10:0] addr_RAM_correlation;
wire [31:0] DI_RAM_correlation;
wire [31:0] DO_RAM_correlation;
wire        WE_RAM_correlation;

// table_shift
wire [4:0] addr_RAM_shift;
wire       WE_RAM_shift;
wire [5:0] DI_RAM_shift;
wire [5:0] DO_RAM_shift;

reg [40:0] valid_table_correlation[31:0]; // CACode(32 words) x shift(41 bits)

// table_max_correlation_shift
reg [31:0] correlation_max_per_CACode;
reg [5:0]  shift_signed_with_correlation_max;

wire [31:0] cmp_CACode_A, cmp_CACode_B;
wire iscmp_CACode_A_gt_B;

// Accumulator
wire [31:0] accum_in_data;
wire accum_first_data; // pulse signal
wire [31:0] accum_out_data;
wire accum_err;
wire accum_in_data_of; // overflow
wire accum_in_data_uf; // underflow
wire accum_out_data_of; // overflow

wire in_correlation_sign;
wire [7:0]  in_correlation_exp;
wire [22:0] in_correlation_frac;
wire [7:0] in_correlation_exp_div_4096;

// table_correlation_avg
wire [10:0] addr_RAM_correlation_avg;
wire [31:0] DI_RAM_correlation_avg;
wire [31:0] DO_RAM_correlation_avg;
wire        WE_RAM_correlation_avg;

//================================================================
// Instance
//================================================================
// Length : 32   [bits]  (32-bits correlation single floating point)
// Depth  : 4096 [words] (4096 data)
RAM_32x4096 u_RAM_data(
	.clock(clk),
	.wren(WE_RAM_data),
	.address(addr_RAM_data),
	.data(DI_RAM_data),
	.q(DO_RAM_data)
);

// Length : 12   [bits]  (index of halfchip, 0~2045)
// Depth  : 2048 [words] (32 [CACode] x 41 [shift])
RAM_12x2048_idx_halfchip u_RAM_idx_halfchip(
	.clock(clk),
	.address(addr_RAM_idx_halfchip),
	.wren(WE_RAM_idx_halfchip),
	.data(DI_RAM_idx_halfchip),
	.q(DO_RAM_idx_halfchip)
);

// Length : 32   [bits]  (32-bits correlation single floating point)
// Depth  : 2048 [words] (32 [CACode] x 41 [shift])
RAM_32x2048_correlation u_RAM_correlation(
	.clock(clk),
	.address(addr_RAM_correlation),
	.wren(WE_RAM_correlation),
	.data(DI_RAM_correlation),
	.q(DO_RAM_correlation)
);

// Length : 6  [bits]  (signed shift with correlation max in a CACode, -20~+20)
// Depth  : 32 [words] (32 [CACode])
RAM_6x32_shift u_RAM_shift(
	.clock(clk),
    .address(addr_RAM_shift),
	.wren(WE_RAM_shift),
	.data(DI_RAM_shift),
	.q(DO_RAM_shift)
);

// Format  : Single Floating Point
// Latency : 0 cycle
// Output  : a greater than b (a>b)
genvar i_cmp;
generate
    for(i_cmp=0;i_cmp<3;i_cmp=i_cmp+1) begin:FP_compare
        FP_compare u_FP_compare(
            .clk(clk),
            .areset(!rst_n),
            .a(cmp_A[i_cmp]),
            .b(cmp_B[i_cmp]),
            .q(iscmp_A_gt_B[i_cmp])
        );
    end
endgenerate

FP_compare u_FP_compare_CACode(
    .clk(clk),
    .areset(!rst_n),
    .a(cmp_CACode_A),
    .b(cmp_CACode_B),
    .q(iscmp_CACode_A_gt_B)
);

// Format : Single Floating Point
// maxMSBX : 17
// MSBA : 30
// LSBA : -26
// Target Frequency : 50 MHz
// Latency : 3 cycle
FP_accumulator u_FP_accumulator(
    .clk(clk),
	.areset(!rst_n),
	.x(accum_in_data),
	.n(accum_first_data),
	.r(accum_out_data),
	.xo(accum_in_data_of),
	.xu(accum_in_data_uf),
	.ao(accum_out_data_of)
);

// Length : 32   [bits]  (32-bits average correlation single floating point)
// Depth  : 2048 [words] (32 [CACode] x 41 [shift])
RAM_32x2048_correlation u_RAM_correlation_avg(
	.clock(clk),
	.address(addr_RAM_correlation_avg),
	.wren(WE_RAM_correlation_avg),
	.data(DI_RAM_correlation_avg),
	.q(DO_RAM_correlation_avg)
);
//================================================================
// Design
//================================================================
// Design - Input
assign shift_unsigned = (shift_signed + 6'd20);
assign shift_start_unsigned = (shift_start_signed + 6'd20);
assign shift_end_unsigned   = (shift_end_signed + 6'd20);
assign table_in_shift_unsigned = (table_in_shift + 6'd20);

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        CACode <= 'b0;
        shift_signed <= 'b0;
    end
    else begin
        if(in_valid) begin
            CACode <= in_CACode;
            shift_signed <= in_shift;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        CACode_q <= 'b0;
        shift_unsigned_q <= 'b0;
    end
    else begin
        CACode_q <= CACode;
        shift_unsigned_q <= shift_unsigned;
    end
end

// Design - IFFT Output Counter
assign is_cnt_data_eq_0 = (cnt_data==12'd0);
assign is_cnt_data_eq_4095 = (cnt_data==12'd4095);
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        cnt_data <= 'b0;
        is_cnt_data_eq_4095_q <= 'b0;
        is_cnt_data_eq_4095_q_q <= 'b0;
        is_cnt_data_eq_4095_q_q_q <= 'b0;
    end
    else begin
        is_cnt_data_eq_4095_q <= is_cnt_data_eq_4095;
        is_cnt_data_eq_4095_q_q <= is_cnt_data_eq_4095_q;
        is_cnt_data_eq_4095_q_q_q <= is_cnt_data_eq_4095_q_q;
        if(in_valid) begin
            cnt_data <= (cnt_data + 12'b1);
        end
    end
end

// Design - correlation comparator
assign cmp_A[0] = in_correlation;
assign cmp_B[0] = correlation_sorted[0]; // [0] min

assign cmp_A[1] = in_correlation;
assign cmp_B[1] = correlation_sorted[1];

assign cmp_A[2] = in_correlation;
assign cmp_B[2] = correlation_sorted[2]; // [2] max

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i=0;i<3;i=i+1) begin
            correlation_sorted[i] <= 'b0;
            idx_halfchip[i] <= 'b0;
        end
    end
    else begin
        if(ctrl_restart) begin
            for(i=0;i<3;i=i+1) begin
                correlation_sorted[i] <= 'b0;
                idx_halfchip[i] <= 'b0;
            end
        end
        else if(in_valid && is_cnt_data_eq_0) begin
            correlation_sorted[2] <= in_correlation;
            idx_halfchip[2] <= cnt_data;
            for(i=0;i<2;i=i+1) begin
                correlation_sorted[i] <= 'b0;
                idx_halfchip[i] <= 'b0;
            end
        end
        else if(in_valid) begin
            // 3'b000: n ≤ 1st, n ≤ 2nd, n ≤ 3rd => 1st ≥ 2nd ≥ 3rd ≥ n
            // 3'b001: n ≤ 1st, n ≤ 2nd, n ≥ 3rd => 1st ≥ 2nd ≥ n ≥ 3rd
            // 3'b010: n ≤ 1st, n ≥ 2nd, n ≤ 3rd => 1st ≥ 2nd = 3rd = n
            // 3'b011: n ≤ 1st, n ≥ 2nd, n ≥ 3rd => 1st ≥ n ≥ 2nd ≥ 3rd
            // 3'b100: n ≥ 1st, n ≤ 2nd, n ≤ 3rd => 1st = 2nd = 3rd = n
            // 3'b101: n ≥ 1st, n ≤ 2nd, n ≥ 3rd => 1st = 2nd = n ≥ 3rd
            // 3'b110: n ≥ 1st, n ≥ 2nd, n ≤ 3rd => 1st = 2nd = 3rd = n
            // 3'b111: n ≥ 1st, n ≥ 2nd, n ≥ 3rd => n ≥ 1st ≥ 2nd ≥ 3rd
            case({iscmp_A_gt_B[2],iscmp_A_gt_B[1],iscmp_A_gt_B[0]})
                3'b001: begin
                    correlation_sorted[0] <= in_correlation;
                    idx_halfchip[0]       <= cnt_data;
                end
                3'b011: begin
                    correlation_sorted[1] <= in_correlation;
                    correlation_sorted[0] <= correlation_sorted[1];
                    idx_halfchip[1]       <= cnt_data;
                    idx_halfchip[0]       <= idx_halfchip[1];
                end
                3'b101: begin
                    correlation_sorted[0] <= in_correlation;
                    idx_halfchip[0]       <= cnt_data;
                end
                3'b111: begin
                    correlation_sorted[2] <= in_correlation;
                    correlation_sorted[1] <= correlation_sorted[2];
                    correlation_sorted[0] <= correlation_sorted[1];
                    idx_halfchip[2]       <= cnt_data;
                    idx_halfchip[1]       <= idx_halfchip[2];
                    idx_halfchip[0]       <= idx_halfchip[1];
                end
            endcase
        end
    end
end

// Design - Comparator Condition
assign is_chip_1st_gt_2nd = (idx_halfchip[2]>=idx_halfchip[1]);
assign is_chip_2nd_gt_3rd = (idx_halfchip[1]>=idx_halfchip[0]);
assign is_chip_1st_gt_3rd = (idx_halfchip[2]>=idx_halfchip[0]);
always @(*) begin
    // 3'b000: 1st ≤ 2nd, 2nd ≤ 3rd, 1st ≤ 3rd => 1st([2]) ≤ 2nd([1]) ≤ 3rd([0])
    // 3'b001: 1st ≤ 2nd, 2nd ≤ 3rd, 1st > 3rd => Impossible
    // 3'b010: 1st ≤ 2nd, 2nd > 3rd, 1st ≤ 3rd => 1st([2]) ≤ 3rd([0]) < 2nd([1])
    // 3'b011: 1st ≤ 2nd, 2nd > 3rd, 1st > 3rd => 3rd([0]) < 1st([2]) ≤ 2nd([1])
    // 3'b100: 1st > 2nd, 2nd ≤ 3rd, 1st ≤ 3rd => 2nd([1]) < 1st([2]) ≤ 3rd([0])
    // 3'b101: 1st > 2nd, 2nd ≤ 3rd, 1st > 3rd => 2nd([1]) ≤ 3rd([0]) < 1st([2])
    // 3'b110: 1st > 2nd, 2nd > 3rd, 1st ≤ 3rd => Impossible
    // 3'b111: 1st > 2nd, 2nd > 3rd, 1st > 3rd => 3rd([0]) < 2nd([1]) < 1st([2])
    case({is_chip_1st_gt_2nd, is_chip_2nd_gt_3rd, is_chip_1st_gt_3rd})
        3'b000: begin
            chip_max = idx_halfchip[0];
            chip_mid = idx_halfchip[1];
            chip_min = idx_halfchip[2];
        end
        3'b010: begin
            chip_max = idx_halfchip[1];
            chip_mid = idx_halfchip[0];
            chip_min = idx_halfchip[2];
        end
        3'b011: begin
            chip_max = idx_halfchip[1];
            chip_mid = idx_halfchip[2];
            chip_min = idx_halfchip[0];
        end
        3'b100: begin
            chip_max = idx_halfchip[0];
            chip_mid = idx_halfchip[2];
            chip_min = idx_halfchip[1];
        end
        3'b101: begin
            chip_max = idx_halfchip[2];
            chip_mid = idx_halfchip[0];
            chip_min = idx_halfchip[1];
        end
        3'b111: begin
            chip_max = idx_halfchip[2];
            chip_mid = idx_halfchip[1];
            chip_min = idx_halfchip[0];
        end
        default: begin
            // 3'b001, 3'b110: Impossible
            chip_max = 'b0;
            chip_mid = 'b0;
            chip_min = 'b0;
        end
    endcase
end

assign diff_chip_max_mid = (chip_max - chip_mid);
assign diff_chip_max_min = (chip_max - chip_min);
assign diff_chip_mid_min = (chip_mid - chip_min);
assign is_diff_chip_max_mid_valid = ((diff_chip_max_mid==12'd2046) || (diff_chip_max_mid==12'd2050));
assign is_diff_chip_max_min_valid = ((diff_chip_max_min==12'd2046) || (diff_chip_max_min==12'd2050));
assign is_diff_chip_mid_min_valid = ((diff_chip_mid_min==12'd2046) || (diff_chip_mid_min==12'd2050));
assign valid_3max = (   is_diff_chip_max_mid_valid || 
                        is_diff_chip_max_min_valid || 
                        is_diff_chip_mid_min_valid);

always @(*) begin
    case(condition)
        condition_3max: valid_condition = (is_cnt_data_eq_4095_q && valid_3max);
        condition_max:  valid_condition = is_cnt_data_eq_4095_q;
    endcase
end

// Design - table_data
assign addr_RAM_data = in_valid?cnt_data:ar_data;
assign WE_RAM_data   = in_valid;
assign DI_RAM_data   = in_correlation;
assign DO_data = DO_RAM_data;

// Design - valid_table_correlation
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(j=0;j<32;j=j+1) begin
            valid_table_correlation[j] <= 'b0;
        end
    end
    else begin
        if(ctrl_restart) begin
            for(j=0;j<32;j=j+1) begin
                valid_table_correlation[j] <= 'b0;
            end
        end
        else if(is_cnt_data_eq_4095_q) begin
            valid_table_correlation[CACode][shift_unsigned] <= valid_condition;
        end
    end
end

// Design - table_idx_halfchip
assign ar_correlation = {table_in_CACode, table_in_shift_unsigned};
assign addr_RAM = {CACode, shift_unsigned};

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        addr_RAM_q <= 'b0;
        addr_RAM_q_q <= 'b0;
        addr_RAM_q_q_q <= 'b0;
    end
    else begin
        addr_RAM_q <= addr_RAM;
        addr_RAM_q_q <= addr_RAM_q;
        addr_RAM_q_q_q <= addr_RAM_q_q;
    end
end

assign addr_RAM_idx_halfchip = WE_RAM_idx_halfchip?addr_RAM_q:ar_correlation;
assign WE_RAM_idx_halfchip = is_cnt_data_eq_4095_q;
assign DO_idx_halfchip = DO_RAM_idx_halfchip;
always @(*) begin
    case(condition)
        condition_3max: begin
            case({is_diff_chip_max_mid_valid, is_diff_chip_max_min_valid, is_diff_chip_mid_min_valid})
                3'b100:  DI_RAM_idx_halfchip = chip_mid;
                3'b010:  DI_RAM_idx_halfchip = chip_min;
                3'b001:  DI_RAM_idx_halfchip = chip_min;
                default: DI_RAM_idx_halfchip = 12'b0;
            endcase
        end
        condition_max: begin
            DI_RAM_idx_halfchip = idx_halfchip[2];
        end
    endcase
end

// Design - table_correlation
assign addr_RAM_correlation = WE_RAM_correlation?addr_RAM_q:ar_correlation;
assign DI_RAM_correlation = correlation_sorted[2];
assign WE_RAM_correlation = is_cnt_data_eq_4095_q;
assign DO_correlation = DO_RAM_correlation;

// Design - table_max_correlation_shift
genvar i_table;
generate
    for(i_table=0;i_table<32;i_table=i_table+1) begin:valid_table
        assign valid_table_CACode[i_table] = (|valid_table_correlation[i_table]);
    end
endgenerate

assign cmp_CACode_A = correlation_sorted[2];
assign cmp_CACode_B = correlation_max_per_CACode;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        correlation_max_per_CACode <= 'b0;
        shift_signed_with_correlation_max <= 'b0;
    end
    else begin
        if( (is_cnt_data_eq_4095_q && shift_unsigned==shift_start_unsigned) || 
            (valid_condition && shift_unsigned!=shift_start_unsigned && iscmp_CACode_A_gt_B)) begin
            correlation_max_per_CACode <= cmp_CACode_A;
            shift_signed_with_correlation_max <= shift_signed;
        end
    end
end

// Design - table_shift
assign WE_RAM_shift   = (is_cnt_data_eq_4095_q_q && shift_unsigned_q==shift_end_unsigned);
assign addr_RAM_shift = WE_RAM_shift?CACode_q:ar_shift_max_CACode;
assign DI_RAM_shift   = shift_signed_with_correlation_max;

assign DO_shift_max = DO_RAM_shift;

// Design - accumulator
assign accum_err = (accum_in_data_of | accum_in_data_uf | accum_out_data_of);
assign in_correlation_sign = in_correlation[31];
assign in_correlation_exp = in_correlation[23+:8];
assign in_correlation_frac = in_correlation[0+:23];
assign in_correlation_exp_div_4096 = in_correlation_exp - 8'd12;

assign accum_in_data = in_valid?{in_correlation_sign, in_correlation_exp_div_4096, in_correlation_frac}:'b0;
assign accum_first_data = (in_valid && is_cnt_data_eq_0);

// Design - table_correlation_avg
assign addr_RAM_correlation_avg = WE_RAM_correlation_avg?addr_RAM_q_q_q:ar_correlation;
assign WE_RAM_correlation_avg = is_cnt_data_eq_4095_q_q_q;
assign DI_RAM_correlation_avg = accum_err?32'b0:accum_out_data;
assign DO_correlation_avg = DO_RAM_correlation_avg;
//================================================================
// Design - Output
assign out_CACode = CACode;
assign out_shift = shift_signed;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        irq <= 'b0;
    end
    else begin
        if( (mode==mode_all && CACode==5'd31 && shift_unsigned==shift_end_unsigned && is_cnt_data_eq_4095_q) ||
            (mode==mode_single_CACode_multi_shift && shift_unsigned==shift_end_unsigned && is_cnt_data_eq_4095_q) ||
            (mode==mode_debug && is_cnt_data_eq_4095_q)) begin
            irq <= 'b1;
        end

        if(irq_ack) begin
            irq <= 'b0;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        irq_status <= 'd3;
    end
    else begin
        if(CACode==5'd31 && shift_unsigned==shift_end_unsigned && is_cnt_data_eq_4095_q) begin
            irq_status <= 'd0;
        end
        else if(shift_unsigned==shift_end_unsigned && is_cnt_data_eq_4095_q) begin
            irq_status <= 'd1;
        end
        else if(is_cnt_data_eq_4095_q) begin
            irq_status <= 'd2;
        end
        else begin
            irq_status <= 'd3;
        end
    end
end

// Debug
assign debug_CACode = CACode;
assign debug_shift_unsigned = shift_unsigned;
assign debug_shift_end_unsigned = shift_end_unsigned;
assign debug_cnt_data = cnt_data;
endmodule