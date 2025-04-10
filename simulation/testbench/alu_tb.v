`timescale 1ns / 1ps

module alu_tb();
	
	reg			clk;
	reg			rst_n;
	reg [5:0] 	opcode;
	reg [31:0] 	op1;
	reg [31:0] 	op2;
	reg [4:0]	dest_tag;
	reg 		start;

	wire		done;
	wire [4:0] 	out_tag;
	wire [31:0]	result;

	alu DUT (
		.clk(clk),
		.rst_n(rst_n),
		.opcode(opcode),
		.op1(op1),
		.op2(op2),
		.dest_tag(dest_tag),
		.start(start),
		.done(done),
		.out_tag(out_tag),
		.result(result)
		);

	always #5 clk = ~clk;

	initial begin
		rst_n 	= 0;
		clk		= 0;

		repeat(10) @(posedge clk);
		rst_n 	= 1;

		repeat(5) @(posedge clk);
		start	= 1;

		opcode	= 6'b000000;
		op1		= $random;
		op2		= $random;
		dest_tag = 5'b01010;
		@(posedge clk);

		start	= 0;
		repeat(5) @(posedge clk);
		$finish;
	end
endmodule


