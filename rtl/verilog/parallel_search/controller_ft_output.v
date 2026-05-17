module controller_ft_output(
    // System
    clk,
    rst_n,
    ctrl_restart,
    mode,
    table_data_read_ack,
    shift_end_signed,
    // Input - FT(Fourier Transform)
    FTOut_valid,
    FTOut_ready,
    FTOut_first,
    FTOut_last,
    FTOut_real,
    FTOut_imag,
    FTOut_error,
    FTOut_pts,
    // Output - Convolution(FFT Output)
    out_valid_RAM_signal_conv,
    out_valid_RAM_CACode_conv,
    out_valid_last,
    out_data_real_conv,
    out_data_imag_conv,
    // Output - Correlation(IFFT Output)
    out_valid_corr,
    out_CACode_corr,
    out_shift_corr,
    out_data_real_corr,
    out_data_imag_corr,
    // Output - controller_ft_input
    out_last_shift,
    // Input - FIFO_FT
    rdreq_FIFO_FT,
    empty_FIFO_FT,
    DO_FIFO_FT
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
input table_data_read_ack;
input [5:0] shift_end_signed;

// Input - FT(Fourier Transform)
input         FTOut_valid;
output        FTOut_ready;
input         FTOut_first, FTOut_last;
input  [31:0] FTOut_real, FTOut_imag;
input  [1:0]  FTOut_error;
input  [12:0] FTOut_pts;

// Output - Convolution(FFT Output)
output out_valid_RAM_signal_conv;
output out_valid_RAM_CACode_conv;
output out_valid_last;
output [31:0] out_data_real_conv, out_data_imag_conv;

// Output - Correlation(IFFT Output)
output out_valid_corr;
output [4:0]  out_CACode_corr;
output [5:0]  out_shift_corr;
output [31:0] out_data_real_corr, out_data_imag_corr;

// Output - controller_ft_input
output out_last_shift;

// Input - FIFO_FT
output rdreq_FIFO_FT;
input  empty_FIFO_FT;
input  [11:0] DO_FIFO_FT;

//================================================================
// Parameters & Integer
//================================================================
localparam  state_FFT_output_signal                            = 1'd0,
            state_FFT_output_CACode_or_IFFT_output_correlation = 1'd1;

localparam  inverse_FFT  = 1'b0,
            inverse_IFFT = 1'b1;

localparam  mode_all                       = 2'd0,
            mode_single_CACode_multi_shift = 2'd1,
            mode_debug                     = 2'd2;
//================================================================
// Register & Wire
//================================================================
// state
reg state;

// FT(Fourier Transform)
wire FTOut_valid_ready;

// FIFO_FT
wire [4:0] CACode;
wire [5:0] shift; // signed
wire inverse;

wire last_shift_mode_neq_debug;
reg  last_shift_mode_eq_debug_wait_for_cpu_ack;

//================================================================
// Design
//================================================================
// Design - state
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        state <= state_FFT_output_signal;
    end
    else begin
        if(ctrl_restart) begin
            state <= state_FFT_output_signal;
        end
        else if(state==state_FFT_output_signal && FTOut_valid_ready & FTOut_last) begin
            state <= state_FFT_output_CACode_or_IFFT_output_correlation;
        end
    end
end

//================================================================
// Design - FT(Fourier Transform)
assign FTOut_ready = 1'b1;
assign FTOut_valid_ready = (FTOut_valid & FTOut_ready);

// Design - FIFO_FT
assign CACode  = empty_FIFO_FT?5'b0:DO_FIFO_FT[7+:5];
assign shift   = empty_FIFO_FT?6'b0:DO_FIFO_FT[1+:6];
assign inverse = empty_FIFO_FT?1'b0:DO_FIFO_FT[0];
assign rdreq_FIFO_FT = (out_valid_last && !empty_FIFO_FT);

// Design - Convolution(FFT Output)
assign out_valid_RAM_signal_conv = (FTOut_valid_ready && state==state_FFT_output_signal);
assign out_valid_RAM_CACode_conv = (FTOut_valid_ready && 
                                    state==state_FFT_output_CACode_or_IFFT_output_correlation && 
                                    inverse==inverse_FFT);
assign out_valid_last = (FTOut_valid_ready && FTOut_last);
assign out_data_real_conv = FTOut_real;
assign out_data_imag_conv = FTOut_imag;

// Design - Correlation(IFFT Output)
assign out_valid_corr = (   FTOut_valid_ready && 
                            state==state_FFT_output_CACode_or_IFFT_output_correlation && 
                            inverse==inverse_IFFT);
assign out_data_real_corr = FTOut_real;
assign out_data_imag_corr = FTOut_imag;
assign out_CACode_corr = CACode;
assign out_shift_corr = shift;

// Design - controller_ft_input
assign last_shift_mode_neq_debug = (inverse==inverse_IFFT && shift==shift_end_signed && FTOut_last);
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        last_shift_mode_eq_debug_wait_for_cpu_ack <= 'b0;
    end
    else begin
        if(ctrl_restart) begin
            last_shift_mode_eq_debug_wait_for_cpu_ack <= 'b0;
        end
        else begin
            if(mode==mode_debug && last_shift_mode_neq_debug) begin
                last_shift_mode_eq_debug_wait_for_cpu_ack <= 'b1;
            end
            if(mode==mode_debug && table_data_read_ack) begin
                last_shift_mode_eq_debug_wait_for_cpu_ack <= 'b0;
            end
        end
    end
end

assign out_last_shift = (   (mode!=mode_debug && last_shift_mode_neq_debug) ||
                            (mode==mode_debug && last_shift_mode_eq_debug_wait_for_cpu_ack && table_data_read_ack));
endmodule