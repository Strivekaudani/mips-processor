`timescale 1ns / 1ps

module reg_file (
	input wire 			clk,
	input wire 			rst_n,
	input wire [4:0]	raddr1,
	input wire [4:0] 	raddr2, 
	output wire [31:0]  rdata1,
	output wire [31:0] 	rdata2,

	input wire			we,
	input wire [4:0]    waddr,
	input wire [31:0]	wdata,
	);

	reg [31:0] reg_array [0:31];

	// Asynchronous read
	assign rdata1 = reg_array[raddr1];
	assign rdata2 = reg_array[raddr2];

	// Synchronous write
	always @(posedge clk or negedge rst_n) begin
		if (rst_n == 'b0) begin
			integer i;
			for (i = 0; i < 32; i = i + 1)
				reg_array[i] <= 0;
		end else if (we && waddr != 0) begin
			// Avoid writing to register $zero
			reg_array[waddr] <= wdata;
		end
	end
endmodule
