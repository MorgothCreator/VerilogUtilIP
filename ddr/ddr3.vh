/*
 * This IP is the DDR3 header declarations.
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

`define DDR3_TOP \
	output [1:0]ddr3_dm, \
	inout [15:0]ddr3_dq, \
	inout [13:0]ddr3_addr, \
	output [1:0]ddr3_dqs_p, \
	output [1:0]ddr3_dqs_n, \
	output [0:0]ddr3_ck_p, \
	output [0:0]ddr3_ck_n, \
	output [2:0]ddr3_ba, \
	output [0:0]ddr3_odt, \
	output [0:0]ddr3_cke, \
	output ddr3_ras_n, \
	output ddr3_cas_n, \
	output ddr3_we_n, \
	output ddr3_cs_n, \
	output ddr3_reset_n
	
`define DDR3_IO \
 \
wire [1:0]ddr3_dm_out; \
 \
wire [15:0]ddr3_dq_in; \
wire [15:0]ddr3_dq_out; \
wire ddr3_dq_oe; \
 \
wire [13:0]ddr3_addr_out; \
 \
wire [1:0]ddr3_dqs_in; \
wire [1:0]ddr3_dqs_out; \
wire ddr3_dqs_oe; \
 \
wire ddr3_ck_out; \
wire ddr3_ck_oe; \
 \
wire ddr3_odt_out; \
 \
wire [2:0]ddr3_ba_out; \
 \
wire ddr3_cke_out; \
 \
wire ddr3_ras_out; \
 \
wire ddr3_cas_out; \
 \
wire ddr3_we_out; \
 \
wire ddr3_cs_out; \
 \
wire ddr3_reset_out; \
 \
OBUF #( \
	.DRIVE(12),   // Specify the output drive strength \
	.SLEW("FAST") // Specify the output slew rate \
) OBUF_DM_inst [1:0]( \
	.O(ddr3_dm),     // Buffer output (connect directly to top-level port) \
	.I(ddr3_dm_out)     // Buffer input \
); \
 \
IOBUF #( \
	.DRIVE(12), // Specify the output drive strength \
	.IBUF_LOW_PWR("FALSE"),  // Low Power - "TRUE", High Performance = "FALSE"  \
	.SLEW("FAST") // Specify the output slew rate \
) IOBUF_DQ_inst [15:0]( \
	.O(ddr3_dq_in),     // Buffer output \
	.IO(ddr3_dq),   // Buffer inout port (connect directly to top-level port) \
	.I(ddr3_dq_out),     // Buffer input \
	.T({16{~ddr3_dq_oe}})      // 3-state enable input, high=input, low=output \
); \
 \
OBUF #(.SLEW("FAST")) OBUF_ADDR_inst [13:0]( \
	.O(ddr3_addr),     // Buffer output (connect directly to top-level port) \
	.I(ddr3_addr_out)     // Buffer input \
); \
 \
IOBUFDS #( \
	.DIFF_TERM("TRUE"),     // Differential Termination ("TRUE"/"FALSE") \
	.IBUF_LOW_PWR("FALSE"),   // Low Power - "TRUE", High Performance = "FALSE"  \
	.SLEW("FAST")            // Specify the output slew rate \
) IOBUFDS_DQS_inst [1:0]( \
	.O(ddr3_dqs_in),     // Buffer output \
	.IO(ddr3_dqs_p),   // Diff_p inout (connect directly to top-level port) \
	.IOB(ddr3_dqs_n), // Diff_n inout (connect directly to top-level port) \
	.I(ddr3_dqs_out),     // Buffer input \
	.T({2{~ddr3_dqs_oe}})      // 3-state enable input, high=input, low=output \
); \
 \
OBUFTDS #( \
	.SLEW("FAST")           // Specify the output slew rate \
) OBUFTDS_CK_inst ( \
	.O(ddr3_ck_p),     // Diff_p output (connect directly to top-level port) \
	.OB(ddr3_ck_n),   // Diff_n output (connect directly to top-level port) \
	.I(ddr3_ck_out),     // Buffer input \
	.T(~ddr3_ck_oe)      // 3-state enable input \
); \
 \
OBUF #(.SLEW("FAST")) OBUF_ODT_inst ( \
	.O(ddr3_odt),     // Buffer output (connect directly to top-level port) \
	.I(ddr3_odt_out)     // Buffer input \
); \
 \
OBUF #(.SLEW("FAST")) OBUF_BA_inst [2:0]( \
	.O(ddr3_ba),     // Buffer output (connect directly to top-level port) \
	.I(ddr3_ba_out)     // Buffer input \
); \
 \
OBUF #(.SLEW("FAST")) OBUF_CKE_inst ( \
	.O(ddr3_cke),     // Buffer output (connect directly to top-level port) \
	.I(ddr3_cke_out)     // Buffer input \
); \
 \
OBUF #(.SLEW("FAST")) OBUF_RAS_inst ( \
	.O(ddr3_ras_n),     // Buffer output (connect directly to top-level port) \
	.I(ddr3_ras_out)     // Buffer input \
); \
 \
OBUF #(.SLEW("FAST")) OBUF_CAS_inst ( \
	.O(ddr3_cas_n),     // Buffer output (connect directly to top-level port) \
	.I(ddr3_cas_out)     // Buffer input \
); \
 \
OBUF #(.SLEW("FAST")) OBUF_WE_inst ( \
	.O(ddr3_we_n),     // Buffer output (connect directly to top-level port) \
	.I(ddr3_we_out)     // Buffer input \
); \
 \
OBUF #(.SLEW("FAST")) OBUF_CS_inst ( \
	.O(ddr3_cs_n),     // Buffer output (connect directly to top-level port) \
	.I(ddr3_cs_out)     // Buffer input \
); \
 \
OBUF #(.SLEW("FAST")) OBUF_RESET_inst ( \
	.O(ddr3_reset_n),     // Buffer output (connect directly to top-level port) \
	.I(ddr3_reset_out)     // Buffer input \
);

`define DDR3_CONNECT \
	.rst(rst), \
	.clk(clk_int), \
	.clk90(clk90_int), \
	.clkdiv(clkdiv_int), \
	 \
	.ddr3_dm_out(ddr3_dm_out), \
	 \
	.ddr3_dq_in(ddr3_dq_in), \
	.ddr3_dq_out(ddr3_dq_out), \
	.ddr3_dq_oe(ddr3_dq_oe), \
	 \
	.ddr3_addr_out(ddr3_addr_out), \
	 \
	.ddr3_dqs_in(ddr3_dqs_in), \
	.ddr3_dqs_out(ddr3_dqs_out), \
	.ddr3_dqs_oe(ddr3_dqs_oe), \
	 \
	.ddr3_ck_out(ddr3_ck_out), \
	.ddr3_ck_oe(ddr3_ck_oe), \
	 \
	.ddr3_odt_out(ddr3_odt_out), \
	 \
	.ddr3_ba_out(ddr3_ba_out), \
	 \
	.ddr3_cke_out(ddr3_cke_out), \
	 \
	.ddr3_ras_out(ddr3_ras_out), \
	 \
	.ddr3_cas_out(ddr3_cas_out), \
	 \
	.ddr3_we_out(ddr3_we_out), \
	 \
	.ddr3_cs_out(ddr3_cs_out), \
	 \
	.ddr3_reset_out(ddr3_reset_out)

