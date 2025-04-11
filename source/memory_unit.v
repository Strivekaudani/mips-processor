`timescale 1ns / 1ps

module memory_unit (
	input wire			clk,
	input wire			rst_n,
	input wire			we,
	input wire [31:0]	addr,
	input wire [31:0]	wdata,
	input wire 			req,
	
	output reg			ack,
	output reg [31:0]	rdata
	);

	reg [31:0] mem_array [0:1024]; // 1KB memory, word-addressable

	integer i;

	always @(posedge clk or negedge rst_n) begin
		if (rst_n == 'b0) begin
			for (i = 0; i < 1024; i = i + 1) begin
				mem_array[i] <= 32'd0;
			end
			ack		<= 'b0;
			rdata 	<= 32'd0;
		end else if (req) begin
			if (we) begin
				//Store word
				mem_array[addr >> 2] <= wdata;
			end else begin
				// Load word
				rdata <= mem_array[addr >> 2];
			end
			ack <= 1;
		end else begin
			ack <= 0;
		end
	end
endmodule
