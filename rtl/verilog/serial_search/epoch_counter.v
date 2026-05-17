//                              -*- Mode: Verilog -*-
// Filename        : epoch_counter.v
// Description     : Count the C/A code cycles.

// Author          : Peter Mumford, UNSW, 2005

/*
 * C/A code cycles are counted by two counters;
 * the 1ms epoch counter (or cycle counter)
 * and the 20ms epoch counter (or bit counter).
 * The 1ms epoch counter counts C/A code cycles (by 
 * counting dump_enable pulses) that occur every 1ms
 * from 0 to 19. This allows the tracking of the bit
 * boundaries in the broadcast message that occur every
 * 20ms. Every time this counter rolls over, the 20ms
 * epoch counter increments. The 20ms epoch counter
 * goes from 0 to 49 to allow tracking of the message
 * frame boundary.
 * 
 * The 1ms epoch count is 5 bits wide.
 * The 20ms bit count is 6 bits wide.
 * 
 * The values are latched into epoch on the tic_enable.
 * The epoch_check is for instantaneous values used for finding
 * message bit flips.
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

module epoch_counter (
    clk, 
    rst_n, 
    tic_enable, 
    dump_enable, 
    epoch_enable, 
    epoch_load, 
    epoch, 
    epoch_check
);
// ===============================================================
// Input & Output
// ===============================================================
input clk, rst_n;
input tic_enable, dump_enable, epoch_enable;
input [10:0] epoch_load;
output reg [10:0] epoch;
output reg [10:0] epoch_check;

//================================================================
// Register & Wire
//================================================================
reg [4:0] cycle_count;
reg [5:0] bit_count;
wire cycle_count_overflow;
wire bit_count_overflow;
wire [10:0] epoch_d; 

//================================================================
// Design
//================================================================
// the 1ms epoch (C/A code cycle) counter
assign cycle_count_overflow = (cycle_count==19);
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        cycle_count <= 'b0;
    end
    else begin
        if(epoch_enable) begin
            cycle_count <= epoch_load[4:0];
        end
        else if(dump_enable) begin
            cycle_count <= cycle_count_overflow?5'b0:(cycle_count+5'b1);
        end
    end
end

// the 20ms epoch (bit flip) counter
assign bit_count_overflow = (bit_count==49);
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        bit_count <= 'b0;
    end
    else begin
        if(epoch_enable) begin
            bit_count <= epoch_load[10:5];
        end
        else if(cycle_count_overflow & dump_enable) begin
            bit_count <= bit_count_overflow?6'b0:(bit_count+6'b1);
        end
    end
end

// latch the epoch into a register
assign epoch_d = {bit_count, cycle_count};
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        epoch <= 'b0;
        epoch_check <= 'b0;
    end
    else begin
        epoch_check <= epoch_d;

        if(tic_enable) begin
            epoch <= epoch_d;
        end
    end
end
endmodule