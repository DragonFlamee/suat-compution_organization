`include "define.v"



module SUAT_top(
	input wire              clk		,
	input wire              rst		
		
);

//ifu
 wire [`SUAT_INST]  	if_id_inst 	   ;
 wire [`SUAT_INST]		DPIC_if_inst	;

 wire [`SUAT_PC]    	if_id_pc    	   ;

//idu

wire [`SUAT_REGADDR] id_reg_rs1_addr ;
wire [`SUAT_REGADDR] id_reg_rs2_addr ;
wire [`SUAT_REGADDR] id_reg_rd_addr ;
wire                          id_reg_rs1_ena	;
wire                          id_reg_rs2_ena	;
wire                          id_reg_rd_ena	;

wire [`SUAT_IMM]     	id_ex_imm	;
wire            		id_ex_branch   ;
wire            		id_ex_jump     ;
wire [3:0]      		id_ls_ctl  	   ;
wire [1:0]      		id_wb_ctl    	   ;
wire [7:0]			id_ex_alu_sel;
wire [`SUAT_PC]    	id_ex_pc    	   ;
wire [`SUAT_DATA] 	id_ex_op1 ;
wire [`SUAT_DATA] 	id_ex_op2 ;
wire [3:0]                      id_ex_csrctl;
wire                            magic_flag;


//exu
wire  [`SUAT_REG]           ex_aludata    ;
wire [`SUAT_DATA] 	     ex_ls_store_data  ;
wire  [`SUAT_PC]  	     ex_if_pc 	   ;
wire           			     ex_if_pc_sel  		;
wire [`SUAT_REG]  	ex_dpic_mstatus     ;
wire [`SUAT_REG]  	ex_dpic_mepc        ;
wire [`SUAT_REG]  	ex_dpic_mtvec       ;
wire [`SUAT_REG]  	ex_dpic_mcause      ;


//lsu
wire [`SUAT_DATA]         ls_wb_data        ;

//wbu
wire [`SUAT_DATA]	   wb_reg_rd_data     ;

// regfile
wire [`SUAT_REG] reg_id_rs1_data ;
wire [`SUAT_REG] reg_id_rs2_data ;

//DPI-C
wire [`SUAT_REG]		regs0 ;
wire [`SUAT_REG]		regs1 ;
wire [`SUAT_REG]		regs2 ;
wire [`SUAT_REG]		regs3 ;
wire [`SUAT_REG]		regs4 ;
wire [`SUAT_REG]		regs5 ;
wire [`SUAT_REG]		regs6 ;
wire [`SUAT_REG]		regs7 ;
wire [`SUAT_REG]		regs8 ;
wire [`SUAT_REG]		regs9 ;
wire [`SUAT_REG]		regs10;
wire [`SUAT_REG]		regs11;
wire [`SUAT_REG]		regs12;
wire [`SUAT_REG]		regs13;
wire [`SUAT_REG]		regs14;
wire [`SUAT_REG]		regs15;
wire [`SUAT_REG]		regs16;
wire [`SUAT_REG]		regs17;
wire [`SUAT_REG]		regs18;
wire [`SUAT_REG]		regs19;
wire [`SUAT_REG]		regs20;
wire [`SUAT_REG]		regs21;
wire [`SUAT_REG]		regs22;
wire [`SUAT_REG]		regs23;
wire [`SUAT_REG]		regs24;
wire [`SUAT_REG]		regs25;
wire [`SUAT_REG]		regs26;
wire [`SUAT_REG]		regs27;
wire [`SUAT_REG]		regs28;
wire [`SUAT_REG]		regs29;
wire [`SUAT_REG]		regs30;
wire [`SUAT_REG]		regs31;
wire [`SUAT_REGADDR]	rd;

SUAT_ifu ifu0(
		.clk(clk)	,
		.rst(rst)	,
		.pcsrc_i(ex_if_pc_sel)  ,
 		.ex_pc_i(ex_if_pc)	,
		.inst_i(DPIC_if_inst)	,
 		.inst_o(if_id_inst)	,		
		.pc_o(if_id_pc)
);

SUAT_idu idu1(
	.rst(rst)	,
	.inst_i(if_id_inst)	,
	.pc_i(if_id_pc)	,
 	.pc_o(id_ex_pc)	,
 	
	.rs1_addr(id_reg_rs1_addr)	,
	.rs2_addr(id_reg_rs2_addr)	,
	.rs1_ena(id_reg_rs1_ena)	,
	.rs2_ena(id_reg_rs2_ena)	,
	.rs1_data(reg_id_rs1_data)	,
	.rs2_data(reg_id_rs2_data)	,
	.rd_ena(id_reg_rd_ena)		,
	.rd_addr(id_reg_rd_addr)	,
	
	.alusrc_o(id_ex_alu_sel)	,
	.lsctl_o(id_ls_ctl)			,
 	.wbctl_o(id_wb_ctl)			,
	.jump_o(id_ex_jump)			,
	.branch_o(id_ex_branch)		,
	.imm(id_ex_imm)				,
	.idu_dpic_rd_addr(rd)		,
	.csr_ctl(id_ex_csrctl)		,
	.op1(id_ex_op1)				,
	.op2(id_ex_op2)				,
	.magic_flag(magic_flag)
);

SUAT_exu exu2(
	.clk(clk)	,
	.rst(rst)	,
	.op1(id_ex_op1)	,
	.op2(id_ex_op2)	,
	.pc_i(id_ex_pc)	,
	.imm(id_ex_imm)	,
	.csr_ctl(id_ex_csrctl)	,
	.jump_i(id_ex_jump)	,
	.branch_i(id_ex_branch)	,
	.alu_sel(id_ex_alu_sel)	,
	.exu_res(ex_aludata)	,
	.store_data(ex_ls_store_data) ,
	.jump_pc_o(ex_if_pc)	,
 	.ex_pcsrc_o(ex_if_pc_sel),
	.csr_ex_mstatus(ex_dpic_mstatus),
	.csr_ex_mepc   (ex_dpic_mepc   ),
	.csr_ex_mtvec  (ex_dpic_mtvec  ),
	.csr_ex_mcause (ex_dpic_mcause )		
);

SUAT_lsu lsu3(
 	.rst(rst)		,
 	.clk(clk)	,
 	.alu_res(ex_aludata)	,
 	.store_data(ex_ls_store_data)	,
 	.ls_ctl	(id_ls_ctl) ,
 	.ls_data_o(ls_wb_data)	
 );

SUAT_wbu wbu4(
 	.rst(rst),
 	.ls_rd_data(ls_wb_data)	,
 	.wb_ctl(id_wb_ctl)	,
 	.exu_res(ex_aludata)	,
 	.wb_data(wb_reg_rd_data)	
);

SUAT_regfile reg3(
	.clk(clk)	,
	.rst(rst)	,
	.waddr(id_reg_rd_addr)	,
	.wdata(wb_reg_rd_data)	,
	.raddr1(id_reg_rs1_addr)	,
	.raddr2(id_reg_rs2_addr)	,
	.rdata1(reg_id_rs1_data)	,
	.rdata2(reg_id_rs2_data)	,
	.wen(id_reg_rd_ena)		,
	.ren1(id_reg_rs1_ena)	,
	.ren2(id_reg_rs2_ena)	,
	.regs0 (regs0 ),
	.regs1 (regs1 ),
	.regs2 (regs2 ),
	.regs3 (regs3 ),
	.regs4 (regs4 ),
	.regs5 (regs5 ),
	.regs6 (regs6 ),
	.regs7 (regs7 ),
	.regs8 (regs8 ),
	.regs9 (regs9 ),
	.regs10(regs10),
	.regs11(regs11),
	.regs12(regs12),
	.regs13(regs13),
	.regs14(regs14),
	.regs15(regs15),
	.regs16(regs16),
	.regs17(regs17),
	.regs18(regs18),
	.regs19(regs19),
	.regs20(regs20),
	.regs21(regs21),
	.regs22(regs22),
	.regs23(regs23),
	.regs24(regs24),
	.regs25(regs25),
	.regs26(regs26),
	.regs27(regs27),
	.regs28(regs28),
	.regs29(regs29),
	.regs30(regs30),
	.regs31(regs31)
);

SUAT_DPIC dpic(
	.clk	(clk)	,
	.rst	(rst)	,
	.pc_i   (if_id_pc),
	.inst_o	(DPIC_if_inst),
	.rd_addr(rd),
	.imm	(id_ex_imm),
	.regs0  (regs0 ),
	.regs1  (regs1 ),
	.regs2  (regs2 ),
	.regs3  (regs3 ),
	.regs4  (regs4 ),
	.regs5  (regs5 ),
	.regs6  (regs6 ),
	.regs7  (regs7 ),
	.regs8  (regs8 ),
	.regs9  (regs9 ),
	.regs10 (regs10),
	.regs11 (regs11),
	.regs12 (regs12),
	.regs13 (regs13),
	.regs14 (regs14),
	.regs15 (regs15),
	.regs16 (regs16),
	.regs17 (regs17),
	.regs18 (regs18),
	.regs19 (regs19),
	.regs20 (regs20),
	.regs21 (regs21),
	.regs22 (regs22),
	.regs23 (regs23),
	.regs24 (regs24),
	.regs25 (regs25),
	.regs26 (regs26),
	.regs27 (regs27),
	.regs28 (regs28),
	.regs29 (regs29),
	.regs30 (regs30),
	.regs31 (regs31),
	.mstatus(ex_dpic_mstatus),
	.mtvec  (ex_dpic_mepc   ),
	.mepc   (ex_dpic_mtvec  ),
	.mcause (ex_dpic_mcause ),
	.magic_flag(magic_flag)
);

endmodule

