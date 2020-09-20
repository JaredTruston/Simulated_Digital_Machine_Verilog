// Name: register_file.v
// Module: REGISTER_FILE_32x32
// Input:  DATA_W : Data to be written at address ADDR_W
//         ADDR_W : Address of the memory location to be written
//         ADDR_R1 : Address of the memory location to be read for DATA_R1
//         ADDR_R2 : Address of the memory location to be read for DATA_R2
//         READ    : Read signal
//         WRITE   : Write signal
//         CLK     : Clock signal
//         RST     : Reset signal
// Output: DATA_R1 : Data at ADDR_R1 address
//         DATA_R2 : Data at ADDR_R1 address
//
// Notes: - 32 bit word accessible dual read register file having 32 regsisters.
//        - Reset is done at -ve edge of the RST signal
//        - Rest of the operation is done at the +ve edge of the CLK signal
//        - Read operation is done if READ=1 and WRITE=0
//        - Write operation is done if WRITE=1 and READ=0
//        - X is the value at DATA_R* if both READ and WRITE are 0 or 1
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
//
`include "prj_definition.v"
module REGISTER_32(CLK, RST, L, D, Q);

//input list
input CLK, RST, L;
input [31:0] D;
//output
output [31:0] Q;
//Qbar output
wire [31:0] Qbar;

genvar i;
generate
for (i = 0; i < 32; i = i + 1)
begin: reg_1_bit_gen_loop
 REG1 register_1_bit_inst(Q[i], Qbar[i], D[i], L, CLK, 1'b1, RST);
end
endgenerate

endmodule

module REGISTER_FILE_32x32(DATA_R1, DATA_R2, ADDR_R1, ADDR_R2, 
                            DATA_W, ADDR_W, READ, WRITE, CLK, RST);

// input list
input READ, WRITE, CLK, RST;
input [`DATA_INDEX_LIMIT:0] DATA_W;
input [`REG_ADDR_INDEX_LIMIT:0] ADDR_R1, ADDR_R2, ADDR_W;

// output list
output [`DATA_INDEX_LIMIT:0] DATA_R1;
output [`DATA_INDEX_LIMIT:0] DATA_R2;

// 5x32 line decoder
wire [31:0] fD; //32 bit wire for output of the decoders
DECODER_5x32 decoder_5x32_inst(fD,ADDR_W);

wire [31:0] D; //32 bit wire for output of each and gate between line decoder output and WRITE signals

genvar j;
generate
for (j = 0; j < 32; j = j + 1)
begin : AND_GATES_gen_loop
 and and_inst(D[j], fD[j], WRITE);
end
endgenerate

wire [31:0] Q [31:0]; //32 bit output from each of the 32 bit registers
//32 and gates between W_ADDR line decoded and WRITE signal
genvar i;
generate
for (i = 0; i < 32; i = i + 1)
begin : REG_32_BIT_gen_loop
 REGISTER_32 reg_32_inst(CLK, RST, D[i], DATA_W, Q[i]);
end
endgenerate

//2 32x1 MUX
wire [31:0] Y [1:0]; //wire for output from 32x1 mux
MUX32_32x1 mux32_32x1_inst1(Y[0], Q[0], Q[1], Q[2], Q[3], Q[4], Q[5], Q[6], Q[7],
                     Q[8], Q[9], Q[10], Q[11], Q[12], Q[13], Q[14], Q[15],
                     Q[16], Q[17], Q[18], Q[19], Q[20], Q[21], Q[22], Q[23],
                     Q[24], Q[25], Q[26], Q[27], Q[28], Q[29], Q[30], Q[31], ADDR_R1);

MUX32_32x1 mux32_32x1_inst2(Y[1], Q[0], Q[1], Q[2], Q[3], Q[4], Q[5], Q[6], Q[7],
                     Q[8], Q[9], Q[10], Q[11], Q[12], Q[13], Q[14], Q[15],
                     Q[16], Q[17], Q[18], Q[19], Q[20], Q[21], Q[22], Q[23],
                     Q[24], Q[25], Q[26], Q[27], Q[28], Q[29], Q[30], Q[31], ADDR_R2);

MUX32_2x1 mux32_2x1_inst1(DATA_R1, 32'hZ, Y[0], READ);
MUX32_2x1 mux32_2x1_inst2(DATA_R2, 32'hZ, Y[1], READ);

endmodule
