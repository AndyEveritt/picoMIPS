//---------------------------------------------------------
// File Name   : decodertest.sv
// Function    : testbench for picoMIPS instruction decoder 
// Author: Andy Everitt
// ver 1:  // only NOP, ADD, ADDI
// Last revised: 12 Mar 19
//---------------------------------------------------------

`include "opcodes.sv"
//---------------------------------------------------------
module decodertest;

logic [5:0] opcode; // top 6 bits of instruction
logic [3:0] ALUfunc;
//    PC control, imm MUX control, register file control
logic PCincr,imm,w1,w2;
//    ALU control
   
//------------- code starts here ---------
// instruction decoder
always_comb 
begin
  // default output signal values
   PCincr = 1'b1; // PC increments by default
   ALUfunc = 3'b000; imm=0; w1=0; w2=0; 
  case(opcode)
    `ADDI : begin
	          w1 = 1'b1; // dest register
			  imm = 1'b1; // direct imm data to data_a
	       end
 
  endcase // opcode


end // always_comb


endmodule //module decoder --------------------------------