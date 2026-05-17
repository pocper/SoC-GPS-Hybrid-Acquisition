//                              -*- Mode: Verilog -*-
// Filename        : accumulator.v
// Description     : accumulate and dump process

// Author          : Peter Mumford, UNSW, 2005
// Code updated    : Artyon Favrilov, gnss-sdr.com, 2012
/*
 * carrier_mix_sign provides the sign.
 * 0 for negative, 1 for positive.
 * The three magnitude bits represent the values 1,2,3,6.
 * 
 * The code is 0 or 1 representing -1 or 1 respectively.
 * 
 * The multiplication of the carrier_mix and the code
 * is simply the carrier_mix_mag with the sign determined
 * from the multiplication of the carrier_mix sign and the code.
 * 
 * code              0 0 1 1
 * carrier_mix_sign  0 1 0 1
 *                   -------
 * result            1 0 0 1  (0 for -ve, 1 for +ve)
 * 
 * if (code == carrier_mix_sign) result = 1
 * else result = 0
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
module accumulator (
    clk,
    rst_n,
    sample_enable,
    dump_enable,
    code,
    carrier_mix_sign,
    carrier_mix_mag,
    accumulation
);
// ===============================================================
// Input & Output
// ===============================================================
input clk, rst_n;
input sample_enable, dump_enable;
input code;

input       carrier_mix_sign;
input [2:0] carrier_mix_mag;

output reg [15:0] accumulation;

//================================================================
// Register & Wire
//================================================================
reg  [15:0] accum_q;
wire [15:0] accum_d;
wire [15:0] carrier_mix_mag_16bits;
wire [15:0] carrier_mix_mag_16bits_negative;
wire [15:0] carrier_mix_val;

//================================================================
// Design
//================================================================
// Accumulator
assign carrier_mix_mag_16bits = {13'b0, carrier_mix_mag};
assign carrier_mix_mag_16bits_negative = (~carrier_mix_mag_16bits + 16'b1);
assign carrier_mix_val = (code==carrier_mix_sign)?carrier_mix_mag_16bits:carrier_mix_mag_16bits_negative;
assign accum_d = accum_q + carrier_mix_val;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        accum_q <= 0;
    end
    else begin
        if(dump_enable) begin
            accum_q <= 0;
        end
        else if(sample_enable) begin
            accum_q <= accum_d;
        end
    end
end

// Output
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        accumulation <= 0;
    end
    else begin
        if (dump_enable) begin
            accumulation <= accum_q;
        end
    end
end
endmodule
