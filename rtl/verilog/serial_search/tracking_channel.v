//                              -*- Mode: Verilog -*-
// Filename        : tracking_channel.v
// Description     : Wire the correlator block together.
//                   2 carrier_mixers
//                   1 carrier_nco
//                   1 code_nco
//                   1 code_gen
//                   1 epoch_counter
//                   6 accumulators

// Author          : Peter Mumford, UNSW 2005
// Author          : Gavrilov Artyom, gnss-sdr.com, 2012 (iq-processing upgrade).

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

module tracking_channel (
    clk,
    rst_n,
    accum_sample_enable,
    if_I,
    if_Q,
    pre_tic_enable,
    tic_enable,
    carr_nco_fc,
    code_nco_fc,
    carrier_val,
    code_val,
    glns_or_gps,
    prn_key_enable,
    prn_key,
    chip_select,
    slew_enable,
    code_slew,
    epoch_enable,
    epoch_load,
    epoch,
    epoch_check,
    dump_enable,
    i_early,
    q_early,
    i_prompt,
    q_prompt,
    i_late,
    q_late,
    debug_hc_count2,
    debug_hc_count3,
    debug_max_count2,
    debug_slew
);
// ===============================================================
// Input & Output
// ===============================================================
input clk, rst_n;
input accum_sample_enable, pre_tic_enable, tic_enable;

input [1:0] if_I, if_Q;

input  [28:0] carr_nco_fc;
output [31:0] carrier_val;

input  [27:0] code_nco_fc;
output [20:0] code_val;

input glns_or_gps;

input        prn_key_enable;
input [9:0]  prn_key;
input [1:0]  chip_select;

input        slew_enable;
input [10:0] code_slew;

input         epoch_enable;
input  [10:0] epoch_load;
output [10:0] epoch, epoch_check;

output [15:0] i_early,  q_early;
output [15:0] i_prompt, q_prompt;
output [15:0] i_late,   q_late;
output        dump_enable;

// Debug
output [11:0] debug_hc_count2;
output [10:0] debug_hc_count3;
output [11:0] debug_max_count2;
output [10:0] debug_slew;

//================================================================
// Register & Wire
//================================================================
wire hc_enable, qc_enable, hqc_enable;
wire early_code, prompt_code, late_code;

wire carrier_i_sign, carrier_q_sign;
wire carrier_i_mag,  carrier_q_mag;

wire       mix_ii_sign, mix_iq_sign;
wire [2:0] mix_ii_mag,  mix_iq_mag;

wire       mix_qq_sign, mix_qi_sign;
wire [2:0] mix_qq_mag,  mix_qi_mag;

//================================================================
// Design
//================================================================
// code nco -----------------------------------------------------------------
code_nco u_code_nco (
    // Input
    .clk           (clk),
    .rst_n         (rst_n),
    .tic_enable    (pre_tic_enable),
    .f_control     (code_nco_fc),
    // Output
    .hc_enable     (hc_enable),
    .qc_enable     (qc_enable),
    .hqc_enable    (hqc_enable),
    .code_nco_phase(code_val[9:0])
);
// code gen -----------------------------------------------------------------
code_gen u_code_gen (
    // Input
    .clk           (clk),
    .rst_n         (rst_n),
    .glns_or_gps   (glns_or_gps),
    .tic_enable    (tic_enable),
    .hc_enable     (hc_enable),
    .qc_enable     (qc_enable),
    .hqc_enable    (hqc_enable),
    .chip_select   (chip_select),
    .prn_key_enable(prn_key_enable),
    .prn_key       (prn_key),
    .slew_enable   (slew_enable),
    .code_slew     (code_slew),
    // Output
    .code_phase    (code_val[20:10]),
    .dump_enable   (dump_enable),
    .early         (early_code),
    .prompt        (prompt_code),
    .late          (late_code),
    // Debug
    .debug_hc_count2(debug_hc_count2),
    .debug_hc_count3(debug_hc_count3),
    .debug_max_count2(debug_max_count2)
);
// carrier nco --------------------------------------------------------------
carrier_nco u_carrier_nco (
    // Input
    .clk        (clk),
    .rst_n      (rst_n),
    .tic_enable (tic_enable),
    .f_control  (carr_nco_fc),
    // Output
    .carrier_val(carrier_val),
    .i_sign     (carrier_i_sign),
    .i_mag      (carrier_i_mag),
    .q_sign     (carrier_q_sign),
    .q_mag      (carrier_q_mag)
);

// epoch counter ------------------------------------------------------------
epoch_counter u_epoch_counter (
    // Input
    .clk         (clk),
    .rst_n       (rst_n),
    .tic_enable  (tic_enable),
    .dump_enable (dump_enable),
    .epoch_enable(epoch_enable),
    .epoch_load  (epoch_load),
    // Output
    .epoch       (epoch),
    .epoch_check (epoch_check)
);

// carrier mixers -----------------------------------------------------------
carrier_mixer u_carrier_mixer_ii (
    // Input
    .clk         (clk),
    .rst_n       (rst_n),
    .if_sign     (if_I[1]),
    .if_mag      (if_I[0]),
    .carrier_sign(carrier_i_sign),
    .carrier_mag (carrier_i_mag),
    // Output
    .mix_sign    (mix_ii_sign),
    .mix_mag     (mix_ii_mag)
);
carrier_mixer u_carrier_mixer_iq (
    // Input
    .clk         (clk),
    .rst_n       (rst_n),
    .if_sign     (if_I[1]),
    .if_mag      (if_I[0]),
    .carrier_sign(carrier_q_sign),
    .carrier_mag (carrier_q_mag),
    // Output
    .mix_sign    (mix_iq_sign),
    .mix_mag     (mix_iq_mag)
);

`ifdef ENABLE_IQ_PROCESSING
// For iq-processing 4 mixers are used instead of 2 (to make multiplication of complex numbers).
carrier_mixer u_carrier_mixer_qi (
    // Input
    .clk         (clk),
    .rst_n       (rst_n),
    .if_sign     (if_Q[1]),
    .if_mag      (if_Q[0]),
    .carrier_sign(carrier_i_sign),
    .carrier_mag (carrier_i_mag),
    // Output
    .mix_sign    (mix_qi_sign),
    .mix_mag     (mix_qi_mag)
);
carrier_mixer u_carrier_mixer_qq (
    // Input
    .clk         (clk),
    .rst_n       (rst_n),
    .if_sign     (if_Q[1]),
    .if_mag      (if_Q[0]),
    .carrier_sign(carrier_q_sign),
    .carrier_mag (carrier_q_mag),
    // Output
    .mix_sign    (mix_qq_sign),
    .mix_mag     (mix_qq_mag)
);
`endif

// accumulators -------------------------------------------------------------
`ifndef ENABLE_IQ_PROCESSING
// in-phase early
accumulator u_accumulator_ie (
    .clk             (clk),
    .rst_n           (rst_n),
    .sample_enable   (accum_sample_enable),
    .code            (early_code),
    .carrier_mix_sign(mix_ii_sign),
    .carrier_mix_mag (mix_ii_mag),
    .dump_enable     (dump_enable),
    .accumulation    (i_early)
);
// in-phase prompt
accumulator u_accumulator_ip (
    .clk             (clk),
    .rst_n           (rst_n),
    .sample_enable   (accum_sample_enable),
    .code            (prompt_code),
    .carrier_mix_sign(mix_ii_sign),
    .carrier_mix_mag (mix_ii_mag),
    .dump_enable     (dump_enable),
    .accumulation    (i_prompt)
);
// in-phase late
accumulator il (
    .clk             (clk),
    .rst_n           (rst_n),
    .sample_enable   (accum_sample_enable),
    .code            (late_code),
    .carrier_mix_sign(mix_ii_sign),
    .carrier_mix_mag (mix_ii_mag),
    .dump_enable     (dump_enable),
    .accumulation    (i_late)
);
// quadrature-phase early
accumulator qe (
    .clk             (clk),
    .rst_n           (rst_n),
    .sample_enable   (accum_sample_enable),
    .code            (early_code),
    .carrier_mix_sign(mix_iq_sign),
    .carrier_mix_mag (mix_iq_mag),
    .dump_enable     (dump_enable),
    .accumulation    (q_early)
);
// quadrature-phase prompt
accumulator qp (
    .clk             (clk),
    .rst_n           (rst_n),
    .sample_enable   (accum_sample_enable),
    .code            (prompt_code),
    .carrier_mix_sign(mix_iq_sign),
    .carrier_mix_mag (mix_iq_mag),
    .dump_enable     (dump_enable),
    .accumulation    (q_prompt)
);
// quadrature-phase late
accumulator ql (
    .clk             (clk),
    .rst_n           (rst_n),
    .sample_enable   (accum_sample_enable),
    .code            (late_code),
    .carrier_mix_sign(mix_iq_sign),
    .carrier_mix_mag (mix_iq_mag),
    .dump_enable     (dump_enable),
    .accumulation    (q_late)
);
//-------------------------------------------------------------------------
`else
// in-phase early
accumulator_two_inputs u_accumulator_two_inputs_ie (
    .clk              (clk),
    .rst_n            (rst_n),
    .sample_enable    (accum_sample_enable),
    .code             (early_code),
    .carrier_mix1_sign(mix_ii_sign),
    .carrier_mix1_mag (mix_ii_mag),
    .carrier_mix2_sign(~mix_qq_sign),
    .carrier_mix2_mag (mix_qq_mag),
    .dump_enable      (dump_enable),
    .accumulation     (i_early)
);
// in-phase prompt
accumulator_two_inputs u_accumulator_two_inputs_ip (
    .clk              (clk),
    .rst_n            (rst_n),
    .sample_enable    (accum_sample_enable),
    .code             (prompt_code),
    .carrier_mix1_sign(mix_ii_sign),
    .carrier_mix1_mag (mix_ii_mag),
    .carrier_mix2_sign(~mix_qq_sign),
    .carrier_mix2_mag (mix_qq_mag),
    .dump_enable      (dump_enable),
    .accumulation     (i_prompt)
);
// in-phase late
accumulator_two_inputs u_accumulator_two_inputs_il (
    .clk              (clk),
    .rst_n            (rst_n),
    .sample_enable    (accum_sample_enable),
    .code             (late_code),
    .carrier_mix1_sign(mix_ii_sign),
    .carrier_mix1_mag (mix_ii_mag),
    .carrier_mix2_sign(~mix_qq_sign),
    .carrier_mix2_mag (mix_qq_mag),
    .dump_enable      (dump_enable),
    .accumulation     (i_late)
);
// quadrature-phase early
accumulator_two_inputs u_accumulator_two_inputs_qe (
    .clk              (clk),
    .rst_n            (rst_n),
    .sample_enable    (accum_sample_enable),
    .code             (early_code),
    .carrier_mix1_sign(mix_qi_sign),
    .carrier_mix1_mag (mix_qi_mag),
    .carrier_mix2_sign(mix_iq_sign),
    .carrier_mix2_mag (mix_iq_mag),
    .dump_enable      (dump_enable),
    .accumulation     (q_early)
);
// quadrature-phase prompt
accumulator_two_inputs u_accumulator_two_inputs_qp (
    .clk              (clk),
    .rst_n            (rst_n),
    .sample_enable    (accum_sample_enable),
    .code             (prompt_code),
    .carrier_mix1_sign(mix_qi_sign),
    .carrier_mix1_mag (mix_qi_mag),
    .carrier_mix2_sign(mix_iq_sign),
    .carrier_mix2_mag (mix_iq_mag),
    .dump_enable      (dump_enable),
    .accumulation     (q_prompt)
);
// quadrature-phase late
accumulator_two_inputs u_accumulator_two_inputs_ql (
    .clk              (clk),
    .rst_n            (rst_n),
    .sample_enable    (accum_sample_enable),
    .code             (late_code),
    .carrier_mix1_sign(mix_qi_sign),
    .carrier_mix1_mag (mix_qi_mag),
    .carrier_mix2_sign(mix_iq_sign),
    .carrier_mix2_mag (mix_iq_mag),
    .dump_enable      (dump_enable),
    .accumulation     (q_late)
);
`endif
endmodule