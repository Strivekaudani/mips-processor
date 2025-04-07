`timescale 1ns / 1ps

module instruction_fetch_tb();

	reg 				clk;
	reg 				rst_n;
	reg					stall_fetch;
	wire [31:0] 			instr;
	wire [31:0] 			pc_out;

	instruction_fetch DUT (
		.clk(clk),
		.rst_n(rst_n),
		.stall_fetch(stall_fetch),
		.instr(instr),
		.pc_out(pc_out)
		);

	always #5 clk = ~ clk;

	initial begin
		clk 		= 0;
		rst_n 		= 0;
		stall_fetch = 0;
		
		repeat(10) @(posedge clk);
		rst_n 		= 1;


		repeat(100) @(posedge clk);
		$finish;
	end
endmodule






