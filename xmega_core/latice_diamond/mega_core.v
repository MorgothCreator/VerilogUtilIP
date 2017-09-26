/*
 * This IP is the Atmel XMEGA CPU implementation.
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

`include "mega_alu_h.v"
`include "mega_core_h.v"
`include "mega_core_cfg_h.v"

module mega_core # (
	parameter bus_addr_pgm_width = 11,
	parameter bus_addr_data_width = 12
)(
	input rst,
	input clk,
	
	output [bus_addr_pgm_width-1:0]pgm_addr,
	input [15:0]pgm_data,
	//output reg pgm_re,
	
	output reg [bus_addr_data_width-1:0]data_addr,
	input [7:0]data_in,
	output reg [7:0]data_out,
	output reg data_we,
	output reg data_re,
	
	output reg [5:0]io_addr,
	input [7:0]io_in,
	output reg [7:0]io_out,
	output io_we,
	output reg io_re
    );

reg data_we_int;
reg data_we_int1;

reg [7:0]ALU_FLAGS = 0;	//Carry Flag
wire ALU_FLAG_C_OUT;	//Carry Flag
wire ALU_FLAG_Z_OUT;	//Zero Flag
wire ALU_FLAG_N_OUT;	//Negative Flag
wire ALU_FLAG_V_OUT;	//Two's complement overflow indicator 
wire ALU_FLAG_S_OUT;	//N?V for signed tests
wire ALU_FLAG_H_OUT;	//Half Carry Flag
wire ALU_FLAG_T_OUT;	//Transfer bit used by BLD and BST instructions
wire ALU_FLAG_I_OUT;	//Global Interrupt Enable/Disable Flag
reg [15:0]PC = 0;
assign pgm_addr = PC;
wire [15:0]PC_PLUS_ONE = PC + 1;
wire [15:0]PC_PLUS_TWO = PC + 2;
reg [15:0]SP = 0;
wire [15:0]SP_PLUS_ONE = SP + 1;
wire [15:0]SP_MINUS_ONE = SP - 1;
reg [2:0]step_cnt = 0;
reg [15:0]tmp_pgm_data = 0;

// REG aditional
reg write_to_reg = 0;
reg write_to_io = 0;
// REG wires
reg [4:0]rw_addr = 0;
reg [15:0]rw_data = 0;
reg rw_16bit = 0;
//wire write;
reg [4:0]rd_addr_d = 0;
wire [15:0]rd_data_d;
reg rd_16bit_d = 0;
wire read_d;
reg [4:0]rd_addr_r = 0;
wire [15:0]rd_data_r;
wire [15:0]rd_data_r_PLUS_ONE = rd_data_r + 1;
wire [15:0]rd_data_r_MINUS_ONE = rd_data_r - 1;
reg rd_16bit_r = 0;
wire read_r;

// ALU wires
reg [15:0]alu_in_1 = 0;
reg [15:0]alu_in_2 = 0;
wire [15:0]alu_out;
wire alu_c_out;
reg [15:0]indirect_addr_offset = 0;
wire [15:0]indirect_addr_offset_res = rd_data_r + indirect_addr_offset;
reg [15:0]ldd_back_offset_res;

/*
 * Data address demultiplexer.
 */
always @ (*)
begin
	data_addr <= 'hz;
	case(step_cnt)
	`STEP1:
	begin
		casex(pgm_data)
`ifndef CORE_TYPE_REDUCED
`ifndef CORE_TYPE_MINIMAL
		`INSTRUCTION_LDD_STD: data_addr <= indirect_addr_offset_res;
		`INSTRUCTION_LD_ST_X,
		`INSTRUCTION_LD_ST_XP,
		`INSTRUCTION_LD_ST_YZP: data_addr <= rd_data_r;
		`INSTRUCTION_LD_ST_XN,
		`INSTRUCTION_LD_ST_YZN: data_addr <= rd_data_r_MINUS_ONE;
		`INSTRUCTION_POP_PUSH: 
		begin
			if(pgm_data[9])
				data_addr <= SP;
			else
				data_addr <= SP_PLUS_ONE;
		end
`endif
`endif
`ifndef CORE_TYPE_REDUCED
`ifndef CORE_TYPE_MINIMAL
		`INSTRUCTION_ICALL,
`endif
`endif
		`INSTRUCTION_RCALL,
		`INSTRUCTION_CALL: data_addr <= SP;
		`INSTRUCTION_RET_RETI: data_addr <= SP_PLUS_ONE;
		`INSTRUCTION_XCH,
		`INSTRUCTION_LAS,
		`INSTRUCTION_LAC,
		`INSTRUCTION_LAT: data_addr <= rd_data_r;
		endcase
	end
	`STEP2:
	begin
		casex(tmp_pgm_data)
`ifndef CORE_TYPE_REDUCED
`ifndef CORE_TYPE_MINIMAL
		`INSTRUCTION_ICALL,
`endif
`endif
		`INSTRUCTION_CALL,
		`INSTRUCTION_RCALL: data_addr <= SP;
		`INSTRUCTION_RET_RETI: data_addr <= SP_PLUS_ONE;
		`INSTRUCTION_LDS_STS: data_addr <= pgm_data;
		endcase
	end
	endcase
end

/*
 * Translate core instructions to REG adresses, and connect busses to ALU.
 * Arithmetic instructions.
 */
always @ (*)
begin
	rw_addr <= {5{1'b0}};
	rw_16bit <= 1'b0;
	rd_addr_d <= {5{1'b0}};
	rd_16bit_d <= 1'b0;
	rd_addr_r <= {5{1'b0}};
	rd_16bit_r <= 1'b0;
	// Connect busses
	rw_data <= {16{1'b0}};
	alu_in_1 <= {16{1'b0}};
	alu_in_2 <= {16{1'b0}};
	write_to_reg <= 1'b0;
	write_to_io <= 1'b0;
	io_re <= 1'b0;
	io_addr <= 5'hz;
	io_out <= 8'hz;
	data_out <= 'hz;
	data_re <= 1'b0;
	indirect_addr_offset <= {16{1'b0}};
	data_we_int1 <= 1'b0;
	case(step_cnt)
	`STEP1:
	begin
		casex(pgm_data)
		`INSTRUCTION_MOVW:
		begin
			rw_addr <= {pgm_data[7:4], 1'b0};
			rw_16bit <= 1'b1;
			rd_addr_d <= {pgm_data[7:4], 1'b0};
			rd_16bit_d <= 1'b1;
			rd_addr_r <= {pgm_data[3:0], 1'b0};
			rd_16bit_r <= 1'b1;
			// Connect busses
			alu_in_1 <= rd_data_d;
			alu_in_2 <= rd_data_r;
			rw_data <= alu_out;
			// Signalize write_to_reg;
			write_to_reg <= 1'b1;
		end
		`INSTRUCTION_CPC_CP:
		begin
			rw_addr <= pgm_data[8:4];
			rd_addr_d <= pgm_data[8:4];
			rd_addr_r <= {pgm_data[9], pgm_data[3:0]};
			// Connect busses
			alu_in_1 <= rd_data_d;
			alu_in_2 <= rd_data_r;
			rw_data <= alu_out;
		end
		`INSTRUCTION_SBC_SUB_ADD_ADC,
		`INST_AND_EOR_OR_MOV:
		begin
			rw_addr <= pgm_data[8:4];
			rd_addr_d <= pgm_data[8:4];
			rd_addr_r <= {pgm_data[9], pgm_data[3:0]};
			// Connect busses
			alu_in_1 <= rd_data_d;
			alu_in_2 <= rd_data_r;
			rw_data <= alu_out;
			// Signalize write_to_reg;
			write_to_reg <= 1'b1;
		end
		`INSTRUCTION_SUBI_SBCI,
		`INSTRUCTION_ORI_ANDI:
		begin
			rw_addr <= {1'b1, pgm_data[7:4]};
			rd_addr_d <= {1'b1, pgm_data[7:4]};
			// Connect busses
			alu_in_1 <= rd_data_d;
			alu_in_2 <= {pgm_data[11:8], pgm_data[3:0]};
			rw_data <= alu_out;
			// Signalize write_to_reg;
			write_to_reg <= 1'b1;
		end
		`INST_COM_NEG_SWAP_INC,
		`INSTRUCTION_ASR,
		`INSTRUCTION_LSR,
		`INSTRUCTION_ROR:
		begin
			rw_addr <= pgm_data[8:4];
			rd_addr_d <= pgm_data[8:4];
			// Connect busses
			alu_in_1 <= rd_data_d;
			casex(pgm_data)
			`INSTRUCTION_INC: alu_in_2 <= 16'h0001;
			`INSTRUCTION_DEC: alu_in_2 <= 16'hFFFF;
			endcase
			rw_data <= alu_out;
			// Signalize write_to_reg;
			write_to_reg <= 1'b1;
		end
`ifndef CORE_TYPE_REDUCED
`ifndef CORE_TYPE_MINIMAL
		`INSTRUCTION_LDD_STD:
		begin
			rd_addr_r <= {{3{1'b1}}, ~pgm_data[3], 1'b0};
			rd_16bit_r <= 1'b1;
			indirect_addr_offset <= {{11{1'b0}}, pgm_data[11:10], pgm_data[2:0]};
			if(pgm_data[9])
			begin
				rd_addr_d <= pgm_data[8:4];
				data_out <= rd_data_d;
				data_we_int1 <= 1'b1;
			end
			else
			begin
				rw_addr <= pgm_data[8:4];
				// Connect busses
				rw_data <= data_in;
				// Signalize write_to_reg;
				write_to_reg <= 1'b1;
				data_re <= 1'b1;
			end
		end
		`INSTRUCTION_LD_ST_X:
		begin
			rd_addr_r <= 5'd26;
			rd_16bit_r <= 1'b1;
			if(pgm_data[9])
			begin
				rd_addr_d <= pgm_data[8:4];
				data_out <= rd_data_d;
				data_we_int1 <= 1'b1;
			end
			else
			begin
				rw_addr <= pgm_data[8:4];
				// Connect busses
				rw_data <= data_in;
				// Signalize write_to_reg;
				write_to_reg <= 1'b1;
				data_re <= 1'b1;
			end
			
		end
		`INSTRUCTION_LD_ST_YZP,
		`INSTRUCTION_LD_ST_YZN:
		begin
			rd_addr_r <= {{3{1'b1}}, ~pgm_data[3], 1'b0};
			rd_16bit_r <= 1'b1;
			rw_addr <= {{3{1'b1}}, ~pgm_data[3], 1'b0};
			//rw_16bit <= 1'b1;
			if(pgm_data[9])
			begin
				rd_addr_d <= pgm_data[8:4];
				data_out <= rd_data_d;
				data_we_int1 <= 1'b1;
			end
			else
			begin
				rw_addr <= pgm_data[8:4];
				// Connect busses
				rw_data <= data_in;
				// Signalize write_to_reg;
				write_to_reg <= 1'b1;
				data_re <= 1'b1;
			end
		end
		`INSTRUCTION_LD_ST_XP,
		`INSTRUCTION_LD_ST_XN:
		begin
			rd_addr_r <= 5'd26;
			rd_16bit_r <= 1'b1;
			rw_addr <= 5'd26;
			//rw_16bit <= 1'b1;
			if(pgm_data[9])
			begin
				rd_addr_d <= pgm_data[8:4];
				data_out <= rd_data_d;
				data_we_int1 <= 1'b1;
			end
			else
			begin
				rw_addr <= pgm_data[8:4];
				// Connect busses
				rw_data <= data_in;
				// Signalize write_to_reg;
				write_to_reg <= 1'b1;
				data_re <= 1'b1;
			end
		end
`endif
`endif
		`INSTRUCTION_XCH,
		`INSTRUCTION_LAS,
		`INSTRUCTION_LAC,
		`INSTRUCTION_LAT:
		begin
			rd_addr_d <= pgm_data[8:4];
			rd_addr_r <= 5'h1e;
			rw_addr <= pgm_data[8:4];
			data_re <= 1'b1;
			casex(pgm_data)
			`INSTRUCTION_XCH: data_out <= rd_data_d;
			`INSTRUCTION_LAS: data_out <= data_in | rd_data_d;
			`INSTRUCTION_LAC: data_out <= data_in & ~rd_data_d;
			`INSTRUCTION_LAT: data_out <= data_in ^ rd_data_d;
			endcase
			// Connect busses
			rw_data <= data_in;
			// Signalize write_to_reg;
			write_to_reg <= 1'b1;
		end
		`INSTRUCTION_IN_OUT:
		begin
			io_addr <= {pgm_data[10:9], pgm_data[3:0]};
			rw_addr <= pgm_data[8:4];
			rd_addr_d <= pgm_data[8:4];
			if(!pgm_data[11])
			begin
				io_re <= 1'b1;
				rw_data <= io_in;
				write_to_reg <= 1'b1;
			end
			else
			begin
				io_out <= rd_data_d;
				write_to_io <= 1'b1; // Put "data_we" to high to store the selected register.
			end
		end
`ifndef CORE_TYPE_REDUCED
`ifndef CORE_TYPE_MINIMAL
`ifndef CORE_TYPE_CLASSIC_8K
`ifndef CORE_TYPE_CLASSIC_128K
`INSTRUCTION_MUL:
		begin
			rw_16bit <= 1'b1;
			rd_addr_d <= pgm_data[8:4];
			rd_addr_r <= {pgm_data[9], pgm_data[3:0]};
			// Connect busses
			alu_in_1 <= rd_data_d;
			alu_in_2 <= rd_data_r;
			rw_data <= alu_out;
			// Signalize write_to_reg;
			//write_to_reg <= 1'b1;
			// Because the multiply unit has more latency, we will add an extra clock.
		end
`endif
`endif
`endif
`endif
		`INSTRUCTION_LDI:
		begin
			rw_addr <= {1'b1, pgm_data[7:4]};
			// Connect busses
			rw_data <= {pgm_data[11:8], pgm_data[3:0]};
			// Signalize write_to_reg;
			write_to_reg <= 1'b1;
		end
`ifndef CORE_TYPE_REDUCED
`ifndef CORE_TYPE_MINIMAL
		`INSTRUCTION_ADIW_SBIW:
		begin
			rw_addr <= {2'b11, pgm_data[5:4], 1'b0};
			rw_16bit <= 1'b1;
			rd_addr_d <= {2'b11, pgm_data[5:4], 1'b0};
			rd_16bit_d <= 1'b1;
			//rd_addr_r <= {5{1'b00}};
			rd_16bit_r <= 1'b1;
			// Connect busses
			rw_data <= alu_out;
			alu_in_1 <= rd_data_d;
			alu_in_2 <= {10'h000, pgm_data[7:6], pgm_data[3:0]};
			// Signalize write_to_reg;
			write_to_reg <= 1'b1;
		end
		`INSTRUCTION_POP_PUSH:
		begin
			if(pgm_data[9])
			begin
				rd_addr_d <= pgm_data[8:4];
				data_out <= rd_data_d;
				data_we_int1 <= 1'b1; // Put "data_we" to high to store the selected register.
			end
			else
			begin
				rd_addr_d <= pgm_data[8:4];
				rw_addr <= pgm_data[8:4];
				// Connect busses
				rw_data <= data_in;
				// Signalize write_to_reg;
				write_to_reg <= 1'b1;
				data_re <= 1'b1;
			end
		end
		`INSTRUCTION_IJMP:
		begin
			rd_addr_d <= 5'h1e;
			rd_16bit_d <= 1'b1;
		end
`endif
`endif
		`INSTRUCTION_CBI_SBI:
		begin
			io_addr <= {{11{1'b0}}, pgm_data[7:3]};
			case(pgm_data[2:0])
				3'h0: io_out <= {io_in[7:1], pgm_data[9]};
				3'h1: io_out <= {io_in[7:2], pgm_data[9], io_in[0]};
				3'h2: io_out <= {io_in[7:3], pgm_data[9], io_in[1:0]};
				3'h3: io_out <= {io_in[7:4], pgm_data[9], io_in[2:0]};
				3'h4: io_out <= {io_in[7:5], pgm_data[9], io_in[3:0]};
				3'h5: io_out <= {io_in[7:6], pgm_data[9], io_in[4:0]};
				3'h6: io_out <= {io_in[7], pgm_data[9], io_in[5:0]};
				3'h7: io_out <= {pgm_data[9], io_in[6:0]};
			endcase
			io_re <= 1'b1;
			write_to_io <= 1'b1;
		end
		`INSTRUCTION_BLD_BST:
		begin
			rd_addr_d <= pgm_data[8:4];
			if(pgm_data[9])
			begin
				rw_addr <= pgm_data[8:4];
				write_to_reg <= 1'b1;
				case(pgm_data[2:0])
					3'h0: rw_data <= {rd_data_d[7:1], ALU_FLAGS[`ALU_FLAG_T]};
					3'h1: rw_data <= {rd_data_d[7:2], ALU_FLAGS[`ALU_FLAG_T], rd_data_d[0]};
					3'h2: rw_data <= {rd_data_d[7:3], ALU_FLAGS[`ALU_FLAG_T], rd_data_d[1:0]};
					3'h3: rw_data <= {rd_data_d[7:4], ALU_FLAGS[`ALU_FLAG_T], rd_data_d[2:0]};
					3'h4: rw_data <= {rd_data_d[7:5], ALU_FLAGS[`ALU_FLAG_T], rd_data_d[3:0]};
					3'h5: rw_data <= {rd_data_d[7:6], ALU_FLAGS[`ALU_FLAG_T], rd_data_d[4:0]};
					3'h6: rw_data <= {rd_data_d[7], ALU_FLAGS[`ALU_FLAG_T], rd_data_d[5:0]};
					3'h7: rw_data <= {ALU_FLAGS[`ALU_FLAG_T], rd_data_d[6:0]};
				endcase
			end
		end
`ifndef CORE_TYPE_REDUCED
`ifndef CORE_TYPE_MINIMAL
		`INSTRUCTION_ICALL,
`endif
`endif
		`INSTRUCTION_RCALL:
		begin
			data_out <= PC_PLUS_ONE[7:0];// Put low byte of the PC.
			data_we_int1 <= 1'b1; // Put "data_we" to high to store low byte of the PC.
		end
		`INSTRUCTION_CALL:
		begin
			data_out <= PC_PLUS_TWO[7:0];
			data_we_int1 <= 1'b1; // Put "data_we" to high to store low byte of the PC.
		end
		`INSTRUCTION_RET_RETI:
		begin
			data_re <= 1'b1;
		end
		endcase
	end
	`STEP2:
	begin
		casex(tmp_pgm_data)
		`INSTRUCTION_RET_RETI:
		begin
			data_re <= 1'b1;
		end
		`INSTRUCTION_CALL:
		begin
			data_out <= PC_PLUS_TWO[15:8];
			data_we_int1 <= 1'b1; // Put "data_we" to high to store low byte of the PC.
		end
`ifndef CORE_TYPE_REDUCED
`ifndef CORE_TYPE_MINIMAL
		`INSTRUCTION_ICALL:
		begin
			data_out <= PC_PLUS_ONE[15:8];// Put high byte of the PC.
			rd_addr_d <= 5'h1e;
			data_we_int1 <= 1'b1; // Put "data_we" to high to store low byte of the PC.
		end
`endif
`endif
		`INSTRUCTION_RCALL:
		begin
			data_out <= PC_PLUS_ONE[15:8];// Put high byte of the PC.
			data_we_int1 <= 1'b1; // Put "data_we" to high to store low byte of the PC.
		end
`ifndef CORE_TYPE_REDUCED
`ifndef CORE_TYPE_MINIMAL
		`INSTRUCTION_LDS_STS:
		begin
			if(tmp_pgm_data[9])
			begin
				rd_addr_d <= tmp_pgm_data[8:4];
				data_out <= rd_data_d;
				data_we_int1 <= 1'b1; // Put "data_we" to high to store low byte of the PC.
			end
			else
			begin
				rw_addr <= tmp_pgm_data[8:4];
				// Connect busses
				rw_data <= data_in;
				// Signalize write_to_reg;
				write_to_reg <= 1'b1;
				data_re <= 1'b1;
			end
			
		end
		`INSTRUCTION_LD_ST_XP,
		`INSTRUCTION_LD_ST_XN:
		begin
			rd_addr_r <= 5'd26;
			rd_16bit_r <= 1'b1;
			rw_addr <= 5'd26;
			rw_16bit <= 1'b1;
			case(tmp_pgm_data[1:0])
			2'b01: rw_data <= rd_data_r_PLUS_ONE;
			2'b10: rw_data <= rd_data_r_MINUS_ONE;
			endcase
			write_to_reg <= 1'b1;
		end
		`INSTRUCTION_LD_ST_YZP,
		`INSTRUCTION_LD_ST_YZN:
		begin
			rd_addr_r <= {{3{1'b1}}, ~pgm_data[3], 1'b0};
			rd_16bit_r <= 1'b1;
			rw_addr <= {{3{1'b1}}, ~pgm_data[3], 1'b0};
			rw_16bit <= 1'b1;
			case(tmp_pgm_data[1:0])
			2'b01: rw_data <= rd_data_r_PLUS_ONE;
			2'b10: rw_data <= rd_data_r_MINUS_ONE;
			endcase
			write_to_reg <= 1'b1;
		end
`endif
`endif
		`INSTRUCTION_CPSE,
		`INSTRUCTION_SBRC_SBRS:
		begin
			rd_addr_d <= tmp_pgm_data[8:4];
			rd_addr_r <= {tmp_pgm_data[9], tmp_pgm_data[3:0]};
		end
		`INSTRUCTION_SBIC_SBIS:
		begin
			io_addr <= {{11{1'b0}}, tmp_pgm_data[7:3]};
			io_re <= 1'b1;
		end
`ifndef CORE_TYPE_REDUCED
`ifndef CORE_TYPE_MINIMAL
`ifndef CORE_TYPE_CLASSIC_8K
`ifndef CORE_TYPE_CLASSIC_128K
		`INSTRUCTION_MUL:
		begin
			rw_16bit <= 1'b1;
			rd_addr_d <= pgm_data[8:4];
			rd_addr_r <= {pgm_data[9], pgm_data[3:0]};
			// Connect busses
			alu_in_1 <= rd_data_d;
			alu_in_2 <= rd_data_r;
			rw_data <= alu_out;
			// Signalize write_to_reg;
			write_to_reg <= 1'b1;
		end
`endif
`endif
`endif
`endif
		endcase
	end
	endcase
end

wire [15:0]relative_offset = PC_PLUS_ONE + {{5{pgm_data[11]}}, pgm_data[10:0]};
//wire [0:7]ALU_FLAGS_FOR_CHECK = {ALU_FLAG_C_OUT,ALU_FLAG_Z_OUT,ALU_FLAG_N_OUT,ALU_FLAG_V_OUT,ALU_FLAG_S_OUT,ALU_FLAG_H_OUT,ALU_FLAG_T_OUT,ALU_FLAG_I_OUT};

always @ (clk or data_we_int or data_we_int1)
begin
	data_we <= (data_we_int | data_we_int1) & ~clk;
end

/*
 * PC, SP and jumps.
 * Jump and branch instructions.
 */ 
always @ (posedge clk)
begin
	if(rst)
	begin
		ALU_FLAGS[0] <= 1'b0;	//Carry Flag
		ALU_FLAGS[1] <= 1'b0;	//Zero Flag
		ALU_FLAGS[2] <= 1'b0;	//Negative Flag
		ALU_FLAGS[3] <= 1'b0;	//Two's complement overflow indicator 
		ALU_FLAGS[4] <= 1'b0;	//N?V for signed tests
		ALU_FLAGS[5] <= 1'b0;	//Half Carry Flag
		ALU_FLAGS[6] <= 1'b0;	//Transfer bit used by BLD and BST instructions
		ALU_FLAGS[7] <= 1'b0;	//Global Interrupt Enable/Disable Flag
		PC <= {16{1'b0}};
		SP <= {16{1'b1}};
		step_cnt <= `STEP1;
	end
	else
	begin
		ALU_FLAGS[0] <= ALU_FLAG_C_OUT;	//Carry Flag
		ALU_FLAGS[1] <= ALU_FLAG_Z_OUT;	//Zero Flag
		ALU_FLAGS[2] <= ALU_FLAG_N_OUT;	//Negative Flag
		ALU_FLAGS[3] <= ALU_FLAG_V_OUT;	//Two's complement overflow indicator 
		ALU_FLAGS[4] <= ALU_FLAG_S_OUT;	//N?V for signed tests
		ALU_FLAGS[5] <= ALU_FLAG_H_OUT;	//Half Carry Flag
		ALU_FLAGS[6] <= ALU_FLAG_T_OUT;	//Transfer bit used by BLD and BST instructions
		ALU_FLAGS[7] <= ALU_FLAG_I_OUT;	//Global Interrupt Enable/Disable Flag
		step_cnt <= `STEP1;
		PC <= PC_PLUS_ONE;// Increment PC by 1 if not specified otherwise.
		data_we_int <= 1'b0; // Clear "data_we" if not specified otherwise.
		case(step_cnt)
		`STEP1:
		begin
			casex(pgm_data)
`ifndef CORE_TYPE_REDUCED
`ifndef CORE_TYPE_MINIMAL
`ifndef CORE_TYPE_CLASSIC_8K
			`INSTRUCTION_JMP:
			begin
				tmp_pgm_data <= pgm_data;
				step_cnt <= `STEP2;
			end
`endif
`endif
`endif
			`INSTRUCTION_RJMP:
			begin
				PC <= relative_offset;
			end
`ifndef CORE_TYPE_REDUCED
`ifndef CORE_TYPE_MINIMAL
			`INSTRUCTION_IJMP:
			begin
				PC <= rd_data_d;
			end
`endif
`endif
`ifndef CORE_TYPE_REDUCED
`ifndef CORE_TYPE_MINIMAL
`ifndef CORE_TYPE_CLASSIC_8K
			`INSTRUCTION_CALL,
`endif
`endif
`endif
`ifndef CORE_TYPE_REDUCED
`ifndef CORE_TYPE_MINIMAL
			`INSTRUCTION_ICALL,
`endif
`endif
			`INSTRUCTION_RCALL:
			begin
				step_cnt <= `STEP2;
				tmp_pgm_data <= pgm_data;
				SP <= SP_MINUS_ONE;
				casex(pgm_data)
`ifndef CORE_TYPE_REDUCED
`ifndef CORE_TYPE_MINIMAL
				`INSTRUCTION_ICALL,
`endif
`endif
				`INSTRUCTION_RCALL: PC <= PC;
				endcase
			end
`ifndef CORE_TYPE_REDUCED
`ifndef CORE_TYPE_MINIMAL
			`INSTRUCTION_POP_PUSH:
			begin
				if(pgm_data[9])
					SP <= SP_MINUS_ONE;
				else
					SP <= SP_PLUS_ONE;
			end
`endif
`endif
			`INSTRUCTION_RET_RETI:
			begin
				step_cnt <= `STEP2;
				tmp_pgm_data <= pgm_data;
				SP <= SP_PLUS_ONE;
				PC <= {data_in, PC[7:0]};
			end
`ifndef CORE_TYPE_REDUCED
`ifndef CORE_TYPE_MINIMAL
			`INSTRUCTION_LDS_STS:
			begin
				tmp_pgm_data <= pgm_data;
				step_cnt <= `STEP2;
			end
`endif
`endif
`ifndef CORE_TYPE_REDUCED
`ifndef CORE_TYPE_MINIMAL
`ifndef CORE_TYPE_CLASSIC_8K
`ifndef CORE_TYPE_CLASSIC_128K
			`INSTRUCTION_MUL,
`endif
`endif
`endif
`endif
`ifndef CORE_TYPE_REDUCED
`ifndef CORE_TYPE_MINIMAL
			`INSTRUCTION_LD_ST_YZP,
			`INSTRUCTION_LD_ST_YZN,
			`INSTRUCTION_LD_ST_XP,
			`INSTRUCTION_LD_ST_XN:
			begin
				tmp_pgm_data <= pgm_data;
				step_cnt <= `STEP2;
				PC <= PC;
			end
`endif
`endif
			`INSTRUCTION_COND_BRANCH:
			begin
				if(pgm_data[10] != ALU_FLAGS[pgm_data[2:0]])
					PC <= PC + {{10{pgm_data[9]}}, pgm_data[8:3]} + 16'h0001;
			end
			`INSTRUCTION_CPSE,
			`INSTRUCTION_SBRC_SBRS,
			`INSTRUCTION_SBIC_SBIS:
			begin
				tmp_pgm_data <= pgm_data;
				step_cnt <= `STEP2;
			end
			`INSTRUCTION_BLD_BST:
			begin
				if(!pgm_data[9])
					ALU_FLAGS[`ALU_FLAG_T] <= rd_data_d[pgm_data[2:0]];
			end
			endcase
		end
		`STEP2:
		begin
			casex(tmp_pgm_data)
`ifndef CORE_TYPE_REDUCED
`ifndef CORE_TYPE_MINIMAL
`ifndef CORE_TYPE_CLASSIC_8K
			`INSTRUCTION_JMP:
			begin
				PC <= pgm_data;
			end
			`INSTRUCTION_CALL:
			begin
				SP <= SP_MINUS_ONE;
				PC <= pgm_data;
			end
`endif
`endif
`endif
`ifndef CORE_TYPE_REDUCED
`ifndef CORE_TYPE_MINIMAL
			`INSTRUCTION_ICALL:
			begin
				SP <= SP_MINUS_ONE;
				PC <= rd_data_d;// Backup the reg Z value to a 16bit temporary register because the reading section of REG's is asynchronous.
			end
`endif
`endif
			`INSTRUCTION_RCALL:
			begin
				SP <= SP_MINUS_ONE;
				PC <= relative_offset;// If is a relative CALL load the offset to "TEMP16".
			end
			`INSTRUCTION_RET_RETI:
			begin
				SP <= SP_PLUS_ONE;
				if(tmp_pgm_data[4])
					ALU_FLAGS[7] <= 1'b1;
				PC <= {PC[15:8], data_in};
			end
			`INSTRUCTION_CPSE:
			begin
				if(rd_data_d == rd_data_r)
				begin
					casex(pgm_data)
						`INSTRUCTION_LDS_STS,
						`INSTRUCTION_JMP_CALL: PC <= PC_PLUS_TWO;
					endcase
				end
			end
			`INSTRUCTION_SBRC_SBRS:
			begin
				if(rd_data_d[tmp_pgm_data[2:0]] == tmp_pgm_data[9])
				begin
					casex(pgm_data)
					`INSTRUCTION_LDS_STS,
					`INSTRUCTION_JMP_CALL: PC <= PC_PLUS_TWO;
				endcase
				end
			end
			`INSTRUCTION_SBIC_SBIS:
			begin
				if(io_in[tmp_pgm_data[2:0]] == tmp_pgm_data[9])
				begin
					casex(pgm_data)
					`INSTRUCTION_LDS_STS,
					`INSTRUCTION_JMP_CALL: PC <= PC_PLUS_TWO;
				endcase
				end
			end
		endcase
		end
		endcase
	end
end

mega_regs regs(
	.clk(clk),
	.rw_addr(rw_addr),
	.rw_data(rw_data),
	.rw_16bit(rw_16bit),
	.write(write_to_reg),
	.rd_addr_d(rd_addr_d),
	.rd_data_d(rd_data_d),
	.rd_16bit_d(rd_16bit_d),
	.read_d(1'b1),
	.rd_addr_r(rd_addr_r),
	.rd_data_r(rd_data_r),
	.rd_16bit_r(rd_16bit_r),
	.read_r(1'b1)
);

mega_alu alu(
	.inst(pgm_data),
	.in_addr_1(rd_addr_d),
	.in_addr_2(rd_addr_r),
	.in_1(alu_in_1),
	.in_2(alu_in_2),
	.out(alu_out),
	.ALU_FLAG_C_IN(ALU_FLAGS[0]),		//Carry Flag
	.ALU_FLAG_Z_IN(ALU_FLAGS[1]),		//Zero Flag
	.ALU_FLAG_N_IN(ALU_FLAGS[2]),		//Negative Flag
	.ALU_FLAG_V_IN(ALU_FLAGS[3]),		//Two's complement overflow indicator 
	.ALU_FLAG_S_IN(ALU_FLAGS[4]),		//N?V for signed tests
	.ALU_FLAG_H_IN(ALU_FLAGS[5]),		//Half Carry Flag
	.ALU_FLAG_T_IN(ALU_FLAGS[6]),		//Transfer bit used by BLD and BST instructions
	.ALU_FLAG_I_IN(ALU_FLAGS[7]),		//Global Interrupt Enable/Disable Flag

	.ALU_FLAG_C_OUT(ALU_FLAG_C_OUT),	//Carry Flag
	.ALU_FLAG_Z_OUT(ALU_FLAG_Z_OUT),	//Zero Flag
	.ALU_FLAG_N_OUT(ALU_FLAG_N_OUT),	//Negative Flag
	.ALU_FLAG_V_OUT(ALU_FLAG_V_OUT),	//Two's complement overflow indicator 
	.ALU_FLAG_S_OUT(ALU_FLAG_S_OUT),	//N?V for signed tests
	.ALU_FLAG_H_OUT(ALU_FLAG_H_OUT),	//Half Carry Flag
	.ALU_FLAG_T_OUT(ALU_FLAG_T_OUT),	//Transfer bit used by BLD and BST instructions
	.ALU_FLAG_I_OUT(ALU_FLAG_I_OUT)		//Global Interrupt Enable/Disable Flag
);

assign io_we = write_to_io & ~clk;// If "write_to_io" is high put to "io_we" the "clk" signal.

endmodule
