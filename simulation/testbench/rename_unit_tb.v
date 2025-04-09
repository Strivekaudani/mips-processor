`timescale 1ns / 1ps

module rename_unit_tb ();

	reg 		clk;
	reg 		rst_n;
	reg [4:0] 	rs;
	reg [4:0] 	rt;
	reg [4:0] 	rd;
	reg			has_dest;
	reg			issue_enable;
	reg [4:0] 	rob_tag_alloc;

	wire [4:0] 	rs_tag_out;
	wire [4:0] 	rt_tag_out;

	wire		rs_ready;
	wire		rt_ready;
	wire [4:0] 	dest_rob_tag_out;
	wire		stall;

	integer i;

	rename_unit DUT (
		.clk(clk),
		.rst_n(rst_n),
		.rs(rs),
		.rt(rt),
		.rd(rd),
		.has_dest(has_dest),
		.issue_enable(issue_enable),
		.rob_tag_alloc(rob_tag_alloc),
		.rs_tag_out(rs_tag_out),
		.rt_tag_out(rt_tag_out),
		.rs_ready(rs_ready),
		.rt_ready(rt_ready),
		.dest_rob_tag_out(dest_rob_tag_out),
		.stall(stall)
		);

	always #5 clk = ~clk;

	initial begin
		clk 			= 0;
		rst_n 			= 0;
		issue_enable 	= 0;

		repeat(10) @(posedge clk);
		rst_n = 1;

		for (i = 0; i < 32; i = i + 1) begin
			issue_enable = 1;
			rs 				= $random;
			rt 				= $random;
			rd 				= $random;
			has_dest 		= $random;
			rob_tag_alloc 	= $random;

			@(posedge clk);
		end

		$finish;
	end
endmodule

