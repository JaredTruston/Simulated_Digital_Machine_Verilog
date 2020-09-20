`timescale 1ns/1ps
`include "prj_definition.v"

module logic_32_bit_tb;

reg [31:0] A, B;
wire [31:0] Y;
//NOR32_2x1(Y,A,B)
NOR32_2x1 nor32_inst(Y, A, B);
initial
begin
 A = 27; B = 13;
end

reg [31:0] C, D;
wire [31:0] Z;
//AND32_2x1(Y,A,B)
AND32_2x1 and32_inst(Z, C, D);
initial
begin
 C = 26; D = 19;
end

reg [31:0] E;
wire [31:0] nE;
//INV32_1x1(Y,A)
INV32_1x1 inv32_inst(nE, E);
initial
begin
 E = 32'hffffffff;
end

reg [31:0] F, G;
wire [31:0] X;
//OR32_2x1(Y,A,B)
OR32_2x1 or32_inst(X, F, G);
initial
begin
 F = 32'hffffffff; G = 32'h0000ffff;
end

endmodule