`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 03/11/2017 07:10:16 PM
// Design Name:
// Module Name: main
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module main(
	input CLK100MHZ,
	input btnc,
	input uart_tx_in,
	output uart_rx_out,
	input [7:0]sw,
	output reg [7:0]led,
	output [7:0]ja
    );
reg txen;
reg rxen;

wire [8:0]data_rec;
wire [8:0]data_send;
reg wr;
reg rd;
wire buffempty;
wire charreceived;
wire receiveoverrun;
wire frameerror;
wire parityerror;

wire	[15:0]prescaller_cnt;

parameter PRESCALLER	=	(450000000/1000000/16) - 1;

wire uart_clk;

wire clk_pll_0;
wire clk_pll_1;
wire clk_pll_2;
wire clk_pll_3;
wire clk_pll_4;
wire clk_pll_5;
assign uart_clk = (PRESCALLER) ? ((prescaller_cnt < (PRESCALLER >> 1)) ? 1'b1:1'b0):clk_pll_0; // If prescaller != 0 generate a ~50% clk wavwform.
wire PLL1_FEEDBACK;
   PLLE2_BASE #(
      .BANDWIDTH("OPTIMIZED"),  // OPTIMIZED, HIGH, LOW
      .CLKFBOUT_MULT(9),        // Multiply value for all CLKOUT, (2-64)
      .CLKFBOUT_PHASE(0.0),     // Phase offset in degrees of CLKFB, (-360.000-360.000).
      .CLKIN1_PERIOD(10.0),      // Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
      // CLKOUT0_DIVIDE - CLKOUT5_DIVIDE: Divide amount for each CLKOUT (1-128)
      .CLKOUT0_DIVIDE(2),
      .CLKOUT1_DIVIDE(4),
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
      .CLKOUT0(clk_pll_0),   // 1-bit output: CLKOUT0
      .CLKOUT1(clk_pll_1),   // 1-bit output: CLKOUT1
      .CLKOUT2(clk_pll_2),   // 1-bit output: CLKOUT2
      .CLKOUT3(clk_pll_3),   // 1-bit output: CLKOUT3
      .CLKOUT4(clk_pll_4),   // 1-bit output: CLKOUT4
      .CLKOUT5(clk_pll_5),   // 1-bit output: CLKOUT5
      // Feedback Clocks: 1-bit (each) output: Clock feedback ports
      .CLKFBOUT(PLL1_FEEDBACK), // 1-bit output: Feedback clock
      //.LOCKED(LOCKED),     // 1-bit output: LOCK
      .CLKIN1(CLK100MHZ),     // 1-bit input: Input clock
      // Control Ports: 1-bit (each) input: PLL control ports
      .PWRDWN(btnc),     // 1-bit input: Power-down
      .RST(btnc),           // 1-bit input: Reset
      // Feedback Clocks: 1-bit (each) input: Clock feedback ports
      .CLKFBIN(PLL1_FEEDBACK)    // 1-bit input: Feedback clock
   );


`define CNT_ASYNC(rst, clk, lath, load, value) \
always @ (posedge clk) \
begin \
	if(load) lath <= value; \
	else lath <= ~lath; \
end

wire prescaler_load;

cnt_async_dn_rst_ld # (
	.SIZE(16))
prescaller(
	.rst(btnc),
	.clk(clk_pll_0),
	.load(prescaler_load),
	.value(PRESCALLER),
	.cnt(prescaller_cnt)
);

assign prescaler_load = (prescaller_cnt == 0);

uart_tx uart_tx0(
	.clk(uart_clk),/*	Peripheral	clock (uart_clk/8) = brate if u2x = 1 or (uart_clk/16) = brate if u2x = 0	(input)	*/
	.rst(btnc),/*	Asynchronus	reset,	is	mandatory	to	provide	this	signal,	active	on	posedge	(input)	*/
	.txen(txen),
	.data(data_send),/*	In/	data(input)	*/
	.wr(wr),/*	Send	data,	asynchronus	with	'clk'	,	active	on	posedge	or	negedge(input)	*/
	.buffempty(buffempty),/*	'1'	if	transmit	buffer	is	empty	(output)	*/
	.wordlen(4'd8),/* 0 = 5bit, 1 = 6bit, 2 = 7bit, 3 = 8bit, 4 = 9bit, 5-6-7 = reserved */
	.tx(uart_rx_out),/* Tx pin */
	.u2x(1'b0),/* Double speed */
	.parity(2'd1),/* Parity type: 0 = none, 1 = even, 2 = odd (Not implemented yet) */
	.stopbits(1'b0),/* Number of stop bits: 0 = one stop bit, 1 = Two stop bits */
	.mode(1'b0)/*0 = Asysnhronous, 1 = Synchronous*/
);

uart_rx uart_rx0(
	.clk(uart_clk),/*	Peripheral	clock (uart_clk/8) = brate if u2x = 1 or (uart_clk/16) = brate if u2x = 0	(input)	*/
	.rst(btnc),/*	Asynchronus	reset,	is	mandatory	to	provide	this	signal,	active	on	posedge	(input)	*/
	.rxen(rxen), 
	.data(data_rec),/*	Out	data(output)	*/
	.rd(rd),/*	Read	data,	,	asynchronus	with	'clk'	,	active	on	posedge	or	negedge	(input)	*/
	.charreceived(charreceived),/*	Is	set	to	'1'	if	a	character	is	received,	if	you	read	the	receive	buffe	this	bit	will	go	'0',	if	you	ignore	it	and	continue	to	send	data	this	bit	will	remain	'1'	until	you	read	the	read	register	(output)	*/
	.wordlen(4'd8),/* 0 = 5bit, 1 = 6bit, 2 = 7bit, 3 = 8bit, 4 = 9bit, 5-6-7 = reserved */
	.rx(uart_tx_in),/* Rx pin */
	.u2x(1'b0),/* Double speed */
	.parity(2'd1),/* Parity type: 0 = none, 1 = even, 2 = odd (Not implemented yet) */
	.stopbits(1'b0),/* Number of stop bits: 0 = one stop bit, 1 = Two stop bits */
	.mode(1'b0),/*0 = Asysnhronous, 1 = Synchronous*/
	.frameerror(frameerror),/* If stop bit is not detected a frame error will report, this is actualized every received byte. */
	.parityerror(parityerror),/* Parity error bit report (Not implemented yet) */
	.receiveoverrun(receiveoverrun)/* If receive buffer is full and another char is received a receiveoverrun will report, this bit is resetted on read. */
);


always @ (posedge uart_clk)
begin
	if(btnc)
		led[0] <= 1'b0;
	else
		if(frameerror)
			led[0] <= 1'b1;
end

always @ (posedge uart_clk)
begin
	if(btnc)
		led[1] <= 1'b0;
	else
		if(receiveoverrun)
			led[1] <= 1'b1;
end

always @ (posedge uart_clk)
begin
	if(btnc)
		led[2] <= 1'b0;
	else
		//if(parityerror)
			led[2] <= parityerror;
end

reg [2:0]cnt = 0;
reg [1:0]start_cnt = 0;

initial begin
end

reg [25:0]sequence_count;
reg [8:0]temp_chars;  

`define ORDER_TO_TYME(order)   \
    26'h2000000 + (order * 26'h0000010)

parameter rom_char_end = `ORDER_TO_TYME(94); 

`define SEND_CHAR(char_nr, char) \
	char_nr:\
		begin\
			temp_chars <= char;\
			sequence_count <= sequence_count + 26'h00000001;\
		end\
		char_nr + 1:\
		begin\
			wr <= 1'b1;\
			sequence_count <= sequence_count + 26'h00000001;\
		end\
		char_nr + 2:\
		begin\
			wr <= 1'b0;\
			sequence_count <= sequence_count + 26'h00000001;\
		end\
		char_nr + 3:\
		begin\
			if(buffempty)\
				sequence_count <= char_nr + 26'h00000010;\
		end

always @ (posedge clk_pll_1 or posedge btnc)
begin
	if(btnc)
	begin
		wr <= 1'b0;
		start_cnt <= 2'h0;
		cnt <= 3'h2;
		//led <= 8'h00;
		sequence_count <= 32'h0;
		txen <= 1'b0;
        rxen <= 1'b0;
	end
	else
	begin
		case(start_cnt)
			2'h0:
			begin
				txen <= 1'b0;
				rxen <= 1'b0;
				start_cnt <= 2'h1;
			end
			2'h1:
			begin
				txen <= 1'b1;
				rxen <= 1'b1;
				start_cnt <= 2'h2;
			end
		endcase
			
		if(sequence_count >= rom_char_end)
		begin
			if(charreceived && cnt == 3'h02)
			begin
				cnt <= 3'h00;
			end
			else
			begin
				case(cnt)
                    3'h00:
                    begin
				        //led <= data_rec;
                        wr <= 1'b1;
                        rd <= 1'b1;
                        cnt <= 3'h01;
                    end
                    3'h01:
                    begin
                        wr <= 1'b0;
                        rd <= 1'b0;
                        cnt <= 3'h02;
                    end
				endcase
			end
		end
		else
		begin
			if(sequence_count < `ORDER_TO_TYME(0))
			begin
				sequence_count <= sequence_count + 11'h001;
			end
			else
			begin
				case (sequence_count)
				`SEND_CHAR(`ORDER_TO_TYME(0), "G")
				`SEND_CHAR(`ORDER_TO_TYME(1), "o")
				`SEND_CHAR(`ORDER_TO_TYME(2), "o")
				`SEND_CHAR(`ORDER_TO_TYME(3), "d")
				`SEND_CHAR(`ORDER_TO_TYME(4), " ")
				`SEND_CHAR(`ORDER_TO_TYME(5), "m")
				`SEND_CHAR(`ORDER_TO_TYME(6), "o")
				`SEND_CHAR(`ORDER_TO_TYME(7), "r")
				`SEND_CHAR(`ORDER_TO_TYME(8), "n")
				`SEND_CHAR(`ORDER_TO_TYME(9), "i")
				`SEND_CHAR(`ORDER_TO_TYME(10), "n")
				`SEND_CHAR(`ORDER_TO_TYME(11), "g")
				`SEND_CHAR(`ORDER_TO_TYME(12), "\r")
				`SEND_CHAR(`ORDER_TO_TYME(13), "T")
				`SEND_CHAR(`ORDER_TO_TYME(14), "h")
				`SEND_CHAR(`ORDER_TO_TYME(15), "i")
				`SEND_CHAR(`ORDER_TO_TYME(16), "s")
				`SEND_CHAR(`ORDER_TO_TYME(17), " ")
				`SEND_CHAR(`ORDER_TO_TYME(18), "i")
				`SEND_CHAR(`ORDER_TO_TYME(19), "s")
				`SEND_CHAR(`ORDER_TO_TYME(20), " ")
				`SEND_CHAR(`ORDER_TO_TYME(21), "a")
				`SEND_CHAR(`ORDER_TO_TYME(22), "n")
				`SEND_CHAR(`ORDER_TO_TYME(23), " ")
				`SEND_CHAR(`ORDER_TO_TYME(24), "e")
				`SEND_CHAR(`ORDER_TO_TYME(25), "x")
				`SEND_CHAR(`ORDER_TO_TYME(26), "a")
				`SEND_CHAR(`ORDER_TO_TYME(27), "m")
				`SEND_CHAR(`ORDER_TO_TYME(28), "p")
				`SEND_CHAR(`ORDER_TO_TYME(29), "l")
				`SEND_CHAR(`ORDER_TO_TYME(30), "e")
				`SEND_CHAR(`ORDER_TO_TYME(31), " ")
				`SEND_CHAR(`ORDER_TO_TYME(32), "o")
				`SEND_CHAR(`ORDER_TO_TYME(33), "f")
				`SEND_CHAR(`ORDER_TO_TYME(34), " ")
				`SEND_CHAR(`ORDER_TO_TYME(35), "a")
				`SEND_CHAR(`ORDER_TO_TYME(36), " ")
				`SEND_CHAR(`ORDER_TO_TYME(37), "u")
				`SEND_CHAR(`ORDER_TO_TYME(38), "a")
				`SEND_CHAR(`ORDER_TO_TYME(39), "r")
				`SEND_CHAR(`ORDER_TO_TYME(40), "t")
				`SEND_CHAR(`ORDER_TO_TYME(41), " ")
				`SEND_CHAR(`ORDER_TO_TYME(42), "h")
				`SEND_CHAR(`ORDER_TO_TYME(43), "a")
				`SEND_CHAR(`ORDER_TO_TYME(44), "r")
				`SEND_CHAR(`ORDER_TO_TYME(45), "d")
				`SEND_CHAR(`ORDER_TO_TYME(46), "w")
				`SEND_CHAR(`ORDER_TO_TYME(47), "a")
				`SEND_CHAR(`ORDER_TO_TYME(48), "r")
				`SEND_CHAR(`ORDER_TO_TYME(49), "e")
				`SEND_CHAR(`ORDER_TO_TYME(50), " ")
				`SEND_CHAR(`ORDER_TO_TYME(51), "m")
				`SEND_CHAR(`ORDER_TO_TYME(52), "o")
				`SEND_CHAR(`ORDER_TO_TYME(53), "d")
				`SEND_CHAR(`ORDER_TO_TYME(54), "u")
				`SEND_CHAR(`ORDER_TO_TYME(55), "l")
				`SEND_CHAR(`ORDER_TO_TYME(56), "e")
				`SEND_CHAR(`ORDER_TO_TYME(57), " ")
				`SEND_CHAR(`ORDER_TO_TYME(58), "t")
				`SEND_CHAR(`ORDER_TO_TYME(59), "h")
				`SEND_CHAR(`ORDER_TO_TYME(60), "a")
				`SEND_CHAR(`ORDER_TO_TYME(61), "t")
				`SEND_CHAR(`ORDER_TO_TYME(62), " ")
				`SEND_CHAR(`ORDER_TO_TYME(63), "e")
				`SEND_CHAR(`ORDER_TO_TYME(64), "c")
				`SEND_CHAR(`ORDER_TO_TYME(65), "h")
				`SEND_CHAR(`ORDER_TO_TYME(66), "o")
				`SEND_CHAR(`ORDER_TO_TYME(67), " ")
				`SEND_CHAR(`ORDER_TO_TYME(68), "t")
				`SEND_CHAR(`ORDER_TO_TYME(69), "h")
				`SEND_CHAR(`ORDER_TO_TYME(70), "e")
				`SEND_CHAR(`ORDER_TO_TYME(71), " ")
				`SEND_CHAR(`ORDER_TO_TYME(72), "r")
				`SEND_CHAR(`ORDER_TO_TYME(73), "e")
				`SEND_CHAR(`ORDER_TO_TYME(74), "c")
				`SEND_CHAR(`ORDER_TO_TYME(75), "e")
				`SEND_CHAR(`ORDER_TO_TYME(76), "i")
				`SEND_CHAR(`ORDER_TO_TYME(77), "v")
				`SEND_CHAR(`ORDER_TO_TYME(78), "e")
				`SEND_CHAR(`ORDER_TO_TYME(79), "d")
				`SEND_CHAR(`ORDER_TO_TYME(80), " ")
				`SEND_CHAR(`ORDER_TO_TYME(81), "c")
				`SEND_CHAR(`ORDER_TO_TYME(82), "h")
				`SEND_CHAR(`ORDER_TO_TYME(83), "a")
				`SEND_CHAR(`ORDER_TO_TYME(84), "r")
				`SEND_CHAR(`ORDER_TO_TYME(85), "s")
				`SEND_CHAR(`ORDER_TO_TYME(86), " ")
				`SEND_CHAR(`ORDER_TO_TYME(87), "b")
				`SEND_CHAR(`ORDER_TO_TYME(88), "a")
				`SEND_CHAR(`ORDER_TO_TYME(89), "c")
				`SEND_CHAR(`ORDER_TO_TYME(90), "k")
				`SEND_CHAR(`ORDER_TO_TYME(91), ".")
				`SEND_CHAR(`ORDER_TO_TYME(92), "\r")
				`SEND_CHAR(`ORDER_TO_TYME(93), "\r")
				endcase
			end
		end
	end
end

assign data_send = (sequence_count >= rom_char_end) ? data_rec : temp_chars;

endmodule