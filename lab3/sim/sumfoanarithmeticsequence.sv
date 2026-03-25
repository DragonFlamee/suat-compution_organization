`timescale 1ns/1ps

module sumfoanarithmeticsequence;

localparam [6:0] OPCODE_JAL    = 7'b1101111;
localparam [6:0] OPCODE_BRANCH = 7'b1100011;
localparam [6:0] OPCODE_OPIMM  = 7'b0010011;
localparam [6:0] OPCODE_OP     = 7'b0110011;


localparam integer shouxiang = 1;
localparam integer gongcha   = 1;
localparam integer xiangshu  = 100;
localparam integer EXPECTED_SUM = (xiangshu * (2 * shouxiang + (xiangshu - 1) * gongcha)) / 2;

reg clk;
reg rst;
wire [31:0] tb_if_pc;
reg  [31:0] tb_if_inst;

wire tb_ex_jump;
wire [31:0] tb_ex_jump_pc;
wire [31:0] tb_ex_res;

reg [31:0] imem [0:255];

integer i;
integer cycles;
reg done;

localparam signed [12:0] B_OFF_20  = 13'sd20;
localparam signed [20:0] J_OFF_M16 = -21'sd16;
localparam signed [20:0] J_OFF_0   = 21'sd0;

SUAT_top dut (
     .clk          (clk)
    ,.rst          (rst)
    ,.tb_if_inst   (tb_if_inst)
    ,.tb_if_pc     (tb_if_pc)
    ,.tb_ex_jump   (tb_ex_jump)
    ,.tb_ex_jump_pc(tb_ex_jump_pc)
    ,.tb_ex_res    (tb_ex_res)
);

always @(*) begin
    if (^tb_if_pc === 1'bx) tb_if_inst = 32'h00000013;
    else tb_if_inst = imem[tb_if_pc[9:2]];
end

initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
end

initial begin

    for (i = 0; i < 256; i = i + 1) begin
        imem[i] = 32'h00000013; // nop
    end

    // x27=a, x28=d, x29=n, x30=sum, x31=i, x6=final_sum
    // 0x00: addi x27, x0, shouxiang
    // 0x04: addi x28, x0, gongcha
    // 0x08: addi x29, x0, xiangshu
    // 0x0c: addi x30, x0, 0
    // 0x10: addi x31, x0, 0
    // loop:
    // 0x14: beq  x31, x29, end
    // 0x18: add  x30, x30, x27
    // 0x1c: add  x27, x27, x28
    // 0x20: addi x31, x31, 1
    // 0x24: jal  x0, loop
    // end:
    // 0x28: addi x6, x30, 0
    // 0x2c: jal  x0, 0
    imem[0]  = {shouxiang[11:0], 5'd0, 3'b000, 5'd27, OPCODE_OPIMM};
    imem[1]  = {gongcha[11:0],   5'd0, 3'b000, 5'd28, OPCODE_OPIMM};
    imem[2]  = {xiangshu[11:0],  5'd0, 3'b000, 5'd29, OPCODE_OPIMM};
    imem[3]  = {12'd0, 5'd0, 3'b000, 5'd30, OPCODE_OPIMM};
    imem[4]  = {12'd0, 5'd0, 3'b000, 5'd31, OPCODE_OPIMM};
    imem[5]  = {B_OFF_20[12], B_OFF_20[10:5], 5'd29, 5'd31, 3'b000, B_OFF_20[4:1], B_OFF_20[11], OPCODE_BRANCH};
    imem[6]  = {7'b0000000, 5'd27, 5'd30, 3'b000, 5'd30, OPCODE_OP};
    imem[7]  = {7'b0000000, 5'd28, 5'd27, 3'b000, 5'd27, OPCODE_OP};
    imem[8]  = {12'd1, 5'd31, 3'b000, 5'd31, OPCODE_OPIMM};
    imem[9]  = {J_OFF_M16[20], J_OFF_M16[10:1], J_OFF_M16[11], J_OFF_M16[19:12], 5'd0, OPCODE_JAL};
    imem[10] = {12'd0, 5'd30, 3'b000, 5'd6, OPCODE_OPIMM};
    imem[11] = {J_OFF_0[20], J_OFF_0[10:1], J_OFF_0[11], J_OFF_0[19:12], 5'd0, OPCODE_JAL};

    rst = 1'b1;
    tb_if_inst = 32'h00000013;
    done = 1'b0;

    #20;
    rst = 1'b0;

    for (cycles = 0; cycles < 1200; cycles = cycles + 1) begin
        @(posedge clk);
        #1;

        if (tb_if_pc == (`SUAT_STARTPC + 32'd44)) begin
            repeat (2) begin
                @(posedge clk);
                #1;
            end

            if (dut.reg5.regs[6] !== EXPECTED_SUM[31:0]) begin
                $fatal(1, "sum failed: expected=%0d got=%0d", EXPECTED_SUM, dut.reg5.regs[6]);
            end

            $display("[PASS] arithmetic-sequence benchmark passed.");
            $display("[CFG ] a1=%0d d=%0d n=%0d expected=%0d", shouxiang, gongcha, xiangshu, EXPECTED_SUM);
            $display("[REG ] x27(a)=%0d x28(d)=%0d x29(n)=%0d x30(sum_work)=%0d x31(i)=%0d x6(sum)=%0d",
                dut.reg5.regs[27], dut.reg5.regs[28], dut.reg5.regs[29], dut.reg5.regs[30], dut.reg5.regs[31], dut.reg5.regs[6]);

            done = 1'b1;
            $finish;
        end
    end

    if (!done) begin
        $fatal(1, "timeout: program did not finish");
    end
end

endmodule
