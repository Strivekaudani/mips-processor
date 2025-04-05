`timescale 1ns /1ps

module instruction_fetch (
							input wire 			clk,
							input wire 			rst_n,
							input wire 			pc_src,
							input wire 			stall_fetch,
							output wire [31:0] 	instr,
							output wire [31:0] 	pc_out
							);

	reg [31:0] 	pc;
	reg [31:0] 	instr_mem [0:255];

	initial begin
		$readmemh("mips_program.mem", instr_mem);
	end

	always @(posedge clk or negedge rst_n) begin
		if (rst_n == 'b0)
			pc 	<= 32'h0000;
		else if (!stall_fetch) 
			pc 	<= pc + 32'd4;
	end

	assign instr 	= instr_mem[pc >> 2]; //word aligned access
	assign pc_out 	= pc;
endmodule
