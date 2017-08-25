`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/10/2017 04:58:07 PM
// Design Name: 
// Module Name: util
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


module reg_write_generator(
	input rst,
	input clk,
	input wtite,
	output pulse
    );

reg write_to_reg_p = 0;
reg write_to_reg_n = 0;

always @ (posedge clk)
begin
	if(rst)
		write_to_reg_p <= 0;
	else
	begin
		if(wtite && write_to_reg_p ^ ~write_to_reg_n)
			write_to_reg_p <= ~write_to_reg_n;
	end
end
    
always @ (negedge clk)
begin
	if(rst)
		write_to_reg_n <= 0;
	else
	begin
		if(write_to_reg_p ^ write_to_reg_n)
			write_to_reg_n <= write_to_reg_p;
	end
end

assign pulse = write_to_reg_p ^ write_to_reg_n;

endmodule

