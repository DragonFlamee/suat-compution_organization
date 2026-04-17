`include "define.v"

module SUAT_lsu(
     input   wire    [31:0]  addr_i
    ,input   wire    [31:0]  wdata_i
    ,input   wire    [31:0]  rdata_i
    ,input   wire    [3:0]   lsu_op
    ,output  wire    [3:0]   WREN
    ,output  wire    [15:0]  addr_o
    ,output  wire    [31:0]  wdata_o
    ,output  wire    [31:0]  rdata_o
);

    
    //lb
    wire [31:0] r_byte_data = (rdata_i & (32'hff << (addr_i[1:0] << 3))) >> (addr_i[1:0] << 3);
    wire [31:0] rdata_lb = {{24{r_byte_data[7]}},r_byte_data[7:0]};
    //sb 
    wire [31:0] wdata_sb = ({24'b0, wdata_i[7:0]} << (addr_i[1:0] << 3));
    //lw 
    wire [31:0] rdata_lw = rdata_i;
    //sw
    wire [31:0] wdata_sw = wdata_i;
    
    //output
    assign WREN = (4'b1111 & {4{lsu_op[0]}}) |
                  ((4'b0001 << addr_i[1:0]) & {4{lsu_op[2]}}) |
                  4'b0000;

    assign rdata_o = (rdata_lw &  {32{lsu_op[1]}}) |
                     (rdata_lb &  {32{lsu_op[3]}}) ;
    assign wdata_o = (wdata_sw &  {32{lsu_op[0]}}) |
                     (wdata_sb &  {32{lsu_op[2]}}) ;

    assign addr_o = addr_i[15:0];

endmodule
