// Name: alu.v
// Module: ALU
// Input: OP1[32] - operand 1
//        OP2[32] - operand 2
//        OPRN[6] - operation code
// Output: OUT[32] - output result for the operation
//
// Notes: 32 bit combinatorial ALU
// 
// Supports the following functions
//	- Integer add (0x1), sub(0x2), mul(0x3)
//	- Integer shift_rigth (0x4), shift_left (0x5)
//	- Bitwise and (0x6), or (0x7), nor (0x8)
//  - set less than (0x9)
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//  1.1     Oct 19, 2014        Kaushik Patra   kpatra@sjsu.edu         Added ZERO status output
//------------------------------------------------------------------------------------------
//
`include "prj_definition.v"
module ALU(OUT, ZERO, OP1, OP2, OPRN);
// input list
input [`DATA_INDEX_LIMIT:0] OP1; // operand 1
input [`DATA_INDEX_LIMIT:0] OP2; // operand 2
input [`ALU_OPRN_INDEX_LIMIT:0] OPRN; // operation code

// output list
output [`DATA_INDEX_LIMIT:0] OUT; // result of the operation.
output ZERO;

//control signals
wire notOPRN0;
not not_inst(notOPRN0, OPRN[0]);
wire SnA = notOPRN0 + (OPRN[3] & OPRN[0]);
wire LnR = notOPRN0;

//mulitplexer inputs
wire [31:0] In [15:0];

//Signed Multiplier Instance
//HI output
wire [31:0] HI;
MULT32 mult32_inst(HI, In[3], OP1, OP2);

//Barrel Shfiter Instances
SHIFT32 shift32_inst1(In[4], OP1, OP2, LnR);
SHIFT32 shift32_inst2(In[5], OP1, OP2, LnR);

//Adder Subtractor Instances
wire CO;
RC_ADD_SUB_32 rc_add_sub_32_inst1(In[1], CO, OP1, OP2, SnA);
RC_ADD_SUB_32 rc_add_sub_32_inst2(In[2], CO, OP1, OP2, SnA);
wire [31:0] SLTOut;
RC_ADD_SUB_32 rc_add_sub_32_inst3(SLTOut, CO, OP1, OP2, SnA);
assign In[9] = {31'b0,SLTOut[31]};

//AND instance
AND32_2x1 and32_2x1_inst(In[6],OP1,OP2);

//OR instance
OR32_2x1 or32_2x1_inst(In[7],OP1,OP2);

//NOR instance
NOR32_2x1 nor32_2x1_inst(In[8],OP1,OP2);

//MUX for each operation
wire [31:0] MUXOUT;
MUX32_16x1 mux32_16x1_inst(MUXOUT, In[0], In[1], In[2], In[3], 
		In[4], In[5], In[6], In[7], In[8], In[9], In[10], 
		In[11], In[12], In[13], In[14], In[15], OPRN[3:0]);
nor nor_inst(ZERO, MUXOUT, 1'b1);
assign OUT = MUXOUT;

endmodule
