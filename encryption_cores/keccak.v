/*
 * This IP is the synthetizable keccak 224-256-384-512 one hash ped clk implementation.
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

`define PLEN 200

/*** Helper macros to unroll the permutation. ***/
`define get_set_word(x, a) \
	x[(((a) + 1) * 64) - 1 : (a) * 64]

`define SHA3KECCAK_STAGE(out_cnt, cnt, stage, clk) \
clk \
begin \
		b_a_a = 0; \
		`get_set_word(b_a_a, 0) =  `get_set_word(a_a1[cnt], 0) ^ `get_set_word(a_a1[cnt], 5) ^ `get_set_word(a_a1[cnt], 10) ^ `get_set_word(a_a1[cnt], 15) ^ `get_set_word(a_a1[cnt], 20); \
		`get_set_word(b_a_a, 1) =  `get_set_word(a_a1[cnt], 1) ^ `get_set_word(a_a1[cnt], 6) ^ `get_set_word(a_a1[cnt], 11) ^ `get_set_word(a_a1[cnt], 16) ^ `get_set_word(a_a1[cnt], 21); \
		`get_set_word(b_a_a, 2) =  `get_set_word(a_a1[cnt], 2) ^ `get_set_word(a_a1[cnt], 7) ^ `get_set_word(a_a1[cnt], 12) ^ `get_set_word(a_a1[cnt], 17) ^ `get_set_word(a_a1[cnt], 22); \
		`get_set_word(b_a_a, 3) =  `get_set_word(a_a1[cnt], 3) ^ `get_set_word(a_a1[cnt], 8) ^ `get_set_word(a_a1[cnt], 13) ^ `get_set_word(a_a1[cnt], 18) ^ `get_set_word(a_a1[cnt], 23); \
		`get_set_word(b_a_a, 4) =  `get_set_word(a_a1[cnt], 4) ^ `get_set_word(a_a1[cnt], 9) ^ `get_set_word(a_a1[cnt], 14) ^ `get_set_word(a_a1[cnt], 19) ^ `get_set_word(a_a1[cnt], 24); \
		 \
		a_a2[cnt] = {(`PLEN * 8){1'b0}}; \
		`get_set_word(a_a2[cnt], 0+0) = `get_set_word(a_a1[cnt], 0+0) ^ `get_set_word(b_a_a, (0+4) % 5) ^ rol64(`get_set_word(b_a_a, 0+1), 1); \
		`get_set_word(a_a2[cnt], 5+0) = `get_set_word(a_a1[cnt], 5+0) ^ `get_set_word(b_a_a, (0+4) % 5) ^ rol64(`get_set_word(b_a_a, 0+1), 1); \
		`get_set_word(a_a2[cnt], 10+0) = `get_set_word(a_a1[cnt], 10+0) ^ `get_set_word(b_a_a, (0+4) % 5) ^ rol64(`get_set_word(b_a_a, 0+1), 1); \
		`get_set_word(a_a2[cnt], 15+0) = `get_set_word(a_a1[cnt], 15+0) ^ `get_set_word(b_a_a, (0+4) % 5) ^ rol64(`get_set_word(b_a_a, 0+1), 1); \
		`get_set_word(a_a2[cnt], 20+0) = `get_set_word(a_a1[cnt], 20+0) ^ `get_set_word(b_a_a, (0+4) % 5) ^ rol64(`get_set_word(b_a_a, 0+1), 1); \
 \
		`get_set_word(a_a2[cnt], 0+1) = `get_set_word(a_a1[cnt], 0+1) ^ `get_set_word(b_a_a, (1+4) % 5) ^ rol64(`get_set_word(b_a_a, 1+1), 1); \
		`get_set_word(a_a2[cnt], 5+1) = `get_set_word(a_a1[cnt], 5+1) ^ `get_set_word(b_a_a, (1+4) % 5) ^ rol64(`get_set_word(b_a_a, 1+1), 1); \
		`get_set_word(a_a2[cnt], 10+1) = `get_set_word(a_a1[cnt], 10+1) ^ `get_set_word(b_a_a, (1+4) % 5) ^ rol64(`get_set_word(b_a_a, 1+1), 1); \
		`get_set_word(a_a2[cnt], 15+1) = `get_set_word(a_a1[cnt], 15+1) ^ `get_set_word(b_a_a, (1+4) % 5) ^ rol64(`get_set_word(b_a_a, 1+1), 1); \
		`get_set_word(a_a2[cnt], 20+1) = `get_set_word(a_a1[cnt], 20+1) ^ `get_set_word(b_a_a, (1+4) % 5) ^ rol64(`get_set_word(b_a_a, 1+1), 1); \
 \
		`get_set_word(a_a2[cnt], 0+2) = `get_set_word(a_a1[cnt], 0+2) ^ `get_set_word(b_a_a, (2+4) % 5) ^ rol64(`get_set_word(b_a_a, 2+1), 1); \
		`get_set_word(a_a2[cnt], 5+2) = `get_set_word(a_a1[cnt], 5+2) ^ `get_set_word(b_a_a, (2+4) % 5) ^ rol64(`get_set_word(b_a_a, 2+1), 1); \
		`get_set_word(a_a2[cnt], 10+2) = `get_set_word(a_a1[cnt], 10+2) ^ `get_set_word(b_a_a, (2+4) % 5) ^ rol64(`get_set_word(b_a_a, 2+1), 1); \
		`get_set_word(a_a2[cnt], 15+2) = `get_set_word(a_a1[cnt], 15+2) ^ `get_set_word(b_a_a, (2+4) % 5) ^ rol64(`get_set_word(b_a_a, 2+1), 1); \
		`get_set_word(a_a2[cnt], 20+2) = `get_set_word(a_a1[cnt], 20+2) ^ `get_set_word(b_a_a, (2+4) % 5) ^ rol64(`get_set_word(b_a_a, 2+1), 1); \
 \
		`get_set_word(a_a2[cnt], 0+3) = `get_set_word(a_a1[cnt], 0+3) ^ `get_set_word(b_a_a, (3+4) % 5) ^ rol64(`get_set_word(b_a_a, 3+1), 1); \
		`get_set_word(a_a2[cnt], 5+3) = `get_set_word(a_a1[cnt], 5+3) ^ `get_set_word(b_a_a, (3+4) % 5) ^ rol64(`get_set_word(b_a_a, 3+1), 1); \
		`get_set_word(a_a2[cnt], 10+3) = `get_set_word(a_a1[cnt], 10+3) ^ `get_set_word(b_a_a, (3+4) % 5) ^ rol64(`get_set_word(b_a_a, 3+1), 1); \
		`get_set_word(a_a2[cnt], 15+3) = `get_set_word(a_a1[cnt], 15+3) ^ `get_set_word(b_a_a, (3+4) % 5) ^ rol64(`get_set_word(b_a_a, 3+1), 1); \
		`get_set_word(a_a2[cnt], 20+3) = `get_set_word(a_a1[cnt], 20+3) ^ `get_set_word(b_a_a, (3+4) % 5) ^ rol64(`get_set_word(b_a_a, 3+1), 1); \
 \
		`get_set_word(a_a2[cnt], 0+4) = `get_set_word(a_a1[cnt], 0+4) ^ `get_set_word(b_a_a, (4+4) % 5) ^ rol64(`get_set_word(b_a_a, (4+1) % 5), 1); \
		`get_set_word(a_a2[cnt], 5+4) = `get_set_word(a_a1[cnt], 5+4) ^ `get_set_word(b_a_a, (4+4) % 5) ^ rol64(`get_set_word(b_a_a, (4+1) % 5), 1); \
		`get_set_word(a_a2[cnt], 10+4) = `get_set_word(a_a1[cnt], 10+4) ^ `get_set_word(b_a_a, (4+4) % 5) ^ rol64(`get_set_word(b_a_a, (4+1) % 5), 1); \
		`get_set_word(a_a2[cnt], 15+4) = `get_set_word(a_a1[cnt], 15+4) ^ `get_set_word(b_a_a, (4+4) % 5) ^ rol64(`get_set_word(b_a_a, (4+1) % 5), 1); \
		`get_set_word(a_a2[cnt], 20+4) = `get_set_word(a_a1[cnt], 20+4) ^ `get_set_word(b_a_a, (4+4) % 5) ^ rol64(`get_set_word(b_a_a, (4+1) % 5), 1); \
		 \
		a_a3[cnt] = a_a2[cnt]; \
		t = `get_set_word(a_a2[cnt], 1); \
		b = `get_set_word(a_a2[cnt], pi0); \
		`get_set_word(a_a3[cnt], pi0) = rol64(t, rho0); \
		t = b; \
 \
		b = `get_set_word(a_a2[cnt], pi1); \
		`get_set_word(a_a3[cnt], pi1) = rol64(t, rho1); \
		t = b; \
		 \
		b = `get_set_word(a_a2[cnt], pi2); \
		`get_set_word(a_a3[cnt], pi2) = rol64(t, rho2); \
		t = b; \
		 \
		b = `get_set_word(a_a2[cnt], pi3); \
		`get_set_word(a_a3[cnt], pi3) = rol64(t, rho3); \
		t = b; \
		 \
		b = `get_set_word(a_a2[cnt], pi4); \
		`get_set_word(a_a3[cnt], pi4) = rol64(t, rho4); \
		t = b; \
		 \
		b = `get_set_word(a_a2[cnt], pi5); \
		`get_set_word(a_a3[cnt], pi5) = rol64(t, rho5); \
		t = b; \
		 \
		b = `get_set_word(a_a2[cnt], pi6); \
		`get_set_word(a_a3[cnt], pi6) = rol64(t, rho6); \
		t = b; \
		 \
		b = `get_set_word(a_a2[cnt], pi7); \
		`get_set_word(a_a3[cnt], pi7) = rol64(t, rho7); \
		t = b; \
		 \
		b = `get_set_word(a_a2[cnt], pi8); \
		`get_set_word(a_a3[cnt], pi8) = rol64(t, rho8); \
		t = b; \
		 \
		b = `get_set_word(a_a2[cnt], pi9); \
		`get_set_word(a_a3[cnt], pi9) = rol64(t, rho9); \
		t = b; \
		 \
		b = `get_set_word(a_a2[cnt], pi10); \
		`get_set_word(a_a3[cnt], pi10) = rol64(t, rho10); \
		t = b; \
		 \
		b = `get_set_word(a_a2[cnt], pi11); \
		`get_set_word(a_a3[cnt], pi11) = rol64(t, rho11); \
		t = b; \
		 \
		b = `get_set_word(a_a2[cnt], pi12); \
		`get_set_word(a_a3[cnt], pi12) = rol64(t, rho12); \
		t = b; \
		 \
		b = `get_set_word(a_a2[cnt], pi13); \
		`get_set_word(a_a3[cnt], pi13) = rol64(t, rho13); \
		t = b; \
		 \
		b = `get_set_word(a_a2[cnt], pi14); \
		`get_set_word(a_a3[cnt], pi14) = rol64(t, rho14); \
		t = b; \
		 \
		b = `get_set_word(a_a2[cnt], pi15); \
		`get_set_word(a_a3[cnt], pi15) = rol64(t, rho15); \
		t = b; \
		 \
		b = `get_set_word(a_a2[cnt], pi16); \
		`get_set_word(a_a3[cnt], pi16) = rol64(t, rho16); \
		t = b; \
		 \
		b = `get_set_word(a_a2[cnt], pi17); \
		`get_set_word(a_a3[cnt], pi17) = rol64(t, rho17); \
		t = b; \
		 \
		b = `get_set_word(a_a2[cnt], pi18); \
		`get_set_word(a_a3[cnt], pi18) = rol64(t, rho18); \
		t = b; \
		 \
		b = `get_set_word(a_a2[cnt], pi19); \
		`get_set_word(a_a3[cnt], pi19) = rol64(t, rho19); \
		t = b; \
		 \
		b = `get_set_word(a_a2[cnt], pi20); \
		`get_set_word(a_a3[cnt], pi20) = rol64(t, rho20); \
		t = b; \
		 \
		b = `get_set_word(a_a2[cnt], pi21); \
		`get_set_word(a_a3[cnt], pi21) = rol64(t, rho21); \
		t = b; \
		 \
		b = `get_set_word(a_a2[cnt], pi22); \
		`get_set_word(a_a3[cnt], pi22) = rol64(t, rho22); \
		t = b; \
		 \
		b = `get_set_word(a_a2[cnt], pi23); \
		`get_set_word(a_a3[cnt], pi23) = rol64(t, rho23); \
		 \
		a_a1[out_cnt] <= {(`PLEN * 8){1'b0}}; \
		b_a_a = 0; \
		`get_set_word(b_a_a, 0) = `get_set_word(a_a3[cnt], 0+0); \
		`get_set_word(b_a_a, 1) = `get_set_word(a_a3[cnt], 0+1); \
		`get_set_word(b_a_a, 2) = `get_set_word(a_a3[cnt], 0+2); \
		`get_set_word(b_a_a, 3) = `get_set_word(a_a3[cnt], 0+3); \
		`get_set_word(b_a_a, 4) = `get_set_word(a_a3[cnt], 0+4); \
		`get_set_word(a_a1[out_cnt], 0+0) <= `get_set_word(b_a_a, 0) ^ (~`get_set_word(b_a_a, (0+1) % 5) & `get_set_word(b_a_a, (0+2) % 5)) ^ select_RC(stage); \
		`get_set_word(a_a1[out_cnt], 0+1) <= `get_set_word(b_a_a, 1) ^ (~`get_set_word(b_a_a, (1+1) % 5) & `get_set_word(b_a_a, (1+2) % 5)); \
		`get_set_word(a_a1[out_cnt], 0+2) <= `get_set_word(b_a_a, 2) ^ (~`get_set_word(b_a_a, (2+1) % 5) & `get_set_word(b_a_a, (2+2) % 5)); \
		`get_set_word(a_a1[out_cnt], 0+3) <= `get_set_word(b_a_a, 3) ^ (~`get_set_word(b_a_a, (3+1) % 5) & `get_set_word(b_a_a, (3+2) % 5)); \
		`get_set_word(a_a1[out_cnt], 0+4) <= `get_set_word(b_a_a, 4) ^ (~`get_set_word(b_a_a, (4+1) % 5) & `get_set_word(b_a_a, (4+2) % 5)); \
		 \
		`get_set_word(b_a_a, 0) = `get_set_word(a_a3[cnt], 5+0); \
		`get_set_word(b_a_a, 1) = `get_set_word(a_a3[cnt], 5+1); \
		`get_set_word(b_a_a, 2) = `get_set_word(a_a3[cnt], 5+2); \
		`get_set_word(b_a_a, 3) = `get_set_word(a_a3[cnt], 5+3); \
		`get_set_word(b_a_a, 4) = `get_set_word(a_a3[cnt], 5+4); \
		`get_set_word(a_a1[out_cnt], 5+0) <= `get_set_word(b_a_a, 0) ^ (~`get_set_word(b_a_a, (0+1) % 5) & `get_set_word(b_a_a, (0+2) % 5)); \
		`get_set_word(a_a1[out_cnt], 5+1) <= `get_set_word(b_a_a, 1) ^ (~`get_set_word(b_a_a, (1+1) % 5) & `get_set_word(b_a_a, (1+2) % 5)); \
		`get_set_word(a_a1[out_cnt], 5+2) <= `get_set_word(b_a_a, 2) ^ (~`get_set_word(b_a_a, (2+1) % 5) & `get_set_word(b_a_a, (2+2) % 5)); \
		`get_set_word(a_a1[out_cnt], 5+3) <= `get_set_word(b_a_a, 3) ^ (~`get_set_word(b_a_a, (3+1) % 5) & `get_set_word(b_a_a, (3+2) % 5)); \
		`get_set_word(a_a1[out_cnt], 5+4) <= `get_set_word(b_a_a, 4) ^ (~`get_set_word(b_a_a, (4+1) % 5) & `get_set_word(b_a_a, (4+2) % 5)); \
		 \
		`get_set_word(b_a_a, 0) = `get_set_word(a_a3[cnt], 10+0); \
		`get_set_word(b_a_a, 1) = `get_set_word(a_a3[cnt], 10+1); \
		`get_set_word(b_a_a, 2) = `get_set_word(a_a3[cnt], 10+2); \
		`get_set_word(b_a_a, 3) = `get_set_word(a_a3[cnt], 10+3); \
		`get_set_word(b_a_a, 4) = `get_set_word(a_a3[cnt], 10+4); \
		`get_set_word(a_a1[out_cnt], 10+0) <= `get_set_word(b_a_a, 0) ^ (~`get_set_word(b_a_a, (0+1) % 5) & `get_set_word(b_a_a, (0+2) % 5)); \
		`get_set_word(a_a1[out_cnt], 10+1) <= `get_set_word(b_a_a, 1) ^ (~`get_set_word(b_a_a, (1+1) % 5) & `get_set_word(b_a_a, (1+2) % 5)); \
		`get_set_word(a_a1[out_cnt], 10+2) <= `get_set_word(b_a_a, 2) ^ (~`get_set_word(b_a_a, (2+1) % 5) & `get_set_word(b_a_a, (2+2) % 5)); \
		`get_set_word(a_a1[out_cnt], 10+3) <= `get_set_word(b_a_a, 3) ^ (~`get_set_word(b_a_a, (3+1) % 5) & `get_set_word(b_a_a, (3+2) % 5)); \
		`get_set_word(a_a1[out_cnt], 10+4) <= `get_set_word(b_a_a, 4) ^ (~`get_set_word(b_a_a, (4+1) % 5) & `get_set_word(b_a_a, (4+2) % 5)); \
		 \
		`get_set_word(b_a_a, 0) = `get_set_word(a_a3[cnt], 15+0); \
		`get_set_word(b_a_a, 1) = `get_set_word(a_a3[cnt], 15+1); \
		`get_set_word(b_a_a, 2) = `get_set_word(a_a3[cnt], 15+2); \
		`get_set_word(b_a_a, 3) = `get_set_word(a_a3[cnt], 15+3); \
		`get_set_word(b_a_a, 4) = `get_set_word(a_a3[cnt], 15+4); \
		`get_set_word(a_a1[out_cnt], 15+0) <= `get_set_word(b_a_a, 0) ^ (~`get_set_word(b_a_a, (0+1) % 5) & `get_set_word(b_a_a, (0+2) % 5)); \
		`get_set_word(a_a1[out_cnt], 15+1) <= `get_set_word(b_a_a, 1) ^ (~`get_set_word(b_a_a, (1+1) % 5) & `get_set_word(b_a_a, (1+2) % 5)); \
		`get_set_word(a_a1[out_cnt], 15+2) <= `get_set_word(b_a_a, 2) ^ (~`get_set_word(b_a_a, (2+1) % 5) & `get_set_word(b_a_a, (2+2) % 5)); \
		`get_set_word(a_a1[out_cnt], 15+3) <= `get_set_word(b_a_a, 3) ^ (~`get_set_word(b_a_a, (3+1) % 5) & `get_set_word(b_a_a, (3+2) % 5)); \
		`get_set_word(a_a1[out_cnt], 15+4) <= `get_set_word(b_a_a, 4) ^ (~`get_set_word(b_a_a, (4+1) % 5) & `get_set_word(b_a_a, (4+2) % 5)); \
		 \
		`get_set_word(b_a_a, 0) = `get_set_word(a_a3[cnt], 20+0); \
		`get_set_word(b_a_a, 1) = `get_set_word(a_a3[cnt], 20+1); \
		`get_set_word(b_a_a, 2) = `get_set_word(a_a3[cnt], 20+2); \
		`get_set_word(b_a_a, 3) = `get_set_word(a_a3[cnt], 20+3); \
		`get_set_word(b_a_a, 4) = `get_set_word(a_a3[cnt], 20+4); \
		`get_set_word(a_a1[out_cnt], 20+0) <= `get_set_word(b_a_a, 0) ^ (~`get_set_word(b_a_a, (0+1) % 5) & `get_set_word(b_a_a, (0+2) % 5)); \
		`get_set_word(a_a1[out_cnt], 20+1) <= `get_set_word(b_a_a, 1) ^ (~`get_set_word(b_a_a, (1+1) % 5) & `get_set_word(b_a_a, (1+2) % 5)); \
		`get_set_word(a_a1[out_cnt], 20+2) <= `get_set_word(b_a_a, 2) ^ (~`get_set_word(b_a_a, (2+1) % 5) & `get_set_word(b_a_a, (2+2) % 5)); \
		`get_set_word(a_a1[out_cnt], 20+3) <= `get_set_word(b_a_a, 3) ^ (~`get_set_word(b_a_a, (3+1) % 5) & `get_set_word(b_a_a, (3+2) % 5)); \
		`get_set_word(a_a1[out_cnt], 20+4) <= `get_set_word(b_a_a, 4) ^ (~`get_set_word(b_a_a, (4+1) % 5) & `get_set_word(b_a_a, (4+2) % 5)); \
end


module keccak_512 # (
	parameter PIPELINED = 1,
	parameter OUT_WIDTH = 512)/* Supports all four modes of output. */
	(
		input rst,
		input clk,
		input [((`PLEN - (OUT_WIDTH / 4)) * 8) - 1:0]in,/* Input width is automatically calculated. */
		input [7:0]in_len,/* Number of bytes on input, the rest of bytes will be cleared. */
		input [7:0]delimiter,/* This delimiter can be custom, default is 0'h01. */
		output [OUT_WIDTH - 1:0]out,
		input load,//Used only when PIPELINED == 0
		output ready//Used only when PIPELINED == 0
	);

/*** Constants. ***/
localparam rho0 = 1; 
localparam rho1 = 3; 
localparam rho2 = 6; 
localparam rho3 = 10;
localparam rho4 = 15; 
localparam rho5 = 21; 
localparam rho6 = 28; 
localparam rho7 = 36;
localparam rho8 = 45; 
localparam rho9 = 55; 
localparam rho10 = 2; 
localparam rho11 = 14;
localparam rho12 = 27; 
localparam rho13 = 41; 
localparam rho14 = 56; 
localparam rho15 = 8;
localparam rho16 = 25; 
localparam rho17 = 43; 
localparam rho18 = 62; 
localparam rho19 = 18;
localparam rho20 = 39; 
localparam rho21 = 61; 
localparam rho22 = 20; 
localparam rho23 = 44;

localparam pi0 = 10; 
localparam pi1 = 7; 
localparam pi2 = 11; 
localparam pi3 = 17;
localparam pi4 = 18; 
localparam pi5 = 3; 
localparam pi6 = 5; 
localparam pi7 = 16;
localparam pi8 = 8; 
localparam pi9 = 21; 
localparam pi10 = 24; 
localparam pi11 = 4;
localparam pi12 = 15; 
localparam pi13 = 23; 
localparam pi14 = 19; 
localparam pi15 = 13;
localparam pi16 = 12; 
localparam pi17 = 2; 
localparam pi18 = 20; 
localparam pi19 = 14;
localparam pi20 = 22; 
localparam pi21 = 9; 
localparam pi22 = 6; 
localparam pi23 = 1;

localparam RC0 = 64'h0000000000000001; 
localparam RC1 = 64'h0000000000008082; 
localparam RC2 = 64'h800000000000808a; 
localparam RC3 = 64'h8000000080008000;
localparam RC4 = 64'h000000000000808b; 
localparam RC5 = 64'h0000000080000001; 
localparam RC6 = 64'h8000000080008081; 
localparam RC7 = 64'h8000000000008009;
localparam RC8 = 64'h000000000000008a; 
localparam RC9 = 64'h0000000000000088; 
localparam RC10 = 64'h0000000080008009; 
localparam RC11 = 64'h000000008000000a;
localparam RC12 = 64'h000000008000808b; 
localparam RC13 = 64'h800000000000008b; 
localparam RC14 = 64'h8000000000008089; 
localparam RC15 = 64'h8000000000008003;
localparam RC16 = 64'h8000000000008002; 
localparam RC17 = 64'h8000000000000080; 
localparam RC18 = 64'h000000000000800a; 
localparam RC19 = 64'h800000008000000a;
localparam RC20 = 64'h8000000080008081; 
localparam RC21 = 64'h8000000000008080; 
localparam RC22 = 64'h0000000080000001; 
localparam RC23 = 64'h8000000080008008;

wire clk_int = rst ? 1'b0 : clk;


reg [(`PLEN * 8) - 1:0]a_a1[0:24];
reg [(`PLEN * 8) - 1:0]a_a2[0:24];
reg [(`PLEN * 8) - 1:0]a_a3[0:24];

reg [320 - 1 : 0]b_a_a;
reg [320 - 1 : 0]b_a_tmp;

wire [(`PLEN * 8) - 1 : 0]delimiter1_int = (delimiter << (in_len * 8));
wire [(`PLEN * 8) - 1 : 0]delimiter2_int = (8'h80 << ((`PLEN - (OUT_WIDTH / 4)) - 1) * 8);
wire [(`PLEN * 8) - 1 : 0]delimiters_int = delimiter1_int | delimiter2_int;
//wire [(`PLEN * 8) - 1 : 0]input_mask = (({{(`PLEN * 8)-2{1'b0}}, 1'b1} << (in_len << 3)) - 1);

//`define rol64(x, s) (((x) << s) | ((x) >> (64 - s)))
function [63:0]rol64;
	input [63:0]x;
	input [5:0]s;
	begin
		case(s)
		0: rol64 = {x};
		1: rol64 = {x[62:0], x[63]};
		2: rol64 = {x[61:0], x[63:62]};
		3: rol64 = {x[60:0], x[63:61]};
		4: rol64 = {x[59:0], x[63:60]};
		5: rol64 = {x[58:0], x[63:59]};
		6: rol64 = {x[57:0], x[63:58]};
		7: rol64 = {x[56:0], x[63:57]};
		8: rol64 = {x[55:0], x[63:56]};
		9: rol64 = {x[54:0], x[63:55]};
		10: rol64 = {x[53:0], x[63:54]};
		11: rol64 = {x[52:0], x[63:53]};
		12: rol64 = {x[51:0], x[63:52]};
		13: rol64 = {x[50:0], x[63:51]};
		14: rol64 = {x[49:0], x[63:50]};
		15: rol64 = {x[48:0], x[63:49]};
		16: rol64 = {x[47:0], x[63:48]};
		17: rol64 = {x[46:0], x[63:47]};
		18: rol64 = {x[45:0], x[63:46]};
		19: rol64 = {x[44:0], x[63:45]};
		20: rol64 = {x[43:0], x[63:44]};
		21: rol64 = {x[42:0], x[63:43]};
		22: rol64 = {x[41:0], x[63:42]};
		23: rol64 = {x[40:0], x[63:41]};
		24: rol64 = {x[39:0], x[63:40]};
		25: rol64 = {x[38:0], x[63:39]};
		26: rol64 = {x[37:0], x[63:38]};
		27: rol64 = {x[36:0], x[63:37]};
		28: rol64 = {x[35:0], x[63:36]};
		29: rol64 = {x[34:0], x[63:35]};
		30: rol64 = {x[33:0], x[63:34]};
		31: rol64 = {x[32:0], x[63:33]};
		32: rol64 = {x[31:0], x[63:32]};
		33: rol64 = {x[30:0], x[63:31]};
		34: rol64 = {x[29:0], x[63:30]};
		35: rol64 = {x[28:0], x[63:29]};
		36: rol64 = {x[27:0], x[63:28]};
		37: rol64 = {x[26:0], x[63:27]};
		38: rol64 = {x[25:0], x[63:26]};
		39: rol64 = {x[24:0], x[63:25]};
		40: rol64 = {x[23:0], x[63:24]};
		41: rol64 = {x[22:0], x[63:23]};
		42: rol64 = {x[21:0], x[63:22]};
		43: rol64 = {x[20:0], x[63:21]};
		44: rol64 = {x[19:0], x[63:20]};
		45: rol64 = {x[18:0], x[63:19]};
		46: rol64 = {x[17:0], x[63:18]};
		47: rol64 = {x[16:0], x[63:17]};
		48: rol64 = {x[15:0], x[63:16]};
		49: rol64 = {x[14:0], x[63:15]};
		50: rol64 = {x[13:0], x[63:14]};
		51: rol64 = {x[12:0], x[63:13]};
		52: rol64 = {x[11:0], x[63:12]};
		53: rol64 = {x[10:0], x[63:11]};
		54: rol64 = {x[09:0], x[63:10]};
		55: rol64 = {x[08:0], x[63:09]};
		56: rol64 = {x[07:0], x[63:08]};
		57: rol64 = {x[06:0], x[63:07]};
		58: rol64 = {x[05:0], x[63:06]};
		59: rol64 = {x[04:0], x[63:05]};
		60: rol64 = {x[03:0], x[63:04]};
		61: rol64 = {x[02:0], x[63:03]};
		62: rol64 = {x[01:0], x[63:02]};
		63: rol64 = {x[00], x[63:01]};
		endcase
	end
endfunction

function [63:0]select_RC;
	input [4:0]s;
	begin
		case(s)
		0: select_RC = RC0;
		1: select_RC = RC1;
		2: select_RC = RC2;
		3: select_RC = RC3;
		4: select_RC = RC4;
		5: select_RC = RC5;
		6: select_RC = RC6;
		7: select_RC = RC7;
		8: select_RC = RC8;
		9: select_RC = RC9;
		10: select_RC = RC10;
		11: select_RC = RC11;
		12: select_RC = RC12;
		13: select_RC = RC13;
		14: select_RC = RC14;
		15: select_RC = RC15;
		16: select_RC = RC16;
		17: select_RC = RC17;
		18: select_RC = RC18;
		19: select_RC = RC19;
		20: select_RC = RC20;
		21: select_RC = RC21;
		22: select_RC = RC22;
		23: select_RC = RC23;
		default: select_RC = 0;
		endcase
	end
endfunction

reg [63:0]t;
reg [63:0]b;
genvar cnt;
reg [4:0]stage_cnt;

/*always @ (*)
begin
	in_int = 0;
	in_int <= in;
end*/

always @ (*)
begin
	if(PIPELINED == 0)
	begin
		if(load)
			a_a1[0] <= in ^ delimiters_int;
		else
			a_a1[0] <= a_a1[1];
	end
	else
		a_a1[0] <= in ^ delimiters_int;
end

always @ (posedge clk)
begin
	if(PIPELINED == 0)
	begin
		if(rst | load)
			stage_cnt <= 0;
		else
		begin
			if(stage_cnt != 24)
			begin
				`SHA3KECCAK_STAGE(1, 0, stage_cnt, )
				stage_cnt <= stage_cnt + 1;
			end
		end
	end
end

generate
	for(cnt = 0; cnt < 24; cnt = cnt + 1)
	begin: L0
		if(PIPELINED == 1)
		begin
			`SHA3KECCAK_STAGE(cnt + 1, cnt, cnt, always @ (posedge clk))
		end
	end
endgenerate

/*generate
for(cnt = 0; cnt < OUT_WIDTH; cnt = cnt + 8)
begin: REORDER_OUT
assign out[cnt + 7: cnt] = a_a1[24][OUT_WIDTH - cnt - 1:OUT_WIDTH - (cnt + 8)];
end
endgenerate*/

assign out = (PIPELINED == 0) ? (stage_cnt == 24 ? a_a1[0] : 0) : a_a1[24];
assign ready = stage_cnt == 24;

endmodule
