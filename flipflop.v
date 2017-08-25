/*
 * This IP is the synthetizable flip-flops implementation.
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

 //JK flip flop module
module flip_flop_jkrse(J,K,Clk,R,S,CE,Qout);
   input J,K;  //inputs
   input Clk;  //Clock
   input R;    //synchronous reset (R) 
   input S; //synchronous set (S)
   input CE; //clock enable (CE) 
   output Qout;  //data output (Q)
   
   //Internal variable
   reg Qout;
   
   always@ (posedge(Clk))  //Everything is synchronous to positive edge of clock
   begin
       if(R == 1) //reset has highest priority.
           Qout = 0;
       else    
           if(S == 1)  //set has next priority
               Qout = 1;
           else
               if(CE == 1) //J,K values are considered only when CE is ON.
                   if(J == 0 && K == 0)    
                       Qout = Qout; //no change
                   else if(J == 0 && K == 1)
                       Qout = 0;  //reset
                   else if(J == 1 && K == 0)
                       Qout = 1;  //set
                   else
                       Qout = ~Qout;  //toggle
               else
                   Qout = Qout; //no change
   end
   
endmodule
