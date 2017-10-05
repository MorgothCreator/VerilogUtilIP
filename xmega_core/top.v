/*
 * This IP is the top of Atmel XMEGA CPU implementation.
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

`define BUS_ADDR_PGM_LEN	11 /* < in 16-bit instructions */
`define BUS_ADDR_DATA_LEN	8  /* < in bytes */

module top(
	input rst,
	input clk,
	output reg [2:0]RGB0,
	output reg [2:0]RGB1,
	output reg [2:0]RGB2,
	output reg [2:0]RGB3,
	output reg [3:0]LED,
	input [3:0]SW,
	input [3:0]BTN
	
	);
	

//wire pgm_re;
wire [`BUS_ADDR_PGM_LEN-1:0] pgm_addr;
wire [15:0] pgm_data;
wire data_re;
wire data_we;
wire [`BUS_ADDR_DATA_LEN-1:0] data_addr;
wire [7:0]data_in;
wire [7:0]data_out;

wire io_re;
wire io_we;
wire [5:0] io_addr;
wire [7:0] io_out;
wire [7:0] io_in;


wire core_clk;
wire CLKOUT1;
wire CLKOUT2;
wire CLKOUT3;
wire CLKOUT4;
wire CLKOUT5;
wire CLKFB;
wire LOCKED;

   PLLE2_BASE #(
      .BANDWIDTH("OPTIMIZED"),  // OPTIMIZED, HIGH, LOW
      .CLKFBOUT_MULT(10),        // Multiply value for all CLKOUT, (2-64)
      .CLKFBOUT_PHASE(0.0),     // Phase offset in degrees of CLKFB, (-360.000-360.000).
      .CLKIN1_PERIOD(10.0),      // Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
      // CLKOUT0_DIVIDE - CLKOUT5_DIVIDE: Divide amount for each CLKOUT (1-128)
      .CLKOUT0_DIVIDE(20),
      .CLKOUT1_DIVIDE(1),
      .CLKOUT2_DIVIDE(1),
      .CLKOUT3_DIVIDE(1),
      .CLKOUT4_DIVIDE(1),
      .CLKOUT5_DIVIDE(1),
      // CLKOUT0_DUTY_CYCLE - CLKOUT5_DUTY_CYCLE: Duty cycle for each CLKOUT (0.001-0.999).
      .CLKOUT0_DUTY_CYCLE(0.5),
      .CLKOUT1_DUTY_CYCLE(0.5),
      .CLKOUT2_DUTY_CYCLE(0.5),
      .CLKOUT3_DUTY_CYCLE(0.5),
      .CLKOUT4_DUTY_CYCLE(0.5),
      .CLKOUT5_DUTY_CYCLE(0.5),
      // CLKOUT0_PHASE - CLKOUT5_PHASE: Phase offset for each CLKOUT (-360.000-360.000).
      .CLKOUT0_PHASE(0.0),
      .CLKOUT1_PHASE(0.0),
      .CLKOUT2_PHASE(0.0),
      .CLKOUT3_PHASE(0.0),
      .CLKOUT4_PHASE(0.0),
      .CLKOUT5_PHASE(0.0),
      .DIVCLK_DIVIDE(1),        // Master division value, (1-56)
      .REF_JITTER1(0.0),        // Reference input jitter in UI, (0.000-0.999).
      .STARTUP_WAIT("FALSE")    // Delay DONE until PLL Locks, ("TRUE"/"FALSE")
   )
   PLLE2_BASE_inst (
      // Clock Outputs: 1-bit (each) output: User configurable clock outputs
      .CLKOUT0(core_clk),   // 1-bit output: CLKOUT0
      .CLKOUT1(CLKOUT1),   // 1-bit output: CLKOUT1
      .CLKOUT2(CLKOUT2),   // 1-bit output: CLKOUT2
      .CLKOUT3(CLKOUT3),   // 1-bit output: CLKOUT3
      .CLKOUT4(CLKOUT4),   // 1-bit output: CLKOUT4
      .CLKOUT5(CLKOUT5),   // 1-bit output: CLKOUT5
      // Feedback Clocks: 1-bit (each) output: Clock feedback ports
      .CLKFBOUT(CLKFB), // 1-bit output: Feedback clock
      .LOCKED(LOCKED),     // 1-bit output: LOCK
      .CLKIN1(clk),     // 1-bit input: Input clock
      // Control Ports: 1-bit (each) input: PLL control ports
      .PWRDWN(1'b0),     // 1-bit input: Power-down
      .RST(~rst),           // 1-bit input: Reset
      // Feedback Clocks: 1-bit (each) input: Clock feedback ports
      .CLKFBIN(CLKFB)    // 1-bit input: Feedback clock
   );


rom  #(
.bus_addr_pgm_width(`BUS_ADDR_PGM_LEN),
.rom_path("core1ROM.mem")
)rom(
	.pmem_a(pgm_addr),
	.pmem_d(pgm_data)
	
);

ram  #(
.bus_addr_data_width(`BUS_ADDR_DATA_LEN),
.ram_path("NONE")
)ram(
	.dmem_re(data_re),
	.dmem_we(data_we),
	.dmem_a(data_addr),
	.dmem_r(data_in),
	.dmem_w(data_out)
);

reg [7:0]out_led;
wire io_select_0 = (io_addr == 0 & (io_we | io_re)) ? 1'b1:1'b0;

always @ (*)
begin
	if(io_select_0 & io_we)
		{LED, RGB0[1], RGB1[1], RGB2[1], RGB3[1]} <= io_out;
end

assign io_in = (io_re & io_select_0) ? {BTN, SW} : 8'bz; // 

reg RST = 0;

initial begin
	RST = 0;
	#1;
	RST = 1;
	#1000;
	$finish;
end

mega_core #(
.bus_addr_pgm_width(`BUS_ADDR_PGM_LEN),
.bus_addr_data_width(`BUS_ADDR_DATA_LEN)
)core(
	.rst(~rst),
	.clk(core_clk),
	
	//.pgm_re(1'b1),
	.pgm_addr(pgm_addr),
	.pgm_data(pgm_data),
	
	.data_re(data_re),
	.data_we(data_we),
	.data_addr(data_addr),
	.data_in(data_in),
	.data_out(data_out),
	
	.io_re(io_re),
	.io_we(io_we),
	.io_addr(io_addr),
	.io_out(io_out),
	.io_in(io_in)
);

endmodule
