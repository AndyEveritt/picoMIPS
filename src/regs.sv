//-----------------------------------------------------
// File Name : regs.sv
// Function : picoMIPS 32 x n registers
// Version 1
// Author: Andy Everitt
//-----------------------------------------------------
module regs #(parameter n = 8)	// n - data bus width
	(input logic clk, w,		// clk and write control
	input logic [n-1:0] Wdata,	// write data
	input logic Raddr,			// read address
	output logic [n-1:0] Rdata	// read data
	);

 	// Declare 2 n-bit registers 
	logic [n-1:0] gpr [1:0];

	// initialise registers
	initial
    for (int i = 0; i < 2; ++i)
        gpr[i] = 0;

	always @ (posedge clk)
	begin
		// write process
		if (w)
            gpr[Raddr] <= Wdata;
		// read process
		Rdata <= gpr[Raddr];
	end	

endmodule