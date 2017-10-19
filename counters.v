/*
 * This IP is the synthetizable synchronous counters implementation.
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

module clk_div #(parameter WIDTH = 2)(
		input rst,
		input clk_in,
		input [WIDTH-1:0]divider,
		output clk_out
);
reg [WIDTH-1:0]q;
wire [WIDTH-1:0]pos_edge_loader = divider[WIDTH-1:1] + divider[0];
wire [WIDTH-1:0]neg_edge_loader = divider[WIDTH-1:1];
reg clk_out_int1;
reg clk_out_int2;

assign clk_out = (divider == 0) ? clk_in : 
				(divider == 1) ? clk_out_int1 : clk_out_int2;

always @ (posedge clk_in)
begin
	if(rst)
	begin
		q <= {WIDTH{1'b0}};
		clk_out_int1 <= 1'b0;
		clk_out_int2 <= 1'b0;
	end
	else if(divider == 1) clk_out_int1 <= ~clk_out_int1;
	else if(divider > 1) 
	begin
		if(!q)
		begin
			q <= divider;
			clk_out_int2 <= ~clk_out_int2;
		end
		else
			q <= q - 1;
	end
end

endmodule

module count_up #(parameter WIDTH = 2)(
		input rst,
		input clk,
		output reg[WIDTH-1:0]out
    );
    
always @ (negedge clk)
begin
	if(rst)
		out <= {WIDTH{1'b0}};
	else
		out <= out + 1;
end
endmodule

module count_dn #(parameter WIDTH = 2)(
		input rst,
		input clk,
		output reg[WIDTH-1:0]out
    );
    
always @ (posedge clk)
begin
	if(rst)
		out <= {WIDTH{1'b0}};
	else
		out <= out - 1;
end
endmodule

module count_up_ld #(parameter WIDTH = 2)(
		input rst,
		input clk,
		input load,
		input [WIDTH-1:0]value,
		output reg[WIDTH-1:0]out
    );
    
always @ (negedge clk)
begin
	if(rst)
		out <= {WIDTH{1'b0}};
	else if(load)
		out <= value;
	else
		out <= out + 1;
end
endmodule

module count_dn_ld #(parameter WIDTH = 2)(
		input rst,
		input clk,
		input load,
		input [WIDTH-1:0]value,
		output reg[WIDTH-1:0]out
    );
    
always @ (posedge clk)
begin
	if(rst)
		out <= {WIDTH{1'b0}};
	else if(load)
		out <= value;
	else
		out <= out - 1;
end
endmodule

module count_up_dn_ld #(parameter WIDTH = 2)(
		input rst,
		input clk,
		input dir,
		input load,
		input [WIDTH-1:0]value,
		output reg[WIDTH-1:0]out
    );

always @ (posedge dir ? ~clk : clk)
begin
	if(rst)
		out <= {WIDTH{1'b0}};
	else if(load)
		out <= value;
	else if(dir)
		out <= out + 1;
	else
		out <= out - 1;
end
endmodule

module count_up_dn #(parameter WIDTH = 2)(
		input rst,
		input clk,
		input dir,
		input [WIDTH-1:0]value,
		output reg[WIDTH-1:0]out
    );

always @ (posedge dir ? ~clk : clk)
begin
	if(rst)
		out <= {WIDTH{1'b0}};
	else if(dir)
		out <= out + 1;
	else
		out <= out - 1;
end
endmodule
