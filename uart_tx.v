`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/21/2017 02:54:54 PM
// Design Name: 
// Module Name: uart_tx
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


module uart_tx(
		input	clk,/*	Peripheral clock/will be provided from a prescaller, no need to be 50% waveform (input)	*/
		input	rst,/*	Asynchronus	reset,	is	mandatory	to	provide	this	signal,	active	on	posedge	(input)	*/
		input	txen,
		input	[8:0]data,/*	In data(input)	*/
		input	wr,/*	Send	data,	asynchronus	with	'clk'	,	active	on	posedge	or	negedge(input)	*/
		output	buffempty,/*	'1'	if	transmit	buffer	is	empty	(output)	*/
		input	[3:0]wordlen,/* In bits */
		output	reg	tx,/* Tx pin */
		inout	sck,/* Synchronous clk pin (Not implemented yet) */
		input u2x,/* Double speed */
		input [1:0]parity,/* Parity type: 0 = none, 1 = even, 2 = odd (Not implemented yet) */
		input stopbits,/* Number of stop bits: 0 = one stop bit, 1 = Two stop bits */
		input mode/*0 = Asysnhronous, 1 = Synchronous*/
    );

parameter MAX_WORD_LEN = 9;
parameter	state_idle	=	1'b0;
parameter	state_busy	=	1'b1;

reg	state_tx;
reg	[(MAX_WORD_LEN - 1) + 4:0]shift_reg_out;
reg	[MAX_WORD_LEN - 1:0]input_buffer;

reg	inbufffullp;
reg	inbufffulln;

reg	[3:0]sckint_tx;
reg	[3:0]bitcount_tx;
reg [3:0]total_word_len_tx;

wire _chk_int;
wire chk_int;
reg [(MAX_WORD_LEN - 1) + 4:0]parity_mask;
wire [(MAX_WORD_LEN - 1) + 4:0]parity_rest;

always @ (*)
begin
	case(wordlen)
		4'h05: parity_mask <= 12'b000000111110;
		4'h06: parity_mask <= 12'b000001111110;
		4'h07: parity_mask <= 12'b000011111110;
		4'h09: parity_mask <= 12'b001111111110;
		default: parity_mask <= 12'b000111111110;
	endcase
end
/*assign parity_mask = (wordlen == 4'h08) ? 12'b000111111110:
						(wordlen == 4'h05) ? 12'b000000111110:
						(wordlen == 4'h06) ? 12'b000001111110:
						(wordlen == 4'h07) ? 12'b000011111110:
						(wordlen == 4'h09) ? 12'b001111111110:
						12'b000111111110;*/
						
assign parity_rest = shift_reg_out & parity_mask;
assign _chk_int = ^parity_rest;
assign chk_int = (parity == 2'b10) ? ~_chk_int:_chk_int;

assign	buffempty = ~(inbufffullp ^ inbufffulln);

/***********************************************/
/*************	Asynchronus	send	****************/
/***********************************************/
/*
	*		You	need	to	put	the	data	on	the	bus	and	wait	a	half	of	core	clock	to	assert	the	wr	signal(see	simulation).
	*/
always	@	(posedge wr/* or posedge rst*/)
begin
   if(wr	&&	inbufffullp	==	inbufffulln	&&	buffempty && txen)
   begin
       input_buffer <=	data;
   end
end

always	@	(negedge	wr	or posedge rst)
begin
	if(rst || !txen)
		inbufffullp	<=	1'b0;
	else
	if(inbufffullp == inbufffulln && buffempty && txen)
	begin
		inbufffullp <= ~inbufffullp;
	end
end

wire [4:0]input_buffer_tmp_5b = input_buffer[4:0];
wire [5:0]input_buffer_tmp_6b = input_buffer[5:0];
wire [6:0]input_buffer_tmp_7b = input_buffer[6:0];
wire [7:0]input_buffer_tmp_8b = input_buffer[7:0];
wire [8:0]input_buffer_tmp_9b = input_buffer[8:0];

/*Tx logic*/
always	@	(posedge clk or	posedge rst)
begin
	if(rst || !txen)
	begin
		inbufffulln	<=	1'b0;
		state_tx	<=	state_idle;
		shift_reg_out	<=	{MAX_WORD_LEN{1'b0}};
		sckint_tx	<= {5{1'b0}};
		bitcount_tx <= {4{1'b0}};
		total_word_len_tx <= {4{1'b0}};
		tx	<=	1'b1;
	end
	else
	begin
		case(state_tx)
			state_idle:
			begin
				if(inbufffullp != inbufffulln)
				begin
					inbufffulln <= inbufffullp;
					sckint_tx <= 5'h01;
					case({parity, stopbits, wordlen})
						{2'b00, 4'h05}: shift_reg_out	<=	{1'b1, input_buffer[4:0], 1'h0};
						{2'b00, 4'h06}: shift_reg_out	<=	{1'b1, input_buffer[5:0], 1'h0};
						{2'b00, 4'h07}: shift_reg_out	<=	{1'b1, input_buffer[6:0], 1'h0};
						{2'b00, 4'h08}: shift_reg_out	<=	{1'b1, input_buffer[7:0], 1'h0};
						{2'b00, 4'h09}: shift_reg_out	<=	{1'b1, input_buffer[8:0], 1'h0};
						{2'b01, 4'h05}: shift_reg_out	<=	{2'b11, input_buffer[4:0], 1'h0};
						{2'b01, 4'h06}: shift_reg_out	<=	{2'b11, input_buffer[5:0], 1'h0};
						{2'b01, 4'h07}: shift_reg_out	<=	{2'b11, input_buffer[6:0], 1'h0};
						{2'b01, 4'h08}: shift_reg_out	<=	{2'b11, input_buffer[7:0], 1'h0};
						{2'b01, 4'h09}: shift_reg_out	<=	{2'b11, input_buffer[8:0], 1'h0};
						{2'b10, 4'h05}: shift_reg_out	<=	{1'b1, chk_int, input_buffer[4:0], 1'h0};
						{2'b10, 4'h06}: shift_reg_out	<=	{1'b1, chk_int, input_buffer[5:0], 1'h0};
						{2'b10, 4'h07}: shift_reg_out	<=	{1'b1, chk_int, input_buffer[6:0], 1'h0};
						{2'b10, 4'h08}: shift_reg_out	<=	{1'b1, chk_int, input_buffer[7:0], 1'h0};
						{2'b10, 4'h09}: shift_reg_out	<=	{1'b1, chk_int, input_buffer[8:0], 1'h0};
						{2'b11, 4'h05}:shift_reg_out	<=	{2'b11, chk_int, input_buffer[4:0], 1'h0};
						{2'b11, 4'h06}:shift_reg_out	<=	{2'b11, chk_int, input_buffer[5:0], 1'h0};
						{2'b11, 4'h07}:shift_reg_out	<=	{2'b11, chk_int, input_buffer[6:0], 1'h0};
						{2'b11, 4'h08}:shift_reg_out	<=	{2'b11, chk_int, input_buffer[7:0], 1'h0};
						{2'b11, 4'h09}:shift_reg_out	<=	{2'b11, chk_int, input_buffer[8:0], 1'h0};
						default: shift_reg_out	<=	{1'b1, input_buffer[7:0], 1'h0};
					endcase
					bitcount_tx <= 4'b0000;
					total_word_len_tx <= parity ? 1 : 0 + 1 + stopbits + wordlen + 1;
					state_tx <=	state_busy;
					/*Put start, first bit from shift_reg_out*/
					tx <= 1'b0;
				end
			end
			state_busy:
			begin
		        case(sckint_tx)
		          4'h0D:
		          begin
					  sckint_tx <= sckint_tx + 1;
                      bitcount_tx <= bitcount_tx + 4'b0001;
		          end
		          4'h0E:
		          begin
		              if(bitcount_tx == total_word_len_tx)
		                  state_tx <= state_idle;
		              sckint_tx <= sckint_tx + 1;
		          end
		          4'h0F:
		          begin
                      sckint_tx	<= sckint_tx + 1;
                      tx <= shift_reg_out[bitcount_tx];
		          end
		          default:
		          begin
		              sckint_tx <= sckint_tx + 1;
		          end
		        endcase
			end
		endcase
	end
end

endmodule
