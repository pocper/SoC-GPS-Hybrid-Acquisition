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

-- VHDL created from FP_hypotenuse_0002
-- VHDL created on Sat Feb 21 22:28:05 2026


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

entity FP_hypotenuse_0002 is
    port (
        a : in std_logic_vector(31 downto 0);  -- float32_m23
        b : in std_logic_vector(31 downto 0);  -- float32_m23
        c : in std_logic_vector(31 downto 0);  -- float32_m23
        q : out std_logic_vector(31 downto 0);  -- float32_m23
        clk : in std_logic;
        areset : in std_logic
    );
end FP_hypotenuse_0002;

architecture normal of FP_hypotenuse_0002 is

    attribute altera_attribute : string;
    attribute altera_attribute of normal : architecture is "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF; -name PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 10037; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 15400; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 12020; -name MESSAGE_DISABLE 12030; -name MESSAGE_DISABLE 12010; -name MESSAGE_DISABLE 12110; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 13410; -name MESSAGE_DISABLE 113007";
    
    signal GND_q : STD_LOGIC_VECTOR (0 downto 0);
    signal VCC_q : STD_LOGIC_VECTOR (0 downto 0);
    signal cstAllOWE_uid12_fpHypot3dTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal cstZeroWF_uid13_fpHypot3dTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal cstAllZWE_uid14_fpHypot3dTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal excZ_x_uid17_fpHypot3dTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expXIsMax_uid18_fpHypot3dTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid19_fpHypot3dTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid19_fpHypot3dTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsNotZero_uid20_fpHypot3dTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excI_x_uid21_fpHypot3dTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excN_x_uid22_fpHypot3dTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal excN_x_uid22_fpHypot3dTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invExpXIsMax_uid23_fpHypot3dTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal InvExpXIsZero_uid24_fpHypot3dTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excR_x_uid25_fpHypot3dTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excZ_y_uid31_fpHypot3dTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expXIsMax_uid32_fpHypot3dTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid33_fpHypot3dTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid33_fpHypot3dTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsNotZero_uid34_fpHypot3dTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excI_y_uid35_fpHypot3dTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excN_y_uid36_fpHypot3dTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal excN_y_uid36_fpHypot3dTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invExpXIsMax_uid37_fpHypot3dTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal InvExpXIsZero_uid38_fpHypot3dTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excR_y_uid39_fpHypot3dTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excZ_z_uid45_fpHypot3dTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expXIsMax_uid46_fpHypot3dTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid47_fpHypot3dTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid47_fpHypot3dTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsNotZero_uid48_fpHypot3dTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excI_z_uid49_fpHypot3dTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excN_z_uid50_fpHypot3dTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal excN_z_uid50_fpHypot3dTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invExpXIsMax_uid51_fpHypot3dTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal InvExpXIsZero_uid52_fpHypot3dTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excR_z_uid53_fpHypot3dTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal oFracX_uid55_fpHypot3dTest_q : STD_LOGIC_VECTOR (23 downto 0);
    signal oFracY_uid56_fpHypot3dTest_q : STD_LOGIC_VECTOR (23 downto 0);
    signal oFracZ_uid57_fpHypot3dTest_q : STD_LOGIC_VECTOR (23 downto 0);
    signal bias_uid61_fpHypot3dTest_q : STD_LOGIC_VECTOR (6 downto 0);
    signal normBitXSqr_uid62_fpHypot3dTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal normBitYSqr_uid63_fpHypot3dTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal normBitZSqr_uid64_fpHypot3dTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal expXTimes2_uid65_fpHypot3dTest_q : STD_LOGIC_VECTOR (8 downto 0);
    signal expYTimes2_uid67_fpHypot3dTest_q : STD_LOGIC_VECTOR (8 downto 0);
    signal expZTimes2_uid69_fpHypot3dTest_q : STD_LOGIC_VECTOR (8 downto 0);
    signal expP_uid71_fpHypot3dTest_a : STD_LOGIC_VECTOR (9 downto 0);
    signal expP_uid71_fpHypot3dTest_b : STD_LOGIC_VECTOR (9 downto 0);
    signal expP_uid71_fpHypot3dTest_o : STD_LOGIC_VECTOR (9 downto 0);
    signal expP_uid71_fpHypot3dTest_q : STD_LOGIC_VECTOR (9 downto 0);
    signal expQ_uid72_fpHypot3dTest_a : STD_LOGIC_VECTOR (9 downto 0);
    signal expQ_uid72_fpHypot3dTest_b : STD_LOGIC_VECTOR (9 downto 0);
    signal expQ_uid72_fpHypot3dTest_o : STD_LOGIC_VECTOR (9 downto 0);
    signal expQ_uid72_fpHypot3dTest_q : STD_LOGIC_VECTOR (9 downto 0);
    signal expS_uid73_fpHypot3dTest_a : STD_LOGIC_VECTOR (9 downto 0);
    signal expS_uid73_fpHypot3dTest_b : STD_LOGIC_VECTOR (9 downto 0);
    signal expS_uid73_fpHypot3dTest_o : STD_LOGIC_VECTOR (9 downto 0);
    signal expS_uid73_fpHypot3dTest_q : STD_LOGIC_VECTOR (9 downto 0);
    signal normFracXSqrHigh_uid74_fpHypot3dTest_b : STD_LOGIC_VECTOR (23 downto 0);
    signal normFracXSqrLow_uid75_fpHypot3dTest_in : STD_LOGIC_VECTOR (46 downto 0);
    signal normFracXSqrLow_uid75_fpHypot3dTest_b : STD_LOGIC_VECTOR (23 downto 0);
    signal ofracP_uid76_fpHypot3dTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal ofracP_uid76_fpHypot3dTest_q : STD_LOGIC_VECTOR (23 downto 0);
    signal normFracYSqrHigh_uid77_fpHypot3dTest_b : STD_LOGIC_VECTOR (23 downto 0);
    signal normFracYSqrLow_uid78_fpHypot3dTest_in : STD_LOGIC_VECTOR (46 downto 0);
    signal normFracYSqrLow_uid78_fpHypot3dTest_b : STD_LOGIC_VECTOR (23 downto 0);
    signal ofracQ_uid79_fpHypot3dTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal ofracQ_uid79_fpHypot3dTest_q : STD_LOGIC_VECTOR (23 downto 0);
    signal normFracZSqrHigh_uid80_fpHypot3dTest_b : STD_LOGIC_VECTOR (23 downto 0);
    signal normFracZSqrLow_uid81_fpHypot3dTest_in : STD_LOGIC_VECTOR (46 downto 0);
    signal normFracZSqrLow_uid81_fpHypot3dTest_b : STD_LOGIC_VECTOR (23 downto 0);
    signal ofracS_uid82_fpHypot3dTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal ofracS_uid82_fpHypot3dTest_q : STD_LOGIC_VECTOR (23 downto 0);
    signal pGTEq_uid83_fpHypot3dTest_a : STD_LOGIC_VECTOR (11 downto 0);
    signal pGTEq_uid83_fpHypot3dTest_b : STD_LOGIC_VECTOR (11 downto 0);
    signal pGTEq_uid83_fpHypot3dTest_o : STD_LOGIC_VECTOR (11 downto 0);
    signal pGTEq_uid83_fpHypot3dTest_n : STD_LOGIC_VECTOR (0 downto 0);
    signal expCmpGtePQ_uid84_fpHypot3dTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal pGTEs_uid85_fpHypot3dTest_a : STD_LOGIC_VECTOR (11 downto 0);
    signal pGTEs_uid85_fpHypot3dTest_b : STD_LOGIC_VECTOR (11 downto 0);
    signal pGTEs_uid85_fpHypot3dTest_o : STD_LOGIC_VECTOR (11 downto 0);
    signal pGTEs_uid85_fpHypot3dTest_n : STD_LOGIC_VECTOR (0 downto 0);
    signal expCmpGtePS_uid86_fpHypot3dTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal qGTEs_uid87_fpHypot3dTest_a : STD_LOGIC_VECTOR (11 downto 0);
    signal qGTEs_uid87_fpHypot3dTest_b : STD_LOGIC_VECTOR (11 downto 0);
    signal qGTEs_uid87_fpHypot3dTest_o : STD_LOGIC_VECTOR (11 downto 0);
    signal qGTEs_uid87_fpHypot3dTest_n : STD_LOGIC_VECTOR (0 downto 0);
    signal expCmpGteQS_uid88_fpHypot3dTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal concCompareExpRes_uid89_fpHypot3dTest_q : STD_LOGIC_VECTOR (2 downto 0);
    signal selATab_uid90_fpHypot3dTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal selBTab_uid91_fpHypot3dTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal selCTab_uid92_fpHypot3dTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal expA_uid93_fpHypot3dTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal expA_uid93_fpHypot3dTest_q : STD_LOGIC_VECTOR (9 downto 0);
    signal expB_uid94_fpHypot3dTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal expB_uid94_fpHypot3dTest_q : STD_LOGIC_VECTOR (9 downto 0);
    signal expC_uid95_fpHypot3dTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal expC_uid95_fpHypot3dTest_q : STD_LOGIC_VECTOR (9 downto 0);
    signal expAmB_uid96_fpHypot3dTest_a : STD_LOGIC_VECTOR (10 downto 0);
    signal expAmB_uid96_fpHypot3dTest_b : STD_LOGIC_VECTOR (10 downto 0);
    signal expAmB_uid96_fpHypot3dTest_o : STD_LOGIC_VECTOR (10 downto 0);
    signal expAmB_uid96_fpHypot3dTest_q : STD_LOGIC_VECTOR (10 downto 0);
    signal expAmC_uid97_fpHypot3dTest_a : STD_LOGIC_VECTOR (10 downto 0);
    signal expAmC_uid97_fpHypot3dTest_b : STD_LOGIC_VECTOR (10 downto 0);
    signal expAmC_uid97_fpHypot3dTest_o : STD_LOGIC_VECTOR (10 downto 0);
    signal expAmC_uid97_fpHypot3dTest_q : STD_LOGIC_VECTOR (10 downto 0);
    signal cWFP2_uid98_fpHypot3dTest_q : STD_LOGIC_VECTOR (5 downto 0);
    signal shiftedOutB_uid99_fpHypot3dTest_a : STD_LOGIC_VECTOR (12 downto 0);
    signal shiftedOutB_uid99_fpHypot3dTest_b : STD_LOGIC_VECTOR (12 downto 0);
    signal shiftedOutB_uid99_fpHypot3dTest_o : STD_LOGIC_VECTOR (12 downto 0);
    signal shiftedOutB_uid99_fpHypot3dTest_n : STD_LOGIC_VECTOR (0 downto 0);
    signal shiftedOutC_uid101_fpHypot3dTest_a : STD_LOGIC_VECTOR (12 downto 0);
    signal shiftedOutC_uid101_fpHypot3dTest_b : STD_LOGIC_VECTOR (12 downto 0);
    signal shiftedOutC_uid101_fpHypot3dTest_o : STD_LOGIC_VECTOR (12 downto 0);
    signal shiftedOutC_uid101_fpHypot3dTest_n : STD_LOGIC_VECTOR (0 downto 0);
    signal oFracA_uid102_fpHypot3dTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal oFracA_uid102_fpHypot3dTest_q : STD_LOGIC_VECTOR (23 downto 0);
    signal oFracB_uid103_fpHypot3dTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal oFracB_uid103_fpHypot3dTest_q : STD_LOGIC_VECTOR (23 downto 0);
    signal oFracC_uid104_fpHypot3dTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal oFracC_uid104_fpHypot3dTest_q : STD_LOGIC_VECTOR (23 downto 0);
    signal cstbfvZwfp1_uid105_fpHypot3dTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal expDiffShiftRangeB_uid106_fpHypot3dTest_in : STD_LOGIC_VECTOR (4 downto 0);
    signal expDiffShiftRangeB_uid106_fpHypot3dTest_b : STD_LOGIC_VECTOR (4 downto 0);
    signal shiftValueB_uid107_fpHypot3dTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal shiftValueB_uid107_fpHypot3dTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal expDiffShiftRangeC_uid108_fpHypot3dTest_in : STD_LOGIC_VECTOR (4 downto 0);
    signal expDiffShiftRangeC_uid108_fpHypot3dTest_b : STD_LOGIC_VECTOR (4 downto 0);
    signal shiftValueC_uid109_fpHypot3dTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal shiftValueC_uid109_fpHypot3dTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal excAZero_uid110_fpHypot3dTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal excAZero_uid110_fpHypot3dTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excBZero_uid111_fpHypot3dTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal excBZero_uid111_fpHypot3dTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excCZero_uid112_fpHypot3dTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal excCZero_uid112_fpHypot3dTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal oFracBFlushToZero_uid113_fpHypot3dTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal oFracCFlushToZero_uid114_fpHypot3dTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal zerosWFp1_uid115_fpHypot3dTest_q : STD_LOGIC_VECTOR (23 downto 0);
    signal oFracCPostExc_uid116_fpHypot3dTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal oFracCPostExc_uid116_fpHypot3dTest_q : STD_LOGIC_VECTOR (23 downto 0);
    signal oFracBPostExc_uid117_fpHypot3dTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal oFracBPostExc_uid117_fpHypot3dTest_q : STD_LOGIC_VECTOR (23 downto 0);
    signal oFracAPostExc_uid118_fpHypot3dTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal oFracAPostExc_uid118_fpHypot3dTest_q : STD_LOGIC_VECTOR (23 downto 0);
    signal cstZ2_uid119_fpHypot3dTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal oFracBPostExcG_uid120_fpHypot3dTest_q : STD_LOGIC_VECTOR (25 downto 0);
    signal oFracBPostExcG_uid122_fpHypot3dTest_q : STD_LOGIC_VECTOR (25 downto 0);
    signal pad_oFracAPostExc_uid118_uid126_fpHypot3dTest_q : STD_LOGIC_VECTOR (25 downto 0);
    signal soSPreNorm_uid126_fpHypot3dTest_a : STD_LOGIC_VECTOR (27 downto 0);
    signal soSPreNorm_uid126_fpHypot3dTest_b : STD_LOGIC_VECTOR (27 downto 0);
    signal soSPreNorm_uid126_fpHypot3dTest_c : STD_LOGIC_VECTOR (27 downto 0);
    signal soSPreNorm_uid126_fpHypot3dTest_o : STD_LOGIC_VECTOR (27 downto 0);
    signal soSPreNorm_uid126_fpHypot3dTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal sumOfSquareNormBits_uid128_fpHypot3dTest_b : STD_LOGIC_VECTOR (1 downto 0);
    signal soSRangeHigh_uid129_fpHypot3dTest_in : STD_LOGIC_VECTOR (26 downto 0);
    signal soSRangeHigh_uid129_fpHypot3dTest_b : STD_LOGIC_VECTOR (23 downto 0);
    signal soSRangeMed_uid130_fpHypot3dTest_in : STD_LOGIC_VECTOR (25 downto 0);
    signal soSRangeMed_uid130_fpHypot3dTest_b : STD_LOGIC_VECTOR (23 downto 0);
    signal soSRangeLow_uid131_fpHypot3dTest_in : STD_LOGIC_VECTOR (24 downto 0);
    signal soSRangeLow_uid131_fpHypot3dTest_b : STD_LOGIC_VECTOR (23 downto 0);
    signal resFracNorm_uid132_fpHypot3dTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal resFracNorm_uid132_fpHypot3dTest_q : STD_LOGIC_VECTOR (23 downto 0);
    signal expCatRndBit_uid135_fpHypot3dTest_q : STD_LOGIC_VECTOR (33 downto 0);
    signal cst01_2_uid136_fpHypot3dTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal cst10_2_uid137_fpHypot3dTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal expUpdateVal_uid138_fpHypot3dTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal expUpdateVal_uid138_fpHypot3dTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal normCatFracSoS_uid140_fpHypot3dTest_q : STD_LOGIC_VECTOR (25 downto 0);
    signal expFracPostNorm_uid141_fpHypot3dTest_a : STD_LOGIC_VECTOR (35 downto 0);
    signal expFracPostNorm_uid141_fpHypot3dTest_b : STD_LOGIC_VECTOR (35 downto 0);
    signal expFracPostNorm_uid141_fpHypot3dTest_o : STD_LOGIC_VECTOR (35 downto 0);
    signal expFracPostNorm_uid141_fpHypot3dTest_q : STD_LOGIC_VECTOR (34 downto 0);
    signal fracRPreSqrt_uid142_fpHypot3dTest_in : STD_LOGIC_VECTOR (23 downto 0);
    signal fracRPreSqrt_uid142_fpHypot3dTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal expRPreSqrt_uid143_fpHypot3dTest_in : STD_LOGIC_VECTOR (33 downto 0);
    signal expRPreSqrt_uid143_fpHypot3dTest_b : STD_LOGIC_VECTOR (9 downto 0);
    signal expSumOfSquaresUnbiased_uid144_fpHypot3dTest_a : STD_LOGIC_VECTOR (11 downto 0);
    signal expSumOfSquaresUnbiased_uid144_fpHypot3dTest_b : STD_LOGIC_VECTOR (11 downto 0);
    signal expSumOfSquaresUnbiased_uid144_fpHypot3dTest_o : STD_LOGIC_VECTOR (11 downto 0);
    signal expSumOfSquaresUnbiased_uid144_fpHypot3dTest_q : STD_LOGIC_VECTOR (10 downto 0);
    signal expREven_uid145_fpHypot3dTest_b : STD_LOGIC_VECTOR (9 downto 0);
    signal biasP1Signal_uid146_fpHypot3dTest_q : STD_LOGIC_VECTOR (6 downto 0);
    signal expOddSig_uid147_fpHypot3dTest_a : STD_LOGIC_VECTOR (11 downto 0);
    signal expOddSig_uid147_fpHypot3dTest_b : STD_LOGIC_VECTOR (11 downto 0);
    signal expOddSig_uid147_fpHypot3dTest_o : STD_LOGIC_VECTOR (11 downto 0);
    signal expOddSig_uid147_fpHypot3dTest_q : STD_LOGIC_VECTOR (10 downto 0);
    signal expROdd_uid148_fpHypot3dTest_b : STD_LOGIC_VECTOR (9 downto 0);
    signal x0_uid149_fpHypot3dTest_in : STD_LOGIC_VECTOR (0 downto 0);
    signal x0_uid149_fpHypot3dTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal expOddSelect_uid151_fpHypot3dTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expRMux_uid152_fpHypot3dTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal expRMux_uid152_fpHypot3dTest_q : STD_LOGIC_VECTOR (9 downto 0);
    signal addrFull_uid153_fpHypot3dTest_q : STD_LOGIC_VECTOR (23 downto 0);
    signal yAddr_uid155_fpHypot3dTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal yy_uid156_fpHypot3dTest_in : STD_LOGIC_VECTOR (15 downto 0);
    signal yy_uid156_fpHypot3dTest_b : STD_LOGIC_VECTOR (15 downto 0);
    signal fracRPreInc_uid158_fpHypot3dTest_in : STD_LOGIC_VECTOR (30 downto 0);
    signal fracRPreInc_uid158_fpHypot3dTest_b : STD_LOGIC_VECTOR (25 downto 0);
    signal fracRPostInc_uid161_fpHypot3dTest_a : STD_LOGIC_VECTOR (26 downto 0);
    signal fracRPostInc_uid161_fpHypot3dTest_b : STD_LOGIC_VECTOR (26 downto 0);
    signal fracRPostInc_uid161_fpHypot3dTest_o : STD_LOGIC_VECTOR (26 downto 0);
    signal fracRPostInc_uid161_fpHypot3dTest_q : STD_LOGIC_VECTOR (26 downto 0);
    signal fracR_uid162_fpHypot3dTest_in : STD_LOGIC_VECTOR (23 downto 0);
    signal fracR_uid162_fpHypot3dTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal fracRPostIncMSBU_uid163_fpHypot3dTest_in : STD_LOGIC_VECTOR (25 downto 0);
    signal fracRPostIncMSBU_uid163_fpHypot3dTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal expRPostInc_uid164_fpHypot3dTest_a : STD_LOGIC_VECTOR (11 downto 0);
    signal expRPostInc_uid164_fpHypot3dTest_b : STD_LOGIC_VECTOR (11 downto 0);
    signal expRPostInc_uid164_fpHypot3dTest_o : STD_LOGIC_VECTOR (11 downto 0);
    signal expRPostInc_uid164_fpHypot3dTest_q : STD_LOGIC_VECTOR (10 downto 0);
    signal sqrtUnderflow_uid165_fpHypot3dTest_a : STD_LOGIC_VECTOR (12 downto 0);
    signal sqrtUnderflow_uid165_fpHypot3dTest_b : STD_LOGIC_VECTOR (12 downto 0);
    signal sqrtUnderflow_uid165_fpHypot3dTest_o : STD_LOGIC_VECTOR (12 downto 0);
    signal sqrtUnderflow_uid165_fpHypot3dTest_n : STD_LOGIC_VECTOR (0 downto 0);
    signal sqrtOverflow_uid167_fpHypot3dTest_a : STD_LOGIC_VECTOR (12 downto 0);
    signal sqrtOverflow_uid167_fpHypot3dTest_b : STD_LOGIC_VECTOR (12 downto 0);
    signal sqrtOverflow_uid167_fpHypot3dTest_o : STD_LOGIC_VECTOR (12 downto 0);
    signal sqrtOverflow_uid167_fpHypot3dTest_n : STD_LOGIC_VECTOR (0 downto 0);
    signal excXYZ_uid168_fpHypot3dTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal excXYZ_uid168_fpHypot3dTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal oneIsInf_uid169_fpHypot3dTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal oneIsInf_uid169_fpHypot3dTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal noneInf_uid170_fpHypot3dTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal onIsReg_uid171_fpHypot3dTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal onIsReg_uid171_fpHypot3dTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excXYRUdf_uid172_fpHypot3dTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRZero_uid173_fpHypot3dTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invExcZN_uid174_fpHypot3dTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invExcYN_uid175_fpHypot3dTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invExcXN_uid176_fpHypot3dTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRInf_uid177_fpHypot3dTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRNaN_uid178_fpHypot3dTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excSelBits_uid179_fpHypot3dTest_q : STD_LOGIC_VECTOR (2 downto 0);
    signal outMuxSelEnc_uid180_fpHypot3dTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal NaNFracRPostExc_uid181_fpHypot3dTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal fracRPostExc_uid185_fpHypot3dTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal fracRPostExc_uid185_fpHypot3dTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal expRPreExc_uid188_fpHypot3dTest_in : STD_LOGIC_VECTOR (7 downto 0);
    signal expRPreExc_uid188_fpHypot3dTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal expRPostExc_uid190_fpHypot3dTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal expRPostExc_uid190_fpHypot3dTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal RHypot_uid191_fpHypot3dTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal yT1_uid205_invPolyEval_b : STD_LOGIC_VECTOR (11 downto 0);
    signal lowRangeB_uid207_invPolyEval_in : STD_LOGIC_VECTOR (0 downto 0);
    signal lowRangeB_uid207_invPolyEval_b : STD_LOGIC_VECTOR (0 downto 0);
    signal highBBits_uid208_invPolyEval_b : STD_LOGIC_VECTOR (11 downto 0);
    signal s1sumAHighB_uid209_invPolyEval_a : STD_LOGIC_VECTOR (21 downto 0);
    signal s1sumAHighB_uid209_invPolyEval_b : STD_LOGIC_VECTOR (21 downto 0);
    signal s1sumAHighB_uid209_invPolyEval_o : STD_LOGIC_VECTOR (21 downto 0);
    signal s1sumAHighB_uid209_invPolyEval_q : STD_LOGIC_VECTOR (21 downto 0);
    signal s1_uid210_invPolyEval_q : STD_LOGIC_VECTOR (22 downto 0);
    signal lowRangeB_uid213_invPolyEval_in : STD_LOGIC_VECTOR (1 downto 0);
    signal lowRangeB_uid213_invPolyEval_b : STD_LOGIC_VECTOR (1 downto 0);
    signal highBBits_uid214_invPolyEval_b : STD_LOGIC_VECTOR (21 downto 0);
    signal s2sumAHighB_uid215_invPolyEval_a : STD_LOGIC_VECTOR (29 downto 0);
    signal s2sumAHighB_uid215_invPolyEval_b : STD_LOGIC_VECTOR (29 downto 0);
    signal s2sumAHighB_uid215_invPolyEval_o : STD_LOGIC_VECTOR (29 downto 0);
    signal s2sumAHighB_uid215_invPolyEval_q : STD_LOGIC_VECTOR (29 downto 0);
    signal s2_uid216_invPolyEval_q : STD_LOGIC_VECTOR (31 downto 0);
    signal osig_uid219_pT1_uid206_invPolyEval_b : STD_LOGIC_VECTOR (12 downto 0);
    signal osig_uid222_pT2_uid212_invPolyEval_b : STD_LOGIC_VECTOR (23 downto 0);
    signal rightShiftStage0Idx1Rng8_uid226_alignFracB_uid124_fpHypot3dTest_b : STD_LOGIC_VECTOR (17 downto 0);
    signal rightShiftStage0Idx1_uid228_alignFracB_uid124_fpHypot3dTest_q : STD_LOGIC_VECTOR (25 downto 0);
    signal rightShiftStage0Idx2Rng16_uid229_alignFracB_uid124_fpHypot3dTest_b : STD_LOGIC_VECTOR (9 downto 0);
    signal rightShiftStage0Idx2Pad16_uid230_alignFracB_uid124_fpHypot3dTest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal rightShiftStage0Idx2_uid231_alignFracB_uid124_fpHypot3dTest_q : STD_LOGIC_VECTOR (25 downto 0);
    signal rightShiftStage0Idx3Rng24_uid232_alignFracB_uid124_fpHypot3dTest_b : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStage0Idx3_uid234_alignFracB_uid124_fpHypot3dTest_q : STD_LOGIC_VECTOR (25 downto 0);
    signal rightShiftStage0_uid236_alignFracB_uid124_fpHypot3dTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStage0_uid236_alignFracB_uid124_fpHypot3dTest_q : STD_LOGIC_VECTOR (25 downto 0);
    signal rightShiftStage1Idx1Rng2_uid237_alignFracB_uid124_fpHypot3dTest_b : STD_LOGIC_VECTOR (23 downto 0);
    signal rightShiftStage1Idx1_uid239_alignFracB_uid124_fpHypot3dTest_q : STD_LOGIC_VECTOR (25 downto 0);
    signal rightShiftStage1Idx2Rng4_uid240_alignFracB_uid124_fpHypot3dTest_b : STD_LOGIC_VECTOR (21 downto 0);
    signal rightShiftStage1Idx2Pad4_uid241_alignFracB_uid124_fpHypot3dTest_q : STD_LOGIC_VECTOR (3 downto 0);
    signal rightShiftStage1Idx2_uid242_alignFracB_uid124_fpHypot3dTest_q : STD_LOGIC_VECTOR (25 downto 0);
    signal rightShiftStage1Idx3Rng6_uid243_alignFracB_uid124_fpHypot3dTest_b : STD_LOGIC_VECTOR (19 downto 0);
    signal rightShiftStage1Idx3Pad6_uid244_alignFracB_uid124_fpHypot3dTest_q : STD_LOGIC_VECTOR (5 downto 0);
    signal rightShiftStage1Idx3_uid245_alignFracB_uid124_fpHypot3dTest_q : STD_LOGIC_VECTOR (25 downto 0);
    signal rightShiftStage1_uid247_alignFracB_uid124_fpHypot3dTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStage1_uid247_alignFracB_uid124_fpHypot3dTest_q : STD_LOGIC_VECTOR (25 downto 0);
    signal rightShiftStage2Idx1Rng1_uid248_alignFracB_uid124_fpHypot3dTest_b : STD_LOGIC_VECTOR (24 downto 0);
    signal rightShiftStage2Idx1_uid250_alignFracB_uid124_fpHypot3dTest_q : STD_LOGIC_VECTOR (25 downto 0);
    signal rightShiftStage2_uid252_alignFracB_uid124_fpHypot3dTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal rightShiftStage2_uid252_alignFracB_uid124_fpHypot3dTest_q : STD_LOGIC_VECTOR (25 downto 0);
    signal rightShiftStage0Idx1Rng8_uid256_alignFracC_uid125_fpHypot3dTest_b : STD_LOGIC_VECTOR (17 downto 0);
    signal rightShiftStage0Idx1_uid258_alignFracC_uid125_fpHypot3dTest_q : STD_LOGIC_VECTOR (25 downto 0);
    signal rightShiftStage0Idx2Rng16_uid259_alignFracC_uid125_fpHypot3dTest_b : STD_LOGIC_VECTOR (9 downto 0);
    signal rightShiftStage0Idx2_uid261_alignFracC_uid125_fpHypot3dTest_q : STD_LOGIC_VECTOR (25 downto 0);
    signal rightShiftStage0Idx3Rng24_uid262_alignFracC_uid125_fpHypot3dTest_b : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStage0Idx3_uid264_alignFracC_uid125_fpHypot3dTest_q : STD_LOGIC_VECTOR (25 downto 0);
    signal rightShiftStage0_uid266_alignFracC_uid125_fpHypot3dTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStage0_uid266_alignFracC_uid125_fpHypot3dTest_q : STD_LOGIC_VECTOR (25 downto 0);
    signal rightShiftStage1Idx1Rng2_uid267_alignFracC_uid125_fpHypot3dTest_b : STD_LOGIC_VECTOR (23 downto 0);
    signal rightShiftStage1Idx1_uid269_alignFracC_uid125_fpHypot3dTest_q : STD_LOGIC_VECTOR (25 downto 0);
    signal rightShiftStage1Idx2Rng4_uid270_alignFracC_uid125_fpHypot3dTest_b : STD_LOGIC_VECTOR (21 downto 0);
    signal rightShiftStage1Idx2_uid272_alignFracC_uid125_fpHypot3dTest_q : STD_LOGIC_VECTOR (25 downto 0);
    signal rightShiftStage1Idx3Rng6_uid273_alignFracC_uid125_fpHypot3dTest_b : STD_LOGIC_VECTOR (19 downto 0);
    signal rightShiftStage1Idx3_uid275_alignFracC_uid125_fpHypot3dTest_q : STD_LOGIC_VECTOR (25 downto 0);
    signal rightShiftStage1_uid277_alignFracC_uid125_fpHypot3dTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStage1_uid277_alignFracC_uid125_fpHypot3dTest_q : STD_LOGIC_VECTOR (25 downto 0);
    signal rightShiftStage2Idx1Rng1_uid278_alignFracC_uid125_fpHypot3dTest_b : STD_LOGIC_VECTOR (24 downto 0);
    signal rightShiftStage2Idx1_uid280_alignFracC_uid125_fpHypot3dTest_q : STD_LOGIC_VECTOR (25 downto 0);
    signal rightShiftStage2_uid282_alignFracC_uid125_fpHypot3dTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal rightShiftStage2_uid282_alignFracC_uid125_fpHypot3dTest_q : STD_LOGIC_VECTOR (25 downto 0);
    signal memoryC0_uid193_sqrtTables_lutmem_reset0 : std_logic;
    signal memoryC0_uid193_sqrtTables_lutmem_ia : STD_LOGIC_VECTOR (28 downto 0);
    signal memoryC0_uid193_sqrtTables_lutmem_aa : STD_LOGIC_VECTOR (7 downto 0);
    signal memoryC0_uid193_sqrtTables_lutmem_ab : STD_LOGIC_VECTOR (7 downto 0);
    signal memoryC0_uid193_sqrtTables_lutmem_ir : STD_LOGIC_VECTOR (28 downto 0);
    signal memoryC0_uid193_sqrtTables_lutmem_r : STD_LOGIC_VECTOR (28 downto 0);
    signal memoryC1_uid196_sqrtTables_lutmem_reset0 : std_logic;
    signal memoryC1_uid196_sqrtTables_lutmem_ia : STD_LOGIC_VECTOR (20 downto 0);
    signal memoryC1_uid196_sqrtTables_lutmem_aa : STD_LOGIC_VECTOR (7 downto 0);
    signal memoryC1_uid196_sqrtTables_lutmem_ab : STD_LOGIC_VECTOR (7 downto 0);
    signal memoryC1_uid196_sqrtTables_lutmem_ir : STD_LOGIC_VECTOR (20 downto 0);
    signal memoryC1_uid196_sqrtTables_lutmem_r : STD_LOGIC_VECTOR (20 downto 0);
    signal memoryC2_uid199_sqrtTables_lutmem_reset0 : std_logic;
    signal memoryC2_uid199_sqrtTables_lutmem_ia : STD_LOGIC_VECTOR (11 downto 0);
    signal memoryC2_uid199_sqrtTables_lutmem_aa : STD_LOGIC_VECTOR (7 downto 0);
    signal memoryC2_uid199_sqrtTables_lutmem_ab : STD_LOGIC_VECTOR (7 downto 0);
    signal memoryC2_uid199_sqrtTables_lutmem_ir : STD_LOGIC_VECTOR (11 downto 0);
    signal memoryC2_uid199_sqrtTables_lutmem_r : STD_LOGIC_VECTOR (11 downto 0);
    signal oFracXSqr_uid58_fpHypot3dTest_cma_reset : std_logic;
    type oFracXSqr_uid58_fpHypot3dTest_cma_a0type is array(NATURAL range <>) of UNSIGNED(23 downto 0);
    signal oFracXSqr_uid58_fpHypot3dTest_cma_a0 : oFracXSqr_uid58_fpHypot3dTest_cma_a0type(0 to 0);
    attribute preserve : boolean;
    attribute preserve of oFracXSqr_uid58_fpHypot3dTest_cma_a0 : signal is true;
    signal oFracXSqr_uid58_fpHypot3dTest_cma_c0 : oFracXSqr_uid58_fpHypot3dTest_cma_a0type(0 to 0);
    attribute preserve of oFracXSqr_uid58_fpHypot3dTest_cma_c0 : signal is true;
    type oFracXSqr_uid58_fpHypot3dTest_cma_ptype is array(NATURAL range <>) of UNSIGNED(47 downto 0);
    signal oFracXSqr_uid58_fpHypot3dTest_cma_p : oFracXSqr_uid58_fpHypot3dTest_cma_ptype(0 to 0);
    signal oFracXSqr_uid58_fpHypot3dTest_cma_u : oFracXSqr_uid58_fpHypot3dTest_cma_ptype(0 to 0);
    signal oFracXSqr_uid58_fpHypot3dTest_cma_w : oFracXSqr_uid58_fpHypot3dTest_cma_ptype(0 to 0);
    signal oFracXSqr_uid58_fpHypot3dTest_cma_x : oFracXSqr_uid58_fpHypot3dTest_cma_ptype(0 to 0);
    signal oFracXSqr_uid58_fpHypot3dTest_cma_y : oFracXSqr_uid58_fpHypot3dTest_cma_ptype(0 to 0);
    signal oFracXSqr_uid58_fpHypot3dTest_cma_s : oFracXSqr_uid58_fpHypot3dTest_cma_ptype(0 to 0);
    signal oFracXSqr_uid58_fpHypot3dTest_cma_qq : STD_LOGIC_VECTOR (47 downto 0);
    signal oFracXSqr_uid58_fpHypot3dTest_cma_q : STD_LOGIC_VECTOR (47 downto 0);
    signal oFracXSqr_uid58_fpHypot3dTest_cma_ena0 : std_logic;
    signal oFracXSqr_uid58_fpHypot3dTest_cma_ena1 : std_logic;
    signal oFracYSqr_uid59_fpHypot3dTest_cma_reset : std_logic;
    signal oFracYSqr_uid59_fpHypot3dTest_cma_a0 : oFracXSqr_uid58_fpHypot3dTest_cma_a0type(0 to 0);
    attribute preserve of oFracYSqr_uid59_fpHypot3dTest_cma_a0 : signal is true;
    signal oFracYSqr_uid59_fpHypot3dTest_cma_c0 : oFracXSqr_uid58_fpHypot3dTest_cma_a0type(0 to 0);
    attribute preserve of oFracYSqr_uid59_fpHypot3dTest_cma_c0 : signal is true;
    signal oFracYSqr_uid59_fpHypot3dTest_cma_p : oFracXSqr_uid58_fpHypot3dTest_cma_ptype(0 to 0);
    signal oFracYSqr_uid59_fpHypot3dTest_cma_u : oFracXSqr_uid58_fpHypot3dTest_cma_ptype(0 to 0);
    signal oFracYSqr_uid59_fpHypot3dTest_cma_w : oFracXSqr_uid58_fpHypot3dTest_cma_ptype(0 to 0);
    signal oFracYSqr_uid59_fpHypot3dTest_cma_x : oFracXSqr_uid58_fpHypot3dTest_cma_ptype(0 to 0);
    signal oFracYSqr_uid59_fpHypot3dTest_cma_y : oFracXSqr_uid58_fpHypot3dTest_cma_ptype(0 to 0);
    signal oFracYSqr_uid59_fpHypot3dTest_cma_s : oFracXSqr_uid58_fpHypot3dTest_cma_ptype(0 to 0);
    signal oFracYSqr_uid59_fpHypot3dTest_cma_qq : STD_LOGIC_VECTOR (47 downto 0);
    signal oFracYSqr_uid59_fpHypot3dTest_cma_q : STD_LOGIC_VECTOR (47 downto 0);
    signal oFracYSqr_uid59_fpHypot3dTest_cma_ena0 : std_logic;
    signal oFracYSqr_uid59_fpHypot3dTest_cma_ena1 : std_logic;
    signal oFracZSqr_uid60_fpHypot3dTest_cma_reset : std_logic;
    signal oFracZSqr_uid60_fpHypot3dTest_cma_a0 : oFracXSqr_uid58_fpHypot3dTest_cma_a0type(0 to 0);
    attribute preserve of oFracZSqr_uid60_fpHypot3dTest_cma_a0 : signal is true;
    signal oFracZSqr_uid60_fpHypot3dTest_cma_c0 : oFracXSqr_uid58_fpHypot3dTest_cma_a0type(0 to 0);
    attribute preserve of oFracZSqr_uid60_fpHypot3dTest_cma_c0 : signal is true;
    signal oFracZSqr_uid60_fpHypot3dTest_cma_p : oFracXSqr_uid58_fpHypot3dTest_cma_ptype(0 to 0);
    signal oFracZSqr_uid60_fpHypot3dTest_cma_u : oFracXSqr_uid58_fpHypot3dTest_cma_ptype(0 to 0);
    signal oFracZSqr_uid60_fpHypot3dTest_cma_w : oFracXSqr_uid58_fpHypot3dTest_cma_ptype(0 to 0);
    signal oFracZSqr_uid60_fpHypot3dTest_cma_x : oFracXSqr_uid58_fpHypot3dTest_cma_ptype(0 to 0);
    signal oFracZSqr_uid60_fpHypot3dTest_cma_y : oFracXSqr_uid58_fpHypot3dTest_cma_ptype(0 to 0);
    signal oFracZSqr_uid60_fpHypot3dTest_cma_s : oFracXSqr_uid58_fpHypot3dTest_cma_ptype(0 to 0);
    signal oFracZSqr_uid60_fpHypot3dTest_cma_qq : STD_LOGIC_VECTOR (47 downto 0);
    signal oFracZSqr_uid60_fpHypot3dTest_cma_q : STD_LOGIC_VECTOR (47 downto 0);
    signal oFracZSqr_uid60_fpHypot3dTest_cma_ena0 : std_logic;
    signal oFracZSqr_uid60_fpHypot3dTest_cma_ena1 : std_logic;
    signal prodXY_uid218_pT1_uid206_invPolyEval_cma_reset : std_logic;
    type prodXY_uid218_pT1_uid206_invPolyEval_cma_a0type is array(NATURAL range <>) of UNSIGNED(11 downto 0);
    signal prodXY_uid218_pT1_uid206_invPolyEval_cma_a0 : prodXY_uid218_pT1_uid206_invPolyEval_cma_a0type(0 to 0);
    attribute preserve of prodXY_uid218_pT1_uid206_invPolyEval_cma_a0 : signal is true;
    type prodXY_uid218_pT1_uid206_invPolyEval_cma_c0type is array(NATURAL range <>) of SIGNED(11 downto 0);
    signal prodXY_uid218_pT1_uid206_invPolyEval_cma_c0 : prodXY_uid218_pT1_uid206_invPolyEval_cma_c0type(0 to 0);
    attribute preserve of prodXY_uid218_pT1_uid206_invPolyEval_cma_c0 : signal is true;
    type prodXY_uid218_pT1_uid206_invPolyEval_cma_ltype is array(NATURAL range <>) of SIGNED(12 downto 0);
    signal prodXY_uid218_pT1_uid206_invPolyEval_cma_l : prodXY_uid218_pT1_uid206_invPolyEval_cma_ltype(0 to 0);
    type prodXY_uid218_pT1_uid206_invPolyEval_cma_ptype is array(NATURAL range <>) of SIGNED(24 downto 0);
    signal prodXY_uid218_pT1_uid206_invPolyEval_cma_p : prodXY_uid218_pT1_uid206_invPolyEval_cma_ptype(0 to 0);
    signal prodXY_uid218_pT1_uid206_invPolyEval_cma_u : prodXY_uid218_pT1_uid206_invPolyEval_cma_ptype(0 to 0);
    signal prodXY_uid218_pT1_uid206_invPolyEval_cma_w : prodXY_uid218_pT1_uid206_invPolyEval_cma_ptype(0 to 0);
    signal prodXY_uid218_pT1_uid206_invPolyEval_cma_x : prodXY_uid218_pT1_uid206_invPolyEval_cma_ptype(0 to 0);
    signal prodXY_uid218_pT1_uid206_invPolyEval_cma_y : prodXY_uid218_pT1_uid206_invPolyEval_cma_ptype(0 to 0);
    signal prodXY_uid218_pT1_uid206_invPolyEval_cma_s : prodXY_uid218_pT1_uid206_invPolyEval_cma_ptype(0 to 0);
    signal prodXY_uid218_pT1_uid206_invPolyEval_cma_qq : STD_LOGIC_VECTOR (23 downto 0);
    signal prodXY_uid218_pT1_uid206_invPolyEval_cma_q : STD_LOGIC_VECTOR (23 downto 0);
    signal prodXY_uid218_pT1_uid206_invPolyEval_cma_ena0 : std_logic;
    signal prodXY_uid218_pT1_uid206_invPolyEval_cma_ena1 : std_logic;
    signal prodXY_uid221_pT2_uid212_invPolyEval_cma_reset : std_logic;
    type prodXY_uid221_pT2_uid212_invPolyEval_cma_a0type is array(NATURAL range <>) of UNSIGNED(15 downto 0);
    signal prodXY_uid221_pT2_uid212_invPolyEval_cma_a0 : prodXY_uid221_pT2_uid212_invPolyEval_cma_a0type(0 to 0);
    attribute preserve of prodXY_uid221_pT2_uid212_invPolyEval_cma_a0 : signal is true;
    type prodXY_uid221_pT2_uid212_invPolyEval_cma_c0type is array(NATURAL range <>) of SIGNED(22 downto 0);
    signal prodXY_uid221_pT2_uid212_invPolyEval_cma_c0 : prodXY_uid221_pT2_uid212_invPolyEval_cma_c0type(0 to 0);
    attribute preserve of prodXY_uid221_pT2_uid212_invPolyEval_cma_c0 : signal is true;
    type prodXY_uid221_pT2_uid212_invPolyEval_cma_ltype is array(NATURAL range <>) of SIGNED(16 downto 0);
    signal prodXY_uid221_pT2_uid212_invPolyEval_cma_l : prodXY_uid221_pT2_uid212_invPolyEval_cma_ltype(0 to 0);
    type prodXY_uid221_pT2_uid212_invPolyEval_cma_ptype is array(NATURAL range <>) of SIGNED(39 downto 0);
    signal prodXY_uid221_pT2_uid212_invPolyEval_cma_p : prodXY_uid221_pT2_uid212_invPolyEval_cma_ptype(0 to 0);
    signal prodXY_uid221_pT2_uid212_invPolyEval_cma_u : prodXY_uid221_pT2_uid212_invPolyEval_cma_ptype(0 to 0);
    signal prodXY_uid221_pT2_uid212_invPolyEval_cma_w : prodXY_uid221_pT2_uid212_invPolyEval_cma_ptype(0 to 0);
    signal prodXY_uid221_pT2_uid212_invPolyEval_cma_x : prodXY_uid221_pT2_uid212_invPolyEval_cma_ptype(0 to 0);
    signal prodXY_uid221_pT2_uid212_invPolyEval_cma_y : prodXY_uid221_pT2_uid212_invPolyEval_cma_ptype(0 to 0);
    signal prodXY_uid221_pT2_uid212_invPolyEval_cma_s : prodXY_uid221_pT2_uid212_invPolyEval_cma_ptype(0 to 0);
    signal prodXY_uid221_pT2_uid212_invPolyEval_cma_qq : STD_LOGIC_VECTOR (38 downto 0);
    signal prodXY_uid221_pT2_uid212_invPolyEval_cma_q : STD_LOGIC_VECTOR (38 downto 0);
    signal prodXY_uid221_pT2_uid212_invPolyEval_cma_ena0 : std_logic;
    signal prodXY_uid221_pT2_uid212_invPolyEval_cma_ena1 : std_logic;
    signal expX_uid6_fpHypot3dTest_merged_bit_select_b : STD_LOGIC_VECTOR (7 downto 0);
    signal expX_uid6_fpHypot3dTest_merged_bit_select_c : STD_LOGIC_VECTOR (22 downto 0);
    signal expY_uid7_fpHypot3dTest_merged_bit_select_b : STD_LOGIC_VECTOR (7 downto 0);
    signal expY_uid7_fpHypot3dTest_merged_bit_select_c : STD_LOGIC_VECTOR (22 downto 0);
    signal expZ_uid8_fpHypot3dTest_merged_bit_select_b : STD_LOGIC_VECTOR (7 downto 0);
    signal expZ_uid8_fpHypot3dTest_merged_bit_select_c : STD_LOGIC_VECTOR (22 downto 0);
    signal rightShiftStageSel4Dto3_uid235_alignFracB_uid124_fpHypot3dTest_merged_bit_select_b : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStageSel4Dto3_uid235_alignFracB_uid124_fpHypot3dTest_merged_bit_select_c : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStageSel4Dto3_uid235_alignFracB_uid124_fpHypot3dTest_merged_bit_select_d : STD_LOGIC_VECTOR (0 downto 0);
    signal rightShiftStageSel4Dto3_uid265_alignFracC_uid125_fpHypot3dTest_merged_bit_select_b : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStageSel4Dto3_uid265_alignFracC_uid125_fpHypot3dTest_merged_bit_select_c : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStageSel4Dto3_uid265_alignFracC_uid125_fpHypot3dTest_merged_bit_select_d : STD_LOGIC_VECTOR (0 downto 0);
    signal redist0_expZ_uid8_fpHypot3dTest_merged_bit_select_b_2_q : STD_LOGIC_VECTOR (7 downto 0);
    signal redist1_expY_uid7_fpHypot3dTest_merged_bit_select_b_2_q : STD_LOGIC_VECTOR (7 downto 0);
    signal redist2_expX_uid6_fpHypot3dTest_merged_bit_select_b_2_q : STD_LOGIC_VECTOR (7 downto 0);
    signal redist3_onIsReg_uid171_fpHypot3dTest_q_7_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist4_oneIsInf_uid169_fpHypot3dTest_q_7_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist5_excXYZ_uid168_fpHypot3dTest_q_7_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist6_yy_uid156_fpHypot3dTest_b_2_q : STD_LOGIC_VECTOR (15 downto 0);
    signal redist7_yy_uid156_fpHypot3dTest_b_4_q : STD_LOGIC_VECTOR (15 downto 0);
    signal redist8_yAddr_uid155_fpHypot3dTest_b_2_q : STD_LOGIC_VECTOR (7 downto 0);
    signal redist9_yAddr_uid155_fpHypot3dTest_b_4_q : STD_LOGIC_VECTOR (7 downto 0);
    signal redist11_expA_uid93_fpHypot3dTest_q_1_q : STD_LOGIC_VECTOR (9 downto 0);
    signal redist12_excN_z_uid50_fpHypot3dTest_q_7_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist13_fracXIsZero_uid47_fpHypot3dTest_q_2_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist14_excN_y_uid36_fpHypot3dTest_q_7_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist15_fracXIsZero_uid33_fpHypot3dTest_q_2_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist16_excN_x_uid22_fpHypot3dTest_q_7_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist17_fracXIsZero_uid19_fpHypot3dTest_q_2_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist10_expRMux_uid152_fpHypot3dTest_q_6_mem_reset0 : std_logic;
    signal redist10_expRMux_uid152_fpHypot3dTest_q_6_mem_ia : STD_LOGIC_VECTOR (9 downto 0);
    signal redist10_expRMux_uid152_fpHypot3dTest_q_6_mem_aa : STD_LOGIC_VECTOR (1 downto 0);
    signal redist10_expRMux_uid152_fpHypot3dTest_q_6_mem_ab : STD_LOGIC_VECTOR (1 downto 0);
    signal redist10_expRMux_uid152_fpHypot3dTest_q_6_mem_iq : STD_LOGIC_VECTOR (9 downto 0);
    signal redist10_expRMux_uid152_fpHypot3dTest_q_6_mem_q : STD_LOGIC_VECTOR (9 downto 0);
    signal redist10_expRMux_uid152_fpHypot3dTest_q_6_rdcnt_q : STD_LOGIC_VECTOR (1 downto 0);
    signal redist10_expRMux_uid152_fpHypot3dTest_q_6_rdcnt_i : UNSIGNED (1 downto 0);
    attribute preserve of redist10_expRMux_uid152_fpHypot3dTest_q_6_rdcnt_i : signal is true;
    signal redist10_expRMux_uid152_fpHypot3dTest_q_6_wraddr_q : STD_LOGIC_VECTOR (1 downto 0);
    signal redist10_expRMux_uid152_fpHypot3dTest_q_6_mem_last_q : STD_LOGIC_VECTOR (2 downto 0);
    signal redist10_expRMux_uid152_fpHypot3dTest_q_6_cmp_b : STD_LOGIC_VECTOR (2 downto 0);
    signal redist10_expRMux_uid152_fpHypot3dTest_q_6_cmp_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist10_expRMux_uid152_fpHypot3dTest_q_6_cmpReg_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist10_expRMux_uid152_fpHypot3dTest_q_6_notEnable_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist10_expRMux_uid152_fpHypot3dTest_q_6_nor_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist10_expRMux_uid152_fpHypot3dTest_q_6_sticky_ena_q : STD_LOGIC_VECTOR (0 downto 0);
    attribute dont_merge : boolean;
    attribute dont_merge of redist10_expRMux_uid152_fpHypot3dTest_q_6_sticky_ena_q : signal is true;
    signal redist10_expRMux_uid152_fpHypot3dTest_q_6_enaAnd_q : STD_LOGIC_VECTOR (0 downto 0);

begin


    -- GND(CONSTANT,0)
    GND_q <= "0";

    -- cstAllOWE_uid12_fpHypot3dTest(CONSTANT,11)
    cstAllOWE_uid12_fpHypot3dTest_q <= "11111111";

    -- cst10_2_uid137_fpHypot3dTest(CONSTANT,136)
    cst10_2_uid137_fpHypot3dTest_q <= "10";

    -- cst01_2_uid136_fpHypot3dTest(CONSTANT,135)
    cst01_2_uid136_fpHypot3dTest_q <= "01";

    -- cstZ2_uid119_fpHypot3dTest(CONSTANT,118)
    cstZ2_uid119_fpHypot3dTest_q <= "00";

    -- rightShiftStage2Idx1Rng1_uid278_alignFracC_uid125_fpHypot3dTest(BITSELECT,277)@3
    rightShiftStage2Idx1Rng1_uid278_alignFracC_uid125_fpHypot3dTest_b <= rightShiftStage1_uid277_alignFracC_uid125_fpHypot3dTest_q(25 downto 1);

    -- rightShiftStage2Idx1_uid280_alignFracC_uid125_fpHypot3dTest(BITJOIN,279)@3
    rightShiftStage2Idx1_uid280_alignFracC_uid125_fpHypot3dTest_q <= GND_q & rightShiftStage2Idx1Rng1_uid278_alignFracC_uid125_fpHypot3dTest_b;

    -- rightShiftStage1Idx3Pad6_uid244_alignFracB_uid124_fpHypot3dTest(CONSTANT,243)
    rightShiftStage1Idx3Pad6_uid244_alignFracB_uid124_fpHypot3dTest_q <= "000000";

    -- rightShiftStage1Idx3Rng6_uid273_alignFracC_uid125_fpHypot3dTest(BITSELECT,272)@3
    rightShiftStage1Idx3Rng6_uid273_alignFracC_uid125_fpHypot3dTest_b <= rightShiftStage0_uid266_alignFracC_uid125_fpHypot3dTest_q(25 downto 6);

    -- rightShiftStage1Idx3_uid275_alignFracC_uid125_fpHypot3dTest(BITJOIN,274)@3
    rightShiftStage1Idx3_uid275_alignFracC_uid125_fpHypot3dTest_q <= rightShiftStage1Idx3Pad6_uid244_alignFracB_uid124_fpHypot3dTest_q & rightShiftStage1Idx3Rng6_uid273_alignFracC_uid125_fpHypot3dTest_b;

    -- rightShiftStage1Idx2Pad4_uid241_alignFracB_uid124_fpHypot3dTest(CONSTANT,240)
    rightShiftStage1Idx2Pad4_uid241_alignFracB_uid124_fpHypot3dTest_q <= "0000";

    -- rightShiftStage1Idx2Rng4_uid270_alignFracC_uid125_fpHypot3dTest(BITSELECT,269)@3
    rightShiftStage1Idx2Rng4_uid270_alignFracC_uid125_fpHypot3dTest_b <= rightShiftStage0_uid266_alignFracC_uid125_fpHypot3dTest_q(25 downto 4);

    -- rightShiftStage1Idx2_uid272_alignFracC_uid125_fpHypot3dTest(BITJOIN,271)@3
    rightShiftStage1Idx2_uid272_alignFracC_uid125_fpHypot3dTest_q <= rightShiftStage1Idx2Pad4_uid241_alignFracB_uid124_fpHypot3dTest_q & rightShiftStage1Idx2Rng4_uid270_alignFracC_uid125_fpHypot3dTest_b;

    -- rightShiftStage1Idx1Rng2_uid267_alignFracC_uid125_fpHypot3dTest(BITSELECT,266)@3
    rightShiftStage1Idx1Rng2_uid267_alignFracC_uid125_fpHypot3dTest_b <= rightShiftStage0_uid266_alignFracC_uid125_fpHypot3dTest_q(25 downto 2);

    -- rightShiftStage1Idx1_uid269_alignFracC_uid125_fpHypot3dTest(BITJOIN,268)@3
    rightShiftStage1Idx1_uid269_alignFracC_uid125_fpHypot3dTest_q <= cstZ2_uid119_fpHypot3dTest_q & rightShiftStage1Idx1Rng2_uid267_alignFracC_uid125_fpHypot3dTest_b;

    -- zerosWFp1_uid115_fpHypot3dTest(CONSTANT,114)
    zerosWFp1_uid115_fpHypot3dTest_q <= "000000000000000000000000";

    -- rightShiftStage0Idx3Rng24_uid262_alignFracC_uid125_fpHypot3dTest(BITSELECT,261)@3
    rightShiftStage0Idx3Rng24_uid262_alignFracC_uid125_fpHypot3dTest_b <= oFracBPostExcG_uid122_fpHypot3dTest_q(25 downto 24);

    -- rightShiftStage0Idx3_uid264_alignFracC_uid125_fpHypot3dTest(BITJOIN,263)@3
    rightShiftStage0Idx3_uid264_alignFracC_uid125_fpHypot3dTest_q <= zerosWFp1_uid115_fpHypot3dTest_q & rightShiftStage0Idx3Rng24_uid262_alignFracC_uid125_fpHypot3dTest_b;

    -- rightShiftStage0Idx2Pad16_uid230_alignFracB_uid124_fpHypot3dTest(CONSTANT,229)
    rightShiftStage0Idx2Pad16_uid230_alignFracB_uid124_fpHypot3dTest_q <= "0000000000000000";

    -- rightShiftStage0Idx2Rng16_uid259_alignFracC_uid125_fpHypot3dTest(BITSELECT,258)@3
    rightShiftStage0Idx2Rng16_uid259_alignFracC_uid125_fpHypot3dTest_b <= oFracBPostExcG_uid122_fpHypot3dTest_q(25 downto 16);

    -- rightShiftStage0Idx2_uid261_alignFracC_uid125_fpHypot3dTest(BITJOIN,260)@3
    rightShiftStage0Idx2_uid261_alignFracC_uid125_fpHypot3dTest_q <= rightShiftStage0Idx2Pad16_uid230_alignFracB_uid124_fpHypot3dTest_q & rightShiftStage0Idx2Rng16_uid259_alignFracC_uid125_fpHypot3dTest_b;

    -- rightShiftStage0Idx1Rng8_uid256_alignFracC_uid125_fpHypot3dTest(BITSELECT,255)@3
    rightShiftStage0Idx1Rng8_uid256_alignFracC_uid125_fpHypot3dTest_b <= oFracBPostExcG_uid122_fpHypot3dTest_q(25 downto 8);

    -- rightShiftStage0Idx1_uid258_alignFracC_uid125_fpHypot3dTest(BITJOIN,257)@3
    rightShiftStage0Idx1_uid258_alignFracC_uid125_fpHypot3dTest_q <= cstAllZWE_uid14_fpHypot3dTest_q & rightShiftStage0Idx1Rng8_uid256_alignFracC_uid125_fpHypot3dTest_b;

    -- expZ_uid8_fpHypot3dTest_merged_bit_select(BITSELECT,293)@0
    expZ_uid8_fpHypot3dTest_merged_bit_select_b <= STD_LOGIC_VECTOR(c(30 downto 23));
    expZ_uid8_fpHypot3dTest_merged_bit_select_c <= STD_LOGIC_VECTOR(c(22 downto 0));

    -- oFracZ_uid57_fpHypot3dTest(BITJOIN,56)@0
    oFracZ_uid57_fpHypot3dTest_q <= VCC_q & expZ_uid8_fpHypot3dTest_merged_bit_select_c;

    -- oFracZSqr_uid60_fpHypot3dTest_cma(CHAINMULTADD,288)@0 + 2
    oFracZSqr_uid60_fpHypot3dTest_cma_reset <= areset;
    oFracZSqr_uid60_fpHypot3dTest_cma_ena0 <= '1';
    oFracZSqr_uid60_fpHypot3dTest_cma_ena1 <= oFracZSqr_uid60_fpHypot3dTest_cma_ena0;
    oFracZSqr_uid60_fpHypot3dTest_cma_p(0) <= oFracZSqr_uid60_fpHypot3dTest_cma_a0(0) * oFracZSqr_uid60_fpHypot3dTest_cma_c0(0);
    oFracZSqr_uid60_fpHypot3dTest_cma_u(0) <= RESIZE(oFracZSqr_uid60_fpHypot3dTest_cma_p(0),48);
    oFracZSqr_uid60_fpHypot3dTest_cma_w(0) <= oFracZSqr_uid60_fpHypot3dTest_cma_u(0);
    oFracZSqr_uid60_fpHypot3dTest_cma_x(0) <= oFracZSqr_uid60_fpHypot3dTest_cma_w(0);
    oFracZSqr_uid60_fpHypot3dTest_cma_y(0) <= oFracZSqr_uid60_fpHypot3dTest_cma_x(0);
    oFracZSqr_uid60_fpHypot3dTest_cma_chainmultadd_input: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            oFracZSqr_uid60_fpHypot3dTest_cma_a0 <= (others => (others => '0'));
            oFracZSqr_uid60_fpHypot3dTest_cma_c0 <= (others => (others => '0'));
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (oFracZSqr_uid60_fpHypot3dTest_cma_ena0 = '1') THEN
                oFracZSqr_uid60_fpHypot3dTest_cma_a0(0) <= RESIZE(UNSIGNED(oFracZ_uid57_fpHypot3dTest_q),24);
                oFracZSqr_uid60_fpHypot3dTest_cma_c0(0) <= RESIZE(UNSIGNED(oFracZ_uid57_fpHypot3dTest_q),24);
            END IF;
        END IF;
    END PROCESS;
    oFracZSqr_uid60_fpHypot3dTest_cma_chainmultadd_output: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            oFracZSqr_uid60_fpHypot3dTest_cma_s <= (others => (others => '0'));
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (oFracZSqr_uid60_fpHypot3dTest_cma_ena1 = '1') THEN
                oFracZSqr_uid60_fpHypot3dTest_cma_s(0) <= oFracZSqr_uid60_fpHypot3dTest_cma_y(0);
            END IF;
        END IF;
    END PROCESS;
    oFracZSqr_uid60_fpHypot3dTest_cma_delay : dspba_delay
    GENERIC MAP ( width => 48, depth => 0, reset_kind => "ASYNC" )
    PORT MAP ( xin => STD_LOGIC_VECTOR(oFracZSqr_uid60_fpHypot3dTest_cma_s(0)(47 downto 0)), xout => oFracZSqr_uid60_fpHypot3dTest_cma_qq, clk => clk, aclr => areset );
    oFracZSqr_uid60_fpHypot3dTest_cma_q <= STD_LOGIC_VECTOR(oFracZSqr_uid60_fpHypot3dTest_cma_qq(47 downto 0));

    -- normFracZSqrHigh_uid80_fpHypot3dTest(BITSELECT,79)@2
    normFracZSqrHigh_uid80_fpHypot3dTest_b <= oFracZSqr_uid60_fpHypot3dTest_cma_q(47 downto 24);

    -- normFracZSqrLow_uid81_fpHypot3dTest(BITSELECT,80)@2
    normFracZSqrLow_uid81_fpHypot3dTest_in <= oFracZSqr_uid60_fpHypot3dTest_cma_q(46 downto 0);
    normFracZSqrLow_uid81_fpHypot3dTest_b <= normFracZSqrLow_uid81_fpHypot3dTest_in(46 downto 23);

    -- normBitZSqr_uid64_fpHypot3dTest(BITSELECT,63)@2
    normBitZSqr_uid64_fpHypot3dTest_b <= STD_LOGIC_VECTOR(oFracZSqr_uid60_fpHypot3dTest_cma_q(47 downto 47));

    -- ofracS_uid82_fpHypot3dTest(MUX,81)@2
    ofracS_uid82_fpHypot3dTest_s <= normBitZSqr_uid64_fpHypot3dTest_b;
    ofracS_uid82_fpHypot3dTest_combproc: PROCESS (ofracS_uid82_fpHypot3dTest_s, normFracZSqrLow_uid81_fpHypot3dTest_b, normFracZSqrHigh_uid80_fpHypot3dTest_b)
    BEGIN
        CASE (ofracS_uid82_fpHypot3dTest_s) IS
            WHEN "0" => ofracS_uid82_fpHypot3dTest_q <= normFracZSqrLow_uid81_fpHypot3dTest_b;
            WHEN "1" => ofracS_uid82_fpHypot3dTest_q <= normFracZSqrHigh_uid80_fpHypot3dTest_b;
            WHEN OTHERS => ofracS_uid82_fpHypot3dTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- expY_uid7_fpHypot3dTest_merged_bit_select(BITSELECT,292)@0
    expY_uid7_fpHypot3dTest_merged_bit_select_b <= STD_LOGIC_VECTOR(b(30 downto 23));
    expY_uid7_fpHypot3dTest_merged_bit_select_c <= STD_LOGIC_VECTOR(b(22 downto 0));

    -- oFracY_uid56_fpHypot3dTest(BITJOIN,55)@0
    oFracY_uid56_fpHypot3dTest_q <= VCC_q & expY_uid7_fpHypot3dTest_merged_bit_select_c;

    -- oFracYSqr_uid59_fpHypot3dTest_cma(CHAINMULTADD,287)@0 + 2
    oFracYSqr_uid59_fpHypot3dTest_cma_reset <= areset;
    oFracYSqr_uid59_fpHypot3dTest_cma_ena0 <= '1';
    oFracYSqr_uid59_fpHypot3dTest_cma_ena1 <= oFracYSqr_uid59_fpHypot3dTest_cma_ena0;
    oFracYSqr_uid59_fpHypot3dTest_cma_p(0) <= oFracYSqr_uid59_fpHypot3dTest_cma_a0(0) * oFracYSqr_uid59_fpHypot3dTest_cma_c0(0);
    oFracYSqr_uid59_fpHypot3dTest_cma_u(0) <= RESIZE(oFracYSqr_uid59_fpHypot3dTest_cma_p(0),48);
    oFracYSqr_uid59_fpHypot3dTest_cma_w(0) <= oFracYSqr_uid59_fpHypot3dTest_cma_u(0);
    oFracYSqr_uid59_fpHypot3dTest_cma_x(0) <= oFracYSqr_uid59_fpHypot3dTest_cma_w(0);
    oFracYSqr_uid59_fpHypot3dTest_cma_y(0) <= oFracYSqr_uid59_fpHypot3dTest_cma_x(0);
    oFracYSqr_uid59_fpHypot3dTest_cma_chainmultadd_input: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            oFracYSqr_uid59_fpHypot3dTest_cma_a0 <= (others => (others => '0'));
            oFracYSqr_uid59_fpHypot3dTest_cma_c0 <= (others => (others => '0'));
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (oFracYSqr_uid59_fpHypot3dTest_cma_ena0 = '1') THEN
                oFracYSqr_uid59_fpHypot3dTest_cma_a0(0) <= RESIZE(UNSIGNED(oFracY_uid56_fpHypot3dTest_q),24);
                oFracYSqr_uid59_fpHypot3dTest_cma_c0(0) <= RESIZE(UNSIGNED(oFracY_uid56_fpHypot3dTest_q),24);
            END IF;
        END IF;
    END PROCESS;
    oFracYSqr_uid59_fpHypot3dTest_cma_chainmultadd_output: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            oFracYSqr_uid59_fpHypot3dTest_cma_s <= (others => (others => '0'));
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (oFracYSqr_uid59_fpHypot3dTest_cma_ena1 = '1') THEN
                oFracYSqr_uid59_fpHypot3dTest_cma_s(0) <= oFracYSqr_uid59_fpHypot3dTest_cma_y(0);
            END IF;
        END IF;
    END PROCESS;
    oFracYSqr_uid59_fpHypot3dTest_cma_delay : dspba_delay
    GENERIC MAP ( width => 48, depth => 0, reset_kind => "ASYNC" )
    PORT MAP ( xin => STD_LOGIC_VECTOR(oFracYSqr_uid59_fpHypot3dTest_cma_s(0)(47 downto 0)), xout => oFracYSqr_uid59_fpHypot3dTest_cma_qq, clk => clk, aclr => areset );
    oFracYSqr_uid59_fpHypot3dTest_cma_q <= STD_LOGIC_VECTOR(oFracYSqr_uid59_fpHypot3dTest_cma_qq(47 downto 0));

    -- normFracYSqrHigh_uid77_fpHypot3dTest(BITSELECT,76)@2
    normFracYSqrHigh_uid77_fpHypot3dTest_b <= oFracYSqr_uid59_fpHypot3dTest_cma_q(47 downto 24);

    -- normFracYSqrLow_uid78_fpHypot3dTest(BITSELECT,77)@2
    normFracYSqrLow_uid78_fpHypot3dTest_in <= oFracYSqr_uid59_fpHypot3dTest_cma_q(46 downto 0);
    normFracYSqrLow_uid78_fpHypot3dTest_b <= normFracYSqrLow_uid78_fpHypot3dTest_in(46 downto 23);

    -- normBitYSqr_uid63_fpHypot3dTest(BITSELECT,62)@2
    normBitYSqr_uid63_fpHypot3dTest_b <= STD_LOGIC_VECTOR(oFracYSqr_uid59_fpHypot3dTest_cma_q(47 downto 47));

    -- ofracQ_uid79_fpHypot3dTest(MUX,78)@2
    ofracQ_uid79_fpHypot3dTest_s <= normBitYSqr_uid63_fpHypot3dTest_b;
    ofracQ_uid79_fpHypot3dTest_combproc: PROCESS (ofracQ_uid79_fpHypot3dTest_s, normFracYSqrLow_uid78_fpHypot3dTest_b, normFracYSqrHigh_uid77_fpHypot3dTest_b)
    BEGIN
        CASE (ofracQ_uid79_fpHypot3dTest_s) IS
            WHEN "0" => ofracQ_uid79_fpHypot3dTest_q <= normFracYSqrLow_uid78_fpHypot3dTest_b;
            WHEN "1" => ofracQ_uid79_fpHypot3dTest_q <= normFracYSqrHigh_uid77_fpHypot3dTest_b;
            WHEN OTHERS => ofracQ_uid79_fpHypot3dTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- expX_uid6_fpHypot3dTest_merged_bit_select(BITSELECT,291)@0
    expX_uid6_fpHypot3dTest_merged_bit_select_b <= STD_LOGIC_VECTOR(a(30 downto 23));
    expX_uid6_fpHypot3dTest_merged_bit_select_c <= STD_LOGIC_VECTOR(a(22 downto 0));

    -- oFracX_uid55_fpHypot3dTest(BITJOIN,54)@0
    oFracX_uid55_fpHypot3dTest_q <= VCC_q & expX_uid6_fpHypot3dTest_merged_bit_select_c;

    -- oFracXSqr_uid58_fpHypot3dTest_cma(CHAINMULTADD,286)@0 + 2
    oFracXSqr_uid58_fpHypot3dTest_cma_reset <= areset;
    oFracXSqr_uid58_fpHypot3dTest_cma_ena0 <= '1';
    oFracXSqr_uid58_fpHypot3dTest_cma_ena1 <= oFracXSqr_uid58_fpHypot3dTest_cma_ena0;
    oFracXSqr_uid58_fpHypot3dTest_cma_p(0) <= oFracXSqr_uid58_fpHypot3dTest_cma_a0(0) * oFracXSqr_uid58_fpHypot3dTest_cma_c0(0);
    oFracXSqr_uid58_fpHypot3dTest_cma_u(0) <= RESIZE(oFracXSqr_uid58_fpHypot3dTest_cma_p(0),48);
    oFracXSqr_uid58_fpHypot3dTest_cma_w(0) <= oFracXSqr_uid58_fpHypot3dTest_cma_u(0);
    oFracXSqr_uid58_fpHypot3dTest_cma_x(0) <= oFracXSqr_uid58_fpHypot3dTest_cma_w(0);
    oFracXSqr_uid58_fpHypot3dTest_cma_y(0) <= oFracXSqr_uid58_fpHypot3dTest_cma_x(0);
    oFracXSqr_uid58_fpHypot3dTest_cma_chainmultadd_input: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            oFracXSqr_uid58_fpHypot3dTest_cma_a0 <= (others => (others => '0'));
            oFracXSqr_uid58_fpHypot3dTest_cma_c0 <= (others => (others => '0'));
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (oFracXSqr_uid58_fpHypot3dTest_cma_ena0 = '1') THEN
                oFracXSqr_uid58_fpHypot3dTest_cma_a0(0) <= RESIZE(UNSIGNED(oFracX_uid55_fpHypot3dTest_q),24);
                oFracXSqr_uid58_fpHypot3dTest_cma_c0(0) <= RESIZE(UNSIGNED(oFracX_uid55_fpHypot3dTest_q),24);
            END IF;
        END IF;
    END PROCESS;
    oFracXSqr_uid58_fpHypot3dTest_cma_chainmultadd_output: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            oFracXSqr_uid58_fpHypot3dTest_cma_s <= (others => (others => '0'));
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (oFracXSqr_uid58_fpHypot3dTest_cma_ena1 = '1') THEN
                oFracXSqr_uid58_fpHypot3dTest_cma_s(0) <= oFracXSqr_uid58_fpHypot3dTest_cma_y(0);
            END IF;
        END IF;
    END PROCESS;
    oFracXSqr_uid58_fpHypot3dTest_cma_delay : dspba_delay
    GENERIC MAP ( width => 48, depth => 0, reset_kind => "ASYNC" )
    PORT MAP ( xin => STD_LOGIC_VECTOR(oFracXSqr_uid58_fpHypot3dTest_cma_s(0)(47 downto 0)), xout => oFracXSqr_uid58_fpHypot3dTest_cma_qq, clk => clk, aclr => areset );
    oFracXSqr_uid58_fpHypot3dTest_cma_q <= STD_LOGIC_VECTOR(oFracXSqr_uid58_fpHypot3dTest_cma_qq(47 downto 0));

    -- normFracXSqrHigh_uid74_fpHypot3dTest(BITSELECT,73)@2
    normFracXSqrHigh_uid74_fpHypot3dTest_b <= oFracXSqr_uid58_fpHypot3dTest_cma_q(47 downto 24);

    -- normFracXSqrLow_uid75_fpHypot3dTest(BITSELECT,74)@2
    normFracXSqrLow_uid75_fpHypot3dTest_in <= oFracXSqr_uid58_fpHypot3dTest_cma_q(46 downto 0);
    normFracXSqrLow_uid75_fpHypot3dTest_b <= normFracXSqrLow_uid75_fpHypot3dTest_in(46 downto 23);

    -- normBitXSqr_uid62_fpHypot3dTest(BITSELECT,61)@2
    normBitXSqr_uid62_fpHypot3dTest_b <= STD_LOGIC_VECTOR(oFracXSqr_uid58_fpHypot3dTest_cma_q(47 downto 47));

    -- ofracP_uid76_fpHypot3dTest(MUX,75)@2
    ofracP_uid76_fpHypot3dTest_s <= normBitXSqr_uid62_fpHypot3dTest_b;
    ofracP_uid76_fpHypot3dTest_combproc: PROCESS (ofracP_uid76_fpHypot3dTest_s, normFracXSqrLow_uid75_fpHypot3dTest_b, normFracXSqrHigh_uid74_fpHypot3dTest_b)
    BEGIN
        CASE (ofracP_uid76_fpHypot3dTest_s) IS
            WHEN "0" => ofracP_uid76_fpHypot3dTest_q <= normFracXSqrLow_uid75_fpHypot3dTest_b;
            WHEN "1" => ofracP_uid76_fpHypot3dTest_q <= normFracXSqrHigh_uid74_fpHypot3dTest_b;
            WHEN OTHERS => ofracP_uid76_fpHypot3dTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- redist1_expY_uid7_fpHypot3dTest_merged_bit_select_b_2(DELAY,297)
    redist1_expY_uid7_fpHypot3dTest_merged_bit_select_b_2 : dspba_delay
    GENERIC MAP ( width => 8, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => expY_uid7_fpHypot3dTest_merged_bit_select_b, xout => redist1_expY_uid7_fpHypot3dTest_merged_bit_select_b_2_q, clk => clk, aclr => areset );

    -- excZ_y_uid31_fpHypot3dTest(LOGICAL,30)@2
    excZ_y_uid31_fpHypot3dTest_q <= "1" WHEN redist1_expY_uid7_fpHypot3dTest_merged_bit_select_b_2_q = cstAllZWE_uid14_fpHypot3dTest_q ELSE "0";

    -- bias_uid61_fpHypot3dTest(CONSTANT,60)
    bias_uid61_fpHypot3dTest_q <= "1111111";

    -- expYTimes2_uid67_fpHypot3dTest(BITJOIN,66)@2
    expYTimes2_uid67_fpHypot3dTest_q <= redist1_expY_uid7_fpHypot3dTest_merged_bit_select_b_2_q & normBitYSqr_uid63_fpHypot3dTest_b;

    -- expQ_uid72_fpHypot3dTest(SUB,71)@2
    expQ_uid72_fpHypot3dTest_a <= STD_LOGIC_VECTOR("0" & expYTimes2_uid67_fpHypot3dTest_q);
    expQ_uid72_fpHypot3dTest_b <= STD_LOGIC_VECTOR("000" & bias_uid61_fpHypot3dTest_q);
    expQ_uid72_fpHypot3dTest_o <= STD_LOGIC_VECTOR(UNSIGNED(expQ_uid72_fpHypot3dTest_a) - UNSIGNED(expQ_uid72_fpHypot3dTest_b));
    expQ_uid72_fpHypot3dTest_q <= expQ_uid72_fpHypot3dTest_o(9 downto 0);

    -- redist2_expX_uid6_fpHypot3dTest_merged_bit_select_b_2(DELAY,298)
    redist2_expX_uid6_fpHypot3dTest_merged_bit_select_b_2 : dspba_delay
    GENERIC MAP ( width => 8, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => expX_uid6_fpHypot3dTest_merged_bit_select_b, xout => redist2_expX_uid6_fpHypot3dTest_merged_bit_select_b_2_q, clk => clk, aclr => areset );

    -- expXTimes2_uid65_fpHypot3dTest(BITJOIN,64)@2
    expXTimes2_uid65_fpHypot3dTest_q <= redist2_expX_uid6_fpHypot3dTest_merged_bit_select_b_2_q & normBitXSqr_uid62_fpHypot3dTest_b;

    -- expP_uid71_fpHypot3dTest(SUB,70)@2
    expP_uid71_fpHypot3dTest_a <= STD_LOGIC_VECTOR("0" & expXTimes2_uid65_fpHypot3dTest_q);
    expP_uid71_fpHypot3dTest_b <= STD_LOGIC_VECTOR("000" & bias_uid61_fpHypot3dTest_q);
    expP_uid71_fpHypot3dTest_o <= STD_LOGIC_VECTOR(UNSIGNED(expP_uid71_fpHypot3dTest_a) - UNSIGNED(expP_uid71_fpHypot3dTest_b));
    expP_uid71_fpHypot3dTest_q <= expP_uid71_fpHypot3dTest_o(9 downto 0);

    -- pGTEq_uid83_fpHypot3dTest(COMPARE,82)@2
    pGTEq_uid83_fpHypot3dTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((11 downto 10 => expP_uid71_fpHypot3dTest_q(9)) & expP_uid71_fpHypot3dTest_q));
    pGTEq_uid83_fpHypot3dTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((11 downto 10 => expQ_uid72_fpHypot3dTest_q(9)) & expQ_uid72_fpHypot3dTest_q));
    pGTEq_uid83_fpHypot3dTest_o <= STD_LOGIC_VECTOR(SIGNED(pGTEq_uid83_fpHypot3dTest_a) - SIGNED(pGTEq_uid83_fpHypot3dTest_b));
    pGTEq_uid83_fpHypot3dTest_n(0) <= not (pGTEq_uid83_fpHypot3dTest_o(11));

    -- expCmpGtePQ_uid84_fpHypot3dTest(LOGICAL,83)@2
    expCmpGtePQ_uid84_fpHypot3dTest_q <= pGTEq_uid83_fpHypot3dTest_n or excZ_y_uid31_fpHypot3dTest_q;

    -- redist0_expZ_uid8_fpHypot3dTest_merged_bit_select_b_2(DELAY,296)
    redist0_expZ_uid8_fpHypot3dTest_merged_bit_select_b_2 : dspba_delay
    GENERIC MAP ( width => 8, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => expZ_uid8_fpHypot3dTest_merged_bit_select_b, xout => redist0_expZ_uid8_fpHypot3dTest_merged_bit_select_b_2_q, clk => clk, aclr => areset );

    -- excZ_z_uid45_fpHypot3dTest(LOGICAL,44)@2
    excZ_z_uid45_fpHypot3dTest_q <= "1" WHEN redist0_expZ_uid8_fpHypot3dTest_merged_bit_select_b_2_q = cstAllZWE_uid14_fpHypot3dTest_q ELSE "0";

    -- expZTimes2_uid69_fpHypot3dTest(BITJOIN,68)@2
    expZTimes2_uid69_fpHypot3dTest_q <= redist0_expZ_uid8_fpHypot3dTest_merged_bit_select_b_2_q & normBitZSqr_uid64_fpHypot3dTest_b;

    -- expS_uid73_fpHypot3dTest(SUB,72)@2
    expS_uid73_fpHypot3dTest_a <= STD_LOGIC_VECTOR("0" & expZTimes2_uid69_fpHypot3dTest_q);
    expS_uid73_fpHypot3dTest_b <= STD_LOGIC_VECTOR("000" & bias_uid61_fpHypot3dTest_q);
    expS_uid73_fpHypot3dTest_o <= STD_LOGIC_VECTOR(UNSIGNED(expS_uid73_fpHypot3dTest_a) - UNSIGNED(expS_uid73_fpHypot3dTest_b));
    expS_uid73_fpHypot3dTest_q <= expS_uid73_fpHypot3dTest_o(9 downto 0);

    -- qGTEs_uid87_fpHypot3dTest(COMPARE,86)@2
    qGTEs_uid87_fpHypot3dTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((11 downto 10 => expQ_uid72_fpHypot3dTest_q(9)) & expQ_uid72_fpHypot3dTest_q));
    qGTEs_uid87_fpHypot3dTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((11 downto 10 => expS_uid73_fpHypot3dTest_q(9)) & expS_uid73_fpHypot3dTest_q));
    qGTEs_uid87_fpHypot3dTest_o <= STD_LOGIC_VECTOR(SIGNED(qGTEs_uid87_fpHypot3dTest_a) - SIGNED(qGTEs_uid87_fpHypot3dTest_b));
    qGTEs_uid87_fpHypot3dTest_n(0) <= not (qGTEs_uid87_fpHypot3dTest_o(11));

    -- expCmpGteQS_uid88_fpHypot3dTest(LOGICAL,87)@2
    expCmpGteQS_uid88_fpHypot3dTest_q <= qGTEs_uid87_fpHypot3dTest_n or excZ_z_uid45_fpHypot3dTest_q;

    -- pGTEs_uid85_fpHypot3dTest(COMPARE,84)@2
    pGTEs_uid85_fpHypot3dTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((11 downto 10 => expP_uid71_fpHypot3dTest_q(9)) & expP_uid71_fpHypot3dTest_q));
    pGTEs_uid85_fpHypot3dTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((11 downto 10 => expS_uid73_fpHypot3dTest_q(9)) & expS_uid73_fpHypot3dTest_q));
    pGTEs_uid85_fpHypot3dTest_o <= STD_LOGIC_VECTOR(SIGNED(pGTEs_uid85_fpHypot3dTest_a) - SIGNED(pGTEs_uid85_fpHypot3dTest_b));
    pGTEs_uid85_fpHypot3dTest_n(0) <= not (pGTEs_uid85_fpHypot3dTest_o(11));

    -- expCmpGtePS_uid86_fpHypot3dTest(LOGICAL,85)@2
    expCmpGtePS_uid86_fpHypot3dTest_q <= pGTEs_uid85_fpHypot3dTest_n or excZ_z_uid45_fpHypot3dTest_q;

    -- concCompareExpRes_uid89_fpHypot3dTest(BITJOIN,88)@2
    concCompareExpRes_uid89_fpHypot3dTest_q <= expCmpGtePQ_uid84_fpHypot3dTest_q & expCmpGteQS_uid88_fpHypot3dTest_q & expCmpGtePS_uid86_fpHypot3dTest_q;

    -- selCTab_uid92_fpHypot3dTest(LOOKUP,91)@2
    selCTab_uid92_fpHypot3dTest_combproc: PROCESS (concCompareExpRes_uid89_fpHypot3dTest_q)
    BEGIN
        -- Begin reserved scope level
        CASE (concCompareExpRes_uid89_fpHypot3dTest_q) IS
            WHEN "000" => selCTab_uid92_fpHypot3dTest_q <= "00";
            WHEN "001" => selCTab_uid92_fpHypot3dTest_q <= "00";
            WHEN "010" => selCTab_uid92_fpHypot3dTest_q <= "00";
            WHEN "011" => selCTab_uid92_fpHypot3dTest_q <= "10";
            WHEN "100" => selCTab_uid92_fpHypot3dTest_q <= "01";
            WHEN "101" => selCTab_uid92_fpHypot3dTest_q <= "01";
            WHEN "110" => selCTab_uid92_fpHypot3dTest_q <= "00";
            WHEN "111" => selCTab_uid92_fpHypot3dTest_q <= "10";
            WHEN OTHERS => -- unreachable
                           selCTab_uid92_fpHypot3dTest_q <= (others => '-');
        END CASE;
        -- End reserved scope level
    END PROCESS;

    -- oFracC_uid104_fpHypot3dTest(MUX,103)@2
    oFracC_uid104_fpHypot3dTest_s <= selCTab_uid92_fpHypot3dTest_q;
    oFracC_uid104_fpHypot3dTest_combproc: PROCESS (oFracC_uid104_fpHypot3dTest_s, ofracP_uid76_fpHypot3dTest_q, ofracQ_uid79_fpHypot3dTest_q, ofracS_uid82_fpHypot3dTest_q)
    BEGIN
        CASE (oFracC_uid104_fpHypot3dTest_s) IS
            WHEN "00" => oFracC_uid104_fpHypot3dTest_q <= ofracP_uid76_fpHypot3dTest_q;
            WHEN "01" => oFracC_uid104_fpHypot3dTest_q <= ofracQ_uid79_fpHypot3dTest_q;
            WHEN "10" => oFracC_uid104_fpHypot3dTest_q <= ofracS_uid82_fpHypot3dTest_q;
            WHEN "11" => oFracC_uid104_fpHypot3dTest_q <= ofracP_uid76_fpHypot3dTest_q;
            WHEN OTHERS => oFracC_uid104_fpHypot3dTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- cWFP2_uid98_fpHypot3dTest(CONSTANT,97)
    cWFP2_uid98_fpHypot3dTest_q <= "011001";

    -- expC_uid95_fpHypot3dTest(MUX,94)@2
    expC_uid95_fpHypot3dTest_s <= selCTab_uid92_fpHypot3dTest_q;
    expC_uid95_fpHypot3dTest_combproc: PROCESS (expC_uid95_fpHypot3dTest_s, expP_uid71_fpHypot3dTest_q, expQ_uid72_fpHypot3dTest_q, expS_uid73_fpHypot3dTest_q)
    BEGIN
        CASE (expC_uid95_fpHypot3dTest_s) IS
            WHEN "00" => expC_uid95_fpHypot3dTest_q <= expP_uid71_fpHypot3dTest_q;
            WHEN "01" => expC_uid95_fpHypot3dTest_q <= expQ_uid72_fpHypot3dTest_q;
            WHEN "10" => expC_uid95_fpHypot3dTest_q <= expS_uid73_fpHypot3dTest_q;
            WHEN "11" => expC_uid95_fpHypot3dTest_q <= expP_uid71_fpHypot3dTest_q;
            WHEN OTHERS => expC_uid95_fpHypot3dTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- selATab_uid90_fpHypot3dTest(LOOKUP,89)@2
    selATab_uid90_fpHypot3dTest_combproc: PROCESS (concCompareExpRes_uid89_fpHypot3dTest_q)
    BEGIN
        -- Begin reserved scope level
        CASE (concCompareExpRes_uid89_fpHypot3dTest_q) IS
            WHEN "000" => selATab_uid90_fpHypot3dTest_q <= "10";
            WHEN "001" => selATab_uid90_fpHypot3dTest_q <= "00";
            WHEN "010" => selATab_uid90_fpHypot3dTest_q <= "01";
            WHEN "011" => selATab_uid90_fpHypot3dTest_q <= "01";
            WHEN "100" => selATab_uid90_fpHypot3dTest_q <= "10";
            WHEN "101" => selATab_uid90_fpHypot3dTest_q <= "00";
            WHEN "110" => selATab_uid90_fpHypot3dTest_q <= "00";
            WHEN "111" => selATab_uid90_fpHypot3dTest_q <= "00";
            WHEN OTHERS => -- unreachable
                           selATab_uid90_fpHypot3dTest_q <= (others => '-');
        END CASE;
        -- End reserved scope level
    END PROCESS;

    -- expA_uid93_fpHypot3dTest(MUX,92)@2
    expA_uid93_fpHypot3dTest_s <= selATab_uid90_fpHypot3dTest_q;
    expA_uid93_fpHypot3dTest_combproc: PROCESS (expA_uid93_fpHypot3dTest_s, expP_uid71_fpHypot3dTest_q, expQ_uid72_fpHypot3dTest_q, expS_uid73_fpHypot3dTest_q)
    BEGIN
        CASE (expA_uid93_fpHypot3dTest_s) IS
            WHEN "00" => expA_uid93_fpHypot3dTest_q <= expP_uid71_fpHypot3dTest_q;
            WHEN "01" => expA_uid93_fpHypot3dTest_q <= expQ_uid72_fpHypot3dTest_q;
            WHEN "10" => expA_uid93_fpHypot3dTest_q <= expS_uid73_fpHypot3dTest_q;
            WHEN "11" => expA_uid93_fpHypot3dTest_q <= expP_uid71_fpHypot3dTest_q;
            WHEN OTHERS => expA_uid93_fpHypot3dTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- expAmC_uid97_fpHypot3dTest(SUB,96)@2
    expAmC_uid97_fpHypot3dTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((10 downto 10 => expA_uid93_fpHypot3dTest_q(9)) & expA_uid93_fpHypot3dTest_q));
    expAmC_uid97_fpHypot3dTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((10 downto 10 => expC_uid95_fpHypot3dTest_q(9)) & expC_uid95_fpHypot3dTest_q));
    expAmC_uid97_fpHypot3dTest_o <= STD_LOGIC_VECTOR(SIGNED(expAmC_uid97_fpHypot3dTest_a) - SIGNED(expAmC_uid97_fpHypot3dTest_b));
    expAmC_uid97_fpHypot3dTest_q <= expAmC_uid97_fpHypot3dTest_o(10 downto 0);

    -- shiftedOutC_uid101_fpHypot3dTest(COMPARE,100)@2
    shiftedOutC_uid101_fpHypot3dTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((12 downto 11 => expAmC_uid97_fpHypot3dTest_q(10)) & expAmC_uid97_fpHypot3dTest_q));
    shiftedOutC_uid101_fpHypot3dTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((12 downto 6 => cWFP2_uid98_fpHypot3dTest_q(5)) & cWFP2_uid98_fpHypot3dTest_q));
    shiftedOutC_uid101_fpHypot3dTest_o <= STD_LOGIC_VECTOR(SIGNED(shiftedOutC_uid101_fpHypot3dTest_a) - SIGNED(shiftedOutC_uid101_fpHypot3dTest_b));
    shiftedOutC_uid101_fpHypot3dTest_n(0) <= not (shiftedOutC_uid101_fpHypot3dTest_o(12));

    -- excZ_x_uid17_fpHypot3dTest(LOGICAL,16)@2
    excZ_x_uid17_fpHypot3dTest_q <= "1" WHEN redist2_expX_uid6_fpHypot3dTest_merged_bit_select_b_2_q = cstAllZWE_uid14_fpHypot3dTest_q ELSE "0";

    -- excCZero_uid112_fpHypot3dTest(MUX,111)@2
    excCZero_uid112_fpHypot3dTest_s <= selCTab_uid92_fpHypot3dTest_q;
    excCZero_uid112_fpHypot3dTest_combproc: PROCESS (excCZero_uid112_fpHypot3dTest_s, excZ_x_uid17_fpHypot3dTest_q, excZ_y_uid31_fpHypot3dTest_q, excZ_z_uid45_fpHypot3dTest_q)
    BEGIN
        CASE (excCZero_uid112_fpHypot3dTest_s) IS
            WHEN "00" => excCZero_uid112_fpHypot3dTest_q <= excZ_x_uid17_fpHypot3dTest_q;
            WHEN "01" => excCZero_uid112_fpHypot3dTest_q <= excZ_y_uid31_fpHypot3dTest_q;
            WHEN "10" => excCZero_uid112_fpHypot3dTest_q <= excZ_z_uid45_fpHypot3dTest_q;
            WHEN "11" => excCZero_uid112_fpHypot3dTest_q <= excZ_x_uid17_fpHypot3dTest_q;
            WHEN OTHERS => excCZero_uid112_fpHypot3dTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- oFracCFlushToZero_uid114_fpHypot3dTest(LOGICAL,113)@2
    oFracCFlushToZero_uid114_fpHypot3dTest_q <= excCZero_uid112_fpHypot3dTest_q or shiftedOutC_uid101_fpHypot3dTest_n;

    -- oFracCPostExc_uid116_fpHypot3dTest(MUX,115)@2 + 1
    oFracCPostExc_uid116_fpHypot3dTest_s <= oFracCFlushToZero_uid114_fpHypot3dTest_q;
    oFracCPostExc_uid116_fpHypot3dTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            oFracCPostExc_uid116_fpHypot3dTest_q <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            CASE (oFracCPostExc_uid116_fpHypot3dTest_s) IS
                WHEN "0" => oFracCPostExc_uid116_fpHypot3dTest_q <= oFracC_uid104_fpHypot3dTest_q;
                WHEN "1" => oFracCPostExc_uid116_fpHypot3dTest_q <= zerosWFp1_uid115_fpHypot3dTest_q;
                WHEN OTHERS => oFracCPostExc_uid116_fpHypot3dTest_q <= (others => '0');
            END CASE;
        END IF;
    END PROCESS;

    -- oFracBPostExcG_uid122_fpHypot3dTest(BITJOIN,121)@3
    oFracBPostExcG_uid122_fpHypot3dTest_q <= oFracCPostExc_uid116_fpHypot3dTest_q & cstZ2_uid119_fpHypot3dTest_q;

    -- rightShiftStage0_uid266_alignFracC_uid125_fpHypot3dTest(MUX,265)@3
    rightShiftStage0_uid266_alignFracC_uid125_fpHypot3dTest_s <= rightShiftStageSel4Dto3_uid265_alignFracC_uid125_fpHypot3dTest_merged_bit_select_b;
    rightShiftStage0_uid266_alignFracC_uid125_fpHypot3dTest_combproc: PROCESS (rightShiftStage0_uid266_alignFracC_uid125_fpHypot3dTest_s, oFracBPostExcG_uid122_fpHypot3dTest_q, rightShiftStage0Idx1_uid258_alignFracC_uid125_fpHypot3dTest_q, rightShiftStage0Idx2_uid261_alignFracC_uid125_fpHypot3dTest_q, rightShiftStage0Idx3_uid264_alignFracC_uid125_fpHypot3dTest_q)
    BEGIN
        CASE (rightShiftStage0_uid266_alignFracC_uid125_fpHypot3dTest_s) IS
            WHEN "00" => rightShiftStage0_uid266_alignFracC_uid125_fpHypot3dTest_q <= oFracBPostExcG_uid122_fpHypot3dTest_q;
            WHEN "01" => rightShiftStage0_uid266_alignFracC_uid125_fpHypot3dTest_q <= rightShiftStage0Idx1_uid258_alignFracC_uid125_fpHypot3dTest_q;
            WHEN "10" => rightShiftStage0_uid266_alignFracC_uid125_fpHypot3dTest_q <= rightShiftStage0Idx2_uid261_alignFracC_uid125_fpHypot3dTest_q;
            WHEN "11" => rightShiftStage0_uid266_alignFracC_uid125_fpHypot3dTest_q <= rightShiftStage0Idx3_uid264_alignFracC_uid125_fpHypot3dTest_q;
            WHEN OTHERS => rightShiftStage0_uid266_alignFracC_uid125_fpHypot3dTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- rightShiftStage1_uid277_alignFracC_uid125_fpHypot3dTest(MUX,276)@3
    rightShiftStage1_uid277_alignFracC_uid125_fpHypot3dTest_s <= rightShiftStageSel4Dto3_uid265_alignFracC_uid125_fpHypot3dTest_merged_bit_select_c;
    rightShiftStage1_uid277_alignFracC_uid125_fpHypot3dTest_combproc: PROCESS (rightShiftStage1_uid277_alignFracC_uid125_fpHypot3dTest_s, rightShiftStage0_uid266_alignFracC_uid125_fpHypot3dTest_q, rightShiftStage1Idx1_uid269_alignFracC_uid125_fpHypot3dTest_q, rightShiftStage1Idx2_uid272_alignFracC_uid125_fpHypot3dTest_q, rightShiftStage1Idx3_uid275_alignFracC_uid125_fpHypot3dTest_q)
    BEGIN
        CASE (rightShiftStage1_uid277_alignFracC_uid125_fpHypot3dTest_s) IS
            WHEN "00" => rightShiftStage1_uid277_alignFracC_uid125_fpHypot3dTest_q <= rightShiftStage0_uid266_alignFracC_uid125_fpHypot3dTest_q;
            WHEN "01" => rightShiftStage1_uid277_alignFracC_uid125_fpHypot3dTest_q <= rightShiftStage1Idx1_uid269_alignFracC_uid125_fpHypot3dTest_q;
            WHEN "10" => rightShiftStage1_uid277_alignFracC_uid125_fpHypot3dTest_q <= rightShiftStage1Idx2_uid272_alignFracC_uid125_fpHypot3dTest_q;
            WHEN "11" => rightShiftStage1_uid277_alignFracC_uid125_fpHypot3dTest_q <= rightShiftStage1Idx3_uid275_alignFracC_uid125_fpHypot3dTest_q;
            WHEN OTHERS => rightShiftStage1_uid277_alignFracC_uid125_fpHypot3dTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- cstbfvZwfp1_uid105_fpHypot3dTest(CONSTANT,104)
    cstbfvZwfp1_uid105_fpHypot3dTest_q <= "00000";

    -- expDiffShiftRangeC_uid108_fpHypot3dTest(BITSELECT,107)@2
    expDiffShiftRangeC_uid108_fpHypot3dTest_in <= expAmC_uid97_fpHypot3dTest_q(4 downto 0);
    expDiffShiftRangeC_uid108_fpHypot3dTest_b <= expDiffShiftRangeC_uid108_fpHypot3dTest_in(4 downto 0);

    -- selBTab_uid91_fpHypot3dTest(LOOKUP,90)@2
    selBTab_uid91_fpHypot3dTest_combproc: PROCESS (concCompareExpRes_uid89_fpHypot3dTest_q)
    BEGIN
        -- Begin reserved scope level
        CASE (concCompareExpRes_uid89_fpHypot3dTest_q) IS
            WHEN "000" => selBTab_uid91_fpHypot3dTest_q <= "01";
            WHEN "001" => selBTab_uid91_fpHypot3dTest_q <= "00";
            WHEN "010" => selBTab_uid91_fpHypot3dTest_q <= "10";
            WHEN "011" => selBTab_uid91_fpHypot3dTest_q <= "00";
            WHEN "100" => selBTab_uid91_fpHypot3dTest_q <= "00";
            WHEN "101" => selBTab_uid91_fpHypot3dTest_q <= "10";
            WHEN "110" => selBTab_uid91_fpHypot3dTest_q <= "00";
            WHEN "111" => selBTab_uid91_fpHypot3dTest_q <= "01";
            WHEN OTHERS => -- unreachable
                           selBTab_uid91_fpHypot3dTest_q <= (others => '-');
        END CASE;
        -- End reserved scope level
    END PROCESS;

    -- expB_uid94_fpHypot3dTest(MUX,93)@2
    expB_uid94_fpHypot3dTest_s <= selBTab_uid91_fpHypot3dTest_q;
    expB_uid94_fpHypot3dTest_combproc: PROCESS (expB_uid94_fpHypot3dTest_s, expP_uid71_fpHypot3dTest_q, expQ_uid72_fpHypot3dTest_q, expS_uid73_fpHypot3dTest_q)
    BEGIN
        CASE (expB_uid94_fpHypot3dTest_s) IS
            WHEN "00" => expB_uid94_fpHypot3dTest_q <= expP_uid71_fpHypot3dTest_q;
            WHEN "01" => expB_uid94_fpHypot3dTest_q <= expQ_uid72_fpHypot3dTest_q;
            WHEN "10" => expB_uid94_fpHypot3dTest_q <= expS_uid73_fpHypot3dTest_q;
            WHEN "11" => expB_uid94_fpHypot3dTest_q <= expP_uid71_fpHypot3dTest_q;
            WHEN OTHERS => expB_uid94_fpHypot3dTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- expAmB_uid96_fpHypot3dTest(SUB,95)@2
    expAmB_uid96_fpHypot3dTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((10 downto 10 => expA_uid93_fpHypot3dTest_q(9)) & expA_uid93_fpHypot3dTest_q));
    expAmB_uid96_fpHypot3dTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((10 downto 10 => expB_uid94_fpHypot3dTest_q(9)) & expB_uid94_fpHypot3dTest_q));
    expAmB_uid96_fpHypot3dTest_o <= STD_LOGIC_VECTOR(SIGNED(expAmB_uid96_fpHypot3dTest_a) - SIGNED(expAmB_uid96_fpHypot3dTest_b));
    expAmB_uid96_fpHypot3dTest_q <= expAmB_uid96_fpHypot3dTest_o(10 downto 0);

    -- shiftedOutB_uid99_fpHypot3dTest(COMPARE,98)@2
    shiftedOutB_uid99_fpHypot3dTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((12 downto 11 => expAmB_uid96_fpHypot3dTest_q(10)) & expAmB_uid96_fpHypot3dTest_q));
    shiftedOutB_uid99_fpHypot3dTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((12 downto 6 => cWFP2_uid98_fpHypot3dTest_q(5)) & cWFP2_uid98_fpHypot3dTest_q));
    shiftedOutB_uid99_fpHypot3dTest_o <= STD_LOGIC_VECTOR(SIGNED(shiftedOutB_uid99_fpHypot3dTest_a) - SIGNED(shiftedOutB_uid99_fpHypot3dTest_b));
    shiftedOutB_uid99_fpHypot3dTest_n(0) <= not (shiftedOutB_uid99_fpHypot3dTest_o(12));

    -- shiftValueC_uid109_fpHypot3dTest(MUX,108)@2 + 1
    shiftValueC_uid109_fpHypot3dTest_s <= shiftedOutB_uid99_fpHypot3dTest_n;
    shiftValueC_uid109_fpHypot3dTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            shiftValueC_uid109_fpHypot3dTest_q <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            CASE (shiftValueC_uid109_fpHypot3dTest_s) IS
                WHEN "0" => shiftValueC_uid109_fpHypot3dTest_q <= expDiffShiftRangeC_uid108_fpHypot3dTest_b;
                WHEN "1" => shiftValueC_uid109_fpHypot3dTest_q <= cstbfvZwfp1_uid105_fpHypot3dTest_q;
                WHEN OTHERS => shiftValueC_uid109_fpHypot3dTest_q <= (others => '0');
            END CASE;
        END IF;
    END PROCESS;

    -- rightShiftStageSel4Dto3_uid265_alignFracC_uid125_fpHypot3dTest_merged_bit_select(BITSELECT,295)@3
    rightShiftStageSel4Dto3_uid265_alignFracC_uid125_fpHypot3dTest_merged_bit_select_b <= shiftValueC_uid109_fpHypot3dTest_q(4 downto 3);
    rightShiftStageSel4Dto3_uid265_alignFracC_uid125_fpHypot3dTest_merged_bit_select_c <= shiftValueC_uid109_fpHypot3dTest_q(2 downto 1);
    rightShiftStageSel4Dto3_uid265_alignFracC_uid125_fpHypot3dTest_merged_bit_select_d <= shiftValueC_uid109_fpHypot3dTest_q(0 downto 0);

    -- rightShiftStage2_uid282_alignFracC_uid125_fpHypot3dTest(MUX,281)@3
    rightShiftStage2_uid282_alignFracC_uid125_fpHypot3dTest_s <= rightShiftStageSel4Dto3_uid265_alignFracC_uid125_fpHypot3dTest_merged_bit_select_d;
    rightShiftStage2_uid282_alignFracC_uid125_fpHypot3dTest_combproc: PROCESS (rightShiftStage2_uid282_alignFracC_uid125_fpHypot3dTest_s, rightShiftStage1_uid277_alignFracC_uid125_fpHypot3dTest_q, rightShiftStage2Idx1_uid280_alignFracC_uid125_fpHypot3dTest_q)
    BEGIN
        CASE (rightShiftStage2_uid282_alignFracC_uid125_fpHypot3dTest_s) IS
            WHEN "0" => rightShiftStage2_uid282_alignFracC_uid125_fpHypot3dTest_q <= rightShiftStage1_uid277_alignFracC_uid125_fpHypot3dTest_q;
            WHEN "1" => rightShiftStage2_uid282_alignFracC_uid125_fpHypot3dTest_q <= rightShiftStage2Idx1_uid280_alignFracC_uid125_fpHypot3dTest_q;
            WHEN OTHERS => rightShiftStage2_uid282_alignFracC_uid125_fpHypot3dTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- rightShiftStage2Idx1Rng1_uid248_alignFracB_uid124_fpHypot3dTest(BITSELECT,247)@3
    rightShiftStage2Idx1Rng1_uid248_alignFracB_uid124_fpHypot3dTest_b <= rightShiftStage1_uid247_alignFracB_uid124_fpHypot3dTest_q(25 downto 1);

    -- rightShiftStage2Idx1_uid250_alignFracB_uid124_fpHypot3dTest(BITJOIN,249)@3
    rightShiftStage2Idx1_uid250_alignFracB_uid124_fpHypot3dTest_q <= GND_q & rightShiftStage2Idx1Rng1_uid248_alignFracB_uid124_fpHypot3dTest_b;

    -- rightShiftStage1Idx3Rng6_uid243_alignFracB_uid124_fpHypot3dTest(BITSELECT,242)@3
    rightShiftStage1Idx3Rng6_uid243_alignFracB_uid124_fpHypot3dTest_b <= rightShiftStage0_uid236_alignFracB_uid124_fpHypot3dTest_q(25 downto 6);

    -- rightShiftStage1Idx3_uid245_alignFracB_uid124_fpHypot3dTest(BITJOIN,244)@3
    rightShiftStage1Idx3_uid245_alignFracB_uid124_fpHypot3dTest_q <= rightShiftStage1Idx3Pad6_uid244_alignFracB_uid124_fpHypot3dTest_q & rightShiftStage1Idx3Rng6_uid243_alignFracB_uid124_fpHypot3dTest_b;

    -- rightShiftStage1Idx2Rng4_uid240_alignFracB_uid124_fpHypot3dTest(BITSELECT,239)@3
    rightShiftStage1Idx2Rng4_uid240_alignFracB_uid124_fpHypot3dTest_b <= rightShiftStage0_uid236_alignFracB_uid124_fpHypot3dTest_q(25 downto 4);

    -- rightShiftStage1Idx2_uid242_alignFracB_uid124_fpHypot3dTest(BITJOIN,241)@3
    rightShiftStage1Idx2_uid242_alignFracB_uid124_fpHypot3dTest_q <= rightShiftStage1Idx2Pad4_uid241_alignFracB_uid124_fpHypot3dTest_q & rightShiftStage1Idx2Rng4_uid240_alignFracB_uid124_fpHypot3dTest_b;

    -- rightShiftStage1Idx1Rng2_uid237_alignFracB_uid124_fpHypot3dTest(BITSELECT,236)@3
    rightShiftStage1Idx1Rng2_uid237_alignFracB_uid124_fpHypot3dTest_b <= rightShiftStage0_uid236_alignFracB_uid124_fpHypot3dTest_q(25 downto 2);

    -- rightShiftStage1Idx1_uid239_alignFracB_uid124_fpHypot3dTest(BITJOIN,238)@3
    rightShiftStage1Idx1_uid239_alignFracB_uid124_fpHypot3dTest_q <= cstZ2_uid119_fpHypot3dTest_q & rightShiftStage1Idx1Rng2_uid237_alignFracB_uid124_fpHypot3dTest_b;

    -- rightShiftStage0Idx3Rng24_uid232_alignFracB_uid124_fpHypot3dTest(BITSELECT,231)@3
    rightShiftStage0Idx3Rng24_uid232_alignFracB_uid124_fpHypot3dTest_b <= oFracBPostExcG_uid120_fpHypot3dTest_q(25 downto 24);

    -- rightShiftStage0Idx3_uid234_alignFracB_uid124_fpHypot3dTest(BITJOIN,233)@3
    rightShiftStage0Idx3_uid234_alignFracB_uid124_fpHypot3dTest_q <= zerosWFp1_uid115_fpHypot3dTest_q & rightShiftStage0Idx3Rng24_uid232_alignFracB_uid124_fpHypot3dTest_b;

    -- rightShiftStage0Idx2Rng16_uid229_alignFracB_uid124_fpHypot3dTest(BITSELECT,228)@3
    rightShiftStage0Idx2Rng16_uid229_alignFracB_uid124_fpHypot3dTest_b <= oFracBPostExcG_uid120_fpHypot3dTest_q(25 downto 16);

    -- rightShiftStage0Idx2_uid231_alignFracB_uid124_fpHypot3dTest(BITJOIN,230)@3
    rightShiftStage0Idx2_uid231_alignFracB_uid124_fpHypot3dTest_q <= rightShiftStage0Idx2Pad16_uid230_alignFracB_uid124_fpHypot3dTest_q & rightShiftStage0Idx2Rng16_uid229_alignFracB_uid124_fpHypot3dTest_b;

    -- rightShiftStage0Idx1Rng8_uid226_alignFracB_uid124_fpHypot3dTest(BITSELECT,225)@3
    rightShiftStage0Idx1Rng8_uid226_alignFracB_uid124_fpHypot3dTest_b <= oFracBPostExcG_uid120_fpHypot3dTest_q(25 downto 8);

    -- rightShiftStage0Idx1_uid228_alignFracB_uid124_fpHypot3dTest(BITJOIN,227)@3
    rightShiftStage0Idx1_uid228_alignFracB_uid124_fpHypot3dTest_q <= cstAllZWE_uid14_fpHypot3dTest_q & rightShiftStage0Idx1Rng8_uid226_alignFracB_uid124_fpHypot3dTest_b;

    -- oFracB_uid103_fpHypot3dTest(MUX,102)@2
    oFracB_uid103_fpHypot3dTest_s <= selBTab_uid91_fpHypot3dTest_q;
    oFracB_uid103_fpHypot3dTest_combproc: PROCESS (oFracB_uid103_fpHypot3dTest_s, ofracP_uid76_fpHypot3dTest_q, ofracQ_uid79_fpHypot3dTest_q, ofracS_uid82_fpHypot3dTest_q)
    BEGIN
        CASE (oFracB_uid103_fpHypot3dTest_s) IS
            WHEN "00" => oFracB_uid103_fpHypot3dTest_q <= ofracP_uid76_fpHypot3dTest_q;
            WHEN "01" => oFracB_uid103_fpHypot3dTest_q <= ofracQ_uid79_fpHypot3dTest_q;
            WHEN "10" => oFracB_uid103_fpHypot3dTest_q <= ofracS_uid82_fpHypot3dTest_q;
            WHEN "11" => oFracB_uid103_fpHypot3dTest_q <= ofracP_uid76_fpHypot3dTest_q;
            WHEN OTHERS => oFracB_uid103_fpHypot3dTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- excBZero_uid111_fpHypot3dTest(MUX,110)@2
    excBZero_uid111_fpHypot3dTest_s <= selBTab_uid91_fpHypot3dTest_q;
    excBZero_uid111_fpHypot3dTest_combproc: PROCESS (excBZero_uid111_fpHypot3dTest_s, excZ_x_uid17_fpHypot3dTest_q, excZ_y_uid31_fpHypot3dTest_q, excZ_z_uid45_fpHypot3dTest_q)
    BEGIN
        CASE (excBZero_uid111_fpHypot3dTest_s) IS
            WHEN "00" => excBZero_uid111_fpHypot3dTest_q <= excZ_x_uid17_fpHypot3dTest_q;
            WHEN "01" => excBZero_uid111_fpHypot3dTest_q <= excZ_y_uid31_fpHypot3dTest_q;
            WHEN "10" => excBZero_uid111_fpHypot3dTest_q <= excZ_z_uid45_fpHypot3dTest_q;
            WHEN "11" => excBZero_uid111_fpHypot3dTest_q <= excZ_x_uid17_fpHypot3dTest_q;
            WHEN OTHERS => excBZero_uid111_fpHypot3dTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- oFracBFlushToZero_uid113_fpHypot3dTest(LOGICAL,112)@2
    oFracBFlushToZero_uid113_fpHypot3dTest_q <= excBZero_uid111_fpHypot3dTest_q or shiftedOutB_uid99_fpHypot3dTest_n;

    -- oFracBPostExc_uid117_fpHypot3dTest(MUX,116)@2 + 1
    oFracBPostExc_uid117_fpHypot3dTest_s <= oFracBFlushToZero_uid113_fpHypot3dTest_q;
    oFracBPostExc_uid117_fpHypot3dTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            oFracBPostExc_uid117_fpHypot3dTest_q <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            CASE (oFracBPostExc_uid117_fpHypot3dTest_s) IS
                WHEN "0" => oFracBPostExc_uid117_fpHypot3dTest_q <= oFracB_uid103_fpHypot3dTest_q;
                WHEN "1" => oFracBPostExc_uid117_fpHypot3dTest_q <= zerosWFp1_uid115_fpHypot3dTest_q;
                WHEN OTHERS => oFracBPostExc_uid117_fpHypot3dTest_q <= (others => '0');
            END CASE;
        END IF;
    END PROCESS;

    -- oFracBPostExcG_uid120_fpHypot3dTest(BITJOIN,119)@3
    oFracBPostExcG_uid120_fpHypot3dTest_q <= oFracBPostExc_uid117_fpHypot3dTest_q & cstZ2_uid119_fpHypot3dTest_q;

    -- rightShiftStage0_uid236_alignFracB_uid124_fpHypot3dTest(MUX,235)@3
    rightShiftStage0_uid236_alignFracB_uid124_fpHypot3dTest_s <= rightShiftStageSel4Dto3_uid235_alignFracB_uid124_fpHypot3dTest_merged_bit_select_b;
    rightShiftStage0_uid236_alignFracB_uid124_fpHypot3dTest_combproc: PROCESS (rightShiftStage0_uid236_alignFracB_uid124_fpHypot3dTest_s, oFracBPostExcG_uid120_fpHypot3dTest_q, rightShiftStage0Idx1_uid228_alignFracB_uid124_fpHypot3dTest_q, rightShiftStage0Idx2_uid231_alignFracB_uid124_fpHypot3dTest_q, rightShiftStage0Idx3_uid234_alignFracB_uid124_fpHypot3dTest_q)
    BEGIN
        CASE (rightShiftStage0_uid236_alignFracB_uid124_fpHypot3dTest_s) IS
            WHEN "00" => rightShiftStage0_uid236_alignFracB_uid124_fpHypot3dTest_q <= oFracBPostExcG_uid120_fpHypot3dTest_q;
            WHEN "01" => rightShiftStage0_uid236_alignFracB_uid124_fpHypot3dTest_q <= rightShiftStage0Idx1_uid228_alignFracB_uid124_fpHypot3dTest_q;
            WHEN "10" => rightShiftStage0_uid236_alignFracB_uid124_fpHypot3dTest_q <= rightShiftStage0Idx2_uid231_alignFracB_uid124_fpHypot3dTest_q;
            WHEN "11" => rightShiftStage0_uid236_alignFracB_uid124_fpHypot3dTest_q <= rightShiftStage0Idx3_uid234_alignFracB_uid124_fpHypot3dTest_q;
            WHEN OTHERS => rightShiftStage0_uid236_alignFracB_uid124_fpHypot3dTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- rightShiftStage1_uid247_alignFracB_uid124_fpHypot3dTest(MUX,246)@3
    rightShiftStage1_uid247_alignFracB_uid124_fpHypot3dTest_s <= rightShiftStageSel4Dto3_uid235_alignFracB_uid124_fpHypot3dTest_merged_bit_select_c;
    rightShiftStage1_uid247_alignFracB_uid124_fpHypot3dTest_combproc: PROCESS (rightShiftStage1_uid247_alignFracB_uid124_fpHypot3dTest_s, rightShiftStage0_uid236_alignFracB_uid124_fpHypot3dTest_q, rightShiftStage1Idx1_uid239_alignFracB_uid124_fpHypot3dTest_q, rightShiftStage1Idx2_uid242_alignFracB_uid124_fpHypot3dTest_q, rightShiftStage1Idx3_uid245_alignFracB_uid124_fpHypot3dTest_q)
    BEGIN
        CASE (rightShiftStage1_uid247_alignFracB_uid124_fpHypot3dTest_s) IS
            WHEN "00" => rightShiftStage1_uid247_alignFracB_uid124_fpHypot3dTest_q <= rightShiftStage0_uid236_alignFracB_uid124_fpHypot3dTest_q;
            WHEN "01" => rightShiftStage1_uid247_alignFracB_uid124_fpHypot3dTest_q <= rightShiftStage1Idx1_uid239_alignFracB_uid124_fpHypot3dTest_q;
            WHEN "10" => rightShiftStage1_uid247_alignFracB_uid124_fpHypot3dTest_q <= rightShiftStage1Idx2_uid242_alignFracB_uid124_fpHypot3dTest_q;
            WHEN "11" => rightShiftStage1_uid247_alignFracB_uid124_fpHypot3dTest_q <= rightShiftStage1Idx3_uid245_alignFracB_uid124_fpHypot3dTest_q;
            WHEN OTHERS => rightShiftStage1_uid247_alignFracB_uid124_fpHypot3dTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- expDiffShiftRangeB_uid106_fpHypot3dTest(BITSELECT,105)@2
    expDiffShiftRangeB_uid106_fpHypot3dTest_in <= expAmB_uid96_fpHypot3dTest_q(4 downto 0);
    expDiffShiftRangeB_uid106_fpHypot3dTest_b <= expDiffShiftRangeB_uid106_fpHypot3dTest_in(4 downto 0);

    -- shiftValueB_uid107_fpHypot3dTest(MUX,106)@2 + 1
    shiftValueB_uid107_fpHypot3dTest_s <= shiftedOutB_uid99_fpHypot3dTest_n;
    shiftValueB_uid107_fpHypot3dTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            shiftValueB_uid107_fpHypot3dTest_q <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            CASE (shiftValueB_uid107_fpHypot3dTest_s) IS
                WHEN "0" => shiftValueB_uid107_fpHypot3dTest_q <= expDiffShiftRangeB_uid106_fpHypot3dTest_b;
                WHEN "1" => shiftValueB_uid107_fpHypot3dTest_q <= cstbfvZwfp1_uid105_fpHypot3dTest_q;
                WHEN OTHERS => shiftValueB_uid107_fpHypot3dTest_q <= (others => '0');
            END CASE;
        END IF;
    END PROCESS;

    -- rightShiftStageSel4Dto3_uid235_alignFracB_uid124_fpHypot3dTest_merged_bit_select(BITSELECT,294)@3
    rightShiftStageSel4Dto3_uid235_alignFracB_uid124_fpHypot3dTest_merged_bit_select_b <= shiftValueB_uid107_fpHypot3dTest_q(4 downto 3);
    rightShiftStageSel4Dto3_uid235_alignFracB_uid124_fpHypot3dTest_merged_bit_select_c <= shiftValueB_uid107_fpHypot3dTest_q(2 downto 1);
    rightShiftStageSel4Dto3_uid235_alignFracB_uid124_fpHypot3dTest_merged_bit_select_d <= shiftValueB_uid107_fpHypot3dTest_q(0 downto 0);

    -- rightShiftStage2_uid252_alignFracB_uid124_fpHypot3dTest(MUX,251)@3
    rightShiftStage2_uid252_alignFracB_uid124_fpHypot3dTest_s <= rightShiftStageSel4Dto3_uid235_alignFracB_uid124_fpHypot3dTest_merged_bit_select_d;
    rightShiftStage2_uid252_alignFracB_uid124_fpHypot3dTest_combproc: PROCESS (rightShiftStage2_uid252_alignFracB_uid124_fpHypot3dTest_s, rightShiftStage1_uid247_alignFracB_uid124_fpHypot3dTest_q, rightShiftStage2Idx1_uid250_alignFracB_uid124_fpHypot3dTest_q)
    BEGIN
        CASE (rightShiftStage2_uid252_alignFracB_uid124_fpHypot3dTest_s) IS
            WHEN "0" => rightShiftStage2_uid252_alignFracB_uid124_fpHypot3dTest_q <= rightShiftStage1_uid247_alignFracB_uid124_fpHypot3dTest_q;
            WHEN "1" => rightShiftStage2_uid252_alignFracB_uid124_fpHypot3dTest_q <= rightShiftStage2Idx1_uid250_alignFracB_uid124_fpHypot3dTest_q;
            WHEN OTHERS => rightShiftStage2_uid252_alignFracB_uid124_fpHypot3dTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- oFracA_uid102_fpHypot3dTest(MUX,101)@2
    oFracA_uid102_fpHypot3dTest_s <= selATab_uid90_fpHypot3dTest_q;
    oFracA_uid102_fpHypot3dTest_combproc: PROCESS (oFracA_uid102_fpHypot3dTest_s, ofracP_uid76_fpHypot3dTest_q, ofracQ_uid79_fpHypot3dTest_q, ofracS_uid82_fpHypot3dTest_q)
    BEGIN
        CASE (oFracA_uid102_fpHypot3dTest_s) IS
            WHEN "00" => oFracA_uid102_fpHypot3dTest_q <= ofracP_uid76_fpHypot3dTest_q;
            WHEN "01" => oFracA_uid102_fpHypot3dTest_q <= ofracQ_uid79_fpHypot3dTest_q;
            WHEN "10" => oFracA_uid102_fpHypot3dTest_q <= ofracS_uid82_fpHypot3dTest_q;
            WHEN "11" => oFracA_uid102_fpHypot3dTest_q <= ofracP_uid76_fpHypot3dTest_q;
            WHEN OTHERS => oFracA_uid102_fpHypot3dTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- excAZero_uid110_fpHypot3dTest(MUX,109)@2
    excAZero_uid110_fpHypot3dTest_s <= selATab_uid90_fpHypot3dTest_q;
    excAZero_uid110_fpHypot3dTest_combproc: PROCESS (excAZero_uid110_fpHypot3dTest_s, excZ_x_uid17_fpHypot3dTest_q, excZ_y_uid31_fpHypot3dTest_q, excZ_z_uid45_fpHypot3dTest_q)
    BEGIN
        CASE (excAZero_uid110_fpHypot3dTest_s) IS
            WHEN "00" => excAZero_uid110_fpHypot3dTest_q <= excZ_x_uid17_fpHypot3dTest_q;
            WHEN "01" => excAZero_uid110_fpHypot3dTest_q <= excZ_y_uid31_fpHypot3dTest_q;
            WHEN "10" => excAZero_uid110_fpHypot3dTest_q <= excZ_z_uid45_fpHypot3dTest_q;
            WHEN "11" => excAZero_uid110_fpHypot3dTest_q <= excZ_x_uid17_fpHypot3dTest_q;
            WHEN OTHERS => excAZero_uid110_fpHypot3dTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- oFracAPostExc_uid118_fpHypot3dTest(MUX,117)@2 + 1
    oFracAPostExc_uid118_fpHypot3dTest_s <= excAZero_uid110_fpHypot3dTest_q;
    oFracAPostExc_uid118_fpHypot3dTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            oFracAPostExc_uid118_fpHypot3dTest_q <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            CASE (oFracAPostExc_uid118_fpHypot3dTest_s) IS
                WHEN "0" => oFracAPostExc_uid118_fpHypot3dTest_q <= oFracA_uid102_fpHypot3dTest_q;
                WHEN "1" => oFracAPostExc_uid118_fpHypot3dTest_q <= zerosWFp1_uid115_fpHypot3dTest_q;
                WHEN OTHERS => oFracAPostExc_uid118_fpHypot3dTest_q <= (others => '0');
            END CASE;
        END IF;
    END PROCESS;

    -- pad_oFracAPostExc_uid118_uid126_fpHypot3dTest(BITJOIN,125)@3
    pad_oFracAPostExc_uid118_uid126_fpHypot3dTest_q <= oFracAPostExc_uid118_fpHypot3dTest_q & STD_LOGIC_VECTOR((1 downto 1 => GND_q(0)) & GND_q);

    -- soSPreNorm_uid126_fpHypot3dTest(ADDSUB3,126)@3
    soSPreNorm_uid126_fpHypot3dTest_a <= STD_LOGIC_VECTOR("00" & pad_oFracAPostExc_uid118_uid126_fpHypot3dTest_q);
    soSPreNorm_uid126_fpHypot3dTest_b <= STD_LOGIC_VECTOR("00" & rightShiftStage2_uid252_alignFracB_uid124_fpHypot3dTest_q);
    soSPreNorm_uid126_fpHypot3dTest_c <= STD_LOGIC_VECTOR("00" & rightShiftStage2_uid282_alignFracC_uid125_fpHypot3dTest_q);
    soSPreNorm_uid126_fpHypot3dTest_o <= STD_LOGIC_VECTOR(UNSIGNED(soSPreNorm_uid126_fpHypot3dTest_a) + UNSIGNED(soSPreNorm_uid126_fpHypot3dTest_b) + UNSIGNED(soSPreNorm_uid126_fpHypot3dTest_c));
    soSPreNorm_uid126_fpHypot3dTest_q <= soSPreNorm_uid126_fpHypot3dTest_o(27 downto 0);


    -- sumOfSquareNormBits_uid128_fpHypot3dTest(BITSELECT,127)@3
    sumOfSquareNormBits_uid128_fpHypot3dTest_b <= soSPreNorm_uid126_fpHypot3dTest_q(27 downto 26);

    -- expUpdateVal_uid138_fpHypot3dTest(MUX,137)@3
    expUpdateVal_uid138_fpHypot3dTest_s <= sumOfSquareNormBits_uid128_fpHypot3dTest_b;
    expUpdateVal_uid138_fpHypot3dTest_combproc: PROCESS (expUpdateVal_uid138_fpHypot3dTest_s, cstZ2_uid119_fpHypot3dTest_q, cst01_2_uid136_fpHypot3dTest_q, cst10_2_uid137_fpHypot3dTest_q)
    BEGIN
        CASE (expUpdateVal_uid138_fpHypot3dTest_s) IS
            WHEN "00" => expUpdateVal_uid138_fpHypot3dTest_q <= cstZ2_uid119_fpHypot3dTest_q;
            WHEN "01" => expUpdateVal_uid138_fpHypot3dTest_q <= cst01_2_uid136_fpHypot3dTest_q;
            WHEN "10" => expUpdateVal_uid138_fpHypot3dTest_q <= cst10_2_uid137_fpHypot3dTest_q;
            WHEN "11" => expUpdateVal_uid138_fpHypot3dTest_q <= cst10_2_uid137_fpHypot3dTest_q;
            WHEN OTHERS => expUpdateVal_uid138_fpHypot3dTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- soSRangeHigh_uid129_fpHypot3dTest(BITSELECT,128)@3
    soSRangeHigh_uid129_fpHypot3dTest_in <= soSPreNorm_uid126_fpHypot3dTest_q(26 downto 0);
    soSRangeHigh_uid129_fpHypot3dTest_b <= soSRangeHigh_uid129_fpHypot3dTest_in(26 downto 3);

    -- soSRangeMed_uid130_fpHypot3dTest(BITSELECT,129)@3
    soSRangeMed_uid130_fpHypot3dTest_in <= soSPreNorm_uid126_fpHypot3dTest_q(25 downto 0);
    soSRangeMed_uid130_fpHypot3dTest_b <= soSRangeMed_uid130_fpHypot3dTest_in(25 downto 2);

    -- soSRangeLow_uid131_fpHypot3dTest(BITSELECT,130)@3
    soSRangeLow_uid131_fpHypot3dTest_in <= soSPreNorm_uid126_fpHypot3dTest_q(24 downto 0);
    soSRangeLow_uid131_fpHypot3dTest_b <= soSRangeLow_uid131_fpHypot3dTest_in(24 downto 1);

    -- resFracNorm_uid132_fpHypot3dTest(MUX,131)@3
    resFracNorm_uid132_fpHypot3dTest_s <= sumOfSquareNormBits_uid128_fpHypot3dTest_b;
    resFracNorm_uid132_fpHypot3dTest_combproc: PROCESS (resFracNorm_uid132_fpHypot3dTest_s, soSRangeLow_uid131_fpHypot3dTest_b, soSRangeMed_uid130_fpHypot3dTest_b, soSRangeHigh_uid129_fpHypot3dTest_b)
    BEGIN
        CASE (resFracNorm_uid132_fpHypot3dTest_s) IS
            WHEN "00" => resFracNorm_uid132_fpHypot3dTest_q <= soSRangeLow_uid131_fpHypot3dTest_b;
            WHEN "01" => resFracNorm_uid132_fpHypot3dTest_q <= soSRangeMed_uid130_fpHypot3dTest_b;
            WHEN "10" => resFracNorm_uid132_fpHypot3dTest_q <= soSRangeHigh_uid129_fpHypot3dTest_b;
            WHEN "11" => resFracNorm_uid132_fpHypot3dTest_q <= soSRangeHigh_uid129_fpHypot3dTest_b;
            WHEN OTHERS => resFracNorm_uid132_fpHypot3dTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- normCatFracSoS_uid140_fpHypot3dTest(BITJOIN,139)@3
    normCatFracSoS_uid140_fpHypot3dTest_q <= expUpdateVal_uid138_fpHypot3dTest_q & resFracNorm_uid132_fpHypot3dTest_q;

    -- redist11_expA_uid93_fpHypot3dTest_q_1(DELAY,307)
    redist11_expA_uid93_fpHypot3dTest_q_1 : dspba_delay
    GENERIC MAP ( width => 10, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => expA_uid93_fpHypot3dTest_q, xout => redist11_expA_uid93_fpHypot3dTest_q_1_q, clk => clk, aclr => areset );

    -- cstZeroWF_uid13_fpHypot3dTest(CONSTANT,12)
    cstZeroWF_uid13_fpHypot3dTest_q <= "00000000000000000000000";

    -- expCatRndBit_uid135_fpHypot3dTest(BITJOIN,134)@3
    expCatRndBit_uid135_fpHypot3dTest_q <= redist11_expA_uid93_fpHypot3dTest_q_1_q & cstZeroWF_uid13_fpHypot3dTest_q & VCC_q;

    -- expFracPostNorm_uid141_fpHypot3dTest(ADD,140)@3
    expFracPostNorm_uid141_fpHypot3dTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((35 downto 34 => expCatRndBit_uid135_fpHypot3dTest_q(33)) & expCatRndBit_uid135_fpHypot3dTest_q));
    expFracPostNorm_uid141_fpHypot3dTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("0000000000" & normCatFracSoS_uid140_fpHypot3dTest_q));
    expFracPostNorm_uid141_fpHypot3dTest_o <= STD_LOGIC_VECTOR(SIGNED(expFracPostNorm_uid141_fpHypot3dTest_a) + SIGNED(expFracPostNorm_uid141_fpHypot3dTest_b));
    expFracPostNorm_uid141_fpHypot3dTest_q <= expFracPostNorm_uid141_fpHypot3dTest_o(34 downto 0);

    -- expRPreSqrt_uid143_fpHypot3dTest(BITSELECT,142)@3
    expRPreSqrt_uid143_fpHypot3dTest_in <= STD_LOGIC_VECTOR(expFracPostNorm_uid141_fpHypot3dTest_q(33 downto 0));
    expRPreSqrt_uid143_fpHypot3dTest_b <= STD_LOGIC_VECTOR(expRPreSqrt_uid143_fpHypot3dTest_in(33 downto 24));

    -- x0_uid149_fpHypot3dTest(BITSELECT,148)@3
    x0_uid149_fpHypot3dTest_in <= STD_LOGIC_VECTOR(expRPreSqrt_uid143_fpHypot3dTest_b(0 downto 0));
    x0_uid149_fpHypot3dTest_b <= STD_LOGIC_VECTOR(x0_uid149_fpHypot3dTest_in(0 downto 0));

    -- expOddSelect_uid151_fpHypot3dTest(LOGICAL,150)@3
    expOddSelect_uid151_fpHypot3dTest_q <= not (x0_uid149_fpHypot3dTest_b);

    -- fracRPreSqrt_uid142_fpHypot3dTest(BITSELECT,141)@3
    fracRPreSqrt_uid142_fpHypot3dTest_in <= expFracPostNorm_uid141_fpHypot3dTest_q(23 downto 0);
    fracRPreSqrt_uid142_fpHypot3dTest_b <= fracRPreSqrt_uid142_fpHypot3dTest_in(23 downto 1);

    -- addrFull_uid153_fpHypot3dTest(BITJOIN,152)@3
    addrFull_uid153_fpHypot3dTest_q <= expOddSelect_uid151_fpHypot3dTest_q & fracRPreSqrt_uid142_fpHypot3dTest_b;

    -- yAddr_uid155_fpHypot3dTest(BITSELECT,154)@3
    yAddr_uid155_fpHypot3dTest_b <= addrFull_uid153_fpHypot3dTest_q(23 downto 16);

    -- memoryC2_uid199_sqrtTables_lutmem(DUALMEM,285)@3 + 2
    -- in j@20000000
    memoryC2_uid199_sqrtTables_lutmem_aa <= yAddr_uid155_fpHypot3dTest_b;
    memoryC2_uid199_sqrtTables_lutmem_reset0 <= areset;
    memoryC2_uid199_sqrtTables_lutmem_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "M10K",
        operation_mode => "ROM",
        width_a => 12,
        widthad_a => 8,
        numwords_a => 256,
        lpm_type => "altera_syncram",
        width_byteena_a => 1,
        outdata_reg_a => "CLOCK0",
        outdata_aclr_a => "CLEAR0",
        clock_enable_input_a => "NORMAL",
        power_up_uninitialized => "FALSE",
        init_file => "FP_hypotenuse_0002_memoryC2_uid199_sqrtTables_lutmem.hex",
        init_file_layout => "PORT_A",
        intended_device_family => "Cyclone V"
    )
    PORT MAP (
        clocken0 => VCC_q(0),
        aclr0 => memoryC2_uid199_sqrtTables_lutmem_reset0,
        clock0 => clk,
        address_a => memoryC2_uid199_sqrtTables_lutmem_aa,
        q_a => memoryC2_uid199_sqrtTables_lutmem_ir
    );
    memoryC2_uid199_sqrtTables_lutmem_r <= memoryC2_uid199_sqrtTables_lutmem_ir(11 downto 0);

    -- yy_uid156_fpHypot3dTest(BITSELECT,155)@3
    yy_uid156_fpHypot3dTest_in <= fracRPreSqrt_uid142_fpHypot3dTest_b(15 downto 0);
    yy_uid156_fpHypot3dTest_b <= yy_uid156_fpHypot3dTest_in(15 downto 0);

    -- redist6_yy_uid156_fpHypot3dTest_b_2(DELAY,302)
    redist6_yy_uid156_fpHypot3dTest_b_2 : dspba_delay
    GENERIC MAP ( width => 16, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => yy_uid156_fpHypot3dTest_b, xout => redist6_yy_uid156_fpHypot3dTest_b_2_q, clk => clk, aclr => areset );

    -- yT1_uid205_invPolyEval(BITSELECT,204)@5
    yT1_uid205_invPolyEval_b <= redist6_yy_uid156_fpHypot3dTest_b_2_q(15 downto 4);

    -- prodXY_uid218_pT1_uid206_invPolyEval_cma(CHAINMULTADD,289)@5 + 2
    prodXY_uid218_pT1_uid206_invPolyEval_cma_reset <= areset;
    prodXY_uid218_pT1_uid206_invPolyEval_cma_ena0 <= '1';
    prodXY_uid218_pT1_uid206_invPolyEval_cma_ena1 <= prodXY_uid218_pT1_uid206_invPolyEval_cma_ena0;
    prodXY_uid218_pT1_uid206_invPolyEval_cma_l(0) <= SIGNED(RESIZE(prodXY_uid218_pT1_uid206_invPolyEval_cma_a0(0),13));
    prodXY_uid218_pT1_uid206_invPolyEval_cma_p(0) <= prodXY_uid218_pT1_uid206_invPolyEval_cma_l(0) * prodXY_uid218_pT1_uid206_invPolyEval_cma_c0(0);
    prodXY_uid218_pT1_uid206_invPolyEval_cma_u(0) <= RESIZE(prodXY_uid218_pT1_uid206_invPolyEval_cma_p(0),25);
    prodXY_uid218_pT1_uid206_invPolyEval_cma_w(0) <= prodXY_uid218_pT1_uid206_invPolyEval_cma_u(0);
    prodXY_uid218_pT1_uid206_invPolyEval_cma_x(0) <= prodXY_uid218_pT1_uid206_invPolyEval_cma_w(0);
    prodXY_uid218_pT1_uid206_invPolyEval_cma_y(0) <= prodXY_uid218_pT1_uid206_invPolyEval_cma_x(0);
    prodXY_uid218_pT1_uid206_invPolyEval_cma_chainmultadd_input: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            prodXY_uid218_pT1_uid206_invPolyEval_cma_a0 <= (others => (others => '0'));
            prodXY_uid218_pT1_uid206_invPolyEval_cma_c0 <= (others => (others => '0'));
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (prodXY_uid218_pT1_uid206_invPolyEval_cma_ena0 = '1') THEN
                prodXY_uid218_pT1_uid206_invPolyEval_cma_a0(0) <= RESIZE(UNSIGNED(yT1_uid205_invPolyEval_b),12);
                prodXY_uid218_pT1_uid206_invPolyEval_cma_c0(0) <= RESIZE(SIGNED(memoryC2_uid199_sqrtTables_lutmem_r),12);
            END IF;
        END IF;
    END PROCESS;
    prodXY_uid218_pT1_uid206_invPolyEval_cma_chainmultadd_output: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            prodXY_uid218_pT1_uid206_invPolyEval_cma_s <= (others => (others => '0'));
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (prodXY_uid218_pT1_uid206_invPolyEval_cma_ena1 = '1') THEN
                prodXY_uid218_pT1_uid206_invPolyEval_cma_s(0) <= prodXY_uid218_pT1_uid206_invPolyEval_cma_y(0);
            END IF;
        END IF;
    END PROCESS;
    prodXY_uid218_pT1_uid206_invPolyEval_cma_delay : dspba_delay
    GENERIC MAP ( width => 24, depth => 0, reset_kind => "ASYNC" )
    PORT MAP ( xin => STD_LOGIC_VECTOR(prodXY_uid218_pT1_uid206_invPolyEval_cma_s(0)(23 downto 0)), xout => prodXY_uid218_pT1_uid206_invPolyEval_cma_qq, clk => clk, aclr => areset );
    prodXY_uid218_pT1_uid206_invPolyEval_cma_q <= STD_LOGIC_VECTOR(prodXY_uid218_pT1_uid206_invPolyEval_cma_qq(23 downto 0));

    -- osig_uid219_pT1_uid206_invPolyEval(BITSELECT,218)@7
    osig_uid219_pT1_uid206_invPolyEval_b <= STD_LOGIC_VECTOR(prodXY_uid218_pT1_uid206_invPolyEval_cma_q(23 downto 11));

    -- highBBits_uid208_invPolyEval(BITSELECT,207)@7
    highBBits_uid208_invPolyEval_b <= STD_LOGIC_VECTOR(osig_uid219_pT1_uid206_invPolyEval_b(12 downto 1));

    -- redist8_yAddr_uid155_fpHypot3dTest_b_2(DELAY,304)
    redist8_yAddr_uid155_fpHypot3dTest_b_2 : dspba_delay
    GENERIC MAP ( width => 8, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => yAddr_uid155_fpHypot3dTest_b, xout => redist8_yAddr_uid155_fpHypot3dTest_b_2_q, clk => clk, aclr => areset );

    -- memoryC1_uid196_sqrtTables_lutmem(DUALMEM,284)@5 + 2
    -- in j@20000000
    memoryC1_uid196_sqrtTables_lutmem_aa <= redist8_yAddr_uid155_fpHypot3dTest_b_2_q;
    memoryC1_uid196_sqrtTables_lutmem_reset0 <= areset;
    memoryC1_uid196_sqrtTables_lutmem_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "M10K",
        operation_mode => "ROM",
        width_a => 21,
        widthad_a => 8,
        numwords_a => 256,
        lpm_type => "altera_syncram",
        width_byteena_a => 1,
        outdata_reg_a => "CLOCK0",
        outdata_aclr_a => "CLEAR0",
        clock_enable_input_a => "NORMAL",
        power_up_uninitialized => "FALSE",
        init_file => "FP_hypotenuse_0002_memoryC1_uid196_sqrtTables_lutmem.hex",
        init_file_layout => "PORT_A",
        intended_device_family => "Cyclone V"
    )
    PORT MAP (
        clocken0 => VCC_q(0),
        aclr0 => memoryC1_uid196_sqrtTables_lutmem_reset0,
        clock0 => clk,
        address_a => memoryC1_uid196_sqrtTables_lutmem_aa,
        q_a => memoryC1_uid196_sqrtTables_lutmem_ir
    );
    memoryC1_uid196_sqrtTables_lutmem_r <= memoryC1_uid196_sqrtTables_lutmem_ir(20 downto 0);

    -- s1sumAHighB_uid209_invPolyEval(ADD,208)@7
    s1sumAHighB_uid209_invPolyEval_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((21 downto 21 => memoryC1_uid196_sqrtTables_lutmem_r(20)) & memoryC1_uid196_sqrtTables_lutmem_r));
    s1sumAHighB_uid209_invPolyEval_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((21 downto 12 => highBBits_uid208_invPolyEval_b(11)) & highBBits_uid208_invPolyEval_b));
    s1sumAHighB_uid209_invPolyEval_o <= STD_LOGIC_VECTOR(SIGNED(s1sumAHighB_uid209_invPolyEval_a) + SIGNED(s1sumAHighB_uid209_invPolyEval_b));
    s1sumAHighB_uid209_invPolyEval_q <= s1sumAHighB_uid209_invPolyEval_o(21 downto 0);

    -- lowRangeB_uid207_invPolyEval(BITSELECT,206)@7
    lowRangeB_uid207_invPolyEval_in <= osig_uid219_pT1_uid206_invPolyEval_b(0 downto 0);
    lowRangeB_uid207_invPolyEval_b <= lowRangeB_uid207_invPolyEval_in(0 downto 0);

    -- s1_uid210_invPolyEval(BITJOIN,209)@7
    s1_uid210_invPolyEval_q <= s1sumAHighB_uid209_invPolyEval_q & lowRangeB_uid207_invPolyEval_b;

    -- redist7_yy_uid156_fpHypot3dTest_b_4(DELAY,303)
    redist7_yy_uid156_fpHypot3dTest_b_4 : dspba_delay
    GENERIC MAP ( width => 16, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => redist6_yy_uid156_fpHypot3dTest_b_2_q, xout => redist7_yy_uid156_fpHypot3dTest_b_4_q, clk => clk, aclr => areset );

    -- prodXY_uid221_pT2_uid212_invPolyEval_cma(CHAINMULTADD,290)@7 + 2
    prodXY_uid221_pT2_uid212_invPolyEval_cma_reset <= areset;
    prodXY_uid221_pT2_uid212_invPolyEval_cma_ena0 <= '1';
    prodXY_uid221_pT2_uid212_invPolyEval_cma_ena1 <= prodXY_uid221_pT2_uid212_invPolyEval_cma_ena0;
    prodXY_uid221_pT2_uid212_invPolyEval_cma_l(0) <= SIGNED(RESIZE(prodXY_uid221_pT2_uid212_invPolyEval_cma_a0(0),17));
    prodXY_uid221_pT2_uid212_invPolyEval_cma_p(0) <= prodXY_uid221_pT2_uid212_invPolyEval_cma_l(0) * prodXY_uid221_pT2_uid212_invPolyEval_cma_c0(0);
    prodXY_uid221_pT2_uid212_invPolyEval_cma_u(0) <= RESIZE(prodXY_uid221_pT2_uid212_invPolyEval_cma_p(0),40);
    prodXY_uid221_pT2_uid212_invPolyEval_cma_w(0) <= prodXY_uid221_pT2_uid212_invPolyEval_cma_u(0);
    prodXY_uid221_pT2_uid212_invPolyEval_cma_x(0) <= prodXY_uid221_pT2_uid212_invPolyEval_cma_w(0);
    prodXY_uid221_pT2_uid212_invPolyEval_cma_y(0) <= prodXY_uid221_pT2_uid212_invPolyEval_cma_x(0);
    prodXY_uid221_pT2_uid212_invPolyEval_cma_chainmultadd_input: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            prodXY_uid221_pT2_uid212_invPolyEval_cma_a0 <= (others => (others => '0'));
            prodXY_uid221_pT2_uid212_invPolyEval_cma_c0 <= (others => (others => '0'));
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (prodXY_uid221_pT2_uid212_invPolyEval_cma_ena0 = '1') THEN
                prodXY_uid221_pT2_uid212_invPolyEval_cma_a0(0) <= RESIZE(UNSIGNED(redist7_yy_uid156_fpHypot3dTest_b_4_q),16);
                prodXY_uid221_pT2_uid212_invPolyEval_cma_c0(0) <= RESIZE(SIGNED(s1_uid210_invPolyEval_q),23);
            END IF;
        END IF;
    END PROCESS;
    prodXY_uid221_pT2_uid212_invPolyEval_cma_chainmultadd_output: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            prodXY_uid221_pT2_uid212_invPolyEval_cma_s <= (others => (others => '0'));
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (prodXY_uid221_pT2_uid212_invPolyEval_cma_ena1 = '1') THEN
                prodXY_uid221_pT2_uid212_invPolyEval_cma_s(0) <= prodXY_uid221_pT2_uid212_invPolyEval_cma_y(0);
            END IF;
        END IF;
    END PROCESS;
    prodXY_uid221_pT2_uid212_invPolyEval_cma_delay : dspba_delay
    GENERIC MAP ( width => 39, depth => 0, reset_kind => "ASYNC" )
    PORT MAP ( xin => STD_LOGIC_VECTOR(prodXY_uid221_pT2_uid212_invPolyEval_cma_s(0)(38 downto 0)), xout => prodXY_uid221_pT2_uid212_invPolyEval_cma_qq, clk => clk, aclr => areset );
    prodXY_uid221_pT2_uid212_invPolyEval_cma_q <= STD_LOGIC_VECTOR(prodXY_uid221_pT2_uid212_invPolyEval_cma_qq(38 downto 0));

    -- osig_uid222_pT2_uid212_invPolyEval(BITSELECT,221)@9
    osig_uid222_pT2_uid212_invPolyEval_b <= STD_LOGIC_VECTOR(prodXY_uid221_pT2_uid212_invPolyEval_cma_q(38 downto 15));

    -- highBBits_uid214_invPolyEval(BITSELECT,213)@9
    highBBits_uid214_invPolyEval_b <= STD_LOGIC_VECTOR(osig_uid222_pT2_uid212_invPolyEval_b(23 downto 2));

    -- redist9_yAddr_uid155_fpHypot3dTest_b_4(DELAY,305)
    redist9_yAddr_uid155_fpHypot3dTest_b_4 : dspba_delay
    GENERIC MAP ( width => 8, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => redist8_yAddr_uid155_fpHypot3dTest_b_2_q, xout => redist9_yAddr_uid155_fpHypot3dTest_b_4_q, clk => clk, aclr => areset );

    -- memoryC0_uid193_sqrtTables_lutmem(DUALMEM,283)@7 + 2
    -- in j@20000000
    memoryC0_uid193_sqrtTables_lutmem_aa <= redist9_yAddr_uid155_fpHypot3dTest_b_4_q;
    memoryC0_uid193_sqrtTables_lutmem_reset0 <= areset;
    memoryC0_uid193_sqrtTables_lutmem_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "M10K",
        operation_mode => "ROM",
        width_a => 29,
        widthad_a => 8,
        numwords_a => 256,
        lpm_type => "altera_syncram",
        width_byteena_a => 1,
        outdata_reg_a => "CLOCK0",
        outdata_aclr_a => "CLEAR0",
        clock_enable_input_a => "NORMAL",
        power_up_uninitialized => "FALSE",
        init_file => "FP_hypotenuse_0002_memoryC0_uid193_sqrtTables_lutmem.hex",
        init_file_layout => "PORT_A",
        intended_device_family => "Cyclone V"
    )
    PORT MAP (
        clocken0 => VCC_q(0),
        aclr0 => memoryC0_uid193_sqrtTables_lutmem_reset0,
        clock0 => clk,
        address_a => memoryC0_uid193_sqrtTables_lutmem_aa,
        q_a => memoryC0_uid193_sqrtTables_lutmem_ir
    );
    memoryC0_uid193_sqrtTables_lutmem_r <= memoryC0_uid193_sqrtTables_lutmem_ir(28 downto 0);

    -- s2sumAHighB_uid215_invPolyEval(ADD,214)@9
    s2sumAHighB_uid215_invPolyEval_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((29 downto 29 => memoryC0_uid193_sqrtTables_lutmem_r(28)) & memoryC0_uid193_sqrtTables_lutmem_r));
    s2sumAHighB_uid215_invPolyEval_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((29 downto 22 => highBBits_uid214_invPolyEval_b(21)) & highBBits_uid214_invPolyEval_b));
    s2sumAHighB_uid215_invPolyEval_o <= STD_LOGIC_VECTOR(SIGNED(s2sumAHighB_uid215_invPolyEval_a) + SIGNED(s2sumAHighB_uid215_invPolyEval_b));
    s2sumAHighB_uid215_invPolyEval_q <= s2sumAHighB_uid215_invPolyEval_o(29 downto 0);

    -- lowRangeB_uid213_invPolyEval(BITSELECT,212)@9
    lowRangeB_uid213_invPolyEval_in <= osig_uid222_pT2_uid212_invPolyEval_b(1 downto 0);
    lowRangeB_uid213_invPolyEval_b <= lowRangeB_uid213_invPolyEval_in(1 downto 0);

    -- s2_uid216_invPolyEval(BITJOIN,215)@9
    s2_uid216_invPolyEval_q <= s2sumAHighB_uid215_invPolyEval_q & lowRangeB_uid213_invPolyEval_b;

    -- fracRPreInc_uid158_fpHypot3dTest(BITSELECT,157)@9
    fracRPreInc_uid158_fpHypot3dTest_in <= s2_uid216_invPolyEval_q(30 downto 0);
    fracRPreInc_uid158_fpHypot3dTest_b <= fracRPreInc_uid158_fpHypot3dTest_in(30 downto 5);

    -- fracRPostInc_uid161_fpHypot3dTest(ADD,160)@9
    fracRPostInc_uid161_fpHypot3dTest_a <= STD_LOGIC_VECTOR("0" & fracRPreInc_uid158_fpHypot3dTest_b);
    fracRPostInc_uid161_fpHypot3dTest_b <= STD_LOGIC_VECTOR("00000000000000000000000000" & VCC_q);
    fracRPostInc_uid161_fpHypot3dTest_o <= STD_LOGIC_VECTOR(UNSIGNED(fracRPostInc_uid161_fpHypot3dTest_a) + UNSIGNED(fracRPostInc_uid161_fpHypot3dTest_b));
    fracRPostInc_uid161_fpHypot3dTest_q <= fracRPostInc_uid161_fpHypot3dTest_o(26 downto 0);

    -- fracRPostIncMSBU_uid163_fpHypot3dTest(BITSELECT,162)@9
    fracRPostIncMSBU_uid163_fpHypot3dTest_in <= STD_LOGIC_VECTOR(fracRPostInc_uid161_fpHypot3dTest_q(25 downto 0));
    fracRPostIncMSBU_uid163_fpHypot3dTest_b <= STD_LOGIC_VECTOR(fracRPostIncMSBU_uid163_fpHypot3dTest_in(25 downto 25));

    -- redist10_expRMux_uid152_fpHypot3dTest_q_6_notEnable(LOGICAL,320)
    redist10_expRMux_uid152_fpHypot3dTest_q_6_notEnable_q <= STD_LOGIC_VECTOR(not (VCC_q));

    -- redist10_expRMux_uid152_fpHypot3dTest_q_6_nor(LOGICAL,321)
    redist10_expRMux_uid152_fpHypot3dTest_q_6_nor_q <= not (redist10_expRMux_uid152_fpHypot3dTest_q_6_notEnable_q or redist10_expRMux_uid152_fpHypot3dTest_q_6_sticky_ena_q);

    -- redist10_expRMux_uid152_fpHypot3dTest_q_6_mem_last(CONSTANT,317)
    redist10_expRMux_uid152_fpHypot3dTest_q_6_mem_last_q <= "010";

    -- redist10_expRMux_uid152_fpHypot3dTest_q_6_cmp(LOGICAL,318)
    redist10_expRMux_uid152_fpHypot3dTest_q_6_cmp_b <= STD_LOGIC_VECTOR("0" & redist10_expRMux_uid152_fpHypot3dTest_q_6_rdcnt_q);
    redist10_expRMux_uid152_fpHypot3dTest_q_6_cmp_q <= "1" WHEN redist10_expRMux_uid152_fpHypot3dTest_q_6_mem_last_q = redist10_expRMux_uid152_fpHypot3dTest_q_6_cmp_b ELSE "0";

    -- redist10_expRMux_uid152_fpHypot3dTest_q_6_cmpReg(REG,319)
    redist10_expRMux_uid152_fpHypot3dTest_q_6_cmpReg_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            redist10_expRMux_uid152_fpHypot3dTest_q_6_cmpReg_q <= "0";
        ELSIF (clk'EVENT AND clk = '1') THEN
            redist10_expRMux_uid152_fpHypot3dTest_q_6_cmpReg_q <= STD_LOGIC_VECTOR(redist10_expRMux_uid152_fpHypot3dTest_q_6_cmp_q);
        END IF;
    END PROCESS;

    -- redist10_expRMux_uid152_fpHypot3dTest_q_6_sticky_ena(REG,322)
    redist10_expRMux_uid152_fpHypot3dTest_q_6_sticky_ena_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            redist10_expRMux_uid152_fpHypot3dTest_q_6_sticky_ena_q <= "0";
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (redist10_expRMux_uid152_fpHypot3dTest_q_6_nor_q = "1") THEN
                redist10_expRMux_uid152_fpHypot3dTest_q_6_sticky_ena_q <= STD_LOGIC_VECTOR(redist10_expRMux_uid152_fpHypot3dTest_q_6_cmpReg_q);
            END IF;
        END IF;
    END PROCESS;

    -- redist10_expRMux_uid152_fpHypot3dTest_q_6_enaAnd(LOGICAL,323)
    redist10_expRMux_uid152_fpHypot3dTest_q_6_enaAnd_q <= redist10_expRMux_uid152_fpHypot3dTest_q_6_sticky_ena_q and VCC_q;

    -- redist10_expRMux_uid152_fpHypot3dTest_q_6_rdcnt(COUNTER,315)
    -- low=0, high=3, step=1, init=0
    redist10_expRMux_uid152_fpHypot3dTest_q_6_rdcnt_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            redist10_expRMux_uid152_fpHypot3dTest_q_6_rdcnt_i <= TO_UNSIGNED(0, 2);
        ELSIF (clk'EVENT AND clk = '1') THEN
            redist10_expRMux_uid152_fpHypot3dTest_q_6_rdcnt_i <= redist10_expRMux_uid152_fpHypot3dTest_q_6_rdcnt_i + 1;
        END IF;
    END PROCESS;
    redist10_expRMux_uid152_fpHypot3dTest_q_6_rdcnt_q <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR(RESIZE(redist10_expRMux_uid152_fpHypot3dTest_q_6_rdcnt_i, 2)));

    -- biasP1Signal_uid146_fpHypot3dTest(CONSTANT,145)
    biasP1Signal_uid146_fpHypot3dTest_q <= "1111110";

    -- expOddSig_uid147_fpHypot3dTest(ADD,146)@3
    expOddSig_uid147_fpHypot3dTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((11 downto 10 => expRPreSqrt_uid143_fpHypot3dTest_b(9)) & expRPreSqrt_uid143_fpHypot3dTest_b));
    expOddSig_uid147_fpHypot3dTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("00000" & biasP1Signal_uid146_fpHypot3dTest_q));
    expOddSig_uid147_fpHypot3dTest_o <= STD_LOGIC_VECTOR(SIGNED(expOddSig_uid147_fpHypot3dTest_a) + SIGNED(expOddSig_uid147_fpHypot3dTest_b));
    expOddSig_uid147_fpHypot3dTest_q <= expOddSig_uid147_fpHypot3dTest_o(10 downto 0);

    -- expROdd_uid148_fpHypot3dTest(BITSELECT,147)@3
    expROdd_uid148_fpHypot3dTest_b <= STD_LOGIC_VECTOR(expOddSig_uid147_fpHypot3dTest_q(10 downto 1));

    -- expSumOfSquaresUnbiased_uid144_fpHypot3dTest(ADD,143)@3
    expSumOfSquaresUnbiased_uid144_fpHypot3dTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((11 downto 10 => expRPreSqrt_uid143_fpHypot3dTest_b(9)) & expRPreSqrt_uid143_fpHypot3dTest_b));
    expSumOfSquaresUnbiased_uid144_fpHypot3dTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("00000" & bias_uid61_fpHypot3dTest_q));
    expSumOfSquaresUnbiased_uid144_fpHypot3dTest_o <= STD_LOGIC_VECTOR(SIGNED(expSumOfSquaresUnbiased_uid144_fpHypot3dTest_a) + SIGNED(expSumOfSquaresUnbiased_uid144_fpHypot3dTest_b));
    expSumOfSquaresUnbiased_uid144_fpHypot3dTest_q <= expSumOfSquaresUnbiased_uid144_fpHypot3dTest_o(10 downto 0);

    -- expREven_uid145_fpHypot3dTest(BITSELECT,144)@3
    expREven_uid145_fpHypot3dTest_b <= STD_LOGIC_VECTOR(expSumOfSquaresUnbiased_uid144_fpHypot3dTest_q(10 downto 1));

    -- expRMux_uid152_fpHypot3dTest(MUX,151)@3 + 1
    expRMux_uid152_fpHypot3dTest_s <= expOddSelect_uid151_fpHypot3dTest_q;
    expRMux_uid152_fpHypot3dTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            expRMux_uid152_fpHypot3dTest_q <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            CASE (expRMux_uid152_fpHypot3dTest_s) IS
                WHEN "0" => expRMux_uid152_fpHypot3dTest_q <= expREven_uid145_fpHypot3dTest_b;
                WHEN "1" => expRMux_uid152_fpHypot3dTest_q <= expROdd_uid148_fpHypot3dTest_b;
                WHEN OTHERS => expRMux_uid152_fpHypot3dTest_q <= (others => '0');
            END CASE;
        END IF;
    END PROCESS;

    -- redist10_expRMux_uid152_fpHypot3dTest_q_6_wraddr(REG,316)
    redist10_expRMux_uid152_fpHypot3dTest_q_6_wraddr_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            redist10_expRMux_uid152_fpHypot3dTest_q_6_wraddr_q <= "11";
        ELSIF (clk'EVENT AND clk = '1') THEN
            redist10_expRMux_uid152_fpHypot3dTest_q_6_wraddr_q <= STD_LOGIC_VECTOR(redist10_expRMux_uid152_fpHypot3dTest_q_6_rdcnt_q);
        END IF;
    END PROCESS;

    -- redist10_expRMux_uid152_fpHypot3dTest_q_6_mem(DUALMEM,314)
    redist10_expRMux_uid152_fpHypot3dTest_q_6_mem_ia <= STD_LOGIC_VECTOR(expRMux_uid152_fpHypot3dTest_q);
    redist10_expRMux_uid152_fpHypot3dTest_q_6_mem_aa <= redist10_expRMux_uid152_fpHypot3dTest_q_6_wraddr_q;
    redist10_expRMux_uid152_fpHypot3dTest_q_6_mem_ab <= redist10_expRMux_uid152_fpHypot3dTest_q_6_rdcnt_q;
    redist10_expRMux_uid152_fpHypot3dTest_q_6_mem_reset0 <= areset;
    redist10_expRMux_uid152_fpHypot3dTest_q_6_mem_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "MLAB",
        operation_mode => "DUAL_PORT",
        width_a => 10,
        widthad_a => 2,
        numwords_a => 4,
        width_b => 10,
        widthad_b => 2,
        numwords_b => 4,
        lpm_type => "altera_syncram",
        width_byteena_a => 1,
        address_reg_b => "CLOCK0",
        indata_reg_b => "CLOCK0",
        rdcontrol_reg_b => "CLOCK0",
        byteena_reg_b => "CLOCK0",
        outdata_reg_b => "CLOCK1",
        outdata_aclr_b => "CLEAR1",
        clock_enable_input_a => "NORMAL",
        clock_enable_input_b => "NORMAL",
        clock_enable_output_b => "NORMAL",
        read_during_write_mode_mixed_ports => "DONT_CARE",
        power_up_uninitialized => "TRUE",
        intended_device_family => "Cyclone V"
    )
    PORT MAP (
        clocken1 => redist10_expRMux_uid152_fpHypot3dTest_q_6_enaAnd_q(0),
        clocken0 => VCC_q(0),
        clock0 => clk,
        aclr1 => redist10_expRMux_uid152_fpHypot3dTest_q_6_mem_reset0,
        clock1 => clk,
        address_a => redist10_expRMux_uid152_fpHypot3dTest_q_6_mem_aa,
        data_a => redist10_expRMux_uid152_fpHypot3dTest_q_6_mem_ia,
        wren_a => VCC_q(0),
        address_b => redist10_expRMux_uid152_fpHypot3dTest_q_6_mem_ab,
        q_b => redist10_expRMux_uid152_fpHypot3dTest_q_6_mem_iq
    );
    redist10_expRMux_uid152_fpHypot3dTest_q_6_mem_q <= redist10_expRMux_uid152_fpHypot3dTest_q_6_mem_iq(9 downto 0);

    -- expRPostInc_uid164_fpHypot3dTest(ADD,163)@9
    expRPostInc_uid164_fpHypot3dTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((11 downto 10 => redist10_expRMux_uid152_fpHypot3dTest_q_6_mem_q(9)) & redist10_expRMux_uid152_fpHypot3dTest_q_6_mem_q));
    expRPostInc_uid164_fpHypot3dTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("00000000000" & fracRPostIncMSBU_uid163_fpHypot3dTest_b));
    expRPostInc_uid164_fpHypot3dTest_o <= STD_LOGIC_VECTOR(SIGNED(expRPostInc_uid164_fpHypot3dTest_a) + SIGNED(expRPostInc_uid164_fpHypot3dTest_b));
    expRPostInc_uid164_fpHypot3dTest_q <= expRPostInc_uid164_fpHypot3dTest_o(10 downto 0);

    -- expRPreExc_uid188_fpHypot3dTest(BITSELECT,187)@9
    expRPreExc_uid188_fpHypot3dTest_in <= expRPostInc_uid164_fpHypot3dTest_q(7 downto 0);
    expRPreExc_uid188_fpHypot3dTest_b <= expRPreExc_uid188_fpHypot3dTest_in(7 downto 0);

    -- cstAllZWE_uid14_fpHypot3dTest(CONSTANT,13)
    cstAllZWE_uid14_fpHypot3dTest_q <= "00000000";

    -- fracXIsZero_uid47_fpHypot3dTest(LOGICAL,46)@0 + 1
    fracXIsZero_uid47_fpHypot3dTest_qi <= "1" WHEN cstZeroWF_uid13_fpHypot3dTest_q = expZ_uid8_fpHypot3dTest_merged_bit_select_c ELSE "0";
    fracXIsZero_uid47_fpHypot3dTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracXIsZero_uid47_fpHypot3dTest_qi, xout => fracXIsZero_uid47_fpHypot3dTest_q, clk => clk, aclr => areset );

    -- redist13_fracXIsZero_uid47_fpHypot3dTest_q_2(DELAY,309)
    redist13_fracXIsZero_uid47_fpHypot3dTest_q_2 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracXIsZero_uid47_fpHypot3dTest_q, xout => redist13_fracXIsZero_uid47_fpHypot3dTest_q_2_q, clk => clk, aclr => areset );

    -- fracXIsNotZero_uid48_fpHypot3dTest(LOGICAL,47)@2
    fracXIsNotZero_uid48_fpHypot3dTest_q <= not (redist13_fracXIsZero_uid47_fpHypot3dTest_q_2_q);

    -- expXIsMax_uid46_fpHypot3dTest(LOGICAL,45)@2
    expXIsMax_uid46_fpHypot3dTest_q <= "1" WHEN redist0_expZ_uid8_fpHypot3dTest_merged_bit_select_b_2_q = cstAllOWE_uid12_fpHypot3dTest_q ELSE "0";

    -- excN_z_uid50_fpHypot3dTest(LOGICAL,49)@2 + 1
    excN_z_uid50_fpHypot3dTest_qi <= expXIsMax_uid46_fpHypot3dTest_q and fracXIsNotZero_uid48_fpHypot3dTest_q;
    excN_z_uid50_fpHypot3dTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => excN_z_uid50_fpHypot3dTest_qi, xout => excN_z_uid50_fpHypot3dTest_q, clk => clk, aclr => areset );

    -- redist12_excN_z_uid50_fpHypot3dTest_q_7(DELAY,308)
    redist12_excN_z_uid50_fpHypot3dTest_q_7 : dspba_delay
    GENERIC MAP ( width => 1, depth => 6, reset_kind => "ASYNC" )
    PORT MAP ( xin => excN_z_uid50_fpHypot3dTest_q, xout => redist12_excN_z_uid50_fpHypot3dTest_q_7_q, clk => clk, aclr => areset );

    -- fracXIsZero_uid33_fpHypot3dTest(LOGICAL,32)@0 + 1
    fracXIsZero_uid33_fpHypot3dTest_qi <= "1" WHEN cstZeroWF_uid13_fpHypot3dTest_q = expY_uid7_fpHypot3dTest_merged_bit_select_c ELSE "0";
    fracXIsZero_uid33_fpHypot3dTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracXIsZero_uid33_fpHypot3dTest_qi, xout => fracXIsZero_uid33_fpHypot3dTest_q, clk => clk, aclr => areset );

    -- redist15_fracXIsZero_uid33_fpHypot3dTest_q_2(DELAY,311)
    redist15_fracXIsZero_uid33_fpHypot3dTest_q_2 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracXIsZero_uid33_fpHypot3dTest_q, xout => redist15_fracXIsZero_uid33_fpHypot3dTest_q_2_q, clk => clk, aclr => areset );

    -- fracXIsNotZero_uid34_fpHypot3dTest(LOGICAL,33)@2
    fracXIsNotZero_uid34_fpHypot3dTest_q <= not (redist15_fracXIsZero_uid33_fpHypot3dTest_q_2_q);

    -- expXIsMax_uid32_fpHypot3dTest(LOGICAL,31)@2
    expXIsMax_uid32_fpHypot3dTest_q <= "1" WHEN redist1_expY_uid7_fpHypot3dTest_merged_bit_select_b_2_q = cstAllOWE_uid12_fpHypot3dTest_q ELSE "0";

    -- excN_y_uid36_fpHypot3dTest(LOGICAL,35)@2 + 1
    excN_y_uid36_fpHypot3dTest_qi <= expXIsMax_uid32_fpHypot3dTest_q and fracXIsNotZero_uid34_fpHypot3dTest_q;
    excN_y_uid36_fpHypot3dTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => excN_y_uid36_fpHypot3dTest_qi, xout => excN_y_uid36_fpHypot3dTest_q, clk => clk, aclr => areset );

    -- redist14_excN_y_uid36_fpHypot3dTest_q_7(DELAY,310)
    redist14_excN_y_uid36_fpHypot3dTest_q_7 : dspba_delay
    GENERIC MAP ( width => 1, depth => 6, reset_kind => "ASYNC" )
    PORT MAP ( xin => excN_y_uid36_fpHypot3dTest_q, xout => redist14_excN_y_uid36_fpHypot3dTest_q_7_q, clk => clk, aclr => areset );

    -- fracXIsZero_uid19_fpHypot3dTest(LOGICAL,18)@0 + 1
    fracXIsZero_uid19_fpHypot3dTest_qi <= "1" WHEN cstZeroWF_uid13_fpHypot3dTest_q = expX_uid6_fpHypot3dTest_merged_bit_select_c ELSE "0";
    fracXIsZero_uid19_fpHypot3dTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracXIsZero_uid19_fpHypot3dTest_qi, xout => fracXIsZero_uid19_fpHypot3dTest_q, clk => clk, aclr => areset );

    -- redist17_fracXIsZero_uid19_fpHypot3dTest_q_2(DELAY,313)
    redist17_fracXIsZero_uid19_fpHypot3dTest_q_2 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracXIsZero_uid19_fpHypot3dTest_q, xout => redist17_fracXIsZero_uid19_fpHypot3dTest_q_2_q, clk => clk, aclr => areset );

    -- fracXIsNotZero_uid20_fpHypot3dTest(LOGICAL,19)@2
    fracXIsNotZero_uid20_fpHypot3dTest_q <= not (redist17_fracXIsZero_uid19_fpHypot3dTest_q_2_q);

    -- expXIsMax_uid18_fpHypot3dTest(LOGICAL,17)@2
    expXIsMax_uid18_fpHypot3dTest_q <= "1" WHEN redist2_expX_uid6_fpHypot3dTest_merged_bit_select_b_2_q = cstAllOWE_uid12_fpHypot3dTest_q ELSE "0";

    -- excN_x_uid22_fpHypot3dTest(LOGICAL,21)@2 + 1
    excN_x_uid22_fpHypot3dTest_qi <= expXIsMax_uid18_fpHypot3dTest_q and fracXIsNotZero_uid20_fpHypot3dTest_q;
    excN_x_uid22_fpHypot3dTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => excN_x_uid22_fpHypot3dTest_qi, xout => excN_x_uid22_fpHypot3dTest_q, clk => clk, aclr => areset );

    -- redist16_excN_x_uid22_fpHypot3dTest_q_7(DELAY,312)
    redist16_excN_x_uid22_fpHypot3dTest_q_7 : dspba_delay
    GENERIC MAP ( width => 1, depth => 6, reset_kind => "ASYNC" )
    PORT MAP ( xin => excN_x_uid22_fpHypot3dTest_q, xout => redist16_excN_x_uid22_fpHypot3dTest_q_7_q, clk => clk, aclr => areset );

    -- excRNaN_uid178_fpHypot3dTest(LOGICAL,177)@9
    excRNaN_uid178_fpHypot3dTest_q <= redist16_excN_x_uid22_fpHypot3dTest_q_7_q or redist14_excN_y_uid36_fpHypot3dTest_q_7_q or redist12_excN_z_uid50_fpHypot3dTest_q_7_q;

    -- sqrtOverflow_uid167_fpHypot3dTest(COMPARE,166)@9
    sqrtOverflow_uid167_fpHypot3dTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((12 downto 11 => expRPostInc_uid164_fpHypot3dTest_q(10)) & expRPostInc_uid164_fpHypot3dTest_q));
    sqrtOverflow_uid167_fpHypot3dTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("00000" & cstAllOWE_uid12_fpHypot3dTest_q));
    sqrtOverflow_uid167_fpHypot3dTest_o <= STD_LOGIC_VECTOR(SIGNED(sqrtOverflow_uid167_fpHypot3dTest_a) - SIGNED(sqrtOverflow_uid167_fpHypot3dTest_b));
    sqrtOverflow_uid167_fpHypot3dTest_n(0) <= not (sqrtOverflow_uid167_fpHypot3dTest_o(12));

    -- invExcZN_uid174_fpHypot3dTest(LOGICAL,173)@9
    invExcZN_uid174_fpHypot3dTest_q <= not (redist12_excN_z_uid50_fpHypot3dTest_q_7_q);

    -- invExcYN_uid175_fpHypot3dTest(LOGICAL,174)@9
    invExcYN_uid175_fpHypot3dTest_q <= not (redist14_excN_y_uid36_fpHypot3dTest_q_7_q);

    -- invExcXN_uid176_fpHypot3dTest(LOGICAL,175)@9
    invExcXN_uid176_fpHypot3dTest_q <= not (redist16_excN_x_uid22_fpHypot3dTest_q_7_q);

    -- excRInf_uid177_fpHypot3dTest(LOGICAL,176)@9
    excRInf_uid177_fpHypot3dTest_q <= invExcXN_uid176_fpHypot3dTest_q and invExcYN_uid175_fpHypot3dTest_q and invExcZN_uid174_fpHypot3dTest_q and sqrtOverflow_uid167_fpHypot3dTest_n;

    -- excI_z_uid49_fpHypot3dTest(LOGICAL,48)@2
    excI_z_uid49_fpHypot3dTest_q <= expXIsMax_uid46_fpHypot3dTest_q and redist13_fracXIsZero_uid47_fpHypot3dTest_q_2_q;

    -- excI_y_uid35_fpHypot3dTest(LOGICAL,34)@2
    excI_y_uid35_fpHypot3dTest_q <= expXIsMax_uid32_fpHypot3dTest_q and redist15_fracXIsZero_uid33_fpHypot3dTest_q_2_q;

    -- excI_x_uid21_fpHypot3dTest(LOGICAL,20)@2
    excI_x_uid21_fpHypot3dTest_q <= expXIsMax_uid18_fpHypot3dTest_q and redist17_fracXIsZero_uid19_fpHypot3dTest_q_2_q;

    -- oneIsInf_uid169_fpHypot3dTest(LOGICAL,168)@2 + 1
    oneIsInf_uid169_fpHypot3dTest_qi <= excI_x_uid21_fpHypot3dTest_q or excI_y_uid35_fpHypot3dTest_q or excI_z_uid49_fpHypot3dTest_q;
    oneIsInf_uid169_fpHypot3dTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => oneIsInf_uid169_fpHypot3dTest_qi, xout => oneIsInf_uid169_fpHypot3dTest_q, clk => clk, aclr => areset );

    -- redist4_oneIsInf_uid169_fpHypot3dTest_q_7(DELAY,300)
    redist4_oneIsInf_uid169_fpHypot3dTest_q_7 : dspba_delay
    GENERIC MAP ( width => 1, depth => 6, reset_kind => "ASYNC" )
    PORT MAP ( xin => oneIsInf_uid169_fpHypot3dTest_q, xout => redist4_oneIsInf_uid169_fpHypot3dTest_q_7_q, clk => clk, aclr => areset );

    -- noneInf_uid170_fpHypot3dTest(LOGICAL,169)@9
    noneInf_uid170_fpHypot3dTest_q <= not (redist4_oneIsInf_uid169_fpHypot3dTest_q_7_q);

    -- invExpXIsMax_uid51_fpHypot3dTest(LOGICAL,50)@2
    invExpXIsMax_uid51_fpHypot3dTest_q <= not (expXIsMax_uid46_fpHypot3dTest_q);

    -- InvExpXIsZero_uid52_fpHypot3dTest(LOGICAL,51)@2
    InvExpXIsZero_uid52_fpHypot3dTest_q <= not (excZ_z_uid45_fpHypot3dTest_q);

    -- excR_z_uid53_fpHypot3dTest(LOGICAL,52)@2
    excR_z_uid53_fpHypot3dTest_q <= InvExpXIsZero_uid52_fpHypot3dTest_q and invExpXIsMax_uid51_fpHypot3dTest_q;

    -- invExpXIsMax_uid37_fpHypot3dTest(LOGICAL,36)@2
    invExpXIsMax_uid37_fpHypot3dTest_q <= not (expXIsMax_uid32_fpHypot3dTest_q);

    -- InvExpXIsZero_uid38_fpHypot3dTest(LOGICAL,37)@2
    InvExpXIsZero_uid38_fpHypot3dTest_q <= not (excZ_y_uid31_fpHypot3dTest_q);

    -- excR_y_uid39_fpHypot3dTest(LOGICAL,38)@2
    excR_y_uid39_fpHypot3dTest_q <= InvExpXIsZero_uid38_fpHypot3dTest_q and invExpXIsMax_uid37_fpHypot3dTest_q;

    -- invExpXIsMax_uid23_fpHypot3dTest(LOGICAL,22)@2
    invExpXIsMax_uid23_fpHypot3dTest_q <= not (expXIsMax_uid18_fpHypot3dTest_q);

    -- InvExpXIsZero_uid24_fpHypot3dTest(LOGICAL,23)@2
    InvExpXIsZero_uid24_fpHypot3dTest_q <= not (excZ_x_uid17_fpHypot3dTest_q);

    -- excR_x_uid25_fpHypot3dTest(LOGICAL,24)@2
    excR_x_uid25_fpHypot3dTest_q <= InvExpXIsZero_uid24_fpHypot3dTest_q and invExpXIsMax_uid23_fpHypot3dTest_q;

    -- onIsReg_uid171_fpHypot3dTest(LOGICAL,170)@2 + 1
    onIsReg_uid171_fpHypot3dTest_qi <= excR_x_uid25_fpHypot3dTest_q or excR_y_uid39_fpHypot3dTest_q or excR_z_uid53_fpHypot3dTest_q;
    onIsReg_uid171_fpHypot3dTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => onIsReg_uid171_fpHypot3dTest_qi, xout => onIsReg_uid171_fpHypot3dTest_q, clk => clk, aclr => areset );

    -- redist3_onIsReg_uid171_fpHypot3dTest_q_7(DELAY,299)
    redist3_onIsReg_uid171_fpHypot3dTest_q_7 : dspba_delay
    GENERIC MAP ( width => 1, depth => 6, reset_kind => "ASYNC" )
    PORT MAP ( xin => onIsReg_uid171_fpHypot3dTest_q, xout => redist3_onIsReg_uid171_fpHypot3dTest_q_7_q, clk => clk, aclr => areset );

    -- sqrtUnderflow_uid165_fpHypot3dTest(COMPARE,164)@9
    sqrtUnderflow_uid165_fpHypot3dTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("000000000000" & GND_q));
    sqrtUnderflow_uid165_fpHypot3dTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((12 downto 11 => expRPostInc_uid164_fpHypot3dTest_q(10)) & expRPostInc_uid164_fpHypot3dTest_q));
    sqrtUnderflow_uid165_fpHypot3dTest_o <= STD_LOGIC_VECTOR(SIGNED(sqrtUnderflow_uid165_fpHypot3dTest_a) - SIGNED(sqrtUnderflow_uid165_fpHypot3dTest_b));
    sqrtUnderflow_uid165_fpHypot3dTest_n(0) <= not (sqrtUnderflow_uid165_fpHypot3dTest_o(12));

    -- excXYRUdf_uid172_fpHypot3dTest(LOGICAL,171)@9
    excXYRUdf_uid172_fpHypot3dTest_q <= sqrtUnderflow_uid165_fpHypot3dTest_n and redist3_onIsReg_uid171_fpHypot3dTest_q_7_q and noneInf_uid170_fpHypot3dTest_q;

    -- excXYZ_uid168_fpHypot3dTest(LOGICAL,167)@2 + 1
    excXYZ_uid168_fpHypot3dTest_qi <= excZ_x_uid17_fpHypot3dTest_q and excZ_y_uid31_fpHypot3dTest_q and excZ_z_uid45_fpHypot3dTest_q;
    excXYZ_uid168_fpHypot3dTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => excXYZ_uid168_fpHypot3dTest_qi, xout => excXYZ_uid168_fpHypot3dTest_q, clk => clk, aclr => areset );

    -- redist5_excXYZ_uid168_fpHypot3dTest_q_7(DELAY,301)
    redist5_excXYZ_uid168_fpHypot3dTest_q_7 : dspba_delay
    GENERIC MAP ( width => 1, depth => 6, reset_kind => "ASYNC" )
    PORT MAP ( xin => excXYZ_uid168_fpHypot3dTest_q, xout => redist5_excXYZ_uid168_fpHypot3dTest_q_7_q, clk => clk, aclr => areset );

    -- excRZero_uid173_fpHypot3dTest(LOGICAL,172)@9
    excRZero_uid173_fpHypot3dTest_q <= redist5_excXYZ_uid168_fpHypot3dTest_q_7_q or excXYRUdf_uid172_fpHypot3dTest_q;

    -- excSelBits_uid179_fpHypot3dTest(BITJOIN,178)@9
    excSelBits_uid179_fpHypot3dTest_q <= excRNaN_uid178_fpHypot3dTest_q & excRInf_uid177_fpHypot3dTest_q & excRZero_uid173_fpHypot3dTest_q;

    -- outMuxSelEnc_uid180_fpHypot3dTest(LOOKUP,179)@9
    outMuxSelEnc_uid180_fpHypot3dTest_combproc: PROCESS (excSelBits_uid179_fpHypot3dTest_q)
    BEGIN
        -- Begin reserved scope level
        CASE (excSelBits_uid179_fpHypot3dTest_q) IS
            WHEN "000" => outMuxSelEnc_uid180_fpHypot3dTest_q <= "01";
            WHEN "001" => outMuxSelEnc_uid180_fpHypot3dTest_q <= "00";
            WHEN "010" => outMuxSelEnc_uid180_fpHypot3dTest_q <= "10";
            WHEN "011" => outMuxSelEnc_uid180_fpHypot3dTest_q <= "01";
            WHEN "100" => outMuxSelEnc_uid180_fpHypot3dTest_q <= "11";
            WHEN "101" => outMuxSelEnc_uid180_fpHypot3dTest_q <= "01";
            WHEN "110" => outMuxSelEnc_uid180_fpHypot3dTest_q <= "11";
            WHEN "111" => outMuxSelEnc_uid180_fpHypot3dTest_q <= "01";
            WHEN OTHERS => -- unreachable
                           outMuxSelEnc_uid180_fpHypot3dTest_q <= (others => '-');
        END CASE;
        -- End reserved scope level
    END PROCESS;

    -- VCC(CONSTANT,1)
    VCC_q <= "1";

    -- expRPostExc_uid190_fpHypot3dTest(MUX,189)@9
    expRPostExc_uid190_fpHypot3dTest_s <= outMuxSelEnc_uid180_fpHypot3dTest_q;
    expRPostExc_uid190_fpHypot3dTest_combproc: PROCESS (expRPostExc_uid190_fpHypot3dTest_s, cstAllZWE_uid14_fpHypot3dTest_q, expRPreExc_uid188_fpHypot3dTest_b, cstAllOWE_uid12_fpHypot3dTest_q)
    BEGIN
        CASE (expRPostExc_uid190_fpHypot3dTest_s) IS
            WHEN "00" => expRPostExc_uid190_fpHypot3dTest_q <= cstAllZWE_uid14_fpHypot3dTest_q;
            WHEN "01" => expRPostExc_uid190_fpHypot3dTest_q <= expRPreExc_uid188_fpHypot3dTest_b;
            WHEN "10" => expRPostExc_uid190_fpHypot3dTest_q <= cstAllOWE_uid12_fpHypot3dTest_q;
            WHEN "11" => expRPostExc_uid190_fpHypot3dTest_q <= cstAllOWE_uid12_fpHypot3dTest_q;
            WHEN OTHERS => expRPostExc_uid190_fpHypot3dTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- NaNFracRPostExc_uid181_fpHypot3dTest(CONSTANT,180)
    NaNFracRPostExc_uid181_fpHypot3dTest_q <= "00000000000000000000001";

    -- fracR_uid162_fpHypot3dTest(BITSELECT,161)@9
    fracR_uid162_fpHypot3dTest_in <= fracRPostInc_uid161_fpHypot3dTest_q(23 downto 0);
    fracR_uid162_fpHypot3dTest_b <= fracR_uid162_fpHypot3dTest_in(23 downto 1);

    -- fracRPostExc_uid185_fpHypot3dTest(MUX,184)@9
    fracRPostExc_uid185_fpHypot3dTest_s <= outMuxSelEnc_uid180_fpHypot3dTest_q;
    fracRPostExc_uid185_fpHypot3dTest_combproc: PROCESS (fracRPostExc_uid185_fpHypot3dTest_s, cstZeroWF_uid13_fpHypot3dTest_q, fracR_uid162_fpHypot3dTest_b, NaNFracRPostExc_uid181_fpHypot3dTest_q)
    BEGIN
        CASE (fracRPostExc_uid185_fpHypot3dTest_s) IS
            WHEN "00" => fracRPostExc_uid185_fpHypot3dTest_q <= cstZeroWF_uid13_fpHypot3dTest_q;
            WHEN "01" => fracRPostExc_uid185_fpHypot3dTest_q <= fracR_uid162_fpHypot3dTest_b;
            WHEN "10" => fracRPostExc_uid185_fpHypot3dTest_q <= cstZeroWF_uid13_fpHypot3dTest_q;
            WHEN "11" => fracRPostExc_uid185_fpHypot3dTest_q <= NaNFracRPostExc_uid181_fpHypot3dTest_q;
            WHEN OTHERS => fracRPostExc_uid185_fpHypot3dTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- RHypot_uid191_fpHypot3dTest(BITJOIN,190)@9
    RHypot_uid191_fpHypot3dTest_q <= GND_q & expRPostExc_uid190_fpHypot3dTest_q & fracRPostExc_uid185_fpHypot3dTest_q;

    -- xOut(GPOUT,4)@9
    q <= RHypot_uid191_fpHypot3dTest_q;

END normal;
