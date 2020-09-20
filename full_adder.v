// Name: full_adder.v
// Module: FULL_ADDER
//
// Output: S : Sum
//         CO : Carry Out
//
// Input: A : Bit 1
//        B : Bit 2
//        CI : Carry In
//
// Notes: 1-bit full adder implementaiton.
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

module FULL_ADDER(S,CO,A,B,CI);
//output list
output S,CO;
//input list
input A,B, CI;
//wires: S1 provides output for sum bit of the first
//half-adder and subsequent input for the second half-
//-adder, C1 provides output for for the carry out bit
//of the first half-adder and input for the or gate in
//computation of the carry out of the full-adder, C2
//provides output for the carry out of the second half-
//-adder which is then used as input for the or gate
//in computation of the full-adder carry out bit
wire C1, C2, S1;

//Instantiation Two Half adders
HALF_ADDER hs_inst_1(.Y(S1), .C(C1), .A(A), .B(B));
HALF_ADDER hs_inst_2(.Y(S), .C(C2), .A(S1), .B(CI));

//OR gate for output of the full-adder Carry Out bit
or inst1(CO, C1, C2);

endmodule;
