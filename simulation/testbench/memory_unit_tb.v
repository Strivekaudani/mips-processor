`timescale 1ns / 1ps

module memory_unit_tb();

	reg			clk;
	reg			rst_n;
	reg			we;
	reg [31:0]	addr;
	reg [31:0]	wdata;
	reg 		req;
	
	wire		ack;
	wire [31:0]	rdata;

	memory_unit DUT(
		.clk(clk),
		.rst_n(rst_n),
		.we(we),
		.addr(addr),
		.wdata(wdata),
		.req(req),
		.ack(ack),
		.rdata(rdata)
		);

	always #5 clk = ~clk;

	initial begin
		rst_n	= 0;
		clk		= 0;
		we		= 0;
		addr 	= 0;
		wdata	= 0;
		req		= 0;
		
		repeat(10) @(posedge clk);

		rst_n	= 1;
		
		req		= 1;
		we		= 1;
		addr	= 0;
		wdata 	= $random;

		repeat(5) @(posedge clk);
		we		= 0;

		repeat(5) @(posedge clk);
		req 	= 0;

		repeat(10) @(posedge clk);
		$finish;
	end
endmodule
