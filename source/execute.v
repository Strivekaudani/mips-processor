`timescale 1ns / 1ps

module execute (
				input wire [31:0] 	reg_data1,
				input wire [31:0] 	reg_data2,
				input wire [31:0] 	imm,
				input wire 			alu_src,
				input wire [2:0] 	alu_op,
				output reg [31:0]	alu_result,
				output wire			zero
				);

	wire [31:0] 	operand2;
	
	assign operand2 = alu_src ? imm : reg_data2;

	always @(*) begin
		case (alu_op)
			3'b010: alu_result = reg_data1 + operand2; // ADD
			3'b110: alu_result = reg_data1 - operand2; // SUB
			3'b000: alu_result = reg_data1 & operand2; // AND
			3'b001: alu_result = reg_data1 | operand2; // OR
			3'b111: alu_result = (reg_data1 < operand2) ? 1 : 0; // SLT
			default: alu_result = 0;
		endcase
	end

	assign zero = (alu_result == 0);
endmodule
			
				
