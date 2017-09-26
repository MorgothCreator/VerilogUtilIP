/*
 * This IP is the ALU for Atmel XMEGA CPU implementation.
 * 
 * Copyright (C) 2017  Iulian Gheorghiu
 * 
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

`timescale 1ns / 1ps

`include "mega_alu.vh"
`include "mega_core.vh"
`include "mega_core_cfg.vh"

module mega_alu(
	input [15:0]inst,
	input [4:0]in_addr_1,
	input [4:0]in_addr_2,
	input [15:0]in_1,
	input [15:0]in_2,
	output reg [15:0]out,
	//output c_out,
	input ALU_FLAG_C_IN,	//Zero Flag
	input ALU_FLAG_Z_IN,	//Zero Flag
	input ALU_FLAG_N_IN, //Negative Flag
	input ALU_FLAG_V_IN, //Two's complement overflow indicator 
	input ALU_FLAG_S_IN,	//N?V for signed tests
	input ALU_FLAG_H_IN,	//Half Carry Flag
	input ALU_FLAG_T_IN,	//Transfer bit used by BLD and BST instructions
	input ALU_FLAG_I_IN,	//Global Interrupt Enable/Disable Flag
	output reg ALU_FLAG_C_OUT,	//Carry Flag
	output reg ALU_FLAG_Z_OUT,	//Zero Flag
	output reg ALU_FLAG_N_OUT, //Negative Flag
	output reg ALU_FLAG_V_OUT, //Two's complement overflow indicator 
	output reg ALU_FLAG_S_OUT,	//N?V for signed tests
	output reg ALU_FLAG_H_OUT,	//Half Carry Flag
	output reg ALU_FLAG_T_OUT,	//Transfer bit used by BLD and BST instructions
	output reg ALU_FLAG_I_OUT	//Global Interrupt Enable/Disable Flag
    );
    
reg [`ALU_SELECT_BUS_SIZE - 1:0]inst_dec_out;

initial
begin
	ALU_FLAG_C_OUT = 0;
	ALU_FLAG_Z_OUT = 0;
	ALU_FLAG_N_OUT = 0;
	ALU_FLAG_V_OUT = 0;
	ALU_FLAG_S_OUT = 0;
	ALU_FLAG_H_OUT = 0;
	ALU_FLAG_T_OUT = 0;
	ALU_FLAG_I_OUT = 0;
end

reg in_addr_1_and_2_equal;

always @ (in_addr_1 or in_addr_2)
begin
	in_addr_1_and_2_equal = (in_addr_1 == in_addr_2) ? 1'b1 : 1'b0;
end

reg [15:0]in_2_int;
reg cin_int;

always @ (*)
begin
	in_2_int <= in_1;
	cin_int <= ALU_FLAG_C_IN;

	casex(inst)
	`INSTRUCTION_ADD,
	`INSTRUCTION_ADC:
	begin
		if(!in_addr_1_and_2_equal)
			in_2_int <= in_2;
	end
`ifndef CORE_TYPE_REDUCED
`ifndef CORE_TYPE_MINIMAL
	`INSTRUCTION_ADIW,
	`INSTRUCTION_SBIW,
`endif
`endif
	`INSTRUCTION_SUB,
	`INSTRUCTION_SBC,
	`INSTRUCTION_SUBI,
	`INSTRUCTION_SBCI,
	`INSTRUCTION_INC,
	`INSTRUCTION_DEC: in_2_int <= in_2;
	endcase

	casex(inst)
	`INSTRUCTION_ADD,
	`INSTRUCTION_LSR,
	`INSTRUCTION_NEG,
	`INSTRUCTION_SUB,
	`INSTRUCTION_SUBI,
	`INSTRUCTION_INC,
	`INSTRUCTION_DEC: cin_int <= 1'b0;
	endcase
	
end

wire [17:0] add_result_int_w_c_tmp = {in_1, 1'b1} + {in_2_int, cin_int};
wire [16:0] add_result_int_w_c = add_result_int_w_c_tmp[17:1];
wire [17:0] sub_result_int_w_c_tmp = {in_1, 1'b0} - {in_2_int, cin_int};
wire [16:0] sub_result_int_w_c = sub_result_int_w_c_tmp[17:1];

`ifndef CORE_TYPE_REDUCED
`ifndef CORE_TYPE_MINIMAL
`ifndef CORE_TYPE_CLASSIC_8K
`ifndef CORE_TYPE_CLASSIC_128K
wire [15:0]mul_result_int = in_1 * in_2;
`endif
`endif
`endif
`endif
wire carry_8bit = in_1 < in_2;
wire carry_8bit_plus_carry = in_1 < (in_2 + ALU_FLAG_C_IN);

always @ (*)
begin
	{ALU_FLAG_C_OUT, out} <= 17'h00000;
	casex(inst)
		`INSTRUCTION_ADD: 
		begin
			if(in_addr_1_and_2_equal)
				{ALU_FLAG_C_OUT, out} <= {in_1[7], 7'h00, in_1[6:0], cin_int};//LSL
			else
				{ALU_FLAG_C_OUT, out} <= {add_result_int_w_c[8], 8'h00, add_result_int_w_c[7:0]};
		end
		`INSTRUCTION_ADC: 
		begin
			if(in_addr_1_and_2_equal)
				{ALU_FLAG_C_OUT, out} <= {in_1[7], 7'h00, in_1[6:0], cin_int};//ROL
			else
				{ALU_FLAG_C_OUT, out} <= {add_result_int_w_c[8], 8'h00, add_result_int_w_c[7:0]};
		end
		`INSTRUCTION_INC,
		`INSTRUCTION_DEC:		{ALU_FLAG_C_OUT, out} <= {add_result_int_w_c[8], 8'h00, add_result_int_w_c[7:0]};
		`INSTRUCTION_SUB,
		`INSTRUCTION_SBC,
		`INSTRUCTION_SUBI,
		`INSTRUCTION_SBCI: 		{ALU_FLAG_C_OUT, out} <= {sub_result_int_w_c[8], 8'h00, sub_result_int_w_c[7:0]};
		`INSTRUCTION_LSR,
		`INSTRUCTION_ROR: 		{ALU_FLAG_C_OUT, out} <= {in_1[0], 7'h00, cin_int, in_1[7:1]};
		`INSTRUCTION_AND: 		{ALU_FLAG_C_OUT, out} <= {9'h00, (in_1[7:0] & in_2[7:0])};
		`INSTRUCTION_OR: 		{ALU_FLAG_C_OUT, out} <= {9'h00, (in_1[7:0] | in_2[7:0])};
		`INSTRUCTION_EOR: 		{ALU_FLAG_C_OUT, out} <= {9'h00, (in_1[7:0] ^ in_2[7:0])};
		`INSTRUCTION_MOV: 		{ALU_FLAG_C_OUT, out} <= {9'h00, in_1[7:0]};
		`INSTRUCTION_MOVW: 		{ALU_FLAG_C_OUT, out} <= {1'h00, in_1};
		`INSTRUCTION_COM: 		{ALU_FLAG_C_OUT, out} <= {1'b1, 8'h00, (8'h00 - in_1[7:0])};
		`INSTRUCTION_NEG: 		{ALU_FLAG_C_OUT, out} <= {|in_1[7:0], 8'h00, ~in_1[7:0]};
`ifndef CORE_TYPE_REDUCED
`ifndef CORE_TYPE_MINIMAL
		`INSTRUCTION_ADIW: 		{ALU_FLAG_C_OUT, out} <= add_result_int_w_c;
		`INSTRUCTION_SBIW: 		{ALU_FLAG_C_OUT, out} <= sub_result_int_w_c;
`endif
`endif
`ifndef CORE_TYPE_REDUCED
`ifndef CORE_TYPE_MINIMAL
`ifndef CORE_TYPE_CLASSIC_8K
`ifndef CORE_TYPE_CLASSIC_128K
		`INSTRUCTION_MUL: 		{ALU_FLAG_C_OUT, out} <= {mul_result_int[15], mul_result_int};
`endif
`endif
`endif
`endif
		`INSTRUCTION_ASR: 		{ALU_FLAG_C_OUT, out} <= {in_1[0], 7'h00, in_1[7], in_1[7:1]};
		`INSTRUCTION_CP,
		`INSTRUCTION_CPI:		{ALU_FLAG_C_OUT, out} <= {carry_8bit, 16'h0000};
		`INSTRUCTION_CPC:		{ALU_FLAG_C_OUT, out} <= {carry_8bit_plus_carry, 16'h0000};
		`INSTRUCTION_SWAP:		{ALU_FLAG_C_OUT, out} <= {1'b0, in_1[3:0], in_1[7:4]};
		`INSTRUCTION_SEx_CLx:	{ALU_FLAG_C_OUT, out} <= inst[6:4] ? {ALU_FLAG_C_IN, {16{1'b0}}} : {inst[7], {16{1'b0}}};
	endcase
end

/*
 * ALU FLAG effect for each instruction.
 */
always @ (inst or out or in_1 or in_2)
begin
	ALU_FLAG_Z_OUT <= ALU_FLAG_Z_IN;
	ALU_FLAG_N_OUT <= ALU_FLAG_N_IN;
	ALU_FLAG_V_OUT <= ALU_FLAG_V_IN;
	ALU_FLAG_S_OUT <= ALU_FLAG_S_IN;
	ALU_FLAG_H_OUT <= ALU_FLAG_H_IN;
	ALU_FLAG_T_OUT <= ALU_FLAG_T_IN;
	ALU_FLAG_I_OUT <= ALU_FLAG_I_IN;
	casex(inst)
	`INSTRUCTION_ADD:
	begin
		if(in_addr_1_and_2_equal)
		begin
			ALU_FLAG_H_OUT <= in_1[3];
			ALU_FLAG_V_OUT <= ALU_FLAG_N_OUT & ALU_FLAG_C_OUT;
		end
		else
		begin
			ALU_FLAG_H_OUT <= (in_1[3] & in_2[3])|(in_2[3] & ~out[3])|(~out[3] & in_1[3]);
			ALU_FLAG_V_OUT <= (in_1[7] & in_2[7] & ~out[7])|(~in_1[7] & ~in_2[7] & out[7]);
		end
		ALU_FLAG_S_OUT <= ALU_FLAG_N_OUT & ALU_FLAG_V_OUT;
		ALU_FLAG_N_OUT <= out[7];
		ALU_FLAG_Z_OUT <= &(~out[7:0]);
	end
	`INSTRUCTION_ADC:
	begin
		if(in_addr_1_and_2_equal)
		begin
			ALU_FLAG_H_OUT <= in_1[3];
			ALU_FLAG_V_OUT <= ALU_FLAG_N_OUT & ALU_FLAG_C_OUT;
			ALU_FLAG_Z_OUT <= &(~out[7:0]);
		end
		else
		begin
			ALU_FLAG_H_OUT <= (in_1[3] & in_2[3])|(in_2[3] & ~out[3])|(~out[3] & in_1[3]);
			ALU_FLAG_V_OUT <= (in_1[7] & in_2[7] & ~out[7])|(~in_1[7] & ~in_2[7] & out[7]);
			ALU_FLAG_Z_OUT <= &(~{out[7:0], ALU_FLAG_Z_IN});
		end
		ALU_FLAG_S_OUT <= ALU_FLAG_N_OUT & ALU_FLAG_V_OUT;
		ALU_FLAG_N_OUT <= out[7];
	end
	`INSTRUCTION_SUB,
	`INSTRUCTION_SUBI,
	`INSTRUCTION_CP,
	`INSTRUCTION_CPI:
	begin
		ALU_FLAG_H_OUT <= (in_1[3] & in_2[3])|(in_2[3] & ~out[3])|(~out[3] & in_1[3]);
		ALU_FLAG_S_OUT <= ALU_FLAG_N_OUT & ALU_FLAG_V_OUT;
		ALU_FLAG_V_OUT <= (in_1[7] & in_2[7] & ~out[7])|(~in_1[7] & ~in_2[7] & out[7]);
		ALU_FLAG_N_OUT <= out[7];
		ALU_FLAG_Z_OUT <= &(~out[7:0]);
	end
	`INSTRUCTION_INC,
	`INSTRUCTION_DEC:
	begin
		ALU_FLAG_S_OUT <= ALU_FLAG_N_OUT & ALU_FLAG_V_OUT;
		ALU_FLAG_V_OUT <= &{out[7], ~out[6:0]};
		ALU_FLAG_N_OUT <= out[7];
		ALU_FLAG_Z_OUT <= &(~out[7:0]);
	end
	`INSTRUCTION_SBC,
	`INSTRUCTION_SBCI,
	`INSTRUCTION_CPC:
	begin
		ALU_FLAG_H_OUT <= (in_1[3] & in_2[3])|(in_2[3] & ~out[3])|(~out[3] & in_1[3]);
		ALU_FLAG_S_OUT <= ALU_FLAG_N_OUT & ALU_FLAG_V_OUT;
		ALU_FLAG_V_OUT <= (in_1[7] & in_2[7] & ~out[7])|(~in_1[7] & ~in_2[7] & out[7]);
		ALU_FLAG_N_OUT <= out[7];
		ALU_FLAG_Z_OUT <= &(~{out[7:0], ALU_FLAG_Z_IN});
	end
`ifndef CORE_TYPE_REDUCED
`ifndef CORE_TYPE_MINIMAL
	`INSTRUCTION_ADIW,
	`INSTRUCTION_SBIW:
	begin
		ALU_FLAG_S_OUT <= ALU_FLAG_N_OUT & ALU_FLAG_V_OUT;
		ALU_FLAG_V_OUT <= ALU_FLAG_C_OUT;
		ALU_FLAG_N_OUT <= out[15];
		ALU_FLAG_Z_OUT <= &(~out[15:0]);
	end
`endif
`endif
	`INSTRUCTION_AND,
	`INSTRUCTION_OR,
	`INSTRUCTION_COM,
	`INSTRUCTION_EOR:
	begin
		ALU_FLAG_S_OUT <= ALU_FLAG_N_OUT & ALU_FLAG_V_OUT;
		ALU_FLAG_V_OUT <= 1'b0;
		ALU_FLAG_N_OUT <= out[7];
		ALU_FLAG_Z_OUT <= &(~out[7:0]);
	end
	`INSTRUCTION_NEG:
	begin
		ALU_FLAG_H_OUT <= out[3] + ~in_1[3];
		ALU_FLAG_S_OUT <= ALU_FLAG_N_OUT & ALU_FLAG_V_OUT;
		ALU_FLAG_V_OUT <= &{out[7], ~out[6:0]};
		ALU_FLAG_N_OUT <= out[7];
		ALU_FLAG_Z_OUT <= &(~out[7:0]);
	end
	`INSTRUCTION_ASR:
	begin
		ALU_FLAG_S_OUT <= ALU_FLAG_N_OUT & ALU_FLAG_V_OUT;
		ALU_FLAG_V_OUT <= 1'b0;
		ALU_FLAG_N_OUT <= out[7];
		ALU_FLAG_Z_OUT <= &(~out[7:0]);
	end
	`INSTRUCTION_LSR,
	`INSTRUCTION_ROR:
	begin
		ALU_FLAG_H_OUT <= in_1[3];
		ALU_FLAG_S_OUT <= ALU_FLAG_N_OUT & ALU_FLAG_V_OUT;
		ALU_FLAG_V_OUT <= ALU_FLAG_N_OUT & ALU_FLAG_C_OUT;
		ALU_FLAG_N_OUT <= 0;
		ALU_FLAG_Z_OUT <= &(~out[7:0]);
	end
	`INSTRUCTION_SEx_CLx:
	begin
		case(inst[6:4])
		3'd1: ALU_FLAG_Z_OUT <= inst[7];
		3'd2: ALU_FLAG_N_OUT <= inst[7];
		3'd3: ALU_FLAG_V_OUT <= inst[7];
		3'd4: ALU_FLAG_S_OUT <= inst[7];
		3'd5: ALU_FLAG_H_OUT <= inst[7];
		3'd6: ALU_FLAG_T_OUT <= inst[7];
		3'd7: ALU_FLAG_I_OUT <= inst[7];
		endcase
	end
`ifndef CORE_TYPE_REDUCED
`ifndef CORE_TYPE_MINIMAL
`ifndef CORE_TYPE_CLASSIC_8K
`ifndef CORE_TYPE_CLASSIC_128K
	`INSTRUCTION_MUL: ALU_FLAG_Z_OUT <= &(~out[15:0]);
`endif
`endif
`endif
`endif
	endcase
end

endmodule
