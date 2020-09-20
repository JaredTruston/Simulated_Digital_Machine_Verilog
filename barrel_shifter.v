// Name: barrel_shifter.v
// Module: SHIFT32_L , SHIFT32_R, SHIFT32
//
// Notes: 32-bit barrel shifter
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

// 32-bit shift amount shifter
module SHIFT32(Y,D,S, LnR);
// output list
output [31:0] Y;
wire [31:0] bsOUT;
// input list
input [31:0] D;
input [31:0] S;
input LnR;

// Barrel shifter instance
BARREL_SHIFTER32 barrel_shift_32_inst(.Y(bsOUT), .D(D), .S(S[4:0]), .LnR(LnR));

//or gate
wire or_out;

or or_inst(or_out, S[31:5], 1'b0);

MUX32_2x1 mux32_2x1_inst(.Y(Y), .I0(bsOUT), .I1(32'b0),  .S(or_out));

endmodule

// Shift with control L or R shift
module BARREL_SHIFTER32(Y,D,S, LnR);
// output list
output [31:0] Y;
// input list
input [31:0] D;
input [4:0] S;
input LnR;
//Intermediary Output for left and right barrel shifter
wire [31:0] rY, lY;

//Left and Right Barrel shifter instances
SHIFT32_R shift_32_r_inst(.Y(rY), .D(D), .S(S));
SHIFT32_L shift_32_l_inst(.Y(lY), .D(D), .S(S));

//32 bit mux to select between left and right barrel shifter
MUX32_2x1 mux32_2x1_inst(.Y(Y), .I0(lY), .I1(rY), .S(LnR));

endmodule

// Left shifter
module SHIFT32_L(Y,D,S);
// output list
output [31:0] Y;
// input list
input [31:0] D;
input [4:0] S;

// intermediary outputs and inputs from multiplexers
wire [3:0] B [31:0];

//MUX1_2x1 mux1_2x1_inst1(Y,I0, I1, S);

//First Bit Shift
genvar i;
generate
for (i = 0; i < 32; i = i + 1)
begin : mux_2x1_gen_loop_1
 if (i === 0)
 MUX1_2x1 mux1_2x1_inst(.Y(B[i][0]), .I0(D[i]), .I1(1'b0), .S(S[0]));
 else
 MUX1_2x1 mux1_2x1_inst(.Y(B[i][0]), .I0(D[i]), .I1(D[i-1]), .S(S[0]));
end
endgenerate

//Second Bit Shift
genvar j;
generate
for (j = 0; j < 32; j = j + 1)
begin : mux_2x1_gen_loop_2
 if (j <= 1)
 MUX1_2x1 mux1_2x1_inst(.Y(B[j][1]), .I0(B[j][0]), .I1(1'b0), .S(S[1]));
 else
 MUX1_2x1 mux1_2x1_inst(.Y(B[j][1]), .I0(B[j][0]), .I1(B[j-2][0]), .S(S[1]));
end
endgenerate

//Third Bit Shift
genvar k;
generate
for (k = 0; k < 32; k = k + 1)
begin : mux_2x1_gen_loop_3
 if (k <= 3)
 MUX1_2x1 mux1_2x1_inst(.Y(B[k][2]), .I0(B[k][1]), .I1(1'b0), .S(S[2]));
 else
 MUX1_2x1 mux1_2x1_inst(.Y(B[k][2]), .I0(B[k][1]), .I1(B[k-4][1]), .S(S[2]));
end
endgenerate

//Fourth Bit Shift
genvar x;
generate
for (x = 0; x < 32; x = x + 1)
begin : mux_2x1_gen_loop_4
 if (x <= 7)
 MUX1_2x1 mux1_2x1_inst(.Y(B[x][3]), .I0(B[x][2]), .I1(1'b0), .S(S[3]));
 else
 MUX1_2x1 mux1_2x1_inst(.Y(B[x][3]), .I0(B[x][2]), .I1(B[x-8][2]), .S(S[3]));
end
endgenerate

//Fifth Bit Shift
genvar y;
generate
for (y = 0; y < 32; y = y + 1)
begin : mux_2x1_gen_loop_5
 if (y <= 15)
 MUX1_2x1 mux1_2x1_inst(.Y(Y[y]), .I0(B[y][3]), .I1(1'b0), .S(S[4]));
 else
 MUX1_2x1 mux1_2x1_inst(.Y(Y[y]), .I0(B[y][3]), .I1(B[y-16][3]), .S(S[4]));
end
endgenerate

endmodule

// Right shifter
module SHIFT32_R(Y,D,S);
// output list
output [31:0] Y;
// input list
input [31:0] D;
input [4:0] S;

// intermediary outputs and inputs from multiplexers
wire [3:0] B [31:0];

//MUX1_2x1 mux1_2x1_inst1(Y,I0, I1, S);

//First Bit Shift
genvar i;
generate
for (i = 0; i < 32; i = i + 1)
begin : mux_2x1_gen_loop_1
 if (i === 31)
 MUX1_2x1 mux1_2x1_inst(.Y(B[i][0]), .I0(D[i]), .I1(1'b0), .S(S[0]));
 else
 MUX1_2x1 mux1_2x1_inst(.Y(B[i][0]), .I0(D[i]), .I1(D[i+1]), .S(S[0]));
end
endgenerate

//Second Bit Shift
genvar j;
generate
for (j = 0; j < 32; j = j + 1)
begin : mux_2x1_gen_loop_2
 if (j >= 30)
 MUX1_2x1 mux1_2x1_inst(.Y(B[j][1]), .I0(B[j][0]), .I1(1'b0), .S(S[1]));
 else
 MUX1_2x1 mux1_2x1_inst(.Y(B[j][1]), .I0(B[j][0]), .I1(B[j+2][0]), .S(S[1]));
end
endgenerate

//Third Bit Shift
genvar k;
generate
for (k = 0; k < 32; k = k + 1)
begin : mux_2x1_gen_loop_3
 if (k >= 28)
 MUX1_2x1 mux1_2x1_inst(.Y(B[k][2]), .I0(B[k][1]), .I1(1'b0), .S(S[2]));
 else
 MUX1_2x1 mux1_2x1_inst(.Y(B[k][2]), .I0(B[k][1]), .I1(B[k+4][1]), .S(S[2]));
end
endgenerate

//Fourth Bit Shift
genvar x;
generate
for (x = 0; x < 32; x = x + 1)
begin : mux_2x1_gen_loop_4
 if (x >= 24)
 MUX1_2x1 mux1_2x1_inst(.Y(B[x][3]), .I0(B[x][2]), .I1(1'b0), .S(S[3]));
 else
 MUX1_2x1 mux1_2x1_inst(.Y(B[x][3]), .I0(B[x][2]), .I1(B[x+8][2]), .S(S[3]));
end
endgenerate

//Fifth Bit Shift
genvar y;
generate
for (y = 0; y < 32; y = y + 1)
begin : mux_2x1_gen_loop_5
 if (y >= 16)
 MUX1_2x1 mux1_2x1_inst(.Y(Y[y]), .I0(B[y][3]), .I1(1'b0), .S(S[4]));
 else
 MUX1_2x1 mux1_2x1_inst(.Y(Y[y]), .I0(B[y][3]), .I1(B[y+16][3]), .S(S[4]));
end
endgenerate

endmodule

