`timescale 1ns / 1ps

module control (
				input wire [5:0] 	opcode,
				output reg			reg_write,
				output reg			mem_read,
				output reg			mem_write,
				output reg			mem_to_reg,
				output reg 			alu_src,
				output reg [2:0]	alu_op
				);
					

	always @(*) begin
		case (opcode)
				6'b000000: begin // R-type
				reg_write 	= 1;
				alu_src		= 0;
				mem_read	= 0;
				mem_write	= 0;
				mem_to_reg	= 0;
				alu_op 		= 3'b010; // ADD/SUB based on funct
			end

			6'b100011: begin // LW
				reg_write 	= 1;
				alu_src		= 1;
				mem_read	= 1;
				mem_write	= 0;
				mem_to_reg	= 1;
				alu_op 		= 3'b010; 
			end

			6'b000000: begin // SW
				reg_write 	= 0;
				alu_src		= 1;
				mem_read	= 0;
				mem_write	= 1;
				mem_to_reg	= 0; // don't care
				alu_op 		= 3'b010; 
			end

			default: begin 
				reg_write 	= 0;
				alu_src		= 0;
				mem_read	= 0;
				mem_write	= 0;
				mem_to_reg	= 0;
				alu_op 		= 3'b000; 
			end
		endcase
	end
endmodule



				
