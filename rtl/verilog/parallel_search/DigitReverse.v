module DigitReverse
#(parameter WIDTH = 12)
(
    bits,
    bitsReverse
);
// ===============================================================
// Input & Output
// ===============================================================
input  [WIDTH-1:0] bits;
output [WIDTH-1:0] bitsReverse;

//================================================================
// Design
//================================================================
genvar i;
generate
    // Only for Radix-4 architecture
    for (i=0;i<WIDTH;i=i+2) begin : bit_reverse
        assign bitsReverse[(WIDTH-2-i)+:2] = bits[i+:2];
    end
endgenerate
endmodule