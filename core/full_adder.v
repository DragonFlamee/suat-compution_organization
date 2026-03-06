module full_adder(
    input wire a,      // 输入位a
    input wire b,      // 输入位b
    input wire cin,    // 进位输入
    output wire sum,   // 和输出
    output wire cout   // 进位输出
);
    assign sum  = a ^ b ^ cin;  // 和是 a、b、cin 的异或
    assign cout = (a & b) | (cin & (a ^ b)); // 进位是 a 和 b 或者 cin 和 (a xor b) 的与
endmodule
    