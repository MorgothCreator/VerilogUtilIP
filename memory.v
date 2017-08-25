/*
 * This IPs is the ROM and RAM memory for the Atmel XMEGA CPU implementation.
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

module rom  #(
	parameter bus_addr_pgm_width = 11, 
	parameter rom_path = "NONE"
) (
	input [bus_addr_pgm_width-1:0] pmem_a,
	output [15:0] pmem_d
);

localparam LENGTH=2**bus_addr_pgm_width;
reg [15:0] mem [LENGTH-1:0];
initial $readmemh(rom_path, mem);
assign pmem_d = mem[pmem_a];

endmodule


module ram  #(
	parameter bus_addr_data_width = 13,  /* < in bytes */
	parameter ram_path = "NONE"
) (
	input dmem_we,
	input dmem_re,
	input [bus_addr_data_width-1:0] dmem_a,
	input [7:0] dmem_w,
	output [7:0] dmem_r
);

reg [7:0] mem [2**bus_addr_data_width-1:0];
    
initial begin
if (ram_path == "true")
	$readmemh(ram_path, mem);
end

always@(posedge dmem_we) begin
	mem[dmem_a] <= dmem_w;
end
assign dmem_r = dmem_re ? mem[dmem_a] : 8'bz;

endmodule
