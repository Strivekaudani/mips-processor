`timescale 1ns / 1ps

module reservation_station_tb ();
	reg 		clk,
	reg			rst_n,

	// Issue Interface
	reg 		issue_en,
	reg [5:0] 	opcode,
	reg [4:0]	tag_dest,
	reg [4:0]	tag_rs,
	reg			rs_ready,
	reg [31:0] 	val_rs,
	reg [4:0]	tag_rt,
	reg			rt_ready,
	reg [31:0] 	val_rt,
	wire		stall,


	// ALU grant
	reg			alu_ready,
	wire			rs_valid_out,
	wire [5:0]	alu_opcode,
	wire [31:0]	alu_op1,
	wire [31:0]	alu_op2,
	wire [4:0] 	alu_dest_tag,

	// CDB input
	reg 			cdb_valid,
	reg [4:0] 	cdb_tag,
	reg [31:0] 	cdb_data
	



