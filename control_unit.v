// Name: control_unit.v
// Module: CONTROL_UNIT
// Output: RF_DATA_W  : Data to be written at register file address RF_ADDR_W
//         RF_ADDR_W  : Register file address of the memory location to be written
//         RF_ADDR_R1 : Register file address of the memory location to be read for RF_DATA_R1
//         RF_ADDR_R2 : Registere file address of the memory location to be read for RF_DATA_R2
//         RF_READ    : Register file Read signal
//         RF_WRITE   : Register file Write signal
//         ALU_OP1    : ALU operand 1
//         ALU_OP2    : ALU operand 2
//         ALU_OPRN   : ALU operation code
//         MEM_ADDR   : Memory address to be read in
//         MEM_READ   : Memory read signal
//         MEM_WRITE  : Memory write signal
//         
// Input:  RF_DATA_R1 : Data at ADDR_R1 address
//         RF_DATA_R2 : Data at ADDR_R1 address
//         ALU_RESULT    : ALU output data
//         CLK        : Clock signal
//         RST        : Reset signal
//
// INOUT: MEM_DATA    : Data to be read in from or write to the memory
//
// Notes: - Control unit synchronize operations of a processor
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//  1.1     Oct 19, 2014        Kaushik Patra   kpatra@sjsu.edu         Added ZERO status output
//------------------------------------------------------------------------------------------
`include "prj_definition.v"
module CONTROL_UNIT(MEM_DATA, RF_DATA_W, RF_ADDR_W, RF_ADDR_R1, RF_ADDR_R2, RF_READ, RF_WRITE,
                    ALU_OP1, ALU_OP2, ALU_OPRN, MEM_ADDR, MEM_READ, MEM_WRITE,
                    RF_DATA_R1, RF_DATA_R2, ALU_RESULT, ZERO, CLK, RST); 

// Output signals
// Outputs for register file 
output [`DATA_INDEX_LIMIT:0] RF_DATA_W;
output [`ADDRESS_INDEX_LIMIT:0] RF_ADDR_W, RF_ADDR_R1, RF_ADDR_R2;
output RF_READ, RF_WRITE;
// Outputs for ALU
output [`DATA_INDEX_LIMIT:0]  ALU_OP1, ALU_OP2;
output  [`ALU_OPRN_INDEX_LIMIT:0] ALU_OPRN;
// Outputs for memory
output [`ADDRESS_INDEX_LIMIT:0]  MEM_ADDR;
output MEM_READ, MEM_WRITE;

//registers for corresponding output ports
//Register file registers
reg [`DATA_INDEX_LIMIT:0] RF_DATA_W;
reg [`ADDRESS_INDEX_LIMIT:0] RF_ADDR_W, RF_ADDR_R1, RF_ADDR_R2;
reg RF_READ, RF_WRITE;
//ALU registers
reg [`DATA_INDEX_LIMIT:0]  ALU_OP1, ALU_OP2;
reg  [`ALU_OPRN_INDEX_LIMIT:0] ALU_OPRN;
//Memory registers
reg [`ADDRESS_INDEX_LIMIT:0]  MEM_ADDR;
reg MEM_READ, MEM_WRITE;

// Input signals
input [`DATA_INDEX_LIMIT:0] RF_DATA_R1, RF_DATA_R2, ALU_RESULT;
input ZERO, CLK, RST;

// Inout signal
inout [`DATA_INDEX_LIMIT:0] MEM_DATA;

//register for write data in memory
reg [`DATA_INDEX_LIMIT:0] data_ret_w;

//For read operation, DATA must be set to HighZ and 
//For write operation, DATA must be set to internal write data register
assign MEM_DATA = ((MEM_READ===1'b0)&&(MEM_WRITE===1'b1))?data_ret_w:{`DATA_WIDTH{1'bz} };

//internal registers
reg [`DATA_INDEX_LIMIT:0]PC_REG; // Holds the program counter value
reg [`DATA_INDEX_LIMIT:0]INST_REG; // Stores the current instruction
reg [`DATA_INDEX_LIMIT:0]SP_REF; // Stack pointer register

// State nets
wire [2:0] proc_state;

//output registers for instructions
reg [5:0]   opcode; 
reg [4:0]   rs; 
reg [4:0]   rt; 
reg [4:0]   rd; 
reg [4:0]   shamt; 
reg [5:0]   funct; 
reg [15:0]  immediate; 
reg [25:0]  address;
reg [31:0]  signextimm;
reg [31:0]  zeroextimm;
reg [31:0]  loadupperimm;
reg [31:0]  jumpaddress;

PROC_SM state_machine(.STATE(proc_state),.CLK(CLK),.RST(RST));

initial
begin
 PC_REG = `INST_START_ADDR;
 SP_REF = `INIT_STACK_POINTER;
end

always @ (proc_state or RST)
begin

 if (RST === 1'b0)
 begin
  PC_REG = `INST_START_ADDR;
  SP_REF = `INIT_STACK_POINTER;
 end
 
 else

 begin
  if (proc_state === `PROC_FETCH)
   begin
   // Set Memory Address to Program Counter
   MEM_ADDR = PC_REG;
   
   // Set Memory Control to the read operation 
   MEM_READ = 1'b1;
   MEM_WRITE = 1'b0;
   
   // Set Register File Control to hold
   RF_READ = 1'b0;
   RF_WRITE = 1'b0;
   end
 
  if (proc_state === `PROC_DECODE)
   begin
   // Store current instruction into INST_REG
   INST_REG = MEM_DATA;
   
   print_instruction(INST_REG);  

   // Parse into instruction and instantiate the various ports

   // R-Type
   {opcode, rs, rt, rd, shamt, funct} = INST_REG;
   
   // I-Type
   {opcode, rs, rt, immediate} = INST_REG;
   signextimm[15:0] = immediate;
   signextimm[31:16] = {16{immediate[15]}};
   zeroextimm = {16'b0, immediate};
   loadupperimm = {immediate, 16'b0};
   
   // J-Type
   {opcode, address} = INST_REG;
   jumpaddress = {6'b0, address};
   
   // read address of RF set to rs and rt
   RF_ADDR_R1 = rs;
   RF_ADDR_R2 = rt;
   
   // rf operation is set to reading
   RF_READ = 1'b1;
   RF_WRITE = 1'b0; 
  end

  if (proc_state === `PROC_EXE)
   begin
   //$write("	Instruction Parts: opcode = %h, rs = %h, rt = %h,rd = %h, shamt = %h, funct = %h", opcode, rs, rt, rd, shamt, funct);
   case(opcode)
   // R-Type
   6'h00 : begin
 	 	case(funct)
			6'h20: begin
				ALU_OPRN = `ALU_OPRN_WIDTH'h01; 
				ALU_OP1 = RF_DATA_R1; 
				ALU_OP2 = RF_DATA_R2; //add function
			       end
			6'h22: begin 
				ALU_OPRN = `ALU_OPRN_WIDTH'h02; 
				ALU_OP1 = RF_DATA_R1; 
				ALU_OP2 = RF_DATA_R2; //sub function
			       end
			6'h2c: begin
				ALU_OPRN = `ALU_OPRN_WIDTH'h03; 
				ALU_OP1 = RF_DATA_R1; 
				ALU_OP2 = RF_DATA_R2; //mul function
			       end
			6'h02: begin
				ALU_OPRN = `ALU_OPRN_WIDTH'h04; 
				ALU_OP1 = RF_DATA_R1; 
				ALU_OP2 = shamt; //integer shift right function
			       end
			6'h01: begin
				ALU_OPRN = `ALU_OPRN_WIDTH'h05; 
				ALU_OP1 = RF_DATA_R1; 
				ALU_OP2 = shamt; //integer shift left function
			       end
			6'h24: begin
				ALU_OPRN = `ALU_OPRN_WIDTH'h06; 
				ALU_OP1 = RF_DATA_R1; 
				ALU_OP2 = RF_DATA_R2; //and function
			       end
			6'h25: begin
				ALU_OPRN = `ALU_OPRN_WIDTH'h07; 
				ALU_OP1 = RF_DATA_R1; 
				ALU_OP2 = RF_DATA_R2; //or function
			       end
			6'h27: begin
				ALU_OPRN = `ALU_OPRN_WIDTH'h08; 
				ALU_OP1 = RF_DATA_R1; 
				ALU_OP2 = RF_DATA_R2; //nor function
			       end
			6'h2a: begin
				ALU_OPRN = `ALU_OPRN_WIDTH'h09; 
				ALU_OP1 = RF_DATA_R1; 
				ALU_OP2 = RF_DATA_R2; //set less than function
			       end
		endcase
	end

   // I-Type
   6'h08 : begin
		ALU_OPRN = `ALU_OPRN_WIDTH'h01; 
		ALU_OP1 = RF_DATA_R1; 
		ALU_OP2 = signextimm; //add function
		
	   end
   6'h1d : begin
		ALU_OPRN = `ALU_OPRN_WIDTH'h03; 
		ALU_OP1 = RF_DATA_R1; 
		ALU_OP2 = signextimm; //mul function
	   end
   6'h0c : begin
		ALU_OPRN = `ALU_OPRN_WIDTH'h06; 
		ALU_OP1 = RF_DATA_R1; 
		ALU_OP2 = zeroextimm; //and function
	   end
   6'h0d : begin
		ALU_OPRN = `ALU_OPRN_WIDTH'h07; 
		ALU_OP1 = RF_DATA_R1; 
		ALU_OP2 = zeroextimm; //or function
	   end
   6'h0a : begin
		ALU_OPRN = `ALU_OPRN_WIDTH'h09; 
		ALU_OP1 = RF_DATA_R1; 
		ALU_OP2 = signextimm; //set less than
	   end
  
   // J-Type
   6'h1b : RF_ADDR_R1 = 0; // push function
   endcase 
   
   end

  if(proc_state === `PROC_MEM)
   begin
   //$write("	ALU: alu oprn = %h, alu op1 = %h, alu op2 = %h, shamt = %h, signextimm = %h, alu result = %h", ALU_OPRN, ALU_OP1, ALU_OP2, shamt, signextimm, ALU_RESULT);
   case(opcode)
   6'h23 : begin // load word operation
	   //[rt] = M[[rs] + SignExtImm
	   MEM_ADDR = RF_DATA_R1 + signextimm;
	   MEM_READ = 1'b1;
	   MEM_WRITE = 1'b0;
	   //$write("	Load Word - addr = %h", MEM_ADDR);
	   end
   6'h2b : begin // store word operation
	   //M[[rs] + SignExtImm] = rt
	   data_ret_w = RF_DATA_R2;
	   MEM_ADDR = RF_DATA_R1 + signextimm;
           //$write("	Store Word - addr = %h, data = %d", MEM_ADDR, data_ret_w);
	   MEM_READ = 1'b0;
	   MEM_WRITE = 1'b1;
	   end
   6'h1b : begin // push operation
	   //M[$sp] = R[0]; $sp = $sp - 1
	   MEM_ADDR = SP_REF;
	   data_ret_w = RF_DATA_R1;
	   MEM_READ = 1'b0;
	   MEM_WRITE = 1'b1;
	   SP_REF = SP_REF - 1;
	   //$write("	Push Operation - addr = %h", MEM_ADDR);
	   end
   6'h1c : begin // pop operation
	   //$sp = $sp + 1; R[0] = M[$sp]
	   SP_REF = SP_REF + 1;
	   MEM_ADDR = SP_REF;
	   MEM_READ = 1'b1;
	   MEM_WRITE = 1'b0;
	   //$write("	Pop Operation");
	   end
   default : begin //set memory to HighZ
	     MEM_READ = 1'b1;
	     MEM_WRITE = 1'b1;
	     end
   endcase
   end

  if(proc_state === `PROC_WB)
   begin
   // by default increase PC_REG by 1  
   PC_REG = PC_REG + 1;
  
   // Reset the memory write signal to no-op
   MEM_WRITE = 1'b1;
   MEM_READ = 1'b1;
  
   // Set RF writing address, data, and control to write back into register file
   if (opcode === 6'h00)
	RF_ADDR_W = rd;
   else
	RF_ADDR_W = rt;
   if (opcode === 6'h23 | opcode === 6'h1c)
	begin
  	RF_DATA_W = MEM_DATA;
	RF_READ = 1'b0;
   	RF_WRITE = 1'b1;
	end
   else if (opcode === 6'h2b | opcode === 6'h1b )
	begin
	// Do Nothing
	end
   else if (opcode === 6'h04) // beq instruction
    begin
     if (RF_DATA_R1 === RF_DATA_R2)
      PC_REG = PC_REG + signextimm;
    end
   else if (opcode === 6'h05) // bne instruction
    begin
     if (RF_DATA_R1 != RF_DATA_R2)
      PC_REG = PC_REG + signextimm;
    end
   else if (opcode === 6'h02) // jmp instruction
    PC_REG = jumpaddress;
   else if (opcode === 6'h03) // jal instruction
    begin
     RF_ADDR_W = 'd31;
     //$write("RF_ADDR_W %d", RF_ADDR_W);
     RF_DATA_W = PC_REG;
     RF_READ = 1'b0;
     RF_WRITE = 1'b1;
     PC_REG = jumpaddress;
    end
   else if (opcode === 6'h0f) // lui instruction
   begin
    RF_DATA_W = loadupperimm;
    RF_READ = 1'b0;
    RF_WRITE = 1'b1;
   end
   else
   begin
    if (funct === 6'h08 && opcode === 6'h00) // jr instruction
    begin
     PC_REG = RF_DATA_R1;
    end
    else
    begin
     RF_DATA_W = ALU_RESULT;
     RF_READ = 1'b0;
     RF_WRITE = 1'b1;
    end
   end
  
  //$write("	RF_DATA = %h, RF_ADDR_W = %h ", RF_DATA_W, RF_ADDR_W);
  
  //$stop;
  end
 end
end




task print_instruction; 
input [`DATA_INDEX_LIMIT:0] inst; 

reg [5:0]   opcode; 
reg [4:0]   rs; 
reg [4:0]   rt; 
reg [4:0]   rd; 
reg [4:0]   shamt; 
reg [5:0]   funct; 
reg [15:0]  immediate; 
reg [25:0]  address; 
begin // parse the instruction 
// R-type {opcode, rs, rt, rd, shamt, funct} = inst; 
// I-type {opcode, rs, rt, immediate } = inst; 
// J-type {opcode, address} = inst; 
$write("@ %6dns -> [0X%08h] ", $time, inst); 

case(opcode) 
// R-Type 
6'h00 : begin
            case(funct)
                6'h20: $write("add  r[%02d], r[%02d], r[%02d];", rs, rt, rd);
                6'h22: $write("sub  r[%02d], r[%02d], r[%02d];", rs, rt, rd);
                6'h2c: $write("mul  r[%02d], r[%02d], r[%02d];", rs, rt, rd);
                6'h24: $write("and  r[%02d], r[%02d], r[%02d];", rs, rt, rd);
		6'h25: $write("or   r[%02d], r[%02d], r[%02d];", rs, rt, rd);
                6'h27: $write("nor  r[%02d], r[%02d], r[%02d];", rs, rt, rd);
                6'h2a: $write("slt  r[%02d], r[%02d], r[%02d];", rs, rt, rd);
                6'h01: $write("sll  r[%02d], %2d, r[%02d];", rs, shamt, rd);
                6'h02: $write("srl  r[%02d], 0X%02h, r[%02d];", rs, shamt, rd);
                6'h08: $write("jr   r[%02d];", rs);
                default: $write("");
            endcase
        end
// I-type
6'h08 : $write("addi  r[%02d], r[%02d], 0X%04h;", rs, rt, immediate); 
6'h1d : $write("muli  r[%02d], r[%02d], 0X%04h;", rs, rt, immediate); 
6'h0c : $write("andi  r[%02d], r[%02d], 0X%04h;", rs, rt, immediate); 
6'h0d : $write("ori   r[%02d], r[%02d], 0X%04h;", rs, rt, immediate); 
6'h0f : $write("lui   r[%02d], 0X%04h;", rt, immediate); 
6'h0a : $write("slti  r[%02d], r[%02d], 0X%04h;", rs, rt, immediate); 
6'h04 : $write("beq   r[%02d], r[%02d], 0X%04h;", rs, rt, immediate); 
6'h05 : $write("bne   r[%02d], r[%02d], 0X%04h;", rs, rt, immediate); 
6'h23 : $write("lw    r[%02d], r[%02d], 0X%04h;", rs, rt, immediate); 
6'h2b : $write("sw    r[%02d], r[%02d], 0X%04h;", rs, rt, immediate); 
// J-Type 
6'h02 : $write("jmp   0X%07h;", address); 
6'h03 : $write("jal   0X%07h;", address); 
6'h1b : $write("push;"); 
6'h1c : $write("pop;");
default: $write(""); 
endcase 
$write("\n"); 
end 
endtask

endmodule;


//------------------------------------------------------------------------------------------
// Module: CONTROL_UNIT
// Output: STATE      : State of the processor
//         
// Input:  CLK        : Clock signal
//         RST        : Reset signal
//
// INOUT: MEM_DATA    : Data to be read in from or write to the memory
//
// Notes: - Processor continuously cycle witnin fetch, decode, execute, 
//          memory, write back state. State values are in the prj_definition.v
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
module PROC_SM(STATE,CLK,RST);
// list of inputs
input CLK, RST;
// list of outputs
output [2:0] STATE;
// registers
reg [2:0] STATE;
reg [2:0] NEXT_STATE;

//initial block
initial
begin
 NEXT_STATE = `PROC_FETCH;
 STATE = 3'bxx; //3 bit unknown
end

always @ (posedge CLK or negedge RST)
begin
 if (RST === 1'b0)
  begin
   NEXT_STATE = `PROC_FETCH;
   STATE = 3'bxx; //3 bit unknown
  end

 else
  begin
  //assign state with next_state
   STATE = NEXT_STATE;

  //if NEXT_STATE is PROC_FETCH, set it to PROC_DECODE
  if (STATE === `PROC_FETCH)
   begin
    NEXT_STATE = `PROC_DECODE;
   end

  //if NEXT_STATE is PROC_DECODE, set it to PROC_EXE
  if (STATE === `PROC_DECODE)
   begin
    NEXT_STATE = `PROC_EXE;
   end

  //if NEXT_STATE is PROC_EXE, set it to PROC_MEM
  if (STATE === `PROC_EXE)
   begin
    NEXT_STATE = `PROC_MEM;
   end

  //if NEXT_STATE is PROC_MEM, set it to PROC_WB
  if (STATE === `PROC_MEM)
   begin
    NEXT_STATE = `PROC_WB;
   end

  //if NEXT_STATE is PROC_WB, set it to PROC_FETCH
  if (STATE === `PROC_WB)
   begin
    NEXT_STATE = `PROC_FETCH;
   end
   end
end

endmodule;
