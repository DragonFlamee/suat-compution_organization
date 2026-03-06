module alu_sll(
    input  wire [31:0] a,
    input  wire [4:0]  shamt,
    output wire [31:0] out
);
    wire [31:0] stage1, stage2, stage3, stage4, stage5;
    
    assign stage1 = shamt[0] ? {a[30:0], 1'b0} : a;
    assign stage2 = shamt[1] ? {stage1[29:0], 2'b00} : stage1;
    assign stage3 = shamt[2] ? {stage2[27:0], 4'b0000} : stage2;
    assign stage4 = shamt[3] ? {stage3[23:0], 8'b00000000} : stage3;
    assign stage5 = shamt[4] ? {stage4[15:0],16'b0} : stage4;
    assign out = stage5;
endmodule