//---------------------------------------------------------
// File Name   : decoder.sv
// Function    : picoMIPS instruction decoder 
// Author: Andy Everitt
// ver 2:  // NOP, ADD, ADDI, and branches
// Last revised: 12 Mar 19
//---------------------------------------------------------

`include "opcodes.sv"
//---------------------------------------------------------
module decoder #(parameter n = 8, Isize = 16) (
  input [n+7:0] I,
  input SW8,
  output logic [n-1:0] imm,
  output logic PCHold,
  output logic SelSW,
  output logic SelImm,
  output logic SelReg,
  output logic UseMul,
  output logic AccEn,
  output logic AccRes,
  output logic RegEn,
  output logic RegAddr
  );

 logic [7:0] op;

//------------- code starts here ---------
// instruction decoder
assign op = I[Isize-1:n];
assign imm = I[n-1:0];

assign RegAddr = imm[1];

assign AccRes = op[7];
assign PCHold = op[6] && (SW8 == imm[0]);
assign SelSW  = op[5];
assign SelImm = op[4];
assign SelReg = op[3];
assign UseMul = op[2];
assign AccEn  = op[1];
assign RegEn  = op[0];


endmodule //module decoder --------------------------------