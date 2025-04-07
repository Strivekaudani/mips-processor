`timescale 1ns / 1ps

module instruction_decode (
							input wire 			clk,
							input wire 			rst_n,
							input wire  [31:0] 	instr,
							output wire [31:0] 	reg_data1,
							output wire [31:0]	reg_data2, 
							output wire [31:0] 	sign_ext_imm,
							output wire [4:0]	rs,
							output wire [4:0]	rt,
							output wire [4:0]	rd,
							output wire [5:0]	opcode,
							output wire [5:0]	funct
							);

	reg [31:0] 	reg_file [0:31];
	integer i;

	assign opcode 	= instr[31:36];
	assign rs 		= instr[25:21];
	assign opcode 	= instr[20:16];
	assign opcode 	= instr[15:11];
	assign opcode 	= instr[5:0];

	assign reg_data1 	= reg_file[rs];
	assign reg_data2 	= reg_file[rt];

	assign sign_ext_imm	= {{16{instr[15]}}, instr[15:0]};

	always @(posedge clk or negedge rst_n) 
		begin
			if (rst_n = 'b0) begin
				for (i = 0; i < 32; i = i + 1)
					reg_file[i] <= 32'h0000;
			end
		end
endmodule


