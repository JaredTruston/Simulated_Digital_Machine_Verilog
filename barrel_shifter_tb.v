`timescale 1ns/1ps
`include "prj_definition.v"

module barrel_shifter_tb;

// output list
wire [31:0] Y;
// input list
reg [31:0] D;
reg [31:0] S;
reg LnR;

// 32 bit barrel shifter instance
SHIFT32 shifter_32_inst(Y,D,S, LnR);

initial
begin
//0 bit shift left
D = 32'hffff0230;
S = 'd0;
LnR = 1'b0;
# 5//1 bit shift left
D = 32'hffff0230;
S = 'd1;
LnR = 1'b0;
# 5 //2 bit shift left
D = 32'hffff0230;
S = 'd2;
LnR = 1'b0;
# 5 //3 bit shift left
D = 32'hffff0230;
S = 'd3;
LnR = 1'b0;
# 5 //4 bit shift left
D = 32'hffff0230;
S = 'd4;
LnR = 1'b0;
# 5 //5 bit shift left
D = 32'hffff0230;
S = 'd5;
LnR = 1'b0;
# 5 //6 bit shift left
D = 32'hffff0230;
S = 'd6;
LnR = 1'b0;
# 5 //7 bit shift left
D = 32'hffff0230;
S = 'd7;
LnR = 1'b0;
# 5 //8 bit shift left
D = 32'hffff0230;
S = 'd8;
LnR = 1'b0;
# 5 //9 bit shift left
D = 32'hffff0230;
S = 'd9;
LnR = 1'b0;
# 5 //10 bit shift left
D = 32'hffff0230;
S = 'd10;
LnR = 1'b0;
# 5 //11 bit shift left
D = 32'hffff0230;
S = 'd11;
LnR = 1'b0;
# 5 //12 bit shift left
D = 32'hffff0230;
S = 'd12;
LnR = 1'b0;
# 5 //13 bit shift left
D = 32'hffff0230;
S = 'd13;
LnR = 1'b0;
# 5 //14 bit shift left
D = 32'hffff0230;
S = 'd14;
LnR = 1'b0;
# 5 //31 bit shift left
D = 32'hffff0230;
S = 'd31;
LnR = 1'b0;
# 5 //32 bit shift left
D = 32'hffff0230;
S = 'd32;
LnR = 1'b0;
# 5 //1 bit shift right
D = 32'hffff0230;
S = 'd1;
LnR = 1'b1;
# 5 //2 bit shift right
D = 32'hffff0230;
S = 'd2;
LnR = 1'b1;
# 5 //4 bit shift right
D = 32'hffff0230;
S = 'd4;
LnR = 1'b1;
# 5 //8 bit shift right
D = 32'hffff0230;
S = 'd8;
LnR = 1'b1;
# 5 //16 bit shift right
D = 32'hffff0230;
S = 'd16;
LnR = 1'b1;
# 5 //31 bit shift right
D = 32'hffff0230;
S = 'd31;
LnR = 1'b1;
# 5 //32 bit shift right
D = 32'hffff0230;
S = 'd32;
LnR = 1'b1;
end

endmodule
