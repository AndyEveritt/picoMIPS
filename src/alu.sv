//-----------------------------------------------------
// File Name   : alu.sv
// Function    : ALU module for picoMIPS
// Author: Andy Everitt
//-----------------------------------------------------

`include "alu_ops.sv"  
module alu #(parameter n =8) (
   input clk,
   input Reset, // active high reset
   input logic [n-1:0] DataA, DataB, // ALU operands
   input logic WriteEn, // Write enable
   input logic UseMul, // Use multiplier
   output logic [n-1:0] result // ALU result
);       

//------------- code starts here ---------
logic signed [n-1:0] TmpAdd, TmpMul, TmpOut;

adder adder0 (
   .A (DataA),
   .B (DataB),
   .Out (TmpAdd)
);

mult2s mult2s0 (
   .A (DataA),
   .B (DataB),
   .Out (TmpMul)
);

mux2 mux20 (
   .A (TmpAdd),
   .B (TmpMul),
   .select (UseMul),
   .Out (TmpOut)
);

always_ff @ (posedge clk or posedge Reset)
   if (Reset)
      result <= 8'b0;
   else if (WriteEn)
      result <= TmpOut;

endmodule //end of module ALU

