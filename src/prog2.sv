//-----------------------------------------------------
// File Name : prog.sv
// Function : Program memory Psize x Isize
// Author: Andy Everitt
//-----------------------------------------------------
module prog2 #(parameter Psize = 5, Isize = 15) (// psize - address width, Isize - instruction width
  input clk,
  input logic [Psize-1:0] address,
  output logic [Isize-1:0] I
  ); // I - instruction code

`include "opcodes.sv"

// program memory 
always
  case (address)
    // x1 operations
    0 : I = {`HEI , 8'b0};          // Wait until SW8 == 1
    1 : I = {`MULI, 8'b0};          // accum = 0
    2 : I = {`ADDS, 8'b0};          // accum = SW[7:0] (x1)
    3 : I = {`MULI, 8'b01100000};   // accum = x1 * 0.75
    4 : I = {`ADDI, 8'b00010100};   // accum = (x1 * 0.75) + 20
    5 : I = {`STR , 8'b0};          // r0 = accum = (x1 * 0.75) + 20
    6 : I = {`MULI, 8'b0};          // accum = 0
    7 : I = {`ADDS, 8'b0};          // accum = SW[7:0] (x1)
    8 : I = {`MULI, 8'b11000000};   // accum = x1 * -0.5
    9 : I = {`ADDI, 8'b11101100};   // accum = (x1 * -0.5) - 20
    10 : I = {`STR , 8'b1};         // r1 = (x1 * -0.5) - 20
    11 : I = {`MULI, 8'b0};         // accum = 0

    // y1 operations
    12 : I = {`HEI , 8'b1};         // Wait until SW8 == 0
    13 : I = {`HEI , 8'b0};         // Wait until SW8 == 1
    14 : I = {`ADDS, 8'b0};         // accum = SW[7:0] (y1)
    15 : I = {`MULI, 8'b01000000};  // accum = y1 * 0.5
    16 : I = {`ADDR, 8'b0};         // accum = (y1 * 0.5) + r0
    17 : I = {`STR , 8'b0};         // r0 = accum = (x1 * 0.75) + (y1 * 0.5) + 20
    18 : I = {`MULI, 8'b0};         // accum = 0
    19 : I = {`ADDS, 8'b0};         // accum = SW[7:0] (y1)
    20 : I = {`MULI, 8'b01100000};  // accum = y1 * 0.75
    21 : I = {`ADDR, 8'b1};         // accum = (y1 * 0.75) + r1
    22 : I = {`STR , 8'b1};         // r1 = accum = (x1 * -0.5) + (y1 * 0.75) - 20
    23 : I = {`MULI, 8'b0};         // accum = 0
    
    // Display x2
    24 : I = {`HEI , 8'b1};         // Wait until SW8 == 0
    25 : I = {`ADDR, 8'b0};         // accum = r0 = x2
    

    // Display y2
    26 : I = {`HEI , 8'b0};         // Wait until SW8 == 1
    27 : I = {`MULI, 8'b0};         // accum = 0
    28 : I = {`ADDR, 8'b1};         // accum = r1 = y2
    29 : I = {`HEI , 8'b1};         // Wait until SW8 == 0
    30 : I = {`MULI, 8'b0};         // accum = 0

    default: I = {(Isize){1'b0}};

  endcase
      
endmodule // end of module prog