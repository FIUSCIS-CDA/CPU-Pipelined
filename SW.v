// Copyright (C) 1991-2015 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, the Altera Quartus II License Agreement,
// the Altera MegaCore Function License Agreement, or other 
// applicable license agreement, including, without limitation, 
// that your use is for the sole purpose of programming logic 
// devices manufactured by Altera and sold by Altera or its 
// authorized distributors.  Please refer to the applicable 
// agreement for further details.

// PROGRAM		"Quartus II 64-Bit"
// VERSION		"Version 15.0.0 Build 145 04/22/2015 SJ Web Edition"
// CREATED		"Tue Feb  2 07:59:24 2021"

module SW(
	Op,
	Y
);


input wire	[31:26] Op;
output wire	Y;

wire	NOTOp28;
wire	NOTOp30;




assign	Y = Op[29] & Op[31] & NOTOp30 & NOTOp28 & Op[27] & Op[26];

assign	NOTOp30 =  ~Op[30];

assign	NOTOp28 =  ~Op[28];


endmodule
