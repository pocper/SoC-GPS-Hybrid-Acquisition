//                              -*- Mode: Verilog -*-
// Filename        : code_gen.v
// Description     : Generates early prompt and late C/A code chips.

// Author          : Peter Mumford, 2005, UNSW

// Function        : Generate the C/A code early, prompt and late chipping sequence.

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

module code_gen (
    clk, 
    rst_n,
    tic_enable,
    hc_enable,
    qc_enable,
    hqc_enable,
    chip_select,
    glns_or_gps,
    prn_key_enable,
    prn_key,
    code_slew,
    slew_enable,
    dump_enable,
    code_phase,
    early,
    prompt,
    late,
    debug_hc_count2,
    debug_hc_count3,
    debug_max_count2
);
// ===============================================================
// Input & Output
// ===============================================================
input clk, rst_n;
input tic_enable;       // the TIC
input hc_enable;        // the half-chip(0.5) enable pulse from the code_nco
input qc_enable;        // the quarter-chip(0.25) enable pulse from the code_nco
input hqc_enable;       // the half-quarter-chip(0.125) enable pulse from the code_nco
input [1:0] chip_select;// 0 : 0.5 chip; 1 : 0.25 chip; 2 : 0.125 chip;
input glns_or_gps;      // GLONASS or GPS Code generator (1 = GLONASS, 0 = GPS)
input prn_key_enable;   // pulse to latch in the prn_key and reset the logic
input [9:0] prn_key;    // 10 bit number used to select satellite PRN code
input slew_enable;      // pulse to set the slew_flag
input [10:0] code_slew; // number of half chips to delay the C/A code after the next dump_enable

output dump_enable;          // pulse at the beginning/end of prompt C/A code cycle
output reg [10:0] code_phase;// the phase of the C/A code at the TIC
output early, prompt, late;  // half-chip spaced C/A code sequences

// Debug
output [11:0] debug_hc_count2;
output [10:0] debug_hc_count3;
output [11:0] debug_max_count2;

//================================================================
// Register & Wire
//================================================================
reg [9:0] g1;          // the g1 shift register
reg g1_q;              // output of the g1 shift register
reg [9:0] g2;          // the g2 shift register
reg g2_q;              // output of the g2 shift register
reg [8:0] g3;          // [Art] g3 shift register for GLONASS code generator
reg g3_q;              // [Art] output of the g3 shift register

reg ca_code;          // the C/A code chip sequence from (g1, g2) or g3 shifters
reg chip_enable;
reg [2:0] shift_ca_code; // the output of the chip spreader
wire [2:0] shift;

reg fc_enable;         // full-chip enable that drives the g1 and g2 shifters
reg dump_enable;       // pulse generated at the begining/end of the prompt C/A code cycle
reg [10:0] hc_count1;  // counter used for generating the fc_enable and slew logic (max slew 2045)
wire is_hc_count1_eq_fc;
reg [10:0] slew;       // the code_slew latched if the slew_flag is set
reg [11:0] hc_count2;  // counter for keeping track of the begining/end of C/A code cycle (max count 4091)
reg [11:0] max_count2; // limit of hc_count2, normally = 2045, but increased when slew delays the C/A code

reg slew_flag;         // slew_flag is set on the slew_enable pulse and cleared on the dump_enable
reg slew_trigger;      // triggers the slew event

reg [10:0] hc_count3;  // this counter is reset at the dump_enable, latched into the code_phase on the TIC

//================================================================
// Design
//================================================================
// The G1 shift register
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        g1 <= 'b0;
        g1_q <= 'b0;
    end
    else begin
        if(prn_key_enable) begin
            g1 <= {10{1'b1}};
            g1_q <= 1'b1;
        end
        else if(fc_enable) begin
            g1 <= {(g1[7] ^ g1[0]), g1[9:1]};
            g1_q <= g1[0];
        end
    end
end

// The G2 shift register
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        g2 <= 'b0;
        g2_q <= 'b0;
    end
    else begin
        if(prn_key_enable) begin
            g2 <= prn_key;
            g2_q <= 'b0;
        end
        else if(fc_enable) begin
            g2 <= {(g2[8] ^ g2[7] ^ g2[4] ^ g2[2] ^ g2[1] ^ g2[0]), g2[9:1]};
            g2_q <= g2[0];
        end
    end
end

// The G3 shift register
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        g3 <= 'b0;
        g3_q <= 'b0;
    end
    else begin
        if(prn_key_enable) begin
            g3   <= {9{1'b1}};
            g3_q <= 1'b1;
        end
        else if(fc_enable) begin
            g3   <= {(g3[4] ^ g3[0]), g3[8:1]};
            g3_q <= g3[2];
        end
    end
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        ca_code <= 'b0;
    end
    else begin
        ca_code <= glns_or_gps ? g3_q : (g1_q ^ g2_q);
    end
end

always @(*) begin
    case(chip_select)
        2'd0: chip_enable = hc_enable;
        2'd1: chip_enable = qc_enable;
        2'd2: chip_enable = hqc_enable;
        default: chip_enable = 0;
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        shift_ca_code <= 'b0;
    end
    else begin
        if(prn_key_enable) begin
            shift_ca_code <= 'b0;
        end
        else if(chip_enable) begin
            shift_ca_code <= {shift_ca_code[1:0], ca_code};
        end
    end
end

// assign the early, prompt and late chips, one half chip apart
assign early  = shift_ca_code[0];
assign prompt = shift_ca_code[1];
assign late   = shift_ca_code[2];

// hc_count3 process
//------------------
// Counter 3 counts hc_enables, reset on dump_enable.
// If there is slew delay this counter will roll over
// before the next dump. However, code_phase measurements
// are not valid during slewing.
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        hc_count3 <= 0;
    end
    else begin
        if(prn_key_enable || dump_enable) begin
            hc_count3 <= 0;
        end
        else if(hc_enable) begin
            hc_count3 <= hc_count3 + 11'b1;
        end
    end
end

// capture the code phase at TIC
//------------------------------
// The code_phase is the half-chip count
// at the TIC. Half-chips are numbered 0 to 2045.
// The code_nco_phase (from the code_nco) provides
// the fine (sub half-chip) code phase.
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        code_phase <= 'b0;
    end
    else begin
        if(tic_enable) begin
            code_phase <= hc_count3;
        end
    end
end

// The full-chip enable generator
//--------------------------------
// Without the code_slew being set
// this process just creates the full-chip enable
// at half the rate of the half-chip enable.
// When the code_slew is set, the fc_enable
// is delayed for a number of half-chips.
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        slew <= 0;
    end
    else begin
        if(prn_key_enable) begin
            slew <= 'b0;
        end
        else if(slew_trigger) begin
            slew <= code_slew;
        end
        else if(hc_enable & slew!=0) begin
            slew <= slew - 11'b1;
        end
    end
end

assign is_hc_count1_eq_fc = (hc_count1 == 1);
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        hc_count1 <= 'b0;
    end
    else begin
        if(prn_key_enable) begin
            hc_count1 <= 'b0;
        end
        else if(hc_enable && slew==0) begin
            hc_count1 <= is_hc_count1_eq_fc?11'b0:(hc_count1 + 11'b1);
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        fc_enable <= 'b0;
    end
    else begin
        if(prn_key_enable) begin
            fc_enable <= 'b0;
        end
        else begin
            fc_enable <= (hc_enable && slew==0 && is_hc_count1_eq_fc);
        end
    end
end

// The dump_enable generator
//--------------------------
// create the dump_enable
//
// When a slew value (= x) is written to the code_slew register,
// the C/A code is delayed x half-chips at the next dump.
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        dump_enable <= 'b0;
    end
    else begin
        if(prn_key_enable) begin
            dump_enable <= 'b0;
        end
        else begin
            dump_enable <= (hc_enable && hc_count2==3);
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        hc_count2 <= 'b0;
    end
    else begin
        if(prn_key_enable) begin
            hc_count2 <= 'b0;
        end
        else if(hc_enable) begin
            hc_count2 <= (hc_count2 == max_count2)?12'b0:(hc_count2 + 12'b1);
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        max_count2 <= (glns_or_gps?12'd1021:12'd2045);
    end
    else begin
        if(prn_key_enable) begin
            max_count2 <= (glns_or_gps?12'd1021:12'd2045);
        end
        // signals the arrival of the first hc_enable
        else if(hc_enable && hc_count2==1) begin
            if(slew_flag) begin
                max_count2 <= (glns_or_gps?12'd1021:12'd2045) + code_slew;
            end
            else begin
                max_count2 <= (glns_or_gps?12'd1021:12'd2045);
            end
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        slew_trigger <= 'b0;
    end
    else begin
        if(prn_key_enable) begin
            slew_trigger <= 'b0;
        end
        else begin
            slew_trigger <= (hc_enable & hc_count2==1 & slew_flag);
        end
    end
end


// slew_flag process
//------------------
// The slew_flag is set on slew_enable and cleared on the dump_enable.
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        slew_flag <= 'b0;
    end
    else begin
        if(prn_key_enable) begin
            slew_flag <= 'b0;
        end
        else begin
            if(slew_enable) begin
                slew_flag <= 1;
            end

            if(dump_enable) begin
                slew_flag <= 'b0;
            end
        end
    end
end

// Debug
assign debug_hc_count2 = hc_count2;
assign debug_hc_count3 = hc_count3;
assign debug_max_count2 = max_count2;
endmodule