//                              -*- Mode: Verilog -*-
// Filename        : carrier_nco.v
// Description     : Generates the 8 stage carrier local oscilator.

// Author          : Peter Mumford, UNSW, 2005

/*
 * Numerically Controlled Oscillator (NCO) which replicates the
 * carrier frequency. This pseudo-sinusoid waveform consists of
 * 8 stages or phases.
 * 
 * The NCO frequency is:
 * f = fControl * Clk / 2^N
 * 
 * where:
 * f = the required carrier wave frequency
 * Clk = the system clock (= 40MHz)
 * N = 30 (bit width of the phase accumulator)
 * fControl = the 30 bit (unsigned) control word
 * 
 * The generated waveforms for I & Q look like:
 * | Phase |  0  |  1  |  2  |  3  |  4  |  5  |  6  |  7  |
 * |:-----:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
 * |   I   | -1  | +1  | +2  | +2  | +1  | -1  | -2  | -2  |
 * |   Q   | +2  | +2  | +1  | -1  | -2  | -2  | -1  | +1  |
 * The nominal center frequency for the GP2015 is:
 * IF = 1.405396825MHz
 * Clk = 40 MHz
 * fControl = 2^N * IF / Clk
 * fControl = 0x23FA689 for center frequency
 * 
 * Resolution:
 * fControl increment value = 0.037252902 Hz
 * Put another way:
 * 37mHz is the smallest change in carrier frequency possible
 * with this NCO.
 * 
 * The carrier phase and carrier cycle count are latched into
 * the carrier_val on the tic_enable.
 * 
 * The carrier phase is the 10 msb of the accumulator register
 * (accum_q).
 * The cycle count is the number of full carrier wave cycles
 * between the last 2 tic_enables.
 * The two values are combined into the carrier_val.
 * Bits 9:0 are the carrier phase, bits 31:10 are the cycle count.
 */
/*
	Copyright (C) 2007  Peter Mumford

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
*/

module carrier_nco (
    clk,
    rst_n,
    tic_enable,
    f_control,
    carrier_val,
    i_sign,
    i_mag,
    q_sign,
    q_mag
);
// ===============================================================
// Input & Output
// ===============================================================
input clk, rst_n;
input tic_enable;
input [28:0] f_control;

output reg [31:0] carrier_val;
output i_sign, i_mag; // in-phase (cosine) carrier wave
output q_sign, q_mag; // quadrature (sine) carrier wave

//================================================================
// Register & Wire
//================================================================
reg  [29:0] accum_q;
wire [30:0] accum_d;
wire	    accum_carry;

reg [21:0] cycle_count_reg;

wire [3:0] phase_key;
reg [1:0] I, Q;

//================================================================
// Design
//================================================================
// 30 bit phase accumulator
assign accum_d = {1'b0, accum_q} + {2'b0, f_control};
assign accum_carry = accum_d[30];
assign phase_key = accum_d[29:26];
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        accum_q <= 0;
    end
    else begin
        accum_q <= accum_d[29:0];
    end
end

// cycle counter and value latching
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        cycle_count_reg <= 0;
    end
    else begin
        if(tic_enable) begin
            cycle_count_reg <= 0;
        end
        else if(accum_carry) begin
            cycle_count_reg <= cycle_count_reg + 1'b1;
        end
    end
end

// Output
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        carrier_val <= 'b0;
    end
    else begin
        if(tic_enable) begin
            carrier_val <= {cycle_count_reg, accum_q[29:20]};
        end
    end
end

// look up table for carrier pseudo-sinewave generation
assign i_sign = I[1];
assign i_mag  = I[0];
assign q_sign = Q[1];
assign q_mag  = Q[0];
always @(*) begin
    case(phase_key)
        4'd15, 4'd0: begin
            I = 2'b00; // -1
            Q = 2'b11; // +2
        end
        4'd1, 4'd2: begin
            I = 2'b10; // +1
            Q = 2'b11; // +2
        end
        4'd3, 4'd4: begin
            I = 2'b11; // +2
            Q = 2'b10; // +1
        end
        4'd5, 4'd6: begin
            I = 2'b11; // +2
            Q = 2'b00; // -1
        end
        4'd7, 4'd8: begin
            I = 2'b10; // +1
            Q = 2'b01; // -2
        end
        4'd9, 4'd10: begin
            I = 2'b00; // -1
            Q = 2'b01; // -2
        end
        4'd11, 4'd12: begin
            I = 2'b01; // -2
            Q = 2'b00; // -1
        end
        4'd13, 4'd14: begin
            I = 2'b01; // -2
            Q = 2'b10; // +1
        end
    endcase
end
endmodule