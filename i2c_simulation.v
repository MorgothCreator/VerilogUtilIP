`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/30/2017 06:53:38 PM
// Design Name: 
// Module Name: simulate
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


module	simulate(

);

	wire rst;
	reg	_rst = 0;
	//wire	[7:0]data;
	reg	[7:0]_datasend;
	wire [7:0]_datarec;	
	wire wr;
	reg	_wr	= 0;
	wire rd;
	reg	_rd	= 0;
	wire buffempty;
	reg	dirsend	= 0;
	wire scl;
	wire sda;
	wire senderr;
	reg	res_senderr	= 0;
	wire chartransferred;
	wire ack;
	reg	sendstart = 0;
	wire arbitrationlost;


	wire busy;
	reg	[2:0]clk = 3'b000;
				
	reg	clk_in = 0;
	parameter tck = 2;	///<	clock	tick
				
	always	#(tck/2) clk_in <= ~clk_in;	//	clocking	device
				
	i2c_master  i2c0 (
		.clk(clk[2]),
		.rst(rst),
		.dataIn(_datasend),
		.dataOut(_datarec),
		.wr(wr),
		.rd(rd),
		.buffempty(buffempty),
		.prescaller(3'h0),
		.dirsend(dirsend),
		.scl(scl),
		.sda(sda),
        .senderr(senderr),
		.res_senderr(res_senderr),
		.chartransferred(chartransferred),
		.ack(ack),
		.resendstart(sendstart),
		.arbitrationlost(arbitrationlost)
);
				
initial	begin
	_rst <= 1;
	#2;
	_rst <= 0;
	#2;
	sendstart = 1'b0;
	/* Set unit to transmitter. */
	dirsend = 1'b1;
	/* Put one char to the buffer. */
	_datasend <= 8'h55;
	/*	Wait half core clock for propagation*/
	#1;
	_wr <= 1'b1;
	#1;
	_wr <= 1'b0;
	/*
	 * Wait buffer to become empty, after this you can send another char to maintain buffer full
	 *  This don't mather because the buffer is allready transferred to shift register, the buffer is empty.
	 */
	wait(buffempty == 1);
	/*
	 * This start is not aplyed to first char, will be applyed to second char because the buffer has already transferred to shift register.
	 * After sending first char the unit will resend the start sequency.
	 */
	sendstart = 1'b1;
	#1;
	sendstart = 1'b0;
	/*
	 * Put second char to buffer.
	 */
	_datasend <= 8'hAA;
	/*	Wait half core clock for propagation*/
	#1;
	_wr <= 1'b1;
	#1;
	_wr <= 1'b0;
	/*
	 * We put second char to buffer, now the buffer is full, we wait to become empty to put another char to buffer.
	 */
	wait(buffempty == 1);
	/*	Wait half core clock */
	#1;
	/*
	 * Assert 'rd'.
	 * This read is made for simulatio, w don't use the read char because is already put on _datarec.
	 */
	_rd = 1'b1;
	/*
	 * Wait half core clock for propagation.
	 */
	#1;
	_rd = 1'b0;
	/*
	 * Wait buffer to become empty, after this you can send another char to maintain buffer full.
	 */
	wait(buffempty == 1);
	/*
	 * Wait the second char to be transferred, now because the buffer is empty, the unit will automatically send stop sequency.
	 */
	wait(chartransferred == 1);
	/*
	 * Put the device to reception mode, the mode will be applied only at beginning of next send/receive byte.
	 */
	dirsend = 1'b0;
	/*
	 * This is a dummy byte only used for debug where even in receive mode will transmit.
	 * The unit is made in same wy that in debug mode will transmit even if is in receive mode.
	 * In implementation you need to comment the "`define	I2C_DEBUG" on module.
	 */
	_datasend <= 8'h55;
	#1;
	/*
	 * In receive mode, to receive a byte you can emulate a send sequency because at base will work like send sequency, 
	 * you need to maintain send buffer full in order to receive bytes without sending stop sequency, 
	 * when send buffer is empty the stop sequency is send automatically.
	 */
	_wr <= 1'b1;
	#1;
	_wr <= 1'b0;
	#1;
	/* Assert 'rd' */
	_rd	= 1'b1;
	/*	Wait half core clock for propagation	*/
	#1;
	_rd	= 1'b0;
	/* Wait half core clock for propagation*/
	wait(chartransferred == 1);/* Wait the byte to be received, because the send buffer is empty the unit wil automatically send the stop sequency */
	/* Put 'data' to tri state */
	_datasend =	8'bz;
	/* Wait	half core clock	*/
	#1;
	/*	Assert	'rd'	*/
	_rd	= 1'b1;
	/* Wait half core clock for propagation	*/
	#1;
	/* Read data into '_datarec' register	*/
	_rd	=	1'b0;
	#500;
	$finish;
end
				
assign rst = _rst;
assign wr = _wr;
assign rd = _rd;
assign data = _datasend;

always @ (posedge clk_in)
begin
	clk <= clk + 1;
end
endmodule

