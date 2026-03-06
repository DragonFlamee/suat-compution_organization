module alu_srl(
    input  wire [31:0] a,
    input  wire [4:0]  shamt,
    output wire [31:0] out
);
    wire [31:0] stage1, stage2, stage3, stage4, stage5;
    assign stage1 = shamt[0] ? {1'b0,a[31:1]} : a;
    assign stage2 = shamt[1] ? {2'b00,stage1[31:2]} : stage1;
    assign stage3 = shamt[2] ? {4'b0000,stage2[31:4]} : stage2;
    assign stage4 = shamt[3] ? {8'b00000000,stage3[31:8]} : stage3;
    assign stage5 = shamt[4] ? {16'b0000000000000000,stage4[31:16]} : stage4;
    assign out = stage5;
endmodule
