module alu_slt(
    input  wire [31:0] a,      
    input  wire [31:0] b,      
    output wire       lt       
);

    wire sign_a, sign_b;       
    wire signed_lt;            
    wire unsigned_lt;          

    // 符号位比较，判断 a 和 b 是否有不同的符号
    assign sign_a = a[31];
    assign sign_b = b[31];

    // 负数小于正数的情况
    assign signed_lt = (sign_a && ~sign_b) || (~(sign_a ^ sign_b) && (a < b));

    // 无符号比较（可以通过简单的比较运算符）
    assign unsigned_lt = (a < b);

    // 最终的 lt 输出
    assign lt = signed_lt;

endmodule