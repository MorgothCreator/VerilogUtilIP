/*
 * This IP is the custom DDR SER/DES implementation.
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

module ddr_oserdes #(
	parameter DATA_RATE = "SDR",//"SDR" or "DDR"
	parameter DATA_WIDTH = 8
	)(
	input rst,
	input clk,
	input write,
	output s_out,
	input [DATA_WIDTH - 1:0]data_send,
	output ck_en_out,
	output busy_sig
    );

localparam DATA_WIDTH_int = DATA_RATE == "SDR" ? DATA_WIDTH : DATA_WIDTH / 2;

/*
 * Custom Deserealizer.
 */
    
reg old_state_write;
wire write_pulse = old_state_write != write;
reg [DATA_WIDTH_int - 1:0]sending;
reg [DATA_WIDTH_int - 1:0]shift_reg_p;
reg [DATA_WIDTH_int - 1:0]shift_reg_n;

integer cnt;

always @ (posedge rst or posedge clk)
begin
	if(rst)
	begin
		old_state_write <= 0;
		shift_reg_p <= 0;
		shift_reg_n <= 0;
		sending <= 0;
	end
	else if(sending[0])
	begin
		sending <= {1'b0, sending[DATA_WIDTH_int - 1:1]};
		{shift_reg_p} <= {1'b0, shift_reg_p[DATA_WIDTH_int - 1:1]};
		if(DATA_RATE == "DDR")
			{shift_reg_n} <= {1'b0, shift_reg_n[DATA_WIDTH_int - 1:1]};
	end
	if(write_pulse & ~sending[1] & ~rst)
	begin
		if(DATA_RATE == "DDR")
		begin/* Reorder bits to DDR shift registers. */
			for(cnt = 0; cnt < DATA_WIDTH; cnt = cnt + 2)
				shift_reg_p[cnt >> 1] <= data_send[cnt];
			for(cnt = 0; cnt < DATA_WIDTH; cnt = cnt + 2)
				shift_reg_n[cnt >> 1] <= data_send[cnt + 1];
		end
		else
		begin
			shift_reg_p <= data_send;
		end
		sending <= {DATA_WIDTH_int{1'b1}};
		old_state_write <= write;
	end
end

assign busy_sig = sending[1];
assign s_out = sending[0] ? ((DATA_RATE == "DDR") ? (clk ? shift_reg_p[0] : shift_reg_n[0]) : shift_reg_p[0]) : 1'bz;
assign ck_en_out = sending[0];

endmodule

module ddr_iserdes #(
	parameter DATA_RATE = "SDR",
	parameter DATA_WIDTH = 8
	)(
	input rst,
	input clk,
	input rec_en,
	input s_in,
	output reg [DATA_WIDTH - 1:0]data_rec,
	output reg ready
    );

localparam DATA_WIDTH_int = DATA_RATE == "SDR" ? DATA_WIDTH : DATA_WIDTH / 2;

/*
 * Custom Serializer.
 */

reg [DATA_WIDTH_int - 1:0]receiving;
reg [DATA_WIDTH_int - 1:0]shift_reg_p;
reg [DATA_WIDTH_int - 1:0]shift_reg_n;
reg first_bit;

always @ (posedge rst or negedge rec_en or posedge clk)
begin
	if(rst | ~rec_en)
	begin
		shift_reg_p <= 0;
		if(DATA_RATE == "SDR")
			receiving <= 0;
	end
	else if(rec_en)
	begin
		shift_reg_p <= {s_in, shift_reg_p[DATA_WIDTH_int - 1:1]};
		if(DATA_RATE == "SDR")
			receiving <= {~receiving[0], receiving[DATA_WIDTH_int - 1:1]};
	end
end

always @ (posedge rst or negedge rec_en or negedge clk)
begin
	if(DATA_RATE == "DDR")
	begin
		if(rst | ~rec_en)
		begin
			shift_reg_n <= 0;
			if(DATA_RATE == "DDR")
				receiving <= 0;
		end
		else if(rec_en)
		begin
			shift_reg_n <= {s_in, shift_reg_n[DATA_WIDTH_int - 1:1]};
			if(DATA_RATE == "DDR")
				receiving <= {~receiving[0], receiving[DATA_WIDTH_int - 1:1]};
		end
	end
end

integer cnt;

always @ (*)
begin
	for(cnt = 0; cnt < DATA_WIDTH_int; cnt = cnt + 1)
	begin
		if(DATA_RATE == "DDR")
		begin/* Resorder bits from DDR dual edge shift registers. */
			data_rec[cnt * 2] <= shift_reg_p[cnt];
			data_rec[(cnt * 2) + 1] <= shift_reg_n[cnt];
		end
		else
			data_rec <= shift_reg_p;
	end
end

always @ (posedge clk) ready = receiving[0];

endmodule
