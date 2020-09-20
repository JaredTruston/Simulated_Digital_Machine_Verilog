// Name: mux.v
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
// 32-bit mux
module MUX32_32x1(Y, I0, I1, I2, I3, I4, I5, I6, I7,
                     I8, I9, I10, I11, I12, I13, I14, I15,
                     I16, I17, I18, I19, I20, I21, I22, I23,
                     I24, I25, I26, I27, I28, I29, I30, I31, S);
// output list
output [31:0] Y;
//input list
input [31:0] I0, I1, I2, I3, I4, I5, I6, I7;
input [31:0] I8, I9, I10, I11, I12, I13, I14, I15;
input [31:0] I16, I17, I18, I19, I20, I21, I22, I23;
input [31:0] I24, I25, I26, I27, I28, I29, I30, I31;
input [4:0] S;

//wires for output of first two mux
wire [31:0] mux_inst1_output;
wire [31:0] mux_inst2_output;

//3 mux instances
MUX32_16x1 mux32_2x1_inst_1(mux_inst1_output, I0, I1, I2, I3, I4, I5, I6, I7, I8, 
				I9, I10, I11, I12, I13, I14, I15, S[3:0]);
MUX32_16x1 mux32_2x1_inst_2(mux_inst2_output, I16, I17, I18, I19, I20, I21, I22, 
				I23, I24, I25, I26, I27, I28, I29, I30, I31, S[3:0]);
MUX32_2x1 mux32_2x1_inst_3(.Y(Y), .I0(mux_inst1_output), .I1(mux_inst2_output), .S(S[4]));

endmodule

// 32-bit 16x1 mux
module MUX32_16x1(Y, I0, I1, I2, I3, I4, I5, I6, I7,
                     I8, I9, I10, I11, I12, I13, I14, I15, S);
// output list
output [31:0] Y;
//input list
input [31:0] I0;
input [31:0] I1;
input [31:0] I2;
input [31:0] I3;
input [31:0] I4;
input [31:0] I5;
input [31:0] I6;
input [31:0] I7;
input [31:0] I8;
input [31:0] I9;
input [31:0] I10;
input [31:0] I11;
input [31:0] I12;
input [31:0] I13;
input [31:0] I14;
input [31:0] I15;
input [3:0] S;

//wires for output of first two mux
wire [31:0] mux_inst1_output;
wire [31:0] mux_inst2_output;

//3 mux instances
MUX32_8x1 mux32_2x1_inst_1(mux_inst1_output, I0, I1, I2, I3, I4, I5, I6, I7, S[2:0]);
MUX32_8x1 mux32_2x1_inst_2(mux_inst2_output, I8, I9, I10, I11, I12, I13, I14, I15, S[2:0]);
MUX32_2x1 mux32_2x1_inst_3(.Y(Y), .I0(mux_inst1_output), .I1(mux_inst2_output), .S(S[3]));

endmodule

// 32-bit 8x1 mux
module MUX32_8x1(Y, I0, I1, I2, I3, I4, I5, I6, I7, S);
// output list
output [31:0] Y;
//input list
input [31:0] I0;
input [31:0] I1;
input [31:0] I2;
input [31:0] I3;
input [31:0] I4;
input [31:0] I5;
input [31:0] I6;
input [31:0] I7;
input [2:0] S;

//wires for output of first two mux
wire [31:0] mux_inst1_output;
wire [31:0] mux_inst2_output;

//3 mux instances
MUX32_4x1 mux32_4x1_inst_1(.Y(mux_inst1_output), .I0(I0), .I1(I1), .I2(I2), .I3(I3), .S(S[1:0]));
MUX32_4x1 mux32_4x1_inst_2(.Y(mux_inst2_output), .I0(I4), .I1(I5), .I2(I6), .I3(I7), .S(S[1:0]));
MUX32_2x1 mux32_2x1_inst_3(.Y(Y), .I0(mux_inst1_output), .I1(mux_inst2_output), .S(S[2]));

endmodule

// 32-bit 4x1 mux
module MUX32_4x1(Y, I0, I1, I2, I3, S);
// output list
output [31:0] Y;
//input list
input [31:0] I0;
input [31:0] I1;
input [31:0] I2;
input [31:0] I3;
input [1:0] S;

//wires for output of first two mux
wire [31:0] mux_inst1_output;
wire [31:0] mux_inst2_output;

//3 mux instances
MUX32_2x1 mux32_2x1_inst_1(.Y(mux_inst1_output), .I0(I0), .I1(I1), .S(S[0]));
MUX32_2x1 mux32_2x1_inst_2(.Y(mux_inst2_output), .I0(I2), .I1(I3), .S(S[0]));
MUX32_2x1 mux32_2x1_inst_3(.Y(Y), .I0(mux_inst1_output), .I1(mux_inst2_output), .S(S[1]));

endmodule

// 32-bit mux
module MUX32_2x1(Y, I0, I1, S);
// output list
output [31:0] Y;
//input list
input [31:0] I0;
input [31:0] I1;
input S;

//generate loop to create 32 instantiations of 1 bit mux
genvar i;
generate
   for (i = 0; i < 32; i = i + 1)
   begin : mux32_2x1_gen_loop
	MUX1_2x1 mux_2x1_inst(Y[i], I0[i], I1[i], S);
   end
endgenerate
endmodule

// 1-bit mux
module MUX1_2x1(Y,I0, I1, S);
//output list
output Y;
//input list
input I0, I1, S;
wire not_S, and_out_1, and_out_2;

//not_S = S'
not inst1_not(not_S, S);
//and_out_1 = I0 & not_S
and inst1_and(and_out_1, I0, not_S);
//and_out_2 = I1 & S
and inst2_and(and_out_2, I1, S);
//inst1_or = and_out_1 or and_out_2
or inst1_or(Y, and_out_1, and_out_2);

endmodule
