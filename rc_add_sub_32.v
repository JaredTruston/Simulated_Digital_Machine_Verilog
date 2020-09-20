// Name: rc_add_sub_32.v
// Module: RC_ADD_SUB_32
//
// Output: Y : Output 32-bit
//         CO : Carry Out
//         
//
// Input: A : 32-bit input
//        B : 32-bit input
//        SnA : if SnA=0 it is add, subtraction otherwise
//
// Notes: 32-bit adder / subtractor implementaiton.
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

module RC_ADD_SUB_64(Y, CO, A, B, SnA);
// output list
output [63:0] Y;
output CO;
// input list
input [63:0] A;
input [63:0] B;
input SnA;

wire [63:0] BXOR;
wire [62:0] COp;

genvar i;
generate
for (i = 0; i < 64; i = i + 1)
begin: rc_add_sub_64_gen_loop
 if (i === 0)
  begin
  xor inst1(BXOR[i], SnA, B[i]);
  FULL_ADDER fa_inst1(.S(Y[i]),.CO(COp[i]),.A(A[i]),.B(BXOR[i]),.CI(SnA));
  end
 else if (i === 63)
  begin
  xor inst1(BXOR[i], SnA, B[i]);
  FULL_ADDER fa_inst1(.S(Y[i]),.CO(CO),.A(A[i]),.B(BXOR[i]),.CI(COp[i-1]));
  end
 else
  begin
  xor inst1(BXOR[i], SnA, B[i]);
  FULL_ADDER fa_inst1(.S(Y[i]),.CO(COp[i]),.A(A[i]),.B(BXOR[i]),.CI(COp[i-1]));
  end
end
endgenerate

endmodule

module RC_ADD_SUB_32(Y, CO, A, B, SnA);
// output list
output [`DATA_INDEX_LIMIT:0] Y;
output CO;
// input list
input [`DATA_INDEX_LIMIT:0] A;
input [`DATA_INDEX_LIMIT:0] B;
input SnA;
//wires for connections
wire [`DATA_INDEX_LIMIT:0] BXOR; //result of xor between SnA and given B bit
wire [30:0] COp; //CO from previous Full Adder is used as CI for next Full Adder
//xor instances and FULL_ADDER instances for 32 bit number
xor inst1(BXOR[0], SnA, B[0]);
FULL_ADDER fa_inst1(.S(Y[0]),.CO(COp[0]),.A(A[0]),.B(BXOR[0]),.CI(SnA));
xor inst2(BXOR[1], SnA, B[1]);
FULL_ADDER fa_inst2(.S(Y[1]),.CO(COp[1]),.A(A[1]),.B(BXOR[1]),.CI(COp[0]));
xor inst3(BXOR[2], SnA, B[2]);
FULL_ADDER fa_inst3(.S(Y[2]),.CO(COp[2]),.A(A[2]),.B(BXOR[2]),.CI(COp[1]));
xor inst4(BXOR[3], SnA, B[3]);
FULL_ADDER fa_inst4(.S(Y[3]),.CO(COp[3]),.A(A[3]),.B(BXOR[3]),.CI(COp[2]));
xor inst5(BXOR[4], SnA, B[4]);
FULL_ADDER fa_inst5(.S(Y[4]),.CO(COp[4]),.A(A[4]),.B(BXOR[4]),.CI(COp[3]));
xor inst6(BXOR[5], SnA, B[5]);
FULL_ADDER fa_inst6(.S(Y[5]),.CO(COp[5]),.A(A[5]),.B(BXOR[5]),.CI(COp[4]));
xor inst7(BXOR[6], SnA, B[6]);
FULL_ADDER fa_inst7(.S(Y[6]),.CO(COp[6]),.A(A[6]),.B(BXOR[6]),.CI(COp[5]));
xor inst8(BXOR[7], SnA, B[7]);
FULL_ADDER fa_inst8(.S(Y[7]),.CO(COp[7]),.A(A[7]),.B(BXOR[7]),.CI(COp[6]));
xor inst9(BXOR[8], SnA, B[8]);
FULL_ADDER fa_inst9(.S(Y[8]),.CO(COp[8]),.A(A[8]),.B(BXOR[8]),.CI(COp[7]));
xor inst10(BXOR[9], SnA, B[9]);
FULL_ADDER fa_inst10(.S(Y[9]),.CO(COp[9]),.A(A[9]),.B(BXOR[9]),.CI(COp[8]));
xor inst11(BXOR[10], SnA, B[10]);
FULL_ADDER fa_inst11(.S(Y[10]),.CO(COp[10]),.A(A[10]),.B(BXOR[10]),.CI(COp[9]));
xor inst12(BXOR[11], SnA, B[11]);
FULL_ADDER fa_inst12(.S(Y[11]),.CO(COp[11]),.A(A[11]),.B(BXOR[11]),.CI(COp[10]));
xor inst13(BXOR[12], SnA, B[12]);
FULL_ADDER fa_inst13(.S(Y[12]),.CO(COp[12]),.A(A[12]),.B(BXOR[12]),.CI(COp[11]));
xor inst14(BXOR[13], SnA, B[13]);
FULL_ADDER fa_inst14(.S(Y[13]),.CO(COp[13]),.A(A[13]),.B(BXOR[13]),.CI(COp[12]));
xor inst15(BXOR[14], SnA, B[14]);
FULL_ADDER fa_inst15(.S(Y[14]),.CO(COp[14]),.A(A[14]),.B(BXOR[14]),.CI(COp[13]));
xor inst16(BXOR[15], SnA, B[15]);
FULL_ADDER fa_inst16(.S(Y[15]),.CO(COp[15]),.A(A[15]),.B(BXOR[15]),.CI(COp[14]));
xor inst17(BXOR[16], SnA, B[16]);
FULL_ADDER fa_inst17(.S(Y[16]),.CO(COp[16]),.A(A[16]),.B(BXOR[16]),.CI(COp[15]));
xor inst18(BXOR[17], SnA, B[17]);
FULL_ADDER fa_inst18(.S(Y[17]),.CO(COp[17]),.A(A[17]),.B(BXOR[17]),.CI(COp[16]));
xor inst19(BXOR[18], SnA, B[18]);
FULL_ADDER fa_inst19(.S(Y[18]),.CO(COp[18]),.A(A[18]),.B(BXOR[18]),.CI(COp[17]));
xor inst20(BXOR[19], SnA, B[19]);
FULL_ADDER fa_inst20(.S(Y[19]),.CO(COp[19]),.A(A[19]),.B(BXOR[19]),.CI(COp[18]));
xor inst21(BXOR[20], SnA, B[20]);
FULL_ADDER fa_inst21(.S(Y[20]),.CO(COp[20]),.A(A[20]),.B(BXOR[20]),.CI(COp[19]));
xor inst22(BXOR[21], SnA, B[21]);
FULL_ADDER fa_inst22(.S(Y[21]),.CO(COp[21]),.A(A[21]),.B(BXOR[21]),.CI(COp[20]));
xor inst23(BXOR[22], SnA, B[22]);
FULL_ADDER fa_inst23(.S(Y[22]),.CO(COp[22]),.A(A[22]),.B(BXOR[22]),.CI(COp[21]));
xor inst24(BXOR[23], SnA, B[23]);
FULL_ADDER fa_inst24(.S(Y[23]),.CO(COp[23]),.A(A[23]),.B(BXOR[23]),.CI(COp[22]));
xor inst25(BXOR[24], SnA, B[24]);
FULL_ADDER fa_inst25(.S(Y[24]),.CO(COp[24]),.A(A[24]),.B(BXOR[24]),.CI(COp[23]));
xor inst26(BXOR[25], SnA, B[25]);
FULL_ADDER fa_inst26(.S(Y[25]),.CO(COp[25]),.A(A[25]),.B(BXOR[25]),.CI(COp[24]));
xor inst27(BXOR[26], SnA, B[26]);
FULL_ADDER fa_inst27(.S(Y[26]),.CO(COp[26]),.A(A[26]),.B(BXOR[26]),.CI(COp[25]));
xor inst28(BXOR[27], SnA, B[27]);
FULL_ADDER fa_inst28(.S(Y[27]),.CO(COp[27]),.A(A[27]),.B(BXOR[27]),.CI(COp[26]));
xor inst29(BXOR[28], SnA, B[28]);
FULL_ADDER fa_inst29(.S(Y[28]),.CO(COp[28]),.A(A[28]),.B(BXOR[28]),.CI(COp[27]));
xor inst30(BXOR[29], SnA, B[29]);
FULL_ADDER fa_inst30(.S(Y[29]),.CO(COp[29]),.A(A[29]),.B(BXOR[29]),.CI(COp[28]));
xor inst31(BXOR[30], SnA, B[30]);
FULL_ADDER fa_inst31(.S(Y[30]),.CO(COp[30]),.A(A[30]),.B(BXOR[30]),.CI(COp[29]));
xor inst32(BXOR[31], SnA, B[31]);
FULL_ADDER fa_inst32(.S(Y[31]),.CO(CO),.A(A[31]),.B(BXOR[31]),.CI(COp[30]));

endmodule

