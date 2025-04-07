`timescale 1ns / 1ps

module common_data_bus (
	input wire 				clk,
	input wire				rst_n,
	input wire [4:0] 		tag_in,
	input wire [31:0] 		data_in,

	output reg 				valid_out,
	output reg [4:0] 		tag_out,
	output reg [31:0] 		data_out
	);

	always @(posedge clk or negedge rst_n) begin
		if (rst_n == 'b0) begin
			valid_out 	<= 1'b0;
			tag_out		<= 5'b00000;
			data_out	<= 32'd0;
		end else if (valid_in) begin
			tag_out 	<= tag_in;
			data_out	<= data_in;
			valid_out	<= 1'b1;
		end else begin
			valid_out	<= 1'b0;
		end
	end
endmodule
