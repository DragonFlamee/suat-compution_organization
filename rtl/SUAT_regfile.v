`include "define.v"

module SUAT_regfile (
    input    wire             					 clk   ,
    input    wire             					 rst   ,

    input    wire   [`SUAT_REGADDR]     waddr ,
    input    wire   [`SUAT_REG]    	 wdata ,
    input    wire             				     wen   ,
   
	input    wire   [`SUAT_REGADDR]	 raddr1,
	output	 wire   [`SUAT_REG]	  	 rdata1,
	input	 wire             					 ren1  ,

	input    wire   [`SUAT_REGADDR]	 raddr2,
	output	 wire   [`SUAT_REG]	  	 rdata2,
	input	 wire             					 ren2  ,

	//to dpi-c for difftest
	output  wire	[`SUAT_REG]		 regs0 ,
	output  wire	[`SUAT_REG]		 regs1 ,
	output  wire	[`SUAT_REG]		 regs2 ,
	output  wire	[`SUAT_REG]		 regs3 ,
	output  wire	[`SUAT_REG]		 regs4 ,
	output  wire	[`SUAT_REG]		 regs5 ,
	output  wire	[`SUAT_REG]		 regs6 ,
	output  wire	[`SUAT_REG]		 regs7 ,
	output  wire	[`SUAT_REG]		 regs8 ,
	output  wire	[`SUAT_REG]		 regs9 ,
	output  wire	[`SUAT_REG]		 regs10,
	output  wire	[`SUAT_REG]		 regs11,
	output  wire	[`SUAT_REG]		 regs12,
	output  wire	[`SUAT_REG]		 regs13,
	output  wire	[`SUAT_REG]		 regs14,
	output  wire	[`SUAT_REG]		 regs15,
	output  wire	[`SUAT_REG]		 regs16,
	output  wire	[`SUAT_REG]		 regs17,
	output  wire	[`SUAT_REG]		 regs18,
	output  wire	[`SUAT_REG]		 regs19,
	output  wire	[`SUAT_REG]		 regs20,
	output  wire	[`SUAT_REG]		 regs21,
	output  wire	[`SUAT_REG]		 regs22,
	output  wire	[`SUAT_REG]		 regs23,
	output  wire	[`SUAT_REG]		 regs24,
	output  wire	[`SUAT_REG]		 regs25,
	output  wire	[`SUAT_REG]		 regs26,
	output  wire	[`SUAT_REG]		 regs27,
	output  wire	[`SUAT_REG]		 regs28,
	output  wire	[`SUAT_REG]		 regs29,
	output  wire	[`SUAT_REG]		 regs30,
	output  wire	[`SUAT_REG]		 regs31
);
 
    reg [`SUAT_REG] regs [0:31];

 

 
 always@(posedge clk) begin
	 if(rst == `SUAT_RSTABLE) begin
		regs[0] <= `SUAT_ZERO32; 
 		regs[1] <= `SUAT_ZERO32; 
 		regs[2] <= `SUAT_ZERO32; 
 		regs[3] <= `SUAT_ZERO32; 
 		regs[4] <= `SUAT_ZERO32; 
 		regs[5] <= `SUAT_ZERO32; 
 		regs[6] <= `SUAT_ZERO32; 
 		regs[7] <= `SUAT_ZERO32; 
 		regs[8] <= `SUAT_ZERO32; 
 		regs[9] <= `SUAT_ZERO32; 
 		regs[10] <= `SUAT_ZERO32; 
 		regs[11] <= `SUAT_ZERO32; 
 		regs[12] <= `SUAT_ZERO32; 
 		regs[13] <= `SUAT_ZERO32; 
 		regs[14] <= `SUAT_ZERO32; 
 		regs[15] <= `SUAT_ZERO32; 
 		regs[16] <= `SUAT_ZERO32; 
 		regs[17] <= `SUAT_ZERO32; 
 		regs[18] <= `SUAT_ZERO32; 
 		regs[19] <= `SUAT_ZERO32; 
 		regs[20] <= `SUAT_ZERO32; 
 		regs[21] <= `SUAT_ZERO32; 
 		regs[22] <= `SUAT_ZERO32; 
 		regs[23] <= `SUAT_ZERO32; 
 		regs[24] <= `SUAT_ZERO32; 
 		regs[25] <= `SUAT_ZERO32; 
 		regs[26] <= `SUAT_ZERO32; 
 		regs[27] <= `SUAT_ZERO32; 
 		regs[28] <= `SUAT_ZERO32; 
 		regs[29] <= `SUAT_ZERO32; 
 		regs[30] <= `SUAT_ZERO32; 
 		regs[31] <= `SUAT_ZERO32;
	 end
   else begin
		 if(wen == `SUAT_WENABLE && waddr != 5'd0)begin
			 regs[waddr]<=wdata;
		 end
	 end
 end

 assign rdata1 = ((rst != `SUAT_RSTABLE) && (ren1 == `SUAT_RENABLE)) ? regs[raddr1] : `SUAT_ZERO32;
 assign rdata2 = ((rst != `SUAT_RSTABLE) && (ren2 == `SUAT_RENABLE)) ? regs[raddr2] : `SUAT_ZERO32;

assign regs0  = regs[0] ;
assign regs1  = regs[1] ;
assign regs2  = regs[2] ;
assign regs3  = regs[3] ;
assign regs4  = regs[4] ;
assign regs5  = regs[5] ;
assign regs6  = regs[6] ;
assign regs7  = regs[7] ;
assign regs8  = regs[8] ;
assign regs9  = regs[9] ;
assign regs10 = regs[10];
assign regs11 = regs[11];
assign regs12 = regs[12];
assign regs13 = regs[13];
assign regs14 = regs[14];
assign regs15 = regs[15];
assign regs16 = regs[16];
assign regs17 = regs[17];
assign regs18 = regs[18];
assign regs19 = regs[19];
assign regs20 = regs[20];
assign regs21 = regs[21];
assign regs22 = regs[22];
assign regs23 = regs[23];
assign regs24 = regs[24];
assign regs25 = regs[25];
assign regs26 = regs[26];
assign regs27 = regs[27];
assign regs28 = regs[28];
assign regs29 = regs[29];
assign regs30 = regs[30];
assign regs31 = regs[31];

 endmodule


