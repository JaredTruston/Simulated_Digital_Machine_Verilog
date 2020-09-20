`timescale 1ns/1ps
`include "prj_definition.v"
module twocomp_tb;

//input value
reg[31:0] A;
//output value
wire[31:0] Y;

// 2's complement converter instance
TWOSCOMP32 twocomp32_inst(.Y(Y),.A(A));
initial
begin
A = 2;
#5
A = -7;
end
endmodule