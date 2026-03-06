module alu_sra(
    input  wire [31:0] a,
    input  wire [4:0]  shamt,
    output wire [31:0] out
);
    wire [31:0] stage1, stage2, stage3, stage4, stage5, filled1, filled2, filled3, filled4;
    assign filled1 = shamt[0] ? {a[31],a[31:1]} : a;
    assign filled2 = shamt[1] ? {{2{filled1[31]}},filled1[31:2]} : filled1;
    assign filled3 = shamt[2] ? {{4{filled2[31]}},filled2[31:4]} : filled2;
    assign filled4 = shamt[3] ? {{8{filled3[31]}},filled3[31:8]} : filled3;
    assign stage5 = shamt[4] ? {{16{filled4[31]}},filled4[31:16]} : filled4;
    assign out = stage5;
endmodule