//-----------------------------------------------------
// File Name   : alu.sv
// Function    : Set of ALU modules
// Author: Andy Everitt

`ifndef ALU_OPS
`define ALU_OPS

// Out = A * B
module mult #(parameter n = 8) (
    input signed [n-1:0] A,
    input signed [n-1:0] B,
    output signed [2*n-1:0] Out
    );

    assign Out = A * B;

endmodule

// Out = A + B
module adder #(parameter n = 8) (
    input signed [n-1:0] A,
    input signed [n-1:0] B,
    output logic [n-1:0] Out
    );

    logic [2*n-1:0] addOut, tmp;

    //---------------------------------------------------
    // Uses adder
    // assign addOut = ({A, B}) * ({7'b0, 1'b1, 7'b0, 1'b1});
    //---------------------------------------------------

    //---------------------------------------------------
    // Uses multiplier
    mult #(2*n) mul0(
        .A     ({A, B}),
        .B     ({7'b0, 1'b1, 7'b0, 1'b1}),
        .Out   ({tmp, addOut})
    );
    //---------------------------------------------------

    assign Out = addOut[2*n-1:n];
endmodule


// 2's complement multiplier
module mult2s #(parameter n = 8) (
    input signed [n-1:0] A,
    input signed [n-1:0] B,
    output signed [n-1:0] Out
    );

    logic [2*n-1:0] TmpA, TmpB;
    logic [4*n-1:0] mulOut;

    assign TmpA = {{(n){A[n-1]}}, A};
    assign TmpB = {{(n){B[n-1]}}, B};

    assign mulOut = TmpA * TmpB;

    assign Out = mulOut[2*n-2:n-1];
endmodule

// 2 input multiplexer
// EnA | EnB | Out
//  1  |  0  |  A
//  0  |  1  |  B
module mux2 #(parameter n = 8) (
    input signed [n-1:0] A,
    input signed [n-1:0] B,
    input select,
    output logic [n-1:0] Out
    );

    logic [2*n-1:0] addOut;

    assign addOut = ({A, B}) * ({7'b0, select, 7'b0, ~select});

    assign Out = addOut[2*n-1:n];
endmodule

// 3 input multiplexer
// SelA | SelB | SelC | Out
//  1   |  0   |  0   |  A
//  0   |  1   |  0   |  B
//  X   |  X   |  1   |  C
//  1   |  1   |  0   |  A+B
module mux3 #(parameter n = 8) (
    input signed [n-1:0] A,
    input signed [n-1:0] B,
    input signed [n-1:0] C,
    input SelA, SelB, SelC,
    output logic [n-1:0] Out
    );

    logic [2*n-1:0] mul0Out, mul1Out;

    assign mul0Out = ({A               , B}) * ({7'b0, SelB, 7'b0,  SelA});
    assign mul1Out = ({mul0Out[2*n-1:n], C}) * ({7'b0, SelC, 7'b0, ~SelC});

    assign Out = mul1Out[2*n-1:n];
endmodule

`endif
