`timescale 1ns/1ps
`include "prj_definition.v"
module mult_tb;
// unsigned multiplier
// output list
wire [31:0] HI, LO;
// input list
reg [31:0] A, B;

// 32 bit unsigned multiplier instance
MULT32 mult_inst1(HI, LO, A, B);
initial
begin
A = -'d2; B = -'d3;
#5
A = -'d5; B = 6;
end

endmodule