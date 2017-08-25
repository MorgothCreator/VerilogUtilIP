`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/18/2017 03:51:34 PM
// Design Name: 
// Module Name: i2c_master
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

`define	I2C_DEBUG

module i2c_master(
		input clk,/* Peripheral clock/not necessary to be core clock, the core clock can be different (input) */
		input rst,/* Asynchronus reset, is mandatory to provide this signal, active on posedge (input) */
		input [7:0]dataIn,/* In data */
		output reg [7:0]dataOut,/* Out data */
		input wr,/* Send data, asynchronus with 'clk' , active on posedge or negedge(input) */
		input rd,/* Read data, , asynchronus with 'clk' , active on posedge or negedge (input) */
		output buffempty,/* '1' if transmit buffer is empty (output) */
		input prescaller,/* The prescaller divider is = (1 << prescaller) value between 0 and 7 for dividers by:1,2,4,8,16,32,64,126 and 256 (input)*/
		input dirsend,/* 0 = receiver, 1 = transmitter. */
		output reg scl,
		output sda,
		output reg senderr,/* If you try to send a character if send buffer is full this bit is set to '1', this can be ignored and if is '1' does not affect the interface (output) */
		input res_senderr,/* To reset 'senderr' signal write '1' wait half core clock and and after '0' to this bit, is asynchronous with 'clk' (input)*/
		output chartransferred,/* Is set to '1' if a character is received, if you read the receive buffe this bit will go '0', if you ignore it and continue to send data this bit will remain '1' until you read the read register (output) */
		output reg ack,
		input resendstart,
		output reg arbitrationlost
	);

parameter PRESCALLER_SIZE = 8;

reg dirsendint;

reg charreceivedp;
reg charreceivedn;

reg inbufffullp;
reg inbufffulln;

reg [7:0]input_buffer;
reg [7:0]output_buffer;

assign buffempty = ~(inbufffullp ^ inbufffulln);
reg [2:0]prescallerbuff;

/*
 *  You need to put the data on the bus and wait a half of core clock to assert the wr signal(see simulation).
 */
always @ (posedge wr)
begin
	if(wr && inbufffullp == inbufffulln && buffempty)
	begin
		input_buffer <= dataIn;
	end
end

always @ (posedge wr or posedge res_senderr or posedge rst)
begin
	if(rst)
	begin
		inbufffullp <= 1'b0;
		senderr <= 1'b0;
		prescallerbuff <= 3'b000;
	end
	else
	if(res_senderr)
		senderr <= 1'b0;
	else
	if(wr && inbufffullp == inbufffulln && buffempty)
	begin
		inbufffullp <= ~inbufffullp;
		prescallerbuff = prescaller;
	end
	else
	if(!buffempty)
		senderr <= 1'b1;
end

/*
 *  You need to assert rd signal, wait a half core clock and after read the data(see simulation).
 */
always @ (posedge rd or posedge rst)
begin
	if(rst)
		charreceivedn <= 1'b0;
	else
	if(charreceivedp != charreceivedn)
		charreceivedn <= ~charreceivedn;
end

reg resendstartp;
reg resendstartn;
wire resendstartw;
/*
 *  You need to assert rd signal, wait a half core clock and after read the data(see simulation).
 */
always @ (posedge resendstart or posedge rst)
begin
	if(rst)
		resendstartn <= 1'b0;
	else
	if(resendstartp == resendstartn)
		resendstartn <= ~resendstartn;
end
//assign sendstopw = sendstopp ^ sendstopn;

/***********************************************/
/************ !Asynchronus send ****************/
/***********************************************/
reg [7:0]shift_reg_out;
reg [7:0]shift_reg_in;
reg [5:0]sckint;
//reg sckintn;
parameter dirint_send = 1'b0;
parameter dirint_rec = 1'b1;

reg lsbfirstint;
reg [1:0]modeint;

parameter state_idle = 2'b00;
parameter state_busy = 2'b01;
reg [1:0]state;

parameter statebusy_startphase1 = 4'b0000;
parameter statebusy_startphase2 = 4'b0001;
parameter statebusy_startphase3 = 4'b0010;
parameter statebusy_startphase4 = 4'b0011;
parameter statebusy_start = 4'b0100;
parameter statebusy_send = 4'b0101;
parameter statebusy_stopphase1 = 4'b0110;
parameter statebusy_stopphase2 = 4'b0111;

parameter statebusy_restartphase1 = 4'b1000;
parameter statebusy_restartphase2 = 4'b1001;
parameter statebusy_restartphase3 = 4'b1010;

reg [3:0]statebusy;

reg sda_out;

reg _dirsendint;

always @ (posedge clk or posedge rst)
begin
	if(rst)
	begin
		/*
		 * Reset all bits modifyed by this function.
		 */
		inbufffulln <= 1'b0;
		resendstartp <=  1'b0;
		_dirsendint <= 1'b1;
		dirsendint <= 1'b1;
		state <= state_idle;
		statebusy <= statebusy_startphase1;
		shift_reg_out <= {8{1'b0}};
		shift_reg_in <= {8{1'b0}};
		sckint <=  {6{1'b0}};
		output_buffer <= {8{1'b0}};
		charreceivedp <= 1'b0;
		lsbfirstint <= 1'b0;
		arbitrationlost <= 1'b0;
		modeint <= 2'b00;
		ack <= 1'b1;
		sda_out <= 1'b1;
		scl <= 1'b1;
	end
	else
	begin
		case(state)
		state_idle:
			begin
				/*
          		 * Wait here for a new byte to be pushed on send buff.
          		 */
				if(inbufffullp != inbufffulln)
				begin
					inbufffulln <= ~inbufffulln;
					shift_reg_out <= input_buffer;
					shift_reg_in <= {8{1'b0}};
					_dirsendint <= 1'b1;
					state <= state_busy;
					arbitrationlost <= 1'b0;
					statebusy <= statebusy_startphase1;
					dirsendint <= dirsend;
				end
			end
		state_busy:
			begin
				case(statebusy)
					/*
					 * From here begin to create 'repeat start' condition.
					 */
					statebusy_restartphase1:/* Begin resend start sequency */
					begin
						scl <= 1'b0;
						_dirsendint <= 1'b1;
						statebusy <= statebusy_restartphase2;
					end
					statebusy_restartphase2:
					begin
						sda_out <= 1'b1;
						statebusy <= statebusy_restartphase3;
					end
					statebusy_restartphase3:
					begin
						scl <= 1'b1;
						sckint[5:0] <= 6'b000000;
						statebusy <= statebusy_startphase1;
					end
					/*
                     * From here begin to create 'start' condition.
                     */
					statebusy_startphase1:
					begin
						scl <= 1'b1;
						sda_out <= 1'b0;
						statebusy <= statebusy_startphase2;
					end
					statebusy_startphase2:
					begin
						scl <= 1'b0;
						statebusy <= statebusy_startphase3;
					end
					/*
                     * Put first bit to sda.
                     */
					statebusy_startphase3:
					begin
						 sda_out <= shift_reg_out[7];
						 statebusy <= statebusy_startphase4;
						 _dirsendint <= dirsendint;
					end
					statebusy_startphase4:
					begin
						statebusy <= statebusy_send;
						scl <= 1'b1;
					end
					/*
                     * From here begin to create bit read/write conditions.
                     */
					statebusy_send:/* Send/Receive data */
					begin
						/*
                    	 * Bit all, cycle all.
                     	 */
						sckint <= sckint + 1;
						/*
                    	 * Bit before first bit, cycle 2.
                    	 * Set to transmit.
                    	 */
						if(sckint[5:0] == 6'b111110 && dirsendint)
							_dirsendint <= 1'b1;
						/*
                         * Bit 1, cycle 1.
                         * Set to transmit.
                         */
						if(sckint[5:0] == 6'b000101)
							scl <= 1'b0;
						/*
						 * Bit 9(stop), cycle 0.
						 * If no char on buffer a STOP will be send, from here begin the STOP.
						 */
						if(sckint[5:0] == 6'b100100)
						begin
							sckint <= {6{1'b0}};
							if(inbufffullp == inbufffulln)
							begin
								 scl <= 1'b1;
							end
							statebusy <= statebusy_stopphase1;
							_dirsendint <= 1'b1;
							sda_out <= 1'b1;
						end
						else
						/*
						 * Bit all except 9(stop), cycle 0.
						 * On ACK time will verify if need to send another character without STOP.
						 */
						if(sckint[1:0] == 2'b00)
						begin
							/*
							 * Bit all except 8(ack) and 9(stop), cycle 0.
							 * Here will take the data from SDA pin.
							 */
							if(sckint[5:2] != 4'b1000 && sckint[5:2] != 4'b1001)
							begin
								shift_reg_in <= (shift_reg_in << 1) | sda;
								/*
								 * Check if the input is the same like output, if different signify thas it lost arbitration.
								 */
								if(sda != sda_out)
								begin
									/*
									 * Entirely release the buss and go to Idle state.
									 */
									arbitrationlost <= 1'b1;
									/*
                                     * Next cycle will enter in idle state.
                                     */
									state <= state_idle;
									statebusy <= statebusy_send;
								end
							end
							else
							begin
								/*
								 * Bit 8(ack), cycle 0.
								 * Here is the time to get the ack from the sda pin.
								 */
								if(sckint[5:2] == 4'b1000)
								begin
									/*
									 * Take the ack bit.
									 */
									ack <= sda;
									/*
									 * Check if the send buffer is full.
									 */
									if(inbufffulln != inbufffullp)
									begin
										/*
										 * If send buff is full, continue to send.
										 */
										inbufffulln <= ~inbufffulln;
										shift_reg_out <= input_buffer;
										shift_reg_in <= {8{1'b0}};
										/*
										 * Delay 2 cycles before sending new character.
										 */
										sckint <= 6'b111101;
										/*
										 * Check if need to resend a start sequency.
										 */
										if(resendstartp != resendstartn)
										begin
											/*
											 * Resend start sequency.
											 */
											resendstartp <= ~resendstartp;
											/*
											 * Next cycle wil begin the restart condition.
											 */
											//state <= state_busy;
											statebusy <= statebusy_restartphase1;
										end
										else
										/*
										 * Continue to send data.
										 */
										begin
											//state <= state_busy;
											statebusy <= statebusy_send;
										end
									end
									/*
									 * Put to dataOut the shift register.
									 */
									dataOut <= shift_reg_in;
									if(charreceivedp == charreceivedn)
										charreceivedp <= ~charreceivedp;
									dirsendint <= dirsend;
								end
							end
						end
						else
						/*
                         * Bit all, cycle 1.
                         */
						if(sckint[1:0] == 2'b01)
						begin
							/*
							 * Transition from '1' to '0' of SCL pin.
							 * Shift left the shift_reg_out register after the bit 7 is send and before checking the state of sda is the same to bit 7.
							 */
							shift_reg_out <= (shift_reg_out << 1) | 1'b0;
							scl <= 1'b0;
						end
						else
						/*
                         * Bit all, cycle 3.
                         */
						if(sckint[1:0] == 2'b11)
						begin
							/*
							 * Transition from '0' to '1' of SCL pin.
							 */
							scl <= 1'b1;
						end
						else
						begin
							/*
                        	 * Bit 7(last data bit), cycle 2.
							 */
							if(sckint[5:2] == 4'b0111)
								/*
								 * After sending/receiving last bit put the sda to tristate to check the ack.
								 */
								_dirsendint <= 1'b0;
							else 
							/*
                             * Bit 8, cycle 2.
                             */
							if(sckint[5:2] == 4'b1000)
								/*
								 * After checking ack put sda to open-collector to send the stop sequency if need to be send.
								 */
								_dirsendint <= 1'b1;
							/*
                             * Bit all except 8(ack), cycle 2.
                             * Put data on sda.
                             */
							sda_out <= shift_reg_out[7];
						end
					end
					/*
                     * End the 'stop' condition and go to Idle state.
                     */
					statebusy_stopphase1:
					begin
						/*
						 * End sequence for stop signal.
						 */
						sda_out <= 1'b1;
						/*
                         * Next cycle will enter in idle state.
                         */
						state <= state_idle;
						statebusy <= statebusy_startphase1;
					end
				endcase
			end
		endcase
	end
end

`ifdef I2C_DEBUG
assign sda = sda_out;
`else
assign sda = sda_out ? 1'bz : (_dirsendint ? 1'b0 :  1'bz);
`endif
assign chartransferred = (charreceivedp ^ charreceivedn);


endmodule
