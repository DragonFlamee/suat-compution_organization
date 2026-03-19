module SUAT_alu( 
    input  wire [`SUAT_DATA] src1,
    input  wire [`SUAT_DATA] src2,
    input  wire [9:0]        alu_op,
    output wire [`SUAT_DATA] alu_res
);

// Please complete the code
wire [`SUAT_DATA] res_add,res_and,res_or,res_slt,res_xor,res_shift;
wire lt;
alu_add adder1(src1,src2,alu_op[5],alu_op[4],res_add,lt);

alu_and and1(src1,src2,res_and);

alu_or or1(src1,src2,res_or);

alu_xor xor1(src1,src2,res_xor);

alu_slt slt1(lt,res_slt);

alu_shifter shift1 (src1,src2[4:0],alu_op[1:0],res_shift);

reg [`SUAT_DATA] alu_res_reg;
always @(*) begin
    alu_res_reg = 32'b0;
    if (alu_op[2])      alu_res_reg = res_shift;
    else if (alu_op[3]) alu_res_reg = res_add;
    else if (alu_op[6]) alu_res_reg = res_and;
    else if (alu_op[7]) alu_res_reg = res_or;
    else if (alu_op[8]) alu_res_reg = res_xor;
    else if (alu_op[9]) alu_res_reg = res_slt;
    else                alu_res_reg = 32'b0;
end
assign alu_res = alu_res_reg;

endmodule
