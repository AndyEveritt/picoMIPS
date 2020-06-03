//-----------------------------------------------------
// File Name : regstest.sv
// Function : testbench for pMIPS 32 x n registers, %0 == 0
// Version 1 : code template for Cyclone  MLAB 
//             and true dual port sync RAM
// Author: Andy Everitt
// Last rev. 12 Mar 19
//-----------------------------------------------------
module regstest;

parameter n = 8;

logic clk, w;
logic [n-1:0] Wdata;
logic Raddr;
logic [n-1:0] Rdata;

regs  #(.n(n)) r(.*);

initial
begin
  clk =  0;
end

always
  #5 clk = ~clk;

initial
begin
  w = 1;
  Raddr = 1;
  Wdata = 13;

  #100 Raddr = 0;
  Wdata = -120;

  #100 w = 0;
  Wdata = 0;
  #100 Raddr = 1; 
end

	

endmodule // module regstest