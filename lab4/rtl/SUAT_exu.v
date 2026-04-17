`include "define.v"

module SUAT_exu( 
     input  wire [`SUAT_DATA]   data1
    ,input  wire [`SUAT_DATA]   data2
    ,input  wire [`SUAT_DATA]   data3
    ,input  wire [`SUAT_DATA]   data4
    ,input  wire [17:0]         exu_op
    ,output wire                exu_jump
    ,output wire [`SUAT_PC]     exu_jump_pc
    ,output wire [`SUAT_DATA]   exu_addr
    ,output wire [`SUAT_DATA]   exu_data
);

wire [`SUAT_DATA] alu_res;
wire [3:0]        cmp_res;

SUAT_alu u_SUAT_alu(
    .op1     (data1        ),
    .op2     (data2        ),
    .alu_op  (exu_op[9:0]  ),
    .alu_res (alu_res      ),
    .cmp_res (cmp_res      )
);

wire [`SUAT_DATA] add_res;
wire        lt ;     // less than
wire        equ;     // equal
wire        ne ;     // not equal
wire        ge ;     // greater or equal

alu_add u_alu_add(
    .a           (data3       ),
    .b           (data4       ),
    .is_sub      (1'b0        ),
    .is_unsigned (1'b0        ),
    .out         (add_res     ),
    .lt          (lt          ),
    .equ         (equ         ),
    .ne          (ne          ),
    .ge          (ge          )
);

wire do_jump;
wire do_branch;
wire branch_taken;

assign do_jump   = exu_op[17];
assign do_branch = exu_op[16];

assign branch_taken =
    (exu_op[10] & cmp_res[1]) |
    (exu_op[11] & cmp_res[2]) |
    (exu_op[12] & cmp_res[0]) |
    (exu_op[13] & cmp_res[3]) |
    (exu_op[14] & cmp_res[0]) |
    (exu_op[15] & cmp_res[3]);

assign exu_jump    = do_jump | (do_branch & branch_taken);
assign exu_jump_pc = {add_res[31:1], 1'b0};
assign exu_data    = data3;

assign exu_addr    = alu_res;

endmodule
