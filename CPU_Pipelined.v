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
// CREATED		"Tue Feb  2 08:03:20 2021"

module CPU_Pipelined(
	reset,
	clk,
	Strategy,
	EXIR,
	IDIR,
	IFIR,
	MEMIR,
	PC,
	WBIR
);


input wire	reset;
input wire	clk;
input wire	[1:0] Strategy;
output wire	[31:0] EXIR;
output wire	[31:0] IDIR;
output wire	[31:0] IFIR;
output wire	[31:0] MEMIR;
output wire	[31:0] PC;
output wire	[31:0] WBIR;

wire	[31:0] EXALUOut;
wire	[31:0] EXB;
wire	[31:0] EXIR_ALTERA_SYNTHESIZED;
wire	[31:0] EXMEMTower_ALUOut;
wire	[31:0] EXMEMTower_B;
wire	[31:0] EXMEMTower_IR;
wire	[5:0] EXop;
wire	[4:0] EXrd;
wire	[4:0] EXrs;
wire	[4:0] EXrt;
wire	EXstall;
wire	EXstall_or_IDstall;
wire	Fix;
wire	[1:0] ForwardA_EX;
wire	[1:0] ForwardA_ID;
wire	[1:0] ForwardB_EX;
wire	[1:0] ForwardB_ID;
wire	[31:0] ForwardedValuefromMEM;
wire	[31:0] ForwardedValuefromWB;
wire	[15:0] ID_beq_offset;
wire	[31:0] IDA;
wire	[31:0] IDB;
wire	[31:0] IDEXTower_A;
wire	[31:0] IDEXTower_B;
wire	[31:0] IDEXTower_IR;
wire	[31:0] IDIRwire;
wire	[5:0] IDop;
wire	[4:0] IDrs;
wire	[4:0] IDrt;
wire	IDstall;
wire	[31:0] IFIDTower_IR;
wire	[31:0] IFIRwire;
wire	[5:0] IFop;
wire	[31:0] MEMIRwire;
wire	[5:0] MEMop;
wire	[4:0] MEMrd;
wire	[4:0] MEMrs;
wire	[4:0] MEMrt;
wire	[31:0] MEMValue;
wire	[31:0] MEMWBTower_IR;
wire	[31:0] MEMWBTower_Value;
wire	[31:0] OLDA;
wire	[31:0] OLDB;
wire	[1:0] Pick;
wire	[4:0] REGtoWrite;
wire	RF_we;
wire	[31:0] ValuetoWriteREG;
wire	[5:0] WBop;
wire	[4:0] WBrd;
wire	[4:0] WBrs;
wire	[4:0] WBrt;





Branch_Prediction	b2v_BranchPredictionHW(
	.Taken(Strategy[0]),
	.DelaySlot(Strategy[1]),
	.IDA(IDA),
	.IDB(IDB),
	.IDop(IDop),
	.IFop(IFop),
	.Fix(Fix),
	.Pick(Pick));


EXMEMTower	b2v_EX_MEM_Tower(
	.reset(reset),
	.clk(clk),
	.EXALUOut(EXALUOut),
	.EXB(EXB),
	.EXIR(EXIR_ALTERA_SYNTHESIZED),
	.MEMALUOut(EXMEMTower_ALUOut),
	.MEMB(EXMEMTower_B),
	.MEMIR(EXMEMTower_IR));


EX	b2v_EXStage(
	.EXStall(EXstall),
	.EXA(IDEXTower_A),
	.EXB(IDEXTower_B),
	.Forward_MEM(ForwardedValuefromMEM),
	.Forward_WB(ForwardedValuefromWB),
	.ForwardA_EX(ForwardA_EX),
	.ForwardB_EX(ForwardB_EX),
	.Instruction(IDEXTower_IR),
	.EXALUB(EXB),
	.EXALUOut(EXALUOut),
	.EXIR(EXIR_ALTERA_SYNTHESIZED),
	.Exop(EXop),
	.EXrd(EXrd),
	.EXrs(EXrs),
	.EXrt(EXrt),
	.OLDA(OLDA),
	.OLDB(OLDB));


ForwardDetection	b2v_ForwardDetectionUnit(
	.EXop(EXop),
	.EXrd(EXrd),
	.EXrs(EXrs),
	.EXrt(EXrt),
	.IDrs(IDrs),
	.IDrt(IDrt),
	.MEMop(MEMop),
	.MEMrd(MEMrd),
	.MEMrs(MEMrs),
	.MEMrt(MEMrt),
	.WBop(WBop),
	.WBrd(WBrd),
	.WBrs(WBrs),
	.WBrt(WBrt),
	.ForwardA_EX(ForwardA_EX),
	.ForwardA_ID(ForwardA_ID),
	.ForwardB_EX(ForwardB_EX),
	.ForwardB_ID(ForwardB_ID));


IDEXTower	b2v_ID_EX_Tower(
	.EXstall(EXstall),
	.reset(reset),
	.clk(clk),
	.IDA(IDA),
	.IDB(IDB),
	.IDIR(IDIRwire),
	.OLDA(OLDA),
	.OLDB(OLDB),
	.EXA(IDEXTower_A),
	.EXB(IDEXTower_B),
	.EXIR(IDEXTower_IR));


ID	b2v_IDStage(
	.IDStall(IDstall),
	.reset(reset),
	.clk(clk),
	.WBwe(RF_we),
	.Forward_MEM(ForwardedValuefromMEM),
	.Forward_WB(ForwardedValuefromWB),
	.ForwardA_ID(ForwardA_ID),
	.ForwardB_ID(ForwardB_ID),
	.Instruction(IFIDTower_IR),
	.WBreg(REGtoWrite),
	.WBvalue(ValuetoWriteREG),
	.IDA(IDA),
	.IDB(IDB),
	.IDIR(IDIRwire),
	.IDof(ID_beq_offset),
	.IDop(IDop),
	.IDrs(IDrs),
	.IDrt(IDrt));


IFIDTower	b2v_IF_ID_Tower(
	.reset(reset),
	.clk(clk),
	.stall(EXstall_or_IDstall),
	.IFIR(IFIRwire),
	.IDIR(IFIDTower_IR));


IFF	b2v_IFStage(
	.reset(reset),
	.clk(clk),
	.Taken(Strategy[0]),
	.Fix(Fix),
	.stall(EXstall_or_IDstall),
	.beq_offset(ID_beq_offset),
	.Pick(Pick),
	._PC(PC),
	.IFIR(IFIRwire),
	.IFop(IFop));

assign	EXstall_or_IDstall = EXstall | IDstall;


MEMWBTower	b2v_MEM_WB_Tower(
	.reset(reset),
	.clk(clk),
	.MEMIR(MEMIRwire),
	.MEMValue(MEMValue),
	.WBIR(MEMWBTower_IR),
	.WBValue(MEMWBTower_Value));


MEMM	b2v_MEMStage(
	.clk(clk),
	.Instruction(EXMEMTower_IR),
	.MEMALUOut(EXMEMTower_ALUOut),
	.MEMB(EXMEMTower_B),
	.MEMForward(ForwardedValuefromMEM),
	.MEMIR(MEMIRwire),
	.MEMop(MEMop),
	.MEMrd(MEMrd),
	.MEMrs(MEMrs),
	.MEMrt(MEMrt),
	.MEMValue(MEMValue));


StallDetection	b2v_StallDetectionUnit(
	.EXop(EXop),
	.EXrd(EXrd),
	.EXrs(EXrs),
	.EXrt(EXrt),
	.IDop(IDop),
	.IDrs(IDrs),
	.IDrt(IDrt),
	.MEMop(MEMop),
	.MEMrt(MEMrt),
	.IDStall(IDstall),
	.EXStall(EXstall));


WB	b2v_WBStage(
	.Instruction(MEMWBTower_IR),
	.WBValue(MEMWBTower_Value),
	.WBwe(RF_we),
	.WBData(ValuetoWriteREG),
	.WBForward(ForwardedValuefromWB),
	.WBop(WBop),
	.WBrd(WBrd),
	.WBReg(REGtoWrite),
	.WBrs(WBrs),
	.WBrt(WBrt));

assign	EXIR = EXIR_ALTERA_SYNTHESIZED;
assign	IDIR = IDIRwire;
assign	IFIR = IFIRwire;
assign	MEMIR = MEMIRwire;
assign	WBIR = MEMWBTower_IR;

endmodule
