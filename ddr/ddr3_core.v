`timescale 1ns / 1ps

module ddr3_core #(parameter FREQ_CKDIV_MHZ = 2)(
	input rst,
	input clk,
	input clk90,
	input clkdiv,

	output reg [1:0]ddr3_dm_out,
	
	input [127:0]ddr3_pdata_in,
	output reg [127:0]ddr3_pdata_out,
	output reg ddr3_dq_oe,
	output ddr3_pdata_write,
	output ddr3_dq_receiver_en,
	
	output reg [13:0]ddr3_addr_out,
	
	input [1:0]ddr3_dqs_in,
	output reg [1:0]ddr3_dqs_out,
	output reg ddr3_dqs_oe,
	
	output reg ddr3_ck_oe,
	
	output reg ddr3_odt_out,
	
	output reg [2:0]ddr3_ba_out,
	
	output reg ddr3_cke_out,
	
	output ddr3_ras_out,
	
	output ddr3_cas_out,
	
	output ddr3_we_out,
	
	output ddr3_cs_out,
	
	output reg ddr3_reset_out
    );


`define COMMAND_BANK_ACTIVE					4'b0011
`define COMMAND_SINGLE_BANK_PRECHARGE		4'b0010
`define COMMAND_ALL_BANKS_PRECHARGE			4'b0010
`define COMMAND_WRITE						4'b0100
`define COMMAND_READ						4'b0101
`define COMMAND_DEVICE_DETECT				4'b1000
`define COMMAND_NOP							4'b0111
`define COMMAND_REFRESH						4'b0001
`define COMMAND_SELF_REFRESH_ENTRY			4'b0001
`define COMMAND_SELF_REFRESH_EXIT			4'b1000
`define COMMAND_MRS							4'b0000
`define COMMAND_ZQ_CAL						4'b0110

reg [3:0]command_reg;
assign {ddr3_cs_out, ddr3_ras_out, ddr3_cas_out, ddr3_we_out} = command_reg;

reg [15:0]addrL;
reg [15:0]addrH;

/*
 * 1uS clk generator.
 */
reg [8:0]ck_1us_cnt;
wire ck_1mhz = (ck_1us_cnt == FREQ_CKDIV_MHZ - 1);
reg [9:0]us_cnt;

always @ ( posedge clkdiv)
begin
	if(rst)
		ck_1us_cnt <= 0;
	else
	begin
		if(ck_1mhz)
			ck_1us_cnt <= 0;
		else
			ck_1us_cnt <= ck_1us_cnt + 1;
	end
end

/*
 * DDR3 times definitions.
 */
localparam tXPR	= 1;
localparam tMRD	= 4;
localparam tMOD	= 1;
localparam tZQinit	= 512;
/*
 * DDR3 commands.
 */

`define MR0		0
`define MRS0	0
`define MR1		1
`define MRS1	1
`define MR2		2
`define MRS2	2
`define MR3		3
`define MRS3	3


/*
 * Sequence execution.
 */

`define INIT_RESET_TIME						200
`define INIT_RESET_TO_CK_EN_TIME			500

`define INIT_RESET_START_STAGE				0
`define INIT_RESET_CK_EN_STAGE				1
`define INIT_RESET_NOTE1_START_STAGE		2
`define INIT_RESET_NOTE1_END_STAGE			3
`define INIT_RESET_MR2_START_STAGE			4
`define INIT_RESET_MR2_END_STAGE			5
`define INIT_RESET_MR3_START_STAGE			6
`define INIT_RESET_MR3_END_STAGE			7
`define INIT_RESET_MR1_START_STAGE			8
`define INIT_RESET_MR1_END_STAGE			9
`define INIT_RESET_MR0_START_STAGE			10
`define INIT_RESET_MR0_END_STAGE			11
`define INIT_RESET_ZQCL_START_STAGE			12
`define INIT_RESET_ZQCL_END_STAGE			13
`define INIT_RESET_END_STAGE				14

reg [9:0]us_init_cnt;
reg [9:0]stage_cnt;

always @ ( posedge clk90 )
begin
	if(rst)
	begin
		ddr3_dq_oe <= 0;
		ddr3_dqs_oe <= 0;
		ddr3_ck_oe <= 0;
		
		ddr3_reset_out <= 0;
		ddr3_cke_out <= 0;
		command_reg <= `COMMAND_NOP;
		
		us_init_cnt <= `INIT_RESET_TIME;
		stage_cnt <= 0;
	end
	else
	begin
		if(us_init_cnt)
			us_init_cnt <= us_init_cnt - 1;
		command_reg <= `COMMAND_NOP;
		case(stage_cnt)
		`INIT_RESET_START_STAGE:
		begin
			if(!us_init_cnt)
			begin
				ddr3_reset_out <= 1;
				ddr3_ck_oe <= 1;
				us_init_cnt <= `INIT_RESET_TO_CK_EN_TIME;
				stage_cnt <= `INIT_RESET_CK_EN_STAGE;
			end
		end
		`INIT_RESET_CK_EN_STAGE:
		begin
			if(!us_init_cnt)
			begin
				ddr3_cke_out <= 1;
				ddr3_odt_out <= 0;
				stage_cnt <= `INIT_RESET_MR2_START_STAGE;
			end
		end
		`INIT_RESET_MR2_START_STAGE:
		begin
			command_reg <= `COMMAND_MRS;
			ddr3_ba_out <= `MRS2;
			ddr3_addr_out <= `MR2;
			stage_cnt <= `INIT_RESET_MR2_END_STAGE;
		end
		`INIT_RESET_MR2_END_STAGE:
		begin
			//command_reg <= `COMMAND_NOP;
			us_init_cnt <= tMRD;
			stage_cnt <= `INIT_RESET_MR3_START_STAGE;
		end
		`INIT_RESET_MR3_START_STAGE:
		begin
			if(!us_init_cnt)
			begin
				command_reg <= `COMMAND_MRS;
				ddr3_ba_out <= `MRS3;
				ddr3_addr_out <= `MR3;
				stage_cnt <= `INIT_RESET_MR3_END_STAGE;
			end
		end
		`INIT_RESET_MR3_END_STAGE:
		begin
			//command_reg <= `COMMAND_NOP;
			us_init_cnt <= tMRD;
			stage_cnt <= `INIT_RESET_MR1_START_STAGE;
		end
		`INIT_RESET_MR1_START_STAGE:
		begin
			if(!us_init_cnt)
			begin
				command_reg <= `COMMAND_MRS;
				ddr3_ba_out <= `MRS1;
				ddr3_addr_out <= `MR1;
				stage_cnt <= `INIT_RESET_MR1_END_STAGE;
			end
		end
		`INIT_RESET_MR1_END_STAGE:
		begin
			//command_reg <= `COMMAND_NOP;
			us_init_cnt <= tMRD;
			stage_cnt <= `INIT_RESET_MR0_START_STAGE;
		end
		`INIT_RESET_MR0_START_STAGE:
		begin
			if(!us_init_cnt)
			begin
				command_reg <= `COMMAND_MRS;
				ddr3_ba_out <= `MRS0;
				ddr3_addr_out <= `MR0;
				stage_cnt <= `INIT_RESET_MR0_END_STAGE;
			end
		end
		`INIT_RESET_MR0_END_STAGE:
		begin
			//command_reg <= `COMMAND_NOP;
			us_init_cnt <= tMRD;
			stage_cnt <= `INIT_RESET_ZQCL_START_STAGE;
		end
		`INIT_RESET_ZQCL_START_STAGE:
		begin
			if(!us_init_cnt)
			begin
				command_reg <= `COMMAND_ZQ_CAL;
				us_init_cnt <= tZQinit;
				stage_cnt <= `INIT_RESET_ZQCL_END_STAGE;
			end
		end
		`INIT_RESET_ZQCL_END_STAGE:
		begin
			//command_reg <= `COMMAND_NOP;
			if(!us_init_cnt)
			begin
				ddr3_cke_out <= 0;
				stage_cnt <= `INIT_RESET_END_STAGE;
			end
		end
		endcase
	end
end

endmodule
