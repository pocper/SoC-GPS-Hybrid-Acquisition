-- ------------------------------------------------------------------------- 
-- High Level Design Compiler for Intel(R) FPGAs Version 25.1std (Release Build #1129)
-- Quartus Prime development tool and MATLAB/Simulink Interface
-- 
-- Legal Notice: Copyright 2025 Intel Corporation.  All rights reserved.
-- Your use of  Intel Corporation's design tools,  logic functions and other
-- software and  tools, and its AMPP partner logic functions, and any output
-- files any  of the foregoing (including  device programming  or simulation
-- files), and  any associated  documentation  or information  are expressly
-- subject  to the terms and  conditions of the  Intel FPGA Software License
-- Agreement, Intel MegaCore Function License Agreement, or other applicable
-- license agreement,  including,  without limitation,  that your use is for
-- the  sole  purpose of  programming  logic devices  manufactured by  Intel
-- and  sold by Intel  or its authorized  distributors. Please refer  to the
-- applicable agreement for further details.
-- ---------------------------------------------------------------------------

-- VHDL created from FP_complex_mult_0002
-- VHDL created on Sat Feb 21 22:27:09 2026


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.MATH_REAL.all;
use std.TextIO.all;
use work.dspba_library_package.all;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;
LIBRARY altera_lnsim;
USE altera_lnsim.altera_lnsim_components.altera_syncram;
LIBRARY lpm;
USE lpm.lpm_components.all;

entity FP_complex_mult_0002 is
    port (
        a : in std_logic_vector(31 downto 0);  -- float32_m23
        b : in std_logic_vector(31 downto 0);  -- float32_m23
        c : in std_logic_vector(31 downto 0);  -- float32_m23
        d : in std_logic_vector(31 downto 0);  -- float32_m23
        q : out std_logic_vector(31 downto 0);  -- float32_m23
        r : out std_logic_vector(31 downto 0);  -- float32_m23
        clk : in std_logic;
        areset : in std_logic
    );
end FP_complex_mult_0002;

architecture normal of FP_complex_mult_0002 is

    attribute altera_attribute : string;
    attribute altera_attribute of normal : architecture is "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF; -name PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 10037; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 15400; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 12020; -name MESSAGE_DISABLE 12030; -name MESSAGE_DISABLE 12010; -name MESSAGE_DISABLE 12110; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 13410; -name MESSAGE_DISABLE 113007";
    
    signal GND_q : STD_LOGIC_VECTOR (0 downto 0);
    signal VCC_q : STD_LOGIC_VECTOR (0 downto 0);
    signal ySign_uid10_fpComplexMulTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal excBits_uid11_fpComplexMulTest_b : STD_LOGIC_VECTOR (1 downto 0);
    signal fraction_uid12_fpComplexMulTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal exp_uid13_fpComplexMulTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal invYSign_uid14_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal minusY_uid15_fpComplexMulTest_q : STD_LOGIC_VECTOR (33 downto 0);
    signal expX_uid20_ac_uid6_fpComplexMulTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal expY_uid21_ac_uid6_fpComplexMulTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal signX_uid22_ac_uid6_fpComplexMulTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal signY_uid23_ac_uid6_fpComplexMulTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal cstAllOWE_uid24_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal cstZeroWF_uid25_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal cstAllZWE_uid26_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal frac_x_uid28_ac_uid6_fpComplexMulTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal excZ_x_uid29_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expXIsMax_uid30_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid31_ac_uid6_fpComplexMulTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid31_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsNotZero_uid32_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excI_x_uid33_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excN_x_uid34_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invExpXIsMax_uid35_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal InvExpXIsZero_uid36_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excR_x_uid37_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal frac_y_uid42_ac_uid6_fpComplexMulTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal excZ_y_uid43_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expXIsMax_uid44_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid45_ac_uid6_fpComplexMulTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid45_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsNotZero_uid46_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excI_y_uid47_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excN_y_uid48_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invExpXIsMax_uid49_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal InvExpXIsZero_uid50_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excR_y_uid51_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal ofracX_uid54_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (23 downto 0);
    signal ofracY_uid57_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (23 downto 0);
    signal expSum_uid58_ac_uid6_fpComplexMulTest_a : STD_LOGIC_VECTOR (8 downto 0);
    signal expSum_uid58_ac_uid6_fpComplexMulTest_b : STD_LOGIC_VECTOR (8 downto 0);
    signal expSum_uid58_ac_uid6_fpComplexMulTest_o : STD_LOGIC_VECTOR (8 downto 0);
    signal expSum_uid58_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (8 downto 0);
    signal biasInc_uid59_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (9 downto 0);
    signal expSumMBias_uid60_ac_uid6_fpComplexMulTest_a : STD_LOGIC_VECTOR (11 downto 0);
    signal expSumMBias_uid60_ac_uid6_fpComplexMulTest_b : STD_LOGIC_VECTOR (11 downto 0);
    signal expSumMBias_uid60_ac_uid6_fpComplexMulTest_o : STD_LOGIC_VECTOR (11 downto 0);
    signal expSumMBias_uid60_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (10 downto 0);
    signal signR_uid62_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal normalizeBit_uid63_ac_uid6_fpComplexMulTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal fracRPostNormHigh_uid65_ac_uid6_fpComplexMulTest_in : STD_LOGIC_VECTOR (46 downto 0);
    signal fracRPostNormHigh_uid65_ac_uid6_fpComplexMulTest_b : STD_LOGIC_VECTOR (23 downto 0);
    signal fracRPostNormLow_uid66_ac_uid6_fpComplexMulTest_in : STD_LOGIC_VECTOR (45 downto 0);
    signal fracRPostNormLow_uid66_ac_uid6_fpComplexMulTest_b : STD_LOGIC_VECTOR (23 downto 0);
    signal fracRPostNorm_uid67_ac_uid6_fpComplexMulTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal fracRPostNorm_uid67_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (23 downto 0);
    signal stickyRange_uid68_ac_uid6_fpComplexMulTest_in : STD_LOGIC_VECTOR (21 downto 0);
    signal stickyRange_uid68_ac_uid6_fpComplexMulTest_b : STD_LOGIC_VECTOR (21 downto 0);
    signal extraStickyBitOfProd_uid69_ac_uid6_fpComplexMulTest_in : STD_LOGIC_VECTOR (22 downto 0);
    signal extraStickyBitOfProd_uid69_ac_uid6_fpComplexMulTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal extraStickyBit_uid70_ac_uid6_fpComplexMulTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal extraStickyBit_uid70_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal stickyExtendedRange_uid71_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal stickyRangeComparator_uid73_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal sticky_uid74_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracRPostNorm1dto0_uid75_ac_uid6_fpComplexMulTest_in : STD_LOGIC_VECTOR (1 downto 0);
    signal fracRPostNorm1dto0_uid75_ac_uid6_fpComplexMulTest_b : STD_LOGIC_VECTOR (1 downto 0);
    signal lrs_uid76_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (2 downto 0);
    signal roundBitDetectionConstant_uid77_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (2 downto 0);
    signal roundBitDetectionPattern_uid78_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal roundBit_uid79_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expFracPreRound_uid80_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (34 downto 0);
    signal roundBitAndNormalizationOp_uid82_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (25 downto 0);
    signal expFracRPostRounding_uid83_ac_uid6_fpComplexMulTest_a : STD_LOGIC_VECTOR (36 downto 0);
    signal expFracRPostRounding_uid83_ac_uid6_fpComplexMulTest_b : STD_LOGIC_VECTOR (36 downto 0);
    signal expFracRPostRounding_uid83_ac_uid6_fpComplexMulTest_o : STD_LOGIC_VECTOR (36 downto 0);
    signal expFracRPostRounding_uid83_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (35 downto 0);
    signal fracRPreExc_uid84_ac_uid6_fpComplexMulTest_in : STD_LOGIC_VECTOR (23 downto 0);
    signal fracRPreExc_uid84_ac_uid6_fpComplexMulTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal expRPreExcExt_uid85_ac_uid6_fpComplexMulTest_b : STD_LOGIC_VECTOR (11 downto 0);
    signal expRPreExc_uid86_ac_uid6_fpComplexMulTest_in : STD_LOGIC_VECTOR (7 downto 0);
    signal expRPreExc_uid86_ac_uid6_fpComplexMulTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal expOvf_uid89_ac_uid6_fpComplexMulTest_a : STD_LOGIC_VECTOR (13 downto 0);
    signal expOvf_uid89_ac_uid6_fpComplexMulTest_b : STD_LOGIC_VECTOR (13 downto 0);
    signal expOvf_uid89_ac_uid6_fpComplexMulTest_o : STD_LOGIC_VECTOR (13 downto 0);
    signal expOvf_uid89_ac_uid6_fpComplexMulTest_c : STD_LOGIC_VECTOR (0 downto 0);
    signal excXZAndExcYZ_uid90_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excXZAndExcYR_uid91_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excYZAndExcXR_uid92_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excZC3_uid93_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRZero_uid94_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excXIAndExcYI_uid95_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excXRAndExcYI_uid96_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excYRAndExcXI_uid97_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal ExcROvfAndInReg_uid98_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRInf_uid99_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excYZAndExcXI_uid100_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excXZAndExcYI_uid101_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal ZeroTimesInf_uid102_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRNaN_uid103_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal concExc_uid104_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (2 downto 0);
    signal excREnc_uid105_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal invExcRNaN_uid106_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal signRPostExc_uid107_ac_uid6_fpComplexMulTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal signRPostExc_uid107_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal R_uid108_ac_uid6_fpComplexMulTest_q : STD_LOGIC_VECTOR (33 downto 0);
    signal expX_uid110_bd_uid7_fpComplexMulTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal expY_uid111_bd_uid7_fpComplexMulTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal signX_uid112_bd_uid7_fpComplexMulTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal signY_uid113_bd_uid7_fpComplexMulTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal frac_x_uid118_bd_uid7_fpComplexMulTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal excZ_x_uid119_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expXIsMax_uid120_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid121_bd_uid7_fpComplexMulTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid121_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsNotZero_uid122_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excI_x_uid123_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excN_x_uid124_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invExpXIsMax_uid125_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal InvExpXIsZero_uid126_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excR_x_uid127_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal frac_y_uid132_bd_uid7_fpComplexMulTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal excZ_y_uid133_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expXIsMax_uid134_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid135_bd_uid7_fpComplexMulTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid135_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsNotZero_uid136_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excI_y_uid137_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excN_y_uid138_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invExpXIsMax_uid139_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal InvExpXIsZero_uid140_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excR_y_uid141_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal ofracX_uid144_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (23 downto 0);
    signal ofracY_uid147_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (23 downto 0);
    signal expSum_uid148_bd_uid7_fpComplexMulTest_a : STD_LOGIC_VECTOR (8 downto 0);
    signal expSum_uid148_bd_uid7_fpComplexMulTest_b : STD_LOGIC_VECTOR (8 downto 0);
    signal expSum_uid148_bd_uid7_fpComplexMulTest_o : STD_LOGIC_VECTOR (8 downto 0);
    signal expSum_uid148_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (8 downto 0);
    signal expSumMBias_uid150_bd_uid7_fpComplexMulTest_a : STD_LOGIC_VECTOR (11 downto 0);
    signal expSumMBias_uid150_bd_uid7_fpComplexMulTest_b : STD_LOGIC_VECTOR (11 downto 0);
    signal expSumMBias_uid150_bd_uid7_fpComplexMulTest_o : STD_LOGIC_VECTOR (11 downto 0);
    signal expSumMBias_uid150_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (10 downto 0);
    signal signR_uid152_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal normalizeBit_uid153_bd_uid7_fpComplexMulTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal fracRPostNormHigh_uid155_bd_uid7_fpComplexMulTest_in : STD_LOGIC_VECTOR (46 downto 0);
    signal fracRPostNormHigh_uid155_bd_uid7_fpComplexMulTest_b : STD_LOGIC_VECTOR (23 downto 0);
    signal fracRPostNormLow_uid156_bd_uid7_fpComplexMulTest_in : STD_LOGIC_VECTOR (45 downto 0);
    signal fracRPostNormLow_uid156_bd_uid7_fpComplexMulTest_b : STD_LOGIC_VECTOR (23 downto 0);
    signal fracRPostNorm_uid157_bd_uid7_fpComplexMulTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal fracRPostNorm_uid157_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (23 downto 0);
    signal stickyRange_uid158_bd_uid7_fpComplexMulTest_in : STD_LOGIC_VECTOR (21 downto 0);
    signal stickyRange_uid158_bd_uid7_fpComplexMulTest_b : STD_LOGIC_VECTOR (21 downto 0);
    signal extraStickyBitOfProd_uid159_bd_uid7_fpComplexMulTest_in : STD_LOGIC_VECTOR (22 downto 0);
    signal extraStickyBitOfProd_uid159_bd_uid7_fpComplexMulTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal extraStickyBit_uid160_bd_uid7_fpComplexMulTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal extraStickyBit_uid160_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal stickyExtendedRange_uid161_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal stickyRangeComparator_uid163_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal sticky_uid164_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracRPostNorm1dto0_uid165_bd_uid7_fpComplexMulTest_in : STD_LOGIC_VECTOR (1 downto 0);
    signal fracRPostNorm1dto0_uid165_bd_uid7_fpComplexMulTest_b : STD_LOGIC_VECTOR (1 downto 0);
    signal lrs_uid166_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (2 downto 0);
    signal roundBitDetectionPattern_uid168_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal roundBit_uid169_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expFracPreRound_uid170_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (34 downto 0);
    signal roundBitAndNormalizationOp_uid172_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (25 downto 0);
    signal expFracRPostRounding_uid173_bd_uid7_fpComplexMulTest_a : STD_LOGIC_VECTOR (36 downto 0);
    signal expFracRPostRounding_uid173_bd_uid7_fpComplexMulTest_b : STD_LOGIC_VECTOR (36 downto 0);
    signal expFracRPostRounding_uid173_bd_uid7_fpComplexMulTest_o : STD_LOGIC_VECTOR (36 downto 0);
    signal expFracRPostRounding_uid173_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (35 downto 0);
    signal fracRPreExc_uid174_bd_uid7_fpComplexMulTest_in : STD_LOGIC_VECTOR (23 downto 0);
    signal fracRPreExc_uid174_bd_uid7_fpComplexMulTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal expRPreExcExt_uid175_bd_uid7_fpComplexMulTest_b : STD_LOGIC_VECTOR (11 downto 0);
    signal expRPreExc_uid176_bd_uid7_fpComplexMulTest_in : STD_LOGIC_VECTOR (7 downto 0);
    signal expRPreExc_uid176_bd_uid7_fpComplexMulTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal expOvf_uid179_bd_uid7_fpComplexMulTest_a : STD_LOGIC_VECTOR (13 downto 0);
    signal expOvf_uid179_bd_uid7_fpComplexMulTest_b : STD_LOGIC_VECTOR (13 downto 0);
    signal expOvf_uid179_bd_uid7_fpComplexMulTest_o : STD_LOGIC_VECTOR (13 downto 0);
    signal expOvf_uid179_bd_uid7_fpComplexMulTest_c : STD_LOGIC_VECTOR (0 downto 0);
    signal excXZAndExcYZ_uid180_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excXZAndExcYR_uid181_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excYZAndExcXR_uid182_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excZC3_uid183_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRZero_uid184_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excXIAndExcYI_uid185_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excXRAndExcYI_uid186_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excYRAndExcXI_uid187_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal ExcROvfAndInReg_uid188_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRInf_uid189_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excYZAndExcXI_uid190_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excXZAndExcYI_uid191_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal ZeroTimesInf_uid192_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRNaN_uid193_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal concExc_uid194_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (2 downto 0);
    signal excREnc_uid195_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal invExcRNaN_uid196_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal signRPostExc_uid197_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal R_uid198_bd_uid7_fpComplexMulTest_q : STD_LOGIC_VECTOR (33 downto 0);
    signal expSum_uid238_ad_uid8_fpComplexMulTest_a : STD_LOGIC_VECTOR (8 downto 0);
    signal expSum_uid238_ad_uid8_fpComplexMulTest_b : STD_LOGIC_VECTOR (8 downto 0);
    signal expSum_uid238_ad_uid8_fpComplexMulTest_o : STD_LOGIC_VECTOR (8 downto 0);
    signal expSum_uid238_ad_uid8_fpComplexMulTest_q : STD_LOGIC_VECTOR (8 downto 0);
    signal expSumMBias_uid240_ad_uid8_fpComplexMulTest_a : STD_LOGIC_VECTOR (11 downto 0);
    signal expSumMBias_uid240_ad_uid8_fpComplexMulTest_b : STD_LOGIC_VECTOR (11 downto 0);
    signal expSumMBias_uid240_ad_uid8_fpComplexMulTest_o : STD_LOGIC_VECTOR (11 downto 0);
    signal expSumMBias_uid240_ad_uid8_fpComplexMulTest_q : STD_LOGIC_VECTOR (10 downto 0);
    signal signR_uid242_ad_uid8_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal normalizeBit_uid243_ad_uid8_fpComplexMulTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal fracRPostNormHigh_uid245_ad_uid8_fpComplexMulTest_in : STD_LOGIC_VECTOR (46 downto 0);
    signal fracRPostNormHigh_uid245_ad_uid8_fpComplexMulTest_b : STD_LOGIC_VECTOR (23 downto 0);
    signal fracRPostNormLow_uid246_ad_uid8_fpComplexMulTest_in : STD_LOGIC_VECTOR (45 downto 0);
    signal fracRPostNormLow_uid246_ad_uid8_fpComplexMulTest_b : STD_LOGIC_VECTOR (23 downto 0);
    signal fracRPostNorm_uid247_ad_uid8_fpComplexMulTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal fracRPostNorm_uid247_ad_uid8_fpComplexMulTest_q : STD_LOGIC_VECTOR (23 downto 0);
    signal stickyRange_uid248_ad_uid8_fpComplexMulTest_in : STD_LOGIC_VECTOR (21 downto 0);
    signal stickyRange_uid248_ad_uid8_fpComplexMulTest_b : STD_LOGIC_VECTOR (21 downto 0);
    signal extraStickyBitOfProd_uid249_ad_uid8_fpComplexMulTest_in : STD_LOGIC_VECTOR (22 downto 0);
    signal extraStickyBitOfProd_uid249_ad_uid8_fpComplexMulTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal extraStickyBit_uid250_ad_uid8_fpComplexMulTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal extraStickyBit_uid250_ad_uid8_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal stickyExtendedRange_uid251_ad_uid8_fpComplexMulTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal stickyRangeComparator_uid253_ad_uid8_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal sticky_uid254_ad_uid8_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracRPostNorm1dto0_uid255_ad_uid8_fpComplexMulTest_in : STD_LOGIC_VECTOR (1 downto 0);
    signal fracRPostNorm1dto0_uid255_ad_uid8_fpComplexMulTest_b : STD_LOGIC_VECTOR (1 downto 0);
    signal lrs_uid256_ad_uid8_fpComplexMulTest_q : STD_LOGIC_VECTOR (2 downto 0);
    signal roundBitDetectionPattern_uid258_ad_uid8_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal roundBit_uid259_ad_uid8_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expFracPreRound_uid260_ad_uid8_fpComplexMulTest_q : STD_LOGIC_VECTOR (34 downto 0);
    signal roundBitAndNormalizationOp_uid262_ad_uid8_fpComplexMulTest_q : STD_LOGIC_VECTOR (25 downto 0);
    signal expFracRPostRounding_uid263_ad_uid8_fpComplexMulTest_a : STD_LOGIC_VECTOR (36 downto 0);
    signal expFracRPostRounding_uid263_ad_uid8_fpComplexMulTest_b : STD_LOGIC_VECTOR (36 downto 0);
    signal expFracRPostRounding_uid263_ad_uid8_fpComplexMulTest_o : STD_LOGIC_VECTOR (36 downto 0);
    signal expFracRPostRounding_uid263_ad_uid8_fpComplexMulTest_q : STD_LOGIC_VECTOR (35 downto 0);
    signal fracRPreExc_uid264_ad_uid8_fpComplexMulTest_in : STD_LOGIC_VECTOR (23 downto 0);
    signal fracRPreExc_uid264_ad_uid8_fpComplexMulTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal expRPreExcExt_uid265_ad_uid8_fpComplexMulTest_b : STD_LOGIC_VECTOR (11 downto 0);
    signal expRPreExc_uid266_ad_uid8_fpComplexMulTest_in : STD_LOGIC_VECTOR (7 downto 0);
    signal expRPreExc_uid266_ad_uid8_fpComplexMulTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal expOvf_uid269_ad_uid8_fpComplexMulTest_a : STD_LOGIC_VECTOR (13 downto 0);
    signal expOvf_uid269_ad_uid8_fpComplexMulTest_b : STD_LOGIC_VECTOR (13 downto 0);
    signal expOvf_uid269_ad_uid8_fpComplexMulTest_o : STD_LOGIC_VECTOR (13 downto 0);
    signal expOvf_uid269_ad_uid8_fpComplexMulTest_c : STD_LOGIC_VECTOR (0 downto 0);
    signal excXZAndExcYZ_uid270_ad_uid8_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excXZAndExcYR_uid271_ad_uid8_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excYZAndExcXR_uid272_ad_uid8_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excZC3_uid273_ad_uid8_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRZero_uid274_ad_uid8_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excXIAndExcYI_uid275_ad_uid8_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excXRAndExcYI_uid276_ad_uid8_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excYRAndExcXI_uid277_ad_uid8_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal ExcROvfAndInReg_uid278_ad_uid8_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRInf_uid279_ad_uid8_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excYZAndExcXI_uid280_ad_uid8_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excXZAndExcYI_uid281_ad_uid8_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal ZeroTimesInf_uid282_ad_uid8_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRNaN_uid283_ad_uid8_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal concExc_uid284_ad_uid8_fpComplexMulTest_q : STD_LOGIC_VECTOR (2 downto 0);
    signal excREnc_uid285_ad_uid8_fpComplexMulTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal invExcRNaN_uid286_ad_uid8_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal signRPostExc_uid287_ad_uid8_fpComplexMulTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal signRPostExc_uid287_ad_uid8_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal R_uid288_ad_uid8_fpComplexMulTest_q : STD_LOGIC_VECTOR (33 downto 0);
    signal expSum_uid328_bc_uid9_fpComplexMulTest_a : STD_LOGIC_VECTOR (8 downto 0);
    signal expSum_uid328_bc_uid9_fpComplexMulTest_b : STD_LOGIC_VECTOR (8 downto 0);
    signal expSum_uid328_bc_uid9_fpComplexMulTest_o : STD_LOGIC_VECTOR (8 downto 0);
    signal expSum_uid328_bc_uid9_fpComplexMulTest_q : STD_LOGIC_VECTOR (8 downto 0);
    signal expSumMBias_uid330_bc_uid9_fpComplexMulTest_a : STD_LOGIC_VECTOR (11 downto 0);
    signal expSumMBias_uid330_bc_uid9_fpComplexMulTest_b : STD_LOGIC_VECTOR (11 downto 0);
    signal expSumMBias_uid330_bc_uid9_fpComplexMulTest_o : STD_LOGIC_VECTOR (11 downto 0);
    signal expSumMBias_uid330_bc_uid9_fpComplexMulTest_q : STD_LOGIC_VECTOR (10 downto 0);
    signal signR_uid332_bc_uid9_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal normalizeBit_uid333_bc_uid9_fpComplexMulTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal fracRPostNormHigh_uid335_bc_uid9_fpComplexMulTest_in : STD_LOGIC_VECTOR (46 downto 0);
    signal fracRPostNormHigh_uid335_bc_uid9_fpComplexMulTest_b : STD_LOGIC_VECTOR (23 downto 0);
    signal fracRPostNormLow_uid336_bc_uid9_fpComplexMulTest_in : STD_LOGIC_VECTOR (45 downto 0);
    signal fracRPostNormLow_uid336_bc_uid9_fpComplexMulTest_b : STD_LOGIC_VECTOR (23 downto 0);
    signal fracRPostNorm_uid337_bc_uid9_fpComplexMulTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal fracRPostNorm_uid337_bc_uid9_fpComplexMulTest_q : STD_LOGIC_VECTOR (23 downto 0);
    signal stickyRange_uid338_bc_uid9_fpComplexMulTest_in : STD_LOGIC_VECTOR (21 downto 0);
    signal stickyRange_uid338_bc_uid9_fpComplexMulTest_b : STD_LOGIC_VECTOR (21 downto 0);
    signal extraStickyBitOfProd_uid339_bc_uid9_fpComplexMulTest_in : STD_LOGIC_VECTOR (22 downto 0);
    signal extraStickyBitOfProd_uid339_bc_uid9_fpComplexMulTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal extraStickyBit_uid340_bc_uid9_fpComplexMulTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal extraStickyBit_uid340_bc_uid9_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal stickyExtendedRange_uid341_bc_uid9_fpComplexMulTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal stickyRangeComparator_uid343_bc_uid9_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal sticky_uid344_bc_uid9_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracRPostNorm1dto0_uid345_bc_uid9_fpComplexMulTest_in : STD_LOGIC_VECTOR (1 downto 0);
    signal fracRPostNorm1dto0_uid345_bc_uid9_fpComplexMulTest_b : STD_LOGIC_VECTOR (1 downto 0);
    signal lrs_uid346_bc_uid9_fpComplexMulTest_q : STD_LOGIC_VECTOR (2 downto 0);
    signal roundBitDetectionPattern_uid348_bc_uid9_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal roundBit_uid349_bc_uid9_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expFracPreRound_uid350_bc_uid9_fpComplexMulTest_q : STD_LOGIC_VECTOR (34 downto 0);
    signal roundBitAndNormalizationOp_uid352_bc_uid9_fpComplexMulTest_q : STD_LOGIC_VECTOR (25 downto 0);
    signal expFracRPostRounding_uid353_bc_uid9_fpComplexMulTest_a : STD_LOGIC_VECTOR (36 downto 0);
    signal expFracRPostRounding_uid353_bc_uid9_fpComplexMulTest_b : STD_LOGIC_VECTOR (36 downto 0);
    signal expFracRPostRounding_uid353_bc_uid9_fpComplexMulTest_o : STD_LOGIC_VECTOR (36 downto 0);
    signal expFracRPostRounding_uid353_bc_uid9_fpComplexMulTest_q : STD_LOGIC_VECTOR (35 downto 0);
    signal fracRPreExc_uid354_bc_uid9_fpComplexMulTest_in : STD_LOGIC_VECTOR (23 downto 0);
    signal fracRPreExc_uid354_bc_uid9_fpComplexMulTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal expRPreExcExt_uid355_bc_uid9_fpComplexMulTest_b : STD_LOGIC_VECTOR (11 downto 0);
    signal expRPreExc_uid356_bc_uid9_fpComplexMulTest_in : STD_LOGIC_VECTOR (7 downto 0);
    signal expRPreExc_uid356_bc_uid9_fpComplexMulTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal expOvf_uid359_bc_uid9_fpComplexMulTest_a : STD_LOGIC_VECTOR (13 downto 0);
    signal expOvf_uid359_bc_uid9_fpComplexMulTest_b : STD_LOGIC_VECTOR (13 downto 0);
    signal expOvf_uid359_bc_uid9_fpComplexMulTest_o : STD_LOGIC_VECTOR (13 downto 0);
    signal expOvf_uid359_bc_uid9_fpComplexMulTest_c : STD_LOGIC_VECTOR (0 downto 0);
    signal excXZAndExcYZ_uid360_bc_uid9_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excXZAndExcYR_uid361_bc_uid9_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excYZAndExcXR_uid362_bc_uid9_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excZC3_uid363_bc_uid9_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRZero_uid364_bc_uid9_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excXIAndExcYI_uid365_bc_uid9_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excXRAndExcYI_uid366_bc_uid9_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excYRAndExcXI_uid367_bc_uid9_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal ExcROvfAndInReg_uid368_bc_uid9_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRInf_uid369_bc_uid9_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excYZAndExcXI_uid370_bc_uid9_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excXZAndExcYI_uid371_bc_uid9_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal ZeroTimesInf_uid372_bc_uid9_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRNaN_uid373_bc_uid9_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal concExc_uid374_bc_uid9_fpComplexMulTest_q : STD_LOGIC_VECTOR (2 downto 0);
    signal excREnc_uid375_bc_uid9_fpComplexMulTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal invExcRNaN_uid376_bc_uid9_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal signRPostExc_uid377_bc_uid9_fpComplexMulTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal signRPostExc_uid377_bc_uid9_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal R_uid378_bc_uid9_fpComplexMulTest_q : STD_LOGIC_VECTOR (33 downto 0);
    signal excX_uid385_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (1 downto 0);
    signal zero2b_uid386_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal one2b_uid387_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal two2b_uid388_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal three2b_uid389_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal excXZero_uid390_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excXReg_uid391_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excXInf_uid392_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excXNaN_uid393_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excX_uid399_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (1 downto 0);
    signal excXZero_uid404_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excXReg_uid405_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excXInf_uid406_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excXNaN_uid407_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expFracX_uid408_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (30 downto 0);
    signal expFracY_uid409_rReal_uid16_fpComplexMulTest_in : STD_LOGIC_VECTOR (30 downto 0);
    signal expFracY_uid409_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (30 downto 0);
    signal xGTEy_uid410_rReal_uid16_fpComplexMulTest_a : STD_LOGIC_VECTOR (32 downto 0);
    signal xGTEy_uid410_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (32 downto 0);
    signal xGTEy_uid410_rReal_uid16_fpComplexMulTest_o : STD_LOGIC_VECTOR (32 downto 0);
    signal xGTEy_uid410_rReal_uid16_fpComplexMulTest_n : STD_LOGIC_VECTOR (0 downto 0);
    signal xGTEyOrYz_uid411_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invExcXZ_uid412_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal xGTEy_uid413_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal sigY_uid414_rReal_uid16_fpComplexMulTest_in : STD_LOGIC_VECTOR (31 downto 0);
    signal sigY_uid414_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal fracY_uid415_rReal_uid16_fpComplexMulTest_in : STD_LOGIC_VECTOR (22 downto 0);
    signal fracY_uid415_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal expY_uid416_rReal_uid16_fpComplexMulTest_in : STD_LOGIC_VECTOR (30 downto 0);
    signal expY_uid416_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal ypn_uid417_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal xMuxRange_uid419_rReal_uid16_fpComplexMulTest_in : STD_LOGIC_VECTOR (31 downto 0);
    signal xMuxRange_uid419_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (31 downto 0);
    signal aSig_uid421_rReal_uid16_fpComplexMulTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal aSig_uid421_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal bSig_uid422_rReal_uid16_fpComplexMulTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal bSig_uid422_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal excAI_uid423_rReal_uid16_fpComplexMulTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal excAI_uid423_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excAN_uid424_rReal_uid16_fpComplexMulTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal excAN_uid424_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excAR_uid425_rReal_uid16_fpComplexMulTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal excAR_uid425_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excAZ_uid426_rReal_uid16_fpComplexMulTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal excAZ_uid426_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excBI_uid427_rReal_uid16_fpComplexMulTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal excBI_uid427_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excBN_uid428_rReal_uid16_fpComplexMulTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal excBN_uid428_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excBR_uid429_rReal_uid16_fpComplexMulTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal excBR_uid429_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excBZ_uid430_rReal_uid16_fpComplexMulTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal excBZ_uid430_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expA_uid431_rReal_uid16_fpComplexMulTest_in : STD_LOGIC_VECTOR (30 downto 0);
    signal expA_uid431_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal expB_uid432_rReal_uid16_fpComplexMulTest_in : STD_LOGIC_VECTOR (30 downto 0);
    signal expB_uid432_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal fracA_uid433_rReal_uid16_fpComplexMulTest_in : STD_LOGIC_VECTOR (22 downto 0);
    signal fracA_uid433_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal fracB_uid434_rReal_uid16_fpComplexMulTest_in : STD_LOGIC_VECTOR (22 downto 0);
    signal fracB_uid434_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal sigA_uid435_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal sigB_uid436_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal effSub_uid437_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracBz_uid443_rReal_uid16_fpComplexMulTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal fracBz_uid443_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal invExcBZ_uid445_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal oFracB_uid446_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (23 downto 0);
    signal expAmExpB_uid447_rReal_uid16_fpComplexMulTest_a : STD_LOGIC_VECTOR (8 downto 0);
    signal expAmExpB_uid447_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (8 downto 0);
    signal expAmExpB_uid447_rReal_uid16_fpComplexMulTest_i : STD_LOGIC_VECTOR (8 downto 0);
    signal expAmExpB_uid447_rReal_uid16_fpComplexMulTest_o : STD_LOGIC_VECTOR (8 downto 0);
    signal expAmExpB_uid447_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (8 downto 0);
    signal cWFP2_uid448_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal shiftedOut_uid450_rReal_uid16_fpComplexMulTest_a : STD_LOGIC_VECTOR (10 downto 0);
    signal shiftedOut_uid450_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (10 downto 0);
    signal shiftedOut_uid450_rReal_uid16_fpComplexMulTest_o : STD_LOGIC_VECTOR (10 downto 0);
    signal shiftedOut_uid450_rReal_uid16_fpComplexMulTest_c : STD_LOGIC_VECTOR (0 downto 0);
    signal padConst_uid451_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (24 downto 0);
    signal rightPaddedIn_uid452_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (48 downto 0);
    signal iShiftedOut_uid454_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal alignFracBPostShiftOut_uid455_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (48 downto 0);
    signal alignFracBPostShiftOut_uid455_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (48 downto 0);
    signal cmpEQ_stickyBits_cZwF_uid458_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invCmpEQ_stickyBits_cZwF_uid459_rReal_uid16_fpComplexMulTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal invCmpEQ_stickyBits_cZwF_uid459_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal effSubInvSticky_uid461_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracAAddOp_uid464_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (26 downto 0);
    signal fracBAddOp_uid467_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (26 downto 0);
    signal fracBAddOpPostXor_uid468_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (26 downto 0);
    signal fracBAddOpPostXor_uid468_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (26 downto 0);
    signal fracAddResult_uid469_rReal_uid16_fpComplexMulTest_a : STD_LOGIC_VECTOR (27 downto 0);
    signal fracAddResult_uid469_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (27 downto 0);
    signal fracAddResult_uid469_rReal_uid16_fpComplexMulTest_o : STD_LOGIC_VECTOR (27 downto 0);
    signal fracAddResult_uid469_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal rangeFracAddResultMwfp3Dto0_uid470_rReal_uid16_fpComplexMulTest_in : STD_LOGIC_VECTOR (26 downto 0);
    signal rangeFracAddResultMwfp3Dto0_uid470_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (26 downto 0);
    signal fracGRS_uid471_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal cAmA_uid473_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal aMinusA_uid474_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracPostNorm_uid476_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (26 downto 0);
    signal oneCST_uid477_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal expInc_uid478_rReal_uid16_fpComplexMulTest_a : STD_LOGIC_VECTOR (8 downto 0);
    signal expInc_uid478_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (8 downto 0);
    signal expInc_uid478_rReal_uid16_fpComplexMulTest_o : STD_LOGIC_VECTOR (8 downto 0);
    signal expInc_uid478_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (8 downto 0);
    signal expPostNorm_uid479_rReal_uid16_fpComplexMulTest_a : STD_LOGIC_VECTOR (9 downto 0);
    signal expPostNorm_uid479_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (9 downto 0);
    signal expPostNorm_uid479_rReal_uid16_fpComplexMulTest_o : STD_LOGIC_VECTOR (9 downto 0);
    signal expPostNorm_uid479_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (9 downto 0);
    signal Sticky0_uid480_rReal_uid16_fpComplexMulTest_in : STD_LOGIC_VECTOR (0 downto 0);
    signal Sticky0_uid480_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal Sticky1_uid481_rReal_uid16_fpComplexMulTest_in : STD_LOGIC_VECTOR (1 downto 0);
    signal Sticky1_uid481_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal Round_uid482_rReal_uid16_fpComplexMulTest_in : STD_LOGIC_VECTOR (2 downto 0);
    signal Round_uid482_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal Guard_uid483_rReal_uid16_fpComplexMulTest_in : STD_LOGIC_VECTOR (3 downto 0);
    signal Guard_uid483_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal LSB_uid484_rReal_uid16_fpComplexMulTest_in : STD_LOGIC_VECTOR (4 downto 0);
    signal LSB_uid484_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal rndBitCond_uid485_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal cRBit_uid486_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal rBi_uid487_rReal_uid16_fpComplexMulTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal rBi_uid487_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal roundBit_uid488_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracPostNormRndRange_uid489_rReal_uid16_fpComplexMulTest_in : STD_LOGIC_VECTOR (25 downto 0);
    signal fracPostNormRndRange_uid489_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (23 downto 0);
    signal expFracR_uid490_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (33 downto 0);
    signal rndExpFrac_uid491_rReal_uid16_fpComplexMulTest_a : STD_LOGIC_VECTOR (34 downto 0);
    signal rndExpFrac_uid491_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (34 downto 0);
    signal rndExpFrac_uid491_rReal_uid16_fpComplexMulTest_o : STD_LOGIC_VECTOR (34 downto 0);
    signal rndExpFrac_uid491_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (34 downto 0);
    signal wEP2AllOwE_uid492_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (9 downto 0);
    signal rndExp_uid493_rReal_uid16_fpComplexMulTest_in : STD_LOGIC_VECTOR (33 downto 0);
    signal rndExp_uid493_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (9 downto 0);
    signal rOvfEQMax_uid494_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal rndExpFracOvfBits_uid496_rReal_uid16_fpComplexMulTest_in : STD_LOGIC_VECTOR (33 downto 0);
    signal rndExpFracOvfBits_uid496_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (1 downto 0);
    signal rOvfExtraBits_uid497_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal rOvf_uid498_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal wEP2AllZ_uid499_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (9 downto 0);
    signal rUdfEQMin_uid500_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal rUdfExtraBit_uid501_rReal_uid16_fpComplexMulTest_in : STD_LOGIC_VECTOR (33 downto 0);
    signal rUdfExtraBit_uid501_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal rUdf_uid502_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracRPreExc_uid503_rReal_uid16_fpComplexMulTest_in : STD_LOGIC_VECTOR (23 downto 0);
    signal fracRPreExc_uid503_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal expRPreExc_uid504_rReal_uid16_fpComplexMulTest_in : STD_LOGIC_VECTOR (31 downto 0);
    signal expRPreExc_uid504_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal regInputs_uid505_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRZeroVInC_uid506_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal excRZero_uid507_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal aRegBZeroFPLib_uid508_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal aZeroBRegFPLib_uid509_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fpLibRegInputs_uid510_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal rInfOvf_uid511_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRInfVInC_uid512_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (5 downto 0);
    signal excRInf_uid513_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRNaN2_uid514_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excAIBISub_uid515_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRNaN_uid516_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal concExc_uid517_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (2 downto 0);
    signal excREnc_uid518_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal invAMinusA_uid519_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal signRReg_uid520_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal sigBBInf_uid521_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal sigAAInf_uid522_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal signRInf_uid523_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excAZBZSigASigB_uid524_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excBZARSigA_uid525_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal signRZero_uid526_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal signRInfRZRReg_uid527_rReal_uid16_fpComplexMulTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal signRInfRZRReg_uid527_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invExcRNaN_uid528_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal signRPostExc_uid529_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal oneFracRPostExc2_uid530_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal fracRPostExc_uid533_rReal_uid16_fpComplexMulTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal fracRPostExc_uid533_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal expRPostExc_uid537_rReal_uid16_fpComplexMulTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal expRPostExc_uid537_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal R_uid538_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal excX_uid545_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (1 downto 0);
    signal excXZero_uid550_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excXReg_uid551_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excXInf_uid552_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excXNaN_uid553_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excX_uid559_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (1 downto 0);
    signal excXZero_uid564_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excXReg_uid565_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excXInf_uid566_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excXNaN_uid567_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expFracX_uid568_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (30 downto 0);
    signal expFracY_uid569_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (30 downto 0);
    signal xGTEy_uid570_rImag_uid17_fpComplexMulTest_a : STD_LOGIC_VECTOR (32 downto 0);
    signal xGTEy_uid570_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (32 downto 0);
    signal xGTEy_uid570_rImag_uid17_fpComplexMulTest_o : STD_LOGIC_VECTOR (32 downto 0);
    signal xGTEy_uid570_rImag_uid17_fpComplexMulTest_n : STD_LOGIC_VECTOR (0 downto 0);
    signal xGTEyOrYz_uid571_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invExcXZ_uid572_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal xGTEy_uid573_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal sigY_uid574_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal fracY_uid575_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal expY_uid576_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal ypn_uid577_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal xMuxRange_uid579_rImag_uid17_fpComplexMulTest_in : STD_LOGIC_VECTOR (31 downto 0);
    signal xMuxRange_uid579_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (31 downto 0);
    signal aSig_uid581_rImag_uid17_fpComplexMulTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal aSig_uid581_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal bSig_uid582_rImag_uid17_fpComplexMulTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal bSig_uid582_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal excAI_uid583_rImag_uid17_fpComplexMulTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal excAI_uid583_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excAN_uid584_rImag_uid17_fpComplexMulTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal excAN_uid584_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excAR_uid585_rImag_uid17_fpComplexMulTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal excAR_uid585_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excAZ_uid586_rImag_uid17_fpComplexMulTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal excAZ_uid586_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excBI_uid587_rImag_uid17_fpComplexMulTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal excBI_uid587_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excBN_uid588_rImag_uid17_fpComplexMulTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal excBN_uid588_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excBR_uid589_rImag_uid17_fpComplexMulTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal excBR_uid589_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excBZ_uid590_rImag_uid17_fpComplexMulTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal excBZ_uid590_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expA_uid591_rImag_uid17_fpComplexMulTest_in : STD_LOGIC_VECTOR (30 downto 0);
    signal expA_uid591_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal expB_uid592_rImag_uid17_fpComplexMulTest_in : STD_LOGIC_VECTOR (30 downto 0);
    signal expB_uid592_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal fracA_uid593_rImag_uid17_fpComplexMulTest_in : STD_LOGIC_VECTOR (22 downto 0);
    signal fracA_uid593_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal fracB_uid594_rImag_uid17_fpComplexMulTest_in : STD_LOGIC_VECTOR (22 downto 0);
    signal fracB_uid594_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal sigA_uid595_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal sigB_uid596_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal effSub_uid597_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracBz_uid603_rImag_uid17_fpComplexMulTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal fracBz_uid603_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal invExcBZ_uid605_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal oFracB_uid606_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (23 downto 0);
    signal expAmExpB_uid607_rImag_uid17_fpComplexMulTest_a : STD_LOGIC_VECTOR (8 downto 0);
    signal expAmExpB_uid607_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (8 downto 0);
    signal expAmExpB_uid607_rImag_uid17_fpComplexMulTest_i : STD_LOGIC_VECTOR (8 downto 0);
    signal expAmExpB_uid607_rImag_uid17_fpComplexMulTest_o : STD_LOGIC_VECTOR (8 downto 0);
    signal expAmExpB_uid607_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (8 downto 0);
    signal shiftedOut_uid610_rImag_uid17_fpComplexMulTest_a : STD_LOGIC_VECTOR (10 downto 0);
    signal shiftedOut_uid610_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (10 downto 0);
    signal shiftedOut_uid610_rImag_uid17_fpComplexMulTest_o : STD_LOGIC_VECTOR (10 downto 0);
    signal shiftedOut_uid610_rImag_uid17_fpComplexMulTest_c : STD_LOGIC_VECTOR (0 downto 0);
    signal rightPaddedIn_uid612_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (48 downto 0);
    signal iShiftedOut_uid614_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal alignFracBPostShiftOut_uid615_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (48 downto 0);
    signal alignFracBPostShiftOut_uid615_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (48 downto 0);
    signal cmpEQ_stickyBits_cZwF_uid618_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invCmpEQ_stickyBits_cZwF_uid619_rImag_uid17_fpComplexMulTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal invCmpEQ_stickyBits_cZwF_uid619_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal effSubInvSticky_uid621_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracAAddOp_uid624_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (26 downto 0);
    signal fracBAddOp_uid627_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (26 downto 0);
    signal fracBAddOpPostXor_uid628_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (26 downto 0);
    signal fracBAddOpPostXor_uid628_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (26 downto 0);
    signal fracAddResult_uid629_rImag_uid17_fpComplexMulTest_a : STD_LOGIC_VECTOR (27 downto 0);
    signal fracAddResult_uid629_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (27 downto 0);
    signal fracAddResult_uid629_rImag_uid17_fpComplexMulTest_o : STD_LOGIC_VECTOR (27 downto 0);
    signal fracAddResult_uid629_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal rangeFracAddResultMwfp3Dto0_uid630_rImag_uid17_fpComplexMulTest_in : STD_LOGIC_VECTOR (26 downto 0);
    signal rangeFracAddResultMwfp3Dto0_uid630_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (26 downto 0);
    signal fracGRS_uid631_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal aMinusA_uid634_rImag_uid17_fpComplexMulTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal aMinusA_uid634_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracPostNorm_uid636_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (26 downto 0);
    signal expInc_uid638_rImag_uid17_fpComplexMulTest_a : STD_LOGIC_VECTOR (8 downto 0);
    signal expInc_uid638_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (8 downto 0);
    signal expInc_uid638_rImag_uid17_fpComplexMulTest_o : STD_LOGIC_VECTOR (8 downto 0);
    signal expInc_uid638_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (8 downto 0);
    signal expPostNorm_uid639_rImag_uid17_fpComplexMulTest_a : STD_LOGIC_VECTOR (9 downto 0);
    signal expPostNorm_uid639_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (9 downto 0);
    signal expPostNorm_uid639_rImag_uid17_fpComplexMulTest_o : STD_LOGIC_VECTOR (9 downto 0);
    signal expPostNorm_uid639_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (9 downto 0);
    signal Sticky0_uid640_rImag_uid17_fpComplexMulTest_in : STD_LOGIC_VECTOR (0 downto 0);
    signal Sticky0_uid640_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal Sticky1_uid641_rImag_uid17_fpComplexMulTest_in : STD_LOGIC_VECTOR (1 downto 0);
    signal Sticky1_uid641_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal Round_uid642_rImag_uid17_fpComplexMulTest_in : STD_LOGIC_VECTOR (2 downto 0);
    signal Round_uid642_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal Guard_uid643_rImag_uid17_fpComplexMulTest_in : STD_LOGIC_VECTOR (3 downto 0);
    signal Guard_uid643_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal LSB_uid644_rImag_uid17_fpComplexMulTest_in : STD_LOGIC_VECTOR (4 downto 0);
    signal LSB_uid644_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal rndBitCond_uid645_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal rBi_uid647_rImag_uid17_fpComplexMulTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal rBi_uid647_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal roundBit_uid648_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracPostNormRndRange_uid649_rImag_uid17_fpComplexMulTest_in : STD_LOGIC_VECTOR (25 downto 0);
    signal fracPostNormRndRange_uid649_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (23 downto 0);
    signal expFracR_uid650_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (33 downto 0);
    signal rndExpFrac_uid651_rImag_uid17_fpComplexMulTest_a : STD_LOGIC_VECTOR (34 downto 0);
    signal rndExpFrac_uid651_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (34 downto 0);
    signal rndExpFrac_uid651_rImag_uid17_fpComplexMulTest_o : STD_LOGIC_VECTOR (34 downto 0);
    signal rndExpFrac_uid651_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (34 downto 0);
    signal rndExp_uid653_rImag_uid17_fpComplexMulTest_in : STD_LOGIC_VECTOR (33 downto 0);
    signal rndExp_uid653_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (9 downto 0);
    signal rOvfEQMax_uid654_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal rndExpFracOvfBits_uid656_rImag_uid17_fpComplexMulTest_in : STD_LOGIC_VECTOR (33 downto 0);
    signal rndExpFracOvfBits_uid656_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (1 downto 0);
    signal rOvfExtraBits_uid657_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal rOvf_uid658_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal rUdfEQMin_uid660_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal rUdfExtraBit_uid661_rImag_uid17_fpComplexMulTest_in : STD_LOGIC_VECTOR (33 downto 0);
    signal rUdfExtraBit_uid661_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal rUdf_uid662_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracRPreExc_uid663_rImag_uid17_fpComplexMulTest_in : STD_LOGIC_VECTOR (23 downto 0);
    signal fracRPreExc_uid663_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal expRPreExc_uid664_rImag_uid17_fpComplexMulTest_in : STD_LOGIC_VECTOR (31 downto 0);
    signal expRPreExc_uid664_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal regInputs_uid665_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRZeroVInC_uid666_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal excRZero_uid667_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal aRegBZeroFPLib_uid668_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal aZeroBRegFPLib_uid669_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fpLibRegInputs_uid670_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal rInfOvf_uid671_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRInfVInC_uid672_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (5 downto 0);
    signal excRInf_uid673_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRNaN2_uid674_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excAIBISub_uid675_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRNaN_uid676_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal concExc_uid677_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (2 downto 0);
    signal excREnc_uid678_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal invAMinusA_uid679_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal signRReg_uid680_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal sigBBInf_uid681_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal sigAAInf_uid682_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal signRInf_uid683_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excAZBZSigASigB_uid684_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excBZARSigA_uid685_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal signRZero_uid686_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal signRInfRZRReg_uid687_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invExcRNaN_uid688_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal signRPostExc_uid689_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracRPostExc_uid693_rImag_uid17_fpComplexMulTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal fracRPostExc_uid693_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal expRPostExc_uid697_rImag_uid17_fpComplexMulTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal expRPostExc_uid697_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal R_uid698_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal zs_uid712_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal rVStage_uid713_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (15 downto 0);
    signal vCount_uid714_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal mO_uid715_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (3 downto 0);
    signal vStage_uid716_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_in : STD_LOGIC_VECTOR (11 downto 0);
    signal vStage_uid716_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (11 downto 0);
    signal cStage_uid717_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal vStagei_uid719_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid719_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal vCount_uid722_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid725_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid725_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal zs_uid726_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (3 downto 0);
    signal vCount_uid728_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid731_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid731_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (3 downto 0);
    signal vCount_uid734_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid737_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid737_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal rVStage_uid739_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal vCount_uid740_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal r_uid741_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal rVStage_uid744_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (15 downto 0);
    signal vCount_uid745_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal vStage_uid747_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_in : STD_LOGIC_VECTOR (11 downto 0);
    signal vStage_uid747_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (11 downto 0);
    signal cStage_uid748_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal vStagei_uid750_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid750_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal vCount_uid753_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid756_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid756_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal vCount_uid759_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid762_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid762_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (3 downto 0);
    signal vCount_uid765_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid768_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid768_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal rVStage_uid770_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal vCount_uid771_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal r_uid772_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal expUdf_uid87_ac_uid6_fpComplexMulTest_cmp_sign_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expUdf_uid177_bd_uid7_fpComplexMulTest_cmp_sign_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expUdf_uid267_ad_uid8_fpComplexMulTest_cmp_sign_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expUdf_uid357_bc_uid9_fpComplexMulTest_cmp_sign_q : STD_LOGIC_VECTOR (0 downto 0);
    signal wIntCst_uid784_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (5 downto 0);
    signal shiftedOut_uid785_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_a : STD_LOGIC_VECTOR (10 downto 0);
    signal shiftedOut_uid785_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (10 downto 0);
    signal shiftedOut_uid785_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_o : STD_LOGIC_VECTOR (10 downto 0);
    signal shiftedOut_uid785_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_n : STD_LOGIC_VECTOR (0 downto 0);
    signal rightShiftStage0Idx1Rng16_uid786_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (32 downto 0);
    signal rightShiftStage0Idx1_uid788_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (48 downto 0);
    signal rightShiftStage0Idx2Rng32_uid789_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (16 downto 0);
    signal rightShiftStage0Idx2Pad32_uid790_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal rightShiftStage0Idx2_uid791_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (48 downto 0);
    signal rightShiftStage0Idx3Rng48_uid792_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal rightShiftStage0Idx3Pad48_uid793_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (47 downto 0);
    signal rightShiftStage0Idx3_uid794_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (48 downto 0);
    signal rightShiftStage0_uid796_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStage0_uid796_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (48 downto 0);
    signal rightShiftStage1Idx1Rng4_uid797_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (44 downto 0);
    signal rightShiftStage1Idx1_uid799_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (48 downto 0);
    signal rightShiftStage1Idx2Rng8_uid800_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (40 downto 0);
    signal rightShiftStage1Idx2_uid802_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (48 downto 0);
    signal rightShiftStage1Idx3Rng12_uid803_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (36 downto 0);
    signal rightShiftStage1Idx3Pad12_uid804_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (11 downto 0);
    signal rightShiftStage1Idx3_uid805_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (48 downto 0);
    signal rightShiftStage1_uid807_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStage1_uid807_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (48 downto 0);
    signal rightShiftStage2Idx1Rng1_uid808_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (47 downto 0);
    signal rightShiftStage2Idx1_uid810_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (48 downto 0);
    signal rightShiftStage2Idx2Rng2_uid811_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (46 downto 0);
    signal rightShiftStage2Idx2_uid813_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (48 downto 0);
    signal rightShiftStage2Idx3Rng3_uid814_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (45 downto 0);
    signal rightShiftStage2Idx3Pad3_uid815_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (2 downto 0);
    signal rightShiftStage2Idx3_uid816_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (48 downto 0);
    signal rightShiftStage2_uid818_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStage2_uid818_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (48 downto 0);
    signal zeroOutCst_uid819_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (48 downto 0);
    signal r_uid820_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal r_uid820_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (48 downto 0);
    signal leftShiftStage0Idx1Rng8_uid825_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_in : STD_LOGIC_VECTOR (19 downto 0);
    signal leftShiftStage0Idx1Rng8_uid825_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (19 downto 0);
    signal leftShiftStage0Idx1_uid826_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal leftShiftStage0Idx2_uid829_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal leftShiftStage0Idx3Pad24_uid830_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (23 downto 0);
    signal leftShiftStage0Idx3Rng24_uid831_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_in : STD_LOGIC_VECTOR (3 downto 0);
    signal leftShiftStage0Idx3Rng24_uid831_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (3 downto 0);
    signal leftShiftStage0Idx3_uid832_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal leftShiftStage0_uid834_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal leftShiftStage0_uid834_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal leftShiftStage1Idx1Rng2_uid836_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_in : STD_LOGIC_VECTOR (25 downto 0);
    signal leftShiftStage1Idx1Rng2_uid836_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (25 downto 0);
    signal leftShiftStage1Idx1_uid837_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal leftShiftStage1Idx2Rng4_uid839_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_in : STD_LOGIC_VECTOR (23 downto 0);
    signal leftShiftStage1Idx2Rng4_uid839_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (23 downto 0);
    signal leftShiftStage1Idx2_uid840_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal leftShiftStage1Idx3Pad6_uid841_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (5 downto 0);
    signal leftShiftStage1Idx3Rng6_uid842_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_in : STD_LOGIC_VECTOR (21 downto 0);
    signal leftShiftStage1Idx3Rng6_uid842_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (21 downto 0);
    signal leftShiftStage1Idx3_uid843_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal leftShiftStage1_uid845_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal leftShiftStage1_uid845_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal leftShiftStage2Idx1Rng1_uid847_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_in : STD_LOGIC_VECTOR (26 downto 0);
    signal leftShiftStage2Idx1Rng1_uid847_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_b : STD_LOGIC_VECTOR (26 downto 0);
    signal leftShiftStage2Idx1_uid848_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal leftShiftStage2_uid850_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal leftShiftStage2_uid850_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal shiftedOut_uid855_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_a : STD_LOGIC_VECTOR (10 downto 0);
    signal shiftedOut_uid855_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (10 downto 0);
    signal shiftedOut_uid855_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_o : STD_LOGIC_VECTOR (10 downto 0);
    signal shiftedOut_uid855_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_n : STD_LOGIC_VECTOR (0 downto 0);
    signal rightShiftStage0Idx1Rng16_uid856_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (32 downto 0);
    signal rightShiftStage0Idx1_uid858_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (48 downto 0);
    signal rightShiftStage0Idx2Rng32_uid859_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (16 downto 0);
    signal rightShiftStage0Idx2_uid861_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (48 downto 0);
    signal rightShiftStage0Idx3Rng48_uid862_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal rightShiftStage0Idx3_uid864_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (48 downto 0);
    signal rightShiftStage0_uid866_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStage0_uid866_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (48 downto 0);
    signal rightShiftStage1Idx1Rng4_uid867_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (44 downto 0);
    signal rightShiftStage1Idx1_uid869_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (48 downto 0);
    signal rightShiftStage1Idx2Rng8_uid870_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (40 downto 0);
    signal rightShiftStage1Idx2_uid872_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (48 downto 0);
    signal rightShiftStage1Idx3Rng12_uid873_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (36 downto 0);
    signal rightShiftStage1Idx3_uid875_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (48 downto 0);
    signal rightShiftStage1_uid877_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStage1_uid877_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (48 downto 0);
    signal rightShiftStage2Idx1Rng1_uid878_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (47 downto 0);
    signal rightShiftStage2Idx1_uid880_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (48 downto 0);
    signal rightShiftStage2Idx2Rng2_uid881_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (46 downto 0);
    signal rightShiftStage2Idx2_uid883_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (48 downto 0);
    signal rightShiftStage2Idx3Rng3_uid884_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (45 downto 0);
    signal rightShiftStage2Idx3_uid886_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (48 downto 0);
    signal rightShiftStage2_uid888_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStage2_uid888_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (48 downto 0);
    signal r_uid890_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal r_uid890_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (48 downto 0);
    signal leftShiftStage0Idx1Rng8_uid895_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_in : STD_LOGIC_VECTOR (19 downto 0);
    signal leftShiftStage0Idx1Rng8_uid895_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (19 downto 0);
    signal leftShiftStage0Idx1_uid896_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal leftShiftStage0Idx2_uid899_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal leftShiftStage0Idx3Rng24_uid901_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_in : STD_LOGIC_VECTOR (3 downto 0);
    signal leftShiftStage0Idx3Rng24_uid901_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (3 downto 0);
    signal leftShiftStage0Idx3_uid902_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal leftShiftStage0_uid904_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal leftShiftStage0_uid904_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal leftShiftStage1Idx1Rng2_uid906_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_in : STD_LOGIC_VECTOR (25 downto 0);
    signal leftShiftStage1Idx1Rng2_uid906_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (25 downto 0);
    signal leftShiftStage1Idx1_uid907_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal leftShiftStage1Idx2Rng4_uid909_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_in : STD_LOGIC_VECTOR (23 downto 0);
    signal leftShiftStage1Idx2Rng4_uid909_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (23 downto 0);
    signal leftShiftStage1Idx2_uid910_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal leftShiftStage1Idx3Rng6_uid912_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_in : STD_LOGIC_VECTOR (21 downto 0);
    signal leftShiftStage1Idx3Rng6_uid912_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (21 downto 0);
    signal leftShiftStage1Idx3_uid913_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal leftShiftStage1_uid915_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal leftShiftStage1_uid915_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal leftShiftStage2Idx1Rng1_uid917_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_in : STD_LOGIC_VECTOR (26 downto 0);
    signal leftShiftStage2Idx1Rng1_uid917_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_b : STD_LOGIC_VECTOR (26 downto 0);
    signal leftShiftStage2Idx1_uid918_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal leftShiftStage2_uid920_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal leftShiftStage2_uid920_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_reset : std_logic;
    type prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_a0type is array(NATURAL range <>) of UNSIGNED(23 downto 0);
    signal prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_a0 : prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_a0type(0 to 0);
    attribute preserve : boolean;
    attribute preserve of prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_a0 : signal is true;
    signal prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_c0 : prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_a0type(0 to 0);
    attribute preserve of prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_c0 : signal is true;
    type prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_ptype is array(NATURAL range <>) of UNSIGNED(47 downto 0);
    signal prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_p : prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_ptype(0 to 0);
    signal prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_u : prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_ptype(0 to 0);
    signal prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_w : prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_ptype(0 to 0);
    signal prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_x : prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_ptype(0 to 0);
    signal prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_y : prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_ptype(0 to 0);
    signal prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_s : prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_ptype(0 to 0);
    signal prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_qq : STD_LOGIC_VECTOR (47 downto 0);
    signal prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_q : STD_LOGIC_VECTOR (47 downto 0);
    signal prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_ena0 : std_logic;
    signal prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_ena1 : std_logic;
    signal prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_reset : std_logic;
    signal prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_a0 : prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_a0type(0 to 0);
    attribute preserve of prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_a0 : signal is true;
    signal prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_c0 : prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_a0type(0 to 0);
    attribute preserve of prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_c0 : signal is true;
    signal prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_p : prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_ptype(0 to 0);
    signal prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_u : prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_ptype(0 to 0);
    signal prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_w : prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_ptype(0 to 0);
    signal prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_x : prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_ptype(0 to 0);
    signal prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_y : prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_ptype(0 to 0);
    signal prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_s : prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_ptype(0 to 0);
    signal prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_qq : STD_LOGIC_VECTOR (47 downto 0);
    signal prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_q : STD_LOGIC_VECTOR (47 downto 0);
    signal prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_ena0 : std_logic;
    signal prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_ena1 : std_logic;
    signal prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_reset : std_logic;
    signal prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_a0 : prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_a0type(0 to 0);
    attribute preserve of prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_a0 : signal is true;
    signal prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_c0 : prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_a0type(0 to 0);
    attribute preserve of prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_c0 : signal is true;
    signal prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_p : prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_ptype(0 to 0);
    signal prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_u : prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_ptype(0 to 0);
    signal prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_w : prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_ptype(0 to 0);
    signal prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_x : prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_ptype(0 to 0);
    signal prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_y : prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_ptype(0 to 0);
    signal prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_s : prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_ptype(0 to 0);
    signal prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_qq : STD_LOGIC_VECTOR (47 downto 0);
    signal prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_q : STD_LOGIC_VECTOR (47 downto 0);
    signal prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_ena0 : std_logic;
    signal prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_ena1 : std_logic;
    signal prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_reset : std_logic;
    signal prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_a0 : prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_a0type(0 to 0);
    attribute preserve of prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_a0 : signal is true;
    signal prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_c0 : prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_a0type(0 to 0);
    attribute preserve of prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_c0 : signal is true;
    signal prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_p : prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_ptype(0 to 0);
    signal prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_u : prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_ptype(0 to 0);
    signal prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_w : prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_ptype(0 to 0);
    signal prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_x : prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_ptype(0 to 0);
    signal prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_y : prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_ptype(0 to 0);
    signal prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_s : prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_ptype(0 to 0);
    signal prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_qq : STD_LOGIC_VECTOR (47 downto 0);
    signal prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_q : STD_LOGIC_VECTOR (47 downto 0);
    signal prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_ena0 : std_logic;
    signal prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_ena1 : std_logic;
    signal rightShiftStageSel5Dto4_uid795_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_merged_bit_select_in : STD_LOGIC_VECTOR (5 downto 0);
    signal rightShiftStageSel5Dto4_uid795_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_merged_bit_select_b : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStageSel5Dto4_uid795_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_merged_bit_select_c : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStageSel5Dto4_uid795_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_merged_bit_select_d : STD_LOGIC_VECTOR (1 downto 0);
    signal stickyBits_uid456_rReal_uid16_fpComplexMulTest_merged_bit_select_b : STD_LOGIC_VECTOR (22 downto 0);
    signal stickyBits_uid456_rReal_uid16_fpComplexMulTest_merged_bit_select_c : STD_LOGIC_VECTOR (25 downto 0);
    signal rightShiftStageSel5Dto4_uid865_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_merged_bit_select_in : STD_LOGIC_VECTOR (5 downto 0);
    signal rightShiftStageSel5Dto4_uid865_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_merged_bit_select_b : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStageSel5Dto4_uid865_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_merged_bit_select_c : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStageSel5Dto4_uid865_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_merged_bit_select_d : STD_LOGIC_VECTOR (1 downto 0);
    signal stickyBits_uid616_rImag_uid17_fpComplexMulTest_merged_bit_select_b : STD_LOGIC_VECTOR (22 downto 0);
    signal stickyBits_uid616_rImag_uid17_fpComplexMulTest_merged_bit_select_c : STD_LOGIC_VECTOR (25 downto 0);
    signal rVStage_uid721_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_merged_bit_select_b : STD_LOGIC_VECTOR (7 downto 0);
    signal rVStage_uid721_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_merged_bit_select_c : STD_LOGIC_VECTOR (7 downto 0);
    signal rVStage_uid727_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_merged_bit_select_b : STD_LOGIC_VECTOR (3 downto 0);
    signal rVStage_uid727_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_merged_bit_select_c : STD_LOGIC_VECTOR (3 downto 0);
    signal rVStage_uid733_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_merged_bit_select_b : STD_LOGIC_VECTOR (1 downto 0);
    signal rVStage_uid733_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_merged_bit_select_c : STD_LOGIC_VECTOR (1 downto 0);
    signal leftShiftStageSel4Dto3_uid833_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_merged_bit_select_b : STD_LOGIC_VECTOR (1 downto 0);
    signal leftShiftStageSel4Dto3_uid833_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_merged_bit_select_c : STD_LOGIC_VECTOR (1 downto 0);
    signal leftShiftStageSel4Dto3_uid833_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_merged_bit_select_d : STD_LOGIC_VECTOR (0 downto 0);
    signal rVStage_uid752_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_merged_bit_select_b : STD_LOGIC_VECTOR (7 downto 0);
    signal rVStage_uid752_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_merged_bit_select_c : STD_LOGIC_VECTOR (7 downto 0);
    signal rVStage_uid758_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_merged_bit_select_b : STD_LOGIC_VECTOR (3 downto 0);
    signal rVStage_uid758_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_merged_bit_select_c : STD_LOGIC_VECTOR (3 downto 0);
    signal rVStage_uid764_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_merged_bit_select_b : STD_LOGIC_VECTOR (1 downto 0);
    signal rVStage_uid764_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_merged_bit_select_c : STD_LOGIC_VECTOR (1 downto 0);
    signal leftShiftStageSel4Dto3_uid903_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_merged_bit_select_b : STD_LOGIC_VECTOR (1 downto 0);
    signal leftShiftStageSel4Dto3_uid903_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_merged_bit_select_c : STD_LOGIC_VECTOR (1 downto 0);
    signal leftShiftStageSel4Dto3_uid903_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_merged_bit_select_d : STD_LOGIC_VECTOR (0 downto 0);
    signal redist0_fracPostNormRndRange_uid649_rImag_uid17_fpComplexMulTest_b_1_q : STD_LOGIC_VECTOR (23 downto 0);
    signal redist1_rangeFracAddResultMwfp3Dto0_uid630_rImag_uid17_fpComplexMulTest_b_1_q : STD_LOGIC_VECTOR (26 downto 0);
    signal redist2_effSub_uid597_rImag_uid17_fpComplexMulTest_q_2_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist3_sigB_uid596_rImag_uid17_fpComplexMulTest_b_1_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist4_sigB_uid596_rImag_uid17_fpComplexMulTest_b_3_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist5_sigA_uid595_rImag_uid17_fpComplexMulTest_b_1_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist6_sigA_uid595_rImag_uid17_fpComplexMulTest_b_3_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist7_fracB_uid594_rImag_uid17_fpComplexMulTest_b_1_q : STD_LOGIC_VECTOR (22 downto 0);
    signal redist8_fracA_uid593_rImag_uid17_fpComplexMulTest_b_1_q : STD_LOGIC_VECTOR (22 downto 0);
    signal redist9_expA_uid591_rImag_uid17_fpComplexMulTest_b_2_q : STD_LOGIC_VECTOR (7 downto 0);
    signal redist10_excBZ_uid590_rImag_uid17_fpComplexMulTest_q_1_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist11_excBZ_uid590_rImag_uid17_fpComplexMulTest_q_3_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist12_excAZ_uid586_rImag_uid17_fpComplexMulTest_q_3_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist13_xGTEy_uid573_rImag_uid17_fpComplexMulTest_q_3_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist14_excX_uid559_rImag_uid17_fpComplexMulTest_b_3_q : STD_LOGIC_VECTOR (1 downto 0);
    signal redist15_excX_uid545_rImag_uid17_fpComplexMulTest_b_3_q : STD_LOGIC_VECTOR (1 downto 0);
    signal redist16_fracPostNormRndRange_uid489_rReal_uid16_fpComplexMulTest_b_1_q : STD_LOGIC_VECTOR (23 downto 0);
    signal redist17_aMinusA_uid474_rReal_uid16_fpComplexMulTest_q_1_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist18_rangeFracAddResultMwfp3Dto0_uid470_rReal_uid16_fpComplexMulTest_b_1_q : STD_LOGIC_VECTOR (26 downto 0);
    signal redist19_effSub_uid437_rReal_uid16_fpComplexMulTest_q_2_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist20_sigB_uid436_rReal_uid16_fpComplexMulTest_b_1_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist21_sigB_uid436_rReal_uid16_fpComplexMulTest_b_2_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist22_sigA_uid435_rReal_uid16_fpComplexMulTest_b_1_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist23_sigA_uid435_rReal_uid16_fpComplexMulTest_b_2_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist24_fracB_uid434_rReal_uid16_fpComplexMulTest_b_1_q : STD_LOGIC_VECTOR (22 downto 0);
    signal redist25_fracA_uid433_rReal_uid16_fpComplexMulTest_b_1_q : STD_LOGIC_VECTOR (22 downto 0);
    signal redist26_expA_uid431_rReal_uid16_fpComplexMulTest_b_2_q : STD_LOGIC_VECTOR (7 downto 0);
    signal redist27_excBZ_uid430_rReal_uid16_fpComplexMulTest_q_1_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist28_excBZ_uid430_rReal_uid16_fpComplexMulTest_q_2_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist29_excBZ_uid430_rReal_uid16_fpComplexMulTest_q_3_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist30_excBR_uid429_rReal_uid16_fpComplexMulTest_q_1_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist31_excBI_uid427_rReal_uid16_fpComplexMulTest_q_1_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist32_excAZ_uid426_rReal_uid16_fpComplexMulTest_q_2_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist33_excAZ_uid426_rReal_uid16_fpComplexMulTest_q_3_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist34_excAR_uid425_rReal_uid16_fpComplexMulTest_q_1_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist35_excAI_uid423_rReal_uid16_fpComplexMulTest_q_1_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist36_xGTEy_uid413_rReal_uid16_fpComplexMulTest_q_2_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist37_excX_uid399_rReal_uid16_fpComplexMulTest_b_2_q : STD_LOGIC_VECTOR (1 downto 0);
    signal redist38_excX_uid385_rReal_uid16_fpComplexMulTest_b_2_q : STD_LOGIC_VECTOR (1 downto 0);
    signal redist39_expRPreExc_uid356_bc_uid9_fpComplexMulTest_b_1_q : STD_LOGIC_VECTOR (7 downto 0);
    signal redist40_fracRPreExc_uid354_bc_uid9_fpComplexMulTest_b_1_q : STD_LOGIC_VECTOR (22 downto 0);
    signal redist41_expRPreExc_uid266_ad_uid8_fpComplexMulTest_b_1_q : STD_LOGIC_VECTOR (7 downto 0);
    signal redist42_fracRPreExc_uid264_ad_uid8_fpComplexMulTest_b_1_q : STD_LOGIC_VECTOR (22 downto 0);
    signal redist43_fracXIsZero_uid135_bd_uid7_fpComplexMulTest_q_2_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist44_fracXIsZero_uid121_bd_uid7_fpComplexMulTest_q_2_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist45_signY_uid113_bd_uid7_fpComplexMulTest_b_2_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist46_signX_uid112_bd_uid7_fpComplexMulTest_b_2_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist47_expY_uid111_bd_uid7_fpComplexMulTest_b_2_q : STD_LOGIC_VECTOR (7 downto 0);
    signal redist48_expX_uid110_bd_uid7_fpComplexMulTest_b_2_q : STD_LOGIC_VECTOR (7 downto 0);
    signal redist49_expRPreExc_uid86_ac_uid6_fpComplexMulTest_b_1_q : STD_LOGIC_VECTOR (7 downto 0);
    signal redist50_fracRPreExc_uid84_ac_uid6_fpComplexMulTest_b_1_q : STD_LOGIC_VECTOR (22 downto 0);
    signal redist51_fracXIsZero_uid45_ac_uid6_fpComplexMulTest_q_2_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist52_fracXIsZero_uid31_ac_uid6_fpComplexMulTest_q_2_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist53_signY_uid23_ac_uid6_fpComplexMulTest_b_2_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist54_signX_uid22_ac_uid6_fpComplexMulTest_b_2_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist55_expY_uid21_ac_uid6_fpComplexMulTest_b_2_q : STD_LOGIC_VECTOR (7 downto 0);
    signal redist56_expX_uid20_ac_uid6_fpComplexMulTest_b_2_q : STD_LOGIC_VECTOR (7 downto 0);
    signal redist57_exp_uid13_fpComplexMulTest_b_1_q : STD_LOGIC_VECTOR (7 downto 0);
    signal redist58_fraction_uid12_fpComplexMulTest_b_1_q : STD_LOGIC_VECTOR (22 downto 0);
    signal redist59_excBits_uid11_fpComplexMulTest_b_1_q : STD_LOGIC_VECTOR (1 downto 0);
    signal redist60_ySign_uid10_fpComplexMulTest_b_1_q : STD_LOGIC_VECTOR (0 downto 0);

begin


    -- cAmA_uid473_rReal_uid16_fpComplexMulTest(CONSTANT,472)
    cAmA_uid473_rReal_uid16_fpComplexMulTest_q <= "11100";

    -- zs_uid712_lzCountVal_uid472_rReal_uid16_fpComplexMulTest(CONSTANT,711)
    zs_uid712_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q <= "0000000000000000";

    -- frac_x_uid118_bd_uid7_fpComplexMulTest(BITSELECT,117)@0
    frac_x_uid118_bd_uid7_fpComplexMulTest_b <= b(22 downto 0);

    -- cstZeroWF_uid25_ac_uid6_fpComplexMulTest(CONSTANT,24)
    cstZeroWF_uid25_ac_uid6_fpComplexMulTest_q <= "00000000000000000000000";

    -- fracXIsZero_uid121_bd_uid7_fpComplexMulTest(LOGICAL,120)@0 + 1
    fracXIsZero_uid121_bd_uid7_fpComplexMulTest_qi <= "1" WHEN cstZeroWF_uid25_ac_uid6_fpComplexMulTest_q = frac_x_uid118_bd_uid7_fpComplexMulTest_b ELSE "0";
    fracXIsZero_uid121_bd_uid7_fpComplexMulTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracXIsZero_uid121_bd_uid7_fpComplexMulTest_qi, xout => fracXIsZero_uid121_bd_uid7_fpComplexMulTest_q, clk => clk, aclr => areset );

    -- redist44_fracXIsZero_uid121_bd_uid7_fpComplexMulTest_q_2(DELAY,981)
    redist44_fracXIsZero_uid121_bd_uid7_fpComplexMulTest_q_2 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracXIsZero_uid121_bd_uid7_fpComplexMulTest_q, xout => redist44_fracXIsZero_uid121_bd_uid7_fpComplexMulTest_q_2_q, clk => clk, aclr => areset );

    -- cstAllOWE_uid24_ac_uid6_fpComplexMulTest(CONSTANT,23)
    cstAllOWE_uid24_ac_uid6_fpComplexMulTest_q <= "11111111";

    -- expX_uid110_bd_uid7_fpComplexMulTest(BITSELECT,109)@0
    expX_uid110_bd_uid7_fpComplexMulTest_b <= b(30 downto 23);

    -- redist48_expX_uid110_bd_uid7_fpComplexMulTest_b_2(DELAY,985)
    redist48_expX_uid110_bd_uid7_fpComplexMulTest_b_2 : dspba_delay
    GENERIC MAP ( width => 8, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => expX_uid110_bd_uid7_fpComplexMulTest_b, xout => redist48_expX_uid110_bd_uid7_fpComplexMulTest_b_2_q, clk => clk, aclr => areset );

    -- expXIsMax_uid120_bd_uid7_fpComplexMulTest(LOGICAL,119)@2
    expXIsMax_uid120_bd_uid7_fpComplexMulTest_q <= "1" WHEN redist48_expX_uid110_bd_uid7_fpComplexMulTest_b_2_q = cstAllOWE_uid24_ac_uid6_fpComplexMulTest_q ELSE "0";

    -- excI_x_uid123_bd_uid7_fpComplexMulTest(LOGICAL,122)@2
    excI_x_uid123_bd_uid7_fpComplexMulTest_q <= expXIsMax_uid120_bd_uid7_fpComplexMulTest_q and redist44_fracXIsZero_uid121_bd_uid7_fpComplexMulTest_q_2_q;

    -- cstAllZWE_uid26_ac_uid6_fpComplexMulTest(CONSTANT,25)
    cstAllZWE_uid26_ac_uid6_fpComplexMulTest_q <= "00000000";

    -- expY_uid21_ac_uid6_fpComplexMulTest(BITSELECT,20)@0
    expY_uid21_ac_uid6_fpComplexMulTest_b <= c(30 downto 23);

    -- redist55_expY_uid21_ac_uid6_fpComplexMulTest_b_2(DELAY,992)
    redist55_expY_uid21_ac_uid6_fpComplexMulTest_b_2 : dspba_delay
    GENERIC MAP ( width => 8, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => expY_uid21_ac_uid6_fpComplexMulTest_b, xout => redist55_expY_uid21_ac_uid6_fpComplexMulTest_b_2_q, clk => clk, aclr => areset );

    -- excZ_y_uid43_ac_uid6_fpComplexMulTest(LOGICAL,42)@2
    excZ_y_uid43_ac_uid6_fpComplexMulTest_q <= "1" WHEN redist55_expY_uid21_ac_uid6_fpComplexMulTest_b_2_q = cstAllZWE_uid26_ac_uid6_fpComplexMulTest_q ELSE "0";

    -- excYZAndExcXI_uid370_bc_uid9_fpComplexMulTest(LOGICAL,369)@2
    excYZAndExcXI_uid370_bc_uid9_fpComplexMulTest_q <= excZ_y_uid43_ac_uid6_fpComplexMulTest_q and excI_x_uid123_bd_uid7_fpComplexMulTest_q;

    -- frac_y_uid42_ac_uid6_fpComplexMulTest(BITSELECT,41)@0
    frac_y_uid42_ac_uid6_fpComplexMulTest_b <= c(22 downto 0);

    -- fracXIsZero_uid45_ac_uid6_fpComplexMulTest(LOGICAL,44)@0 + 1
    fracXIsZero_uid45_ac_uid6_fpComplexMulTest_qi <= "1" WHEN cstZeroWF_uid25_ac_uid6_fpComplexMulTest_q = frac_y_uid42_ac_uid6_fpComplexMulTest_b ELSE "0";
    fracXIsZero_uid45_ac_uid6_fpComplexMulTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracXIsZero_uid45_ac_uid6_fpComplexMulTest_qi, xout => fracXIsZero_uid45_ac_uid6_fpComplexMulTest_q, clk => clk, aclr => areset );

    -- redist51_fracXIsZero_uid45_ac_uid6_fpComplexMulTest_q_2(DELAY,988)
    redist51_fracXIsZero_uid45_ac_uid6_fpComplexMulTest_q_2 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracXIsZero_uid45_ac_uid6_fpComplexMulTest_q, xout => redist51_fracXIsZero_uid45_ac_uid6_fpComplexMulTest_q_2_q, clk => clk, aclr => areset );

    -- expXIsMax_uid44_ac_uid6_fpComplexMulTest(LOGICAL,43)@2
    expXIsMax_uid44_ac_uid6_fpComplexMulTest_q <= "1" WHEN redist55_expY_uid21_ac_uid6_fpComplexMulTest_b_2_q = cstAllOWE_uid24_ac_uid6_fpComplexMulTest_q ELSE "0";

    -- excI_y_uid47_ac_uid6_fpComplexMulTest(LOGICAL,46)@2
    excI_y_uid47_ac_uid6_fpComplexMulTest_q <= expXIsMax_uid44_ac_uid6_fpComplexMulTest_q and redist51_fracXIsZero_uid45_ac_uid6_fpComplexMulTest_q_2_q;

    -- excZ_x_uid119_bd_uid7_fpComplexMulTest(LOGICAL,118)@2
    excZ_x_uid119_bd_uid7_fpComplexMulTest_q <= "1" WHEN redist48_expX_uid110_bd_uid7_fpComplexMulTest_b_2_q = cstAllZWE_uid26_ac_uid6_fpComplexMulTest_q ELSE "0";

    -- excXZAndExcYI_uid371_bc_uid9_fpComplexMulTest(LOGICAL,370)@2
    excXZAndExcYI_uid371_bc_uid9_fpComplexMulTest_q <= excZ_x_uid119_bd_uid7_fpComplexMulTest_q and excI_y_uid47_ac_uid6_fpComplexMulTest_q;

    -- ZeroTimesInf_uid372_bc_uid9_fpComplexMulTest(LOGICAL,371)@2
    ZeroTimesInf_uid372_bc_uid9_fpComplexMulTest_q <= excXZAndExcYI_uid371_bc_uid9_fpComplexMulTest_q or excYZAndExcXI_uid370_bc_uid9_fpComplexMulTest_q;

    -- fracXIsNotZero_uid46_ac_uid6_fpComplexMulTest(LOGICAL,45)@2
    fracXIsNotZero_uid46_ac_uid6_fpComplexMulTest_q <= not (redist51_fracXIsZero_uid45_ac_uid6_fpComplexMulTest_q_2_q);

    -- excN_y_uid48_ac_uid6_fpComplexMulTest(LOGICAL,47)@2
    excN_y_uid48_ac_uid6_fpComplexMulTest_q <= expXIsMax_uid44_ac_uid6_fpComplexMulTest_q and fracXIsNotZero_uid46_ac_uid6_fpComplexMulTest_q;

    -- fracXIsNotZero_uid122_bd_uid7_fpComplexMulTest(LOGICAL,121)@2
    fracXIsNotZero_uid122_bd_uid7_fpComplexMulTest_q <= not (redist44_fracXIsZero_uid121_bd_uid7_fpComplexMulTest_q_2_q);

    -- excN_x_uid124_bd_uid7_fpComplexMulTest(LOGICAL,123)@2
    excN_x_uid124_bd_uid7_fpComplexMulTest_q <= expXIsMax_uid120_bd_uid7_fpComplexMulTest_q and fracXIsNotZero_uid122_bd_uid7_fpComplexMulTest_q;

    -- excRNaN_uid373_bc_uid9_fpComplexMulTest(LOGICAL,372)@2
    excRNaN_uid373_bc_uid9_fpComplexMulTest_q <= excN_x_uid124_bd_uid7_fpComplexMulTest_q or excN_y_uid48_ac_uid6_fpComplexMulTest_q or ZeroTimesInf_uid372_bc_uid9_fpComplexMulTest_q;

    -- GND(CONSTANT,0)
    GND_q <= "0";

    -- ofracY_uid57_ac_uid6_fpComplexMulTest(BITJOIN,56)@0
    ofracY_uid57_ac_uid6_fpComplexMulTest_q <= VCC_q & frac_y_uid42_ac_uid6_fpComplexMulTest_b;

    -- ofracX_uid144_bd_uid7_fpComplexMulTest(BITJOIN,143)@0
    ofracX_uid144_bd_uid7_fpComplexMulTest_q <= VCC_q & frac_x_uid118_bd_uid7_fpComplexMulTest_b;

    -- prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma(CHAINMULTADD,924)@0 + 2
    prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_reset <= areset;
    prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_ena0 <= '1';
    prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_ena1 <= prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_ena0;
    prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_p(0) <= prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_a0(0) * prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_c0(0);
    prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_u(0) <= RESIZE(prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_p(0),48);
    prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_w(0) <= prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_u(0);
    prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_x(0) <= prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_w(0);
    prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_y(0) <= prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_x(0);
    prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_chainmultadd_input: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_a0 <= (others => (others => '0'));
            prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_c0 <= (others => (others => '0'));
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_ena0 = '1') THEN
                prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_a0(0) <= RESIZE(UNSIGNED(ofracX_uid144_bd_uid7_fpComplexMulTest_q),24);
                prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_c0(0) <= RESIZE(UNSIGNED(ofracY_uid57_ac_uid6_fpComplexMulTest_q),24);
            END IF;
        END IF;
    END PROCESS;
    prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_chainmultadd_output: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_s <= (others => (others => '0'));
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_ena1 = '1') THEN
                prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_s(0) <= prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_y(0);
            END IF;
        END IF;
    END PROCESS;
    prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_delay : dspba_delay
    GENERIC MAP ( width => 48, depth => 0, reset_kind => "ASYNC" )
    PORT MAP ( xin => STD_LOGIC_VECTOR(prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_s(0)(47 downto 0)), xout => prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_qq, clk => clk, aclr => areset );
    prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_q <= STD_LOGIC_VECTOR(prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_qq(47 downto 0));

    -- normalizeBit_uid333_bc_uid9_fpComplexMulTest(BITSELECT,332)@2
    normalizeBit_uid333_bc_uid9_fpComplexMulTest_b <= STD_LOGIC_VECTOR(prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_q(47 downto 47));

    -- roundBitDetectionConstant_uid77_ac_uid6_fpComplexMulTest(CONSTANT,76)
    roundBitDetectionConstant_uid77_ac_uid6_fpComplexMulTest_q <= "010";

    -- fracRPostNormHigh_uid335_bc_uid9_fpComplexMulTest(BITSELECT,334)@2
    fracRPostNormHigh_uid335_bc_uid9_fpComplexMulTest_in <= prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_q(46 downto 0);
    fracRPostNormHigh_uid335_bc_uid9_fpComplexMulTest_b <= fracRPostNormHigh_uid335_bc_uid9_fpComplexMulTest_in(46 downto 23);

    -- fracRPostNormLow_uid336_bc_uid9_fpComplexMulTest(BITSELECT,335)@2
    fracRPostNormLow_uid336_bc_uid9_fpComplexMulTest_in <= prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_q(45 downto 0);
    fracRPostNormLow_uid336_bc_uid9_fpComplexMulTest_b <= fracRPostNormLow_uid336_bc_uid9_fpComplexMulTest_in(45 downto 22);

    -- fracRPostNorm_uid337_bc_uid9_fpComplexMulTest(MUX,336)@2
    fracRPostNorm_uid337_bc_uid9_fpComplexMulTest_s <= normalizeBit_uid333_bc_uid9_fpComplexMulTest_b;
    fracRPostNorm_uid337_bc_uid9_fpComplexMulTest_combproc: PROCESS (fracRPostNorm_uid337_bc_uid9_fpComplexMulTest_s, fracRPostNormLow_uid336_bc_uid9_fpComplexMulTest_b, fracRPostNormHigh_uid335_bc_uid9_fpComplexMulTest_b)
    BEGIN
        CASE (fracRPostNorm_uid337_bc_uid9_fpComplexMulTest_s) IS
            WHEN "0" => fracRPostNorm_uid337_bc_uid9_fpComplexMulTest_q <= fracRPostNormLow_uid336_bc_uid9_fpComplexMulTest_b;
            WHEN "1" => fracRPostNorm_uid337_bc_uid9_fpComplexMulTest_q <= fracRPostNormHigh_uid335_bc_uid9_fpComplexMulTest_b;
            WHEN OTHERS => fracRPostNorm_uid337_bc_uid9_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- fracRPostNorm1dto0_uid345_bc_uid9_fpComplexMulTest(BITSELECT,344)@2
    fracRPostNorm1dto0_uid345_bc_uid9_fpComplexMulTest_in <= fracRPostNorm_uid337_bc_uid9_fpComplexMulTest_q(1 downto 0);
    fracRPostNorm1dto0_uid345_bc_uid9_fpComplexMulTest_b <= fracRPostNorm1dto0_uid345_bc_uid9_fpComplexMulTest_in(1 downto 0);

    -- extraStickyBitOfProd_uid339_bc_uid9_fpComplexMulTest(BITSELECT,338)@2
    extraStickyBitOfProd_uid339_bc_uid9_fpComplexMulTest_in <= STD_LOGIC_VECTOR(prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_q(22 downto 0));
    extraStickyBitOfProd_uid339_bc_uid9_fpComplexMulTest_b <= STD_LOGIC_VECTOR(extraStickyBitOfProd_uid339_bc_uid9_fpComplexMulTest_in(22 downto 22));

    -- extraStickyBit_uid340_bc_uid9_fpComplexMulTest(MUX,339)@2
    extraStickyBit_uid340_bc_uid9_fpComplexMulTest_s <= normalizeBit_uid333_bc_uid9_fpComplexMulTest_b;
    extraStickyBit_uid340_bc_uid9_fpComplexMulTest_combproc: PROCESS (extraStickyBit_uid340_bc_uid9_fpComplexMulTest_s, GND_q, extraStickyBitOfProd_uid339_bc_uid9_fpComplexMulTest_b)
    BEGIN
        CASE (extraStickyBit_uid340_bc_uid9_fpComplexMulTest_s) IS
            WHEN "0" => extraStickyBit_uid340_bc_uid9_fpComplexMulTest_q <= GND_q;
            WHEN "1" => extraStickyBit_uid340_bc_uid9_fpComplexMulTest_q <= extraStickyBitOfProd_uid339_bc_uid9_fpComplexMulTest_b;
            WHEN OTHERS => extraStickyBit_uid340_bc_uid9_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- stickyRange_uid338_bc_uid9_fpComplexMulTest(BITSELECT,337)@2
    stickyRange_uid338_bc_uid9_fpComplexMulTest_in <= prodXY_uid709_prod_uid331_bc_uid9_fpComplexMulTest_cma_q(21 downto 0);
    stickyRange_uid338_bc_uid9_fpComplexMulTest_b <= stickyRange_uid338_bc_uid9_fpComplexMulTest_in(21 downto 0);

    -- stickyExtendedRange_uid341_bc_uid9_fpComplexMulTest(BITJOIN,340)@2
    stickyExtendedRange_uid341_bc_uid9_fpComplexMulTest_q <= extraStickyBit_uid340_bc_uid9_fpComplexMulTest_q & stickyRange_uid338_bc_uid9_fpComplexMulTest_b;

    -- stickyRangeComparator_uid343_bc_uid9_fpComplexMulTest(LOGICAL,342)@2
    stickyRangeComparator_uid343_bc_uid9_fpComplexMulTest_q <= "1" WHEN stickyExtendedRange_uid341_bc_uid9_fpComplexMulTest_q = cstZeroWF_uid25_ac_uid6_fpComplexMulTest_q ELSE "0";

    -- sticky_uid344_bc_uid9_fpComplexMulTest(LOGICAL,343)@2
    sticky_uid344_bc_uid9_fpComplexMulTest_q <= not (stickyRangeComparator_uid343_bc_uid9_fpComplexMulTest_q);

    -- lrs_uid346_bc_uid9_fpComplexMulTest(BITJOIN,345)@2
    lrs_uid346_bc_uid9_fpComplexMulTest_q <= fracRPostNorm1dto0_uid345_bc_uid9_fpComplexMulTest_b & sticky_uid344_bc_uid9_fpComplexMulTest_q;

    -- roundBitDetectionPattern_uid348_bc_uid9_fpComplexMulTest(LOGICAL,347)@2
    roundBitDetectionPattern_uid348_bc_uid9_fpComplexMulTest_q <= "1" WHEN lrs_uid346_bc_uid9_fpComplexMulTest_q = roundBitDetectionConstant_uid77_ac_uid6_fpComplexMulTest_q ELSE "0";

    -- roundBit_uid349_bc_uid9_fpComplexMulTest(LOGICAL,348)@2
    roundBit_uid349_bc_uid9_fpComplexMulTest_q <= not (roundBitDetectionPattern_uid348_bc_uid9_fpComplexMulTest_q);

    -- roundBitAndNormalizationOp_uid352_bc_uid9_fpComplexMulTest(BITJOIN,351)@2
    roundBitAndNormalizationOp_uid352_bc_uid9_fpComplexMulTest_q <= GND_q & normalizeBit_uid333_bc_uid9_fpComplexMulTest_b & cstZeroWF_uid25_ac_uid6_fpComplexMulTest_q & roundBit_uid349_bc_uid9_fpComplexMulTest_q;

    -- biasInc_uid59_ac_uid6_fpComplexMulTest(CONSTANT,58)
    biasInc_uid59_ac_uid6_fpComplexMulTest_q <= "0001111111";

    -- expSum_uid328_bc_uid9_fpComplexMulTest(ADD,327)@2
    expSum_uid328_bc_uid9_fpComplexMulTest_a <= STD_LOGIC_VECTOR("0" & redist48_expX_uid110_bd_uid7_fpComplexMulTest_b_2_q);
    expSum_uid328_bc_uid9_fpComplexMulTest_b <= STD_LOGIC_VECTOR("0" & redist55_expY_uid21_ac_uid6_fpComplexMulTest_b_2_q);
    expSum_uid328_bc_uid9_fpComplexMulTest_o <= STD_LOGIC_VECTOR(UNSIGNED(expSum_uid328_bc_uid9_fpComplexMulTest_a) + UNSIGNED(expSum_uid328_bc_uid9_fpComplexMulTest_b));
    expSum_uid328_bc_uid9_fpComplexMulTest_q <= expSum_uid328_bc_uid9_fpComplexMulTest_o(8 downto 0);

    -- expSumMBias_uid330_bc_uid9_fpComplexMulTest(SUB,329)@2
    expSumMBias_uid330_bc_uid9_fpComplexMulTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("000" & expSum_uid328_bc_uid9_fpComplexMulTest_q));
    expSumMBias_uid330_bc_uid9_fpComplexMulTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((11 downto 10 => biasInc_uid59_ac_uid6_fpComplexMulTest_q(9)) & biasInc_uid59_ac_uid6_fpComplexMulTest_q));
    expSumMBias_uid330_bc_uid9_fpComplexMulTest_o <= STD_LOGIC_VECTOR(SIGNED(expSumMBias_uid330_bc_uid9_fpComplexMulTest_a) - SIGNED(expSumMBias_uid330_bc_uid9_fpComplexMulTest_b));
    expSumMBias_uid330_bc_uid9_fpComplexMulTest_q <= expSumMBias_uid330_bc_uid9_fpComplexMulTest_o(10 downto 0);

    -- expFracPreRound_uid350_bc_uid9_fpComplexMulTest(BITJOIN,349)@2
    expFracPreRound_uid350_bc_uid9_fpComplexMulTest_q <= expSumMBias_uid330_bc_uid9_fpComplexMulTest_q & fracRPostNorm_uid337_bc_uid9_fpComplexMulTest_q;

    -- expFracRPostRounding_uid353_bc_uid9_fpComplexMulTest(ADD,352)@2
    expFracRPostRounding_uid353_bc_uid9_fpComplexMulTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((36 downto 35 => expFracPreRound_uid350_bc_uid9_fpComplexMulTest_q(34)) & expFracPreRound_uid350_bc_uid9_fpComplexMulTest_q));
    expFracRPostRounding_uid353_bc_uid9_fpComplexMulTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("00000000000" & roundBitAndNormalizationOp_uid352_bc_uid9_fpComplexMulTest_q));
    expFracRPostRounding_uid353_bc_uid9_fpComplexMulTest_o <= STD_LOGIC_VECTOR(SIGNED(expFracRPostRounding_uid353_bc_uid9_fpComplexMulTest_a) + SIGNED(expFracRPostRounding_uid353_bc_uid9_fpComplexMulTest_b));
    expFracRPostRounding_uid353_bc_uid9_fpComplexMulTest_q <= expFracRPostRounding_uid353_bc_uid9_fpComplexMulTest_o(35 downto 0);

    -- expRPreExcExt_uid355_bc_uid9_fpComplexMulTest(BITSELECT,354)@2
    expRPreExcExt_uid355_bc_uid9_fpComplexMulTest_b <= STD_LOGIC_VECTOR(expFracRPostRounding_uid353_bc_uid9_fpComplexMulTest_q(35 downto 24));

    -- expOvf_uid359_bc_uid9_fpComplexMulTest(COMPARE,358)@2
    expOvf_uid359_bc_uid9_fpComplexMulTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("000000" & cstAllOWE_uid24_ac_uid6_fpComplexMulTest_q));
    expOvf_uid359_bc_uid9_fpComplexMulTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((13 downto 12 => expRPreExcExt_uid355_bc_uid9_fpComplexMulTest_b(11)) & expRPreExcExt_uid355_bc_uid9_fpComplexMulTest_b));
    expOvf_uid359_bc_uid9_fpComplexMulTest_o <= STD_LOGIC_VECTOR(SIGNED(expOvf_uid359_bc_uid9_fpComplexMulTest_a) - SIGNED(expOvf_uid359_bc_uid9_fpComplexMulTest_b));
    expOvf_uid359_bc_uid9_fpComplexMulTest_c(0) <= expOvf_uid359_bc_uid9_fpComplexMulTest_o(13);

    -- invExpXIsMax_uid49_ac_uid6_fpComplexMulTest(LOGICAL,48)@2
    invExpXIsMax_uid49_ac_uid6_fpComplexMulTest_q <= not (expXIsMax_uid44_ac_uid6_fpComplexMulTest_q);

    -- InvExpXIsZero_uid50_ac_uid6_fpComplexMulTest(LOGICAL,49)@2
    InvExpXIsZero_uid50_ac_uid6_fpComplexMulTest_q <= not (excZ_y_uid43_ac_uid6_fpComplexMulTest_q);

    -- excR_y_uid51_ac_uid6_fpComplexMulTest(LOGICAL,50)@2
    excR_y_uid51_ac_uid6_fpComplexMulTest_q <= InvExpXIsZero_uid50_ac_uid6_fpComplexMulTest_q and invExpXIsMax_uid49_ac_uid6_fpComplexMulTest_q;

    -- invExpXIsMax_uid125_bd_uid7_fpComplexMulTest(LOGICAL,124)@2
    invExpXIsMax_uid125_bd_uid7_fpComplexMulTest_q <= not (expXIsMax_uid120_bd_uid7_fpComplexMulTest_q);

    -- InvExpXIsZero_uid126_bd_uid7_fpComplexMulTest(LOGICAL,125)@2
    InvExpXIsZero_uid126_bd_uid7_fpComplexMulTest_q <= not (excZ_x_uid119_bd_uid7_fpComplexMulTest_q);

    -- excR_x_uid127_bd_uid7_fpComplexMulTest(LOGICAL,126)@2
    excR_x_uid127_bd_uid7_fpComplexMulTest_q <= InvExpXIsZero_uid126_bd_uid7_fpComplexMulTest_q and invExpXIsMax_uid125_bd_uid7_fpComplexMulTest_q;

    -- ExcROvfAndInReg_uid368_bc_uid9_fpComplexMulTest(LOGICAL,367)@2
    ExcROvfAndInReg_uid368_bc_uid9_fpComplexMulTest_q <= excR_x_uid127_bd_uid7_fpComplexMulTest_q and excR_y_uid51_ac_uid6_fpComplexMulTest_q and expOvf_uid359_bc_uid9_fpComplexMulTest_c;

    -- excYRAndExcXI_uid367_bc_uid9_fpComplexMulTest(LOGICAL,366)@2
    excYRAndExcXI_uid367_bc_uid9_fpComplexMulTest_q <= excR_y_uid51_ac_uid6_fpComplexMulTest_q and excI_x_uid123_bd_uid7_fpComplexMulTest_q;

    -- excXRAndExcYI_uid366_bc_uid9_fpComplexMulTest(LOGICAL,365)@2
    excXRAndExcYI_uid366_bc_uid9_fpComplexMulTest_q <= excR_x_uid127_bd_uid7_fpComplexMulTest_q and excI_y_uid47_ac_uid6_fpComplexMulTest_q;

    -- excXIAndExcYI_uid365_bc_uid9_fpComplexMulTest(LOGICAL,364)@2
    excXIAndExcYI_uid365_bc_uid9_fpComplexMulTest_q <= excI_x_uid123_bd_uid7_fpComplexMulTest_q and excI_y_uid47_ac_uid6_fpComplexMulTest_q;

    -- excRInf_uid369_bc_uid9_fpComplexMulTest(LOGICAL,368)@2
    excRInf_uid369_bc_uid9_fpComplexMulTest_q <= excXIAndExcYI_uid365_bc_uid9_fpComplexMulTest_q or excXRAndExcYI_uid366_bc_uid9_fpComplexMulTest_q or excYRAndExcXI_uid367_bc_uid9_fpComplexMulTest_q or ExcROvfAndInReg_uid368_bc_uid9_fpComplexMulTest_q;

    -- expUdf_uid357_bc_uid9_fpComplexMulTest_cmp_sign(LOGICAL,779)@2
    expUdf_uid357_bc_uid9_fpComplexMulTest_cmp_sign_q <= STD_LOGIC_VECTOR(expRPreExcExt_uid355_bc_uid9_fpComplexMulTest_b(11 downto 11));

    -- excZC3_uid363_bc_uid9_fpComplexMulTest(LOGICAL,362)@2
    excZC3_uid363_bc_uid9_fpComplexMulTest_q <= excR_x_uid127_bd_uid7_fpComplexMulTest_q and excR_y_uid51_ac_uid6_fpComplexMulTest_q and expUdf_uid357_bc_uid9_fpComplexMulTest_cmp_sign_q;

    -- excYZAndExcXR_uid362_bc_uid9_fpComplexMulTest(LOGICAL,361)@2
    excYZAndExcXR_uid362_bc_uid9_fpComplexMulTest_q <= excZ_y_uid43_ac_uid6_fpComplexMulTest_q and excR_x_uid127_bd_uid7_fpComplexMulTest_q;

    -- excXZAndExcYR_uid361_bc_uid9_fpComplexMulTest(LOGICAL,360)@2
    excXZAndExcYR_uid361_bc_uid9_fpComplexMulTest_q <= excZ_x_uid119_bd_uid7_fpComplexMulTest_q and excR_y_uid51_ac_uid6_fpComplexMulTest_q;

    -- excXZAndExcYZ_uid360_bc_uid9_fpComplexMulTest(LOGICAL,359)@2
    excXZAndExcYZ_uid360_bc_uid9_fpComplexMulTest_q <= excZ_x_uid119_bd_uid7_fpComplexMulTest_q and excZ_y_uid43_ac_uid6_fpComplexMulTest_q;

    -- excRZero_uid364_bc_uid9_fpComplexMulTest(LOGICAL,363)@2
    excRZero_uid364_bc_uid9_fpComplexMulTest_q <= excXZAndExcYZ_uid360_bc_uid9_fpComplexMulTest_q or excXZAndExcYR_uid361_bc_uid9_fpComplexMulTest_q or excYZAndExcXR_uid362_bc_uid9_fpComplexMulTest_q or excZC3_uid363_bc_uid9_fpComplexMulTest_q;

    -- concExc_uid374_bc_uid9_fpComplexMulTest(BITJOIN,373)@2
    concExc_uid374_bc_uid9_fpComplexMulTest_q <= excRNaN_uid373_bc_uid9_fpComplexMulTest_q & excRInf_uid369_bc_uid9_fpComplexMulTest_q & excRZero_uid364_bc_uid9_fpComplexMulTest_q;

    -- excREnc_uid375_bc_uid9_fpComplexMulTest(LOOKUP,374)@2 + 1
    excREnc_uid375_bc_uid9_fpComplexMulTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            excREnc_uid375_bc_uid9_fpComplexMulTest_q <= "01";
        ELSIF (clk'EVENT AND clk = '1') THEN
            CASE (concExc_uid374_bc_uid9_fpComplexMulTest_q) IS
                WHEN "000" => excREnc_uid375_bc_uid9_fpComplexMulTest_q <= "01";
                WHEN "001" => excREnc_uid375_bc_uid9_fpComplexMulTest_q <= "00";
                WHEN "010" => excREnc_uid375_bc_uid9_fpComplexMulTest_q <= "10";
                WHEN "011" => excREnc_uid375_bc_uid9_fpComplexMulTest_q <= "00";
                WHEN "100" => excREnc_uid375_bc_uid9_fpComplexMulTest_q <= "11";
                WHEN "101" => excREnc_uid375_bc_uid9_fpComplexMulTest_q <= "00";
                WHEN "110" => excREnc_uid375_bc_uid9_fpComplexMulTest_q <= "00";
                WHEN "111" => excREnc_uid375_bc_uid9_fpComplexMulTest_q <= "00";
                WHEN OTHERS => -- unreachable
                               excREnc_uid375_bc_uid9_fpComplexMulTest_q <= (others => '-');
            END CASE;
        END IF;
    END PROCESS;

    -- invExcRNaN_uid376_bc_uid9_fpComplexMulTest(LOGICAL,375)@2
    invExcRNaN_uid376_bc_uid9_fpComplexMulTest_q <= not (excRNaN_uid373_bc_uid9_fpComplexMulTest_q);

    -- signY_uid23_ac_uid6_fpComplexMulTest(BITSELECT,22)@0
    signY_uid23_ac_uid6_fpComplexMulTest_b <= STD_LOGIC_VECTOR(c(31 downto 31));

    -- redist53_signY_uid23_ac_uid6_fpComplexMulTest_b_2(DELAY,990)
    redist53_signY_uid23_ac_uid6_fpComplexMulTest_b_2 : dspba_delay
    GENERIC MAP ( width => 1, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => signY_uid23_ac_uid6_fpComplexMulTest_b, xout => redist53_signY_uid23_ac_uid6_fpComplexMulTest_b_2_q, clk => clk, aclr => areset );

    -- signX_uid112_bd_uid7_fpComplexMulTest(BITSELECT,111)@0
    signX_uid112_bd_uid7_fpComplexMulTest_b <= STD_LOGIC_VECTOR(b(31 downto 31));

    -- redist46_signX_uid112_bd_uid7_fpComplexMulTest_b_2(DELAY,983)
    redist46_signX_uid112_bd_uid7_fpComplexMulTest_b_2 : dspba_delay
    GENERIC MAP ( width => 1, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => signX_uid112_bd_uid7_fpComplexMulTest_b, xout => redist46_signX_uid112_bd_uid7_fpComplexMulTest_b_2_q, clk => clk, aclr => areset );

    -- signR_uid332_bc_uid9_fpComplexMulTest(LOGICAL,331)@2
    signR_uid332_bc_uid9_fpComplexMulTest_q <= redist46_signX_uid112_bd_uid7_fpComplexMulTest_b_2_q xor redist53_signY_uid23_ac_uid6_fpComplexMulTest_b_2_q;

    -- signRPostExc_uid377_bc_uid9_fpComplexMulTest(LOGICAL,376)@2 + 1
    signRPostExc_uid377_bc_uid9_fpComplexMulTest_qi <= signR_uid332_bc_uid9_fpComplexMulTest_q and invExcRNaN_uid376_bc_uid9_fpComplexMulTest_q;
    signRPostExc_uid377_bc_uid9_fpComplexMulTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => signRPostExc_uid377_bc_uid9_fpComplexMulTest_qi, xout => signRPostExc_uid377_bc_uid9_fpComplexMulTest_q, clk => clk, aclr => areset );

    -- expRPreExc_uid356_bc_uid9_fpComplexMulTest(BITSELECT,355)@2
    expRPreExc_uid356_bc_uid9_fpComplexMulTest_in <= expRPreExcExt_uid355_bc_uid9_fpComplexMulTest_b(7 downto 0);
    expRPreExc_uid356_bc_uid9_fpComplexMulTest_b <= expRPreExc_uid356_bc_uid9_fpComplexMulTest_in(7 downto 0);

    -- redist39_expRPreExc_uid356_bc_uid9_fpComplexMulTest_b_1(DELAY,976)
    redist39_expRPreExc_uid356_bc_uid9_fpComplexMulTest_b_1 : dspba_delay
    GENERIC MAP ( width => 8, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => expRPreExc_uid356_bc_uid9_fpComplexMulTest_b, xout => redist39_expRPreExc_uid356_bc_uid9_fpComplexMulTest_b_1_q, clk => clk, aclr => areset );

    -- fracRPreExc_uid354_bc_uid9_fpComplexMulTest(BITSELECT,353)@2
    fracRPreExc_uid354_bc_uid9_fpComplexMulTest_in <= expFracRPostRounding_uid353_bc_uid9_fpComplexMulTest_q(23 downto 0);
    fracRPreExc_uid354_bc_uid9_fpComplexMulTest_b <= fracRPreExc_uid354_bc_uid9_fpComplexMulTest_in(23 downto 1);

    -- redist40_fracRPreExc_uid354_bc_uid9_fpComplexMulTest_b_1(DELAY,977)
    redist40_fracRPreExc_uid354_bc_uid9_fpComplexMulTest_b_1 : dspba_delay
    GENERIC MAP ( width => 23, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracRPreExc_uid354_bc_uid9_fpComplexMulTest_b, xout => redist40_fracRPreExc_uid354_bc_uid9_fpComplexMulTest_b_1_q, clk => clk, aclr => areset );

    -- R_uid378_bc_uid9_fpComplexMulTest(BITJOIN,377)@3
    R_uid378_bc_uid9_fpComplexMulTest_q <= excREnc_uid375_bc_uid9_fpComplexMulTest_q & signRPostExc_uid377_bc_uid9_fpComplexMulTest_q & redist39_expRPreExc_uid356_bc_uid9_fpComplexMulTest_b_1_q & redist40_fracRPreExc_uid354_bc_uid9_fpComplexMulTest_b_1_q;

    -- sigY_uid574_rImag_uid17_fpComplexMulTest(BITSELECT,573)@3
    sigY_uid574_rImag_uid17_fpComplexMulTest_b <= STD_LOGIC_VECTOR(R_uid378_bc_uid9_fpComplexMulTest_q(31 downto 31));

    -- expY_uid576_rImag_uid17_fpComplexMulTest(BITSELECT,575)@3
    expY_uid576_rImag_uid17_fpComplexMulTest_b <= R_uid378_bc_uid9_fpComplexMulTest_q(30 downto 23);

    -- fracY_uid575_rImag_uid17_fpComplexMulTest(BITSELECT,574)@3
    fracY_uid575_rImag_uid17_fpComplexMulTest_b <= R_uid378_bc_uid9_fpComplexMulTest_q(22 downto 0);

    -- ypn_uid577_rImag_uid17_fpComplexMulTest(BITJOIN,576)@3
    ypn_uid577_rImag_uid17_fpComplexMulTest_q <= sigY_uid574_rImag_uid17_fpComplexMulTest_b & expY_uid576_rImag_uid17_fpComplexMulTest_b & fracY_uid575_rImag_uid17_fpComplexMulTest_b;

    -- frac_x_uid28_ac_uid6_fpComplexMulTest(BITSELECT,27)@0
    frac_x_uid28_ac_uid6_fpComplexMulTest_b <= a(22 downto 0);

    -- fracXIsZero_uid31_ac_uid6_fpComplexMulTest(LOGICAL,30)@0 + 1
    fracXIsZero_uid31_ac_uid6_fpComplexMulTest_qi <= "1" WHEN cstZeroWF_uid25_ac_uid6_fpComplexMulTest_q = frac_x_uid28_ac_uid6_fpComplexMulTest_b ELSE "0";
    fracXIsZero_uid31_ac_uid6_fpComplexMulTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracXIsZero_uid31_ac_uid6_fpComplexMulTest_qi, xout => fracXIsZero_uid31_ac_uid6_fpComplexMulTest_q, clk => clk, aclr => areset );

    -- redist52_fracXIsZero_uid31_ac_uid6_fpComplexMulTest_q_2(DELAY,989)
    redist52_fracXIsZero_uid31_ac_uid6_fpComplexMulTest_q_2 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracXIsZero_uid31_ac_uid6_fpComplexMulTest_q, xout => redist52_fracXIsZero_uid31_ac_uid6_fpComplexMulTest_q_2_q, clk => clk, aclr => areset );

    -- expX_uid20_ac_uid6_fpComplexMulTest(BITSELECT,19)@0
    expX_uid20_ac_uid6_fpComplexMulTest_b <= a(30 downto 23);

    -- redist56_expX_uid20_ac_uid6_fpComplexMulTest_b_2(DELAY,993)
    redist56_expX_uid20_ac_uid6_fpComplexMulTest_b_2 : dspba_delay
    GENERIC MAP ( width => 8, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => expX_uid20_ac_uid6_fpComplexMulTest_b, xout => redist56_expX_uid20_ac_uid6_fpComplexMulTest_b_2_q, clk => clk, aclr => areset );

    -- expXIsMax_uid30_ac_uid6_fpComplexMulTest(LOGICAL,29)@2
    expXIsMax_uid30_ac_uid6_fpComplexMulTest_q <= "1" WHEN redist56_expX_uid20_ac_uid6_fpComplexMulTest_b_2_q = cstAllOWE_uid24_ac_uid6_fpComplexMulTest_q ELSE "0";

    -- excI_x_uid33_ac_uid6_fpComplexMulTest(LOGICAL,32)@2
    excI_x_uid33_ac_uid6_fpComplexMulTest_q <= expXIsMax_uid30_ac_uid6_fpComplexMulTest_q and redist52_fracXIsZero_uid31_ac_uid6_fpComplexMulTest_q_2_q;

    -- expY_uid111_bd_uid7_fpComplexMulTest(BITSELECT,110)@0
    expY_uid111_bd_uid7_fpComplexMulTest_b <= d(30 downto 23);

    -- redist47_expY_uid111_bd_uid7_fpComplexMulTest_b_2(DELAY,984)
    redist47_expY_uid111_bd_uid7_fpComplexMulTest_b_2 : dspba_delay
    GENERIC MAP ( width => 8, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => expY_uid111_bd_uid7_fpComplexMulTest_b, xout => redist47_expY_uid111_bd_uid7_fpComplexMulTest_b_2_q, clk => clk, aclr => areset );

    -- excZ_y_uid133_bd_uid7_fpComplexMulTest(LOGICAL,132)@2
    excZ_y_uid133_bd_uid7_fpComplexMulTest_q <= "1" WHEN redist47_expY_uid111_bd_uid7_fpComplexMulTest_b_2_q = cstAllZWE_uid26_ac_uid6_fpComplexMulTest_q ELSE "0";

    -- excYZAndExcXI_uid280_ad_uid8_fpComplexMulTest(LOGICAL,279)@2
    excYZAndExcXI_uid280_ad_uid8_fpComplexMulTest_q <= excZ_y_uid133_bd_uid7_fpComplexMulTest_q and excI_x_uid33_ac_uid6_fpComplexMulTest_q;

    -- frac_y_uid132_bd_uid7_fpComplexMulTest(BITSELECT,131)@0
    frac_y_uid132_bd_uid7_fpComplexMulTest_b <= d(22 downto 0);

    -- fracXIsZero_uid135_bd_uid7_fpComplexMulTest(LOGICAL,134)@0 + 1
    fracXIsZero_uid135_bd_uid7_fpComplexMulTest_qi <= "1" WHEN cstZeroWF_uid25_ac_uid6_fpComplexMulTest_q = frac_y_uid132_bd_uid7_fpComplexMulTest_b ELSE "0";
    fracXIsZero_uid135_bd_uid7_fpComplexMulTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracXIsZero_uid135_bd_uid7_fpComplexMulTest_qi, xout => fracXIsZero_uid135_bd_uid7_fpComplexMulTest_q, clk => clk, aclr => areset );

    -- redist43_fracXIsZero_uid135_bd_uid7_fpComplexMulTest_q_2(DELAY,980)
    redist43_fracXIsZero_uid135_bd_uid7_fpComplexMulTest_q_2 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracXIsZero_uid135_bd_uid7_fpComplexMulTest_q, xout => redist43_fracXIsZero_uid135_bd_uid7_fpComplexMulTest_q_2_q, clk => clk, aclr => areset );

    -- expXIsMax_uid134_bd_uid7_fpComplexMulTest(LOGICAL,133)@2
    expXIsMax_uid134_bd_uid7_fpComplexMulTest_q <= "1" WHEN redist47_expY_uid111_bd_uid7_fpComplexMulTest_b_2_q = cstAllOWE_uid24_ac_uid6_fpComplexMulTest_q ELSE "0";

    -- excI_y_uid137_bd_uid7_fpComplexMulTest(LOGICAL,136)@2
    excI_y_uid137_bd_uid7_fpComplexMulTest_q <= expXIsMax_uid134_bd_uid7_fpComplexMulTest_q and redist43_fracXIsZero_uid135_bd_uid7_fpComplexMulTest_q_2_q;

    -- excZ_x_uid29_ac_uid6_fpComplexMulTest(LOGICAL,28)@2
    excZ_x_uid29_ac_uid6_fpComplexMulTest_q <= "1" WHEN redist56_expX_uid20_ac_uid6_fpComplexMulTest_b_2_q = cstAllZWE_uid26_ac_uid6_fpComplexMulTest_q ELSE "0";

    -- excXZAndExcYI_uid281_ad_uid8_fpComplexMulTest(LOGICAL,280)@2
    excXZAndExcYI_uid281_ad_uid8_fpComplexMulTest_q <= excZ_x_uid29_ac_uid6_fpComplexMulTest_q and excI_y_uid137_bd_uid7_fpComplexMulTest_q;

    -- ZeroTimesInf_uid282_ad_uid8_fpComplexMulTest(LOGICAL,281)@2
    ZeroTimesInf_uid282_ad_uid8_fpComplexMulTest_q <= excXZAndExcYI_uid281_ad_uid8_fpComplexMulTest_q or excYZAndExcXI_uid280_ad_uid8_fpComplexMulTest_q;

    -- fracXIsNotZero_uid136_bd_uid7_fpComplexMulTest(LOGICAL,135)@2
    fracXIsNotZero_uid136_bd_uid7_fpComplexMulTest_q <= not (redist43_fracXIsZero_uid135_bd_uid7_fpComplexMulTest_q_2_q);

    -- excN_y_uid138_bd_uid7_fpComplexMulTest(LOGICAL,137)@2
    excN_y_uid138_bd_uid7_fpComplexMulTest_q <= expXIsMax_uid134_bd_uid7_fpComplexMulTest_q and fracXIsNotZero_uid136_bd_uid7_fpComplexMulTest_q;

    -- fracXIsNotZero_uid32_ac_uid6_fpComplexMulTest(LOGICAL,31)@2
    fracXIsNotZero_uid32_ac_uid6_fpComplexMulTest_q <= not (redist52_fracXIsZero_uid31_ac_uid6_fpComplexMulTest_q_2_q);

    -- excN_x_uid34_ac_uid6_fpComplexMulTest(LOGICAL,33)@2
    excN_x_uid34_ac_uid6_fpComplexMulTest_q <= expXIsMax_uid30_ac_uid6_fpComplexMulTest_q and fracXIsNotZero_uid32_ac_uid6_fpComplexMulTest_q;

    -- excRNaN_uid283_ad_uid8_fpComplexMulTest(LOGICAL,282)@2
    excRNaN_uid283_ad_uid8_fpComplexMulTest_q <= excN_x_uid34_ac_uid6_fpComplexMulTest_q or excN_y_uid138_bd_uid7_fpComplexMulTest_q or ZeroTimesInf_uid282_ad_uid8_fpComplexMulTest_q;

    -- ofracY_uid147_bd_uid7_fpComplexMulTest(BITJOIN,146)@0
    ofracY_uid147_bd_uid7_fpComplexMulTest_q <= VCC_q & frac_y_uid132_bd_uid7_fpComplexMulTest_b;

    -- ofracX_uid54_ac_uid6_fpComplexMulTest(BITJOIN,53)@0
    ofracX_uid54_ac_uid6_fpComplexMulTest_q <= VCC_q & frac_x_uid28_ac_uid6_fpComplexMulTest_b;

    -- prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma(CHAINMULTADD,923)@0 + 2
    prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_reset <= areset;
    prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_ena0 <= '1';
    prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_ena1 <= prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_ena0;
    prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_p(0) <= prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_a0(0) * prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_c0(0);
    prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_u(0) <= RESIZE(prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_p(0),48);
    prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_w(0) <= prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_u(0);
    prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_x(0) <= prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_w(0);
    prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_y(0) <= prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_x(0);
    prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_chainmultadd_input: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_a0 <= (others => (others => '0'));
            prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_c0 <= (others => (others => '0'));
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_ena0 = '1') THEN
                prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_a0(0) <= RESIZE(UNSIGNED(ofracX_uid54_ac_uid6_fpComplexMulTest_q),24);
                prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_c0(0) <= RESIZE(UNSIGNED(ofracY_uid147_bd_uid7_fpComplexMulTest_q),24);
            END IF;
        END IF;
    END PROCESS;
    prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_chainmultadd_output: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_s <= (others => (others => '0'));
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_ena1 = '1') THEN
                prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_s(0) <= prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_y(0);
            END IF;
        END IF;
    END PROCESS;
    prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_delay : dspba_delay
    GENERIC MAP ( width => 48, depth => 0, reset_kind => "ASYNC" )
    PORT MAP ( xin => STD_LOGIC_VECTOR(prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_s(0)(47 downto 0)), xout => prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_qq, clk => clk, aclr => areset );
    prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_q <= STD_LOGIC_VECTOR(prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_qq(47 downto 0));

    -- normalizeBit_uid243_ad_uid8_fpComplexMulTest(BITSELECT,242)@2
    normalizeBit_uid243_ad_uid8_fpComplexMulTest_b <= STD_LOGIC_VECTOR(prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_q(47 downto 47));

    -- fracRPostNormHigh_uid245_ad_uid8_fpComplexMulTest(BITSELECT,244)@2
    fracRPostNormHigh_uid245_ad_uid8_fpComplexMulTest_in <= prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_q(46 downto 0);
    fracRPostNormHigh_uid245_ad_uid8_fpComplexMulTest_b <= fracRPostNormHigh_uid245_ad_uid8_fpComplexMulTest_in(46 downto 23);

    -- fracRPostNormLow_uid246_ad_uid8_fpComplexMulTest(BITSELECT,245)@2
    fracRPostNormLow_uid246_ad_uid8_fpComplexMulTest_in <= prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_q(45 downto 0);
    fracRPostNormLow_uid246_ad_uid8_fpComplexMulTest_b <= fracRPostNormLow_uid246_ad_uid8_fpComplexMulTest_in(45 downto 22);

    -- fracRPostNorm_uid247_ad_uid8_fpComplexMulTest(MUX,246)@2
    fracRPostNorm_uid247_ad_uid8_fpComplexMulTest_s <= normalizeBit_uid243_ad_uid8_fpComplexMulTest_b;
    fracRPostNorm_uid247_ad_uid8_fpComplexMulTest_combproc: PROCESS (fracRPostNorm_uid247_ad_uid8_fpComplexMulTest_s, fracRPostNormLow_uid246_ad_uid8_fpComplexMulTest_b, fracRPostNormHigh_uid245_ad_uid8_fpComplexMulTest_b)
    BEGIN
        CASE (fracRPostNorm_uid247_ad_uid8_fpComplexMulTest_s) IS
            WHEN "0" => fracRPostNorm_uid247_ad_uid8_fpComplexMulTest_q <= fracRPostNormLow_uid246_ad_uid8_fpComplexMulTest_b;
            WHEN "1" => fracRPostNorm_uid247_ad_uid8_fpComplexMulTest_q <= fracRPostNormHigh_uid245_ad_uid8_fpComplexMulTest_b;
            WHEN OTHERS => fracRPostNorm_uid247_ad_uid8_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- fracRPostNorm1dto0_uid255_ad_uid8_fpComplexMulTest(BITSELECT,254)@2
    fracRPostNorm1dto0_uid255_ad_uid8_fpComplexMulTest_in <= fracRPostNorm_uid247_ad_uid8_fpComplexMulTest_q(1 downto 0);
    fracRPostNorm1dto0_uid255_ad_uid8_fpComplexMulTest_b <= fracRPostNorm1dto0_uid255_ad_uid8_fpComplexMulTest_in(1 downto 0);

    -- extraStickyBitOfProd_uid249_ad_uid8_fpComplexMulTest(BITSELECT,248)@2
    extraStickyBitOfProd_uid249_ad_uid8_fpComplexMulTest_in <= STD_LOGIC_VECTOR(prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_q(22 downto 0));
    extraStickyBitOfProd_uid249_ad_uid8_fpComplexMulTest_b <= STD_LOGIC_VECTOR(extraStickyBitOfProd_uid249_ad_uid8_fpComplexMulTest_in(22 downto 22));

    -- extraStickyBit_uid250_ad_uid8_fpComplexMulTest(MUX,249)@2
    extraStickyBit_uid250_ad_uid8_fpComplexMulTest_s <= normalizeBit_uid243_ad_uid8_fpComplexMulTest_b;
    extraStickyBit_uid250_ad_uid8_fpComplexMulTest_combproc: PROCESS (extraStickyBit_uid250_ad_uid8_fpComplexMulTest_s, GND_q, extraStickyBitOfProd_uid249_ad_uid8_fpComplexMulTest_b)
    BEGIN
        CASE (extraStickyBit_uid250_ad_uid8_fpComplexMulTest_s) IS
            WHEN "0" => extraStickyBit_uid250_ad_uid8_fpComplexMulTest_q <= GND_q;
            WHEN "1" => extraStickyBit_uid250_ad_uid8_fpComplexMulTest_q <= extraStickyBitOfProd_uid249_ad_uid8_fpComplexMulTest_b;
            WHEN OTHERS => extraStickyBit_uid250_ad_uid8_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- stickyRange_uid248_ad_uid8_fpComplexMulTest(BITSELECT,247)@2
    stickyRange_uid248_ad_uid8_fpComplexMulTest_in <= prodXY_uid706_prod_uid241_ad_uid8_fpComplexMulTest_cma_q(21 downto 0);
    stickyRange_uid248_ad_uid8_fpComplexMulTest_b <= stickyRange_uid248_ad_uid8_fpComplexMulTest_in(21 downto 0);

    -- stickyExtendedRange_uid251_ad_uid8_fpComplexMulTest(BITJOIN,250)@2
    stickyExtendedRange_uid251_ad_uid8_fpComplexMulTest_q <= extraStickyBit_uid250_ad_uid8_fpComplexMulTest_q & stickyRange_uid248_ad_uid8_fpComplexMulTest_b;

    -- stickyRangeComparator_uid253_ad_uid8_fpComplexMulTest(LOGICAL,252)@2
    stickyRangeComparator_uid253_ad_uid8_fpComplexMulTest_q <= "1" WHEN stickyExtendedRange_uid251_ad_uid8_fpComplexMulTest_q = cstZeroWF_uid25_ac_uid6_fpComplexMulTest_q ELSE "0";

    -- sticky_uid254_ad_uid8_fpComplexMulTest(LOGICAL,253)@2
    sticky_uid254_ad_uid8_fpComplexMulTest_q <= not (stickyRangeComparator_uid253_ad_uid8_fpComplexMulTest_q);

    -- lrs_uid256_ad_uid8_fpComplexMulTest(BITJOIN,255)@2
    lrs_uid256_ad_uid8_fpComplexMulTest_q <= fracRPostNorm1dto0_uid255_ad_uid8_fpComplexMulTest_b & sticky_uid254_ad_uid8_fpComplexMulTest_q;

    -- roundBitDetectionPattern_uid258_ad_uid8_fpComplexMulTest(LOGICAL,257)@2
    roundBitDetectionPattern_uid258_ad_uid8_fpComplexMulTest_q <= "1" WHEN lrs_uid256_ad_uid8_fpComplexMulTest_q = roundBitDetectionConstant_uid77_ac_uid6_fpComplexMulTest_q ELSE "0";

    -- roundBit_uid259_ad_uid8_fpComplexMulTest(LOGICAL,258)@2
    roundBit_uid259_ad_uid8_fpComplexMulTest_q <= not (roundBitDetectionPattern_uid258_ad_uid8_fpComplexMulTest_q);

    -- roundBitAndNormalizationOp_uid262_ad_uid8_fpComplexMulTest(BITJOIN,261)@2
    roundBitAndNormalizationOp_uid262_ad_uid8_fpComplexMulTest_q <= GND_q & normalizeBit_uid243_ad_uid8_fpComplexMulTest_b & cstZeroWF_uid25_ac_uid6_fpComplexMulTest_q & roundBit_uid259_ad_uid8_fpComplexMulTest_q;

    -- expSum_uid238_ad_uid8_fpComplexMulTest(ADD,237)@2
    expSum_uid238_ad_uid8_fpComplexMulTest_a <= STD_LOGIC_VECTOR("0" & redist56_expX_uid20_ac_uid6_fpComplexMulTest_b_2_q);
    expSum_uid238_ad_uid8_fpComplexMulTest_b <= STD_LOGIC_VECTOR("0" & redist47_expY_uid111_bd_uid7_fpComplexMulTest_b_2_q);
    expSum_uid238_ad_uid8_fpComplexMulTest_o <= STD_LOGIC_VECTOR(UNSIGNED(expSum_uid238_ad_uid8_fpComplexMulTest_a) + UNSIGNED(expSum_uid238_ad_uid8_fpComplexMulTest_b));
    expSum_uid238_ad_uid8_fpComplexMulTest_q <= expSum_uid238_ad_uid8_fpComplexMulTest_o(8 downto 0);

    -- expSumMBias_uid240_ad_uid8_fpComplexMulTest(SUB,239)@2
    expSumMBias_uid240_ad_uid8_fpComplexMulTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("000" & expSum_uid238_ad_uid8_fpComplexMulTest_q));
    expSumMBias_uid240_ad_uid8_fpComplexMulTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((11 downto 10 => biasInc_uid59_ac_uid6_fpComplexMulTest_q(9)) & biasInc_uid59_ac_uid6_fpComplexMulTest_q));
    expSumMBias_uid240_ad_uid8_fpComplexMulTest_o <= STD_LOGIC_VECTOR(SIGNED(expSumMBias_uid240_ad_uid8_fpComplexMulTest_a) - SIGNED(expSumMBias_uid240_ad_uid8_fpComplexMulTest_b));
    expSumMBias_uid240_ad_uid8_fpComplexMulTest_q <= expSumMBias_uid240_ad_uid8_fpComplexMulTest_o(10 downto 0);

    -- expFracPreRound_uid260_ad_uid8_fpComplexMulTest(BITJOIN,259)@2
    expFracPreRound_uid260_ad_uid8_fpComplexMulTest_q <= expSumMBias_uid240_ad_uid8_fpComplexMulTest_q & fracRPostNorm_uid247_ad_uid8_fpComplexMulTest_q;

    -- expFracRPostRounding_uid263_ad_uid8_fpComplexMulTest(ADD,262)@2
    expFracRPostRounding_uid263_ad_uid8_fpComplexMulTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((36 downto 35 => expFracPreRound_uid260_ad_uid8_fpComplexMulTest_q(34)) & expFracPreRound_uid260_ad_uid8_fpComplexMulTest_q));
    expFracRPostRounding_uid263_ad_uid8_fpComplexMulTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("00000000000" & roundBitAndNormalizationOp_uid262_ad_uid8_fpComplexMulTest_q));
    expFracRPostRounding_uid263_ad_uid8_fpComplexMulTest_o <= STD_LOGIC_VECTOR(SIGNED(expFracRPostRounding_uid263_ad_uid8_fpComplexMulTest_a) + SIGNED(expFracRPostRounding_uid263_ad_uid8_fpComplexMulTest_b));
    expFracRPostRounding_uid263_ad_uid8_fpComplexMulTest_q <= expFracRPostRounding_uid263_ad_uid8_fpComplexMulTest_o(35 downto 0);

    -- expRPreExcExt_uid265_ad_uid8_fpComplexMulTest(BITSELECT,264)@2
    expRPreExcExt_uid265_ad_uid8_fpComplexMulTest_b <= STD_LOGIC_VECTOR(expFracRPostRounding_uid263_ad_uid8_fpComplexMulTest_q(35 downto 24));

    -- expOvf_uid269_ad_uid8_fpComplexMulTest(COMPARE,268)@2
    expOvf_uid269_ad_uid8_fpComplexMulTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("000000" & cstAllOWE_uid24_ac_uid6_fpComplexMulTest_q));
    expOvf_uid269_ad_uid8_fpComplexMulTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((13 downto 12 => expRPreExcExt_uid265_ad_uid8_fpComplexMulTest_b(11)) & expRPreExcExt_uid265_ad_uid8_fpComplexMulTest_b));
    expOvf_uid269_ad_uid8_fpComplexMulTest_o <= STD_LOGIC_VECTOR(SIGNED(expOvf_uid269_ad_uid8_fpComplexMulTest_a) - SIGNED(expOvf_uid269_ad_uid8_fpComplexMulTest_b));
    expOvf_uid269_ad_uid8_fpComplexMulTest_c(0) <= expOvf_uid269_ad_uid8_fpComplexMulTest_o(13);

    -- invExpXIsMax_uid139_bd_uid7_fpComplexMulTest(LOGICAL,138)@2
    invExpXIsMax_uid139_bd_uid7_fpComplexMulTest_q <= not (expXIsMax_uid134_bd_uid7_fpComplexMulTest_q);

    -- InvExpXIsZero_uid140_bd_uid7_fpComplexMulTest(LOGICAL,139)@2
    InvExpXIsZero_uid140_bd_uid7_fpComplexMulTest_q <= not (excZ_y_uid133_bd_uid7_fpComplexMulTest_q);

    -- excR_y_uid141_bd_uid7_fpComplexMulTest(LOGICAL,140)@2
    excR_y_uid141_bd_uid7_fpComplexMulTest_q <= InvExpXIsZero_uid140_bd_uid7_fpComplexMulTest_q and invExpXIsMax_uid139_bd_uid7_fpComplexMulTest_q;

    -- invExpXIsMax_uid35_ac_uid6_fpComplexMulTest(LOGICAL,34)@2
    invExpXIsMax_uid35_ac_uid6_fpComplexMulTest_q <= not (expXIsMax_uid30_ac_uid6_fpComplexMulTest_q);

    -- InvExpXIsZero_uid36_ac_uid6_fpComplexMulTest(LOGICAL,35)@2
    InvExpXIsZero_uid36_ac_uid6_fpComplexMulTest_q <= not (excZ_x_uid29_ac_uid6_fpComplexMulTest_q);

    -- excR_x_uid37_ac_uid6_fpComplexMulTest(LOGICAL,36)@2
    excR_x_uid37_ac_uid6_fpComplexMulTest_q <= InvExpXIsZero_uid36_ac_uid6_fpComplexMulTest_q and invExpXIsMax_uid35_ac_uid6_fpComplexMulTest_q;

    -- ExcROvfAndInReg_uid278_ad_uid8_fpComplexMulTest(LOGICAL,277)@2
    ExcROvfAndInReg_uid278_ad_uid8_fpComplexMulTest_q <= excR_x_uid37_ac_uid6_fpComplexMulTest_q and excR_y_uid141_bd_uid7_fpComplexMulTest_q and expOvf_uid269_ad_uid8_fpComplexMulTest_c;

    -- excYRAndExcXI_uid277_ad_uid8_fpComplexMulTest(LOGICAL,276)@2
    excYRAndExcXI_uid277_ad_uid8_fpComplexMulTest_q <= excR_y_uid141_bd_uid7_fpComplexMulTest_q and excI_x_uid33_ac_uid6_fpComplexMulTest_q;

    -- excXRAndExcYI_uid276_ad_uid8_fpComplexMulTest(LOGICAL,275)@2
    excXRAndExcYI_uid276_ad_uid8_fpComplexMulTest_q <= excR_x_uid37_ac_uid6_fpComplexMulTest_q and excI_y_uid137_bd_uid7_fpComplexMulTest_q;

    -- excXIAndExcYI_uid275_ad_uid8_fpComplexMulTest(LOGICAL,274)@2
    excXIAndExcYI_uid275_ad_uid8_fpComplexMulTest_q <= excI_x_uid33_ac_uid6_fpComplexMulTest_q and excI_y_uid137_bd_uid7_fpComplexMulTest_q;

    -- excRInf_uid279_ad_uid8_fpComplexMulTest(LOGICAL,278)@2
    excRInf_uid279_ad_uid8_fpComplexMulTest_q <= excXIAndExcYI_uid275_ad_uid8_fpComplexMulTest_q or excXRAndExcYI_uid276_ad_uid8_fpComplexMulTest_q or excYRAndExcXI_uid277_ad_uid8_fpComplexMulTest_q or ExcROvfAndInReg_uid278_ad_uid8_fpComplexMulTest_q;

    -- expUdf_uid267_ad_uid8_fpComplexMulTest_cmp_sign(LOGICAL,777)@2
    expUdf_uid267_ad_uid8_fpComplexMulTest_cmp_sign_q <= STD_LOGIC_VECTOR(expRPreExcExt_uid265_ad_uid8_fpComplexMulTest_b(11 downto 11));

    -- excZC3_uid273_ad_uid8_fpComplexMulTest(LOGICAL,272)@2
    excZC3_uid273_ad_uid8_fpComplexMulTest_q <= excR_x_uid37_ac_uid6_fpComplexMulTest_q and excR_y_uid141_bd_uid7_fpComplexMulTest_q and expUdf_uid267_ad_uid8_fpComplexMulTest_cmp_sign_q;

    -- excYZAndExcXR_uid272_ad_uid8_fpComplexMulTest(LOGICAL,271)@2
    excYZAndExcXR_uid272_ad_uid8_fpComplexMulTest_q <= excZ_y_uid133_bd_uid7_fpComplexMulTest_q and excR_x_uid37_ac_uid6_fpComplexMulTest_q;

    -- excXZAndExcYR_uid271_ad_uid8_fpComplexMulTest(LOGICAL,270)@2
    excXZAndExcYR_uid271_ad_uid8_fpComplexMulTest_q <= excZ_x_uid29_ac_uid6_fpComplexMulTest_q and excR_y_uid141_bd_uid7_fpComplexMulTest_q;

    -- excXZAndExcYZ_uid270_ad_uid8_fpComplexMulTest(LOGICAL,269)@2
    excXZAndExcYZ_uid270_ad_uid8_fpComplexMulTest_q <= excZ_x_uid29_ac_uid6_fpComplexMulTest_q and excZ_y_uid133_bd_uid7_fpComplexMulTest_q;

    -- excRZero_uid274_ad_uid8_fpComplexMulTest(LOGICAL,273)@2
    excRZero_uid274_ad_uid8_fpComplexMulTest_q <= excXZAndExcYZ_uid270_ad_uid8_fpComplexMulTest_q or excXZAndExcYR_uid271_ad_uid8_fpComplexMulTest_q or excYZAndExcXR_uid272_ad_uid8_fpComplexMulTest_q or excZC3_uid273_ad_uid8_fpComplexMulTest_q;

    -- concExc_uid284_ad_uid8_fpComplexMulTest(BITJOIN,283)@2
    concExc_uid284_ad_uid8_fpComplexMulTest_q <= excRNaN_uid283_ad_uid8_fpComplexMulTest_q & excRInf_uid279_ad_uid8_fpComplexMulTest_q & excRZero_uid274_ad_uid8_fpComplexMulTest_q;

    -- excREnc_uid285_ad_uid8_fpComplexMulTest(LOOKUP,284)@2 + 1
    excREnc_uid285_ad_uid8_fpComplexMulTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            excREnc_uid285_ad_uid8_fpComplexMulTest_q <= "01";
        ELSIF (clk'EVENT AND clk = '1') THEN
            CASE (concExc_uid284_ad_uid8_fpComplexMulTest_q) IS
                WHEN "000" => excREnc_uid285_ad_uid8_fpComplexMulTest_q <= "01";
                WHEN "001" => excREnc_uid285_ad_uid8_fpComplexMulTest_q <= "00";
                WHEN "010" => excREnc_uid285_ad_uid8_fpComplexMulTest_q <= "10";
                WHEN "011" => excREnc_uid285_ad_uid8_fpComplexMulTest_q <= "00";
                WHEN "100" => excREnc_uid285_ad_uid8_fpComplexMulTest_q <= "11";
                WHEN "101" => excREnc_uid285_ad_uid8_fpComplexMulTest_q <= "00";
                WHEN "110" => excREnc_uid285_ad_uid8_fpComplexMulTest_q <= "00";
                WHEN "111" => excREnc_uid285_ad_uid8_fpComplexMulTest_q <= "00";
                WHEN OTHERS => -- unreachable
                               excREnc_uid285_ad_uid8_fpComplexMulTest_q <= (others => '-');
            END CASE;
        END IF;
    END PROCESS;

    -- invExcRNaN_uid286_ad_uid8_fpComplexMulTest(LOGICAL,285)@2
    invExcRNaN_uid286_ad_uid8_fpComplexMulTest_q <= not (excRNaN_uid283_ad_uid8_fpComplexMulTest_q);

    -- signY_uid113_bd_uid7_fpComplexMulTest(BITSELECT,112)@0
    signY_uid113_bd_uid7_fpComplexMulTest_b <= STD_LOGIC_VECTOR(d(31 downto 31));

    -- redist45_signY_uid113_bd_uid7_fpComplexMulTest_b_2(DELAY,982)
    redist45_signY_uid113_bd_uid7_fpComplexMulTest_b_2 : dspba_delay
    GENERIC MAP ( width => 1, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => signY_uid113_bd_uid7_fpComplexMulTest_b, xout => redist45_signY_uid113_bd_uid7_fpComplexMulTest_b_2_q, clk => clk, aclr => areset );

    -- signX_uid22_ac_uid6_fpComplexMulTest(BITSELECT,21)@0
    signX_uid22_ac_uid6_fpComplexMulTest_b <= STD_LOGIC_VECTOR(a(31 downto 31));

    -- redist54_signX_uid22_ac_uid6_fpComplexMulTest_b_2(DELAY,991)
    redist54_signX_uid22_ac_uid6_fpComplexMulTest_b_2 : dspba_delay
    GENERIC MAP ( width => 1, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => signX_uid22_ac_uid6_fpComplexMulTest_b, xout => redist54_signX_uid22_ac_uid6_fpComplexMulTest_b_2_q, clk => clk, aclr => areset );

    -- signR_uid242_ad_uid8_fpComplexMulTest(LOGICAL,241)@2
    signR_uid242_ad_uid8_fpComplexMulTest_q <= redist54_signX_uid22_ac_uid6_fpComplexMulTest_b_2_q xor redist45_signY_uid113_bd_uid7_fpComplexMulTest_b_2_q;

    -- signRPostExc_uid287_ad_uid8_fpComplexMulTest(LOGICAL,286)@2 + 1
    signRPostExc_uid287_ad_uid8_fpComplexMulTest_qi <= signR_uid242_ad_uid8_fpComplexMulTest_q and invExcRNaN_uid286_ad_uid8_fpComplexMulTest_q;
    signRPostExc_uid287_ad_uid8_fpComplexMulTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => signRPostExc_uid287_ad_uid8_fpComplexMulTest_qi, xout => signRPostExc_uid287_ad_uid8_fpComplexMulTest_q, clk => clk, aclr => areset );

    -- expRPreExc_uid266_ad_uid8_fpComplexMulTest(BITSELECT,265)@2
    expRPreExc_uid266_ad_uid8_fpComplexMulTest_in <= expRPreExcExt_uid265_ad_uid8_fpComplexMulTest_b(7 downto 0);
    expRPreExc_uid266_ad_uid8_fpComplexMulTest_b <= expRPreExc_uid266_ad_uid8_fpComplexMulTest_in(7 downto 0);

    -- redist41_expRPreExc_uid266_ad_uid8_fpComplexMulTest_b_1(DELAY,978)
    redist41_expRPreExc_uid266_ad_uid8_fpComplexMulTest_b_1 : dspba_delay
    GENERIC MAP ( width => 8, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => expRPreExc_uid266_ad_uid8_fpComplexMulTest_b, xout => redist41_expRPreExc_uid266_ad_uid8_fpComplexMulTest_b_1_q, clk => clk, aclr => areset );

    -- fracRPreExc_uid264_ad_uid8_fpComplexMulTest(BITSELECT,263)@2
    fracRPreExc_uid264_ad_uid8_fpComplexMulTest_in <= expFracRPostRounding_uid263_ad_uid8_fpComplexMulTest_q(23 downto 0);
    fracRPreExc_uid264_ad_uid8_fpComplexMulTest_b <= fracRPreExc_uid264_ad_uid8_fpComplexMulTest_in(23 downto 1);

    -- redist42_fracRPreExc_uid264_ad_uid8_fpComplexMulTest_b_1(DELAY,979)
    redist42_fracRPreExc_uid264_ad_uid8_fpComplexMulTest_b_1 : dspba_delay
    GENERIC MAP ( width => 23, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracRPreExc_uid264_ad_uid8_fpComplexMulTest_b, xout => redist42_fracRPreExc_uid264_ad_uid8_fpComplexMulTest_b_1_q, clk => clk, aclr => areset );

    -- R_uid288_ad_uid8_fpComplexMulTest(BITJOIN,287)@3
    R_uid288_ad_uid8_fpComplexMulTest_q <= excREnc_uid285_ad_uid8_fpComplexMulTest_q & signRPostExc_uid287_ad_uid8_fpComplexMulTest_q & redist41_expRPreExc_uid266_ad_uid8_fpComplexMulTest_b_1_q & redist42_fracRPreExc_uid264_ad_uid8_fpComplexMulTest_b_1_q;

    -- xMuxRange_uid579_rImag_uid17_fpComplexMulTest(BITSELECT,578)@3
    xMuxRange_uid579_rImag_uid17_fpComplexMulTest_in <= R_uid288_ad_uid8_fpComplexMulTest_q(31 downto 0);
    xMuxRange_uid579_rImag_uid17_fpComplexMulTest_b <= xMuxRange_uid579_rImag_uid17_fpComplexMulTest_in(31 downto 0);

    -- expFracY_uid569_rImag_uid17_fpComplexMulTest(BITSELECT,568)@3
    expFracY_uid569_rImag_uid17_fpComplexMulTest_b <= R_uid378_bc_uid9_fpComplexMulTest_q(30 downto 0);

    -- expFracX_uid568_rImag_uid17_fpComplexMulTest(BITSELECT,567)@3
    expFracX_uid568_rImag_uid17_fpComplexMulTest_b <= R_uid288_ad_uid8_fpComplexMulTest_q(30 downto 0);

    -- xGTEy_uid570_rImag_uid17_fpComplexMulTest(COMPARE,569)@3
    xGTEy_uid570_rImag_uid17_fpComplexMulTest_a <= STD_LOGIC_VECTOR("00" & expFracX_uid568_rImag_uid17_fpComplexMulTest_b);
    xGTEy_uid570_rImag_uid17_fpComplexMulTest_b <= STD_LOGIC_VECTOR("00" & expFracY_uid569_rImag_uid17_fpComplexMulTest_b);
    xGTEy_uid570_rImag_uid17_fpComplexMulTest_o <= STD_LOGIC_VECTOR(UNSIGNED(xGTEy_uid570_rImag_uid17_fpComplexMulTest_a) - UNSIGNED(xGTEy_uid570_rImag_uid17_fpComplexMulTest_b));
    xGTEy_uid570_rImag_uid17_fpComplexMulTest_n(0) <= not (xGTEy_uid570_rImag_uid17_fpComplexMulTest_o(32));

    -- zero2b_uid386_rReal_uid16_fpComplexMulTest(CONSTANT,385)
    zero2b_uid386_rReal_uid16_fpComplexMulTest_q <= "00";

    -- excX_uid559_rImag_uid17_fpComplexMulTest(BITSELECT,558)@3
    excX_uid559_rImag_uid17_fpComplexMulTest_b <= R_uid378_bc_uid9_fpComplexMulTest_q(33 downto 32);

    -- excXZero_uid564_rImag_uid17_fpComplexMulTest(LOGICAL,563)@3
    excXZero_uid564_rImag_uid17_fpComplexMulTest_q <= "1" WHEN excX_uid559_rImag_uid17_fpComplexMulTest_b = zero2b_uid386_rReal_uid16_fpComplexMulTest_q ELSE "0";

    -- xGTEyOrYz_uid571_rImag_uid17_fpComplexMulTest(LOGICAL,570)@3
    xGTEyOrYz_uid571_rImag_uid17_fpComplexMulTest_q <= excXZero_uid564_rImag_uid17_fpComplexMulTest_q or xGTEy_uid570_rImag_uid17_fpComplexMulTest_n;

    -- excX_uid545_rImag_uid17_fpComplexMulTest(BITSELECT,544)@3
    excX_uid545_rImag_uid17_fpComplexMulTest_b <= R_uid288_ad_uid8_fpComplexMulTest_q(33 downto 32);

    -- excXZero_uid550_rImag_uid17_fpComplexMulTest(LOGICAL,549)@3
    excXZero_uid550_rImag_uid17_fpComplexMulTest_q <= "1" WHEN excX_uid545_rImag_uid17_fpComplexMulTest_b = zero2b_uid386_rReal_uid16_fpComplexMulTest_q ELSE "0";

    -- invExcXZ_uid572_rImag_uid17_fpComplexMulTest(LOGICAL,571)@3
    invExcXZ_uid572_rImag_uid17_fpComplexMulTest_q <= not (excXZero_uid550_rImag_uid17_fpComplexMulTest_q);

    -- xGTEy_uid573_rImag_uid17_fpComplexMulTest(LOGICAL,572)@3
    xGTEy_uid573_rImag_uid17_fpComplexMulTest_q <= invExcXZ_uid572_rImag_uid17_fpComplexMulTest_q and xGTEyOrYz_uid571_rImag_uid17_fpComplexMulTest_q;

    -- bSig_uid582_rImag_uid17_fpComplexMulTest(MUX,581)@3
    bSig_uid582_rImag_uid17_fpComplexMulTest_s <= xGTEy_uid573_rImag_uid17_fpComplexMulTest_q;
    bSig_uid582_rImag_uid17_fpComplexMulTest_combproc: PROCESS (bSig_uid582_rImag_uid17_fpComplexMulTest_s, xMuxRange_uid579_rImag_uid17_fpComplexMulTest_b, ypn_uid577_rImag_uid17_fpComplexMulTest_q)
    BEGIN
        CASE (bSig_uid582_rImag_uid17_fpComplexMulTest_s) IS
            WHEN "0" => bSig_uid582_rImag_uid17_fpComplexMulTest_q <= xMuxRange_uid579_rImag_uid17_fpComplexMulTest_b;
            WHEN "1" => bSig_uid582_rImag_uid17_fpComplexMulTest_q <= ypn_uid577_rImag_uid17_fpComplexMulTest_q;
            WHEN OTHERS => bSig_uid582_rImag_uid17_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- sigB_uid596_rImag_uid17_fpComplexMulTest(BITSELECT,595)@3
    sigB_uid596_rImag_uid17_fpComplexMulTest_b <= STD_LOGIC_VECTOR(bSig_uid582_rImag_uid17_fpComplexMulTest_q(31 downto 31));

    -- redist3_sigB_uid596_rImag_uid17_fpComplexMulTest_b_1(DELAY,940)
    redist3_sigB_uid596_rImag_uid17_fpComplexMulTest_b_1 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => sigB_uid596_rImag_uid17_fpComplexMulTest_b, xout => redist3_sigB_uid596_rImag_uid17_fpComplexMulTest_b_1_q, clk => clk, aclr => areset );

    -- aSig_uid581_rImag_uid17_fpComplexMulTest(MUX,580)@3
    aSig_uid581_rImag_uid17_fpComplexMulTest_s <= xGTEy_uid573_rImag_uid17_fpComplexMulTest_q;
    aSig_uid581_rImag_uid17_fpComplexMulTest_combproc: PROCESS (aSig_uid581_rImag_uid17_fpComplexMulTest_s, ypn_uid577_rImag_uid17_fpComplexMulTest_q, xMuxRange_uid579_rImag_uid17_fpComplexMulTest_b)
    BEGIN
        CASE (aSig_uid581_rImag_uid17_fpComplexMulTest_s) IS
            WHEN "0" => aSig_uid581_rImag_uid17_fpComplexMulTest_q <= ypn_uid577_rImag_uid17_fpComplexMulTest_q;
            WHEN "1" => aSig_uid581_rImag_uid17_fpComplexMulTest_q <= xMuxRange_uid579_rImag_uid17_fpComplexMulTest_b;
            WHEN OTHERS => aSig_uid581_rImag_uid17_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- sigA_uid595_rImag_uid17_fpComplexMulTest(BITSELECT,594)@3
    sigA_uid595_rImag_uid17_fpComplexMulTest_b <= STD_LOGIC_VECTOR(aSig_uid581_rImag_uid17_fpComplexMulTest_q(31 downto 31));

    -- redist5_sigA_uid595_rImag_uid17_fpComplexMulTest_b_1(DELAY,942)
    redist5_sigA_uid595_rImag_uid17_fpComplexMulTest_b_1 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => sigA_uid595_rImag_uid17_fpComplexMulTest_b, xout => redist5_sigA_uid595_rImag_uid17_fpComplexMulTest_b_1_q, clk => clk, aclr => areset );

    -- effSub_uid597_rImag_uid17_fpComplexMulTest(LOGICAL,596)@4
    effSub_uid597_rImag_uid17_fpComplexMulTest_q <= redist5_sigA_uid595_rImag_uid17_fpComplexMulTest_b_1_q xor redist3_sigB_uid596_rImag_uid17_fpComplexMulTest_b_1_q;

    -- excBZ_uid590_rImag_uid17_fpComplexMulTest(MUX,589)@3
    excBZ_uid590_rImag_uid17_fpComplexMulTest_s <= xGTEy_uid573_rImag_uid17_fpComplexMulTest_q;
    excBZ_uid590_rImag_uid17_fpComplexMulTest_combproc: PROCESS (excBZ_uid590_rImag_uid17_fpComplexMulTest_s, excXZero_uid550_rImag_uid17_fpComplexMulTest_q, excXZero_uid564_rImag_uid17_fpComplexMulTest_q)
    BEGIN
        CASE (excBZ_uid590_rImag_uid17_fpComplexMulTest_s) IS
            WHEN "0" => excBZ_uid590_rImag_uid17_fpComplexMulTest_q <= excXZero_uid550_rImag_uid17_fpComplexMulTest_q;
            WHEN "1" => excBZ_uid590_rImag_uid17_fpComplexMulTest_q <= excXZero_uid564_rImag_uid17_fpComplexMulTest_q;
            WHEN OTHERS => excBZ_uid590_rImag_uid17_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- expB_uid592_rImag_uid17_fpComplexMulTest(BITSELECT,591)@3
    expB_uid592_rImag_uid17_fpComplexMulTest_in <= bSig_uid582_rImag_uid17_fpComplexMulTest_q(30 downto 0);
    expB_uid592_rImag_uid17_fpComplexMulTest_b <= expB_uid592_rImag_uid17_fpComplexMulTest_in(30 downto 23);

    -- expA_uid591_rImag_uid17_fpComplexMulTest(BITSELECT,590)@3
    expA_uid591_rImag_uid17_fpComplexMulTest_in <= aSig_uid581_rImag_uid17_fpComplexMulTest_q(30 downto 0);
    expA_uid591_rImag_uid17_fpComplexMulTest_b <= expA_uid591_rImag_uid17_fpComplexMulTest_in(30 downto 23);

    -- expAmExpB_uid607_rImag_uid17_fpComplexMulTest(SUB,606)@3 + 1
    expAmExpB_uid607_rImag_uid17_fpComplexMulTest_a <= STD_LOGIC_VECTOR("0" & expA_uid591_rImag_uid17_fpComplexMulTest_b);
    expAmExpB_uid607_rImag_uid17_fpComplexMulTest_b <= STD_LOGIC_VECTOR("0" & expB_uid592_rImag_uid17_fpComplexMulTest_b);
    expAmExpB_uid607_rImag_uid17_fpComplexMulTest_i <= expAmExpB_uid607_rImag_uid17_fpComplexMulTest_a;
    expAmExpB_uid607_rImag_uid17_fpComplexMulTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            expAmExpB_uid607_rImag_uid17_fpComplexMulTest_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (excBZ_uid590_rImag_uid17_fpComplexMulTest_q = "1") THEN
                expAmExpB_uid607_rImag_uid17_fpComplexMulTest_o <= expAmExpB_uid607_rImag_uid17_fpComplexMulTest_i;
            ELSE
                expAmExpB_uid607_rImag_uid17_fpComplexMulTest_o <= STD_LOGIC_VECTOR(UNSIGNED(expAmExpB_uid607_rImag_uid17_fpComplexMulTest_a) - UNSIGNED(expAmExpB_uid607_rImag_uid17_fpComplexMulTest_b));
            END IF;
        END IF;
    END PROCESS;
    expAmExpB_uid607_rImag_uid17_fpComplexMulTest_q <= expAmExpB_uid607_rImag_uid17_fpComplexMulTest_o(8 downto 0);

    -- cWFP2_uid448_rReal_uid16_fpComplexMulTest(CONSTANT,447)
    cWFP2_uid448_rReal_uid16_fpComplexMulTest_q <= "11001";

    -- shiftedOut_uid610_rImag_uid17_fpComplexMulTest(COMPARE,609)@4
    shiftedOut_uid610_rImag_uid17_fpComplexMulTest_a <= STD_LOGIC_VECTOR("000000" & cWFP2_uid448_rReal_uid16_fpComplexMulTest_q);
    shiftedOut_uid610_rImag_uid17_fpComplexMulTest_b <= STD_LOGIC_VECTOR("00" & expAmExpB_uid607_rImag_uid17_fpComplexMulTest_q);
    shiftedOut_uid610_rImag_uid17_fpComplexMulTest_o <= STD_LOGIC_VECTOR(UNSIGNED(shiftedOut_uid610_rImag_uid17_fpComplexMulTest_a) - UNSIGNED(shiftedOut_uid610_rImag_uid17_fpComplexMulTest_b));
    shiftedOut_uid610_rImag_uid17_fpComplexMulTest_c(0) <= shiftedOut_uid610_rImag_uid17_fpComplexMulTest_o(10);

    -- iShiftedOut_uid614_rImag_uid17_fpComplexMulTest(LOGICAL,613)@4
    iShiftedOut_uid614_rImag_uid17_fpComplexMulTest_q <= not (shiftedOut_uid610_rImag_uid17_fpComplexMulTest_c);

    -- zeroOutCst_uid819_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest(CONSTANT,818)
    zeroOutCst_uid819_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q <= "0000000000000000000000000000000000000000000000000";

    -- rightShiftStage2Idx3Pad3_uid815_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest(CONSTANT,814)
    rightShiftStage2Idx3Pad3_uid815_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q <= "000";

    -- rightShiftStage2Idx3Rng3_uid884_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest(BITSELECT,883)@4
    rightShiftStage2Idx3Rng3_uid884_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_b <= rightShiftStage1_uid877_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q(48 downto 3);

    -- rightShiftStage2Idx3_uid886_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest(BITJOIN,885)@4
    rightShiftStage2Idx3_uid886_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q <= rightShiftStage2Idx3Pad3_uid815_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q & rightShiftStage2Idx3Rng3_uid884_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_b;

    -- rightShiftStage2Idx2Rng2_uid881_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest(BITSELECT,880)@4
    rightShiftStage2Idx2Rng2_uid881_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_b <= rightShiftStage1_uid877_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q(48 downto 2);

    -- rightShiftStage2Idx2_uid883_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest(BITJOIN,882)@4
    rightShiftStage2Idx2_uid883_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q <= zero2b_uid386_rReal_uid16_fpComplexMulTest_q & rightShiftStage2Idx2Rng2_uid881_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_b;

    -- rightShiftStage2Idx1Rng1_uid878_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest(BITSELECT,877)@4
    rightShiftStage2Idx1Rng1_uid878_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_b <= rightShiftStage1_uid877_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q(48 downto 1);

    -- rightShiftStage2Idx1_uid880_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest(BITJOIN,879)@4
    rightShiftStage2Idx1_uid880_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q <= GND_q & rightShiftStage2Idx1Rng1_uid878_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_b;

    -- rightShiftStage1Idx3Pad12_uid804_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest(CONSTANT,803)
    rightShiftStage1Idx3Pad12_uid804_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q <= "000000000000";

    -- rightShiftStage1Idx3Rng12_uid873_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest(BITSELECT,872)@4
    rightShiftStage1Idx3Rng12_uid873_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_b <= rightShiftStage0_uid866_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q(48 downto 12);

    -- rightShiftStage1Idx3_uid875_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest(BITJOIN,874)@4
    rightShiftStage1Idx3_uid875_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q <= rightShiftStage1Idx3Pad12_uid804_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q & rightShiftStage1Idx3Rng12_uid873_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_b;

    -- rightShiftStage1Idx2Rng8_uid870_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest(BITSELECT,869)@4
    rightShiftStage1Idx2Rng8_uid870_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_b <= rightShiftStage0_uid866_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q(48 downto 8);

    -- rightShiftStage1Idx2_uid872_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest(BITJOIN,871)@4
    rightShiftStage1Idx2_uid872_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q <= cstAllZWE_uid26_ac_uid6_fpComplexMulTest_q & rightShiftStage1Idx2Rng8_uid870_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_b;

    -- zs_uid726_lzCountVal_uid472_rReal_uid16_fpComplexMulTest(CONSTANT,725)
    zs_uid726_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q <= "0000";

    -- rightShiftStage1Idx1Rng4_uid867_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest(BITSELECT,866)@4
    rightShiftStage1Idx1Rng4_uid867_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_b <= rightShiftStage0_uid866_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q(48 downto 4);

    -- rightShiftStage1Idx1_uid869_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest(BITJOIN,868)@4
    rightShiftStage1Idx1_uid869_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q <= zs_uid726_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q & rightShiftStage1Idx1Rng4_uid867_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_b;

    -- rightShiftStage0Idx3Pad48_uid793_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest(CONSTANT,792)
    rightShiftStage0Idx3Pad48_uid793_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q <= "000000000000000000000000000000000000000000000000";

    -- rightShiftStage0Idx3Rng48_uid862_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest(BITSELECT,861)@4
    rightShiftStage0Idx3Rng48_uid862_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_b <= rightPaddedIn_uid612_rImag_uid17_fpComplexMulTest_q(48 downto 48);

    -- rightShiftStage0Idx3_uid864_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest(BITJOIN,863)@4
    rightShiftStage0Idx3_uid864_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q <= rightShiftStage0Idx3Pad48_uid793_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q & rightShiftStage0Idx3Rng48_uid862_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_b;

    -- rightShiftStage0Idx2Pad32_uid790_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest(CONSTANT,789)
    rightShiftStage0Idx2Pad32_uid790_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q <= "00000000000000000000000000000000";

    -- rightShiftStage0Idx2Rng32_uid859_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest(BITSELECT,858)@4
    rightShiftStage0Idx2Rng32_uid859_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_b <= rightPaddedIn_uid612_rImag_uid17_fpComplexMulTest_q(48 downto 32);

    -- rightShiftStage0Idx2_uid861_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest(BITJOIN,860)@4
    rightShiftStage0Idx2_uid861_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q <= rightShiftStage0Idx2Pad32_uid790_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q & rightShiftStage0Idx2Rng32_uid859_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_b;

    -- rightShiftStage0Idx1Rng16_uid856_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest(BITSELECT,855)@4
    rightShiftStage0Idx1Rng16_uid856_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_b <= rightPaddedIn_uid612_rImag_uid17_fpComplexMulTest_q(48 downto 16);

    -- rightShiftStage0Idx1_uid858_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest(BITJOIN,857)@4
    rightShiftStage0Idx1_uid858_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q <= zs_uid712_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q & rightShiftStage0Idx1Rng16_uid856_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_b;

    -- redist10_excBZ_uid590_rImag_uid17_fpComplexMulTest_q_1(DELAY,947)
    redist10_excBZ_uid590_rImag_uid17_fpComplexMulTest_q_1 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => excBZ_uid590_rImag_uid17_fpComplexMulTest_q, xout => redist10_excBZ_uid590_rImag_uid17_fpComplexMulTest_q_1_q, clk => clk, aclr => areset );

    -- invExcBZ_uid605_rImag_uid17_fpComplexMulTest(LOGICAL,604)@4
    invExcBZ_uid605_rImag_uid17_fpComplexMulTest_q <= not (redist10_excBZ_uid590_rImag_uid17_fpComplexMulTest_q_1_q);

    -- fracB_uid594_rImag_uid17_fpComplexMulTest(BITSELECT,593)@3
    fracB_uid594_rImag_uid17_fpComplexMulTest_in <= bSig_uid582_rImag_uid17_fpComplexMulTest_q(22 downto 0);
    fracB_uid594_rImag_uid17_fpComplexMulTest_b <= fracB_uid594_rImag_uid17_fpComplexMulTest_in(22 downto 0);

    -- redist7_fracB_uid594_rImag_uid17_fpComplexMulTest_b_1(DELAY,944)
    redist7_fracB_uid594_rImag_uid17_fpComplexMulTest_b_1 : dspba_delay
    GENERIC MAP ( width => 23, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracB_uid594_rImag_uid17_fpComplexMulTest_b, xout => redist7_fracB_uid594_rImag_uid17_fpComplexMulTest_b_1_q, clk => clk, aclr => areset );

    -- fracBz_uid603_rImag_uid17_fpComplexMulTest(MUX,602)@4
    fracBz_uid603_rImag_uid17_fpComplexMulTest_s <= redist10_excBZ_uid590_rImag_uid17_fpComplexMulTest_q_1_q;
    fracBz_uid603_rImag_uid17_fpComplexMulTest_combproc: PROCESS (fracBz_uid603_rImag_uid17_fpComplexMulTest_s, redist7_fracB_uid594_rImag_uid17_fpComplexMulTest_b_1_q, cstZeroWF_uid25_ac_uid6_fpComplexMulTest_q)
    BEGIN
        CASE (fracBz_uid603_rImag_uid17_fpComplexMulTest_s) IS
            WHEN "0" => fracBz_uid603_rImag_uid17_fpComplexMulTest_q <= redist7_fracB_uid594_rImag_uid17_fpComplexMulTest_b_1_q;
            WHEN "1" => fracBz_uid603_rImag_uid17_fpComplexMulTest_q <= cstZeroWF_uid25_ac_uid6_fpComplexMulTest_q;
            WHEN OTHERS => fracBz_uid603_rImag_uid17_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- oFracB_uid606_rImag_uid17_fpComplexMulTest(BITJOIN,605)@4
    oFracB_uid606_rImag_uid17_fpComplexMulTest_q <= invExcBZ_uid605_rImag_uid17_fpComplexMulTest_q & fracBz_uid603_rImag_uid17_fpComplexMulTest_q;

    -- padConst_uid451_rReal_uid16_fpComplexMulTest(CONSTANT,450)
    padConst_uid451_rReal_uid16_fpComplexMulTest_q <= "0000000000000000000000000";

    -- rightPaddedIn_uid612_rImag_uid17_fpComplexMulTest(BITJOIN,611)@4
    rightPaddedIn_uid612_rImag_uid17_fpComplexMulTest_q <= oFracB_uid606_rImag_uid17_fpComplexMulTest_q & padConst_uid451_rReal_uid16_fpComplexMulTest_q;

    -- rightShiftStage0_uid866_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest(MUX,865)@4
    rightShiftStage0_uid866_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_s <= rightShiftStageSel5Dto4_uid865_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_merged_bit_select_b;
    rightShiftStage0_uid866_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_combproc: PROCESS (rightShiftStage0_uid866_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_s, rightPaddedIn_uid612_rImag_uid17_fpComplexMulTest_q, rightShiftStage0Idx1_uid858_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q, rightShiftStage0Idx2_uid861_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q, rightShiftStage0Idx3_uid864_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q)
    BEGIN
        CASE (rightShiftStage0_uid866_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_s) IS
            WHEN "00" => rightShiftStage0_uid866_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q <= rightPaddedIn_uid612_rImag_uid17_fpComplexMulTest_q;
            WHEN "01" => rightShiftStage0_uid866_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q <= rightShiftStage0Idx1_uid858_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q;
            WHEN "10" => rightShiftStage0_uid866_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q <= rightShiftStage0Idx2_uid861_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q;
            WHEN "11" => rightShiftStage0_uid866_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q <= rightShiftStage0Idx3_uid864_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q;
            WHEN OTHERS => rightShiftStage0_uid866_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- rightShiftStage1_uid877_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest(MUX,876)@4
    rightShiftStage1_uid877_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_s <= rightShiftStageSel5Dto4_uid865_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_merged_bit_select_c;
    rightShiftStage1_uid877_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_combproc: PROCESS (rightShiftStage1_uid877_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_s, rightShiftStage0_uid866_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q, rightShiftStage1Idx1_uid869_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q, rightShiftStage1Idx2_uid872_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q, rightShiftStage1Idx3_uid875_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q)
    BEGIN
        CASE (rightShiftStage1_uid877_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_s) IS
            WHEN "00" => rightShiftStage1_uid877_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q <= rightShiftStage0_uid866_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q;
            WHEN "01" => rightShiftStage1_uid877_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q <= rightShiftStage1Idx1_uid869_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q;
            WHEN "10" => rightShiftStage1_uid877_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q <= rightShiftStage1Idx2_uid872_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q;
            WHEN "11" => rightShiftStage1_uid877_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q <= rightShiftStage1Idx3_uid875_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q;
            WHEN OTHERS => rightShiftStage1_uid877_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- rightShiftStageSel5Dto4_uid865_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_merged_bit_select(BITSELECT,927)@4
    rightShiftStageSel5Dto4_uid865_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_merged_bit_select_in <= expAmExpB_uid607_rImag_uid17_fpComplexMulTest_q(5 downto 0);
    rightShiftStageSel5Dto4_uid865_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_merged_bit_select_b <= rightShiftStageSel5Dto4_uid865_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_merged_bit_select_in(5 downto 4);
    rightShiftStageSel5Dto4_uid865_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_merged_bit_select_c <= rightShiftStageSel5Dto4_uid865_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_merged_bit_select_in(3 downto 2);
    rightShiftStageSel5Dto4_uid865_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_merged_bit_select_d <= rightShiftStageSel5Dto4_uid865_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_merged_bit_select_in(1 downto 0);

    -- rightShiftStage2_uid888_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest(MUX,887)@4
    rightShiftStage2_uid888_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_s <= rightShiftStageSel5Dto4_uid865_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_merged_bit_select_d;
    rightShiftStage2_uid888_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_combproc: PROCESS (rightShiftStage2_uid888_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_s, rightShiftStage1_uid877_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q, rightShiftStage2Idx1_uid880_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q, rightShiftStage2Idx2_uid883_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q, rightShiftStage2Idx3_uid886_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q)
    BEGIN
        CASE (rightShiftStage2_uid888_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_s) IS
            WHEN "00" => rightShiftStage2_uid888_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q <= rightShiftStage1_uid877_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q;
            WHEN "01" => rightShiftStage2_uid888_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q <= rightShiftStage2Idx1_uid880_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q;
            WHEN "10" => rightShiftStage2_uid888_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q <= rightShiftStage2Idx2_uid883_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q;
            WHEN "11" => rightShiftStage2_uid888_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q <= rightShiftStage2Idx3_uid886_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q;
            WHEN OTHERS => rightShiftStage2_uid888_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- wIntCst_uid784_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest(CONSTANT,783)
    wIntCst_uid784_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q <= "110001";

    -- shiftedOut_uid855_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest(COMPARE,854)@4
    shiftedOut_uid855_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_a <= STD_LOGIC_VECTOR("00" & expAmExpB_uid607_rImag_uid17_fpComplexMulTest_q);
    shiftedOut_uid855_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_b <= STD_LOGIC_VECTOR("00000" & wIntCst_uid784_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q);
    shiftedOut_uid855_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_o <= STD_LOGIC_VECTOR(UNSIGNED(shiftedOut_uid855_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_a) - UNSIGNED(shiftedOut_uid855_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_b));
    shiftedOut_uid855_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_n(0) <= not (shiftedOut_uid855_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_o(10));

    -- r_uid890_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest(MUX,889)@4
    r_uid890_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_s <= shiftedOut_uid855_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_n;
    r_uid890_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_combproc: PROCESS (r_uid890_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_s, rightShiftStage2_uid888_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q, zeroOutCst_uid819_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q)
    BEGIN
        CASE (r_uid890_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_s) IS
            WHEN "0" => r_uid890_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q <= rightShiftStage2_uid888_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q;
            WHEN "1" => r_uid890_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q <= zeroOutCst_uid819_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q;
            WHEN OTHERS => r_uid890_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- alignFracBPostShiftOut_uid615_rImag_uid17_fpComplexMulTest(LOGICAL,614)@4
    alignFracBPostShiftOut_uid615_rImag_uid17_fpComplexMulTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((48 downto 1 => iShiftedOut_uid614_rImag_uid17_fpComplexMulTest_q(0)) & iShiftedOut_uid614_rImag_uid17_fpComplexMulTest_q));
    alignFracBPostShiftOut_uid615_rImag_uid17_fpComplexMulTest_q <= r_uid890_alignmentShifter_uid611_rImag_uid17_fpComplexMulTest_q and alignFracBPostShiftOut_uid615_rImag_uid17_fpComplexMulTest_b;

    -- stickyBits_uid616_rImag_uid17_fpComplexMulTest_merged_bit_select(BITSELECT,928)@4
    stickyBits_uid616_rImag_uid17_fpComplexMulTest_merged_bit_select_b <= alignFracBPostShiftOut_uid615_rImag_uid17_fpComplexMulTest_q(22 downto 0);
    stickyBits_uid616_rImag_uid17_fpComplexMulTest_merged_bit_select_c <= alignFracBPostShiftOut_uid615_rImag_uid17_fpComplexMulTest_q(48 downto 23);

    -- fracBAddOp_uid627_rImag_uid17_fpComplexMulTest(BITJOIN,626)@4
    fracBAddOp_uid627_rImag_uid17_fpComplexMulTest_q <= GND_q & stickyBits_uid616_rImag_uid17_fpComplexMulTest_merged_bit_select_c;

    -- fracBAddOpPostXor_uid628_rImag_uid17_fpComplexMulTest(LOGICAL,627)@4
    fracBAddOpPostXor_uid628_rImag_uid17_fpComplexMulTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((26 downto 1 => effSub_uid597_rImag_uid17_fpComplexMulTest_q(0)) & effSub_uid597_rImag_uid17_fpComplexMulTest_q));
    fracBAddOpPostXor_uid628_rImag_uid17_fpComplexMulTest_q <= fracBAddOp_uid627_rImag_uid17_fpComplexMulTest_q xor fracBAddOpPostXor_uid628_rImag_uid17_fpComplexMulTest_b;

    -- one2b_uid387_rReal_uid16_fpComplexMulTest(CONSTANT,386)
    one2b_uid387_rReal_uid16_fpComplexMulTest_q <= "01";

    -- fracA_uid593_rImag_uid17_fpComplexMulTest(BITSELECT,592)@3
    fracA_uid593_rImag_uid17_fpComplexMulTest_in <= aSig_uid581_rImag_uid17_fpComplexMulTest_q(22 downto 0);
    fracA_uid593_rImag_uid17_fpComplexMulTest_b <= fracA_uid593_rImag_uid17_fpComplexMulTest_in(22 downto 0);

    -- redist8_fracA_uid593_rImag_uid17_fpComplexMulTest_b_1(DELAY,945)
    redist8_fracA_uid593_rImag_uid17_fpComplexMulTest_b_1 : dspba_delay
    GENERIC MAP ( width => 23, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracA_uid593_rImag_uid17_fpComplexMulTest_b, xout => redist8_fracA_uid593_rImag_uid17_fpComplexMulTest_b_1_q, clk => clk, aclr => areset );

    -- cmpEQ_stickyBits_cZwF_uid618_rImag_uid17_fpComplexMulTest(LOGICAL,617)@4
    cmpEQ_stickyBits_cZwF_uid618_rImag_uid17_fpComplexMulTest_q <= "1" WHEN stickyBits_uid616_rImag_uid17_fpComplexMulTest_merged_bit_select_b = cstZeroWF_uid25_ac_uid6_fpComplexMulTest_q ELSE "0";

    -- effSubInvSticky_uid621_rImag_uid17_fpComplexMulTest(LOGICAL,620)@4
    effSubInvSticky_uid621_rImag_uid17_fpComplexMulTest_q <= effSub_uid597_rImag_uid17_fpComplexMulTest_q and cmpEQ_stickyBits_cZwF_uid618_rImag_uid17_fpComplexMulTest_q;

    -- fracAAddOp_uid624_rImag_uid17_fpComplexMulTest(BITJOIN,623)@4
    fracAAddOp_uid624_rImag_uid17_fpComplexMulTest_q <= one2b_uid387_rReal_uid16_fpComplexMulTest_q & redist8_fracA_uid593_rImag_uid17_fpComplexMulTest_b_1_q & GND_q & effSubInvSticky_uid621_rImag_uid17_fpComplexMulTest_q;

    -- fracAddResult_uid629_rImag_uid17_fpComplexMulTest(ADD,628)@4
    fracAddResult_uid629_rImag_uid17_fpComplexMulTest_a <= STD_LOGIC_VECTOR("0" & fracAAddOp_uid624_rImag_uid17_fpComplexMulTest_q);
    fracAddResult_uid629_rImag_uid17_fpComplexMulTest_b <= STD_LOGIC_VECTOR("0" & fracBAddOpPostXor_uid628_rImag_uid17_fpComplexMulTest_q);
    fracAddResult_uid629_rImag_uid17_fpComplexMulTest_o <= STD_LOGIC_VECTOR(UNSIGNED(fracAddResult_uid629_rImag_uid17_fpComplexMulTest_a) + UNSIGNED(fracAddResult_uid629_rImag_uid17_fpComplexMulTest_b));
    fracAddResult_uid629_rImag_uid17_fpComplexMulTest_q <= fracAddResult_uid629_rImag_uid17_fpComplexMulTest_o(27 downto 0);

    -- rangeFracAddResultMwfp3Dto0_uid630_rImag_uid17_fpComplexMulTest(BITSELECT,629)@4
    rangeFracAddResultMwfp3Dto0_uid630_rImag_uid17_fpComplexMulTest_in <= fracAddResult_uid629_rImag_uid17_fpComplexMulTest_q(26 downto 0);
    rangeFracAddResultMwfp3Dto0_uid630_rImag_uid17_fpComplexMulTest_b <= rangeFracAddResultMwfp3Dto0_uid630_rImag_uid17_fpComplexMulTest_in(26 downto 0);

    -- redist1_rangeFracAddResultMwfp3Dto0_uid630_rImag_uid17_fpComplexMulTest_b_1(DELAY,938)
    redist1_rangeFracAddResultMwfp3Dto0_uid630_rImag_uid17_fpComplexMulTest_b_1 : dspba_delay
    GENERIC MAP ( width => 27, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => rangeFracAddResultMwfp3Dto0_uid630_rImag_uid17_fpComplexMulTest_b, xout => redist1_rangeFracAddResultMwfp3Dto0_uid630_rImag_uid17_fpComplexMulTest_b_1_q, clk => clk, aclr => areset );

    -- invCmpEQ_stickyBits_cZwF_uid619_rImag_uid17_fpComplexMulTest(LOGICAL,618)@4 + 1
    invCmpEQ_stickyBits_cZwF_uid619_rImag_uid17_fpComplexMulTest_qi <= not (cmpEQ_stickyBits_cZwF_uid618_rImag_uid17_fpComplexMulTest_q);
    invCmpEQ_stickyBits_cZwF_uid619_rImag_uid17_fpComplexMulTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => invCmpEQ_stickyBits_cZwF_uid619_rImag_uid17_fpComplexMulTest_qi, xout => invCmpEQ_stickyBits_cZwF_uid619_rImag_uid17_fpComplexMulTest_q, clk => clk, aclr => areset );

    -- fracGRS_uid631_rImag_uid17_fpComplexMulTest(BITJOIN,630)@5
    fracGRS_uid631_rImag_uid17_fpComplexMulTest_q <= redist1_rangeFracAddResultMwfp3Dto0_uid630_rImag_uid17_fpComplexMulTest_b_1_q & invCmpEQ_stickyBits_cZwF_uid619_rImag_uid17_fpComplexMulTest_q;

    -- rVStage_uid744_lzCountVal_uid632_rImag_uid17_fpComplexMulTest(BITSELECT,743)@5
    rVStage_uid744_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_b <= fracGRS_uid631_rImag_uid17_fpComplexMulTest_q(27 downto 12);

    -- vCount_uid745_lzCountVal_uid632_rImag_uid17_fpComplexMulTest(LOGICAL,744)@5
    vCount_uid745_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q <= "1" WHEN rVStage_uid744_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_b = zs_uid712_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q ELSE "0";

    -- vStage_uid747_lzCountVal_uid632_rImag_uid17_fpComplexMulTest(BITSELECT,746)@5
    vStage_uid747_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_in <= fracGRS_uid631_rImag_uid17_fpComplexMulTest_q(11 downto 0);
    vStage_uid747_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_b <= vStage_uid747_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_in(11 downto 0);

    -- mO_uid715_lzCountVal_uid472_rReal_uid16_fpComplexMulTest(CONSTANT,714)
    mO_uid715_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q <= "1111";

    -- cStage_uid748_lzCountVal_uid632_rImag_uid17_fpComplexMulTest(BITJOIN,747)@5
    cStage_uid748_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q <= vStage_uid747_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_b & mO_uid715_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q;

    -- vStagei_uid750_lzCountVal_uid632_rImag_uid17_fpComplexMulTest(MUX,749)@5
    vStagei_uid750_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_s <= vCount_uid745_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q;
    vStagei_uid750_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_combproc: PROCESS (vStagei_uid750_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_s, rVStage_uid744_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_b, cStage_uid748_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q)
    BEGIN
        CASE (vStagei_uid750_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_s) IS
            WHEN "0" => vStagei_uid750_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q <= rVStage_uid744_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_b;
            WHEN "1" => vStagei_uid750_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q <= cStage_uid748_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q;
            WHEN OTHERS => vStagei_uid750_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- rVStage_uid752_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_merged_bit_select(BITSELECT,933)@5
    rVStage_uid752_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_merged_bit_select_b <= vStagei_uid750_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q(15 downto 8);
    rVStage_uid752_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_merged_bit_select_c <= vStagei_uid750_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q(7 downto 0);

    -- vCount_uid753_lzCountVal_uid632_rImag_uid17_fpComplexMulTest(LOGICAL,752)@5
    vCount_uid753_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q <= "1" WHEN rVStage_uid752_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_merged_bit_select_b = cstAllZWE_uid26_ac_uid6_fpComplexMulTest_q ELSE "0";

    -- vStagei_uid756_lzCountVal_uid632_rImag_uid17_fpComplexMulTest(MUX,755)@5
    vStagei_uid756_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_s <= vCount_uid753_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q;
    vStagei_uid756_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_combproc: PROCESS (vStagei_uid756_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_s, rVStage_uid752_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_merged_bit_select_b, rVStage_uid752_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_merged_bit_select_c)
    BEGIN
        CASE (vStagei_uid756_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_s) IS
            WHEN "0" => vStagei_uid756_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q <= rVStage_uid752_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_merged_bit_select_b;
            WHEN "1" => vStagei_uid756_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q <= rVStage_uid752_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_merged_bit_select_c;
            WHEN OTHERS => vStagei_uid756_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- rVStage_uid758_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_merged_bit_select(BITSELECT,934)@5
    rVStage_uid758_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_merged_bit_select_b <= vStagei_uid756_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q(7 downto 4);
    rVStage_uid758_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_merged_bit_select_c <= vStagei_uid756_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q(3 downto 0);

    -- vCount_uid759_lzCountVal_uid632_rImag_uid17_fpComplexMulTest(LOGICAL,758)@5
    vCount_uid759_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q <= "1" WHEN rVStage_uid758_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_merged_bit_select_b = zs_uid726_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q ELSE "0";

    -- vStagei_uid762_lzCountVal_uid632_rImag_uid17_fpComplexMulTest(MUX,761)@5
    vStagei_uid762_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_s <= vCount_uid759_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q;
    vStagei_uid762_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_combproc: PROCESS (vStagei_uid762_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_s, rVStage_uid758_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_merged_bit_select_b, rVStage_uid758_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_merged_bit_select_c)
    BEGIN
        CASE (vStagei_uid762_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_s) IS
            WHEN "0" => vStagei_uid762_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q <= rVStage_uid758_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_merged_bit_select_b;
            WHEN "1" => vStagei_uid762_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q <= rVStage_uid758_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_merged_bit_select_c;
            WHEN OTHERS => vStagei_uid762_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- rVStage_uid764_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_merged_bit_select(BITSELECT,935)@5
    rVStage_uid764_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_merged_bit_select_b <= vStagei_uid762_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q(3 downto 2);
    rVStage_uid764_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_merged_bit_select_c <= vStagei_uid762_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q(1 downto 0);

    -- vCount_uid765_lzCountVal_uid632_rImag_uid17_fpComplexMulTest(LOGICAL,764)@5
    vCount_uid765_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q <= "1" WHEN rVStage_uid764_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_merged_bit_select_b = zero2b_uid386_rReal_uid16_fpComplexMulTest_q ELSE "0";

    -- vStagei_uid768_lzCountVal_uid632_rImag_uid17_fpComplexMulTest(MUX,767)@5
    vStagei_uid768_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_s <= vCount_uid765_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q;
    vStagei_uid768_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_combproc: PROCESS (vStagei_uid768_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_s, rVStage_uid764_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_merged_bit_select_b, rVStage_uid764_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_merged_bit_select_c)
    BEGIN
        CASE (vStagei_uid768_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_s) IS
            WHEN "0" => vStagei_uid768_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q <= rVStage_uid764_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_merged_bit_select_b;
            WHEN "1" => vStagei_uid768_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q <= rVStage_uid764_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_merged_bit_select_c;
            WHEN OTHERS => vStagei_uid768_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- rVStage_uid770_lzCountVal_uid632_rImag_uid17_fpComplexMulTest(BITSELECT,769)@5
    rVStage_uid770_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_b <= vStagei_uid768_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q(1 downto 1);

    -- vCount_uid771_lzCountVal_uid632_rImag_uid17_fpComplexMulTest(LOGICAL,770)@5
    vCount_uid771_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q <= "1" WHEN rVStage_uid770_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_b = GND_q ELSE "0";

    -- r_uid772_lzCountVal_uid632_rImag_uid17_fpComplexMulTest(BITJOIN,771)@5
    r_uid772_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q <= vCount_uid745_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q & vCount_uid753_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q & vCount_uid759_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q & vCount_uid765_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q & vCount_uid771_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q;

    -- aMinusA_uid634_rImag_uid17_fpComplexMulTest(LOGICAL,633)@5 + 1
    aMinusA_uid634_rImag_uid17_fpComplexMulTest_qi <= "1" WHEN r_uid772_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q = cAmA_uid473_rReal_uid16_fpComplexMulTest_q ELSE "0";
    aMinusA_uid634_rImag_uid17_fpComplexMulTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => aMinusA_uid634_rImag_uid17_fpComplexMulTest_qi, xout => aMinusA_uid634_rImag_uid17_fpComplexMulTest_q, clk => clk, aclr => areset );

    -- invAMinusA_uid679_rImag_uid17_fpComplexMulTest(LOGICAL,678)@6
    invAMinusA_uid679_rImag_uid17_fpComplexMulTest_q <= not (aMinusA_uid634_rImag_uid17_fpComplexMulTest_q);

    -- redist6_sigA_uid595_rImag_uid17_fpComplexMulTest_b_3(DELAY,943)
    redist6_sigA_uid595_rImag_uid17_fpComplexMulTest_b_3 : dspba_delay
    GENERIC MAP ( width => 1, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => redist5_sigA_uid595_rImag_uid17_fpComplexMulTest_b_1_q, xout => redist6_sigA_uid595_rImag_uid17_fpComplexMulTest_b_3_q, clk => clk, aclr => areset );

    -- redist14_excX_uid559_rImag_uid17_fpComplexMulTest_b_3(DELAY,951)
    redist14_excX_uid559_rImag_uid17_fpComplexMulTest_b_3 : dspba_delay
    GENERIC MAP ( width => 2, depth => 3, reset_kind => "ASYNC" )
    PORT MAP ( xin => excX_uid559_rImag_uid17_fpComplexMulTest_b, xout => redist14_excX_uid559_rImag_uid17_fpComplexMulTest_b_3_q, clk => clk, aclr => areset );

    -- excXReg_uid565_rImag_uid17_fpComplexMulTest(LOGICAL,564)@6
    excXReg_uid565_rImag_uid17_fpComplexMulTest_q <= "1" WHEN redist14_excX_uid559_rImag_uid17_fpComplexMulTest_b_3_q = one2b_uid387_rReal_uid16_fpComplexMulTest_q ELSE "0";

    -- redist15_excX_uid545_rImag_uid17_fpComplexMulTest_b_3(DELAY,952)
    redist15_excX_uid545_rImag_uid17_fpComplexMulTest_b_3 : dspba_delay
    GENERIC MAP ( width => 2, depth => 3, reset_kind => "ASYNC" )
    PORT MAP ( xin => excX_uid545_rImag_uid17_fpComplexMulTest_b, xout => redist15_excX_uid545_rImag_uid17_fpComplexMulTest_b_3_q, clk => clk, aclr => areset );

    -- excXReg_uid551_rImag_uid17_fpComplexMulTest(LOGICAL,550)@6
    excXReg_uid551_rImag_uid17_fpComplexMulTest_q <= "1" WHEN redist15_excX_uid545_rImag_uid17_fpComplexMulTest_b_3_q = one2b_uid387_rReal_uid16_fpComplexMulTest_q ELSE "0";

    -- redist13_xGTEy_uid573_rImag_uid17_fpComplexMulTest_q_3(DELAY,950)
    redist13_xGTEy_uid573_rImag_uid17_fpComplexMulTest_q_3 : dspba_delay
    GENERIC MAP ( width => 1, depth => 3, reset_kind => "ASYNC" )
    PORT MAP ( xin => xGTEy_uid573_rImag_uid17_fpComplexMulTest_q, xout => redist13_xGTEy_uid573_rImag_uid17_fpComplexMulTest_q_3_q, clk => clk, aclr => areset );

    -- excBR_uid589_rImag_uid17_fpComplexMulTest(MUX,588)@6
    excBR_uid589_rImag_uid17_fpComplexMulTest_s <= redist13_xGTEy_uid573_rImag_uid17_fpComplexMulTest_q_3_q;
    excBR_uid589_rImag_uid17_fpComplexMulTest_combproc: PROCESS (excBR_uid589_rImag_uid17_fpComplexMulTest_s, excXReg_uid551_rImag_uid17_fpComplexMulTest_q, excXReg_uid565_rImag_uid17_fpComplexMulTest_q)
    BEGIN
        CASE (excBR_uid589_rImag_uid17_fpComplexMulTest_s) IS
            WHEN "0" => excBR_uid589_rImag_uid17_fpComplexMulTest_q <= excXReg_uid551_rImag_uid17_fpComplexMulTest_q;
            WHEN "1" => excBR_uid589_rImag_uid17_fpComplexMulTest_q <= excXReg_uid565_rImag_uid17_fpComplexMulTest_q;
            WHEN OTHERS => excBR_uid589_rImag_uid17_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- excAR_uid585_rImag_uid17_fpComplexMulTest(MUX,584)@6
    excAR_uid585_rImag_uid17_fpComplexMulTest_s <= redist13_xGTEy_uid573_rImag_uid17_fpComplexMulTest_q_3_q;
    excAR_uid585_rImag_uid17_fpComplexMulTest_combproc: PROCESS (excAR_uid585_rImag_uid17_fpComplexMulTest_s, excXReg_uid565_rImag_uid17_fpComplexMulTest_q, excXReg_uid551_rImag_uid17_fpComplexMulTest_q)
    BEGIN
        CASE (excAR_uid585_rImag_uid17_fpComplexMulTest_s) IS
            WHEN "0" => excAR_uid585_rImag_uid17_fpComplexMulTest_q <= excXReg_uid565_rImag_uid17_fpComplexMulTest_q;
            WHEN "1" => excAR_uid585_rImag_uid17_fpComplexMulTest_q <= excXReg_uid551_rImag_uid17_fpComplexMulTest_q;
            WHEN OTHERS => excAR_uid585_rImag_uid17_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- signRReg_uid680_rImag_uid17_fpComplexMulTest(LOGICAL,679)@6
    signRReg_uid680_rImag_uid17_fpComplexMulTest_q <= excAR_uid585_rImag_uid17_fpComplexMulTest_q and excBR_uid589_rImag_uid17_fpComplexMulTest_q and redist6_sigA_uid595_rImag_uid17_fpComplexMulTest_b_3_q and invAMinusA_uid679_rImag_uid17_fpComplexMulTest_q;

    -- redist4_sigB_uid596_rImag_uid17_fpComplexMulTest_b_3(DELAY,941)
    redist4_sigB_uid596_rImag_uid17_fpComplexMulTest_b_3 : dspba_delay
    GENERIC MAP ( width => 1, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => redist3_sigB_uid596_rImag_uid17_fpComplexMulTest_b_1_q, xout => redist4_sigB_uid596_rImag_uid17_fpComplexMulTest_b_3_q, clk => clk, aclr => areset );

    -- redist11_excBZ_uid590_rImag_uid17_fpComplexMulTest_q_3(DELAY,948)
    redist11_excBZ_uid590_rImag_uid17_fpComplexMulTest_q_3 : dspba_delay
    GENERIC MAP ( width => 1, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => redist10_excBZ_uid590_rImag_uid17_fpComplexMulTest_q_1_q, xout => redist11_excBZ_uid590_rImag_uid17_fpComplexMulTest_q_3_q, clk => clk, aclr => areset );

    -- excAZ_uid586_rImag_uid17_fpComplexMulTest(MUX,585)@3 + 1
    excAZ_uid586_rImag_uid17_fpComplexMulTest_s <= xGTEy_uid573_rImag_uid17_fpComplexMulTest_q;
    excAZ_uid586_rImag_uid17_fpComplexMulTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            excAZ_uid586_rImag_uid17_fpComplexMulTest_q <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            CASE (excAZ_uid586_rImag_uid17_fpComplexMulTest_s) IS
                WHEN "0" => excAZ_uid586_rImag_uid17_fpComplexMulTest_q <= excXZero_uid564_rImag_uid17_fpComplexMulTest_q;
                WHEN "1" => excAZ_uid586_rImag_uid17_fpComplexMulTest_q <= excXZero_uid550_rImag_uid17_fpComplexMulTest_q;
                WHEN OTHERS => excAZ_uid586_rImag_uid17_fpComplexMulTest_q <= (others => '0');
            END CASE;
        END IF;
    END PROCESS;

    -- redist12_excAZ_uid586_rImag_uid17_fpComplexMulTest_q_3(DELAY,949)
    redist12_excAZ_uid586_rImag_uid17_fpComplexMulTest_q_3 : dspba_delay
    GENERIC MAP ( width => 1, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => excAZ_uid586_rImag_uid17_fpComplexMulTest_q, xout => redist12_excAZ_uid586_rImag_uid17_fpComplexMulTest_q_3_q, clk => clk, aclr => areset );

    -- excAZBZSigASigB_uid684_rImag_uid17_fpComplexMulTest(LOGICAL,683)@6
    excAZBZSigASigB_uid684_rImag_uid17_fpComplexMulTest_q <= redist12_excAZ_uid586_rImag_uid17_fpComplexMulTest_q_3_q and redist11_excBZ_uid590_rImag_uid17_fpComplexMulTest_q_3_q and redist6_sigA_uid595_rImag_uid17_fpComplexMulTest_b_3_q and redist4_sigB_uid596_rImag_uid17_fpComplexMulTest_b_3_q;

    -- excBZARSigA_uid685_rImag_uid17_fpComplexMulTest(LOGICAL,684)@6
    excBZARSigA_uid685_rImag_uid17_fpComplexMulTest_q <= redist11_excBZ_uid590_rImag_uid17_fpComplexMulTest_q_3_q and excAR_uid585_rImag_uid17_fpComplexMulTest_q and redist6_sigA_uid595_rImag_uid17_fpComplexMulTest_b_3_q;

    -- signRZero_uid686_rImag_uid17_fpComplexMulTest(LOGICAL,685)@6
    signRZero_uid686_rImag_uid17_fpComplexMulTest_q <= excBZARSigA_uid685_rImag_uid17_fpComplexMulTest_q or excAZBZSigASigB_uid684_rImag_uid17_fpComplexMulTest_q;

    -- two2b_uid388_rReal_uid16_fpComplexMulTest(CONSTANT,387)
    two2b_uid388_rReal_uid16_fpComplexMulTest_q <= "10";

    -- excXInf_uid566_rImag_uid17_fpComplexMulTest(LOGICAL,565)@6
    excXInf_uid566_rImag_uid17_fpComplexMulTest_q <= "1" WHEN redist14_excX_uid559_rImag_uid17_fpComplexMulTest_b_3_q = two2b_uid388_rReal_uid16_fpComplexMulTest_q ELSE "0";

    -- excXInf_uid552_rImag_uid17_fpComplexMulTest(LOGICAL,551)@6
    excXInf_uid552_rImag_uid17_fpComplexMulTest_q <= "1" WHEN redist15_excX_uid545_rImag_uid17_fpComplexMulTest_b_3_q = two2b_uid388_rReal_uid16_fpComplexMulTest_q ELSE "0";

    -- excBI_uid587_rImag_uid17_fpComplexMulTest(MUX,586)@6
    excBI_uid587_rImag_uid17_fpComplexMulTest_s <= redist13_xGTEy_uid573_rImag_uid17_fpComplexMulTest_q_3_q;
    excBI_uid587_rImag_uid17_fpComplexMulTest_combproc: PROCESS (excBI_uid587_rImag_uid17_fpComplexMulTest_s, excXInf_uid552_rImag_uid17_fpComplexMulTest_q, excXInf_uid566_rImag_uid17_fpComplexMulTest_q)
    BEGIN
        CASE (excBI_uid587_rImag_uid17_fpComplexMulTest_s) IS
            WHEN "0" => excBI_uid587_rImag_uid17_fpComplexMulTest_q <= excXInf_uid552_rImag_uid17_fpComplexMulTest_q;
            WHEN "1" => excBI_uid587_rImag_uid17_fpComplexMulTest_q <= excXInf_uid566_rImag_uid17_fpComplexMulTest_q;
            WHEN OTHERS => excBI_uid587_rImag_uid17_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- sigBBInf_uid681_rImag_uid17_fpComplexMulTest(LOGICAL,680)@6
    sigBBInf_uid681_rImag_uid17_fpComplexMulTest_q <= redist4_sigB_uid596_rImag_uid17_fpComplexMulTest_b_3_q and excBI_uid587_rImag_uid17_fpComplexMulTest_q;

    -- excAI_uid583_rImag_uid17_fpComplexMulTest(MUX,582)@6
    excAI_uid583_rImag_uid17_fpComplexMulTest_s <= redist13_xGTEy_uid573_rImag_uid17_fpComplexMulTest_q_3_q;
    excAI_uid583_rImag_uid17_fpComplexMulTest_combproc: PROCESS (excAI_uid583_rImag_uid17_fpComplexMulTest_s, excXInf_uid566_rImag_uid17_fpComplexMulTest_q, excXInf_uid552_rImag_uid17_fpComplexMulTest_q)
    BEGIN
        CASE (excAI_uid583_rImag_uid17_fpComplexMulTest_s) IS
            WHEN "0" => excAI_uid583_rImag_uid17_fpComplexMulTest_q <= excXInf_uid566_rImag_uid17_fpComplexMulTest_q;
            WHEN "1" => excAI_uid583_rImag_uid17_fpComplexMulTest_q <= excXInf_uid552_rImag_uid17_fpComplexMulTest_q;
            WHEN OTHERS => excAI_uid583_rImag_uid17_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- sigAAInf_uid682_rImag_uid17_fpComplexMulTest(LOGICAL,681)@6
    sigAAInf_uid682_rImag_uid17_fpComplexMulTest_q <= redist6_sigA_uid595_rImag_uid17_fpComplexMulTest_b_3_q and excAI_uid583_rImag_uid17_fpComplexMulTest_q;

    -- signRInf_uid683_rImag_uid17_fpComplexMulTest(LOGICAL,682)@6
    signRInf_uid683_rImag_uid17_fpComplexMulTest_q <= sigAAInf_uid682_rImag_uid17_fpComplexMulTest_q or sigBBInf_uid681_rImag_uid17_fpComplexMulTest_q;

    -- signRInfRZRReg_uid687_rImag_uid17_fpComplexMulTest(LOGICAL,686)@6
    signRInfRZRReg_uid687_rImag_uid17_fpComplexMulTest_q <= signRInf_uid683_rImag_uid17_fpComplexMulTest_q or signRZero_uid686_rImag_uid17_fpComplexMulTest_q or signRReg_uid680_rImag_uid17_fpComplexMulTest_q;

    -- three2b_uid389_rReal_uid16_fpComplexMulTest(CONSTANT,388)
    three2b_uid389_rReal_uid16_fpComplexMulTest_q <= "11";

    -- excXNaN_uid567_rImag_uid17_fpComplexMulTest(LOGICAL,566)@6
    excXNaN_uid567_rImag_uid17_fpComplexMulTest_q <= "1" WHEN redist14_excX_uid559_rImag_uid17_fpComplexMulTest_b_3_q = three2b_uid389_rReal_uid16_fpComplexMulTest_q ELSE "0";

    -- excXNaN_uid553_rImag_uid17_fpComplexMulTest(LOGICAL,552)@6
    excXNaN_uid553_rImag_uid17_fpComplexMulTest_q <= "1" WHEN redist15_excX_uid545_rImag_uid17_fpComplexMulTest_b_3_q = three2b_uid389_rReal_uid16_fpComplexMulTest_q ELSE "0";

    -- excBN_uid588_rImag_uid17_fpComplexMulTest(MUX,587)@6
    excBN_uid588_rImag_uid17_fpComplexMulTest_s <= redist13_xGTEy_uid573_rImag_uid17_fpComplexMulTest_q_3_q;
    excBN_uid588_rImag_uid17_fpComplexMulTest_combproc: PROCESS (excBN_uid588_rImag_uid17_fpComplexMulTest_s, excXNaN_uid553_rImag_uid17_fpComplexMulTest_q, excXNaN_uid567_rImag_uid17_fpComplexMulTest_q)
    BEGIN
        CASE (excBN_uid588_rImag_uid17_fpComplexMulTest_s) IS
            WHEN "0" => excBN_uid588_rImag_uid17_fpComplexMulTest_q <= excXNaN_uid553_rImag_uid17_fpComplexMulTest_q;
            WHEN "1" => excBN_uid588_rImag_uid17_fpComplexMulTest_q <= excXNaN_uid567_rImag_uid17_fpComplexMulTest_q;
            WHEN OTHERS => excBN_uid588_rImag_uid17_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- excAN_uid584_rImag_uid17_fpComplexMulTest(MUX,583)@6
    excAN_uid584_rImag_uid17_fpComplexMulTest_s <= redist13_xGTEy_uid573_rImag_uid17_fpComplexMulTest_q_3_q;
    excAN_uid584_rImag_uid17_fpComplexMulTest_combproc: PROCESS (excAN_uid584_rImag_uid17_fpComplexMulTest_s, excXNaN_uid567_rImag_uid17_fpComplexMulTest_q, excXNaN_uid553_rImag_uid17_fpComplexMulTest_q)
    BEGIN
        CASE (excAN_uid584_rImag_uid17_fpComplexMulTest_s) IS
            WHEN "0" => excAN_uid584_rImag_uid17_fpComplexMulTest_q <= excXNaN_uid567_rImag_uid17_fpComplexMulTest_q;
            WHEN "1" => excAN_uid584_rImag_uid17_fpComplexMulTest_q <= excXNaN_uid553_rImag_uid17_fpComplexMulTest_q;
            WHEN OTHERS => excAN_uid584_rImag_uid17_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- excRNaN2_uid674_rImag_uid17_fpComplexMulTest(LOGICAL,673)@6
    excRNaN2_uid674_rImag_uid17_fpComplexMulTest_q <= excAN_uid584_rImag_uid17_fpComplexMulTest_q or excBN_uid588_rImag_uid17_fpComplexMulTest_q;

    -- redist2_effSub_uid597_rImag_uid17_fpComplexMulTest_q_2(DELAY,939)
    redist2_effSub_uid597_rImag_uid17_fpComplexMulTest_q_2 : dspba_delay
    GENERIC MAP ( width => 1, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => effSub_uid597_rImag_uid17_fpComplexMulTest_q, xout => redist2_effSub_uid597_rImag_uid17_fpComplexMulTest_q_2_q, clk => clk, aclr => areset );

    -- excAIBISub_uid675_rImag_uid17_fpComplexMulTest(LOGICAL,674)@6
    excAIBISub_uid675_rImag_uid17_fpComplexMulTest_q <= excAI_uid583_rImag_uid17_fpComplexMulTest_q and excBI_uid587_rImag_uid17_fpComplexMulTest_q and redist2_effSub_uid597_rImag_uid17_fpComplexMulTest_q_2_q;

    -- excRNaN_uid676_rImag_uid17_fpComplexMulTest(LOGICAL,675)@6
    excRNaN_uid676_rImag_uid17_fpComplexMulTest_q <= excAIBISub_uid675_rImag_uid17_fpComplexMulTest_q or excRNaN2_uid674_rImag_uid17_fpComplexMulTest_q;

    -- invExcRNaN_uid688_rImag_uid17_fpComplexMulTest(LOGICAL,687)@6
    invExcRNaN_uid688_rImag_uid17_fpComplexMulTest_q <= not (excRNaN_uid676_rImag_uid17_fpComplexMulTest_q);

    -- VCC(CONSTANT,1)
    VCC_q <= "1";

    -- signRPostExc_uid689_rImag_uid17_fpComplexMulTest(LOGICAL,688)@6
    signRPostExc_uid689_rImag_uid17_fpComplexMulTest_q <= invExcRNaN_uid688_rImag_uid17_fpComplexMulTest_q and signRInfRZRReg_uid687_rImag_uid17_fpComplexMulTest_q;

    -- cRBit_uid486_rReal_uid16_fpComplexMulTest(CONSTANT,485)
    cRBit_uid486_rReal_uid16_fpComplexMulTest_q <= "01000";

    -- leftShiftStage2Idx1Rng1_uid917_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest(BITSELECT,916)@5
    leftShiftStage2Idx1Rng1_uid917_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_in <= leftShiftStage1_uid915_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q(26 downto 0);
    leftShiftStage2Idx1Rng1_uid917_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_b <= leftShiftStage2Idx1Rng1_uid917_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_in(26 downto 0);

    -- leftShiftStage2Idx1_uid918_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest(BITJOIN,917)@5
    leftShiftStage2Idx1_uid918_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q <= leftShiftStage2Idx1Rng1_uid917_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_b & GND_q;

    -- leftShiftStage1Idx3Rng6_uid912_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest(BITSELECT,911)@5
    leftShiftStage1Idx3Rng6_uid912_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_in <= leftShiftStage0_uid904_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q(21 downto 0);
    leftShiftStage1Idx3Rng6_uid912_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_b <= leftShiftStage1Idx3Rng6_uid912_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_in(21 downto 0);

    -- leftShiftStage1Idx3Pad6_uid841_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest(CONSTANT,840)
    leftShiftStage1Idx3Pad6_uid841_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q <= "000000";

    -- leftShiftStage1Idx3_uid913_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest(BITJOIN,912)@5
    leftShiftStage1Idx3_uid913_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q <= leftShiftStage1Idx3Rng6_uid912_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_b & leftShiftStage1Idx3Pad6_uid841_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q;

    -- leftShiftStage1Idx2Rng4_uid909_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest(BITSELECT,908)@5
    leftShiftStage1Idx2Rng4_uid909_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_in <= leftShiftStage0_uid904_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q(23 downto 0);
    leftShiftStage1Idx2Rng4_uid909_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_b <= leftShiftStage1Idx2Rng4_uid909_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_in(23 downto 0);

    -- leftShiftStage1Idx2_uid910_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest(BITJOIN,909)@5
    leftShiftStage1Idx2_uid910_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q <= leftShiftStage1Idx2Rng4_uid909_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_b & zs_uid726_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q;

    -- leftShiftStage1Idx1Rng2_uid906_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest(BITSELECT,905)@5
    leftShiftStage1Idx1Rng2_uid906_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_in <= leftShiftStage0_uid904_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q(25 downto 0);
    leftShiftStage1Idx1Rng2_uid906_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_b <= leftShiftStage1Idx1Rng2_uid906_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_in(25 downto 0);

    -- leftShiftStage1Idx1_uid907_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest(BITJOIN,906)@5
    leftShiftStage1Idx1_uid907_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q <= leftShiftStage1Idx1Rng2_uid906_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_b & zero2b_uid386_rReal_uid16_fpComplexMulTest_q;

    -- leftShiftStage0Idx3Rng24_uid901_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest(BITSELECT,900)@5
    leftShiftStage0Idx3Rng24_uid901_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_in <= fracGRS_uid631_rImag_uid17_fpComplexMulTest_q(3 downto 0);
    leftShiftStage0Idx3Rng24_uid901_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_b <= leftShiftStage0Idx3Rng24_uid901_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_in(3 downto 0);

    -- leftShiftStage0Idx3Pad24_uid830_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest(CONSTANT,829)
    leftShiftStage0Idx3Pad24_uid830_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q <= "000000000000000000000000";

    -- leftShiftStage0Idx3_uid902_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest(BITJOIN,901)@5
    leftShiftStage0Idx3_uid902_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q <= leftShiftStage0Idx3Rng24_uid901_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_b & leftShiftStage0Idx3Pad24_uid830_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q;

    -- leftShiftStage0Idx2_uid899_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest(BITJOIN,898)@5
    leftShiftStage0Idx2_uid899_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q <= vStage_uid747_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_b & zs_uid712_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q;

    -- leftShiftStage0Idx1Rng8_uid895_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest(BITSELECT,894)@5
    leftShiftStage0Idx1Rng8_uid895_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_in <= fracGRS_uid631_rImag_uid17_fpComplexMulTest_q(19 downto 0);
    leftShiftStage0Idx1Rng8_uid895_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_b <= leftShiftStage0Idx1Rng8_uid895_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_in(19 downto 0);

    -- leftShiftStage0Idx1_uid896_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest(BITJOIN,895)@5
    leftShiftStage0Idx1_uid896_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q <= leftShiftStage0Idx1Rng8_uid895_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_b & cstAllZWE_uid26_ac_uid6_fpComplexMulTest_q;

    -- leftShiftStage0_uid904_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest(MUX,903)@5
    leftShiftStage0_uid904_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_s <= leftShiftStageSel4Dto3_uid903_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_merged_bit_select_b;
    leftShiftStage0_uid904_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_combproc: PROCESS (leftShiftStage0_uid904_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_s, fracGRS_uid631_rImag_uid17_fpComplexMulTest_q, leftShiftStage0Idx1_uid896_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q, leftShiftStage0Idx2_uid899_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q, leftShiftStage0Idx3_uid902_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q)
    BEGIN
        CASE (leftShiftStage0_uid904_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_s) IS
            WHEN "00" => leftShiftStage0_uid904_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q <= fracGRS_uid631_rImag_uid17_fpComplexMulTest_q;
            WHEN "01" => leftShiftStage0_uid904_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q <= leftShiftStage0Idx1_uid896_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q;
            WHEN "10" => leftShiftStage0_uid904_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q <= leftShiftStage0Idx2_uid899_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q;
            WHEN "11" => leftShiftStage0_uid904_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q <= leftShiftStage0Idx3_uid902_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q;
            WHEN OTHERS => leftShiftStage0_uid904_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- leftShiftStage1_uid915_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest(MUX,914)@5
    leftShiftStage1_uid915_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_s <= leftShiftStageSel4Dto3_uid903_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_merged_bit_select_c;
    leftShiftStage1_uid915_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_combproc: PROCESS (leftShiftStage1_uid915_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_s, leftShiftStage0_uid904_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q, leftShiftStage1Idx1_uid907_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q, leftShiftStage1Idx2_uid910_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q, leftShiftStage1Idx3_uid913_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q)
    BEGIN
        CASE (leftShiftStage1_uid915_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_s) IS
            WHEN "00" => leftShiftStage1_uid915_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q <= leftShiftStage0_uid904_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q;
            WHEN "01" => leftShiftStage1_uid915_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q <= leftShiftStage1Idx1_uid907_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q;
            WHEN "10" => leftShiftStage1_uid915_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q <= leftShiftStage1Idx2_uid910_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q;
            WHEN "11" => leftShiftStage1_uid915_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q <= leftShiftStage1Idx3_uid913_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q;
            WHEN OTHERS => leftShiftStage1_uid915_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- leftShiftStageSel4Dto3_uid903_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_merged_bit_select(BITSELECT,936)@5
    leftShiftStageSel4Dto3_uid903_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_merged_bit_select_b <= r_uid772_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q(4 downto 3);
    leftShiftStageSel4Dto3_uid903_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_merged_bit_select_c <= r_uid772_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q(2 downto 1);
    leftShiftStageSel4Dto3_uid903_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_merged_bit_select_d <= r_uid772_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q(0 downto 0);

    -- leftShiftStage2_uid920_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest(MUX,919)@5
    leftShiftStage2_uid920_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_s <= leftShiftStageSel4Dto3_uid903_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_merged_bit_select_d;
    leftShiftStage2_uid920_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_combproc: PROCESS (leftShiftStage2_uid920_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_s, leftShiftStage1_uid915_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q, leftShiftStage2Idx1_uid918_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q)
    BEGIN
        CASE (leftShiftStage2_uid920_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_s) IS
            WHEN "0" => leftShiftStage2_uid920_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q <= leftShiftStage1_uid915_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q;
            WHEN "1" => leftShiftStage2_uid920_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q <= leftShiftStage2Idx1_uid918_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q;
            WHEN OTHERS => leftShiftStage2_uid920_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- LSB_uid644_rImag_uid17_fpComplexMulTest(BITSELECT,643)@5
    LSB_uid644_rImag_uid17_fpComplexMulTest_in <= STD_LOGIC_VECTOR(leftShiftStage2_uid920_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q(4 downto 0));
    LSB_uid644_rImag_uid17_fpComplexMulTest_b <= STD_LOGIC_VECTOR(LSB_uid644_rImag_uid17_fpComplexMulTest_in(4 downto 4));

    -- Guard_uid643_rImag_uid17_fpComplexMulTest(BITSELECT,642)@5
    Guard_uid643_rImag_uid17_fpComplexMulTest_in <= STD_LOGIC_VECTOR(leftShiftStage2_uid920_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q(3 downto 0));
    Guard_uid643_rImag_uid17_fpComplexMulTest_b <= STD_LOGIC_VECTOR(Guard_uid643_rImag_uid17_fpComplexMulTest_in(3 downto 3));

    -- Round_uid642_rImag_uid17_fpComplexMulTest(BITSELECT,641)@5
    Round_uid642_rImag_uid17_fpComplexMulTest_in <= STD_LOGIC_VECTOR(leftShiftStage2_uid920_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q(2 downto 0));
    Round_uid642_rImag_uid17_fpComplexMulTest_b <= STD_LOGIC_VECTOR(Round_uid642_rImag_uid17_fpComplexMulTest_in(2 downto 2));

    -- Sticky1_uid641_rImag_uid17_fpComplexMulTest(BITSELECT,640)@5
    Sticky1_uid641_rImag_uid17_fpComplexMulTest_in <= STD_LOGIC_VECTOR(leftShiftStage2_uid920_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q(1 downto 0));
    Sticky1_uid641_rImag_uid17_fpComplexMulTest_b <= STD_LOGIC_VECTOR(Sticky1_uid641_rImag_uid17_fpComplexMulTest_in(1 downto 1));

    -- Sticky0_uid640_rImag_uid17_fpComplexMulTest(BITSELECT,639)@5
    Sticky0_uid640_rImag_uid17_fpComplexMulTest_in <= STD_LOGIC_VECTOR(leftShiftStage2_uid920_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q(0 downto 0));
    Sticky0_uid640_rImag_uid17_fpComplexMulTest_b <= STD_LOGIC_VECTOR(Sticky0_uid640_rImag_uid17_fpComplexMulTest_in(0 downto 0));

    -- rndBitCond_uid645_rImag_uid17_fpComplexMulTest(BITJOIN,644)@5
    rndBitCond_uid645_rImag_uid17_fpComplexMulTest_q <= LSB_uid644_rImag_uid17_fpComplexMulTest_b & Guard_uid643_rImag_uid17_fpComplexMulTest_b & Round_uid642_rImag_uid17_fpComplexMulTest_b & Sticky1_uid641_rImag_uid17_fpComplexMulTest_b & Sticky0_uid640_rImag_uid17_fpComplexMulTest_b;

    -- rBi_uid647_rImag_uid17_fpComplexMulTest(LOGICAL,646)@5 + 1
    rBi_uid647_rImag_uid17_fpComplexMulTest_qi <= "1" WHEN rndBitCond_uid645_rImag_uid17_fpComplexMulTest_q = cRBit_uid486_rReal_uid16_fpComplexMulTest_q ELSE "0";
    rBi_uid647_rImag_uid17_fpComplexMulTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => rBi_uid647_rImag_uid17_fpComplexMulTest_qi, xout => rBi_uid647_rImag_uid17_fpComplexMulTest_q, clk => clk, aclr => areset );

    -- roundBit_uid648_rImag_uid17_fpComplexMulTest(LOGICAL,647)@6
    roundBit_uid648_rImag_uid17_fpComplexMulTest_q <= not (rBi_uid647_rImag_uid17_fpComplexMulTest_q);

    -- oneCST_uid477_rReal_uid16_fpComplexMulTest(CONSTANT,476)
    oneCST_uid477_rReal_uid16_fpComplexMulTest_q <= "00000001";

    -- redist9_expA_uid591_rImag_uid17_fpComplexMulTest_b_2(DELAY,946)
    redist9_expA_uid591_rImag_uid17_fpComplexMulTest_b_2 : dspba_delay
    GENERIC MAP ( width => 8, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => expA_uid591_rImag_uid17_fpComplexMulTest_b, xout => redist9_expA_uid591_rImag_uid17_fpComplexMulTest_b_2_q, clk => clk, aclr => areset );

    -- expInc_uid638_rImag_uid17_fpComplexMulTest(ADD,637)@5
    expInc_uid638_rImag_uid17_fpComplexMulTest_a <= STD_LOGIC_VECTOR("0" & redist9_expA_uid591_rImag_uid17_fpComplexMulTest_b_2_q);
    expInc_uid638_rImag_uid17_fpComplexMulTest_b <= STD_LOGIC_VECTOR("0" & oneCST_uid477_rReal_uid16_fpComplexMulTest_q);
    expInc_uid638_rImag_uid17_fpComplexMulTest_o <= STD_LOGIC_VECTOR(UNSIGNED(expInc_uid638_rImag_uid17_fpComplexMulTest_a) + UNSIGNED(expInc_uid638_rImag_uid17_fpComplexMulTest_b));
    expInc_uid638_rImag_uid17_fpComplexMulTest_q <= expInc_uid638_rImag_uid17_fpComplexMulTest_o(8 downto 0);

    -- expPostNorm_uid639_rImag_uid17_fpComplexMulTest(SUB,638)@5 + 1
    expPostNorm_uid639_rImag_uid17_fpComplexMulTest_a <= STD_LOGIC_VECTOR("0" & expInc_uid638_rImag_uid17_fpComplexMulTest_q);
    expPostNorm_uid639_rImag_uid17_fpComplexMulTest_b <= STD_LOGIC_VECTOR("00000" & r_uid772_lzCountVal_uid632_rImag_uid17_fpComplexMulTest_q);
    expPostNorm_uid639_rImag_uid17_fpComplexMulTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            expPostNorm_uid639_rImag_uid17_fpComplexMulTest_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            expPostNorm_uid639_rImag_uid17_fpComplexMulTest_o <= STD_LOGIC_VECTOR(UNSIGNED(expPostNorm_uid639_rImag_uid17_fpComplexMulTest_a) - UNSIGNED(expPostNorm_uid639_rImag_uid17_fpComplexMulTest_b));
        END IF;
    END PROCESS;
    expPostNorm_uid639_rImag_uid17_fpComplexMulTest_q <= expPostNorm_uid639_rImag_uid17_fpComplexMulTest_o(9 downto 0);

    -- fracPostNorm_uid636_rImag_uid17_fpComplexMulTest(BITSELECT,635)@5
    fracPostNorm_uid636_rImag_uid17_fpComplexMulTest_b <= leftShiftStage2_uid920_fracPostNormExt_uid635_rImag_uid17_fpComplexMulTest_q(27 downto 1);

    -- fracPostNormRndRange_uid649_rImag_uid17_fpComplexMulTest(BITSELECT,648)@5
    fracPostNormRndRange_uid649_rImag_uid17_fpComplexMulTest_in <= fracPostNorm_uid636_rImag_uid17_fpComplexMulTest_b(25 downto 0);
    fracPostNormRndRange_uid649_rImag_uid17_fpComplexMulTest_b <= fracPostNormRndRange_uid649_rImag_uid17_fpComplexMulTest_in(25 downto 2);

    -- redist0_fracPostNormRndRange_uid649_rImag_uid17_fpComplexMulTest_b_1(DELAY,937)
    redist0_fracPostNormRndRange_uid649_rImag_uid17_fpComplexMulTest_b_1 : dspba_delay
    GENERIC MAP ( width => 24, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracPostNormRndRange_uid649_rImag_uid17_fpComplexMulTest_b, xout => redist0_fracPostNormRndRange_uid649_rImag_uid17_fpComplexMulTest_b_1_q, clk => clk, aclr => areset );

    -- expFracR_uid650_rImag_uid17_fpComplexMulTest(BITJOIN,649)@6
    expFracR_uid650_rImag_uid17_fpComplexMulTest_q <= expPostNorm_uid639_rImag_uid17_fpComplexMulTest_q & redist0_fracPostNormRndRange_uid649_rImag_uid17_fpComplexMulTest_b_1_q;

    -- rndExpFrac_uid651_rImag_uid17_fpComplexMulTest(ADD,650)@6
    rndExpFrac_uid651_rImag_uid17_fpComplexMulTest_a <= STD_LOGIC_VECTOR("0" & expFracR_uid650_rImag_uid17_fpComplexMulTest_q);
    rndExpFrac_uid651_rImag_uid17_fpComplexMulTest_b <= STD_LOGIC_VECTOR("0000000000000000000000000000000000" & roundBit_uid648_rImag_uid17_fpComplexMulTest_q);
    rndExpFrac_uid651_rImag_uid17_fpComplexMulTest_o <= STD_LOGIC_VECTOR(UNSIGNED(rndExpFrac_uid651_rImag_uid17_fpComplexMulTest_a) + UNSIGNED(rndExpFrac_uid651_rImag_uid17_fpComplexMulTest_b));
    rndExpFrac_uid651_rImag_uid17_fpComplexMulTest_q <= rndExpFrac_uid651_rImag_uid17_fpComplexMulTest_o(34 downto 0);

    -- expRPreExc_uid664_rImag_uid17_fpComplexMulTest(BITSELECT,663)@6
    expRPreExc_uid664_rImag_uid17_fpComplexMulTest_in <= rndExpFrac_uid651_rImag_uid17_fpComplexMulTest_q(31 downto 0);
    expRPreExc_uid664_rImag_uid17_fpComplexMulTest_b <= expRPreExc_uid664_rImag_uid17_fpComplexMulTest_in(31 downto 24);

    -- rndExpFracOvfBits_uid656_rImag_uid17_fpComplexMulTest(BITSELECT,655)@6
    rndExpFracOvfBits_uid656_rImag_uid17_fpComplexMulTest_in <= rndExpFrac_uid651_rImag_uid17_fpComplexMulTest_q(33 downto 0);
    rndExpFracOvfBits_uid656_rImag_uid17_fpComplexMulTest_b <= rndExpFracOvfBits_uid656_rImag_uid17_fpComplexMulTest_in(33 downto 32);

    -- rOvfExtraBits_uid657_rImag_uid17_fpComplexMulTest(LOGICAL,656)@6
    rOvfExtraBits_uid657_rImag_uid17_fpComplexMulTest_q <= "1" WHEN rndExpFracOvfBits_uid656_rImag_uid17_fpComplexMulTest_b = one2b_uid387_rReal_uid16_fpComplexMulTest_q ELSE "0";

    -- wEP2AllOwE_uid492_rReal_uid16_fpComplexMulTest(CONSTANT,491)
    wEP2AllOwE_uid492_rReal_uid16_fpComplexMulTest_q <= "0011111111";

    -- rndExp_uid653_rImag_uid17_fpComplexMulTest(BITSELECT,652)@6
    rndExp_uid653_rImag_uid17_fpComplexMulTest_in <= rndExpFrac_uid651_rImag_uid17_fpComplexMulTest_q(33 downto 0);
    rndExp_uid653_rImag_uid17_fpComplexMulTest_b <= rndExp_uid653_rImag_uid17_fpComplexMulTest_in(33 downto 24);

    -- rOvfEQMax_uid654_rImag_uid17_fpComplexMulTest(LOGICAL,653)@6
    rOvfEQMax_uid654_rImag_uid17_fpComplexMulTest_q <= "1" WHEN rndExp_uid653_rImag_uid17_fpComplexMulTest_b = wEP2AllOwE_uid492_rReal_uid16_fpComplexMulTest_q ELSE "0";

    -- rOvf_uid658_rImag_uid17_fpComplexMulTest(LOGICAL,657)@6
    rOvf_uid658_rImag_uid17_fpComplexMulTest_q <= rOvfEQMax_uid654_rImag_uid17_fpComplexMulTest_q or rOvfExtraBits_uid657_rImag_uid17_fpComplexMulTest_q;

    -- regInputs_uid665_rImag_uid17_fpComplexMulTest(LOGICAL,664)@6
    regInputs_uid665_rImag_uid17_fpComplexMulTest_q <= excAR_uid585_rImag_uid17_fpComplexMulTest_q and excBR_uid589_rImag_uid17_fpComplexMulTest_q;

    -- aZeroBRegFPLib_uid669_rImag_uid17_fpComplexMulTest(LOGICAL,668)@6
    aZeroBRegFPLib_uid669_rImag_uid17_fpComplexMulTest_q <= redist12_excAZ_uid586_rImag_uid17_fpComplexMulTest_q_3_q and excBR_uid589_rImag_uid17_fpComplexMulTest_q;

    -- aRegBZeroFPLib_uid668_rImag_uid17_fpComplexMulTest(LOGICAL,667)@6
    aRegBZeroFPLib_uid668_rImag_uid17_fpComplexMulTest_q <= excAR_uid585_rImag_uid17_fpComplexMulTest_q and redist11_excBZ_uid590_rImag_uid17_fpComplexMulTest_q_3_q;

    -- fpLibRegInputs_uid670_rImag_uid17_fpComplexMulTest(LOGICAL,669)@6
    fpLibRegInputs_uid670_rImag_uid17_fpComplexMulTest_q <= aRegBZeroFPLib_uid668_rImag_uid17_fpComplexMulTest_q or aZeroBRegFPLib_uid669_rImag_uid17_fpComplexMulTest_q or regInputs_uid665_rImag_uid17_fpComplexMulTest_q;

    -- rInfOvf_uid671_rImag_uid17_fpComplexMulTest(LOGICAL,670)@6
    rInfOvf_uid671_rImag_uid17_fpComplexMulTest_q <= fpLibRegInputs_uid670_rImag_uid17_fpComplexMulTest_q and rOvf_uid658_rImag_uid17_fpComplexMulTest_q;

    -- excRInfVInC_uid672_rImag_uid17_fpComplexMulTest(BITJOIN,671)@6
    excRInfVInC_uid672_rImag_uid17_fpComplexMulTest_q <= rInfOvf_uid671_rImag_uid17_fpComplexMulTest_q & excBN_uid588_rImag_uid17_fpComplexMulTest_q & excAN_uid584_rImag_uid17_fpComplexMulTest_q & excBI_uid587_rImag_uid17_fpComplexMulTest_q & excAI_uid583_rImag_uid17_fpComplexMulTest_q & redist2_effSub_uid597_rImag_uid17_fpComplexMulTest_q_2_q;

    -- excRInf_uid673_rImag_uid17_fpComplexMulTest(LOOKUP,672)@6
    excRInf_uid673_rImag_uid17_fpComplexMulTest_combproc: PROCESS (excRInfVInC_uid672_rImag_uid17_fpComplexMulTest_q)
    BEGIN
        -- Begin reserved scope level
        CASE (excRInfVInC_uid672_rImag_uid17_fpComplexMulTest_q) IS
            WHEN "000000" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "000001" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "000010" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "1";
            WHEN "000011" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "1";
            WHEN "000100" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "1";
            WHEN "000101" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "1";
            WHEN "000110" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "1";
            WHEN "000111" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "001000" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "001001" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "001010" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "001011" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "001100" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "001101" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "001110" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "001111" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "010000" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "010001" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "010010" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "010011" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "010100" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "010101" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "010110" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "010111" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "011000" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "011001" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "011010" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "011011" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "011100" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "011101" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "011110" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "011111" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "100000" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "1";
            WHEN "100001" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "1";
            WHEN "100010" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "100011" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "100100" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "100101" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "100110" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "100111" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "101000" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "101001" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "101010" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "101011" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "101100" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "101101" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "101110" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "101111" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "110000" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "110001" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "110010" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "110011" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "110100" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "110101" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "110110" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "110111" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "111000" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "111001" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "111010" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "111011" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "111100" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "111101" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "111110" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "111111" => excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN OTHERS => -- unreachable
                           excRInf_uid673_rImag_uid17_fpComplexMulTest_q <= (others => '-');
        END CASE;
        -- End reserved scope level
    END PROCESS;

    -- rUdfExtraBit_uid661_rImag_uid17_fpComplexMulTest(BITSELECT,660)@6
    rUdfExtraBit_uid661_rImag_uid17_fpComplexMulTest_in <= STD_LOGIC_VECTOR(rndExpFrac_uid651_rImag_uid17_fpComplexMulTest_q(33 downto 0));
    rUdfExtraBit_uid661_rImag_uid17_fpComplexMulTest_b <= STD_LOGIC_VECTOR(rUdfExtraBit_uid661_rImag_uid17_fpComplexMulTest_in(33 downto 33));

    -- wEP2AllZ_uid499_rReal_uid16_fpComplexMulTest(CONSTANT,498)
    wEP2AllZ_uid499_rReal_uid16_fpComplexMulTest_q <= "0000000000";

    -- rUdfEQMin_uid660_rImag_uid17_fpComplexMulTest(LOGICAL,659)@6
    rUdfEQMin_uid660_rImag_uid17_fpComplexMulTest_q <= "1" WHEN rndExp_uid653_rImag_uid17_fpComplexMulTest_b = wEP2AllZ_uid499_rReal_uid16_fpComplexMulTest_q ELSE "0";

    -- rUdf_uid662_rImag_uid17_fpComplexMulTest(LOGICAL,661)@6
    rUdf_uid662_rImag_uid17_fpComplexMulTest_q <= rUdfEQMin_uid660_rImag_uid17_fpComplexMulTest_q or rUdfExtraBit_uid661_rImag_uid17_fpComplexMulTest_b;

    -- excRZeroVInC_uid666_rImag_uid17_fpComplexMulTest(BITJOIN,665)@6
    excRZeroVInC_uid666_rImag_uid17_fpComplexMulTest_q <= aMinusA_uid634_rImag_uid17_fpComplexMulTest_q & rUdf_uid662_rImag_uid17_fpComplexMulTest_q & regInputs_uid665_rImag_uid17_fpComplexMulTest_q & redist11_excBZ_uid590_rImag_uid17_fpComplexMulTest_q_3_q & redist12_excAZ_uid586_rImag_uid17_fpComplexMulTest_q_3_q;

    -- excRZero_uid667_rImag_uid17_fpComplexMulTest(LOOKUP,666)@6
    excRZero_uid667_rImag_uid17_fpComplexMulTest_combproc: PROCESS (excRZeroVInC_uid666_rImag_uid17_fpComplexMulTest_q)
    BEGIN
        -- Begin reserved scope level
        CASE (excRZeroVInC_uid666_rImag_uid17_fpComplexMulTest_q) IS
            WHEN "00000" => excRZero_uid667_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "00001" => excRZero_uid667_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "00010" => excRZero_uid667_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "00011" => excRZero_uid667_rImag_uid17_fpComplexMulTest_q <= "1";
            WHEN "00100" => excRZero_uid667_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "00101" => excRZero_uid667_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "00110" => excRZero_uid667_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "00111" => excRZero_uid667_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "01000" => excRZero_uid667_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "01001" => excRZero_uid667_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "01010" => excRZero_uid667_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "01011" => excRZero_uid667_rImag_uid17_fpComplexMulTest_q <= "1";
            WHEN "01100" => excRZero_uid667_rImag_uid17_fpComplexMulTest_q <= "1";
            WHEN "01101" => excRZero_uid667_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "01110" => excRZero_uid667_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "01111" => excRZero_uid667_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "10000" => excRZero_uid667_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "10001" => excRZero_uid667_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "10010" => excRZero_uid667_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "10011" => excRZero_uid667_rImag_uid17_fpComplexMulTest_q <= "1";
            WHEN "10100" => excRZero_uid667_rImag_uid17_fpComplexMulTest_q <= "1";
            WHEN "10101" => excRZero_uid667_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "10110" => excRZero_uid667_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "10111" => excRZero_uid667_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "11000" => excRZero_uid667_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "11001" => excRZero_uid667_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "11010" => excRZero_uid667_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "11011" => excRZero_uid667_rImag_uid17_fpComplexMulTest_q <= "1";
            WHEN "11100" => excRZero_uid667_rImag_uid17_fpComplexMulTest_q <= "1";
            WHEN "11101" => excRZero_uid667_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "11110" => excRZero_uid667_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN "11111" => excRZero_uid667_rImag_uid17_fpComplexMulTest_q <= "0";
            WHEN OTHERS => -- unreachable
                           excRZero_uid667_rImag_uid17_fpComplexMulTest_q <= (others => '-');
        END CASE;
        -- End reserved scope level
    END PROCESS;

    -- concExc_uid677_rImag_uid17_fpComplexMulTest(BITJOIN,676)@6
    concExc_uid677_rImag_uid17_fpComplexMulTest_q <= excRNaN_uid676_rImag_uid17_fpComplexMulTest_q & excRInf_uid673_rImag_uid17_fpComplexMulTest_q & excRZero_uid667_rImag_uid17_fpComplexMulTest_q;

    -- excREnc_uid678_rImag_uid17_fpComplexMulTest(LOOKUP,677)@6
    excREnc_uid678_rImag_uid17_fpComplexMulTest_combproc: PROCESS (concExc_uid677_rImag_uid17_fpComplexMulTest_q)
    BEGIN
        -- Begin reserved scope level
        CASE (concExc_uid677_rImag_uid17_fpComplexMulTest_q) IS
            WHEN "000" => excREnc_uid678_rImag_uid17_fpComplexMulTest_q <= "01";
            WHEN "001" => excREnc_uid678_rImag_uid17_fpComplexMulTest_q <= "00";
            WHEN "010" => excREnc_uid678_rImag_uid17_fpComplexMulTest_q <= "10";
            WHEN "011" => excREnc_uid678_rImag_uid17_fpComplexMulTest_q <= "10";
            WHEN "100" => excREnc_uid678_rImag_uid17_fpComplexMulTest_q <= "11";
            WHEN "101" => excREnc_uid678_rImag_uid17_fpComplexMulTest_q <= "11";
            WHEN "110" => excREnc_uid678_rImag_uid17_fpComplexMulTest_q <= "11";
            WHEN "111" => excREnc_uid678_rImag_uid17_fpComplexMulTest_q <= "11";
            WHEN OTHERS => -- unreachable
                           excREnc_uid678_rImag_uid17_fpComplexMulTest_q <= (others => '-');
        END CASE;
        -- End reserved scope level
    END PROCESS;

    -- expRPostExc_uid697_rImag_uid17_fpComplexMulTest(MUX,696)@6
    expRPostExc_uid697_rImag_uid17_fpComplexMulTest_s <= excREnc_uid678_rImag_uid17_fpComplexMulTest_q;
    expRPostExc_uid697_rImag_uid17_fpComplexMulTest_combproc: PROCESS (expRPostExc_uid697_rImag_uid17_fpComplexMulTest_s, cstAllZWE_uid26_ac_uid6_fpComplexMulTest_q, expRPreExc_uid664_rImag_uid17_fpComplexMulTest_b, cstAllOWE_uid24_ac_uid6_fpComplexMulTest_q)
    BEGIN
        CASE (expRPostExc_uid697_rImag_uid17_fpComplexMulTest_s) IS
            WHEN "00" => expRPostExc_uid697_rImag_uid17_fpComplexMulTest_q <= cstAllZWE_uid26_ac_uid6_fpComplexMulTest_q;
            WHEN "01" => expRPostExc_uid697_rImag_uid17_fpComplexMulTest_q <= expRPreExc_uid664_rImag_uid17_fpComplexMulTest_b;
            WHEN "10" => expRPostExc_uid697_rImag_uid17_fpComplexMulTest_q <= cstAllOWE_uid24_ac_uid6_fpComplexMulTest_q;
            WHEN "11" => expRPostExc_uid697_rImag_uid17_fpComplexMulTest_q <= cstAllOWE_uid24_ac_uid6_fpComplexMulTest_q;
            WHEN OTHERS => expRPostExc_uid697_rImag_uid17_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- oneFracRPostExc2_uid530_rReal_uid16_fpComplexMulTest(CONSTANT,529)
    oneFracRPostExc2_uid530_rReal_uid16_fpComplexMulTest_q <= "00000000000000000000001";

    -- fracRPreExc_uid663_rImag_uid17_fpComplexMulTest(BITSELECT,662)@6
    fracRPreExc_uid663_rImag_uid17_fpComplexMulTest_in <= rndExpFrac_uid651_rImag_uid17_fpComplexMulTest_q(23 downto 0);
    fracRPreExc_uid663_rImag_uid17_fpComplexMulTest_b <= fracRPreExc_uid663_rImag_uid17_fpComplexMulTest_in(23 downto 1);

    -- fracRPostExc_uid693_rImag_uid17_fpComplexMulTest(MUX,692)@6
    fracRPostExc_uid693_rImag_uid17_fpComplexMulTest_s <= excREnc_uid678_rImag_uid17_fpComplexMulTest_q;
    fracRPostExc_uid693_rImag_uid17_fpComplexMulTest_combproc: PROCESS (fracRPostExc_uid693_rImag_uid17_fpComplexMulTest_s, cstZeroWF_uid25_ac_uid6_fpComplexMulTest_q, fracRPreExc_uid663_rImag_uid17_fpComplexMulTest_b, oneFracRPostExc2_uid530_rReal_uid16_fpComplexMulTest_q)
    BEGIN
        CASE (fracRPostExc_uid693_rImag_uid17_fpComplexMulTest_s) IS
            WHEN "00" => fracRPostExc_uid693_rImag_uid17_fpComplexMulTest_q <= cstZeroWF_uid25_ac_uid6_fpComplexMulTest_q;
            WHEN "01" => fracRPostExc_uid693_rImag_uid17_fpComplexMulTest_q <= fracRPreExc_uid663_rImag_uid17_fpComplexMulTest_b;
            WHEN "10" => fracRPostExc_uid693_rImag_uid17_fpComplexMulTest_q <= cstZeroWF_uid25_ac_uid6_fpComplexMulTest_q;
            WHEN "11" => fracRPostExc_uid693_rImag_uid17_fpComplexMulTest_q <= oneFracRPostExc2_uid530_rReal_uid16_fpComplexMulTest_q;
            WHEN OTHERS => fracRPostExc_uid693_rImag_uid17_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- R_uid698_rImag_uid17_fpComplexMulTest(BITJOIN,697)@6
    R_uid698_rImag_uid17_fpComplexMulTest_q <= signRPostExc_uid689_rImag_uid17_fpComplexMulTest_q & expRPostExc_uid697_rImag_uid17_fpComplexMulTest_q & fracRPostExc_uid693_rImag_uid17_fpComplexMulTest_q;

    -- excYZAndExcXI_uid190_bd_uid7_fpComplexMulTest(LOGICAL,189)@2
    excYZAndExcXI_uid190_bd_uid7_fpComplexMulTest_q <= excZ_y_uid133_bd_uid7_fpComplexMulTest_q and excI_x_uid123_bd_uid7_fpComplexMulTest_q;

    -- excXZAndExcYI_uid191_bd_uid7_fpComplexMulTest(LOGICAL,190)@2
    excXZAndExcYI_uid191_bd_uid7_fpComplexMulTest_q <= excZ_x_uid119_bd_uid7_fpComplexMulTest_q and excI_y_uid137_bd_uid7_fpComplexMulTest_q;

    -- ZeroTimesInf_uid192_bd_uid7_fpComplexMulTest(LOGICAL,191)@2
    ZeroTimesInf_uid192_bd_uid7_fpComplexMulTest_q <= excXZAndExcYI_uid191_bd_uid7_fpComplexMulTest_q or excYZAndExcXI_uid190_bd_uid7_fpComplexMulTest_q;

    -- excRNaN_uid193_bd_uid7_fpComplexMulTest(LOGICAL,192)@2
    excRNaN_uid193_bd_uid7_fpComplexMulTest_q <= excN_x_uid124_bd_uid7_fpComplexMulTest_q or excN_y_uid138_bd_uid7_fpComplexMulTest_q or ZeroTimesInf_uid192_bd_uid7_fpComplexMulTest_q;

    -- prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma(CHAINMULTADD,922)@0 + 2
    prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_reset <= areset;
    prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_ena0 <= '1';
    prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_ena1 <= prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_ena0;
    prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_p(0) <= prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_a0(0) * prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_c0(0);
    prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_u(0) <= RESIZE(prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_p(0),48);
    prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_w(0) <= prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_u(0);
    prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_x(0) <= prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_w(0);
    prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_y(0) <= prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_x(0);
    prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_chainmultadd_input: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_a0 <= (others => (others => '0'));
            prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_c0 <= (others => (others => '0'));
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_ena0 = '1') THEN
                prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_a0(0) <= RESIZE(UNSIGNED(ofracX_uid144_bd_uid7_fpComplexMulTest_q),24);
                prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_c0(0) <= RESIZE(UNSIGNED(ofracY_uid147_bd_uid7_fpComplexMulTest_q),24);
            END IF;
        END IF;
    END PROCESS;
    prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_chainmultadd_output: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_s <= (others => (others => '0'));
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_ena1 = '1') THEN
                prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_s(0) <= prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_y(0);
            END IF;
        END IF;
    END PROCESS;
    prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_delay : dspba_delay
    GENERIC MAP ( width => 48, depth => 0, reset_kind => "ASYNC" )
    PORT MAP ( xin => STD_LOGIC_VECTOR(prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_s(0)(47 downto 0)), xout => prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_qq, clk => clk, aclr => areset );
    prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_q <= STD_LOGIC_VECTOR(prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_qq(47 downto 0));

    -- normalizeBit_uid153_bd_uid7_fpComplexMulTest(BITSELECT,152)@2
    normalizeBit_uid153_bd_uid7_fpComplexMulTest_b <= STD_LOGIC_VECTOR(prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_q(47 downto 47));

    -- fracRPostNormHigh_uid155_bd_uid7_fpComplexMulTest(BITSELECT,154)@2
    fracRPostNormHigh_uid155_bd_uid7_fpComplexMulTest_in <= prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_q(46 downto 0);
    fracRPostNormHigh_uid155_bd_uid7_fpComplexMulTest_b <= fracRPostNormHigh_uid155_bd_uid7_fpComplexMulTest_in(46 downto 23);

    -- fracRPostNormLow_uid156_bd_uid7_fpComplexMulTest(BITSELECT,155)@2
    fracRPostNormLow_uid156_bd_uid7_fpComplexMulTest_in <= prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_q(45 downto 0);
    fracRPostNormLow_uid156_bd_uid7_fpComplexMulTest_b <= fracRPostNormLow_uid156_bd_uid7_fpComplexMulTest_in(45 downto 22);

    -- fracRPostNorm_uid157_bd_uid7_fpComplexMulTest(MUX,156)@2
    fracRPostNorm_uid157_bd_uid7_fpComplexMulTest_s <= normalizeBit_uid153_bd_uid7_fpComplexMulTest_b;
    fracRPostNorm_uid157_bd_uid7_fpComplexMulTest_combproc: PROCESS (fracRPostNorm_uid157_bd_uid7_fpComplexMulTest_s, fracRPostNormLow_uid156_bd_uid7_fpComplexMulTest_b, fracRPostNormHigh_uid155_bd_uid7_fpComplexMulTest_b)
    BEGIN
        CASE (fracRPostNorm_uid157_bd_uid7_fpComplexMulTest_s) IS
            WHEN "0" => fracRPostNorm_uid157_bd_uid7_fpComplexMulTest_q <= fracRPostNormLow_uid156_bd_uid7_fpComplexMulTest_b;
            WHEN "1" => fracRPostNorm_uid157_bd_uid7_fpComplexMulTest_q <= fracRPostNormHigh_uid155_bd_uid7_fpComplexMulTest_b;
            WHEN OTHERS => fracRPostNorm_uid157_bd_uid7_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- fracRPostNorm1dto0_uid165_bd_uid7_fpComplexMulTest(BITSELECT,164)@2
    fracRPostNorm1dto0_uid165_bd_uid7_fpComplexMulTest_in <= fracRPostNorm_uid157_bd_uid7_fpComplexMulTest_q(1 downto 0);
    fracRPostNorm1dto0_uid165_bd_uid7_fpComplexMulTest_b <= fracRPostNorm1dto0_uid165_bd_uid7_fpComplexMulTest_in(1 downto 0);

    -- extraStickyBitOfProd_uid159_bd_uid7_fpComplexMulTest(BITSELECT,158)@2
    extraStickyBitOfProd_uid159_bd_uid7_fpComplexMulTest_in <= STD_LOGIC_VECTOR(prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_q(22 downto 0));
    extraStickyBitOfProd_uid159_bd_uid7_fpComplexMulTest_b <= STD_LOGIC_VECTOR(extraStickyBitOfProd_uid159_bd_uid7_fpComplexMulTest_in(22 downto 22));

    -- extraStickyBit_uid160_bd_uid7_fpComplexMulTest(MUX,159)@2
    extraStickyBit_uid160_bd_uid7_fpComplexMulTest_s <= normalizeBit_uid153_bd_uid7_fpComplexMulTest_b;
    extraStickyBit_uid160_bd_uid7_fpComplexMulTest_combproc: PROCESS (extraStickyBit_uid160_bd_uid7_fpComplexMulTest_s, GND_q, extraStickyBitOfProd_uid159_bd_uid7_fpComplexMulTest_b)
    BEGIN
        CASE (extraStickyBit_uid160_bd_uid7_fpComplexMulTest_s) IS
            WHEN "0" => extraStickyBit_uid160_bd_uid7_fpComplexMulTest_q <= GND_q;
            WHEN "1" => extraStickyBit_uid160_bd_uid7_fpComplexMulTest_q <= extraStickyBitOfProd_uid159_bd_uid7_fpComplexMulTest_b;
            WHEN OTHERS => extraStickyBit_uid160_bd_uid7_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- stickyRange_uid158_bd_uid7_fpComplexMulTest(BITSELECT,157)@2
    stickyRange_uid158_bd_uid7_fpComplexMulTest_in <= prodXY_uid703_prod_uid151_bd_uid7_fpComplexMulTest_cma_q(21 downto 0);
    stickyRange_uid158_bd_uid7_fpComplexMulTest_b <= stickyRange_uid158_bd_uid7_fpComplexMulTest_in(21 downto 0);

    -- stickyExtendedRange_uid161_bd_uid7_fpComplexMulTest(BITJOIN,160)@2
    stickyExtendedRange_uid161_bd_uid7_fpComplexMulTest_q <= extraStickyBit_uid160_bd_uid7_fpComplexMulTest_q & stickyRange_uid158_bd_uid7_fpComplexMulTest_b;

    -- stickyRangeComparator_uid163_bd_uid7_fpComplexMulTest(LOGICAL,162)@2
    stickyRangeComparator_uid163_bd_uid7_fpComplexMulTest_q <= "1" WHEN stickyExtendedRange_uid161_bd_uid7_fpComplexMulTest_q = cstZeroWF_uid25_ac_uid6_fpComplexMulTest_q ELSE "0";

    -- sticky_uid164_bd_uid7_fpComplexMulTest(LOGICAL,163)@2
    sticky_uid164_bd_uid7_fpComplexMulTest_q <= not (stickyRangeComparator_uid163_bd_uid7_fpComplexMulTest_q);

    -- lrs_uid166_bd_uid7_fpComplexMulTest(BITJOIN,165)@2
    lrs_uid166_bd_uid7_fpComplexMulTest_q <= fracRPostNorm1dto0_uid165_bd_uid7_fpComplexMulTest_b & sticky_uid164_bd_uid7_fpComplexMulTest_q;

    -- roundBitDetectionPattern_uid168_bd_uid7_fpComplexMulTest(LOGICAL,167)@2
    roundBitDetectionPattern_uid168_bd_uid7_fpComplexMulTest_q <= "1" WHEN lrs_uid166_bd_uid7_fpComplexMulTest_q = roundBitDetectionConstant_uid77_ac_uid6_fpComplexMulTest_q ELSE "0";

    -- roundBit_uid169_bd_uid7_fpComplexMulTest(LOGICAL,168)@2
    roundBit_uid169_bd_uid7_fpComplexMulTest_q <= not (roundBitDetectionPattern_uid168_bd_uid7_fpComplexMulTest_q);

    -- roundBitAndNormalizationOp_uid172_bd_uid7_fpComplexMulTest(BITJOIN,171)@2
    roundBitAndNormalizationOp_uid172_bd_uid7_fpComplexMulTest_q <= GND_q & normalizeBit_uid153_bd_uid7_fpComplexMulTest_b & cstZeroWF_uid25_ac_uid6_fpComplexMulTest_q & roundBit_uid169_bd_uid7_fpComplexMulTest_q;

    -- expSum_uid148_bd_uid7_fpComplexMulTest(ADD,147)@2
    expSum_uid148_bd_uid7_fpComplexMulTest_a <= STD_LOGIC_VECTOR("0" & redist48_expX_uid110_bd_uid7_fpComplexMulTest_b_2_q);
    expSum_uid148_bd_uid7_fpComplexMulTest_b <= STD_LOGIC_VECTOR("0" & redist47_expY_uid111_bd_uid7_fpComplexMulTest_b_2_q);
    expSum_uid148_bd_uid7_fpComplexMulTest_o <= STD_LOGIC_VECTOR(UNSIGNED(expSum_uid148_bd_uid7_fpComplexMulTest_a) + UNSIGNED(expSum_uid148_bd_uid7_fpComplexMulTest_b));
    expSum_uid148_bd_uid7_fpComplexMulTest_q <= expSum_uid148_bd_uid7_fpComplexMulTest_o(8 downto 0);

    -- expSumMBias_uid150_bd_uid7_fpComplexMulTest(SUB,149)@2
    expSumMBias_uid150_bd_uid7_fpComplexMulTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("000" & expSum_uid148_bd_uid7_fpComplexMulTest_q));
    expSumMBias_uid150_bd_uid7_fpComplexMulTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((11 downto 10 => biasInc_uid59_ac_uid6_fpComplexMulTest_q(9)) & biasInc_uid59_ac_uid6_fpComplexMulTest_q));
    expSumMBias_uid150_bd_uid7_fpComplexMulTest_o <= STD_LOGIC_VECTOR(SIGNED(expSumMBias_uid150_bd_uid7_fpComplexMulTest_a) - SIGNED(expSumMBias_uid150_bd_uid7_fpComplexMulTest_b));
    expSumMBias_uid150_bd_uid7_fpComplexMulTest_q <= expSumMBias_uid150_bd_uid7_fpComplexMulTest_o(10 downto 0);

    -- expFracPreRound_uid170_bd_uid7_fpComplexMulTest(BITJOIN,169)@2
    expFracPreRound_uid170_bd_uid7_fpComplexMulTest_q <= expSumMBias_uid150_bd_uid7_fpComplexMulTest_q & fracRPostNorm_uid157_bd_uid7_fpComplexMulTest_q;

    -- expFracRPostRounding_uid173_bd_uid7_fpComplexMulTest(ADD,172)@2
    expFracRPostRounding_uid173_bd_uid7_fpComplexMulTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((36 downto 35 => expFracPreRound_uid170_bd_uid7_fpComplexMulTest_q(34)) & expFracPreRound_uid170_bd_uid7_fpComplexMulTest_q));
    expFracRPostRounding_uid173_bd_uid7_fpComplexMulTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("00000000000" & roundBitAndNormalizationOp_uid172_bd_uid7_fpComplexMulTest_q));
    expFracRPostRounding_uid173_bd_uid7_fpComplexMulTest_o <= STD_LOGIC_VECTOR(SIGNED(expFracRPostRounding_uid173_bd_uid7_fpComplexMulTest_a) + SIGNED(expFracRPostRounding_uid173_bd_uid7_fpComplexMulTest_b));
    expFracRPostRounding_uid173_bd_uid7_fpComplexMulTest_q <= expFracRPostRounding_uid173_bd_uid7_fpComplexMulTest_o(35 downto 0);

    -- expRPreExcExt_uid175_bd_uid7_fpComplexMulTest(BITSELECT,174)@2
    expRPreExcExt_uid175_bd_uid7_fpComplexMulTest_b <= STD_LOGIC_VECTOR(expFracRPostRounding_uid173_bd_uid7_fpComplexMulTest_q(35 downto 24));

    -- expOvf_uid179_bd_uid7_fpComplexMulTest(COMPARE,178)@2
    expOvf_uid179_bd_uid7_fpComplexMulTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("000000" & cstAllOWE_uid24_ac_uid6_fpComplexMulTest_q));
    expOvf_uid179_bd_uid7_fpComplexMulTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((13 downto 12 => expRPreExcExt_uid175_bd_uid7_fpComplexMulTest_b(11)) & expRPreExcExt_uid175_bd_uid7_fpComplexMulTest_b));
    expOvf_uid179_bd_uid7_fpComplexMulTest_o <= STD_LOGIC_VECTOR(SIGNED(expOvf_uid179_bd_uid7_fpComplexMulTest_a) - SIGNED(expOvf_uid179_bd_uid7_fpComplexMulTest_b));
    expOvf_uid179_bd_uid7_fpComplexMulTest_c(0) <= expOvf_uid179_bd_uid7_fpComplexMulTest_o(13);

    -- ExcROvfAndInReg_uid188_bd_uid7_fpComplexMulTest(LOGICAL,187)@2
    ExcROvfAndInReg_uid188_bd_uid7_fpComplexMulTest_q <= excR_x_uid127_bd_uid7_fpComplexMulTest_q and excR_y_uid141_bd_uid7_fpComplexMulTest_q and expOvf_uid179_bd_uid7_fpComplexMulTest_c;

    -- excYRAndExcXI_uid187_bd_uid7_fpComplexMulTest(LOGICAL,186)@2
    excYRAndExcXI_uid187_bd_uid7_fpComplexMulTest_q <= excR_y_uid141_bd_uid7_fpComplexMulTest_q and excI_x_uid123_bd_uid7_fpComplexMulTest_q;

    -- excXRAndExcYI_uid186_bd_uid7_fpComplexMulTest(LOGICAL,185)@2
    excXRAndExcYI_uid186_bd_uid7_fpComplexMulTest_q <= excR_x_uid127_bd_uid7_fpComplexMulTest_q and excI_y_uid137_bd_uid7_fpComplexMulTest_q;

    -- excXIAndExcYI_uid185_bd_uid7_fpComplexMulTest(LOGICAL,184)@2
    excXIAndExcYI_uid185_bd_uid7_fpComplexMulTest_q <= excI_x_uid123_bd_uid7_fpComplexMulTest_q and excI_y_uid137_bd_uid7_fpComplexMulTest_q;

    -- excRInf_uid189_bd_uid7_fpComplexMulTest(LOGICAL,188)@2
    excRInf_uid189_bd_uid7_fpComplexMulTest_q <= excXIAndExcYI_uid185_bd_uid7_fpComplexMulTest_q or excXRAndExcYI_uid186_bd_uid7_fpComplexMulTest_q or excYRAndExcXI_uid187_bd_uid7_fpComplexMulTest_q or ExcROvfAndInReg_uid188_bd_uid7_fpComplexMulTest_q;

    -- expUdf_uid177_bd_uid7_fpComplexMulTest_cmp_sign(LOGICAL,775)@2
    expUdf_uid177_bd_uid7_fpComplexMulTest_cmp_sign_q <= STD_LOGIC_VECTOR(expRPreExcExt_uid175_bd_uid7_fpComplexMulTest_b(11 downto 11));

    -- excZC3_uid183_bd_uid7_fpComplexMulTest(LOGICAL,182)@2
    excZC3_uid183_bd_uid7_fpComplexMulTest_q <= excR_x_uid127_bd_uid7_fpComplexMulTest_q and excR_y_uid141_bd_uid7_fpComplexMulTest_q and expUdf_uid177_bd_uid7_fpComplexMulTest_cmp_sign_q;

    -- excYZAndExcXR_uid182_bd_uid7_fpComplexMulTest(LOGICAL,181)@2
    excYZAndExcXR_uid182_bd_uid7_fpComplexMulTest_q <= excZ_y_uid133_bd_uid7_fpComplexMulTest_q and excR_x_uid127_bd_uid7_fpComplexMulTest_q;

    -- excXZAndExcYR_uid181_bd_uid7_fpComplexMulTest(LOGICAL,180)@2
    excXZAndExcYR_uid181_bd_uid7_fpComplexMulTest_q <= excZ_x_uid119_bd_uid7_fpComplexMulTest_q and excR_y_uid141_bd_uid7_fpComplexMulTest_q;

    -- excXZAndExcYZ_uid180_bd_uid7_fpComplexMulTest(LOGICAL,179)@2
    excXZAndExcYZ_uid180_bd_uid7_fpComplexMulTest_q <= excZ_x_uid119_bd_uid7_fpComplexMulTest_q and excZ_y_uid133_bd_uid7_fpComplexMulTest_q;

    -- excRZero_uid184_bd_uid7_fpComplexMulTest(LOGICAL,183)@2
    excRZero_uid184_bd_uid7_fpComplexMulTest_q <= excXZAndExcYZ_uid180_bd_uid7_fpComplexMulTest_q or excXZAndExcYR_uid181_bd_uid7_fpComplexMulTest_q or excYZAndExcXR_uid182_bd_uid7_fpComplexMulTest_q or excZC3_uid183_bd_uid7_fpComplexMulTest_q;

    -- concExc_uid194_bd_uid7_fpComplexMulTest(BITJOIN,193)@2
    concExc_uid194_bd_uid7_fpComplexMulTest_q <= excRNaN_uid193_bd_uid7_fpComplexMulTest_q & excRInf_uid189_bd_uid7_fpComplexMulTest_q & excRZero_uid184_bd_uid7_fpComplexMulTest_q;

    -- excREnc_uid195_bd_uid7_fpComplexMulTest(LOOKUP,194)@2
    excREnc_uid195_bd_uid7_fpComplexMulTest_combproc: PROCESS (concExc_uid194_bd_uid7_fpComplexMulTest_q)
    BEGIN
        -- Begin reserved scope level
        CASE (concExc_uid194_bd_uid7_fpComplexMulTest_q) IS
            WHEN "000" => excREnc_uid195_bd_uid7_fpComplexMulTest_q <= "01";
            WHEN "001" => excREnc_uid195_bd_uid7_fpComplexMulTest_q <= "00";
            WHEN "010" => excREnc_uid195_bd_uid7_fpComplexMulTest_q <= "10";
            WHEN "011" => excREnc_uid195_bd_uid7_fpComplexMulTest_q <= "00";
            WHEN "100" => excREnc_uid195_bd_uid7_fpComplexMulTest_q <= "11";
            WHEN "101" => excREnc_uid195_bd_uid7_fpComplexMulTest_q <= "00";
            WHEN "110" => excREnc_uid195_bd_uid7_fpComplexMulTest_q <= "00";
            WHEN "111" => excREnc_uid195_bd_uid7_fpComplexMulTest_q <= "00";
            WHEN OTHERS => -- unreachable
                           excREnc_uid195_bd_uid7_fpComplexMulTest_q <= (others => '-');
        END CASE;
        -- End reserved scope level
    END PROCESS;

    -- invExcRNaN_uid196_bd_uid7_fpComplexMulTest(LOGICAL,195)@2
    invExcRNaN_uid196_bd_uid7_fpComplexMulTest_q <= not (excRNaN_uid193_bd_uid7_fpComplexMulTest_q);

    -- signR_uid152_bd_uid7_fpComplexMulTest(LOGICAL,151)@2
    signR_uid152_bd_uid7_fpComplexMulTest_q <= redist46_signX_uid112_bd_uid7_fpComplexMulTest_b_2_q xor redist45_signY_uid113_bd_uid7_fpComplexMulTest_b_2_q;

    -- signRPostExc_uid197_bd_uid7_fpComplexMulTest(LOGICAL,196)@2
    signRPostExc_uid197_bd_uid7_fpComplexMulTest_q <= signR_uid152_bd_uid7_fpComplexMulTest_q and invExcRNaN_uid196_bd_uid7_fpComplexMulTest_q;

    -- expRPreExc_uid176_bd_uid7_fpComplexMulTest(BITSELECT,175)@2
    expRPreExc_uid176_bd_uid7_fpComplexMulTest_in <= expRPreExcExt_uid175_bd_uid7_fpComplexMulTest_b(7 downto 0);
    expRPreExc_uid176_bd_uid7_fpComplexMulTest_b <= expRPreExc_uid176_bd_uid7_fpComplexMulTest_in(7 downto 0);

    -- fracRPreExc_uid174_bd_uid7_fpComplexMulTest(BITSELECT,173)@2
    fracRPreExc_uid174_bd_uid7_fpComplexMulTest_in <= expFracRPostRounding_uid173_bd_uid7_fpComplexMulTest_q(23 downto 0);
    fracRPreExc_uid174_bd_uid7_fpComplexMulTest_b <= fracRPreExc_uid174_bd_uid7_fpComplexMulTest_in(23 downto 1);

    -- R_uid198_bd_uid7_fpComplexMulTest(BITJOIN,197)@2
    R_uid198_bd_uid7_fpComplexMulTest_q <= excREnc_uid195_bd_uid7_fpComplexMulTest_q & signRPostExc_uid197_bd_uid7_fpComplexMulTest_q & expRPreExc_uid176_bd_uid7_fpComplexMulTest_b & fracRPreExc_uid174_bd_uid7_fpComplexMulTest_b;

    -- excBits_uid11_fpComplexMulTest(BITSELECT,10)@2
    excBits_uid11_fpComplexMulTest_b <= R_uid198_bd_uid7_fpComplexMulTest_q(33 downto 32);

    -- redist59_excBits_uid11_fpComplexMulTest_b_1(DELAY,996)
    redist59_excBits_uid11_fpComplexMulTest_b_1 : dspba_delay
    GENERIC MAP ( width => 2, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => excBits_uid11_fpComplexMulTest_b, xout => redist59_excBits_uid11_fpComplexMulTest_b_1_q, clk => clk, aclr => areset );

    -- ySign_uid10_fpComplexMulTest(BITSELECT,9)@2
    ySign_uid10_fpComplexMulTest_b <= STD_LOGIC_VECTOR(R_uid198_bd_uid7_fpComplexMulTest_q(31 downto 31));

    -- redist60_ySign_uid10_fpComplexMulTest_b_1(DELAY,997)
    redist60_ySign_uid10_fpComplexMulTest_b_1 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => ySign_uid10_fpComplexMulTest_b, xout => redist60_ySign_uid10_fpComplexMulTest_b_1_q, clk => clk, aclr => areset );

    -- invYSign_uid14_fpComplexMulTest(LOGICAL,13)@3
    invYSign_uid14_fpComplexMulTest_q <= not (redist60_ySign_uid10_fpComplexMulTest_b_1_q);

    -- exp_uid13_fpComplexMulTest(BITSELECT,12)@2
    exp_uid13_fpComplexMulTest_b <= R_uid198_bd_uid7_fpComplexMulTest_q(30 downto 23);

    -- redist57_exp_uid13_fpComplexMulTest_b_1(DELAY,994)
    redist57_exp_uid13_fpComplexMulTest_b_1 : dspba_delay
    GENERIC MAP ( width => 8, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => exp_uid13_fpComplexMulTest_b, xout => redist57_exp_uid13_fpComplexMulTest_b_1_q, clk => clk, aclr => areset );

    -- fraction_uid12_fpComplexMulTest(BITSELECT,11)@2
    fraction_uid12_fpComplexMulTest_b <= R_uid198_bd_uid7_fpComplexMulTest_q(22 downto 0);

    -- redist58_fraction_uid12_fpComplexMulTest_b_1(DELAY,995)
    redist58_fraction_uid12_fpComplexMulTest_b_1 : dspba_delay
    GENERIC MAP ( width => 23, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fraction_uid12_fpComplexMulTest_b, xout => redist58_fraction_uid12_fpComplexMulTest_b_1_q, clk => clk, aclr => areset );

    -- minusY_uid15_fpComplexMulTest(BITJOIN,14)@3
    minusY_uid15_fpComplexMulTest_q <= redist59_excBits_uid11_fpComplexMulTest_b_1_q & invYSign_uid14_fpComplexMulTest_q & redist57_exp_uid13_fpComplexMulTest_b_1_q & redist58_fraction_uid12_fpComplexMulTest_b_1_q;

    -- sigY_uid414_rReal_uid16_fpComplexMulTest(BITSELECT,413)@3
    sigY_uid414_rReal_uid16_fpComplexMulTest_in <= STD_LOGIC_VECTOR(minusY_uid15_fpComplexMulTest_q(31 downto 0));
    sigY_uid414_rReal_uid16_fpComplexMulTest_b <= STD_LOGIC_VECTOR(sigY_uid414_rReal_uid16_fpComplexMulTest_in(31 downto 31));

    -- expY_uid416_rReal_uid16_fpComplexMulTest(BITSELECT,415)@3
    expY_uid416_rReal_uid16_fpComplexMulTest_in <= minusY_uid15_fpComplexMulTest_q(30 downto 0);
    expY_uid416_rReal_uid16_fpComplexMulTest_b <= expY_uid416_rReal_uid16_fpComplexMulTest_in(30 downto 23);

    -- fracY_uid415_rReal_uid16_fpComplexMulTest(BITSELECT,414)@3
    fracY_uid415_rReal_uid16_fpComplexMulTest_in <= minusY_uid15_fpComplexMulTest_q(22 downto 0);
    fracY_uid415_rReal_uid16_fpComplexMulTest_b <= fracY_uid415_rReal_uid16_fpComplexMulTest_in(22 downto 0);

    -- ypn_uid417_rReal_uid16_fpComplexMulTest(BITJOIN,416)@3
    ypn_uid417_rReal_uid16_fpComplexMulTest_q <= sigY_uid414_rReal_uid16_fpComplexMulTest_b & expY_uid416_rReal_uid16_fpComplexMulTest_b & fracY_uid415_rReal_uid16_fpComplexMulTest_b;

    -- excYZAndExcXI_uid100_ac_uid6_fpComplexMulTest(LOGICAL,99)@2
    excYZAndExcXI_uid100_ac_uid6_fpComplexMulTest_q <= excZ_y_uid43_ac_uid6_fpComplexMulTest_q and excI_x_uid33_ac_uid6_fpComplexMulTest_q;

    -- excXZAndExcYI_uid101_ac_uid6_fpComplexMulTest(LOGICAL,100)@2
    excXZAndExcYI_uid101_ac_uid6_fpComplexMulTest_q <= excZ_x_uid29_ac_uid6_fpComplexMulTest_q and excI_y_uid47_ac_uid6_fpComplexMulTest_q;

    -- ZeroTimesInf_uid102_ac_uid6_fpComplexMulTest(LOGICAL,101)@2
    ZeroTimesInf_uid102_ac_uid6_fpComplexMulTest_q <= excXZAndExcYI_uid101_ac_uid6_fpComplexMulTest_q or excYZAndExcXI_uid100_ac_uid6_fpComplexMulTest_q;

    -- excRNaN_uid103_ac_uid6_fpComplexMulTest(LOGICAL,102)@2
    excRNaN_uid103_ac_uid6_fpComplexMulTest_q <= excN_x_uid34_ac_uid6_fpComplexMulTest_q or excN_y_uid48_ac_uid6_fpComplexMulTest_q or ZeroTimesInf_uid102_ac_uid6_fpComplexMulTest_q;

    -- prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma(CHAINMULTADD,921)@0 + 2
    prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_reset <= areset;
    prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_ena0 <= '1';
    prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_ena1 <= prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_ena0;
    prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_p(0) <= prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_a0(0) * prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_c0(0);
    prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_u(0) <= RESIZE(prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_p(0),48);
    prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_w(0) <= prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_u(0);
    prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_x(0) <= prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_w(0);
    prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_y(0) <= prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_x(0);
    prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_chainmultadd_input: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_a0 <= (others => (others => '0'));
            prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_c0 <= (others => (others => '0'));
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_ena0 = '1') THEN
                prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_a0(0) <= RESIZE(UNSIGNED(ofracX_uid54_ac_uid6_fpComplexMulTest_q),24);
                prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_c0(0) <= RESIZE(UNSIGNED(ofracY_uid57_ac_uid6_fpComplexMulTest_q),24);
            END IF;
        END IF;
    END PROCESS;
    prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_chainmultadd_output: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_s <= (others => (others => '0'));
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_ena1 = '1') THEN
                prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_s(0) <= prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_y(0);
            END IF;
        END IF;
    END PROCESS;
    prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_delay : dspba_delay
    GENERIC MAP ( width => 48, depth => 0, reset_kind => "ASYNC" )
    PORT MAP ( xin => STD_LOGIC_VECTOR(prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_s(0)(47 downto 0)), xout => prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_qq, clk => clk, aclr => areset );
    prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_q <= STD_LOGIC_VECTOR(prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_qq(47 downto 0));

    -- normalizeBit_uid63_ac_uid6_fpComplexMulTest(BITSELECT,62)@2
    normalizeBit_uid63_ac_uid6_fpComplexMulTest_b <= STD_LOGIC_VECTOR(prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_q(47 downto 47));

    -- fracRPostNormHigh_uid65_ac_uid6_fpComplexMulTest(BITSELECT,64)@2
    fracRPostNormHigh_uid65_ac_uid6_fpComplexMulTest_in <= prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_q(46 downto 0);
    fracRPostNormHigh_uid65_ac_uid6_fpComplexMulTest_b <= fracRPostNormHigh_uid65_ac_uid6_fpComplexMulTest_in(46 downto 23);

    -- fracRPostNormLow_uid66_ac_uid6_fpComplexMulTest(BITSELECT,65)@2
    fracRPostNormLow_uid66_ac_uid6_fpComplexMulTest_in <= prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_q(45 downto 0);
    fracRPostNormLow_uid66_ac_uid6_fpComplexMulTest_b <= fracRPostNormLow_uid66_ac_uid6_fpComplexMulTest_in(45 downto 22);

    -- fracRPostNorm_uid67_ac_uid6_fpComplexMulTest(MUX,66)@2
    fracRPostNorm_uid67_ac_uid6_fpComplexMulTest_s <= normalizeBit_uid63_ac_uid6_fpComplexMulTest_b;
    fracRPostNorm_uid67_ac_uid6_fpComplexMulTest_combproc: PROCESS (fracRPostNorm_uid67_ac_uid6_fpComplexMulTest_s, fracRPostNormLow_uid66_ac_uid6_fpComplexMulTest_b, fracRPostNormHigh_uid65_ac_uid6_fpComplexMulTest_b)
    BEGIN
        CASE (fracRPostNorm_uid67_ac_uid6_fpComplexMulTest_s) IS
            WHEN "0" => fracRPostNorm_uid67_ac_uid6_fpComplexMulTest_q <= fracRPostNormLow_uid66_ac_uid6_fpComplexMulTest_b;
            WHEN "1" => fracRPostNorm_uid67_ac_uid6_fpComplexMulTest_q <= fracRPostNormHigh_uid65_ac_uid6_fpComplexMulTest_b;
            WHEN OTHERS => fracRPostNorm_uid67_ac_uid6_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- fracRPostNorm1dto0_uid75_ac_uid6_fpComplexMulTest(BITSELECT,74)@2
    fracRPostNorm1dto0_uid75_ac_uid6_fpComplexMulTest_in <= fracRPostNorm_uid67_ac_uid6_fpComplexMulTest_q(1 downto 0);
    fracRPostNorm1dto0_uid75_ac_uid6_fpComplexMulTest_b <= fracRPostNorm1dto0_uid75_ac_uid6_fpComplexMulTest_in(1 downto 0);

    -- extraStickyBitOfProd_uid69_ac_uid6_fpComplexMulTest(BITSELECT,68)@2
    extraStickyBitOfProd_uid69_ac_uid6_fpComplexMulTest_in <= STD_LOGIC_VECTOR(prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_q(22 downto 0));
    extraStickyBitOfProd_uid69_ac_uid6_fpComplexMulTest_b <= STD_LOGIC_VECTOR(extraStickyBitOfProd_uid69_ac_uid6_fpComplexMulTest_in(22 downto 22));

    -- extraStickyBit_uid70_ac_uid6_fpComplexMulTest(MUX,69)@2
    extraStickyBit_uid70_ac_uid6_fpComplexMulTest_s <= normalizeBit_uid63_ac_uid6_fpComplexMulTest_b;
    extraStickyBit_uid70_ac_uid6_fpComplexMulTest_combproc: PROCESS (extraStickyBit_uid70_ac_uid6_fpComplexMulTest_s, GND_q, extraStickyBitOfProd_uid69_ac_uid6_fpComplexMulTest_b)
    BEGIN
        CASE (extraStickyBit_uid70_ac_uid6_fpComplexMulTest_s) IS
            WHEN "0" => extraStickyBit_uid70_ac_uid6_fpComplexMulTest_q <= GND_q;
            WHEN "1" => extraStickyBit_uid70_ac_uid6_fpComplexMulTest_q <= extraStickyBitOfProd_uid69_ac_uid6_fpComplexMulTest_b;
            WHEN OTHERS => extraStickyBit_uid70_ac_uid6_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- stickyRange_uid68_ac_uid6_fpComplexMulTest(BITSELECT,67)@2
    stickyRange_uid68_ac_uid6_fpComplexMulTest_in <= prodXY_uid700_prod_uid61_ac_uid6_fpComplexMulTest_cma_q(21 downto 0);
    stickyRange_uid68_ac_uid6_fpComplexMulTest_b <= stickyRange_uid68_ac_uid6_fpComplexMulTest_in(21 downto 0);

    -- stickyExtendedRange_uid71_ac_uid6_fpComplexMulTest(BITJOIN,70)@2
    stickyExtendedRange_uid71_ac_uid6_fpComplexMulTest_q <= extraStickyBit_uid70_ac_uid6_fpComplexMulTest_q & stickyRange_uid68_ac_uid6_fpComplexMulTest_b;

    -- stickyRangeComparator_uid73_ac_uid6_fpComplexMulTest(LOGICAL,72)@2
    stickyRangeComparator_uid73_ac_uid6_fpComplexMulTest_q <= "1" WHEN stickyExtendedRange_uid71_ac_uid6_fpComplexMulTest_q = cstZeroWF_uid25_ac_uid6_fpComplexMulTest_q ELSE "0";

    -- sticky_uid74_ac_uid6_fpComplexMulTest(LOGICAL,73)@2
    sticky_uid74_ac_uid6_fpComplexMulTest_q <= not (stickyRangeComparator_uid73_ac_uid6_fpComplexMulTest_q);

    -- lrs_uid76_ac_uid6_fpComplexMulTest(BITJOIN,75)@2
    lrs_uid76_ac_uid6_fpComplexMulTest_q <= fracRPostNorm1dto0_uid75_ac_uid6_fpComplexMulTest_b & sticky_uid74_ac_uid6_fpComplexMulTest_q;

    -- roundBitDetectionPattern_uid78_ac_uid6_fpComplexMulTest(LOGICAL,77)@2
    roundBitDetectionPattern_uid78_ac_uid6_fpComplexMulTest_q <= "1" WHEN lrs_uid76_ac_uid6_fpComplexMulTest_q = roundBitDetectionConstant_uid77_ac_uid6_fpComplexMulTest_q ELSE "0";

    -- roundBit_uid79_ac_uid6_fpComplexMulTest(LOGICAL,78)@2
    roundBit_uid79_ac_uid6_fpComplexMulTest_q <= not (roundBitDetectionPattern_uid78_ac_uid6_fpComplexMulTest_q);

    -- roundBitAndNormalizationOp_uid82_ac_uid6_fpComplexMulTest(BITJOIN,81)@2
    roundBitAndNormalizationOp_uid82_ac_uid6_fpComplexMulTest_q <= GND_q & normalizeBit_uid63_ac_uid6_fpComplexMulTest_b & cstZeroWF_uid25_ac_uid6_fpComplexMulTest_q & roundBit_uid79_ac_uid6_fpComplexMulTest_q;

    -- expSum_uid58_ac_uid6_fpComplexMulTest(ADD,57)@2
    expSum_uid58_ac_uid6_fpComplexMulTest_a <= STD_LOGIC_VECTOR("0" & redist56_expX_uid20_ac_uid6_fpComplexMulTest_b_2_q);
    expSum_uid58_ac_uid6_fpComplexMulTest_b <= STD_LOGIC_VECTOR("0" & redist55_expY_uid21_ac_uid6_fpComplexMulTest_b_2_q);
    expSum_uid58_ac_uid6_fpComplexMulTest_o <= STD_LOGIC_VECTOR(UNSIGNED(expSum_uid58_ac_uid6_fpComplexMulTest_a) + UNSIGNED(expSum_uid58_ac_uid6_fpComplexMulTest_b));
    expSum_uid58_ac_uid6_fpComplexMulTest_q <= expSum_uid58_ac_uid6_fpComplexMulTest_o(8 downto 0);

    -- expSumMBias_uid60_ac_uid6_fpComplexMulTest(SUB,59)@2
    expSumMBias_uid60_ac_uid6_fpComplexMulTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("000" & expSum_uid58_ac_uid6_fpComplexMulTest_q));
    expSumMBias_uid60_ac_uid6_fpComplexMulTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((11 downto 10 => biasInc_uid59_ac_uid6_fpComplexMulTest_q(9)) & biasInc_uid59_ac_uid6_fpComplexMulTest_q));
    expSumMBias_uid60_ac_uid6_fpComplexMulTest_o <= STD_LOGIC_VECTOR(SIGNED(expSumMBias_uid60_ac_uid6_fpComplexMulTest_a) - SIGNED(expSumMBias_uid60_ac_uid6_fpComplexMulTest_b));
    expSumMBias_uid60_ac_uid6_fpComplexMulTest_q <= expSumMBias_uid60_ac_uid6_fpComplexMulTest_o(10 downto 0);

    -- expFracPreRound_uid80_ac_uid6_fpComplexMulTest(BITJOIN,79)@2
    expFracPreRound_uid80_ac_uid6_fpComplexMulTest_q <= expSumMBias_uid60_ac_uid6_fpComplexMulTest_q & fracRPostNorm_uid67_ac_uid6_fpComplexMulTest_q;

    -- expFracRPostRounding_uid83_ac_uid6_fpComplexMulTest(ADD,82)@2
    expFracRPostRounding_uid83_ac_uid6_fpComplexMulTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((36 downto 35 => expFracPreRound_uid80_ac_uid6_fpComplexMulTest_q(34)) & expFracPreRound_uid80_ac_uid6_fpComplexMulTest_q));
    expFracRPostRounding_uid83_ac_uid6_fpComplexMulTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("00000000000" & roundBitAndNormalizationOp_uid82_ac_uid6_fpComplexMulTest_q));
    expFracRPostRounding_uid83_ac_uid6_fpComplexMulTest_o <= STD_LOGIC_VECTOR(SIGNED(expFracRPostRounding_uid83_ac_uid6_fpComplexMulTest_a) + SIGNED(expFracRPostRounding_uid83_ac_uid6_fpComplexMulTest_b));
    expFracRPostRounding_uid83_ac_uid6_fpComplexMulTest_q <= expFracRPostRounding_uid83_ac_uid6_fpComplexMulTest_o(35 downto 0);

    -- expRPreExcExt_uid85_ac_uid6_fpComplexMulTest(BITSELECT,84)@2
    expRPreExcExt_uid85_ac_uid6_fpComplexMulTest_b <= STD_LOGIC_VECTOR(expFracRPostRounding_uid83_ac_uid6_fpComplexMulTest_q(35 downto 24));

    -- expOvf_uid89_ac_uid6_fpComplexMulTest(COMPARE,88)@2
    expOvf_uid89_ac_uid6_fpComplexMulTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("000000" & cstAllOWE_uid24_ac_uid6_fpComplexMulTest_q));
    expOvf_uid89_ac_uid6_fpComplexMulTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((13 downto 12 => expRPreExcExt_uid85_ac_uid6_fpComplexMulTest_b(11)) & expRPreExcExt_uid85_ac_uid6_fpComplexMulTest_b));
    expOvf_uid89_ac_uid6_fpComplexMulTest_o <= STD_LOGIC_VECTOR(SIGNED(expOvf_uid89_ac_uid6_fpComplexMulTest_a) - SIGNED(expOvf_uid89_ac_uid6_fpComplexMulTest_b));
    expOvf_uid89_ac_uid6_fpComplexMulTest_c(0) <= expOvf_uid89_ac_uid6_fpComplexMulTest_o(13);

    -- ExcROvfAndInReg_uid98_ac_uid6_fpComplexMulTest(LOGICAL,97)@2
    ExcROvfAndInReg_uid98_ac_uid6_fpComplexMulTest_q <= excR_x_uid37_ac_uid6_fpComplexMulTest_q and excR_y_uid51_ac_uid6_fpComplexMulTest_q and expOvf_uid89_ac_uid6_fpComplexMulTest_c;

    -- excYRAndExcXI_uid97_ac_uid6_fpComplexMulTest(LOGICAL,96)@2
    excYRAndExcXI_uid97_ac_uid6_fpComplexMulTest_q <= excR_y_uid51_ac_uid6_fpComplexMulTest_q and excI_x_uid33_ac_uid6_fpComplexMulTest_q;

    -- excXRAndExcYI_uid96_ac_uid6_fpComplexMulTest(LOGICAL,95)@2
    excXRAndExcYI_uid96_ac_uid6_fpComplexMulTest_q <= excR_x_uid37_ac_uid6_fpComplexMulTest_q and excI_y_uid47_ac_uid6_fpComplexMulTest_q;

    -- excXIAndExcYI_uid95_ac_uid6_fpComplexMulTest(LOGICAL,94)@2
    excXIAndExcYI_uid95_ac_uid6_fpComplexMulTest_q <= excI_x_uid33_ac_uid6_fpComplexMulTest_q and excI_y_uid47_ac_uid6_fpComplexMulTest_q;

    -- excRInf_uid99_ac_uid6_fpComplexMulTest(LOGICAL,98)@2
    excRInf_uid99_ac_uid6_fpComplexMulTest_q <= excXIAndExcYI_uid95_ac_uid6_fpComplexMulTest_q or excXRAndExcYI_uid96_ac_uid6_fpComplexMulTest_q or excYRAndExcXI_uid97_ac_uid6_fpComplexMulTest_q or ExcROvfAndInReg_uid98_ac_uid6_fpComplexMulTest_q;

    -- expUdf_uid87_ac_uid6_fpComplexMulTest_cmp_sign(LOGICAL,773)@2
    expUdf_uid87_ac_uid6_fpComplexMulTest_cmp_sign_q <= STD_LOGIC_VECTOR(expRPreExcExt_uid85_ac_uid6_fpComplexMulTest_b(11 downto 11));

    -- excZC3_uid93_ac_uid6_fpComplexMulTest(LOGICAL,92)@2
    excZC3_uid93_ac_uid6_fpComplexMulTest_q <= excR_x_uid37_ac_uid6_fpComplexMulTest_q and excR_y_uid51_ac_uid6_fpComplexMulTest_q and expUdf_uid87_ac_uid6_fpComplexMulTest_cmp_sign_q;

    -- excYZAndExcXR_uid92_ac_uid6_fpComplexMulTest(LOGICAL,91)@2
    excYZAndExcXR_uid92_ac_uid6_fpComplexMulTest_q <= excZ_y_uid43_ac_uid6_fpComplexMulTest_q and excR_x_uid37_ac_uid6_fpComplexMulTest_q;

    -- excXZAndExcYR_uid91_ac_uid6_fpComplexMulTest(LOGICAL,90)@2
    excXZAndExcYR_uid91_ac_uid6_fpComplexMulTest_q <= excZ_x_uid29_ac_uid6_fpComplexMulTest_q and excR_y_uid51_ac_uid6_fpComplexMulTest_q;

    -- excXZAndExcYZ_uid90_ac_uid6_fpComplexMulTest(LOGICAL,89)@2
    excXZAndExcYZ_uid90_ac_uid6_fpComplexMulTest_q <= excZ_x_uid29_ac_uid6_fpComplexMulTest_q and excZ_y_uid43_ac_uid6_fpComplexMulTest_q;

    -- excRZero_uid94_ac_uid6_fpComplexMulTest(LOGICAL,93)@2
    excRZero_uid94_ac_uid6_fpComplexMulTest_q <= excXZAndExcYZ_uid90_ac_uid6_fpComplexMulTest_q or excXZAndExcYR_uid91_ac_uid6_fpComplexMulTest_q or excYZAndExcXR_uid92_ac_uid6_fpComplexMulTest_q or excZC3_uid93_ac_uid6_fpComplexMulTest_q;

    -- concExc_uid104_ac_uid6_fpComplexMulTest(BITJOIN,103)@2
    concExc_uid104_ac_uid6_fpComplexMulTest_q <= excRNaN_uid103_ac_uid6_fpComplexMulTest_q & excRInf_uid99_ac_uid6_fpComplexMulTest_q & excRZero_uid94_ac_uid6_fpComplexMulTest_q;

    -- excREnc_uid105_ac_uid6_fpComplexMulTest(LOOKUP,104)@2 + 1
    excREnc_uid105_ac_uid6_fpComplexMulTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            excREnc_uid105_ac_uid6_fpComplexMulTest_q <= "01";
        ELSIF (clk'EVENT AND clk = '1') THEN
            CASE (concExc_uid104_ac_uid6_fpComplexMulTest_q) IS
                WHEN "000" => excREnc_uid105_ac_uid6_fpComplexMulTest_q <= "01";
                WHEN "001" => excREnc_uid105_ac_uid6_fpComplexMulTest_q <= "00";
                WHEN "010" => excREnc_uid105_ac_uid6_fpComplexMulTest_q <= "10";
                WHEN "011" => excREnc_uid105_ac_uid6_fpComplexMulTest_q <= "00";
                WHEN "100" => excREnc_uid105_ac_uid6_fpComplexMulTest_q <= "11";
                WHEN "101" => excREnc_uid105_ac_uid6_fpComplexMulTest_q <= "00";
                WHEN "110" => excREnc_uid105_ac_uid6_fpComplexMulTest_q <= "00";
                WHEN "111" => excREnc_uid105_ac_uid6_fpComplexMulTest_q <= "00";
                WHEN OTHERS => -- unreachable
                               excREnc_uid105_ac_uid6_fpComplexMulTest_q <= (others => '-');
            END CASE;
        END IF;
    END PROCESS;

    -- invExcRNaN_uid106_ac_uid6_fpComplexMulTest(LOGICAL,105)@2
    invExcRNaN_uid106_ac_uid6_fpComplexMulTest_q <= not (excRNaN_uid103_ac_uid6_fpComplexMulTest_q);

    -- signR_uid62_ac_uid6_fpComplexMulTest(LOGICAL,61)@2
    signR_uid62_ac_uid6_fpComplexMulTest_q <= redist54_signX_uid22_ac_uid6_fpComplexMulTest_b_2_q xor redist53_signY_uid23_ac_uid6_fpComplexMulTest_b_2_q;

    -- signRPostExc_uid107_ac_uid6_fpComplexMulTest(LOGICAL,106)@2 + 1
    signRPostExc_uid107_ac_uid6_fpComplexMulTest_qi <= signR_uid62_ac_uid6_fpComplexMulTest_q and invExcRNaN_uid106_ac_uid6_fpComplexMulTest_q;
    signRPostExc_uid107_ac_uid6_fpComplexMulTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => signRPostExc_uid107_ac_uid6_fpComplexMulTest_qi, xout => signRPostExc_uid107_ac_uid6_fpComplexMulTest_q, clk => clk, aclr => areset );

    -- expRPreExc_uid86_ac_uid6_fpComplexMulTest(BITSELECT,85)@2
    expRPreExc_uid86_ac_uid6_fpComplexMulTest_in <= expRPreExcExt_uid85_ac_uid6_fpComplexMulTest_b(7 downto 0);
    expRPreExc_uid86_ac_uid6_fpComplexMulTest_b <= expRPreExc_uid86_ac_uid6_fpComplexMulTest_in(7 downto 0);

    -- redist49_expRPreExc_uid86_ac_uid6_fpComplexMulTest_b_1(DELAY,986)
    redist49_expRPreExc_uid86_ac_uid6_fpComplexMulTest_b_1 : dspba_delay
    GENERIC MAP ( width => 8, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => expRPreExc_uid86_ac_uid6_fpComplexMulTest_b, xout => redist49_expRPreExc_uid86_ac_uid6_fpComplexMulTest_b_1_q, clk => clk, aclr => areset );

    -- fracRPreExc_uid84_ac_uid6_fpComplexMulTest(BITSELECT,83)@2
    fracRPreExc_uid84_ac_uid6_fpComplexMulTest_in <= expFracRPostRounding_uid83_ac_uid6_fpComplexMulTest_q(23 downto 0);
    fracRPreExc_uid84_ac_uid6_fpComplexMulTest_b <= fracRPreExc_uid84_ac_uid6_fpComplexMulTest_in(23 downto 1);

    -- redist50_fracRPreExc_uid84_ac_uid6_fpComplexMulTest_b_1(DELAY,987)
    redist50_fracRPreExc_uid84_ac_uid6_fpComplexMulTest_b_1 : dspba_delay
    GENERIC MAP ( width => 23, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracRPreExc_uid84_ac_uid6_fpComplexMulTest_b, xout => redist50_fracRPreExc_uid84_ac_uid6_fpComplexMulTest_b_1_q, clk => clk, aclr => areset );

    -- R_uid108_ac_uid6_fpComplexMulTest(BITJOIN,107)@3
    R_uid108_ac_uid6_fpComplexMulTest_q <= excREnc_uid105_ac_uid6_fpComplexMulTest_q & signRPostExc_uid107_ac_uid6_fpComplexMulTest_q & redist49_expRPreExc_uid86_ac_uid6_fpComplexMulTest_b_1_q & redist50_fracRPreExc_uid84_ac_uid6_fpComplexMulTest_b_1_q;

    -- xMuxRange_uid419_rReal_uid16_fpComplexMulTest(BITSELECT,418)@3
    xMuxRange_uid419_rReal_uid16_fpComplexMulTest_in <= R_uid108_ac_uid6_fpComplexMulTest_q(31 downto 0);
    xMuxRange_uid419_rReal_uid16_fpComplexMulTest_b <= xMuxRange_uid419_rReal_uid16_fpComplexMulTest_in(31 downto 0);

    -- expFracY_uid409_rReal_uid16_fpComplexMulTest(BITSELECT,408)@3
    expFracY_uid409_rReal_uid16_fpComplexMulTest_in <= minusY_uid15_fpComplexMulTest_q(30 downto 0);
    expFracY_uid409_rReal_uid16_fpComplexMulTest_b <= expFracY_uid409_rReal_uid16_fpComplexMulTest_in(30 downto 0);

    -- expFracX_uid408_rReal_uid16_fpComplexMulTest(BITSELECT,407)@3
    expFracX_uid408_rReal_uid16_fpComplexMulTest_b <= R_uid108_ac_uid6_fpComplexMulTest_q(30 downto 0);

    -- xGTEy_uid410_rReal_uid16_fpComplexMulTest(COMPARE,409)@3
    xGTEy_uid410_rReal_uid16_fpComplexMulTest_a <= STD_LOGIC_VECTOR("00" & expFracX_uid408_rReal_uid16_fpComplexMulTest_b);
    xGTEy_uid410_rReal_uid16_fpComplexMulTest_b <= STD_LOGIC_VECTOR("00" & expFracY_uid409_rReal_uid16_fpComplexMulTest_b);
    xGTEy_uid410_rReal_uid16_fpComplexMulTest_o <= STD_LOGIC_VECTOR(UNSIGNED(xGTEy_uid410_rReal_uid16_fpComplexMulTest_a) - UNSIGNED(xGTEy_uid410_rReal_uid16_fpComplexMulTest_b));
    xGTEy_uid410_rReal_uid16_fpComplexMulTest_n(0) <= not (xGTEy_uid410_rReal_uid16_fpComplexMulTest_o(32));

    -- excX_uid399_rReal_uid16_fpComplexMulTest(BITSELECT,398)@3
    excX_uid399_rReal_uid16_fpComplexMulTest_b <= minusY_uid15_fpComplexMulTest_q(33 downto 32);

    -- excXZero_uid404_rReal_uid16_fpComplexMulTest(LOGICAL,403)@3
    excXZero_uid404_rReal_uid16_fpComplexMulTest_q <= "1" WHEN excX_uid399_rReal_uid16_fpComplexMulTest_b = zero2b_uid386_rReal_uid16_fpComplexMulTest_q ELSE "0";

    -- xGTEyOrYz_uid411_rReal_uid16_fpComplexMulTest(LOGICAL,410)@3
    xGTEyOrYz_uid411_rReal_uid16_fpComplexMulTest_q <= excXZero_uid404_rReal_uid16_fpComplexMulTest_q or xGTEy_uid410_rReal_uid16_fpComplexMulTest_n;

    -- excX_uid385_rReal_uid16_fpComplexMulTest(BITSELECT,384)@3
    excX_uid385_rReal_uid16_fpComplexMulTest_b <= R_uid108_ac_uid6_fpComplexMulTest_q(33 downto 32);

    -- excXZero_uid390_rReal_uid16_fpComplexMulTest(LOGICAL,389)@3
    excXZero_uid390_rReal_uid16_fpComplexMulTest_q <= "1" WHEN excX_uid385_rReal_uid16_fpComplexMulTest_b = zero2b_uid386_rReal_uid16_fpComplexMulTest_q ELSE "0";

    -- invExcXZ_uid412_rReal_uid16_fpComplexMulTest(LOGICAL,411)@3
    invExcXZ_uid412_rReal_uid16_fpComplexMulTest_q <= not (excXZero_uid390_rReal_uid16_fpComplexMulTest_q);

    -- xGTEy_uid413_rReal_uid16_fpComplexMulTest(LOGICAL,412)@3
    xGTEy_uid413_rReal_uid16_fpComplexMulTest_q <= invExcXZ_uid412_rReal_uid16_fpComplexMulTest_q and xGTEyOrYz_uid411_rReal_uid16_fpComplexMulTest_q;

    -- bSig_uid422_rReal_uid16_fpComplexMulTest(MUX,421)@3
    bSig_uid422_rReal_uid16_fpComplexMulTest_s <= xGTEy_uid413_rReal_uid16_fpComplexMulTest_q;
    bSig_uid422_rReal_uid16_fpComplexMulTest_combproc: PROCESS (bSig_uid422_rReal_uid16_fpComplexMulTest_s, xMuxRange_uid419_rReal_uid16_fpComplexMulTest_b, ypn_uid417_rReal_uid16_fpComplexMulTest_q)
    BEGIN
        CASE (bSig_uid422_rReal_uid16_fpComplexMulTest_s) IS
            WHEN "0" => bSig_uid422_rReal_uid16_fpComplexMulTest_q <= xMuxRange_uid419_rReal_uid16_fpComplexMulTest_b;
            WHEN "1" => bSig_uid422_rReal_uid16_fpComplexMulTest_q <= ypn_uid417_rReal_uid16_fpComplexMulTest_q;
            WHEN OTHERS => bSig_uid422_rReal_uid16_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- sigB_uid436_rReal_uid16_fpComplexMulTest(BITSELECT,435)@3
    sigB_uid436_rReal_uid16_fpComplexMulTest_b <= STD_LOGIC_VECTOR(bSig_uid422_rReal_uid16_fpComplexMulTest_q(31 downto 31));

    -- redist20_sigB_uid436_rReal_uid16_fpComplexMulTest_b_1(DELAY,957)
    redist20_sigB_uid436_rReal_uid16_fpComplexMulTest_b_1 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => sigB_uid436_rReal_uid16_fpComplexMulTest_b, xout => redist20_sigB_uid436_rReal_uid16_fpComplexMulTest_b_1_q, clk => clk, aclr => areset );

    -- aSig_uid421_rReal_uid16_fpComplexMulTest(MUX,420)@3
    aSig_uid421_rReal_uid16_fpComplexMulTest_s <= xGTEy_uid413_rReal_uid16_fpComplexMulTest_q;
    aSig_uid421_rReal_uid16_fpComplexMulTest_combproc: PROCESS (aSig_uid421_rReal_uid16_fpComplexMulTest_s, ypn_uid417_rReal_uid16_fpComplexMulTest_q, xMuxRange_uid419_rReal_uid16_fpComplexMulTest_b)
    BEGIN
        CASE (aSig_uid421_rReal_uid16_fpComplexMulTest_s) IS
            WHEN "0" => aSig_uid421_rReal_uid16_fpComplexMulTest_q <= ypn_uid417_rReal_uid16_fpComplexMulTest_q;
            WHEN "1" => aSig_uid421_rReal_uid16_fpComplexMulTest_q <= xMuxRange_uid419_rReal_uid16_fpComplexMulTest_b;
            WHEN OTHERS => aSig_uid421_rReal_uid16_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- sigA_uid435_rReal_uid16_fpComplexMulTest(BITSELECT,434)@3
    sigA_uid435_rReal_uid16_fpComplexMulTest_b <= STD_LOGIC_VECTOR(aSig_uid421_rReal_uid16_fpComplexMulTest_q(31 downto 31));

    -- redist22_sigA_uid435_rReal_uid16_fpComplexMulTest_b_1(DELAY,959)
    redist22_sigA_uid435_rReal_uid16_fpComplexMulTest_b_1 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => sigA_uid435_rReal_uid16_fpComplexMulTest_b, xout => redist22_sigA_uid435_rReal_uid16_fpComplexMulTest_b_1_q, clk => clk, aclr => areset );

    -- effSub_uid437_rReal_uid16_fpComplexMulTest(LOGICAL,436)@4
    effSub_uid437_rReal_uid16_fpComplexMulTest_q <= redist22_sigA_uid435_rReal_uid16_fpComplexMulTest_b_1_q xor redist20_sigB_uid436_rReal_uid16_fpComplexMulTest_b_1_q;

    -- excBZ_uid430_rReal_uid16_fpComplexMulTest(MUX,429)@3
    excBZ_uid430_rReal_uid16_fpComplexMulTest_s <= xGTEy_uid413_rReal_uid16_fpComplexMulTest_q;
    excBZ_uid430_rReal_uid16_fpComplexMulTest_combproc: PROCESS (excBZ_uid430_rReal_uid16_fpComplexMulTest_s, excXZero_uid390_rReal_uid16_fpComplexMulTest_q, excXZero_uid404_rReal_uid16_fpComplexMulTest_q)
    BEGIN
        CASE (excBZ_uid430_rReal_uid16_fpComplexMulTest_s) IS
            WHEN "0" => excBZ_uid430_rReal_uid16_fpComplexMulTest_q <= excXZero_uid390_rReal_uid16_fpComplexMulTest_q;
            WHEN "1" => excBZ_uid430_rReal_uid16_fpComplexMulTest_q <= excXZero_uid404_rReal_uid16_fpComplexMulTest_q;
            WHEN OTHERS => excBZ_uid430_rReal_uid16_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- expB_uid432_rReal_uid16_fpComplexMulTest(BITSELECT,431)@3
    expB_uid432_rReal_uid16_fpComplexMulTest_in <= bSig_uid422_rReal_uid16_fpComplexMulTest_q(30 downto 0);
    expB_uid432_rReal_uid16_fpComplexMulTest_b <= expB_uid432_rReal_uid16_fpComplexMulTest_in(30 downto 23);

    -- expA_uid431_rReal_uid16_fpComplexMulTest(BITSELECT,430)@3
    expA_uid431_rReal_uid16_fpComplexMulTest_in <= aSig_uid421_rReal_uid16_fpComplexMulTest_q(30 downto 0);
    expA_uid431_rReal_uid16_fpComplexMulTest_b <= expA_uid431_rReal_uid16_fpComplexMulTest_in(30 downto 23);

    -- expAmExpB_uid447_rReal_uid16_fpComplexMulTest(SUB,446)@3 + 1
    expAmExpB_uid447_rReal_uid16_fpComplexMulTest_a <= STD_LOGIC_VECTOR("0" & expA_uid431_rReal_uid16_fpComplexMulTest_b);
    expAmExpB_uid447_rReal_uid16_fpComplexMulTest_b <= STD_LOGIC_VECTOR("0" & expB_uid432_rReal_uid16_fpComplexMulTest_b);
    expAmExpB_uid447_rReal_uid16_fpComplexMulTest_i <= expAmExpB_uid447_rReal_uid16_fpComplexMulTest_a;
    expAmExpB_uid447_rReal_uid16_fpComplexMulTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            expAmExpB_uid447_rReal_uid16_fpComplexMulTest_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (excBZ_uid430_rReal_uid16_fpComplexMulTest_q = "1") THEN
                expAmExpB_uid447_rReal_uid16_fpComplexMulTest_o <= expAmExpB_uid447_rReal_uid16_fpComplexMulTest_i;
            ELSE
                expAmExpB_uid447_rReal_uid16_fpComplexMulTest_o <= STD_LOGIC_VECTOR(UNSIGNED(expAmExpB_uid447_rReal_uid16_fpComplexMulTest_a) - UNSIGNED(expAmExpB_uid447_rReal_uid16_fpComplexMulTest_b));
            END IF;
        END IF;
    END PROCESS;
    expAmExpB_uid447_rReal_uid16_fpComplexMulTest_q <= expAmExpB_uid447_rReal_uid16_fpComplexMulTest_o(8 downto 0);

    -- shiftedOut_uid450_rReal_uid16_fpComplexMulTest(COMPARE,449)@4
    shiftedOut_uid450_rReal_uid16_fpComplexMulTest_a <= STD_LOGIC_VECTOR("000000" & cWFP2_uid448_rReal_uid16_fpComplexMulTest_q);
    shiftedOut_uid450_rReal_uid16_fpComplexMulTest_b <= STD_LOGIC_VECTOR("00" & expAmExpB_uid447_rReal_uid16_fpComplexMulTest_q);
    shiftedOut_uid450_rReal_uid16_fpComplexMulTest_o <= STD_LOGIC_VECTOR(UNSIGNED(shiftedOut_uid450_rReal_uid16_fpComplexMulTest_a) - UNSIGNED(shiftedOut_uid450_rReal_uid16_fpComplexMulTest_b));
    shiftedOut_uid450_rReal_uid16_fpComplexMulTest_c(0) <= shiftedOut_uid450_rReal_uid16_fpComplexMulTest_o(10);

    -- iShiftedOut_uid454_rReal_uid16_fpComplexMulTest(LOGICAL,453)@4
    iShiftedOut_uid454_rReal_uid16_fpComplexMulTest_q <= not (shiftedOut_uid450_rReal_uid16_fpComplexMulTest_c);

    -- rightShiftStage2Idx3Rng3_uid814_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest(BITSELECT,813)@4
    rightShiftStage2Idx3Rng3_uid814_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_b <= rightShiftStage1_uid807_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q(48 downto 3);

    -- rightShiftStage2Idx3_uid816_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest(BITJOIN,815)@4
    rightShiftStage2Idx3_uid816_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q <= rightShiftStage2Idx3Pad3_uid815_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q & rightShiftStage2Idx3Rng3_uid814_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_b;

    -- rightShiftStage2Idx2Rng2_uid811_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest(BITSELECT,810)@4
    rightShiftStage2Idx2Rng2_uid811_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_b <= rightShiftStage1_uid807_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q(48 downto 2);

    -- rightShiftStage2Idx2_uid813_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest(BITJOIN,812)@4
    rightShiftStage2Idx2_uid813_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q <= zero2b_uid386_rReal_uid16_fpComplexMulTest_q & rightShiftStage2Idx2Rng2_uid811_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_b;

    -- rightShiftStage2Idx1Rng1_uid808_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest(BITSELECT,807)@4
    rightShiftStage2Idx1Rng1_uid808_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_b <= rightShiftStage1_uid807_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q(48 downto 1);

    -- rightShiftStage2Idx1_uid810_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest(BITJOIN,809)@4
    rightShiftStage2Idx1_uid810_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q <= GND_q & rightShiftStage2Idx1Rng1_uid808_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_b;

    -- rightShiftStage1Idx3Rng12_uid803_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest(BITSELECT,802)@4
    rightShiftStage1Idx3Rng12_uid803_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_b <= rightShiftStage0_uid796_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q(48 downto 12);

    -- rightShiftStage1Idx3_uid805_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest(BITJOIN,804)@4
    rightShiftStage1Idx3_uid805_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q <= rightShiftStage1Idx3Pad12_uid804_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q & rightShiftStage1Idx3Rng12_uid803_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_b;

    -- rightShiftStage1Idx2Rng8_uid800_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest(BITSELECT,799)@4
    rightShiftStage1Idx2Rng8_uid800_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_b <= rightShiftStage0_uid796_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q(48 downto 8);

    -- rightShiftStage1Idx2_uid802_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest(BITJOIN,801)@4
    rightShiftStage1Idx2_uid802_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q <= cstAllZWE_uid26_ac_uid6_fpComplexMulTest_q & rightShiftStage1Idx2Rng8_uid800_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_b;

    -- rightShiftStage1Idx1Rng4_uid797_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest(BITSELECT,796)@4
    rightShiftStage1Idx1Rng4_uid797_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_b <= rightShiftStage0_uid796_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q(48 downto 4);

    -- rightShiftStage1Idx1_uid799_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest(BITJOIN,798)@4
    rightShiftStage1Idx1_uid799_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q <= zs_uid726_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q & rightShiftStage1Idx1Rng4_uid797_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_b;

    -- rightShiftStage0Idx3Rng48_uid792_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest(BITSELECT,791)@4
    rightShiftStage0Idx3Rng48_uid792_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_b <= rightPaddedIn_uid452_rReal_uid16_fpComplexMulTest_q(48 downto 48);

    -- rightShiftStage0Idx3_uid794_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest(BITJOIN,793)@4
    rightShiftStage0Idx3_uid794_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q <= rightShiftStage0Idx3Pad48_uid793_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q & rightShiftStage0Idx3Rng48_uid792_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_b;

    -- rightShiftStage0Idx2Rng32_uid789_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest(BITSELECT,788)@4
    rightShiftStage0Idx2Rng32_uid789_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_b <= rightPaddedIn_uid452_rReal_uid16_fpComplexMulTest_q(48 downto 32);

    -- rightShiftStage0Idx2_uid791_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest(BITJOIN,790)@4
    rightShiftStage0Idx2_uid791_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q <= rightShiftStage0Idx2Pad32_uid790_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q & rightShiftStage0Idx2Rng32_uid789_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_b;

    -- rightShiftStage0Idx1Rng16_uid786_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest(BITSELECT,785)@4
    rightShiftStage0Idx1Rng16_uid786_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_b <= rightPaddedIn_uid452_rReal_uid16_fpComplexMulTest_q(48 downto 16);

    -- rightShiftStage0Idx1_uid788_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest(BITJOIN,787)@4
    rightShiftStage0Idx1_uid788_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q <= zs_uid712_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q & rightShiftStage0Idx1Rng16_uid786_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_b;

    -- redist27_excBZ_uid430_rReal_uid16_fpComplexMulTest_q_1(DELAY,964)
    redist27_excBZ_uid430_rReal_uid16_fpComplexMulTest_q_1 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => excBZ_uid430_rReal_uid16_fpComplexMulTest_q, xout => redist27_excBZ_uid430_rReal_uid16_fpComplexMulTest_q_1_q, clk => clk, aclr => areset );

    -- invExcBZ_uid445_rReal_uid16_fpComplexMulTest(LOGICAL,444)@4
    invExcBZ_uid445_rReal_uid16_fpComplexMulTest_q <= not (redist27_excBZ_uid430_rReal_uid16_fpComplexMulTest_q_1_q);

    -- fracB_uid434_rReal_uid16_fpComplexMulTest(BITSELECT,433)@3
    fracB_uid434_rReal_uid16_fpComplexMulTest_in <= bSig_uid422_rReal_uid16_fpComplexMulTest_q(22 downto 0);
    fracB_uid434_rReal_uid16_fpComplexMulTest_b <= fracB_uid434_rReal_uid16_fpComplexMulTest_in(22 downto 0);

    -- redist24_fracB_uid434_rReal_uid16_fpComplexMulTest_b_1(DELAY,961)
    redist24_fracB_uid434_rReal_uid16_fpComplexMulTest_b_1 : dspba_delay
    GENERIC MAP ( width => 23, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracB_uid434_rReal_uid16_fpComplexMulTest_b, xout => redist24_fracB_uid434_rReal_uid16_fpComplexMulTest_b_1_q, clk => clk, aclr => areset );

    -- fracBz_uid443_rReal_uid16_fpComplexMulTest(MUX,442)@4
    fracBz_uid443_rReal_uid16_fpComplexMulTest_s <= redist27_excBZ_uid430_rReal_uid16_fpComplexMulTest_q_1_q;
    fracBz_uid443_rReal_uid16_fpComplexMulTest_combproc: PROCESS (fracBz_uid443_rReal_uid16_fpComplexMulTest_s, redist24_fracB_uid434_rReal_uid16_fpComplexMulTest_b_1_q, cstZeroWF_uid25_ac_uid6_fpComplexMulTest_q)
    BEGIN
        CASE (fracBz_uid443_rReal_uid16_fpComplexMulTest_s) IS
            WHEN "0" => fracBz_uid443_rReal_uid16_fpComplexMulTest_q <= redist24_fracB_uid434_rReal_uid16_fpComplexMulTest_b_1_q;
            WHEN "1" => fracBz_uid443_rReal_uid16_fpComplexMulTest_q <= cstZeroWF_uid25_ac_uid6_fpComplexMulTest_q;
            WHEN OTHERS => fracBz_uid443_rReal_uid16_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- oFracB_uid446_rReal_uid16_fpComplexMulTest(BITJOIN,445)@4
    oFracB_uid446_rReal_uid16_fpComplexMulTest_q <= invExcBZ_uid445_rReal_uid16_fpComplexMulTest_q & fracBz_uid443_rReal_uid16_fpComplexMulTest_q;

    -- rightPaddedIn_uid452_rReal_uid16_fpComplexMulTest(BITJOIN,451)@4
    rightPaddedIn_uid452_rReal_uid16_fpComplexMulTest_q <= oFracB_uid446_rReal_uid16_fpComplexMulTest_q & padConst_uid451_rReal_uid16_fpComplexMulTest_q;

    -- rightShiftStage0_uid796_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest(MUX,795)@4
    rightShiftStage0_uid796_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_s <= rightShiftStageSel5Dto4_uid795_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_merged_bit_select_b;
    rightShiftStage0_uid796_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_combproc: PROCESS (rightShiftStage0_uid796_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_s, rightPaddedIn_uid452_rReal_uid16_fpComplexMulTest_q, rightShiftStage0Idx1_uid788_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q, rightShiftStage0Idx2_uid791_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q, rightShiftStage0Idx3_uid794_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q)
    BEGIN
        CASE (rightShiftStage0_uid796_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_s) IS
            WHEN "00" => rightShiftStage0_uid796_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q <= rightPaddedIn_uid452_rReal_uid16_fpComplexMulTest_q;
            WHEN "01" => rightShiftStage0_uid796_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q <= rightShiftStage0Idx1_uid788_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q;
            WHEN "10" => rightShiftStage0_uid796_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q <= rightShiftStage0Idx2_uid791_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q;
            WHEN "11" => rightShiftStage0_uid796_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q <= rightShiftStage0Idx3_uid794_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q;
            WHEN OTHERS => rightShiftStage0_uid796_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- rightShiftStage1_uid807_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest(MUX,806)@4
    rightShiftStage1_uid807_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_s <= rightShiftStageSel5Dto4_uid795_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_merged_bit_select_c;
    rightShiftStage1_uid807_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_combproc: PROCESS (rightShiftStage1_uid807_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_s, rightShiftStage0_uid796_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q, rightShiftStage1Idx1_uid799_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q, rightShiftStage1Idx2_uid802_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q, rightShiftStage1Idx3_uid805_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q)
    BEGIN
        CASE (rightShiftStage1_uid807_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_s) IS
            WHEN "00" => rightShiftStage1_uid807_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q <= rightShiftStage0_uid796_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q;
            WHEN "01" => rightShiftStage1_uid807_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q <= rightShiftStage1Idx1_uid799_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q;
            WHEN "10" => rightShiftStage1_uid807_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q <= rightShiftStage1Idx2_uid802_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q;
            WHEN "11" => rightShiftStage1_uid807_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q <= rightShiftStage1Idx3_uid805_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q;
            WHEN OTHERS => rightShiftStage1_uid807_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- rightShiftStageSel5Dto4_uid795_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_merged_bit_select(BITSELECT,925)@4
    rightShiftStageSel5Dto4_uid795_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_merged_bit_select_in <= expAmExpB_uid447_rReal_uid16_fpComplexMulTest_q(5 downto 0);
    rightShiftStageSel5Dto4_uid795_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_merged_bit_select_b <= rightShiftStageSel5Dto4_uid795_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_merged_bit_select_in(5 downto 4);
    rightShiftStageSel5Dto4_uid795_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_merged_bit_select_c <= rightShiftStageSel5Dto4_uid795_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_merged_bit_select_in(3 downto 2);
    rightShiftStageSel5Dto4_uid795_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_merged_bit_select_d <= rightShiftStageSel5Dto4_uid795_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_merged_bit_select_in(1 downto 0);

    -- rightShiftStage2_uid818_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest(MUX,817)@4
    rightShiftStage2_uid818_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_s <= rightShiftStageSel5Dto4_uid795_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_merged_bit_select_d;
    rightShiftStage2_uid818_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_combproc: PROCESS (rightShiftStage2_uid818_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_s, rightShiftStage1_uid807_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q, rightShiftStage2Idx1_uid810_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q, rightShiftStage2Idx2_uid813_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q, rightShiftStage2Idx3_uid816_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q)
    BEGIN
        CASE (rightShiftStage2_uid818_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_s) IS
            WHEN "00" => rightShiftStage2_uid818_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q <= rightShiftStage1_uid807_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q;
            WHEN "01" => rightShiftStage2_uid818_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q <= rightShiftStage2Idx1_uid810_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q;
            WHEN "10" => rightShiftStage2_uid818_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q <= rightShiftStage2Idx2_uid813_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q;
            WHEN "11" => rightShiftStage2_uid818_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q <= rightShiftStage2Idx3_uid816_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q;
            WHEN OTHERS => rightShiftStage2_uid818_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- shiftedOut_uid785_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest(COMPARE,784)@4
    shiftedOut_uid785_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_a <= STD_LOGIC_VECTOR("00" & expAmExpB_uid447_rReal_uid16_fpComplexMulTest_q);
    shiftedOut_uid785_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_b <= STD_LOGIC_VECTOR("00000" & wIntCst_uid784_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q);
    shiftedOut_uid785_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_o <= STD_LOGIC_VECTOR(UNSIGNED(shiftedOut_uid785_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_a) - UNSIGNED(shiftedOut_uid785_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_b));
    shiftedOut_uid785_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_n(0) <= not (shiftedOut_uid785_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_o(10));

    -- r_uid820_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest(MUX,819)@4
    r_uid820_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_s <= shiftedOut_uid785_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_n;
    r_uid820_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_combproc: PROCESS (r_uid820_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_s, rightShiftStage2_uid818_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q, zeroOutCst_uid819_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q)
    BEGIN
        CASE (r_uid820_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_s) IS
            WHEN "0" => r_uid820_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q <= rightShiftStage2_uid818_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q;
            WHEN "1" => r_uid820_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q <= zeroOutCst_uid819_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q;
            WHEN OTHERS => r_uid820_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- alignFracBPostShiftOut_uid455_rReal_uid16_fpComplexMulTest(LOGICAL,454)@4
    alignFracBPostShiftOut_uid455_rReal_uid16_fpComplexMulTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((48 downto 1 => iShiftedOut_uid454_rReal_uid16_fpComplexMulTest_q(0)) & iShiftedOut_uid454_rReal_uid16_fpComplexMulTest_q));
    alignFracBPostShiftOut_uid455_rReal_uid16_fpComplexMulTest_q <= r_uid820_alignmentShifter_uid451_rReal_uid16_fpComplexMulTest_q and alignFracBPostShiftOut_uid455_rReal_uid16_fpComplexMulTest_b;

    -- stickyBits_uid456_rReal_uid16_fpComplexMulTest_merged_bit_select(BITSELECT,926)@4
    stickyBits_uid456_rReal_uid16_fpComplexMulTest_merged_bit_select_b <= alignFracBPostShiftOut_uid455_rReal_uid16_fpComplexMulTest_q(22 downto 0);
    stickyBits_uid456_rReal_uid16_fpComplexMulTest_merged_bit_select_c <= alignFracBPostShiftOut_uid455_rReal_uid16_fpComplexMulTest_q(48 downto 23);

    -- fracBAddOp_uid467_rReal_uid16_fpComplexMulTest(BITJOIN,466)@4
    fracBAddOp_uid467_rReal_uid16_fpComplexMulTest_q <= GND_q & stickyBits_uid456_rReal_uid16_fpComplexMulTest_merged_bit_select_c;

    -- fracBAddOpPostXor_uid468_rReal_uid16_fpComplexMulTest(LOGICAL,467)@4
    fracBAddOpPostXor_uid468_rReal_uid16_fpComplexMulTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((26 downto 1 => effSub_uid437_rReal_uid16_fpComplexMulTest_q(0)) & effSub_uid437_rReal_uid16_fpComplexMulTest_q));
    fracBAddOpPostXor_uid468_rReal_uid16_fpComplexMulTest_q <= fracBAddOp_uid467_rReal_uid16_fpComplexMulTest_q xor fracBAddOpPostXor_uid468_rReal_uid16_fpComplexMulTest_b;

    -- fracA_uid433_rReal_uid16_fpComplexMulTest(BITSELECT,432)@3
    fracA_uid433_rReal_uid16_fpComplexMulTest_in <= aSig_uid421_rReal_uid16_fpComplexMulTest_q(22 downto 0);
    fracA_uid433_rReal_uid16_fpComplexMulTest_b <= fracA_uid433_rReal_uid16_fpComplexMulTest_in(22 downto 0);

    -- redist25_fracA_uid433_rReal_uid16_fpComplexMulTest_b_1(DELAY,962)
    redist25_fracA_uid433_rReal_uid16_fpComplexMulTest_b_1 : dspba_delay
    GENERIC MAP ( width => 23, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracA_uid433_rReal_uid16_fpComplexMulTest_b, xout => redist25_fracA_uid433_rReal_uid16_fpComplexMulTest_b_1_q, clk => clk, aclr => areset );

    -- cmpEQ_stickyBits_cZwF_uid458_rReal_uid16_fpComplexMulTest(LOGICAL,457)@4
    cmpEQ_stickyBits_cZwF_uid458_rReal_uid16_fpComplexMulTest_q <= "1" WHEN stickyBits_uid456_rReal_uid16_fpComplexMulTest_merged_bit_select_b = cstZeroWF_uid25_ac_uid6_fpComplexMulTest_q ELSE "0";

    -- effSubInvSticky_uid461_rReal_uid16_fpComplexMulTest(LOGICAL,460)@4
    effSubInvSticky_uid461_rReal_uid16_fpComplexMulTest_q <= effSub_uid437_rReal_uid16_fpComplexMulTest_q and cmpEQ_stickyBits_cZwF_uid458_rReal_uid16_fpComplexMulTest_q;

    -- fracAAddOp_uid464_rReal_uid16_fpComplexMulTest(BITJOIN,463)@4
    fracAAddOp_uid464_rReal_uid16_fpComplexMulTest_q <= one2b_uid387_rReal_uid16_fpComplexMulTest_q & redist25_fracA_uid433_rReal_uid16_fpComplexMulTest_b_1_q & GND_q & effSubInvSticky_uid461_rReal_uid16_fpComplexMulTest_q;

    -- fracAddResult_uid469_rReal_uid16_fpComplexMulTest(ADD,468)@4
    fracAddResult_uid469_rReal_uid16_fpComplexMulTest_a <= STD_LOGIC_VECTOR("0" & fracAAddOp_uid464_rReal_uid16_fpComplexMulTest_q);
    fracAddResult_uid469_rReal_uid16_fpComplexMulTest_b <= STD_LOGIC_VECTOR("0" & fracBAddOpPostXor_uid468_rReal_uid16_fpComplexMulTest_q);
    fracAddResult_uid469_rReal_uid16_fpComplexMulTest_o <= STD_LOGIC_VECTOR(UNSIGNED(fracAddResult_uid469_rReal_uid16_fpComplexMulTest_a) + UNSIGNED(fracAddResult_uid469_rReal_uid16_fpComplexMulTest_b));
    fracAddResult_uid469_rReal_uid16_fpComplexMulTest_q <= fracAddResult_uid469_rReal_uid16_fpComplexMulTest_o(27 downto 0);

    -- rangeFracAddResultMwfp3Dto0_uid470_rReal_uid16_fpComplexMulTest(BITSELECT,469)@4
    rangeFracAddResultMwfp3Dto0_uid470_rReal_uid16_fpComplexMulTest_in <= fracAddResult_uid469_rReal_uid16_fpComplexMulTest_q(26 downto 0);
    rangeFracAddResultMwfp3Dto0_uid470_rReal_uid16_fpComplexMulTest_b <= rangeFracAddResultMwfp3Dto0_uid470_rReal_uid16_fpComplexMulTest_in(26 downto 0);

    -- redist18_rangeFracAddResultMwfp3Dto0_uid470_rReal_uid16_fpComplexMulTest_b_1(DELAY,955)
    redist18_rangeFracAddResultMwfp3Dto0_uid470_rReal_uid16_fpComplexMulTest_b_1 : dspba_delay
    GENERIC MAP ( width => 27, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => rangeFracAddResultMwfp3Dto0_uid470_rReal_uid16_fpComplexMulTest_b, xout => redist18_rangeFracAddResultMwfp3Dto0_uid470_rReal_uid16_fpComplexMulTest_b_1_q, clk => clk, aclr => areset );

    -- invCmpEQ_stickyBits_cZwF_uid459_rReal_uid16_fpComplexMulTest(LOGICAL,458)@4 + 1
    invCmpEQ_stickyBits_cZwF_uid459_rReal_uid16_fpComplexMulTest_qi <= not (cmpEQ_stickyBits_cZwF_uid458_rReal_uid16_fpComplexMulTest_q);
    invCmpEQ_stickyBits_cZwF_uid459_rReal_uid16_fpComplexMulTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => invCmpEQ_stickyBits_cZwF_uid459_rReal_uid16_fpComplexMulTest_qi, xout => invCmpEQ_stickyBits_cZwF_uid459_rReal_uid16_fpComplexMulTest_q, clk => clk, aclr => areset );

    -- fracGRS_uid471_rReal_uid16_fpComplexMulTest(BITJOIN,470)@5
    fracGRS_uid471_rReal_uid16_fpComplexMulTest_q <= redist18_rangeFracAddResultMwfp3Dto0_uid470_rReal_uid16_fpComplexMulTest_b_1_q & invCmpEQ_stickyBits_cZwF_uid459_rReal_uid16_fpComplexMulTest_q;

    -- rVStage_uid713_lzCountVal_uid472_rReal_uid16_fpComplexMulTest(BITSELECT,712)@5
    rVStage_uid713_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_b <= fracGRS_uid471_rReal_uid16_fpComplexMulTest_q(27 downto 12);

    -- vCount_uid714_lzCountVal_uid472_rReal_uid16_fpComplexMulTest(LOGICAL,713)@5
    vCount_uid714_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q <= "1" WHEN rVStage_uid713_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_b = zs_uid712_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q ELSE "0";

    -- vStage_uid716_lzCountVal_uid472_rReal_uid16_fpComplexMulTest(BITSELECT,715)@5
    vStage_uid716_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_in <= fracGRS_uid471_rReal_uid16_fpComplexMulTest_q(11 downto 0);
    vStage_uid716_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_b <= vStage_uid716_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_in(11 downto 0);

    -- cStage_uid717_lzCountVal_uid472_rReal_uid16_fpComplexMulTest(BITJOIN,716)@5
    cStage_uid717_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q <= vStage_uid716_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_b & mO_uid715_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q;

    -- vStagei_uid719_lzCountVal_uid472_rReal_uid16_fpComplexMulTest(MUX,718)@5
    vStagei_uid719_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_s <= vCount_uid714_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q;
    vStagei_uid719_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_combproc: PROCESS (vStagei_uid719_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_s, rVStage_uid713_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_b, cStage_uid717_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q)
    BEGIN
        CASE (vStagei_uid719_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_s) IS
            WHEN "0" => vStagei_uid719_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q <= rVStage_uid713_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_b;
            WHEN "1" => vStagei_uid719_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q <= cStage_uid717_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q;
            WHEN OTHERS => vStagei_uid719_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- rVStage_uid721_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_merged_bit_select(BITSELECT,929)@5
    rVStage_uid721_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_merged_bit_select_b <= vStagei_uid719_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q(15 downto 8);
    rVStage_uid721_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_merged_bit_select_c <= vStagei_uid719_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q(7 downto 0);

    -- vCount_uid722_lzCountVal_uid472_rReal_uid16_fpComplexMulTest(LOGICAL,721)@5
    vCount_uid722_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q <= "1" WHEN rVStage_uid721_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_merged_bit_select_b = cstAllZWE_uid26_ac_uid6_fpComplexMulTest_q ELSE "0";

    -- vStagei_uid725_lzCountVal_uid472_rReal_uid16_fpComplexMulTest(MUX,724)@5
    vStagei_uid725_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_s <= vCount_uid722_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q;
    vStagei_uid725_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_combproc: PROCESS (vStagei_uid725_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_s, rVStage_uid721_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_merged_bit_select_b, rVStage_uid721_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_merged_bit_select_c)
    BEGIN
        CASE (vStagei_uid725_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_s) IS
            WHEN "0" => vStagei_uid725_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q <= rVStage_uid721_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_merged_bit_select_b;
            WHEN "1" => vStagei_uid725_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q <= rVStage_uid721_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_merged_bit_select_c;
            WHEN OTHERS => vStagei_uid725_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- rVStage_uid727_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_merged_bit_select(BITSELECT,930)@5
    rVStage_uid727_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_merged_bit_select_b <= vStagei_uid725_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q(7 downto 4);
    rVStage_uid727_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_merged_bit_select_c <= vStagei_uid725_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q(3 downto 0);

    -- vCount_uid728_lzCountVal_uid472_rReal_uid16_fpComplexMulTest(LOGICAL,727)@5
    vCount_uid728_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q <= "1" WHEN rVStage_uid727_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_merged_bit_select_b = zs_uid726_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q ELSE "0";

    -- vStagei_uid731_lzCountVal_uid472_rReal_uid16_fpComplexMulTest(MUX,730)@5
    vStagei_uid731_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_s <= vCount_uid728_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q;
    vStagei_uid731_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_combproc: PROCESS (vStagei_uid731_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_s, rVStage_uid727_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_merged_bit_select_b, rVStage_uid727_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_merged_bit_select_c)
    BEGIN
        CASE (vStagei_uid731_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_s) IS
            WHEN "0" => vStagei_uid731_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q <= rVStage_uid727_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_merged_bit_select_b;
            WHEN "1" => vStagei_uid731_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q <= rVStage_uid727_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_merged_bit_select_c;
            WHEN OTHERS => vStagei_uid731_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- rVStage_uid733_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_merged_bit_select(BITSELECT,931)@5
    rVStage_uid733_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_merged_bit_select_b <= vStagei_uid731_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q(3 downto 2);
    rVStage_uid733_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_merged_bit_select_c <= vStagei_uid731_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q(1 downto 0);

    -- vCount_uid734_lzCountVal_uid472_rReal_uid16_fpComplexMulTest(LOGICAL,733)@5
    vCount_uid734_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q <= "1" WHEN rVStage_uid733_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_merged_bit_select_b = zero2b_uid386_rReal_uid16_fpComplexMulTest_q ELSE "0";

    -- vStagei_uid737_lzCountVal_uid472_rReal_uid16_fpComplexMulTest(MUX,736)@5
    vStagei_uid737_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_s <= vCount_uid734_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q;
    vStagei_uid737_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_combproc: PROCESS (vStagei_uid737_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_s, rVStage_uid733_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_merged_bit_select_b, rVStage_uid733_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_merged_bit_select_c)
    BEGIN
        CASE (vStagei_uid737_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_s) IS
            WHEN "0" => vStagei_uid737_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q <= rVStage_uid733_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_merged_bit_select_b;
            WHEN "1" => vStagei_uid737_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q <= rVStage_uid733_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_merged_bit_select_c;
            WHEN OTHERS => vStagei_uid737_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- rVStage_uid739_lzCountVal_uid472_rReal_uid16_fpComplexMulTest(BITSELECT,738)@5
    rVStage_uid739_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_b <= vStagei_uid737_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q(1 downto 1);

    -- vCount_uid740_lzCountVal_uid472_rReal_uid16_fpComplexMulTest(LOGICAL,739)@5
    vCount_uid740_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q <= "1" WHEN rVStage_uid739_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_b = GND_q ELSE "0";

    -- r_uid741_lzCountVal_uid472_rReal_uid16_fpComplexMulTest(BITJOIN,740)@5
    r_uid741_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q <= vCount_uid714_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q & vCount_uid722_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q & vCount_uid728_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q & vCount_uid734_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q & vCount_uid740_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q;

    -- aMinusA_uid474_rReal_uid16_fpComplexMulTest(LOGICAL,473)@5
    aMinusA_uid474_rReal_uid16_fpComplexMulTest_q <= "1" WHEN r_uid741_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q = cAmA_uid473_rReal_uid16_fpComplexMulTest_q ELSE "0";

    -- invAMinusA_uid519_rReal_uid16_fpComplexMulTest(LOGICAL,518)@5
    invAMinusA_uid519_rReal_uid16_fpComplexMulTest_q <= not (aMinusA_uid474_rReal_uid16_fpComplexMulTest_q);

    -- redist23_sigA_uid435_rReal_uid16_fpComplexMulTest_b_2(DELAY,960)
    redist23_sigA_uid435_rReal_uid16_fpComplexMulTest_b_2 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => redist22_sigA_uid435_rReal_uid16_fpComplexMulTest_b_1_q, xout => redist23_sigA_uid435_rReal_uid16_fpComplexMulTest_b_2_q, clk => clk, aclr => areset );

    -- redist37_excX_uid399_rReal_uid16_fpComplexMulTest_b_2(DELAY,974)
    redist37_excX_uid399_rReal_uid16_fpComplexMulTest_b_2 : dspba_delay
    GENERIC MAP ( width => 2, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => excX_uid399_rReal_uid16_fpComplexMulTest_b, xout => redist37_excX_uid399_rReal_uid16_fpComplexMulTest_b_2_q, clk => clk, aclr => areset );

    -- excXReg_uid405_rReal_uid16_fpComplexMulTest(LOGICAL,404)@5
    excXReg_uid405_rReal_uid16_fpComplexMulTest_q <= "1" WHEN redist37_excX_uid399_rReal_uid16_fpComplexMulTest_b_2_q = one2b_uid387_rReal_uid16_fpComplexMulTest_q ELSE "0";

    -- redist38_excX_uid385_rReal_uid16_fpComplexMulTest_b_2(DELAY,975)
    redist38_excX_uid385_rReal_uid16_fpComplexMulTest_b_2 : dspba_delay
    GENERIC MAP ( width => 2, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => excX_uid385_rReal_uid16_fpComplexMulTest_b, xout => redist38_excX_uid385_rReal_uid16_fpComplexMulTest_b_2_q, clk => clk, aclr => areset );

    -- excXReg_uid391_rReal_uid16_fpComplexMulTest(LOGICAL,390)@5
    excXReg_uid391_rReal_uid16_fpComplexMulTest_q <= "1" WHEN redist38_excX_uid385_rReal_uid16_fpComplexMulTest_b_2_q = one2b_uid387_rReal_uid16_fpComplexMulTest_q ELSE "0";

    -- redist36_xGTEy_uid413_rReal_uid16_fpComplexMulTest_q_2(DELAY,973)
    redist36_xGTEy_uid413_rReal_uid16_fpComplexMulTest_q_2 : dspba_delay
    GENERIC MAP ( width => 1, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => xGTEy_uid413_rReal_uid16_fpComplexMulTest_q, xout => redist36_xGTEy_uid413_rReal_uid16_fpComplexMulTest_q_2_q, clk => clk, aclr => areset );

    -- excBR_uid429_rReal_uid16_fpComplexMulTest(MUX,428)@5
    excBR_uid429_rReal_uid16_fpComplexMulTest_s <= redist36_xGTEy_uid413_rReal_uid16_fpComplexMulTest_q_2_q;
    excBR_uid429_rReal_uid16_fpComplexMulTest_combproc: PROCESS (excBR_uid429_rReal_uid16_fpComplexMulTest_s, excXReg_uid391_rReal_uid16_fpComplexMulTest_q, excXReg_uid405_rReal_uid16_fpComplexMulTest_q)
    BEGIN
        CASE (excBR_uid429_rReal_uid16_fpComplexMulTest_s) IS
            WHEN "0" => excBR_uid429_rReal_uid16_fpComplexMulTest_q <= excXReg_uid391_rReal_uid16_fpComplexMulTest_q;
            WHEN "1" => excBR_uid429_rReal_uid16_fpComplexMulTest_q <= excXReg_uid405_rReal_uid16_fpComplexMulTest_q;
            WHEN OTHERS => excBR_uid429_rReal_uid16_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- excAR_uid425_rReal_uid16_fpComplexMulTest(MUX,424)@5
    excAR_uid425_rReal_uid16_fpComplexMulTest_s <= redist36_xGTEy_uid413_rReal_uid16_fpComplexMulTest_q_2_q;
    excAR_uid425_rReal_uid16_fpComplexMulTest_combproc: PROCESS (excAR_uid425_rReal_uid16_fpComplexMulTest_s, excXReg_uid405_rReal_uid16_fpComplexMulTest_q, excXReg_uid391_rReal_uid16_fpComplexMulTest_q)
    BEGIN
        CASE (excAR_uid425_rReal_uid16_fpComplexMulTest_s) IS
            WHEN "0" => excAR_uid425_rReal_uid16_fpComplexMulTest_q <= excXReg_uid405_rReal_uid16_fpComplexMulTest_q;
            WHEN "1" => excAR_uid425_rReal_uid16_fpComplexMulTest_q <= excXReg_uid391_rReal_uid16_fpComplexMulTest_q;
            WHEN OTHERS => excAR_uid425_rReal_uid16_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- signRReg_uid520_rReal_uid16_fpComplexMulTest(LOGICAL,519)@5
    signRReg_uid520_rReal_uid16_fpComplexMulTest_q <= excAR_uid425_rReal_uid16_fpComplexMulTest_q and excBR_uid429_rReal_uid16_fpComplexMulTest_q and redist23_sigA_uid435_rReal_uid16_fpComplexMulTest_b_2_q and invAMinusA_uid519_rReal_uid16_fpComplexMulTest_q;

    -- redist21_sigB_uid436_rReal_uid16_fpComplexMulTest_b_2(DELAY,958)
    redist21_sigB_uid436_rReal_uid16_fpComplexMulTest_b_2 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => redist20_sigB_uid436_rReal_uid16_fpComplexMulTest_b_1_q, xout => redist21_sigB_uid436_rReal_uid16_fpComplexMulTest_b_2_q, clk => clk, aclr => areset );

    -- redist28_excBZ_uid430_rReal_uid16_fpComplexMulTest_q_2(DELAY,965)
    redist28_excBZ_uid430_rReal_uid16_fpComplexMulTest_q_2 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => redist27_excBZ_uid430_rReal_uid16_fpComplexMulTest_q_1_q, xout => redist28_excBZ_uid430_rReal_uid16_fpComplexMulTest_q_2_q, clk => clk, aclr => areset );

    -- excAZ_uid426_rReal_uid16_fpComplexMulTest(MUX,425)@3 + 1
    excAZ_uid426_rReal_uid16_fpComplexMulTest_s <= xGTEy_uid413_rReal_uid16_fpComplexMulTest_q;
    excAZ_uid426_rReal_uid16_fpComplexMulTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            excAZ_uid426_rReal_uid16_fpComplexMulTest_q <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            CASE (excAZ_uid426_rReal_uid16_fpComplexMulTest_s) IS
                WHEN "0" => excAZ_uid426_rReal_uid16_fpComplexMulTest_q <= excXZero_uid404_rReal_uid16_fpComplexMulTest_q;
                WHEN "1" => excAZ_uid426_rReal_uid16_fpComplexMulTest_q <= excXZero_uid390_rReal_uid16_fpComplexMulTest_q;
                WHEN OTHERS => excAZ_uid426_rReal_uid16_fpComplexMulTest_q <= (others => '0');
            END CASE;
        END IF;
    END PROCESS;

    -- redist32_excAZ_uid426_rReal_uid16_fpComplexMulTest_q_2(DELAY,969)
    redist32_excAZ_uid426_rReal_uid16_fpComplexMulTest_q_2 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => excAZ_uid426_rReal_uid16_fpComplexMulTest_q, xout => redist32_excAZ_uid426_rReal_uid16_fpComplexMulTest_q_2_q, clk => clk, aclr => areset );

    -- excAZBZSigASigB_uid524_rReal_uid16_fpComplexMulTest(LOGICAL,523)@5
    excAZBZSigASigB_uid524_rReal_uid16_fpComplexMulTest_q <= redist32_excAZ_uid426_rReal_uid16_fpComplexMulTest_q_2_q and redist28_excBZ_uid430_rReal_uid16_fpComplexMulTest_q_2_q and redist23_sigA_uid435_rReal_uid16_fpComplexMulTest_b_2_q and redist21_sigB_uid436_rReal_uid16_fpComplexMulTest_b_2_q;

    -- excBZARSigA_uid525_rReal_uid16_fpComplexMulTest(LOGICAL,524)@5
    excBZARSigA_uid525_rReal_uid16_fpComplexMulTest_q <= redist28_excBZ_uid430_rReal_uid16_fpComplexMulTest_q_2_q and excAR_uid425_rReal_uid16_fpComplexMulTest_q and redist23_sigA_uid435_rReal_uid16_fpComplexMulTest_b_2_q;

    -- signRZero_uid526_rReal_uid16_fpComplexMulTest(LOGICAL,525)@5
    signRZero_uid526_rReal_uid16_fpComplexMulTest_q <= excBZARSigA_uid525_rReal_uid16_fpComplexMulTest_q or excAZBZSigASigB_uid524_rReal_uid16_fpComplexMulTest_q;

    -- excXInf_uid406_rReal_uid16_fpComplexMulTest(LOGICAL,405)@5
    excXInf_uid406_rReal_uid16_fpComplexMulTest_q <= "1" WHEN redist37_excX_uid399_rReal_uid16_fpComplexMulTest_b_2_q = two2b_uid388_rReal_uid16_fpComplexMulTest_q ELSE "0";

    -- excXInf_uid392_rReal_uid16_fpComplexMulTest(LOGICAL,391)@5
    excXInf_uid392_rReal_uid16_fpComplexMulTest_q <= "1" WHEN redist38_excX_uid385_rReal_uid16_fpComplexMulTest_b_2_q = two2b_uid388_rReal_uid16_fpComplexMulTest_q ELSE "0";

    -- excBI_uid427_rReal_uid16_fpComplexMulTest(MUX,426)@5
    excBI_uid427_rReal_uid16_fpComplexMulTest_s <= redist36_xGTEy_uid413_rReal_uid16_fpComplexMulTest_q_2_q;
    excBI_uid427_rReal_uid16_fpComplexMulTest_combproc: PROCESS (excBI_uid427_rReal_uid16_fpComplexMulTest_s, excXInf_uid392_rReal_uid16_fpComplexMulTest_q, excXInf_uid406_rReal_uid16_fpComplexMulTest_q)
    BEGIN
        CASE (excBI_uid427_rReal_uid16_fpComplexMulTest_s) IS
            WHEN "0" => excBI_uid427_rReal_uid16_fpComplexMulTest_q <= excXInf_uid392_rReal_uid16_fpComplexMulTest_q;
            WHEN "1" => excBI_uid427_rReal_uid16_fpComplexMulTest_q <= excXInf_uid406_rReal_uid16_fpComplexMulTest_q;
            WHEN OTHERS => excBI_uid427_rReal_uid16_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- sigBBInf_uid521_rReal_uid16_fpComplexMulTest(LOGICAL,520)@5
    sigBBInf_uid521_rReal_uid16_fpComplexMulTest_q <= redist21_sigB_uid436_rReal_uid16_fpComplexMulTest_b_2_q and excBI_uid427_rReal_uid16_fpComplexMulTest_q;

    -- excAI_uid423_rReal_uid16_fpComplexMulTest(MUX,422)@5
    excAI_uid423_rReal_uid16_fpComplexMulTest_s <= redist36_xGTEy_uid413_rReal_uid16_fpComplexMulTest_q_2_q;
    excAI_uid423_rReal_uid16_fpComplexMulTest_combproc: PROCESS (excAI_uid423_rReal_uid16_fpComplexMulTest_s, excXInf_uid406_rReal_uid16_fpComplexMulTest_q, excXInf_uid392_rReal_uid16_fpComplexMulTest_q)
    BEGIN
        CASE (excAI_uid423_rReal_uid16_fpComplexMulTest_s) IS
            WHEN "0" => excAI_uid423_rReal_uid16_fpComplexMulTest_q <= excXInf_uid406_rReal_uid16_fpComplexMulTest_q;
            WHEN "1" => excAI_uid423_rReal_uid16_fpComplexMulTest_q <= excXInf_uid392_rReal_uid16_fpComplexMulTest_q;
            WHEN OTHERS => excAI_uid423_rReal_uid16_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- sigAAInf_uid522_rReal_uid16_fpComplexMulTest(LOGICAL,521)@5
    sigAAInf_uid522_rReal_uid16_fpComplexMulTest_q <= redist23_sigA_uid435_rReal_uid16_fpComplexMulTest_b_2_q and excAI_uid423_rReal_uid16_fpComplexMulTest_q;

    -- signRInf_uid523_rReal_uid16_fpComplexMulTest(LOGICAL,522)@5
    signRInf_uid523_rReal_uid16_fpComplexMulTest_q <= sigAAInf_uid522_rReal_uid16_fpComplexMulTest_q or sigBBInf_uid521_rReal_uid16_fpComplexMulTest_q;

    -- signRInfRZRReg_uid527_rReal_uid16_fpComplexMulTest(LOGICAL,526)@5 + 1
    signRInfRZRReg_uid527_rReal_uid16_fpComplexMulTest_qi <= signRInf_uid523_rReal_uid16_fpComplexMulTest_q or signRZero_uid526_rReal_uid16_fpComplexMulTest_q or signRReg_uid520_rReal_uid16_fpComplexMulTest_q;
    signRInfRZRReg_uid527_rReal_uid16_fpComplexMulTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => signRInfRZRReg_uid527_rReal_uid16_fpComplexMulTest_qi, xout => signRInfRZRReg_uid527_rReal_uid16_fpComplexMulTest_q, clk => clk, aclr => areset );

    -- excXNaN_uid407_rReal_uid16_fpComplexMulTest(LOGICAL,406)@5
    excXNaN_uid407_rReal_uid16_fpComplexMulTest_q <= "1" WHEN redist37_excX_uid399_rReal_uid16_fpComplexMulTest_b_2_q = three2b_uid389_rReal_uid16_fpComplexMulTest_q ELSE "0";

    -- excXNaN_uid393_rReal_uid16_fpComplexMulTest(LOGICAL,392)@5
    excXNaN_uid393_rReal_uid16_fpComplexMulTest_q <= "1" WHEN redist38_excX_uid385_rReal_uid16_fpComplexMulTest_b_2_q = three2b_uid389_rReal_uid16_fpComplexMulTest_q ELSE "0";

    -- excBN_uid428_rReal_uid16_fpComplexMulTest(MUX,427)@5 + 1
    excBN_uid428_rReal_uid16_fpComplexMulTest_s <= redist36_xGTEy_uid413_rReal_uid16_fpComplexMulTest_q_2_q;
    excBN_uid428_rReal_uid16_fpComplexMulTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            excBN_uid428_rReal_uid16_fpComplexMulTest_q <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            CASE (excBN_uid428_rReal_uid16_fpComplexMulTest_s) IS
                WHEN "0" => excBN_uid428_rReal_uid16_fpComplexMulTest_q <= excXNaN_uid393_rReal_uid16_fpComplexMulTest_q;
                WHEN "1" => excBN_uid428_rReal_uid16_fpComplexMulTest_q <= excXNaN_uid407_rReal_uid16_fpComplexMulTest_q;
                WHEN OTHERS => excBN_uid428_rReal_uid16_fpComplexMulTest_q <= (others => '0');
            END CASE;
        END IF;
    END PROCESS;

    -- excAN_uid424_rReal_uid16_fpComplexMulTest(MUX,423)@5 + 1
    excAN_uid424_rReal_uid16_fpComplexMulTest_s <= redist36_xGTEy_uid413_rReal_uid16_fpComplexMulTest_q_2_q;
    excAN_uid424_rReal_uid16_fpComplexMulTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            excAN_uid424_rReal_uid16_fpComplexMulTest_q <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            CASE (excAN_uid424_rReal_uid16_fpComplexMulTest_s) IS
                WHEN "0" => excAN_uid424_rReal_uid16_fpComplexMulTest_q <= excXNaN_uid407_rReal_uid16_fpComplexMulTest_q;
                WHEN "1" => excAN_uid424_rReal_uid16_fpComplexMulTest_q <= excXNaN_uid393_rReal_uid16_fpComplexMulTest_q;
                WHEN OTHERS => excAN_uid424_rReal_uid16_fpComplexMulTest_q <= (others => '0');
            END CASE;
        END IF;
    END PROCESS;

    -- excRNaN2_uid514_rReal_uid16_fpComplexMulTest(LOGICAL,513)@6
    excRNaN2_uid514_rReal_uid16_fpComplexMulTest_q <= excAN_uid424_rReal_uid16_fpComplexMulTest_q or excBN_uid428_rReal_uid16_fpComplexMulTest_q;

    -- redist19_effSub_uid437_rReal_uid16_fpComplexMulTest_q_2(DELAY,956)
    redist19_effSub_uid437_rReal_uid16_fpComplexMulTest_q_2 : dspba_delay
    GENERIC MAP ( width => 1, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => effSub_uid437_rReal_uid16_fpComplexMulTest_q, xout => redist19_effSub_uid437_rReal_uid16_fpComplexMulTest_q_2_q, clk => clk, aclr => areset );

    -- redist31_excBI_uid427_rReal_uid16_fpComplexMulTest_q_1(DELAY,968)
    redist31_excBI_uid427_rReal_uid16_fpComplexMulTest_q_1 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => excBI_uid427_rReal_uid16_fpComplexMulTest_q, xout => redist31_excBI_uid427_rReal_uid16_fpComplexMulTest_q_1_q, clk => clk, aclr => areset );

    -- redist35_excAI_uid423_rReal_uid16_fpComplexMulTest_q_1(DELAY,972)
    redist35_excAI_uid423_rReal_uid16_fpComplexMulTest_q_1 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => excAI_uid423_rReal_uid16_fpComplexMulTest_q, xout => redist35_excAI_uid423_rReal_uid16_fpComplexMulTest_q_1_q, clk => clk, aclr => areset );

    -- excAIBISub_uid515_rReal_uid16_fpComplexMulTest(LOGICAL,514)@6
    excAIBISub_uid515_rReal_uid16_fpComplexMulTest_q <= redist35_excAI_uid423_rReal_uid16_fpComplexMulTest_q_1_q and redist31_excBI_uid427_rReal_uid16_fpComplexMulTest_q_1_q and redist19_effSub_uid437_rReal_uid16_fpComplexMulTest_q_2_q;

    -- excRNaN_uid516_rReal_uid16_fpComplexMulTest(LOGICAL,515)@6
    excRNaN_uid516_rReal_uid16_fpComplexMulTest_q <= excAIBISub_uid515_rReal_uid16_fpComplexMulTest_q or excRNaN2_uid514_rReal_uid16_fpComplexMulTest_q;

    -- invExcRNaN_uid528_rReal_uid16_fpComplexMulTest(LOGICAL,527)@6
    invExcRNaN_uid528_rReal_uid16_fpComplexMulTest_q <= not (excRNaN_uid516_rReal_uid16_fpComplexMulTest_q);

    -- signRPostExc_uid529_rReal_uid16_fpComplexMulTest(LOGICAL,528)@6
    signRPostExc_uid529_rReal_uid16_fpComplexMulTest_q <= invExcRNaN_uid528_rReal_uid16_fpComplexMulTest_q and signRInfRZRReg_uid527_rReal_uid16_fpComplexMulTest_q;

    -- leftShiftStage2Idx1Rng1_uid847_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest(BITSELECT,846)@5
    leftShiftStage2Idx1Rng1_uid847_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_in <= leftShiftStage1_uid845_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q(26 downto 0);
    leftShiftStage2Idx1Rng1_uid847_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_b <= leftShiftStage2Idx1Rng1_uid847_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_in(26 downto 0);

    -- leftShiftStage2Idx1_uid848_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest(BITJOIN,847)@5
    leftShiftStage2Idx1_uid848_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q <= leftShiftStage2Idx1Rng1_uid847_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_b & GND_q;

    -- leftShiftStage1Idx3Rng6_uid842_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest(BITSELECT,841)@5
    leftShiftStage1Idx3Rng6_uid842_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_in <= leftShiftStage0_uid834_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q(21 downto 0);
    leftShiftStage1Idx3Rng6_uid842_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_b <= leftShiftStage1Idx3Rng6_uid842_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_in(21 downto 0);

    -- leftShiftStage1Idx3_uid843_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest(BITJOIN,842)@5
    leftShiftStage1Idx3_uid843_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q <= leftShiftStage1Idx3Rng6_uid842_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_b & leftShiftStage1Idx3Pad6_uid841_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q;

    -- leftShiftStage1Idx2Rng4_uid839_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest(BITSELECT,838)@5
    leftShiftStage1Idx2Rng4_uid839_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_in <= leftShiftStage0_uid834_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q(23 downto 0);
    leftShiftStage1Idx2Rng4_uid839_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_b <= leftShiftStage1Idx2Rng4_uid839_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_in(23 downto 0);

    -- leftShiftStage1Idx2_uid840_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest(BITJOIN,839)@5
    leftShiftStage1Idx2_uid840_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q <= leftShiftStage1Idx2Rng4_uid839_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_b & zs_uid726_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q;

    -- leftShiftStage1Idx1Rng2_uid836_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest(BITSELECT,835)@5
    leftShiftStage1Idx1Rng2_uid836_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_in <= leftShiftStage0_uid834_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q(25 downto 0);
    leftShiftStage1Idx1Rng2_uid836_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_b <= leftShiftStage1Idx1Rng2_uid836_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_in(25 downto 0);

    -- leftShiftStage1Idx1_uid837_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest(BITJOIN,836)@5
    leftShiftStage1Idx1_uid837_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q <= leftShiftStage1Idx1Rng2_uid836_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_b & zero2b_uid386_rReal_uid16_fpComplexMulTest_q;

    -- leftShiftStage0Idx3Rng24_uid831_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest(BITSELECT,830)@5
    leftShiftStage0Idx3Rng24_uid831_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_in <= fracGRS_uid471_rReal_uid16_fpComplexMulTest_q(3 downto 0);
    leftShiftStage0Idx3Rng24_uid831_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_b <= leftShiftStage0Idx3Rng24_uid831_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_in(3 downto 0);

    -- leftShiftStage0Idx3_uid832_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest(BITJOIN,831)@5
    leftShiftStage0Idx3_uid832_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q <= leftShiftStage0Idx3Rng24_uid831_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_b & leftShiftStage0Idx3Pad24_uid830_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q;

    -- leftShiftStage0Idx2_uid829_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest(BITJOIN,828)@5
    leftShiftStage0Idx2_uid829_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q <= vStage_uid716_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_b & zs_uid712_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q;

    -- leftShiftStage0Idx1Rng8_uid825_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest(BITSELECT,824)@5
    leftShiftStage0Idx1Rng8_uid825_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_in <= fracGRS_uid471_rReal_uid16_fpComplexMulTest_q(19 downto 0);
    leftShiftStage0Idx1Rng8_uid825_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_b <= leftShiftStage0Idx1Rng8_uid825_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_in(19 downto 0);

    -- leftShiftStage0Idx1_uid826_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest(BITJOIN,825)@5
    leftShiftStage0Idx1_uid826_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q <= leftShiftStage0Idx1Rng8_uid825_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_b & cstAllZWE_uid26_ac_uid6_fpComplexMulTest_q;

    -- leftShiftStage0_uid834_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest(MUX,833)@5
    leftShiftStage0_uid834_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_s <= leftShiftStageSel4Dto3_uid833_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_merged_bit_select_b;
    leftShiftStage0_uid834_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_combproc: PROCESS (leftShiftStage0_uid834_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_s, fracGRS_uid471_rReal_uid16_fpComplexMulTest_q, leftShiftStage0Idx1_uid826_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q, leftShiftStage0Idx2_uid829_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q, leftShiftStage0Idx3_uid832_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q)
    BEGIN
        CASE (leftShiftStage0_uid834_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_s) IS
            WHEN "00" => leftShiftStage0_uid834_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q <= fracGRS_uid471_rReal_uid16_fpComplexMulTest_q;
            WHEN "01" => leftShiftStage0_uid834_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q <= leftShiftStage0Idx1_uid826_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q;
            WHEN "10" => leftShiftStage0_uid834_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q <= leftShiftStage0Idx2_uid829_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q;
            WHEN "11" => leftShiftStage0_uid834_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q <= leftShiftStage0Idx3_uid832_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q;
            WHEN OTHERS => leftShiftStage0_uid834_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- leftShiftStage1_uid845_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest(MUX,844)@5
    leftShiftStage1_uid845_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_s <= leftShiftStageSel4Dto3_uid833_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_merged_bit_select_c;
    leftShiftStage1_uid845_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_combproc: PROCESS (leftShiftStage1_uid845_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_s, leftShiftStage0_uid834_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q, leftShiftStage1Idx1_uid837_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q, leftShiftStage1Idx2_uid840_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q, leftShiftStage1Idx3_uid843_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q)
    BEGIN
        CASE (leftShiftStage1_uid845_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_s) IS
            WHEN "00" => leftShiftStage1_uid845_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q <= leftShiftStage0_uid834_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q;
            WHEN "01" => leftShiftStage1_uid845_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q <= leftShiftStage1Idx1_uid837_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q;
            WHEN "10" => leftShiftStage1_uid845_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q <= leftShiftStage1Idx2_uid840_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q;
            WHEN "11" => leftShiftStage1_uid845_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q <= leftShiftStage1Idx3_uid843_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q;
            WHEN OTHERS => leftShiftStage1_uid845_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- leftShiftStageSel4Dto3_uid833_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_merged_bit_select(BITSELECT,932)@5
    leftShiftStageSel4Dto3_uid833_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_merged_bit_select_b <= r_uid741_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q(4 downto 3);
    leftShiftStageSel4Dto3_uid833_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_merged_bit_select_c <= r_uid741_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q(2 downto 1);
    leftShiftStageSel4Dto3_uid833_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_merged_bit_select_d <= r_uid741_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q(0 downto 0);

    -- leftShiftStage2_uid850_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest(MUX,849)@5
    leftShiftStage2_uid850_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_s <= leftShiftStageSel4Dto3_uid833_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_merged_bit_select_d;
    leftShiftStage2_uid850_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_combproc: PROCESS (leftShiftStage2_uid850_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_s, leftShiftStage1_uid845_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q, leftShiftStage2Idx1_uid848_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q)
    BEGIN
        CASE (leftShiftStage2_uid850_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_s) IS
            WHEN "0" => leftShiftStage2_uid850_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q <= leftShiftStage1_uid845_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q;
            WHEN "1" => leftShiftStage2_uid850_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q <= leftShiftStage2Idx1_uid848_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q;
            WHEN OTHERS => leftShiftStage2_uid850_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- LSB_uid484_rReal_uid16_fpComplexMulTest(BITSELECT,483)@5
    LSB_uid484_rReal_uid16_fpComplexMulTest_in <= STD_LOGIC_VECTOR(leftShiftStage2_uid850_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q(4 downto 0));
    LSB_uid484_rReal_uid16_fpComplexMulTest_b <= STD_LOGIC_VECTOR(LSB_uid484_rReal_uid16_fpComplexMulTest_in(4 downto 4));

    -- Guard_uid483_rReal_uid16_fpComplexMulTest(BITSELECT,482)@5
    Guard_uid483_rReal_uid16_fpComplexMulTest_in <= STD_LOGIC_VECTOR(leftShiftStage2_uid850_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q(3 downto 0));
    Guard_uid483_rReal_uid16_fpComplexMulTest_b <= STD_LOGIC_VECTOR(Guard_uid483_rReal_uid16_fpComplexMulTest_in(3 downto 3));

    -- Round_uid482_rReal_uid16_fpComplexMulTest(BITSELECT,481)@5
    Round_uid482_rReal_uid16_fpComplexMulTest_in <= STD_LOGIC_VECTOR(leftShiftStage2_uid850_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q(2 downto 0));
    Round_uid482_rReal_uid16_fpComplexMulTest_b <= STD_LOGIC_VECTOR(Round_uid482_rReal_uid16_fpComplexMulTest_in(2 downto 2));

    -- Sticky1_uid481_rReal_uid16_fpComplexMulTest(BITSELECT,480)@5
    Sticky1_uid481_rReal_uid16_fpComplexMulTest_in <= STD_LOGIC_VECTOR(leftShiftStage2_uid850_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q(1 downto 0));
    Sticky1_uid481_rReal_uid16_fpComplexMulTest_b <= STD_LOGIC_VECTOR(Sticky1_uid481_rReal_uid16_fpComplexMulTest_in(1 downto 1));

    -- Sticky0_uid480_rReal_uid16_fpComplexMulTest(BITSELECT,479)@5
    Sticky0_uid480_rReal_uid16_fpComplexMulTest_in <= STD_LOGIC_VECTOR(leftShiftStage2_uid850_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q(0 downto 0));
    Sticky0_uid480_rReal_uid16_fpComplexMulTest_b <= STD_LOGIC_VECTOR(Sticky0_uid480_rReal_uid16_fpComplexMulTest_in(0 downto 0));

    -- rndBitCond_uid485_rReal_uid16_fpComplexMulTest(BITJOIN,484)@5
    rndBitCond_uid485_rReal_uid16_fpComplexMulTest_q <= LSB_uid484_rReal_uid16_fpComplexMulTest_b & Guard_uid483_rReal_uid16_fpComplexMulTest_b & Round_uid482_rReal_uid16_fpComplexMulTest_b & Sticky1_uid481_rReal_uid16_fpComplexMulTest_b & Sticky0_uid480_rReal_uid16_fpComplexMulTest_b;

    -- rBi_uid487_rReal_uid16_fpComplexMulTest(LOGICAL,486)@5 + 1
    rBi_uid487_rReal_uid16_fpComplexMulTest_qi <= "1" WHEN rndBitCond_uid485_rReal_uid16_fpComplexMulTest_q = cRBit_uid486_rReal_uid16_fpComplexMulTest_q ELSE "0";
    rBi_uid487_rReal_uid16_fpComplexMulTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => rBi_uid487_rReal_uid16_fpComplexMulTest_qi, xout => rBi_uid487_rReal_uid16_fpComplexMulTest_q, clk => clk, aclr => areset );

    -- roundBit_uid488_rReal_uid16_fpComplexMulTest(LOGICAL,487)@6
    roundBit_uid488_rReal_uid16_fpComplexMulTest_q <= not (rBi_uid487_rReal_uid16_fpComplexMulTest_q);

    -- redist26_expA_uid431_rReal_uid16_fpComplexMulTest_b_2(DELAY,963)
    redist26_expA_uid431_rReal_uid16_fpComplexMulTest_b_2 : dspba_delay
    GENERIC MAP ( width => 8, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => expA_uid431_rReal_uid16_fpComplexMulTest_b, xout => redist26_expA_uid431_rReal_uid16_fpComplexMulTest_b_2_q, clk => clk, aclr => areset );

    -- expInc_uid478_rReal_uid16_fpComplexMulTest(ADD,477)@5
    expInc_uid478_rReal_uid16_fpComplexMulTest_a <= STD_LOGIC_VECTOR("0" & redist26_expA_uid431_rReal_uid16_fpComplexMulTest_b_2_q);
    expInc_uid478_rReal_uid16_fpComplexMulTest_b <= STD_LOGIC_VECTOR("0" & oneCST_uid477_rReal_uid16_fpComplexMulTest_q);
    expInc_uid478_rReal_uid16_fpComplexMulTest_o <= STD_LOGIC_VECTOR(UNSIGNED(expInc_uid478_rReal_uid16_fpComplexMulTest_a) + UNSIGNED(expInc_uid478_rReal_uid16_fpComplexMulTest_b));
    expInc_uid478_rReal_uid16_fpComplexMulTest_q <= expInc_uid478_rReal_uid16_fpComplexMulTest_o(8 downto 0);

    -- expPostNorm_uid479_rReal_uid16_fpComplexMulTest(SUB,478)@5 + 1
    expPostNorm_uid479_rReal_uid16_fpComplexMulTest_a <= STD_LOGIC_VECTOR("0" & expInc_uid478_rReal_uid16_fpComplexMulTest_q);
    expPostNorm_uid479_rReal_uid16_fpComplexMulTest_b <= STD_LOGIC_VECTOR("00000" & r_uid741_lzCountVal_uid472_rReal_uid16_fpComplexMulTest_q);
    expPostNorm_uid479_rReal_uid16_fpComplexMulTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            expPostNorm_uid479_rReal_uid16_fpComplexMulTest_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            expPostNorm_uid479_rReal_uid16_fpComplexMulTest_o <= STD_LOGIC_VECTOR(UNSIGNED(expPostNorm_uid479_rReal_uid16_fpComplexMulTest_a) - UNSIGNED(expPostNorm_uid479_rReal_uid16_fpComplexMulTest_b));
        END IF;
    END PROCESS;
    expPostNorm_uid479_rReal_uid16_fpComplexMulTest_q <= expPostNorm_uid479_rReal_uid16_fpComplexMulTest_o(9 downto 0);

    -- fracPostNorm_uid476_rReal_uid16_fpComplexMulTest(BITSELECT,475)@5
    fracPostNorm_uid476_rReal_uid16_fpComplexMulTest_b <= leftShiftStage2_uid850_fracPostNormExt_uid475_rReal_uid16_fpComplexMulTest_q(27 downto 1);

    -- fracPostNormRndRange_uid489_rReal_uid16_fpComplexMulTest(BITSELECT,488)@5
    fracPostNormRndRange_uid489_rReal_uid16_fpComplexMulTest_in <= fracPostNorm_uid476_rReal_uid16_fpComplexMulTest_b(25 downto 0);
    fracPostNormRndRange_uid489_rReal_uid16_fpComplexMulTest_b <= fracPostNormRndRange_uid489_rReal_uid16_fpComplexMulTest_in(25 downto 2);

    -- redist16_fracPostNormRndRange_uid489_rReal_uid16_fpComplexMulTest_b_1(DELAY,953)
    redist16_fracPostNormRndRange_uid489_rReal_uid16_fpComplexMulTest_b_1 : dspba_delay
    GENERIC MAP ( width => 24, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracPostNormRndRange_uid489_rReal_uid16_fpComplexMulTest_b, xout => redist16_fracPostNormRndRange_uid489_rReal_uid16_fpComplexMulTest_b_1_q, clk => clk, aclr => areset );

    -- expFracR_uid490_rReal_uid16_fpComplexMulTest(BITJOIN,489)@6
    expFracR_uid490_rReal_uid16_fpComplexMulTest_q <= expPostNorm_uid479_rReal_uid16_fpComplexMulTest_q & redist16_fracPostNormRndRange_uid489_rReal_uid16_fpComplexMulTest_b_1_q;

    -- rndExpFrac_uid491_rReal_uid16_fpComplexMulTest(ADD,490)@6
    rndExpFrac_uid491_rReal_uid16_fpComplexMulTest_a <= STD_LOGIC_VECTOR("0" & expFracR_uid490_rReal_uid16_fpComplexMulTest_q);
    rndExpFrac_uid491_rReal_uid16_fpComplexMulTest_b <= STD_LOGIC_VECTOR("0000000000000000000000000000000000" & roundBit_uid488_rReal_uid16_fpComplexMulTest_q);
    rndExpFrac_uid491_rReal_uid16_fpComplexMulTest_o <= STD_LOGIC_VECTOR(UNSIGNED(rndExpFrac_uid491_rReal_uid16_fpComplexMulTest_a) + UNSIGNED(rndExpFrac_uid491_rReal_uid16_fpComplexMulTest_b));
    rndExpFrac_uid491_rReal_uid16_fpComplexMulTest_q <= rndExpFrac_uid491_rReal_uid16_fpComplexMulTest_o(34 downto 0);

    -- expRPreExc_uid504_rReal_uid16_fpComplexMulTest(BITSELECT,503)@6
    expRPreExc_uid504_rReal_uid16_fpComplexMulTest_in <= rndExpFrac_uid491_rReal_uid16_fpComplexMulTest_q(31 downto 0);
    expRPreExc_uid504_rReal_uid16_fpComplexMulTest_b <= expRPreExc_uid504_rReal_uid16_fpComplexMulTest_in(31 downto 24);

    -- rndExpFracOvfBits_uid496_rReal_uid16_fpComplexMulTest(BITSELECT,495)@6
    rndExpFracOvfBits_uid496_rReal_uid16_fpComplexMulTest_in <= rndExpFrac_uid491_rReal_uid16_fpComplexMulTest_q(33 downto 0);
    rndExpFracOvfBits_uid496_rReal_uid16_fpComplexMulTest_b <= rndExpFracOvfBits_uid496_rReal_uid16_fpComplexMulTest_in(33 downto 32);

    -- rOvfExtraBits_uid497_rReal_uid16_fpComplexMulTest(LOGICAL,496)@6
    rOvfExtraBits_uid497_rReal_uid16_fpComplexMulTest_q <= "1" WHEN rndExpFracOvfBits_uid496_rReal_uid16_fpComplexMulTest_b = one2b_uid387_rReal_uid16_fpComplexMulTest_q ELSE "0";

    -- rndExp_uid493_rReal_uid16_fpComplexMulTest(BITSELECT,492)@6
    rndExp_uid493_rReal_uid16_fpComplexMulTest_in <= rndExpFrac_uid491_rReal_uid16_fpComplexMulTest_q(33 downto 0);
    rndExp_uid493_rReal_uid16_fpComplexMulTest_b <= rndExp_uid493_rReal_uid16_fpComplexMulTest_in(33 downto 24);

    -- rOvfEQMax_uid494_rReal_uid16_fpComplexMulTest(LOGICAL,493)@6
    rOvfEQMax_uid494_rReal_uid16_fpComplexMulTest_q <= "1" WHEN rndExp_uid493_rReal_uid16_fpComplexMulTest_b = wEP2AllOwE_uid492_rReal_uid16_fpComplexMulTest_q ELSE "0";

    -- rOvf_uid498_rReal_uid16_fpComplexMulTest(LOGICAL,497)@6
    rOvf_uid498_rReal_uid16_fpComplexMulTest_q <= rOvfEQMax_uid494_rReal_uid16_fpComplexMulTest_q or rOvfExtraBits_uid497_rReal_uid16_fpComplexMulTest_q;

    -- redist30_excBR_uid429_rReal_uid16_fpComplexMulTest_q_1(DELAY,967)
    redist30_excBR_uid429_rReal_uid16_fpComplexMulTest_q_1 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => excBR_uid429_rReal_uid16_fpComplexMulTest_q, xout => redist30_excBR_uid429_rReal_uid16_fpComplexMulTest_q_1_q, clk => clk, aclr => areset );

    -- redist34_excAR_uid425_rReal_uid16_fpComplexMulTest_q_1(DELAY,971)
    redist34_excAR_uid425_rReal_uid16_fpComplexMulTest_q_1 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => excAR_uid425_rReal_uid16_fpComplexMulTest_q, xout => redist34_excAR_uid425_rReal_uid16_fpComplexMulTest_q_1_q, clk => clk, aclr => areset );

    -- regInputs_uid505_rReal_uid16_fpComplexMulTest(LOGICAL,504)@6
    regInputs_uid505_rReal_uid16_fpComplexMulTest_q <= redist34_excAR_uid425_rReal_uid16_fpComplexMulTest_q_1_q and redist30_excBR_uid429_rReal_uid16_fpComplexMulTest_q_1_q;

    -- redist33_excAZ_uid426_rReal_uid16_fpComplexMulTest_q_3(DELAY,970)
    redist33_excAZ_uid426_rReal_uid16_fpComplexMulTest_q_3 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => redist32_excAZ_uid426_rReal_uid16_fpComplexMulTest_q_2_q, xout => redist33_excAZ_uid426_rReal_uid16_fpComplexMulTest_q_3_q, clk => clk, aclr => areset );

    -- aZeroBRegFPLib_uid509_rReal_uid16_fpComplexMulTest(LOGICAL,508)@6
    aZeroBRegFPLib_uid509_rReal_uid16_fpComplexMulTest_q <= redist33_excAZ_uid426_rReal_uid16_fpComplexMulTest_q_3_q and redist30_excBR_uid429_rReal_uid16_fpComplexMulTest_q_1_q;

    -- redist29_excBZ_uid430_rReal_uid16_fpComplexMulTest_q_3(DELAY,966)
    redist29_excBZ_uid430_rReal_uid16_fpComplexMulTest_q_3 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => redist28_excBZ_uid430_rReal_uid16_fpComplexMulTest_q_2_q, xout => redist29_excBZ_uid430_rReal_uid16_fpComplexMulTest_q_3_q, clk => clk, aclr => areset );

    -- aRegBZeroFPLib_uid508_rReal_uid16_fpComplexMulTest(LOGICAL,507)@6
    aRegBZeroFPLib_uid508_rReal_uid16_fpComplexMulTest_q <= redist34_excAR_uid425_rReal_uid16_fpComplexMulTest_q_1_q and redist29_excBZ_uid430_rReal_uid16_fpComplexMulTest_q_3_q;

    -- fpLibRegInputs_uid510_rReal_uid16_fpComplexMulTest(LOGICAL,509)@6
    fpLibRegInputs_uid510_rReal_uid16_fpComplexMulTest_q <= aRegBZeroFPLib_uid508_rReal_uid16_fpComplexMulTest_q or aZeroBRegFPLib_uid509_rReal_uid16_fpComplexMulTest_q or regInputs_uid505_rReal_uid16_fpComplexMulTest_q;

    -- rInfOvf_uid511_rReal_uid16_fpComplexMulTest(LOGICAL,510)@6
    rInfOvf_uid511_rReal_uid16_fpComplexMulTest_q <= fpLibRegInputs_uid510_rReal_uid16_fpComplexMulTest_q and rOvf_uid498_rReal_uid16_fpComplexMulTest_q;

    -- excRInfVInC_uid512_rReal_uid16_fpComplexMulTest(BITJOIN,511)@6
    excRInfVInC_uid512_rReal_uid16_fpComplexMulTest_q <= rInfOvf_uid511_rReal_uid16_fpComplexMulTest_q & excBN_uid428_rReal_uid16_fpComplexMulTest_q & excAN_uid424_rReal_uid16_fpComplexMulTest_q & redist31_excBI_uid427_rReal_uid16_fpComplexMulTest_q_1_q & redist35_excAI_uid423_rReal_uid16_fpComplexMulTest_q_1_q & redist19_effSub_uid437_rReal_uid16_fpComplexMulTest_q_2_q;

    -- excRInf_uid513_rReal_uid16_fpComplexMulTest(LOOKUP,512)@6
    excRInf_uid513_rReal_uid16_fpComplexMulTest_combproc: PROCESS (excRInfVInC_uid512_rReal_uid16_fpComplexMulTest_q)
    BEGIN
        -- Begin reserved scope level
        CASE (excRInfVInC_uid512_rReal_uid16_fpComplexMulTest_q) IS
            WHEN "000000" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "000001" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "000010" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "1";
            WHEN "000011" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "1";
            WHEN "000100" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "1";
            WHEN "000101" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "1";
            WHEN "000110" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "1";
            WHEN "000111" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "001000" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "001001" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "001010" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "001011" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "001100" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "001101" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "001110" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "001111" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "010000" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "010001" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "010010" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "010011" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "010100" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "010101" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "010110" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "010111" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "011000" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "011001" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "011010" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "011011" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "011100" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "011101" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "011110" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "011111" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "100000" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "1";
            WHEN "100001" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "1";
            WHEN "100010" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "100011" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "100100" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "100101" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "100110" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "100111" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "101000" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "101001" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "101010" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "101011" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "101100" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "101101" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "101110" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "101111" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "110000" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "110001" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "110010" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "110011" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "110100" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "110101" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "110110" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "110111" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "111000" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "111001" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "111010" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "111011" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "111100" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "111101" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "111110" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "111111" => excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN OTHERS => -- unreachable
                           excRInf_uid513_rReal_uid16_fpComplexMulTest_q <= (others => '-');
        END CASE;
        -- End reserved scope level
    END PROCESS;

    -- redist17_aMinusA_uid474_rReal_uid16_fpComplexMulTest_q_1(DELAY,954)
    redist17_aMinusA_uid474_rReal_uid16_fpComplexMulTest_q_1 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => aMinusA_uid474_rReal_uid16_fpComplexMulTest_q, xout => redist17_aMinusA_uid474_rReal_uid16_fpComplexMulTest_q_1_q, clk => clk, aclr => areset );

    -- rUdfExtraBit_uid501_rReal_uid16_fpComplexMulTest(BITSELECT,500)@6
    rUdfExtraBit_uid501_rReal_uid16_fpComplexMulTest_in <= STD_LOGIC_VECTOR(rndExpFrac_uid491_rReal_uid16_fpComplexMulTest_q(33 downto 0));
    rUdfExtraBit_uid501_rReal_uid16_fpComplexMulTest_b <= STD_LOGIC_VECTOR(rUdfExtraBit_uid501_rReal_uid16_fpComplexMulTest_in(33 downto 33));

    -- rUdfEQMin_uid500_rReal_uid16_fpComplexMulTest(LOGICAL,499)@6
    rUdfEQMin_uid500_rReal_uid16_fpComplexMulTest_q <= "1" WHEN rndExp_uid493_rReal_uid16_fpComplexMulTest_b = wEP2AllZ_uid499_rReal_uid16_fpComplexMulTest_q ELSE "0";

    -- rUdf_uid502_rReal_uid16_fpComplexMulTest(LOGICAL,501)@6
    rUdf_uid502_rReal_uid16_fpComplexMulTest_q <= rUdfEQMin_uid500_rReal_uid16_fpComplexMulTest_q or rUdfExtraBit_uid501_rReal_uid16_fpComplexMulTest_b;

    -- excRZeroVInC_uid506_rReal_uid16_fpComplexMulTest(BITJOIN,505)@6
    excRZeroVInC_uid506_rReal_uid16_fpComplexMulTest_q <= redist17_aMinusA_uid474_rReal_uid16_fpComplexMulTest_q_1_q & rUdf_uid502_rReal_uid16_fpComplexMulTest_q & regInputs_uid505_rReal_uid16_fpComplexMulTest_q & redist29_excBZ_uid430_rReal_uid16_fpComplexMulTest_q_3_q & redist33_excAZ_uid426_rReal_uid16_fpComplexMulTest_q_3_q;

    -- excRZero_uid507_rReal_uid16_fpComplexMulTest(LOOKUP,506)@6
    excRZero_uid507_rReal_uid16_fpComplexMulTest_combproc: PROCESS (excRZeroVInC_uid506_rReal_uid16_fpComplexMulTest_q)
    BEGIN
        -- Begin reserved scope level
        CASE (excRZeroVInC_uid506_rReal_uid16_fpComplexMulTest_q) IS
            WHEN "00000" => excRZero_uid507_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "00001" => excRZero_uid507_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "00010" => excRZero_uid507_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "00011" => excRZero_uid507_rReal_uid16_fpComplexMulTest_q <= "1";
            WHEN "00100" => excRZero_uid507_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "00101" => excRZero_uid507_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "00110" => excRZero_uid507_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "00111" => excRZero_uid507_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "01000" => excRZero_uid507_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "01001" => excRZero_uid507_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "01010" => excRZero_uid507_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "01011" => excRZero_uid507_rReal_uid16_fpComplexMulTest_q <= "1";
            WHEN "01100" => excRZero_uid507_rReal_uid16_fpComplexMulTest_q <= "1";
            WHEN "01101" => excRZero_uid507_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "01110" => excRZero_uid507_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "01111" => excRZero_uid507_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "10000" => excRZero_uid507_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "10001" => excRZero_uid507_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "10010" => excRZero_uid507_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "10011" => excRZero_uid507_rReal_uid16_fpComplexMulTest_q <= "1";
            WHEN "10100" => excRZero_uid507_rReal_uid16_fpComplexMulTest_q <= "1";
            WHEN "10101" => excRZero_uid507_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "10110" => excRZero_uid507_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "10111" => excRZero_uid507_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "11000" => excRZero_uid507_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "11001" => excRZero_uid507_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "11010" => excRZero_uid507_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "11011" => excRZero_uid507_rReal_uid16_fpComplexMulTest_q <= "1";
            WHEN "11100" => excRZero_uid507_rReal_uid16_fpComplexMulTest_q <= "1";
            WHEN "11101" => excRZero_uid507_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "11110" => excRZero_uid507_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN "11111" => excRZero_uid507_rReal_uid16_fpComplexMulTest_q <= "0";
            WHEN OTHERS => -- unreachable
                           excRZero_uid507_rReal_uid16_fpComplexMulTest_q <= (others => '-');
        END CASE;
        -- End reserved scope level
    END PROCESS;

    -- concExc_uid517_rReal_uid16_fpComplexMulTest(BITJOIN,516)@6
    concExc_uid517_rReal_uid16_fpComplexMulTest_q <= excRNaN_uid516_rReal_uid16_fpComplexMulTest_q & excRInf_uid513_rReal_uid16_fpComplexMulTest_q & excRZero_uid507_rReal_uid16_fpComplexMulTest_q;

    -- excREnc_uid518_rReal_uid16_fpComplexMulTest(LOOKUP,517)@6
    excREnc_uid518_rReal_uid16_fpComplexMulTest_combproc: PROCESS (concExc_uid517_rReal_uid16_fpComplexMulTest_q)
    BEGIN
        -- Begin reserved scope level
        CASE (concExc_uid517_rReal_uid16_fpComplexMulTest_q) IS
            WHEN "000" => excREnc_uid518_rReal_uid16_fpComplexMulTest_q <= "01";
            WHEN "001" => excREnc_uid518_rReal_uid16_fpComplexMulTest_q <= "00";
            WHEN "010" => excREnc_uid518_rReal_uid16_fpComplexMulTest_q <= "10";
            WHEN "011" => excREnc_uid518_rReal_uid16_fpComplexMulTest_q <= "10";
            WHEN "100" => excREnc_uid518_rReal_uid16_fpComplexMulTest_q <= "11";
            WHEN "101" => excREnc_uid518_rReal_uid16_fpComplexMulTest_q <= "11";
            WHEN "110" => excREnc_uid518_rReal_uid16_fpComplexMulTest_q <= "11";
            WHEN "111" => excREnc_uid518_rReal_uid16_fpComplexMulTest_q <= "11";
            WHEN OTHERS => -- unreachable
                           excREnc_uid518_rReal_uid16_fpComplexMulTest_q <= (others => '-');
        END CASE;
        -- End reserved scope level
    END PROCESS;

    -- expRPostExc_uid537_rReal_uid16_fpComplexMulTest(MUX,536)@6
    expRPostExc_uid537_rReal_uid16_fpComplexMulTest_s <= excREnc_uid518_rReal_uid16_fpComplexMulTest_q;
    expRPostExc_uid537_rReal_uid16_fpComplexMulTest_combproc: PROCESS (expRPostExc_uid537_rReal_uid16_fpComplexMulTest_s, cstAllZWE_uid26_ac_uid6_fpComplexMulTest_q, expRPreExc_uid504_rReal_uid16_fpComplexMulTest_b, cstAllOWE_uid24_ac_uid6_fpComplexMulTest_q)
    BEGIN
        CASE (expRPostExc_uid537_rReal_uid16_fpComplexMulTest_s) IS
            WHEN "00" => expRPostExc_uid537_rReal_uid16_fpComplexMulTest_q <= cstAllZWE_uid26_ac_uid6_fpComplexMulTest_q;
            WHEN "01" => expRPostExc_uid537_rReal_uid16_fpComplexMulTest_q <= expRPreExc_uid504_rReal_uid16_fpComplexMulTest_b;
            WHEN "10" => expRPostExc_uid537_rReal_uid16_fpComplexMulTest_q <= cstAllOWE_uid24_ac_uid6_fpComplexMulTest_q;
            WHEN "11" => expRPostExc_uid537_rReal_uid16_fpComplexMulTest_q <= cstAllOWE_uid24_ac_uid6_fpComplexMulTest_q;
            WHEN OTHERS => expRPostExc_uid537_rReal_uid16_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- fracRPreExc_uid503_rReal_uid16_fpComplexMulTest(BITSELECT,502)@6
    fracRPreExc_uid503_rReal_uid16_fpComplexMulTest_in <= rndExpFrac_uid491_rReal_uid16_fpComplexMulTest_q(23 downto 0);
    fracRPreExc_uid503_rReal_uid16_fpComplexMulTest_b <= fracRPreExc_uid503_rReal_uid16_fpComplexMulTest_in(23 downto 1);

    -- fracRPostExc_uid533_rReal_uid16_fpComplexMulTest(MUX,532)@6
    fracRPostExc_uid533_rReal_uid16_fpComplexMulTest_s <= excREnc_uid518_rReal_uid16_fpComplexMulTest_q;
    fracRPostExc_uid533_rReal_uid16_fpComplexMulTest_combproc: PROCESS (fracRPostExc_uid533_rReal_uid16_fpComplexMulTest_s, cstZeroWF_uid25_ac_uid6_fpComplexMulTest_q, fracRPreExc_uid503_rReal_uid16_fpComplexMulTest_b, oneFracRPostExc2_uid530_rReal_uid16_fpComplexMulTest_q)
    BEGIN
        CASE (fracRPostExc_uid533_rReal_uid16_fpComplexMulTest_s) IS
            WHEN "00" => fracRPostExc_uid533_rReal_uid16_fpComplexMulTest_q <= cstZeroWF_uid25_ac_uid6_fpComplexMulTest_q;
            WHEN "01" => fracRPostExc_uid533_rReal_uid16_fpComplexMulTest_q <= fracRPreExc_uid503_rReal_uid16_fpComplexMulTest_b;
            WHEN "10" => fracRPostExc_uid533_rReal_uid16_fpComplexMulTest_q <= cstZeroWF_uid25_ac_uid6_fpComplexMulTest_q;
            WHEN "11" => fracRPostExc_uid533_rReal_uid16_fpComplexMulTest_q <= oneFracRPostExc2_uid530_rReal_uid16_fpComplexMulTest_q;
            WHEN OTHERS => fracRPostExc_uid533_rReal_uid16_fpComplexMulTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- R_uid538_rReal_uid16_fpComplexMulTest(BITJOIN,537)@6
    R_uid538_rReal_uid16_fpComplexMulTest_q <= signRPostExc_uid529_rReal_uid16_fpComplexMulTest_q & expRPostExc_uid537_rReal_uid16_fpComplexMulTest_q & fracRPostExc_uid533_rReal_uid16_fpComplexMulTest_q;

    -- xOut(GPOUT,4)@6
    q <= R_uid538_rReal_uid16_fpComplexMulTest_q;
    r <= R_uid698_rImag_uid17_fpComplexMulTest_q;

END normal;
