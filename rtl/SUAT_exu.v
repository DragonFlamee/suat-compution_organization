`include "define.v"

module SUAT_exu(
    input wire          clk,
    input wire          rst,
    input wire [`SUAT_DATA] op1,
    input wire [`SUAT_DATA] op2,
    input wire [`SUAT_IMM] imm,
    input wire [`SUAT_PC] pc_i,
    input wire            jump_i,
    input wire [ 7:0]     alu_sel,
    input wire            branch_i,
    
    output wire [`SUAT_REG] store_data,//
    output wire [`SUAT_PC] jump_pc_o//
);

// 32-bit operations
wire [`SUAT_DATA] op1_add_op2 = op1 + op2;

wire [`SUAT_DATA] op1_sub_op2 = $signed(op1) - $signed(op2);

// SLT / SLTI / SLTIU
wire op1_lt_op2 = (op1[31] && ~op2[31]) || (~op1[31] && ~op2[31] && op1_sub_op2[31]) || (op1[31] && op2[31] && op1_sub_op2[31]);

// SRA / SRAI
wire [`SUAT_DATA] op1_sra_op2 = $signed(op1) >>> op2[4:0];  // 32-bit shift uses [4:0]

// MUL / MULH
wire [63:0] mul = $signed(op1) * $signed(op2);  // 32x32=64 multiplication
wire [`SUAT_DATA] op1_mul_op2 = mul[31:0];  // 32-bit result
wire [`SUAT_DATA] op1_mulh_op2 = mul[63:32];  // 32-bit upper half

// DIV / DIVU
wire [`SUAT_DATA] div = $signed(op1) / $signed(op2);

// REM / REMU
wire [`SUAT_DATA] rem = $signed(op1) % $signed(op2);

reg [`SUAT_DATA] alu_res;

always@(*) begin
  if(rst == `SUAT_RSTABLE) begin
    // alu_res = `SUAT_ZERO;
  end
  else begin
    case(alu_sel)
      `INST_ADDI, `INST_ADD,
      `INST_LUI, `INST_AUIPC: begin alu_res = op1_add_op2; end

      `INST_LB, `INST_LH,
      `INST_LW, `INST_LBU,
      `INST_LHU, `INST_SB,
      `INST_SH, `INST_SW: begin alu_res = op1 + imm; end

      `INST_SUB: begin alu_res = op1_sub_op2; end

      `INST_SLTI, `INST_SLT: begin alu_res = {31'd0, op1_lt_op2}; end
      `INST_SLTIU, `INST_SLTU: begin alu_res = {31'd0, (op1 < op2)}; end
      `INST_SRAI, `INST_SRA: begin alu_res = op1_sra_op2; end
      `INST_XORI, `INST_XOR: begin alu_res = op1 ^ op2; end
      `INST_ORI, `INST_OR: begin alu_res = op1 | op2; end
      `INST_ANDI, `INST_AND: begin alu_res = op1 & op2; end
      `INST_SLLI, `INST_SLL: begin alu_res = op1 << op2[4:0]; end  // 32-bit shift uses [4:0]
      `INST_SRLI, `INST_SRL: begin alu_res = op1 >> op2[4:0]; end  // 32-bit shift uses [4:0]
      `INST_JAL, `INST_JALR: begin alu_res = pc_i + 32'd4; end
      `INST_EBREAK: begin alu_res = op1; end


      default: begin
        alu_res = `SUAT_ZERO32;
      end
    endcase
  end
end

reg ex_branch;

always @(*) begin
  if(~branch_i) begin
    ex_branch = `SUAT_BRANCHDISABLE;
  end
  else begin
    case (alu_sel)
      `INST_BEQ: begin ex_branch = (op1 == op2) ? `SUAT_BRANCHABLE : `SUAT_BRANCHDISABLE; end
      `INST_BNE: begin ex_branch = (op1 != op2) ? `SUAT_BRANCHABLE : `SUAT_BRANCHDISABLE; end
      `INST_BLTU: begin ex_branch = (op1 < op2) ? `SUAT_BRANCHABLE : `SUAT_BRANCHDISABLE; end
      `INST_BGEU: begin ex_branch = (op1 >= op2) ? `SUAT_BRANCHABLE : `SUAT_BRANCHDISABLE; end
      `INST_BLT: begin ex_branch = (op1_lt_op2) ? `SUAT_BRANCHABLE : `SUAT_BRANCHDISABLE; end
      `INST_BGE: begin ex_branch = (~op1_lt_op2) ? `SUAT_BRANCHABLE : `SUAT_BRANCHDISABLE; end
      default: begin ex_branch = `SUAT_BRANCHDISABLE; end
    endcase
  end
end

// Out to IFU
assign ex_pcsrc_o = jump_i | ex_branch;
assign jump_pc_o = (alu_sel == `INST_JAL | branch_i) ? pc_i + imm :
                   (alu_sel == `INST_JALR) ? (op1 + imm) & ~32'd1 :  // JALR clears least significant bit
                   `SUAT_ZERO32;

// Out to LSU
assign store_data = op2;


endmodule


