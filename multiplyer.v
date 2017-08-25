`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Iulian Gheorghiu
// 
// Create Date: 08/15/2017 06:39:44 PM
// Design Name: 
// Module Name: 8 bit custom multiplyer.
// Project Name: 8 bit custom multiplyer IP.
// Target Devices: All
// Tool Versions: 
// Description: This is a 8 bit custom multiplyer IP library.
// 
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module multiplyer # (parameter WIDTH_IN = 8)(
		input [WIDTH_IN - 1:0]a,
		input [WIDTH_IN - 1:0]b,
		output [(WIDTH_IN * 2) - 1:0]p
    );

wire [7:0]X0 = b[0] ? a[7:0] : 8'h00;
wire [7:0]X1 = b[1] ? a[7:0] : 8'h00;
wire [8:0]AD1 = X1 + {1'b0, X0[7:1]};
wire [7:0]X2 = b[2] ? a[7:0] : 8'h00;
wire [8:0]AD2 = X2 + AD1[8:1];
wire [7:0]X3 = b[3] ? a[7:0] : 8'h00;
wire [8:0]AD3 = X3 + AD2[8:1];
wire [7:0]X4 = b[4] ? a[7:0] : 8'h00;
wire [8:0]AD4 = X4 + AD3[8:1];
wire [7:0]X5 = b[5] ? a[7:0] : 8'h00;
wire [8:0]AD5 = X5 + AD4[8:1];
wire [7:0]X6 = b[6] ? a[7:0] : 8'h00;
wire [8:0]AD6 = X6 + AD5[8:1];
wire [7:0]X7 = b[7] ? a[7:0] : 8'h00;
wire [8:0]AD7 = X7 + AD6[8:1];
assign p = {AD7, AD6[0], AD5[0], AD4[0], AD3[0], AD2[0], AD1[0], X0[0]};


endmodule
