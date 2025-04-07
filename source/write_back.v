`timescale 1ns / 1ps

module write_back (
					input wire 			mem_to_reg,
					input wire  [31:0] 	mem_data,
					input wire  [31:0] 	alu_result,
					output wire [31:0]	write_back_data
					);

	assign write_back_data = mem_to_reg ? mem_data : alu_result;
endmodule
