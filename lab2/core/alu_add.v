module alu_add(
    input  wire [31:0] a,      // 输入a
    input  wire [31:0] b,      // 输入b
    input  wire        is_sub, // 是否做减法
    input  wire        is_unsigned, // 是否为无符号数
    output wire [31:0] out,    // 输出结果
    output wire        lt      // less than
);

// Please complete the code
wire [32:0] b_mux;
wire [32:0] result;
wire        cout;

assign b_mux = is_sub ? {1'b0, ~b} : {1'b0, b};
assign result = {1'b0, a} + b_mux + {32'b0, is_sub};
assign cout   = result[32];
assign out    = result[31:0];

wire overflow;
assign overflow = (~a[31] & ~b_mux[31] &  out[31])
                | ( a[31] &  b_mux[31] & ~out[31]);

assign lt = is_unsigned ? ~cout : (out[31] ^ overflow);

endmodule
