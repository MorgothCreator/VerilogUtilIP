/*
 * This IP is the synthetizable adder implementation.
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

module half_adder(
	input A,
	input B,
	output S,
	output C
);
//Implement the Sum and Carry equations using Verilog Bit operators.
assign S = A ^ B;  //XOR operation
assign C = A & B; //AND operation
    
endmodule


module full_adder(
	input A,  //input A
	input B,  //input B
	input C,  //input C
	output Sum,
	output Carry
);

//Internal variables
wire ha1_sum;
wire ha2_sum;
wire ha1_carry;
wire ha2_carry;
wire Data_out_Sum;
wire Data_out_Carry;

//Instantiate the half adder 1
half_adder  ha1(
	.A(A),
	.B(B),
	.S(ha1_sum),
	.C(ha1_carry)
);

//Instantiate the half adder 2
half_adder  ha2(
	.A(C),
	.B(ha1_sum),
	.S(ha2_sum),
	.C(ha2_carry)
);
//sum output from 2nd half adder is connected to full adder output
assign Sum = ha2_sum;  
//The carry's from both the half adders are OR'ed to get the final carry./
assign Carry = ha1_carry | ha2_carry;
    
endmodule
