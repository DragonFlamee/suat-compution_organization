`include "define.v"

module SUAT_exu( 
     input  wire [`SUAT_DATA]   op1
    ,input  wire [`SUAT_DATA]   op2
    ,input  wire [`SUAT_DATA]   op3       // pc_i
    ,input  wire [`SUAT_DATA]   imm
    ,input  wire [10:0]         alu_op
    ,input  wire                branch
    ,input  wire [2:0]          branch_type
    ,input  wire                jump
    ,input  wire                jalr_ena
    ,output wire                exu_jump
    ,output wire [`SUAT_PC]     exu_jump_pc
    ,output wire [`SUAT_DATA]   exu_res
);

// Integer ALU path for arithmetic/logic instructions.
wire [`SUAT_DATA] alu_res;
SUAT_alu u_SUAT_alu(
     .op1           (op1)
    ,.op2           (op2)
    ,.alu_op        (alu_op)
    ,.alu_res       (alu_res)
);

wire cmp_eq;
wire cmp_ltu;
wire cmp_lt;
assign cmp_eq  = (op1 == op2);
assign cmp_ltu = (op1 < op2);
assign cmp_lt  = ($signed(op1) < $signed(op2));

reg branch_taken;
always @(*) begin
    case (branch_type)
        3'b000: branch_taken = cmp_eq;     // beq
        3'b001: branch_taken = ~cmp_eq;    // bne
        3'b100: branch_taken = cmp_lt;     // blt
        3'b101: branch_taken = ~cmp_lt;    // bge
        3'b110: branch_taken = cmp_ltu;    // bltu
        3'b111: branch_taken = ~cmp_ltu;   // bgeu
        default: branch_taken = 1'b0;
    endcase
end

assign exu_jump = jump | (branch & branch_taken);

wire [`SUAT_PC] jal_pc;
wire [`SUAT_PC] jalr_pc;
wire [`SUAT_PC] br_pc;
assign jal_pc  = op3 + imm;
assign jalr_pc = (op1 + imm) & 32'hffff_fffe;
assign br_pc   = op3 + imm;

assign exu_jump_pc = jump ? (jalr_ena ? jalr_pc : jal_pc) : br_pc;

// jal/jalr write back pc+4; others write ALU result.
assign exu_res = jump ? (op3 + `SUAT_PLUS4) : alu_res;


endmodule
