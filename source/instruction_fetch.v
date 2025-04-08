`timescale 1ns /1ps

module instruction_fetch (
							input wire 			clk,
							input wire 			rst_n,
							input wire 			stall,
							input wire 			load_mem_en,
							input wire 	[31:0] 	load_mem_data,
							input wire 	[3:0]	load_mem_addr,
							output wire [31:0] 	instr,
							output wire [31:0] 	pc_out
							);

	reg [31:0] 	pc;
	reg [31:0] 	instr_mem [0:31];

	always @(posedge clk or negedge rst_n) begin
		if (rst_n == 'b0)
			pc 	<= 32'h0000;
		else if (load_mem_en) 
			instr_mem[load_mem_addr] <= load_mem_data;
		else if (!stall) 
			pc 	<= pc + 32'd4;
	end

	assign instr 	= instr_mem[pc >> 2]; //word aligned access
	assign pc_out 	= pc;
endmodule
