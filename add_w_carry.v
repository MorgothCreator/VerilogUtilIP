/*
 * This IP is the synthetizable adder with carry in implementation.
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

module add_w_carry # (
	parameter WIDTH = 8)(
		input c_in,
		input [WIDTH-1:0]in_1,
		input [WIDTH-1:0]in_2,
		output [WIDTH-1:0]out,
		output c_out
    );
wire [WIDTH-1:0]carry;
wire [WIDTH-1:0]p;
wire [WIDTH-1:0]r;
wire [WIDTH-1:0]s;
assign c_out = carry[WIDTH-1];
genvar count_generate;
generate
	for (count_generate = 0; count_generate < WIDTH; count_generate = count_generate + 1)
	begin: ADD
		xor (p[count_generate], in_1[count_generate], in_2[count_generate]);
		xor (out[count_generate], p[count_generate], count_generate ? carry[count_generate - 1] : c_in);
	 
		and(r[count_generate], p[count_generate], count_generate ? carry[count_generate - 1] : c_in);
		and(s[count_generate], in_1[count_generate], in_2[count_generate]);
		or(carry[count_generate], r[count_generate], s[count_generate]);

	end
endgenerate
endmodule
