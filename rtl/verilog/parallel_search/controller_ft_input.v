module controller_ft_input(
    // System
    clk,
    rst_n,
    ctrl_restart,
    // Setting
    mode,
    CACode_id,
    // Input - signal
    in_valid_processing,
    in_real_processing,
    in_imag_processing,
    // Input - cacode
    out_valid_CACode,
    out_CACode,
    in_valid_CACode,
    in_data_CACode,
    // Input - convolution
    in_valid_conv,
    in_shift_conv,
    in_data_real_conv,
    in_data_imag_conv,
    // Input - controller_ft_output
    in_last_shift,
    // Output - ft
    FTIn_inverse,
    FTIn_valid,
    FTIn_ready,
	FTIn_first,
    FTIn_last,
    FTIn_real,
    FTIn_imag,
    FTIn_error,
    FTIn_pts,
    // Output - FIFO
    wrreq_FIFO_FT,
    DI_FIFO_FT,
    // Debug
    debug_state,
    debug_cnt_FTIn
);
// ===============================================================
// Input & Output
// ===============================================================
// System
input clk;
input rst_n;

input ctrl_restart;

// Input - settings
input [1:0] mode;
input [4:0] CACode_id;

// Input - signal
input        in_valid_processing;
input [31:0] in_real_processing, in_imag_processing;

// Input - CACode
output [4:0]  out_CACode;
output        out_valid_CACode;
input         in_valid_CACode;
input  [31:0] in_data_CACode;

// Input - convolution
input        in_valid_conv;
input [5:0]  in_shift_conv; // signed
input [31:0] in_data_real_conv, in_data_imag_conv;

// Input - controller_ft_output
input        in_last_shift;

// Output - FT(Fourier Transform)
output reg        FTIn_inverse;
output            FTIn_valid;
input             FTIn_ready;
output            FTIn_first, FTIn_last;
output reg [31:0] FTIn_real, FTIn_imag;
output     [1:0]  FTIn_error;
output     [12:0] FTIn_pts;

// Output - FIFO_FT
output wrreq_FIFO_FT;
output [11:0] DI_FIFO_FT;

// Debug
output [1:0]  debug_state;
output [11:0] debug_cnt_FTIn;

//================================================================
// Parameters & Integer
//================================================================
localparam  inverse_FFT  = 1'b0,
            inverse_IFFT = 1'b1;

localparam  state_signal_input      = 2'd0,
            state_CACode_input      = 2'd1,
            state_convolution_input = 2'd2;

localparam  mode_all                       = 2'd0,
            mode_single_CACode_multi_shift = 2'd1,
            mode_debug                     = 2'd2;

//================================================================
// Register & Wire
//================================================================
// state
reg [1:0] state, state_q;

// CACode
reg [4:0] CACode;

// FT
wire FTIn_valid_ready;
reg [11:0] cnt_FTIn;
wire iscnt_FTIn_eq_0, iscnt_FTIn_eq_4095;    // eq := equal to

//================================================================
// Design
//================================================================
// Design - State
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        state <= state_signal_input;
    end
    else begin
        case(state)
            state_signal_input: begin
                if(in_valid_processing && FTIn_last) begin
                    state <= state_CACode_input;
                end
            end
            state_CACode_input: begin
                if(in_valid_CACode & FTIn_last) begin
                    state <= state_convolution_input;
                end
            end
            state_convolution_input: begin
                if(in_last_shift) begin
                    state <= (  (mode!=mode_single_CACode_multi_shift && CACode==5'd31) || 
                                (mode==mode_single_CACode_multi_shift))?state_signal_input:state_CACode_input;
                end
            end
        endcase
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        state_q <= state_signal_input;
    end
    else begin
        state_q <= state;
    end
end

// Design - CACode Generator
assign out_CACode = CACode;
// 1. state_signal_input      -> state_CACode_input
// 2. state_convolution_input -> state_CACode_input
assign out_valid_CACode = (state==state_CACode_input && state_q!=state_CACode_input);

// Design - CACode
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        CACode <= 'b0;
    end
    else begin
        if(ctrl_restart) begin
            CACode <= 'b0;
        end
        else begin
            case(mode)
                mode_all, mode_debug: begin
                    if(state==state_convolution_input && in_last_shift) begin
                        CACode <= CACode + 5'd1;
                    end
                end
                mode_single_CACode_multi_shift: begin
                    CACode <= CACode_id;
                end
            endcase
        end
        
    end
end

// Design - FT Input Counter
assign iscnt_FTIn_eq_0    = (!(|cnt_FTIn));
assign iscnt_FTIn_eq_4095 = (&cnt_FTIn);
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        cnt_FTIn <= 'b0;
    end
    else begin
        if(FTIn_valid_ready) begin
            cnt_FTIn <= cnt_FTIn + 12'd1;
        end
    end
end

// Design - FT Input
// inverse(FTIn_inverse) sample at sop
always @(*) begin
    case({in_valid_CACode, in_valid_processing, in_valid_conv})
        3'b100: begin
            FTIn_inverse = inverse_FFT;
            FTIn_real = in_data_CACode;
            FTIn_imag = 'b0;
        end
        3'b010: begin
            FTIn_inverse = inverse_FFT;
            FTIn_real = in_real_processing;
            FTIn_imag = in_imag_processing;
        end
        3'b001: begin
            FTIn_inverse = inverse_IFFT;
            FTIn_real = in_data_real_conv;
            FTIn_imag = in_data_imag_conv;
        end
        default: begin
            FTIn_inverse = inverse_FFT;
            FTIn_real = 'b0;
            FTIn_imag = 'b0;
        end
    endcase
end

assign FTIn_first = (FTIn_valid_ready && iscnt_FTIn_eq_0);
assign FTIn_last  = (FTIn_valid_ready && iscnt_FTIn_eq_4095);

assign FTIn_valid = (in_valid_processing || in_valid_CACode || in_valid_conv);
assign FTIn_valid_ready = (FTIn_valid && FTIn_ready);

// Only sample at SOP
// When changing FTIn_pts, the FFT system will briefly stall on FTIn_ready.
// However, we are unable to stall the signal input or CACode input.
assign FTIn_pts = 13'd4096;

// Error Code
// 2'd0: no error
// 2'd1: miss sop
// 2'd2: miss eop
// 2'd3: unexpected eop
assign FTIn_error = 2'b0;

// Design - FIFO_FT
assign DI_FIFO_FT    = {CACode, in_shift_conv, FTIn_inverse};
assign wrreq_FIFO_FT = FTIn_first;

// Debug
assign debug_state = state;
assign debug_cnt_FTIn = cnt_FTIn;
endmodule