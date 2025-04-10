`timescale 1ns / 1ps

module alu (
	input wire 			clk,
	input wire			rst_n,
	input wire [5:0] 	opcode,
	input wire [31:0] 	op1,
	input wire [31:0] 	op2,
	input wire [4:0]	dest_tag,
	input wire 			start,

	output reg			done,
	output reg [4:0] 	out_tag,
	output reg [31:0]	result
	);

	// Opcodes for R-type instructions (MIPS style)
	localparam ADD = 6'b000000;
	localparam SUB = 6'b000001;
	localparam AND = 6'b000010;
	localparam OR  = 6'b000011;

	reg processing;

	always @(posedge clk or negedge rst_n) begin
		if (rst_n == 1'b0) begin
			result		<= 32'h0000;
			out_tag		<= 5'b00000;
			done		<= 1'b0;
			processing 	<= 1'b0;
		end else if (start && !processing) begin
			// Simulate 1-cycle execution latency (can extend if needed)
			processing 	<= 1'b1;
			done 		<= 1'b0;

			case (opcode)
				ADD: result	<= op1 + op2;
				SUB: result <= op1 - op2;
				AND: result <= op1 & op2;
				OR:  result <= op1 | op2;
				default: result <= 32'hDEADBEEF; // for unknown opcodes
			endcase

			out_tag <= dest_tag;

		end else if (processing) begin
			done 		<= 1'b1;
			processing 	<= 1'b0;
		end else begin
			done 		<= 1'b0;
		end
	end
endmodule
