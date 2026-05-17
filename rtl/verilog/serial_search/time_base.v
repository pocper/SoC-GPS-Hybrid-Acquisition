//                              -*- Mode: Verilog -*-
// Filename        : time_base.v
// Description     : Generates the TIC (tic_enable), preTIC (pre_tic_enable)
//                    ACCUM_INT (accum_enable) and accum_sample_enable.

//                  The accumulator sample rate is set at 40/7 MHz in this design.
//                  The accum_sample_enable pulse is derived from the sample clock
//                  driver for the 2015, but is on a different enable phase.

// Author          : Peter Mumford  UNSW 2005
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

module time_base (
    clk,
    rst_n,
    tic_divide,
    accum_divide,
    pre_tic_enable,
    tic_enable,
    accum_enable,
    tic_count,
    accum_count
);
// ===============================================================
// Input & Output
// ===============================================================
input clk, rst_n;

// TIC
input      [23:0] tic_divide;     // Given by CPU
output            pre_tic_enable; // to code_nco's
output reg        tic_enable;     // to code_gen's
output reg [23:0] tic_count;      // the value of the TIC counter

// Accumulation
input      [23:0] accum_divide; // Given by CPU
output            accum_enable; // accumulation interrupt
output reg [23:0] accum_count;  // the value of the accum counter

//================================================================
// Design
//================================================================
//--------------------------------------------------
// Generate The tic_enable
//--------------------------------------------------
// tic period = (tic_divide + 1) * Clk period
// If clocked by Altera DE-series 50[MHz]:
// tic period = (tic_divide + 1) / 50[MHz]
// For default tic period (0.1s), tic_divide = 4999999
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        tic_count <= 24'd4999999;
    end
    else begin
        tic_count <= (tic_count==0)?tic_divide:(tic_count - 24'b1);
    end
end

// The preTIC comes first latching the code_nco,
// followed by the TIC latching everything else.
// This is due to the delay between the code_nco phase
// and the prompt code.
assign pre_tic_enable = (tic_count==0);
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        tic_enable <= 'b0;
    end
    else begin
        tic_enable <= pre_tic_enable;
    end
end
//---------------------------------------------------------
// Generate The accum_enable
//---------------------------------------------------------
// The Accumulator interrupt signal and flag needs to have
// between 0.5 ms and about 1 ms period.
// This is to ensure that accumulation data can be read
// before it is written over by new data.
// The accumulators are asynchronous to each other and have a
// dump period of nominally 1ms.

// ACCUM_INT period = (accum_divide + 1) * Clk period
// If clocked by Altera DE-series 50[MHz]:
// ACCUM_INT period = (accum_divide + 1) / 50[MHz]
// For default accumulator interrupt(0.5 ms), accum_divide = 24999
assign accum_enable = (accum_count==0);
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        accum_count <= 24'd24999;
    end
    else begin
        accum_count <= (accum_count==0)?accum_divide:(accum_count - 24'b1);
    end
end
endmodule