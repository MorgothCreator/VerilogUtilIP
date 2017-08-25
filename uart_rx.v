`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/21/2017 02:54:54 PM
// Design Name: 
// Module Name: uart_rx
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


module uart_rx(
		input	clk,/*	Peripheral clock/will be provided from a prescaller, no need to be 50% waveform (input)	*/
		input	rst,/*	Asynchronus	reset,	is	mandatory	to	provide	this	signal,	active	on	posedge	(input)	*/
		input	rxen,
		output reg[8:0]data,/* Out data(output)	*/
		input	rd,/*	Read	data,	,	asynchronus	with	'clk'	,	active	on	posedge	or	negedge	(input)	*/
		output	charreceived,/*	Is	set	to	'1'	if	a	character	is	received,	if	you	read	the	receive	buffe	this	bit	will	go	'0',	if	you	ignore	it	and	continue	to	send	data	this	bit	will	remain	'1'	until	you	read	the	read	register	(output)	*/
		input	[3:0]wordlen,/* In bits */
		input	rx,/* Rx pin */
		inout	sck,/* Synchronous clk pin (Not implemented yet) */
		input u2x,/* Double speed */
		input [1:0]parity,/* Parity type: 0 = none, 1 = even, 2 = odd (Not implemented yet) */
		input stopbits,/* Number of stop bits: 0 = one stop bit, 1 = Two stop bits */
		input mode,/*0 = Asysnhronous, 1 = Synchronous*/
		output reg frameerror,/* If stop bit is not detected a frame error will report, this is actualized every received byte. */
		output reg parityerror,/* Parity error bit report (Not implemented yet) */
		output receiveoverrun/* If receive buffer is full and another char is received a receiveoverrun will report, this bit is resetted on read. */
    );
    
parameter [6:0]MAX_WORD_LEN = 9;

parameter	state_idle	=	1'b0;
parameter	state_busy	=	1'b1;

reg receiveoverrunp;
reg receiveoverrunn;
wire receiveoverrunpn;

reg [2:0]rxbitcntstate;

reg	charreceivedp;
reg	charreceivedn;

reg	state_rx;
reg	[(MAX_WORD_LEN - 1) + 4:0]shift_reg_in;
//reg	[MAX_WORD_LEN - 1:0]temp_output_buffer;
reg	[7:0]sckint_rx;
//reg	[3:0]bitcount_rx;
reg [3:0]total_word_len_rx;

wire _chk_int;
wire chk_int;
reg [(MAX_WORD_LEN - 1) + 4:0]parity_mask;
wire [(MAX_WORD_LEN - 1) + 4:0]valid_data;
wire parity_bit;

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
						
assign valid_data = shift_reg_in & parity_mask;
assign _chk_int = ^valid_data;
assign chk_int = (parity == 2'b10) ? ~_chk_int:_chk_int;
assign parity_bit = (shift_reg_in & (1 << wordlen + 1)) ? 1:0;

reg last_state_rxp;
reg last_state_rxn;
wire rx_start_detected;

always @ (negedge rx or	posedge rst)
begin
	if(rst)
		last_state_rxn <= 0;
	else
	begin
		if(last_state_rxn == last_state_rxp)
		begin
			last_state_rxn <= ~last_state_rxp;
		end
	end
end
assign rx_start_detected = (last_state_rxn ^ last_state_rxp);

/*Rx logic*/
always	@	(posedge clk or	posedge rst)
begin
	if(rst || !rxen)
	begin
		last_state_rxp <= 0;
		state_rx <=	state_idle;
		data <=	0;
		shift_reg_in <=	0;
		sckint_rx <= 0;
		charreceivedp <= 0;
		frameerror <= 0;
		parityerror <= 0;
		receiveoverrunn <= 0;
		rxbitcntstate <= 0;
		total_word_len_rx <= 0;
	end
	else
	begin
		if(state_rx == state_idle)
		begin
			// Wait for a transition from hi to low that indicate a start condition.
			if(rx_start_detected)
			begin
				shift_reg_in <= 0;
				sckint_rx <= 0;
				rxbitcntstate <= 7;
				// Calculate the total number of bits to receive including end.
				total_word_len_rx <= parity ? 1 : 0 + 1 + stopbits + wordlen;
				state_rx <= state_busy;
			end
		end
		else
		begin
			case(sckint_rx[3:0])
				7,8,9: 
				begin
					rxbitcntstate <= rxbitcntstate + (rx ? 3'd7 : 3'd1);
					sckint_rx <= sckint_rx + 1;
				end
				10:
				begin 
					if(sckint_rx[7:4] == total_word_len_rx)// If is stop bit check-it and out the received data.
					begin
						// Verify stop bit to be valid, else report a frame error.
						frameerror <= ~rxbitcntstate[2];
						// Verify the parity bit
						if(parity)
							parityerror <= parity_bit ^ chk_int;
						else
							parityerror <= 0;
						// Put data from shift register to output data register.
						data <= valid_data[8:1];
						// Check if the previous received data has been read from output register, if not report a overrun situation..
						if(charreceivedn == charreceivedp)
							charreceivedp <= ~charreceivedp;
						else
						begin
							if(receiveoverrunn == receiveoverrunp)
								receiveoverrunn <= ~receiveoverrunn;
						end
						state_rx <= state_idle;
						sckint_rx <= 0;
						last_state_rxp <= last_state_rxn; 
					end
					else
					begin
						shift_reg_in[sckint_rx[7:4]] <= rxbitcntstate[2];
						sckint_rx <= sckint_rx + 1;
					end
				end
				15:
				begin
					rxbitcntstate <= 7;
					sckint_rx <= sckint_rx + 1;
				end
				default:
				begin
					sckint_rx <= sckint_rx + 1;
				end
			endcase
		end
	end
end
/*
 *		You need to assert rd signal, wait a half core clock and after read the data(see simulation).
 */
wire rdrst;
`ifdef	READ_ON_NEG_EDGE	==	1
assign rdrst = ~rd | rst;
`else
assign rdrst = rd | rst;
`endif
always	@	(posedge rdrst)
begin
	if(rst || !rxen)
	begin
		charreceivedn	<=	1'b0;
		receiveoverrunp <= 1'b0;
	end
	else
	begin
		if(charreceivedp	!=	charreceivedn)
			charreceivedn	<=	~charreceivedn;
		if(receiveoverrunn != receiveoverrunp)
			receiveoverrunp <= ~receiveoverrunp;
	end
end

assign receiveoverrun = (receiveoverrunp ^ receiveoverrunn);

//assign data_out = (rd) ? output_buffer : {MAX_WORD_LEN{1'bz}};

assign charreceived = (charreceivedp ^ charreceivedn);



endmodule
