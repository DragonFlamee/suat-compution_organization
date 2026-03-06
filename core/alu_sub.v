module alu_sub(
    input  wire [31:0] a,
    input  wire [31:0] b,
    output wire [31:0] diff
);
    assign diff = a - b;
endmodule