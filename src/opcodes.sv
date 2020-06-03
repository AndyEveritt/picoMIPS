//---------------------------------------------------------
// File Name   : opcodes.sv
// Function    : picoMIPS instruction decoder 
// Author: Andy Everitt
//---------------------------------------------------------

// opcode bits
// bit[7] = Accumulator reset
// bit[6] = Hold program counter
// bit[5] = Select SW as ALU input
// bit[4] = Select Imm as ALU input
// bit[3] = Select Reg as ALU input
// bit[2] = Use Multiplier
// bit[1] = Accumulator write
// bit[0] = Register write

// NOP
`define NOP  7'b000000

// ALU and registers only: %d = %d op %s
`define ADDR  7'b0001010    // add register to accum
`define ADDS   7'b0100010   // add SW to accum
`define MULR  7'b0001110    // multiply accum by register

// ALU immediate:  %d = %d op imm
`define ADDI  7'b0010010    // add imm to accum
`define MULI  7'b0010110    // multiply accum by imm

// Load & Store
`define STR    7'b0000001   // store accum in register and reset accum

// Branches
`define HEI   7'b1000000    // hold pc if equal to imm