/*
 * This IP is the synthetizable big endian <-> little endian of strings implementation.
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

module string #(parameter LEN = 32)(
	input [LEN-1:0]in,
	output reg [LEN-1:0]out
    );

genvar cnt;
generate
for(cnt = LEN; cnt > 0; cnt = cnt - 8)
begin
	always @(in)
	begin
		if(in[cnt-1:cnt-8])
			out = {in[cnt-1:cnt-8], out[LEN - 1: 8]};
	end
end
for(cnt = LEN; cnt > 0; cnt = cnt - 8)
begin
	always @(in)
	begin
		if(!in[cnt-1:cnt-8])
			out = {8'h00, out[LEN - 1: 8]};
	end
end
endgenerate

endmodule
