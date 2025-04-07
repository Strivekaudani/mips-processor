`timescale 1ns / 1ps 

module rename_unit (
	input wire 			clk,
	input wire 			rst_n,
	input wire [4:0]	rs,
	input wire [4:0] 	rt,
	input wire [4:0] 	rd,
	input wire 			has_dest,
	input wire 			issue_enable,
	input wire [4:0] 	rob_tag_alloc,
	
	output reg [4:0] 	rs_tag_out,
	output reg [4:0] 	rt_tag_out,
	output reg			rs_ready,
	output reg			rt_ready,
	output reg [4:0] 	dest_rob_tag_out,
	output wire			stall
	);

	parameter NONE = 5'b11111;

	reg [4:0] RAT [0:31]; // Register Alias Table

	integer i;

	assign stall = 0; // Remember to add logic here to stall if needed

	always @(posedge clk or negedge rst_n) begin
		if(rst_n == 'b0) begin
			for(i = 0; i < 32; i = i + 1)
				RAT[i] <= NONE;
		end else if (issue_enable) begin
			// Read operand rs
			if (RAT[rs] == NONE) begin
				rs_ready 	<= 1;
				rs_tag_out 	<= NONE;
			end else begin
				rs_ready	<= 0;
				rs_tag_out	<= RAT[rs];
			end

			// Read operand rt
			if (RAT[rt] == NONE) begin
				rt_ready	<= 1;
				rt_tag_out	<= NONE;
			end else begin
				rt_ready	<= 0;
				rt_tag_out	<= RAT[rt];
			end

			// Destination Renaming
			if (has_dest) begin
				RAT[rd] 			<= rob_tag_alloc;
				dest_rob_tag_out 	<= rob_tag_alloc;
			end else begin
				dest_rob_tag_out	<= NONE;
			end
		end
	end
endmodule







