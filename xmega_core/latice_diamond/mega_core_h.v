/*
 * This IP is the Atmel XMEGA CPU header definition file.
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

//`define USE_MULTIPLYER


`define STEP0	0
`define STEP1	1
`define STEP2	2
`define STEP3	3
`define STEP4	4



`define INSTRUCTION_NOP				16'b0000000000000000
`define INSTRUCTION_MOVW			16'b00000001xxxxxxxx//00000001DDDDRRRR
`define INSTRUCTION_MULS			16'b00000010xxxxxxxx//00000010ddddrrrr
`define INSTRUCTION_MULSU			16'b000000110xxx0xxx//000000110ddd0rrr
`define INSTRUCTION_FMUL			16'b000000110xxx1xxx//000000110ddd1rrr
`define INSTRUCTION_FMULS			16'b000000111xxx0xxx//000000111dddurrr
`define INSTRUCTION_CPC_CP			16'b000x01xxxxxxxxxx//000i01rdddddrrrr
`define INSTRUCTION_CPC				16'b000001xxxxxxxxxx//000001rdddddrrrr
`define INSTRUCTION_CP				16'b000101xxxxxxxxxx//000101rdddddrrrr
`define INSTRUCTION_SBC_SUB_ADD_ADC	16'b000x1xxxxxxxxxxx//000i1irdddddrrrr
`define INSTRUCTION_SBC				16'b000010xxxxxxxxxx//000010rdddddrrrr
`define INSTRUCTION_SUB				16'b000110xxxxxxxxxx//000110rdddddrrrr
`define INSTRUCTION_ADD				16'b000011xxxxxxxxxx//000011rdddddrrrr
`define INSTRUCTION_ADC				16'b000111xxxxxxxxxx//000111rdddddrrrr
`define INSTRUCTION_CPSE			16'b000100xxxxxxxxxx//000100rdddddrrrr
`define INST_AND_EOR_OR_MOV			16'b0010xxxxxxxxxxxx//0010iirdddddrrrr
`define INSTRUCTION_AND				16'b001000xxxxxxxxxx//001000rdddddrrrr
`define INSTRUCTION_EOR				16'b001001xxxxxxxxxx//001001rdddddrrrr
`define INSTRUCTION_OR				16'b001010xxxxxxxxxx//001010rdddddrrrr
`define INSTRUCTION_MOV				16'b001011xxxxxxxxxx//001011rdddddrrrr
`define INSTRUCTION_CPI				16'b0011xxxxxxxxxxxx//0011kkkkddddkkkk
`define INSTRUCTION_SUBI_SBCI		16'b010xxxxxxxxxxxxx//010ikkkkddddkkkk
`define INSTRUCTION_SUBI			16'b0101xxxxxxxxxxxx//0101kkkkddddkkkk
`define INSTRUCTION_SBCI			16'b0100xxxxxxxxxxxx//0100kkkkddddkkkk
`define INSTRUCTION_ORI_ANDI		16'b011xxxxxxxxxxxxx//011ikkkkddddkkkk
`define INSTRUCTION_ORI_SBR			16'b0110xxxxxxxxxxxx//0110kkkkddddkkkk
`define INSTRUCTION_ANDI_CBR		16'b0111xxxxxxxxxxxx//0111kkkkddddkkkk

`define INSTRUCTION_LDD_STD			16'b10x0xxxxxxxxxxxx//10k0kksdddddykkk
`define INSTRUCTION_LDS_STS			16'b100100xxxxxx0000//100100sddddd0000
`define INSTRUCTION_LD_ST_YZP		16'b100100xxxxxxx001//100100sdddddy001
`define INSTRUCTION_LD_ST_YZN		16'b100100xxxxxxx010//100100sdddddy010
`define INSTRUCTION_LPM_ELPM_R		16'b1001000xxxxx01x0//1001000ddddd01q0
`define INSTRUCTION_LPM_ELPM_R_P	16'b1001000xxxxx01x1//1001000ddddd01q1
`define INSTRUCTION_XCH				16'b1001001xxxxx0100//1001001ddddd0100
`define INSTRUCTION_LAS				16'b1001001xxxxx0101//1001001ddddd0101
`define INSTRUCTION_LAC				16'b1001001xxxxx0110//1001001ddddd0110
`define INSTRUCTION_LAT				16'b1001001xxxxx0111//1001001ddddd0111
`define INSTRUCTION_LD_ST_X			16'b100100xxxxxx1100//100100sddddd1100
`define INSTRUCTION_LD_ST_XP		16'b100100xxxxxx1101//100100sddddd1101
`define INSTRUCTION_LD_ST_XN		16'b100100xxxxxx1110//100100sddddd1110
`define INSTRUCTION_POP_PUSH		16'b100100xxxxxx1111//100100sddddd1111
`define INST_COM_NEG_SWAP_INC		16'b1001010xxxxx00xx//1001010ddddd00xx
`define INSTRUCTION_COM				16'b1001010xxxxx0000//1001010ddddd0000
`define INSTRUCTION_NEG				16'b1001010xxxxx0001//1001010ddddd0001
`define INSTRUCTION_SWAP			16'b1001010xxxxx0010//1001010ddddd0010
`define INSTRUCTION_INC				16'b1001010xxxxx0011//1001010ddddd0011
`define INSTRUCTION_ASR				16'b1001010xxxxx0101//1001010ddddd0101
`define INSTRUCTION_LSR				16'b1001010xxxxx0110//1001010ddddd0110
`define INSTRUCTION_ROR				16'b1001010xxxxx0111//1001010ddddd0111
`define INSTRUCTION_SEx_CLx			16'b10010100xxxx1000//10010100Bbbb1000
`define INSTRUCTION_RET_RETI		16'b10010101000x1000//10010101000x1000
`define INSTRUCTION_RET				16'b1001010100001000//1001010100001000
`define INSTRUCTION_RETI			16'b1001010100011000//1001010100001000
`define INSTRUCTION_SLEEP			16'b1001010110000000//1001010100001000
`define INSTRUCTION_BREAK			16'b1001010110011000//1001010100011000
`define INSTRUCTION_WDR				16'b1001010110101000//1001010100101000
`define INSTRUCTION_LPM_ELPM		16'b10010101110x1000//10010101110q1000
`define INSTRUCTION_SPM				16'b1001010111101000//1001010111101000
`define INSTRUCTION_SPM_Z_P			16'b1001010111111000//1001010111111000
`define INSTRUCTION_IJMP_ICALL		16'b1001010x00001001//1001010c000e1001
`define INSTRUCTION_IJMP			16'b1001010000001001//1001010c000e1001
`define INSTRUCTION_ICALL			16'b1001010100001001//1001010c000e1001
`define INSTRUCTION_DEC				16'b1001010xxxxx1010//1001010ddddd1010
`define INSTRUCTION_DES				16'b10010100xxxx1011//10010100kkkk1011
`define INSTRUCTION_JMP_CALL		16'b1001010xxxxx11xx//1001010kkkkk11ck
`define INSTRUCTION_JMP				16'b1001010xxxxx110x//1001010kkkkk110k
`define INSTRUCTION_CALL			16'b1001010xxxxx111x//1001010kkkkk111k
`define INSTRUCTION_ADIW_SBIW		16'b1001011xxxxxxxxx//10010110kkppkkkk
`define INSTRUCTION_ADIW			16'b10010110xxxxxxxx//10010110kkppkkkk
`define INSTRUCTION_SBIW			16'b10010111xxxxxxxx//10010111kkppkkkk
`define INSTRUCTION_CBI_SBI			16'b100110x0xxxxxxxx//100110B0aaaaabbb
`define INSTRUCTION_SBIC_SBIS		16'b100110x1xxxxxxxx//100110B1aaaaabbb
`define INSTRUCTION_MUL				16'b100111xxxxxxxxxx//100111rdddddrrrr
`define INSTRUCTION_IN_OUT			16'b1011xxxxxxxxxxxx//1011saadddddaaaa
`define INSTRUCTION_RJMP_RCALL		16'b110xxxxxxxxxxxxx//110cxxxxxxxxxxxx
`define INSTRUCTION_RJMP			16'b1100xxxxxxxxxxxx//1100xxxxxxxxxxxx
`define INSTRUCTION_RCALL			16'b1101xxxxxxxxxxxx//1101xxxxxxxxxxxx
`define INSTRUCTION_LDI				16'b1110xxxxxxxxxxxx//1110KKKKddddKKKK
`define INSTRUCTION_COND_BRANCH		16'b11110xxxxxxxxxxx//11110Bxxxxxxxbbb
`define INSTRUCTION_BLD_BST			16'b111110xxxxxx0xxx//111110sddddd0bbb
`define INSTRUCTION_SBRC_SBRS		16'b111111xxxxxx0xxx//111111Bddddd0bbb
