`timescale 1ns/1ps
`include "prj_definition.v"
module rc_add_sub_32_tb;
// output list
wire [`DATA_INDEX_LIMIT:0] Y;
wire CO;
// input list
reg [`DATA_INDEX_LIMIT:0] A;
reg [`DATA_INDEX_LIMIT:0] B;
reg SnA;
// 32 bit Adder and Subtractor instance
RC_ADD_SUB_32 inst1(Y, CO, A, B, SnA);
initial
begin
//2 - 7 = -2
A = 2; B = 7; SnA = 1;
//'hffffffff + 'h1 = 'h0 (CO = 'h1)
#5 A = 'hffffffff; B = 'h1; SnA = 0;
end

endmodule