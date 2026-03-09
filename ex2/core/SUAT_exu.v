`include "define.v"
`include "alu_adder.v"
`include "alu_sub.v"
`include "alu_and.v"
`include "alu_or.v"
`include "alu_xor.v"
`include "alu_sll.v"
`include "alu_srl.v"
`include "alu_sra.v"
`include "alu_slt.v"

module SUAT_exu( 
    input  wire [`SUAT_DATA] op1,
    input  wire [`SUAT_DATA] op2,
    input  wire [`SUAT_IMM]  imm,
    input  wire [`SUAT_PC]   pc_i,
    input  wire [7:0]        alu_sel,
    input  wire              branch_i,
    input  wire              jump_i,

    output wire [`SUAT_REG]  store_data,
    output wire [`SUAT_PC]   jump_pc_o,
    output wire [`SUAT_DATA] alu_res
);

    wire [31:0] add_res, sub_res, and_res, or_res, xor_res;
    wire [31:0] sll_res, srl_res, sra_res;
    wire        lt_signed, lt_unsigned;

    alu_adder u_add(.a(op1), .b(op2), .sum(add_res));
    alu_sub   u_sub(.a(op1), .b(op2), .diff(sub_res));
    alu_and   u_and(.a(op1), .b(op2), .out(and_res));
    alu_or    u_or (.a(op1), .b(op2), .out(or_res));
    alu_xor   u_xor(.a(op1), .b(op2), .out(xor_res));
    alu_sll   u_sll(.a(op1), .shamt(op2[4:0]), .out(sll_res));
    alu_srl   u_srl(.a(op1), .shamt(op2[4:0]), .out(srl_res));
    alu_sra   u_sra(.a(op1), .shamt(op2[4:0]), .out(sra_res));
    alu_slt   u_slt(.a(op1), .b(op2), .lt(lt_signed));
    assign lt_unsigned = (op1 < op2);

    reg [31:0] alu_res_r;
    always @(*) begin
        case(alu_sel)
            `INST_ADD, `INST_ADDI, `INST_LUI, `INST_AUIPC: alu_res_r = add_res;
            `INST_SUB:  alu_res_r = sub_res;
            `INST_AND, `INST_ANDI: alu_res_r = and_res;
            `INST_OR,  `INST_ORI:  alu_res_r = or_res;
            `INST_XOR, `INST_XORI: alu_res_r = xor_res;
            `INST_SLL, `INST_SLLI: alu_res_r = sll_res;
            `INST_SRL, `INST_SRLI: alu_res_r = srl_res;
            `INST_SRA, `INST_SRAI: alu_res_r = sra_res;
            `INST_SLTI, `INST_SLT: alu_res_r = {31'd0, lt_signed};
            `INST_SLTIU, `INST_SLTU: alu_res_r = {31'd0, lt_unsigned};
            `INST_JAL, `INST_JALR: alu_res_r = pc_i + 32'd4;
            default: alu_res_r = 32'b0;
        endcase
    end

    assign alu_res = alu_res_r;
    assign store_data = op2;
    assign jump_pc_o  = (alu_sel == `INST_JAL) ? pc_i + imm :
                         (alu_sel == `INST_JALR) ? (op1 + imm) & ~32'd1 :
                         32'b0;

endmodule
