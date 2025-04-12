`timescale 1ns / 1ps

module reg_file_tb ();
	reg 			clk;
	reg 			rst_n;
	reg  [4:0]		raddr1;
	reg  [4:0] 		raddr2; 
	wire [31:0]  	rdata1;
	wire [31:0] 	rdata2;

	reg				we;
	reg  [4:0]    	waddr;
	reg  [31:0]		wdata;

	
	reg_file DUT (
		.clk(clk),
		.rst_n(rst_n),
		.raddr1(raddr1),
		.raddr2(raddr2),
		.rdata1(rdata1),
		.we(we),
		.waddr(waddr),
		.wdata(wdata)
		);

	always #5 clk = ~clk;

	initial begin
		clk 		= 0;
		rst_n 		= 0;
		raddr1		= 0;
		raddr2		= 0;
		we			= 0;
		waddr		= 0;
		wdata		= 0;

		repeat(10) @(posedge clk);
		rst_n 		= 1;

		we			= 1;
		waddr		= 1;
		wdata		= $random;
		@(posedge clk);
		waddr		= 2;
		wdata		= $random;

		repeat(10) @(posedge clk);
		raddr1		= 1;
		raddr2		= 2;
		repeat(10) @(posedge clk);
		$finish;
	end
endmodule
		



