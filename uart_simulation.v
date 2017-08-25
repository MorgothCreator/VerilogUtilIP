`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/14/2017 05:30:05 PM
// Design Name: 
// Module Name: simulation
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


module simulation(
    );

reg	clk_in	=	0;
reg	clk_out	=	0;

wire [8:0]data_rec;
reg [8:0]data_send;

reg	[2:0]clk	=	3'b000;/*	Peripheral	clock/not	necessary	to	be	core	clock,	the	core	clock	can	be	different	(input)	*/
wire rst;/*	Asynchronus	reset,	is	mandatory	to	provide	this	signal,	active	on	posedge	(input)	*/
reg	_rst = 0;
wire txen;
reg _txen = 0;
wire rxen;
reg _rxen = 0;
wire wr;/*	Send	data,	asynchronus	with	'clk'	,	active	on	posedge	or	negedge(input)	*/
reg	_wr	= 0;
wire rd;/*	Read	data,	,	asynchronus	with	'clk'	,	active	on	posedge	or	negedge	(input)	*/
reg	_rd	= 0;
wire buffempty;/*	'1'	if	transmit	buffer	is	empty	(output)	*/
wire charreceived;/*	Is	set	to	'1'	if	a	character	is	received,	if	you	read	the	receive	buffe	this	bit	will	go	'0',	if	you	ignore	it	and	continue	to	send	data	this	bit	will	remain	'1'	until	you	read	the	read	register	(output)	*/
reg	[3:0]wordlen;/*0=6bit, 1=7bit, 2=8bit, 3=9bit*/
wire rx;
wire tx;
reg u2x = 0;
wire [1:0]parity;
reg [1:0]_parity = 0;
reg stopbits = 0;
reg mode = 0;
wire receiveoverrun;

//uart uart0(
//	.clk(clk[2]),/*	Peripheral	clock/not	necessary	to	be	core	clock,	the	core	clock	can	be	different	(input)	*/
//	.rst(rst),/*	Asynchronus	reset,	is	mandatory	to	provide	this	signal,	active	on	posedge	(input)	*/
//	.txen(txen),
//	.rxen(rxen),
//	.data_in(data_send),/*	In/	data(input)	*/
//	.data_out(data_rec),/*	Out	data(output)	*/
//	.wr(wr),/*	Send	data,	asynchronus	with	'clk'	,	active	on	posedge	or	negedge(input)	*/
//	.rd(rd),/*	Read	data,	,	asynchronus	with	'clk'	,	active	on	posedge	or	negedge	(input)	*/
//	.buffempty(buffempty),/*	'1'	if	transmit	buffer	is	empty	(output)	*/
//	.prescaller(2),/*	The	prescaller	divider	is	=	(1	<<	prescaller)	value	between	0	and	7	for	dividers	by:1,2,4,8,16,32,64,128	and	256	(input)*/
//	.charreceived(charreceived),/*	Is	set	to	'1'	if	a	character	is	received,	if	you	read	the	receive	buffe	this	bit	will	go	'0',	if	you	ignore	it	and	continue	to	send	data	this	bit	will	remain	'1'	until	you	read	the	read	register	(output)	*/
//	.wordlen(wordlen),
//	.rx(rx),
//	.tx(tx),
//	.u2x(u2x),
//	.parity(parity),
//	.stopbits(stopbits),
//	.mode(mode),
//	.receiveoverrun(receiveoverrun)
//);

uart_tx uart_tx0(
	.clk(clk[2]),/*	Peripheral	clock/not	necessary	to	be	core	clock,	the	core	clock	can	be	different	(input)	*/
	.rst(rst),/*	Asynchronus	reset,	is	mandatory	to	provide	this	signal,	active	on	posedge	(input)	*/
	.txen(txen),
	.data(data_send),/*	In/	data(input)	*/
	.wr(wr),/*	Send	data,	asynchronus	with	'clk'	,	active	on	posedge	or	negedge(input)	*/
	.buffempty(buffempty),/*	'1'	if	transmit	buffer	is	empty	(output)	*/
	.wordlen(wordlen),/* 0 = 8bit, 1 = 5bit, 2 = 6bit, 3 = 7bit, 4 = 9bit, 5-6-7 = 8bit */
	.tx(tx),/* Tx pin */
	.u2x(u2x),/* Double speed */
	.parity(parity),/* Parity type: 0 = none, 1 = even, 2 = odd (Not implemented yet) */
	.stopbits(stopbits),/* Number of stop bits: 0 = one stop bit, 1 = Two stop bits */
	.mode(1'b0)/*0 = Asysnhronous, 1 = Synchronous*/
);

uart_rx uart_rx0(
	.clk(clk[2]),/*	Peripheral	clock/not	necessary	to	be	core	clock,	the	core	clock	can	be	different	(input)	*/
	.rst(rst),/*	Asynchronus	reset,	is	mandatory	to	provide	this	signal,	active	on	posedge	(input)	*/
	.rxen(rxen),
	.data(data_rec),/*	Out	data(output)	*/
	.rd(rd),/*	Read	data,	,	asynchronus	with	'clk'	,	active	on	posedge	or	negedge	(input)	*/
	.charreceived(charreceived),/*	Is	set	to	'1'	if	a	character	is	received,	if	you	read	the	receive	buffe	this	bit	will	go	'0',	if	you	ignore	it	and	continue	to	send	data	this	bit	will	remain	'1'	until	you	read	the	read	register	(output)	*/
	.wordlen(wordlen),/* 0 = 8bit, 1 = 5bit, 2 = 6bit, 3 = 7bit, 4 = 9bit, 5-6-7 = 8bit */
	.rx(rx),/* Rx pin */
	.u2x(u2x),/* Double speed */
	.parity(parity),/* Parity type: 0 = none, 1 = even, 2 = odd (Not implemented yet) */
	.stopbits(stopbits),/* Number of stop bits: 0 = one stop bit, 1 = Two stop bits */
	.mode(1'b0),/*0 = Asysnhronous, 1 = Synchronous*/
	.frameerror(frameerror),/* If stop bit is not detected a frame error will report, this is actualized every received byte. */
	.parityerror(parityerror),/* Parity error bit report (Not implemented yet) */
	.receiveoverrun(receiveoverrun)/* If receive buffer is full and another char is received a receiveoverrun will report, this bit is resetted on read. */
);

parameter	tck	=	2;	///<	clock	tick
				
always	#(tck/2)	clk_in	<=	~clk_in;	//	clocking	device

initial begin
	#1;
	_rst <= 1;
	#2;
	_rst <= 0;
	wordlen = 8;
	stopbits = 0;
	_parity = 2'b00;
	mode = 0;
	u2x = 1'b0;
	#1;
	_txen = 1'b1;
	_rxen = 1'b1;
	#1;
	data_send = 8'h55;
	#1;
	_wr = 1'b1;
	#1;
	_wr = 1'b0;
	#1;
	wait(charreceived	==	1);
	#1;
	_rd = 1'b1;
	#1;
	_rd = 1'b0;
	wait(buffempty	==	1);
	data_send = 8'hAA;
	#1;
	_wr = 1'b1;
	#1;
	_wr = 1'b0;
	#1;
	data_send = 8'h00;
	wait(charreceived	==	1);
	//wait(receiveoverrun	==	1);
	#1;
	_rd = 1'b1;
	#1;
	_rd = 1'b0;
	#100;
	$finish;
end

assign rx = tx;

assign parity = _parity;
assign	rst	=	_rst;
assign	txen	=	_txen;
assign	rxen	=	_rxen;
assign	wr	=	_wr;
assign	rd	=	_rd;

always	@	(posedge	clk_in)
begin
	clk	<=	clk	+	1;
end

endmodule
