`timescale 1ns/10ps
// Name: prj_01_tb.v
// Module: prj_01_tb
// Input: 
// Output: 
//
// Notes: Testbench for project 01 testing ALU functionality
// 
// Supports the following functions
//	- Integer add (0x1), sub(0x2), mul(0x3)
//	- Integer shift_rigth (0x4), shift_left (0x5)
//	- Bitwise and (0x6), or (0x8), nor (0x8)
//      - set less than (0x8)
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 02, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//  1.1     Sep 04, 2014	Kaushik Patra	kpatra@sjsu.edu		Fixed test_and_count task
//                                                                      to count number of test and
//                                                                      pass correctly.
//------------------------------------------------------------------------------------------
//
`include "prj_definition.v"
module ALUZ_TB;

integer total_test;
integer pass_test;

reg [`ALU_OPRN_INDEX_LIMIT:0] oprn_reg;
reg [`DATA_INDEX_LIMIT:0] op1_reg;
reg [`DATA_INDEX_LIMIT:0] op2_reg;

wire [`DATA_INDEX_LIMIT:0] r_net;
wire z_net;

// Instantiation of ALU
ALU ALU_INST_01(.OUT(r_net), .ZERO(z_net), .OP1(op1_reg), 
                .OP2(op2_reg), .OPRN(oprn_reg));

// Drive the test patterns and test
initial
begin
op1_reg=0;
op2_reg=0;
oprn_reg=0;

total_test = 0;
pass_test = 0;

// test 1:  -'d15 + 'd3 = -'d12
#5  op1_reg= -'d15;
    op2_reg= 3;
    oprn_reg=`ALU_OPRN_WIDTH'h01;
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net));
// test 2: 'd15 + 'd5 = 'd20
#5  op1_reg= 15;
    op2_reg= 5;
    oprn_reg=`ALU_OPRN_WIDTH'h01;
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net));
// test 3: 'd5 - 'd15 = - 'd10
#5  op1_reg= 5;
    op2_reg= 15;
    oprn_reg=`ALU_OPRN_WIDTH'h02;   
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net));
// test 4: 'd20 - 'd1 = 'd19
#5  op1_reg=20;
    op2_reg=1;
    oprn_reg=`ALU_OPRN_WIDTH'h02;   
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net));
// test 5: 'd3 * 'd5 = 'd15
#5  op1_reg=3;
    op2_reg=5;
    oprn_reg=`ALU_OPRN_WIDTH'h03;
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net));
// test 6: -'d20 * 'd5 = -'d100
#5  op1_reg=-20;
    op2_reg=5;
    oprn_reg=`ALU_OPRN_WIDTH'h03;
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net));
// test 7: 'd3 >> 'd1 = 'b0011 >> 'd1 = 'b0001 = 'd1
#5  op1_reg=3;
    op2_reg=1;
    oprn_reg=`ALU_OPRN_WIDTH'h04;
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net));
// test 8: 'd18 >> 'd5 = 'b0001 0010 >> 'd5 = 'b0000 0000 = 'd0
#5  op1_reg=18;
    op2_reg=5;
    oprn_reg=`ALU_OPRN_WIDTH'h04;
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net));
// test 9: 'd3 << 'd1 = 'b0011 < 'd1 = 'b0110 = 'd6
#5  op1_reg=3;
    op2_reg=1;
    oprn_reg=`ALU_OPRN_WIDTH'h05;
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net));
// test 10: 'd4 << 'd2 = 'b0000 0100 << 'd2 = 'b0001 0000 = 'd16
#5  op1_reg=4;
    op2_reg=2;
    oprn_reg=`ALU_OPRN_WIDTH'h05;
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net));
// test 11: 'd3 & 'd2 = 'b0011 & 'b0010 = 'b0010 = 'd2
#5  op1_reg=3;
    op2_reg=2;
    oprn_reg=`ALU_OPRN_WIDTH'h06;
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net));
// test 12: 'd10 & 'd15 = 'b1010 & 'b1111 = 'b1010 = 'd10
#5  op1_reg=10;
    op2_reg=15;
    oprn_reg=`ALU_OPRN_WIDTH'h06;
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net));
// test 13: 'd5 | 'd2 = 'b0101 | 'b0010 = 'b0111 = 'd7 
#5  op1_reg=5;
    op2_reg=2;
    oprn_reg=`ALU_OPRN_WIDTH'h07;
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net));
// test 14: 'd10 | 'd16 = 'b0000 1010 | 'b0001 0000 = 'b0001 1010 = 'd26 
#5  op1_reg=10;
    op2_reg=16;
    oprn_reg=`ALU_OPRN_WIDTH'h07;
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net));
//test 15: 'd0 | 'd0 = 'd4294967295
#5  op1_reg=0;
    op2_reg=0;
    oprn_reg=`ALU_OPRN_WIDTH'h08;
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net));
//test 16: 'd4294967294 | 'd0 = 'b1111 1111 1111 1111 1111 1111 1111 1110 | 'b0000 0000 0000 0000 0000 0000 0000 0000 = 'd1
#5  op1_reg=4294967294;
    op2_reg=0;
    oprn_reg=`ALU_OPRN_WIDTH'h08;
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net));
// test 17: 'd5 < 'd6 = 'd1 
#5  op1_reg=5;
    op2_reg=6;
    oprn_reg=`ALU_OPRN_WIDTH'h09;
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net));
// test 18: 'd6 < 'd5 = 'd0
#5  op1_reg=6;
    op2_reg=5;
    oprn_reg=`ALU_OPRN_WIDTH'h09;
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net));

#5  $write("\n");
    $write("\tTotal number of tests %d\n", total_test);
    $write("\tTotal number of pass  %d\n", pass_test);
    $write("\n");
    $stop; // stop simulation here
end

//-----------------------------------------------------------------------------
// TASK: test_and_count
// 
// PARAMETERS: 
//     INOUT: total_test ; total test counter
//     INOUT: pass_test ; pass test counter
//     INPUT: test_status ; status of the current test 1 or 0
//
// NOTES: Keeps track of number of test and pass cases.
//
//-----------------------------------------------------------------------------
task test_and_count;
inout total_test;
inout pass_test;
input test_status;

integer total_test;
integer pass_test;
begin
    total_test = total_test + 1;
    if (test_status)
    begin
        pass_test = pass_test + 1;
    end
end
endtask

//-----------------------------------------------------------------------------
// FUNCTION: test_golden
// 
// PARAMETERS: op1, op2, oprn and result
// RETURN: 1 or 0 if the result matches golden 
//
// NOTES: Tests the result against the golden. Golden is generated inside.
//
//-----------------------------------------------------------------------------
function test_golden;
input [`DATA_INDEX_LIMIT:0] op1;
input [`DATA_INDEX_LIMIT:0] op2;
input [`ALU_OPRN_INDEX_LIMIT:0] oprn;
input [`DATA_INDEX_LIMIT:0] res;

reg [`DATA_INDEX_LIMIT:0] golden; // expected result
begin
    $write("[TEST] %0d ", op1);
    case(oprn)
        `ALU_OPRN_WIDTH'h01 : begin $write("+ "); golden = op1 + op2; end
        `ALU_OPRN_WIDTH'h02 : begin $write("- "); golden = op1 - op2; end
	`ALU_OPRN_WIDTH'h03 : begin $write("* "); golden = op1 * op2; end
	`ALU_OPRN_WIDTH'h04 : begin $write(">> "); golden = op1 >> op2; end
	`ALU_OPRN_WIDTH'h05 : begin $write("<< "); golden = op1 << op2; end
	`ALU_OPRN_WIDTH'h06 : begin $write("AND "); golden = op1&op2; end
	`ALU_OPRN_WIDTH'h07 : begin $write("OR "); golden = op1|op2; end
	`ALU_OPRN_WIDTH'h08 : begin $write("NOR "); golden = ~(op1|op2); end
	`ALU_OPRN_WIDTH'h09 : begin $write("< "); golden = (op1<op2); end
        default: begin $write("? "); golden = `DATA_WIDTH'hx; end
    endcase
    $write("%0d = %0d , got %0d ... ", op2, golden, res);

    test_golden = (res === golden)?1'b1:1'b0; // case equality
    if (test_golden)
	$write("[PASSED]");
    else 
        $write("[FAILED]");
    $write("\n");
end
endfunction

endmodule