// Name: logic.v
// Module: 
// Input: 
// Output: 
//
// Notes: Common definitions
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 02, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
//
// 64-bit two's complement
module TWOSCOMP64(Y,A);
//output list
output [63:0] Y;
//input list
input [63:0] A;

//wire for not output
wire [63:0] nA;

wire CO;

//not gate instances
genvar i;
generate
 for (i = 0; i < 32; i = i + 1)
 begin: not_64_gen_loop
  not notInst(nA[i], A[i]);
 end
endgenerate

// 64 bit adder
RC_ADD_SUB_64 rc_add_sub_64_inst(.Y(Y),.CO(CO), .A(nA), .B(64'b1), .SnA(1'b0));

endmodule

// 32-bit two's complement
module TWOSCOMP32(Y,A);
//output list
output [31:0] Y;
//input list
input [31:0] A;

//wire for not output
wire [31:0] nA;

wire CO;

//not gate instances
genvar i;
generate
 for (i = 0; i < 32; i = i + 1)
 begin: not_32_gen_loop
  not notInst(nA[i], A[i]);
 end
endgenerate

//32 bit adder
RC_ADD_SUB_32 rc_add_sub_32_inst(.Y(Y),.CO(CO), .A(nA), .B(32'b1), .SnA(1'b0));

endmodule

// 32-bit registere +ve edge, Reset on RESET=0
module REG32(Q, D, LOAD, CLK, RESET);
output [31:0] Q;

input CLK, LOAD;
input [31:0] D;
input RESET;

// TBD

endmodule

// 1 bit register +ve edge, 
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module REG1(Q, Qbar, D, L, C, nP, nR);
input D, C, L;
input nP, nR;
output Q,Qbar;

wire mux_out;

MUX1_2x1 mux_inst(mux_out, Q, D, L);
D_FF d_ff_inst(Q, Qbar, mux_out, C, nP, nR);

endmodule

// 1 bit flipflop +ve edge, 
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module D_FF(Q, Qbar, D, C, nP, nR);
input D, C;
input nP, nR;
output Q,Qbar;

//wire for output of the D Latch
wire Y, Ybar;

//inverter for control
wire notC;
not not_inst(notC, C);

D_LATCH d_latch_inst(Y, Ybar, D, C, nP, nR);
SR_LATCH sr_latch_inst(Q, Qbar, Y, Ybar, notC, nP, nR);


endmodule

// 1 bit D latch
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module D_LATCH(Q, Qbar, D, C, nP, nR);
input D, C;
input nP, nR;
output Q,Qbar;

//inverts the D bit
wire notD;
not not_inst(notD, D);

SR_LATCH sr_lact_inst(Q, Qbar, D, notD, C, nP, nR);

endmodule

// 1 bit SR latch
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module SR_LATCH(Q,Qbar, S, R, C, nP, nR);
input S, R, C;
input nP, nR;
output Q,Qbar;

// wire for output from the S and C as well as
// the R and C nand gates
wire SCout, RCout;

//wire for intermediary outputs between 3 way nand gate
wire andOut1, andOut2;

// 4 nand gate instances
nand nand_inst1(SCout, S, C);
nand nand_inst2(RCout, R, C);
and and_inst1(andOut1, SCout, nP);
and and_inst2(andOut2, RCout, nR);
nand nand_inst3(Q, andOut1, Qbar);
nand nand_inst4(Qbar, andOut2, Q);


endmodule

// 5x32 Line decoder
module DECODER_5x32(D,I);
// output
output [31:0] D;
// input
input [4:0] I;
// wire for output of 4x16 line decoder
wire [15:0] fD;
// wire for output of inversion of I4
wire notI;
not not_inst1(notI, I[4]);
DECODER_4x16 decoder_4x16_inst(fD[15:0], I[3:0]);

// instanatiation of and gates
genvar i;
generate
for (i = 0; i < 32; i = i + 1)
begin: and_gen_loop
 if (i < 16)
  and andInst(D[i], fD[i], notI);
 else
  and andInst(D[i], fD[i - 16], I[4]);
end
endgenerate

endmodule

// 4x16 Line decoder
module DECODER_4x16(D,I);
// output
output [15:0] D;
// input
input [3:0] I;
// wire for output of 3x8 line decoder
wire [7:0] fD;
// wire for output of inversion of I3
wire notI;
not not_inst1(notI, I[3]);
DECODER_3x8 decoder_3x8_inst(fD[7:0], I[2:0]);

// instanatiation of and gates
genvar i;
generate
for (i = 0; i < 16; i = i + 1)
begin: and_gen_loop
 if (i < 8)
  and andInst(D[i], fD[i], notI);
 else
  and andInst(D[i], fD[i - 8], I[3]);
end
endgenerate

endmodule

// 3x8 Line decoder
module DECODER_3x8(D,I);
// output
output [7:0] D;
// input
input [2:0] I;
// wire for output of 2x4 line decoder
wire [3:0] fD;
// wire for output of inversion of I2
wire notI;
not not_inst1(notI, I[2]);
DECODER_2x4 decoder_2x4_inst(fD[3:0], I[1:0]);

// and gates
and andInst1(D[0], fD[0], notI);
and andInst2(D[1], fD[1], notI);
and andInst3(D[2], fD[2], notI);
and andInst4(D[3], fD[3], notI);
and andInst5(D[4], fD[0], I[2]);
and andInst6(D[5], fD[1], I[2]);
and andInst7(D[6], fD[2], I[2]);
and andInst8(D[7], fD[3], I[2]);

endmodule

// 2x4 Line decoder
module DECODER_2x4(D,I);
// output
output [3:0] D;
// input
input [1:0] I;
// wire for output of inverter
wire [1:0] notI;
not not_inst1(notI[0], I[0]);
not not_inst2(notI[1], I[1]);

//4 and gate instances
and andInst1(D[0], notI[1], notI[0]);
and andInst2(D[1], notI[1], I[0]);
and andInst3(D[2], I[1], notI[0]);
and andInst4(D[3], I[1], I[0]);

endmodule