/*
 * This IP is the Atmel XMEGA ALU header definition file.
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


`define ALU_FLAG_C	0
`define ALU_FLAG_Z	1
`define ALU_FLAG_N	2
`define ALU_FLAG_V	3
`define ALU_FLAG_S	4
`define ALU_FLAG_H	5
`define ALU_FLAG_T	6
`define ALU_FLAG_I	7



`define ALU_NOP 	0
`define ALU_ADD 	1
`define ALU_ADC 	2
`define ALU_SUB 	3
`define ALU_SBC 	4
`define ALU_LSL 	5
`define ALU_LSR 	6
`define ALU_ROR 	7
`define ALU_ROL 	8
`define ALU_AND 	9
`define ALU_OR 		10
`define ALU_EOR 	11
`define ALU_MOV 	12
`define ALU_MOVW 	13
`define ALU_COM 	14
`define ALU_NEG 	15
`define ALU_ADIW 	16
`define ALU_SBIW 	17
`define ALU_MUL 	18
`define ALU_ASR 	19
`define ALU_CP_CPI	20
`define ALU_CPC 	21
`define ALU_SWAP 	22
`define SEx_CLx		23

`define ALU_SELECT_BUS_SIZE	223

