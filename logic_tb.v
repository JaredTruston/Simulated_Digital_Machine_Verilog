`timescale 1ns/1ps
`include "prj_definition.v"
module SRLatchTB;

//inputs for SR Latch
reg S, R, C, nP, nR;
wire Q, Qbar;

SR_LATCH sr_latch_inst(Q, Qbar, S, R, C, nP, nR);
initial
begin

C = 1'b1; S = 1'b1; R = 1'b0; nP = 1'b1; nR = 1'b1;
#5 C = 1'b1; S = 1'b0; R = 1'b0;
#5 C = 1'b0; S = 1'b0; R = 1'b0;
#5 C = 1'b1; S = 1'b0; R = 1'b1;
#5 C = 1'b1; S = 1'b0; R = 1'b0;
#5 C = 1'b0; S = 1'b0; R = 1'b0;

end
endmodule

module DLatchTB;

//inputs for D Latch
reg D, C, nP, nR;
wire Q, Qbar;

D_LATCH d_latch_inst(Q, Qbar, D, C, nP, nR);
initial
begin

D = 1'b0; C = 1'b1; nP = 1'b1; nR = 1'b1;
#5 C = 1'b0;
#5 D = 1'b1; C = 1'b1;
#5 C = 1'b0;
end
endmodule

module D_FF_TB;

//inputs for D Flip Flop
reg D, C;
reg nP, nR;
wire Q, Qbar;

D_FF d_flip_flop_inst(Q, Qbar, D, C, nP, nR);
initial
begin

C = 1'b1; D = 1'b0; nP = 1'b1; nR = 1'b1;
#5 C = 1'b0;
#5 C = 1'b1; D = 1'b1;
#5 C = 1'b0;
#5 nP = 1'b0; nR = 1'b1;
#5 nP = 1'b1; nR = 1'b0;
end
endmodule

module REG_1_BIT_TB;

//inputs for D Flip Flop
reg D, C, L;
reg nP, nR;
wire Q, Qbar;

REG1 register_1_bit_inst(Q, Qbar, D, L, C, nP, nR);
initial
begin

C = 1'b1; D = 1'b0; L = 1'b1; nP = 1'b1; nR = 1'b1;
#5 C = 1'b0; L = 1'b0;
#5 C = 1'b1; D = 1'b1; L = 1'b1; nP = 1'b1; nR = 1'b1;
#5 C = 1'b0; L = 1'b0;
#5 D = 1'b1; L = 1'b1; nP = 1'b1; nR = 1'b0;
#5 C = 1'b0; L = 1'b0;
#5 C = 1'b1; D = 1'b1; L = 1'b1; nP = 1'b0; nR = 1'b1;
#5 C = 1'b0; L = 1'b0;
#5 C = 1'b1; D = 1'b1; nP = 1'b0; nR = 1'b0;
#5 C = 1'b0;

end
endmodule 