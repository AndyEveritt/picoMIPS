//-----------------------------------------------------
// File Name   : alu.sv
// Function    : ALU testbench module for picoMIPS
// Author: Andy Everitt
//-----------------------------------------------------

//`include "alu_ops.sv"
`include "alu.sv"
//---------------------------------------------------------
module alu_tb;
   parameter n = 8;
   logic clk, Reset;
   logic [n-1:0] DataA, DataB0, DataB1; // ALU operands
   logic WriteEn0, WriteEn1, UseMul0, UseMul1;
   logic [n-1:0] result0, result1; // ALU result

   logic [7:0] Count;
   
   // clk generation
   always #20 clk = ~clk;

   // reset generation
   initial begin
      clk = 0;
      Reset = 0;
      #40 Reset = 1;
      #40 Reset = 0;
   end

   always_ff @ (posedge clk or posedge Reset)
      if (Reset)
         Count = 0;
      else
         Count <= Count + 1;

   // testing ALU without feedback
   always_ff @ (posedge clk) begin
      case(Count)
         0 : begin // result should not change
            WriteEn0 = 1;
            UseMul0 = 1;
            DataA = 8'b00000110;
            DataB0 = 8'b01100000;
            end
         1 : begin // result should not change
            WriteEn0 = 1;
            UseMul0 = 1;
            DataA = 8'b00010100;
            DataB0 = 8'b11100000;
            end
         2 : begin // result should not change
            WriteEn0 = 1;
            UseMul0 = 0;
            DataA = 8'b00000110;
            DataB0 = 8'b01100000;
            end
         3 : begin // result should not change
            WriteEn0 = 1;
            UseMul0 = 0;
            DataA = 8'b00010100;
            DataB0 = 8'b11100000;
            end
      endcase
   end

   // testing ALU with feedback
   always_ff @ (posedge clk) begin
      case(Count)
         0 : begin // result should not change
            WriteEn1 = 0;
            UseMul1 = 0;
            DataB1 = 8'b00000000;
            end
         1 : begin // result should not change
            WriteEn1 = 0;
            UseMul1 = 0;
            DataB1 = 8'b11111111;   // -1
            end
         2 : begin // result += DataB1
            WriteEn1 = 1;
            UseMul1 = 0;
            DataB1 = 8'b10011110;   // -98
            end
         3 : begin // result += DataB1
            WriteEn1 = 1;
            UseMul1 = 0;
            DataB1 = 8'b00010110;   // 22
            end
         4 : begin // result = result
            WriteEn1 = 0;
            UseMul1 = 0;
            DataB1 = 8'b00010110;   // 22
            end
         5 : begin // result *= DataB1
            WriteEn1 = 1;
            UseMul1 = 1;
            DataB1 = 8'b00010110;   // 0.171875
            end
         6 : begin // result *= DataB1
            WriteEn1 = 1;
            UseMul1 = 1;
            DataB1 = 8'b10000000;   // -1
            end
         7 : begin // result *= DataB1
            WriteEn1 = 1;
            UseMul1 = 1;
            DataB1 = 8'b01111111;   // 0.9921875
            end
      endcase
   end

   // ALU with no feedback to test logic
   alu LogicTest (
      .clk(clk),
      .Reset(Reset),
      .DataA(DataA),
      .DataB(DataB0),
      .WriteEn(WriteEn0),
      .UseMul(UseMul0),
      .result(result0)
   );

   // ALU with closed loop feedback to test accumulator
   alu AccumTest (
      .clk(clk),
      .Reset(Reset),
      .DataA(result1),
      .DataB(DataB1),
      .WriteEn(WriteEn1),
      .UseMul(UseMul1),
      .result(result1)
   );

endmodule