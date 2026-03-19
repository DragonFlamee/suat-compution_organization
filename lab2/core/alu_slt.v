module alu_slt(
    input  wire          lt,
    output wire  [31:0]  out
);

// Please complete the code
assign out = lt ? 32'b1:32'b0;

endmodule
