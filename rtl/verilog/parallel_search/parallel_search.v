module parallel_search
(   
    // Clock ------------------------
    clk,
    // Reset ------------------------
    rst_n,
    // Input ------------------------
    in_valid,
    I, 
    Q,
    // Ctrl -------------------------
    ctrl_start,
    ctrl_done,
    ctrl_idle,
    // Status -----------------------
    state,
    // Settings ---------------------
    set_mode,
    set_condition,
    // Input Record -----------------
    table_CDC_in_address,
    table_CDC_out_data,
    // Correlation Record -----------
    irq,
    irq_ack,
    // Correlation Record(Mode#0) ---
    table_in_CACode,
    table_in_shift,
    table_out_correlation,
    table_out_correlation_avg,
    table_out_chip_offset,
    table_max_valid,
    table_max_in_CACode,
    table_max_out_shift,
    // Correlation Record(Mode#1) ---
    set_CACode_id,
    set_shift_center,
    set_shift_width,
    // Correlation Record(Mode#2) ---
    table_data_in_index,
    table_data_out_CACode,
    table_data_out_shift,
    table_data_out_correlation,
    table_data_read_ack,
    // Debug ------------------------
    debug_CACode,
    debug_shift_unsigned,
    debug_shift_end_unsigned,
    debug_cnt_data,
    debug_state_ft_input,
    debug_cnt_FTIn_ft_input,
    debug_state_conv,
    debug_state_CACode_generator,
    debug_cnt_data_CACode_generator
);
// ===============================================================
// Input & Output
// ===============================================================
// Clock ---------------------------------------------------------
input clk;     // 50 [MHz]

// Reset ---------------------------------------------------------
input rst_n;

// Input ---------------------------------------------------------
input in_valid;
input [1:0] I, Q; // {sign, mag}

// Control -------------------------------------------------------
input      ctrl_start; // set when module needs start, ctrl_start need reset otherwise module will start repeatly
output     ctrl_done;  // set when module processes all the dataset
output reg ctrl_idle;  // set when module is not processing data

// Status --------------------------------------------------------
output reg [1:0] state;
input  [1:0] set_mode;
input set_condition;

// Input Record --------------------------------------------------
input  [11:0] table_CDC_in_address;
output [31:0] table_CDC_out_data;

// Correlation Record --------------------------------------------
input  irq_ack;
output irq;

// Mode#0
input  [4:0]  table_in_CACode;
input  signed [5:0] table_in_shift;
output [31:0] table_out_correlation;
output [31:0] table_out_correlation_avg;
output [11:0] table_out_chip_offset;
output [31:0] table_max_valid;
input  [4:0]  table_max_in_CACode;
output signed [5:0] table_max_out_shift;

// Mode#1
input [4:0] set_CACode_id;
input [5:0] set_shift_center; // -20 ~ 0 ~ +20
input [4:0] set_shift_width;  // 0~20

// Mode#2
input  [11:0] table_data_in_index;
output [4:0]  table_data_out_CACode;
output [5:0]  table_data_out_shift;
output [31:0] table_data_out_correlation;
input  table_data_read_ack;

// Debug ---------------------------------------------------------
output [4:0]  debug_CACode;
output [5:0]  debug_shift_unsigned;
output [5:0]  debug_shift_end_unsigned;
output [11:0] debug_cnt_data;
output [1:0]  debug_state_ft_input;
output [11:0] debug_cnt_FTIn_ft_input;
output [1:0]  debug_state_conv;
output debug_state_CACode_generator;
output [11:0] debug_cnt_data_CACode_generator;

//================================================================
// Parameters & Integer
//================================================================
localparam  state_idle  = 2'd0,
            state_FFT   = 2'd1,
            state_IFFT  = 2'd2;

localparam  mode_all                       = 2'd0,
            mode_single_CACode_multi_shift = 2'd1,
            mode_debug                     = 2'd2;

localparam  shift_head = -6'd20, 
            shift_tail =  6'd20;
//================================================================
// Register & Wire
//================================================================
// Design - Settings, only latch on pulse of start_data_process_d
reg [1:0] mode;
reg [4:0] CACode_id;
reg condition;
wire signed [6:0] shift_start_7bits, shift_end_7bits;
wire signed [5:0] shift_start_bounded, shift_end_bounded;
reg [5:0] shift_start_signed, shift_end_signed;

// Design - signal
reg  start_data_process;
wire start_data_process_d;

// IP - FT (Fourier Transform)
wire        FTIn_inverse;
wire        FTIn_valid, FTIn_ready;
wire        FTIn_first, FTIn_last;
wire [12:0] FTIn_pts;
wire [31:0] FTIn_real, FTIn_imag;
wire [1:0]  FTIn_error;
wire        FTOut_valid, FTOut_ready;
wire        FTOut_first, FTOut_last;
wire [12:0] FTOut_pts;
wire [31:0] FTOut_real, FTOut_imag;
wire [1:0]  FTOut_error;

// IP - FIFO_FT
wire [11:0] DI_FIFO_FT, DO_FIFO_FT;
wire rdreq_FIFO_FT, wrreq_FIFO_FT;
wire empty_FIFO_FT;

// Design - signal_processing
wire        valid_processing;
wire [31:0] data_real_processing, data_imag_processing;

// Design - CACode_generator
wire        in_valid_CAcode;
wire [4:0]  in_CACode;
wire        out_valid_CACode;
wire [31:0] out_data_CACode;

// Design - arbiter_ft_output
wire        valid_signal_conv;
wire        in_valid_RAM_CACode_conv;
wire        in_valid_FTOut_last;
wire [31:0] in_data_real_conv, in_data_imag_conv;
wire        in_valid_corr;
wire [4:0]  in_CACode_corr;
wire [5:0]  in_shift_corr;
wire [31:0] in_data_real_corr, in_data_imag_corr;

// Design - convolution
wire [5:0]  out_shift_conv;
wire        out_last_shift_ft_output;
wire        out_valid_conv;
wire [31:0] out_data_real_conv, out_data_imag_conv;

// Design - correlation
wire        out_valid_corr;
wire [4:0]  out_CACode_corr;
wire [5:0]  out_shift_corr;
wire [31:0] correlation;

// Design - correlation_processing
wire [1:0] irq_status;

//================================================================
// Design
//================================================================
// Instance - FT
// Length : 4096, Direction : bi-directional
// Data Flow : Variable Streaming
// Input Order : Natural, Output Order : Digit Reverse
// Data Representation : Single Floating Point
// Latency : 4096 cycle
FFT_IFFT u_FT (
    .clk          (clk),
    .reset_n      (rst_n),
    .inverse      (FTIn_inverse),
    // Input ==========================================
    .sink_valid   (FTIn_valid),
    .sink_ready   (FTIn_ready),
    .sink_error   (FTIn_error),
    .sink_sop     (FTIn_first),
    .sink_eop     (FTIn_last),
    .sink_real    (FTIn_real),
    .sink_imag    (FTIn_imag),
    .fftpts_in    (FTIn_pts),
    // Output ==========================================
    .source_valid (FTOut_valid),
    .source_ready (FTOut_ready),
    .source_error (FTOut_error),
    .source_sop   (FTOut_first),
    .source_eop   (FTOut_last),
    .source_real  (FTOut_real),
    .source_imag  (FTOut_imag),
    .fftpts_out   (FTOut_pts)
);

// Instance - FIFO_FT
// Length : 12 [bits] ([11:7]:CACode, [6:1]:shift, [0]:inverse)
// Notice : shift value are valid at inverse = inverse_IFFT(1)
// Depth : 8 [words]
// optional control signal : empty, synchronous clear
// read access of rdreq signal : show-ahead synchronous FIFO mode
// Description : Record inverse(FFT or IFFT) from input to output
FIFO_FT u_FIFO_FT (
	.clock(clk),
    .sclr(start_data_process),
	.wrreq(wrreq_FIFO_FT),
	.data(DI_FIFO_FT),
	.rdreq(rdreq_FIFO_FT),
	.empty(empty_FIFO_FT),
	.q(DO_FIFO_FT)
);

//================================================================
// Design - state
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        state <= state_idle;
    end
    else begin
        case(state)
            state_idle: begin
                if(start_data_process) begin
                    state <= state_FFT;
                end
            end
            state_FFT: begin
                if(FTOut_valid & FTOut_last) begin
                    state <= state_IFFT;
                end
            end
            state_IFFT: begin
                if(ctrl_done) begin
                    state <= state_idle;
                end
            end
        endcase
    end
end

//================================================================
// Design - Control
assign start_data_process_d = (ctrl_start & ctrl_idle);
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        ctrl_idle <= 'b1;
        start_data_process <= 'b0;
    end
    else begin
        start_data_process <= start_data_process_d;
        if(start_data_process_d) begin
            ctrl_idle <= 'b0;
        end
        if(ctrl_done) begin
            ctrl_idle <= 'b1;
        end
    end
end

assign ctrl_done = ((((mode==mode_all || (mode==mode_single_CACode_multi_shift && CACode_id==5'd31) || mode==mode_debug) && irq_status==2'd0) || 
                     (mode==mode_single_CACode_multi_shift && CACode_id!=5'd31 && irq_status==2'd1)));
//================================================================
// Design - Input
// shift range = center-width to center+width
// shift values beyond this range will be confined to -20 to +20
assign shift_start_7bits = {set_shift_center[5], set_shift_center}-{2'b0, set_shift_width};
assign shift_end_7bits   = {set_shift_center[5], set_shift_center}+{2'b0, set_shift_width};
assign shift_start_bounded = (shift_start_7bits<$signed(-7'd20))?shift_head:shift_start_7bits[5:0];
assign shift_end_bounded   = (shift_end_7bits>$signed(7'd20))?shift_tail:shift_end_7bits[5:0];

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        mode         <= 'b0;
        CACode_id    <= 'b0;
        condition    <= 'b0;
        shift_start_signed <= shift_head;
        shift_end_signed   <= shift_tail;
    end
    else begin
        if(start_data_process) begin
            mode        <= set_mode;
            CACode_id   <= set_CACode_id;
            condition   <= set_condition;
            shift_start_signed <= (set_mode==mode_single_CACode_multi_shift)?shift_start_bounded:shift_head;
            shift_end_signed   <= (set_mode==mode_single_CACode_multi_shift)?shift_end_bounded:shift_tail;
        end
    end
end
//================================================================
signal_processing u_signal_processing(
    .clk(clk),
    .rst_n(rst_n),
    .in_valid(in_valid),
    .I(I),
    .Q(Q),
    .out_valid(valid_processing),
    .out_real(data_real_processing),
    .out_imag(data_imag_processing),
    .signal_start(start_data_process),
    .ar_RAM_cpu(table_CDC_in_address),
    .DO_RAM_cpu(table_CDC_out_data)
);

CACode_generator u_CACode_generator(
    .clk(clk),
    .rst_n(rst_n),
    .in_valid(in_valid_CAcode),
    .in_CACode(in_CACode),
    .out_valid(out_valid_CACode),
    .out_data(out_data_CACode),
    .debug_state(debug_state_CACode_generator),
    .debug_cnt_data(debug_cnt_data_CACode_generator)
);

controller_ft_input u_controller_ft_input(
    .clk(clk),
    .rst_n(rst_n),
    .ctrl_restart(start_data_process),
    .mode(mode),
    .CACode_id(CACode_id),
    .in_valid_processing(valid_processing),
    .in_real_processing(data_real_processing),
    .in_imag_processing(data_imag_processing),
    .out_valid_CACode(in_valid_CAcode),
    .out_CACode(in_CACode),
    .in_valid_CACode(out_valid_CACode),
    .in_data_CACode(out_data_CACode),
    .in_valid_conv(out_valid_conv),
    .in_shift_conv(out_shift_conv),
    .in_data_real_conv(out_data_real_conv),
    .in_data_imag_conv(out_data_imag_conv),
    .in_last_shift(out_last_shift_ft_output),
    .FTIn_inverse(FTIn_inverse),
    .FTIn_valid(FTIn_valid),
    .FTIn_ready(FTIn_ready),
	.FTIn_first(FTIn_first),
    .FTIn_last(FTIn_last),
    .FTIn_real(FTIn_real),
    .FTIn_imag(FTIn_imag),
    .FTIn_error(FTIn_error),
    .FTIn_pts(FTIn_pts),
    .wrreq_FIFO_FT(wrreq_FIFO_FT),
    .DI_FIFO_FT(DI_FIFO_FT),
    .debug_state(debug_state_ft_input),
    .debug_cnt_FTIn(debug_cnt_FTIn_ft_input)
);

controller_ft_output u_controller_ft_output(
    .clk(clk),
    .rst_n(rst_n),
    .ctrl_restart(start_data_process),
    .mode(mode),
    .table_data_read_ack(table_data_read_ack),
    .shift_end_signed(shift_end_signed),
    .FTOut_valid(FTOut_valid),
    .FTOut_ready(FTOut_ready),
    .FTOut_first(FTOut_first),
    .FTOut_last(FTOut_last),
    .FTOut_real(FTOut_real),
    .FTOut_imag(FTOut_imag),
    .FTOut_error(FTOut_error),
    .FTOut_pts(FTOut_pts),
    .out_valid_RAM_signal_conv(valid_signal_conv),
    .out_valid_RAM_CACode_conv(in_valid_RAM_CACode_conv),
    .out_valid_last(in_valid_FTOut_last),
    .out_data_real_conv(in_data_real_conv),
    .out_data_imag_conv(in_data_imag_conv),
    .out_valid_corr(in_valid_corr),
    .out_CACode_corr(in_CACode_corr),
    .out_shift_corr(in_shift_corr),
    .out_data_real_corr(in_data_real_corr),
    .out_data_imag_corr(in_data_imag_corr),
    .out_last_shift(out_last_shift_ft_output),
    .rdreq_FIFO_FT(rdreq_FIFO_FT),
    .empty_FIFO_FT(empty_FIFO_FT),
    .DO_FIFO_FT(DO_FIFO_FT)
);

convolution u_convolution(
    .clk(clk),
    .rst_n(rst_n),
    .mode(mode),
    .in_valid_RAM_signal(valid_signal_conv),
    .in_valid_RAM_CACode(in_valid_RAM_CACode_conv),
    .in_valid_last(in_valid_FTOut_last),
    .in_data_real(in_data_real_conv),
    .in_data_imag(in_data_imag_conv),
    .out_valid(out_valid_conv),
    .out_shift(out_shift_conv),
    .out_data_real(out_data_real_conv),
    .out_data_imag(out_data_imag_conv),
    .shift_start_signed(shift_start_signed),
    .shift_end_signed(shift_end_signed),
    .table_data_read_ack(table_data_read_ack),
    .debug_state(debug_state_conv)
);

correlation u_correlation(
    .clk(clk),
    .rst_n(rst_n),
    .in_valid(in_valid_corr),
    .in_CACode(in_CACode_corr),
    .in_shift(in_shift_corr),
    .in_data_real(in_data_real_corr),
    .in_data_imag(in_data_imag_corr),
    .out_valid(out_valid_corr),
    .out_CACode(out_CACode_corr),
    .out_shift(out_shift_corr),
    .out_correlation(correlation)
);

correlation_processing u_correlation_processing(
    .clk(clk),
    .rst_n(rst_n),
    .ctrl_restart(start_data_process),
    .mode(mode),
    .condition(condition),
    .shift_start_signed(shift_start_signed),
    .shift_end_signed(shift_end_signed),
    .in_valid(out_valid_corr),
    .in_CACode(out_CACode_corr),
    .in_shift(out_shift_corr),
    .in_correlation(correlation),
    .out_CACode(table_data_out_CACode),
    .out_shift(table_data_out_shift),
    .irq(irq),
    .irq_ack(irq_ack),
    .irq_status(irq_status),
    .ar_data(table_data_in_index),
    .DO_data(table_data_out_correlation),
    .table_in_CACode(table_in_CACode),
    .table_in_shift(table_in_shift),
    .DO_correlation(table_out_correlation),
    .DO_correlation_avg(table_out_correlation_avg),
    .DO_idx_halfchip(table_out_chip_offset),
    .valid_table_CACode(table_max_valid),
    .ar_shift_max_CACode(table_max_in_CACode),
    .DO_shift_max(table_max_out_shift),
    .debug_CACode(debug_CACode),
    .debug_shift_unsigned(debug_shift_unsigned),
    .debug_shift_end_unsigned(debug_shift_end_unsigned),
    .debug_cnt_data(debug_cnt_data)
);
endmodule