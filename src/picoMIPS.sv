//------------------------------------
// File Name   : picoMIPS.sv
// Function    : picoMIPS CPU top level encapsulating module
// Author      : Andy Everitt
//------------------------------------

`include "alu_ops.sv"
module picoMIPS #( parameter n = 8) // data bus width
(input logic clk,
  input [9:0] SW,
  output signed [n-1:0] LED // need an output port, this will be the ALU output
);       

// master reset
logic nReset;

// declarations of local signals that connect CPU modules
// ALU
logic [n-1:0] imm; // immediate operand signal
logic [n-1:0] AluB; // output from imm MUX
logic AccEn, AccRes; // enables ALU output to be updated
logic signed [n-1:0] Accum; // ALU accumulator
logic SelSW, SelImm, SelReg, UseMul;
//
// registers
logic [n-1:0] Rdata; // Register data
logic Raddr; // Register address
logic WriteEn; // register write control
//
// Program Counter 
localparam Psize = 5; // up to 32 instructions
logic PCHold; // program counter control
logic [Psize-1:0] ProgAddress;
// Program Memory
localparam Isize = n+8; // Isize - instruction width
logic [Isize-1:0] I; // I - instruction code

assign nReset = SW[9];

//------------- code starts here ---------
// module instantiations
pc  #(.Psize(Psize)) progCounter (
        .clk (clk),
        .nReset (nReset),
        .PCHold (PCHold),
        .PCout (ProgAddress)
        );

prog #(.Psize(Psize),.Isize(Isize)) progMemory (
        .clk (clk),
        .address (ProgAddress),
        .I (I)
        );

decoder  #(.n(n),.Isize(Isize)) D (
        .I (I),
        .SW8 (SW[8]),
        .imm (imm),
        .PCHold (PCHold),
        .SelSW (SelSW),
        .SelImm (SelImm),
        .SelReg (SelReg),
        .UseMul (UseMul),
        .AccEn( AccEn),
        .AccRes( AccRes),
        .RegEn (WriteEn),
        .RegAddr (Raddr)
        );

regs   #(.n(n)) gpr (
        .clk (clk),
        .w (WriteEn),
        .Wdata (Accum),
        .Raddr (Raddr), // reg %s number
        .Rdata (Rdata)
        );

alu    #(.n(n))  iu (
        .clk (clk),
        .Reset (AccRes),
        .DataA (Accum),
        .DataB (AluB),
        .WriteEn (AccEn),
        .UseMul (UseMul),
        .result (Accum)
        ); // ALU result -> destination reg && AluA

// create MUX for immediate operand
mux3   #(.n(n)) mux3_0 (
        .A (SW[n-1:0]),
        .B (imm),
        .C (Rdata),
        .SelA (SelSW),
        .SelB (SelImm),
        .SelC (SelReg),
        .Out (AluB)
        );


// connect ALU result to LED
assign LED = Accum;

endmodule