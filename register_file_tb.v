`include "prj_definition.v"
module REG_FILE_32x32_TB;
// Storage list
reg [`REG_ADDR_INDEX_LIMIT:0] ADDR_R1, ADDR_R2, ADDR_W;
// reset
reg READ, WRITE, RST;
reg [`DATA_INDEX_LIMIT:0] DATA_REG_W; // write input
integer i; // index for memory operation
integer no_of_test, no_of_pass;

// wire lists
wire  CLK;
wire [`DATA_INDEX_LIMIT:0] DATA_R1; // Wire for read 1
wire [`DATA_INDEX_LIMIT:0] DATA_R2; // Wire for read 2

// Clock generator instance
CLK_GENERATOR clk_gen_inst(.CLK(CLK));

// 32x32 Memory Instantiation:  REGISTER_FILE_32x32(DATA_R1, DATA_R2, ADDR_R1, ADDR_R2, DATA_W, ADDR_W, READ, WRITE, CLK, RST)
REGISTER_FILE_32x32 reg_file_ints(.DATA_R1(DATA_R1), .DATA_R2(DATA_R2), .ADDR_R1(ADDR_R1), 
					.ADDR_R2(ADDR_R2), .DATA_W(DATA_REG_W), .ADDR_W(ADDR_W), 
					.READ(READ), .WRITE(WRITE), .CLK(CLK), .RST(RST));

initial
begin
RST=1'b1;
READ=1'b0;
WRITE=1'b0;
no_of_test = 0;
no_of_pass = 0;

//Begin read and write operations
#10 RST = 1'b0; //resets values in all registers
#10 RST = 1'b1;
//Write Cycle
for (i = 0; i <= `DATA_INDEX_LIMIT; i = i + 1)
begin
#10	READ = 1'b0; WRITE = 1'b1; DATA_REG_W = i; ADDR_W = i;
	// sram_32x32[i] = [i];
end
//Read Cycle with Write Data
for (i = 0; i <= `DATA_INDEX_LIMIT; i = i + 1)
begin
#10	READ = 1'b1; WRITE = 1'b0; ADDR_R1 = i; ADDR_R2 = i;
#10	no_of_test = no_of_test + 1;
	if ((DATA_R1 !== i) && (DATA_R2 !== i))
		$write("[TEST] Read %1b, Write %1b, Addr_r1 %7h, Addr_r2 %7h, expecting %8h, got %8h [FAILED]\n", 
                                                            READ, WRITE, ADDR_R1, ADDR_R2, i + i, DATA_R1 + DATA_R2, );
	else
	 no_of_pass = no_of_pass + 1;
end
for (i = 0; i <= `DATA_INDEX_LIMIT; i = i + 1)
begin 
#15	READ = 1'b1; WRITE = 1'b1; ADDR_R1 = i; ADDR_R2 = i; //should hold previous data
end

#10 $write("\n");
    $write("\tTotal number of tests %d\n", no_of_test);
    $write("\tTotal number of pass  %d\n", no_of_pass);
    $write("\n");
    $stop;

end
endmodule;

