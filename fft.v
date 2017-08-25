`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/15/2017 08:09:27 PM
// Design Name: 
// Module Name: fft
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
module load32(
	output [31:0]out,
	input [31:0]in
	);
assign out = in;
endmodule

function real loadReal;
	input real in;
	begin
		loadReal = in;
	end
endfunction

module fft # (
	parameter WIDTH = 8)(
	input rst,
	input clk
    );

real sintable[(2**WIDTH) / 2:0];
real costable[(2**WIDTH) / 2:0];
reg [31:0]bitReverse[2**WIDTH:0];

reg[WIDTH-1:0]k;
reg [WIDTH-1:0]r;
function  [9:0] reverseBitInit;
	input [9:0] i;
	begin
		for (k=0; k<WIDTH; k=k-1)
		begin
			r = r << 1;
			r = r + (i & 1);
			i = i >> 1;
		end
	end
endfunction

localparam real PI = 3.141592653589793;
genvar count_init;
generate
	for (count_init = 0; count_init < WIDTH; count_init = count_init + 1)
	begin: FFT_INIT
		//load32(bitReverse[count_init], reverseBitInit(count_init));
		//real j = loadReal(2.0 * PI * count_init / (2**WIDTH));
		//real costable = loadReal(cos(j));
		//real sintable = loadReal(sin(j));
	end
endgenerate
endmodule
