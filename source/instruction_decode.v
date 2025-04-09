`timescale 1ns / 1ps

module instruction_decode (
							input wire  [31:0] 	instr,
							output wire [5:0]	opcode,
							output wire [4:0]	rs,
							output wire [4:0]	rt,
							output wire [4:0]	rd,
							output wire [15:0]	imm,
							output wire 		is_load,
							output wire 		is_store,
							output wire 		is_alu
							);

	assign opcode 	= instr[31:26];
	assign rs 		= instr[25:21];
	assign rt 		= instr[20:16];
	assign rd 		= instr[15:11];
	assign imm 		= instr[15:0];

	// MIPS opcode matching
	// R-type ALU	: opcode == 6'b000000
	// LW 			: opcode == 6'b100011
	// SW 			: opcode == 6'b101011
	
	assign is_load 	= (opcode == 6'b100011);
	assign is_store	= (opcode == 6'b101011);
	assign is_alu	= (opcode == 6'b000000);

endmodule


