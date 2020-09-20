`timescale 1ns/1ps
`include "prj_definition.v"
module mux_tb;

//registers for inputs
reg I0, I1, S;
//wires for output
wire Y;
//2x1 mux instance
MUX1_2x1 mux1_2x1_inst1(Y,I0, I1, S);
//initial block for testing of 2x1 mux
initial
begin
//Y = (0 & 1) or (1 & 0) = 0
I0 = 1; I1 = 0; S = 0;
//Y = (1 & 1) or (0 & 0) = 1
#5 I0 = 1; I1 = 0; S = 1;
//Y = (0 & 1) or (1 & 1) = 1
#5 I0 = 0; I1 = 1; S = 0;
end

//registers for inputs of 32 2x1bit mux
reg [31:0] I0_32, I1_32; 
reg S_32;
//wire for outpyts of 32 2x1bit mux
wire [31:0] Y_32;
//32 2x1bit mux instance
MUX32_2x1 mux32_2x1_inst1(Y_32, I0_32, I1_32, S_32);
//initial block for testing of 32 2x1bit mux
initial
begin
//Y = 24 
I0_32 = 'd24; I1_32 = 'd5; S_32 = 1;
//Y = 72
#5 I0_32 = 'd308; I1_32 = 'd72; S_32 = 0;
//Y = -25
#5 I0_32 = -'d25; I1_32 = -'d52; S_32 = 1;
end

//registers for inputs of 32 2x1bit mux
reg [31:0] A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P; 
reg [5:0] S_16x1;
//wire for outpyts of 32 2x1bit mux
wire [31:0] Y_16x1;
//32 16x1bit mux instance
MUX32_16x1 mux32_16x1_inst1(Y_16x1, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, S_16x1);
//initial block for testing of 32 2x1bit mux
initial
begin
A = 32'd16; B = 32'd15; C = 32'd14; D = 32'd13; E = 32'd12; F = 32'd11;
G = 32'd10; H = 32'd9; I = 32'd8; J = 32'd7; K = 32'd6; L = 32'd5; M = 32'd4;
N = 32'd3; O = 32'd2; P = 32'd1; 
S_16x1 = 0;
#5 S_16x1 = 1;
#5 S_16x1 = 2;
#5 S_16x1 = 3;
#5 S_16x1 = 4;
#5 S_16x1 = 5;
#5 S_16x1 = 6;
#5 S_16x1 = 7;
#5 S_16x1 = 8;
#5 S_16x1 = 9;
#5 S_16x1 = 10;
#5 S_16x1 = 11;
#5 S_16x1 = 12;
#5 S_16x1 = 13;
#5 S_16x1 = 14;
#5 S_16x1 = 15;
end
endmodule

