/*
 * This IP is the 32 reg memory 1 in and 2 out selectable in 8 or 16 bit for the Atmel XMEGA CPU implementation.
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

module mega_regs (
	input clk,
	input [4:0]rw_addr,
	input [15:0]rw_data,
	input rw_16bit,
	input write,
	input [4:0]rd_addr_d,
	output [15:0]rd_data_d,
	input rd_16bit_d,
	input read_d,
	input [4:0]rd_addr_r,
	output [15:0]rd_data_r,
	input rd_16bit_r,
	input read_r
);

reg [7:0]REGL[0:15];
reg [7:0]REGH[0:15];

reg [4:0]k;

initial
begin
	for (k = 0; k < 16; k = k + 1)
	begin
		REGL[k] = 0;
		REGH[k] = 0;
	end
end

always @ (posedge clk)
begin
	if(write)
	begin
		if(!rw_16bit & !rw_addr[0])
			REGL[rw_addr[4:1]] <= rw_data[7:0];
		else if(!rw_16bit & rw_addr[0])
			REGH[rw_addr[4:1]] <= rw_data[7:0];
		else
		begin
			REGL[rw_addr[4:1]] <= rw_data[7:0];
			REGH[rw_addr[4:1]] <= rw_data[15:8];
		end
	end
end

assign rd_data_d = (read_d) ? (rd_16bit_d) ? {REGH[rd_addr_d[4:1]], REGL[rd_addr_d[4:1]]} : (rd_addr_d[0]) ? REGH[rd_addr_d[4:1]] : REGL[rd_addr_d[4:1]] : 16'bz;
assign rd_data_r = (read_r) ? (rd_16bit_r) ? {REGH[rd_addr_r[4:1]], REGL[rd_addr_r[4:1]]} : (rd_addr_r[0]) ? REGH[rd_addr_r[4:1]] : REGL[rd_addr_r[4:1]] : 16'bz;

endmodule
