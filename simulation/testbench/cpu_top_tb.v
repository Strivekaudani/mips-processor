`timescale 1ns / 1ps

module cpu_top_tb ();
    reg 			clk;
    reg 			rst_n;
	reg 			load_mem_en;
	reg [31:0] 		load_mem_data;
	reg [4:0]		load_mem_addr;

	integer 		i;

	reg [31:0] 		instr_mem [0:31];
	
	cpu_top DUT (
		.clk(clk),
		.rst_n(rst_n),
		.load_mem_en(load_mem_en),
		.load_mem_data(load_mem_data),
		.load_mem_addr(load_mem_addr));

	always #5 clk = ~clk;

	initial begin
		clk				= 0;
		rst_n 			= 0;
		load_mem_en 	= 0;
		
		$readmemh("../instructions.mem", instr_mem);

		for (i = 0; i < 32; i = i + 1) 
			$display("Memory loaded: %h", instr_mem[i]);
		
		repeat(10) @(posedge clk);

		rst_n 			= 1;
		load_mem_en  	= 1;
	
		/*
		for (i = 0; i < 32; i = i + 1) begin
			load_mem_addr 	= i;
			load_mem_data 	= instr_mem[i];
			@(posedge clk);
		end
		*/

		load_mem_addr = 0;
		load_mem_data = instr_mem[10];
		@(posedge clk);
			
		load_mem_en = 0;
		
		repeat(33) @(posedge clk);
		$finish;
	end

endmodule


