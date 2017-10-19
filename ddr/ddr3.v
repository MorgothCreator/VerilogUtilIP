/*
 * This IP is the DDR3 implementation.
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

module ddr3 # (
	parameter D_BUS_WIDTH = 16
	)(
	input rst,
	input clk,
	input clk90,
	input clkdiv,

	output [(D_BUS_WIDTH / 8) - 1:0]ddr3_dm_out,
	
	input [D_BUS_WIDTH - 1:0]ddr3_dq_in,
	output [D_BUS_WIDTH - 1:0]ddr3_dq_out,
	output ddr3_dq_oe,
	
	output [13:0]ddr3_addr_out,
	
	input [(D_BUS_WIDTH / 8) - 1:0]ddr3_dqs_in,
	output [1:0]ddr3_dqs_out,
	output ddr3_dqs_oe,
	
	output ddr3_ck_out,
	output ddr3_ck_oe,
	
	output ddr3_odt_out,
	output [2:0]ddr3_ba_out,
	output ddr3_cke_out,
	output ddr3_ras_out,
	output ddr3_cas_out,
	output ddr3_we_out,
	output ddr3_cs_out,
	output ddr3_reset_out
);

assign ddr3_ck_out = ~clk90;
/**********************************************************************************************************/
wire oserdes_oe;
reg [3:0]oserdes_mask;
reg ioserdes_clk_en;
wire [(D_BUS_WIDTH * 8) - 1:0]pdata_out;
wire [(D_BUS_WIDTH * 8) - 1:0]pdata_in;
/**********************************************************************************************************/
genvar count;

wire [D_BUS_WIDTH - 1:0]dq_in_ready;
wire [D_BUS_WIDTH - 1:0]dq_out_busy;
wire ddr3_pdata_write;
wire ddr3_dq_receiver_en;
generate
for(count = 0; count < D_BUS_WIDTH; count = count + 1)
begin : DQ_DES
	ddr_iserdes #(
		.DATA_RATE("DDR"),
		.DATA_WIDTH(8)
		)ddr_iserdes_dq_inst(
		.rst(rst),
		.clk(ddr3_dqs_in[count / 8]),
		.rec_en(ddr3_dq_receiver_en),
		.s_in(ddr3_dq_in),
		.data_rec({pdata_out[count + (D_BUS_WIDTH * 7)], pdata_out[count + (D_BUS_WIDTH * 6)], pdata_out[count+ (D_BUS_WIDTH * 5)], pdata_out[count + (D_BUS_WIDTH * 4)],
					pdata_out[count + (D_BUS_WIDTH * 3)], pdata_out[count + (D_BUS_WIDTH * 2)], pdata_out[count + (D_BUS_WIDTH * 1)], pdata_out[count]}),
		.ready(dq_in_ready[count])
		);
end

for(count = 0; count < D_BUS_WIDTH; count = count + 1)
begin : DQ_SER
	ddr_oserdes #(
		.DATA_RATE("DDR"),
		.DATA_WIDTH(8)
		)ddr_oserdes_dq_inst(
		.rst(rst),
		.clk(clk),
		.write(ddr3_pdata_write),
		.s_out(ddr3_dq_out),
		.data_send({pdata_in[count + (D_BUS_WIDTH * 7)], pdata_in[count + (D_BUS_WIDTH * 6)], pdata_in[count+ (D_BUS_WIDTH * 5)], pdata_in[count + (D_BUS_WIDTH * 4)],
					pdata_in[count + (D_BUS_WIDTH * 3)], pdata_in[count + (D_BUS_WIDTH * 2)], pdata_in[count + (D_BUS_WIDTH * 1)], pdata_in[count]}),
		.ck_en_out(),
		.busy_sig(dq_out_busy[count])
	);
end
endgenerate

ddr3_core ddr3_core_inst(
	.rst(rst),
	.clk(clk),
	.clk90(clk90),
	.clkdiv(clkdiv),
	 
	.ddr3_dm_out(ddr3_dm_out),
	 
	.ddr3_pdata_in(pdata_out),
	.ddr3_pdata_out(pdata_in),
	.ddr3_dq_oe(ddr3_dq_oe),
	.ddr3_pdata_write(ddr3_pdata_write),
	.ddr3_dq_receiver_en(ddr3_dq_receiver_en),
	
	.ddr3_dqs_in(ddr3_dqs_in),
	.ddr3_dqs_out(ddr3_dqs_out),
	.ddr3_dqs_oe(ddr3_dqs_oe),
	 
	.ddr3_addr_out(ddr3_addr_out),
	
	.ddr3_ck_oe(ddr3_ck_oe),
	
	.ddr3_odt_out(ddr3_odt_out),
	.ddr3_ba_out(ddr3_ba_out),
	.ddr3_cke_out(ddr3_cke_out),
	.ddr3_ras_out(ddr3_ras_out),
	.ddr3_cas_out(ddr3_cas_out),
	.ddr3_we_out(ddr3_we_out),
	.ddr3_cs_out(ddr3_cs_out),
	.ddr3_reset_out(ddr3_reset_out)
);
endmodule
