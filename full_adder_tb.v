`timescale 1ns/1ps
`include "prj_definition.v"

module full_adder_tb;
reg A, B, CI;
wire S, CO;

FULL_ADDER fa_inst_1(.S(S), .CO(CO), .A(A), .B(B), .CI(CI));

initial
begin
//expected S = 0 xor 0 xor 0 = 0
//expected CO = (0 and (0 xor 0)) or (0 and 0) = 0
A = 0; B = 0; CI = 0;
//expected S = 0 xor 1 xor 0 = 1
//expected CO = (0 and (1 xor 0)) or (1 and 0) = 0
#5 A = 1; B = 0; CI = 0;
//expected S = 0 xor 0 xor 1 = 1
//expected CO = (0 and (0 xor 1)) or (0 and 1) = 0
#5 A = 0; B = 1; CI = 0;
//expected S = 0 xor 1 xor 1 = 0
//expected CO = (0 and (1 xor 1)) or (1 and 1) = 1
#5 A = 1; B = 1; CI = 0;
//expected S = 1 xor 0 xor 0 = 1
//expected CO = (1 and (0 xor 0)) or (0 and 0) = 0
#5 A = 0; B = 0; CI = 1;
//expected S = 1 xor 1 xor 0 = 0
//expected CO = (1 and (1 xor 0)) or (1 and 0) = 1
#5 A = 1; B = 0; CI = 1;
//expected S = 1 xor 0 xor 1 = 0
//expected CO = (1 and (0 xor 1)) or (0 and 1) = 1
#5 A = 0; B = 1; CI = 1;
//expected S = 1 xor 1 xor 1 = 1
//expected CO = (1 and (1 xor 1)) or (1 and 1) = 1
#5 A = 1; B = 1; CI = 1;
end

endmodule