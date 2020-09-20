// Name: mult.v
// Module: MULT32 , MULT32_U
//
// Output: HI: 32 higher bits
//         LO: 32 lower bits
//         
//
// Input: A : 32-bit input
//        B : 32-bit input
//
// Notes: 32-bit multiplication
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

module MULT32(HI, LO, A, B);
// output list
output [31:0] HI;
output [31:0] LO;
// input list
input [31:0] A;
input [31:0] B;
// 2's complement converters for A and B input
// output of the 2's complement converters
wire [31:0] twoCOMPA;
wire [31:0] twoCOMPB;
// 2's complement converter instances
TWOSCOMP32 twoCompInst1(twoCOMPA,A);
TWOSCOMP32 twoCompInst2(twoCOMPB,B);
//multiplexers
//output for the 2 multiplexers
wire [31:0] muxOut1;
wire [31:0] muxOut2;
//output of the unsigned mulitplier
wire [31:0] UHI;
wire [31:0] ULO;
//mulitplexer instances for selecting between 2's complement and normal A and B inputs
MUX32_2x1 mux32_2x1_inst1(.Y(muxOut1), .I0(A), .I1(twoCOMPA), .S(A[31]));
MUX32_2x1 mux32_2x1_inst2(.Y(muxOut2), .I0(B), .I1(twoCOMPB), .S(B[31]));
//unsigned multiplier instance
MULT32_U unsignMul32Inst(UHI, ULO, muxOut1, muxOut2);
//wire for sign of final output
wire posNegS;
//sign of final output is selected via xor gate of signs of initial A and B inputs
xor xorGate(posNegS, A[31], B[31]);
//wire holds outputValue of performing two's complement on 64 bit final result
wire [63:0] outputValue;
TWOSCOMP64 twoComp64Inst(outputValue, {UHI,ULO});
//mulitplexers for selecting between 2's complement and normal LO and HI results
MUX32_2x1 mux32_2x1_inst3(.Y(LO), .I0(ULO), .I1(outputValue[31:0]), .S(posNegS));
MUX32_2x1 mux32_2x1_inst4(.Y(HI), .I0(UHI), .I1(outputValue[63:32]), .S(posNegS));


endmodule

module MULT32_U(HI, LO, A, B);
// output list
output [31:0] HI;
output [31:0] LO;
// input list
input [31:0] A;
input [31:0] B;
// wire list
wire [31:0] CO; // Provides Carry Out bit from 32 bit adder and subtractor
wire [31:0] adder_output [31:0]; // Provides output from 21 bit adder and subtractor
wire [31:0] Y [0:31]; // Provides 32 bit AND output

//32 32 bit AND gates
genvar i;
generate
 for (i = 0; i < 32; i = i + 1) 
 begin : and32_32_2x1_gen_loop
  AND32_2x1 and_32_inst(.Y(Y[i]), .A(A), .B({32{B[i]}}));
 end
endgenerate


//31 32 bit Adder and Subtractors
genvar j;
generate
 for (i = 0; i < 32; i = i + 1)
 begin : rc_add_sub_32_gen_loop
  if (i === 0)
  begin
   assign LO[i] = Y[i][0];
   RC_ADD_SUB_32 rc_add_sub_32_inst(.Y(adder_output[i]),.CO(CO[i]), 
	.A({1'b0,Y[i][31:1]}), .B(Y[i+1]), .SnA(1'b0));
  end
  else if (i === 31)
  begin
   assign LO[31] = adder_output[i-1][0];
   assign HI = {CO[i-1],adder_output[i-1][31:1]};
  end
  else
  begin
   assign LO[i] = adder_output[i-1][0];
   RC_ADD_SUB_32 rc_add_sub_32_inst(.Y(adder_output[i]),.CO(CO[i]), 
	.A({CO[i-1],adder_output[i-1][31:1]}), .B(Y[i+1]), .SnA(1'b0));
  end 
 end
endgenerate


endmodule
