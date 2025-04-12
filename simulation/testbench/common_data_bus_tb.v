`timescale 1ns / 1ps

module common_data_bus_tb ();
	reg 			clk;
	reg				rst_n;
	reg				valid_in;
	reg [4:0] 		tag_in;
	reg [31:0] 		data_in;

	wire 			valid_out;
	wire [4:0] 		tag_out;
	wire [31:0] 	data_out;

	common_data_bus DUT (
		.clk(clk),
		.rst_n(rst_n),
		.valid_in(valid_in),
		.tag_in(tag_in),
		.data_in(data_in),
		.valid_out(valid_out),
		.tag_out(tag_out),
		.data_out(data_out)
		);

	always #5 clk = ~clk;

	initial begin
		clk		= 0;
		rst_n	= 0;
		tag_in	= 5'd0;
		data_in	= 32'd0;

		repeat(10) @(posedge clk);
		rst_n 	= 1;

		valid_in 	= 1;
		tag_in 		= $random;
		data_in		= $random;

		repeat(10) @(posedge clk);
		valid_in 	= 0;
		repeat(10) @(posedge clk);
		$finish;
	end
endmodule


