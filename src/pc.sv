//-----------------------------------------------------
// File Name : pc.sv
// Function : picoMIPS Program Counter
// functions: increment, absolute and relative branches
// Author: Andy Everitt
// Last rev. 12 Mar 19
//-----------------------------------------------------
module pc #(parameter Psize = 5) // up to 32 instructions
(input logic clk, nReset, PCHold,
 output logic [Psize-1 : 0]PCout
);

logic [Psize-1:0] PCtmp, tmp;

always_comb
begin
   // increment if not holding
   {PCtmp, tmp} = {PCout, {(Psize-1){1'b0}}, 1'b1} * {{(Psize-1){1'b0}}, ~PCHold, {(Psize-1){1'b0}}, 1'b1};
end

//------------- code starts here---------
always_ff @ ( posedge clk or negedge nReset) // async reset
  if (~nReset) // sync reset
     PCout <= {Psize{1'b0}};
  else 
     PCout <= PCtmp;
  	 
endmodule // module pc