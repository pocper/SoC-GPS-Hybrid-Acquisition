//                              -*- Mode: Verilog -*-
// Filename        : code_nco.v
// Description     : Generate the half-chip enable signal

// Author          : Peter Mumford, UNSW, 2005

/*
 * The Code_NCO creates the half-chip enable signal.
 * This drives the C/A code generator at the required frequency
 * (nominally 1.023MHz). The frequency must be adjusted by the
 * application code to align the incomming signal with the
 * generated C/A code replica and to account for clock error
 * (TCXO frequency error) and doppler.
 * 
 * The code_NCO provides the fine code phase (10 bit) value on
 * the TIC signal. 
 * Note 1) The full-chip enable (fc_enable) is generated in the code_gen
 * module and is not aligned with the hc_enable.
 * The C/A code chip boundaries align to the fc_enable
 * not the hc_enable. This implies that the fine code phase obtained
 * from the code_nco that generates the hc_enable will be early by
 * one clock cycle. To account for this, the pre_tic_enable is used to
 * latch the code NCO phase. 
 * 
 * The NCO frequency is:
 * f = fControl * clk/2^N
 * 
 * where:
 * f = the required frequency
 * N = 29 (bit width of the phase accumulator)
 * clk = the system clock (= 40MHz)
 * fControl = the 28 bit (unsigned) control word
 * 
 * To generate the C/A code at f, the NCO must be set to run
 * at 2f, therefore:
 *     code_frequency = 0.5 * fControl * clk/2^N
 * 
 * For a system clock running @ clk = 40 MHz:
 *     fControl = code_frequency * 2^29 / 20[Mhz]
 * 
 * For code_frequency = 1.023MHz
 *     fControl = 0x1A30552--
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

module code_nco (
    clk,
    rst_n,
    tic_enable,
    f_control,
    hc_enable,
    qc_enable,
    hqc_enable,
    code_nco_phase
);
// ===============================================================
// Input & Output
// ===============================================================
input clk, rst_n;
input tic_enable;
input [27:0] f_control;
output reg hc_enable;
output reg qc_enable;
output reg hqc_enable;
output reg [9:0] code_nco_phase;

//================================================================
// Register & Wire
//================================================================
// 0.5 chip
reg  [28:0] accum_hc_q;
wire [29:0] accum_hc_d;
wire accum_carry_hc;

// 0.25 chip
reg  [27:0] accum_qc_q;
wire [28:0] accum_qc_d;
wire accum_carry_qc;

// 0.125 chip
reg  [26:0] accum_hqc_q;
wire [27:0] accum_hqc_d;
wire accum_carry_hqc;
//================================================================
// Design
//================================================================
// phase accumulator
assign accum_hc_d  = accum_hc_q  + {1'b0, f_control};
assign accum_qc_d  = accum_qc_q  + f_control;
assign accum_hqc_d = accum_hqc_q + f_control[26:0];

assign accum_carry_hc  = accum_hc_d[29];
assign accum_carry_qc  = accum_qc_d[28];
assign accum_carry_hqc = accum_hqc_d[27];

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        accum_hc_q <= 0;
        accum_qc_q <= 0;
        accum_hqc_q <= 0;
    end
    else begin
        accum_hc_q  <= accum_hc_d[28:0];
        accum_qc_q  <= accum_qc_d[27:0];
        accum_hqc_q <= accum_hqc_d[26:0];
    end
end

// latch the top 10 bits on the tic_enable
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        code_nco_phase <= 0;
    end
    else begin
        if(tic_enable) begin
            code_nco_phase <= accum_hc_q[28:19]; // see note 1 above
        end
    end
end

// generate the chip enable
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        hc_enable  <= 0;
        qc_enable  <= 0;
        hqc_enable <= 0;
    end
    else begin
        hc_enable  <= accum_carry_hc;
        qc_enable  <= accum_carry_qc;
        hqc_enable <= accum_carry_hqc;
    end
end
endmodule