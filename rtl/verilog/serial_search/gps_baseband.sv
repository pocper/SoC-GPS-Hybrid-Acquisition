module gps_baseband 
#(parameter num_channel = 8)
(
    clk,
    rst_n,
    // Input
    in_valid,
    I,
    Q,
    tic_divide,
    accum_divide,
    // Output
    tic_enable,
    accum_enable,
    tic_count,
    accum_count,
    // Tracking_channel
    prn_key_enable,
    prn_key,
    chip_select,
    carr_nco,
    code_nco,
    carrier_val,
    code_val,
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
input clk;
input rst_n;

input in_valid;
input [1:0] I, Q;

input [23:0] tic_divide;
input [23:0] accum_divide;

output        tic_enable;
output        accum_enable;
output [23:0] tic_count;
output [23:0] accum_count;

input       prn_key_enable [num_channel-1:0];
input [9:0] prn_key        [num_channel-1:0];
input [1:0] chip_select    [num_channel-1:0];

input  [28:0] carr_nco [num_channel-1:0];
input  [27:0] code_nco [num_channel-1:0];

output [31:0] carrier_val [num_channel-1:0];
output [20:0] code_val [num_channel-1:0];

input slew_enable      [num_channel-1:0];
input [10:0] code_slew [num_channel-1:0];

input         epoch_enable [num_channel-1:0];
input  [10:0] epoch_load   [num_channel-1:0];
output [10:0] epoch        [num_channel-1:0];
output [10:0] epoch_check  [num_channel-1:0];

output        dump_enable [num_channel-1:0];
output [15:0] i_early     [num_channel-1:0];
output [15:0] q_early     [num_channel-1:0];
output [15:0] i_prompt    [num_channel-1:0];
output [15:0] q_prompt    [num_channel-1:0];
output [15:0] i_late      [num_channel-1:0];
output [15:0] q_late      [num_channel-1:0];

output [11:0] debug_hc_count2  [num_channel-1:0];
output [10:0] debug_hc_count3  [num_channel-1:0];
output [11:0] debug_max_count2 [num_channel-1:0];
output [10:0] debug_slew       [num_channel-1:0];

//================================================================
// Register & Wire
//================================================================
// time_base
wire pre_tic_enable;

//================================================================
// Design
//================================================================
time_base u_time_base (
    .clk           (clk),
    .rst_n         (rst_n),
    .tic_divide    (tic_divide),
    .accum_divide  (accum_divide),
    .pre_tic_enable(pre_tic_enable),
    .tic_enable    (tic_enable),
    .accum_enable  (accum_enable),
    .tic_count     (tic_count), 
    .accum_count   (accum_count)
);

genvar i;
generate
    for(i=0;i<num_channel;i=i+1) begin:tracking_channel
        tracking_channel u_tracking_channel (
            .clk                (clk), 
            .rst_n              (rst_n),
            .accum_sample_enable(in_valid),
            .if_I               (I),
            .if_Q               (Q),
            .pre_tic_enable     (pre_tic_enable),
            .tic_enable         (tic_enable),
            .carr_nco_fc        (carr_nco[i]),
            .code_nco_fc        (code_nco[i]),
            .carrier_val        (carrier_val[i]),
            .code_val           (code_val[i]),
            .glns_or_gps        (1'b0),
            .prn_key_enable     (prn_key_enable[i]),
            .prn_key            (prn_key[i]),
            .chip_select        (chip_select[i]),
            .slew_enable        (slew_enable[i]),
            .code_slew          (code_slew[i]),
            .epoch_enable       (epoch_enable[i]),
            .epoch_load         (epoch_load[i]),
            .epoch              (epoch[i]),
            .epoch_check        (epoch_check[i]),
            .dump_enable        (dump_enable[i]),
            .i_early            (i_early[i]),
            .q_early            (q_early[i]),
            .i_prompt           (i_prompt[i]),
            .q_prompt           (q_prompt[i]),
            .i_late             (i_late[i]),
            .q_late             (q_late[i]),
            .debug_hc_count2(debug_hc_count2[i]),
            .debug_hc_count3(debug_hc_count3[i]),
            .debug_max_count2(debug_max_count2[i]),
            .debug_slew(debug_slew[i])
        );
    end
endgenerate
endmodule