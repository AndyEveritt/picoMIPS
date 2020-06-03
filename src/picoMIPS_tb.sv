//-----------------------------------------------------
// File Name   : alu.sv
// Function    : ALU testbench module for picoMIPS
// Author: Andy Everitt
//-----------------------------------------------------

//`include "alu_ops.sv"
`include "picoMIPS.sv"
//---------------------------------------------------------
module picoMIPS_tb;
   parameter n = 8; // data bus width
   logic clk;
   logic [9:0] SW;
   logic signed [n-1:0] LED;
      
   
   // clk generation
   always #23 clk = ~clk;

   // testing ALU without feedback
   initial begin
      clk = 0;
      #100 SW = 10'b0000000000;  // reset
      #100 SW = 10'b1000000000;  // PCHold
      #100 SW = 10'b1100000110;  // Read x1
      #500 SW = 10'b1000000110;  // PCHold
      #200 SW = 10'b1100010100;  // Read y1
      #500 SW = 10'b1100000000;  // PCHold
      #200 SW = 10'b1000000000;  // Display x2
      #300 SW = 10'b1000000000;  // PCHold
      #200 SW = 10'b1100000000;  // Display y2

      // start program again
      #400 SW = 10'b1000000000;  // PCHold
      #100 SW = 10'b1100000110;  // Read x1
      #500 SW = 10'b1000000110;  // PCHold
      #200 SW = 10'b1100010100;  // Read y1
      #500 SW = 10'b1100000000;  // PCHold
      #200 SW = 10'b1000000000;  // Display x2
      #300 SW = 10'b1000000000;  // PCHold
      #200 SW = 10'b1100000000;  // Display y2
   end

   // ALU with no feedback to test logic
   picoMIPS #(.n(n)) UUT0 (
      .clk(clk),
      .SW(SW),
      .LED(LED)
   );

endmodule