`timescale 1ns / 1ps

module instruction_decode_tb();

	reg					clk;
	reg  [31:0]			instr;
	wire [5:0]			opcode;
	wire [4:0]			rs;
	wire [4:0]			rt;
	wire [4:0]			rd;
	wire [15:0]			imm;
	wire				is_load;
	wire				is_store;
	wire				is_alu;

	reg [31:0] instr_mem [0:31];

	integer i;

	instruction_decode DUT (
		.instr(instr),
		.opcode(opcode),
		.rs(rs),
		.rt(rt),
		.rd(rd),
		.imm(imm),
		.is_load(is_load),
		.is_store(is_store),
		.is_alu(is_alu)
		);

	always #5 clk = ~ clk;

	initial begin
		clk				= 0;

		repeat(10) @(posedge clk);

		for (i = 0; i < 32; i = i + 1) begin
			instr_mem[i] = $random;
			instr = instr_mem[i]; 
			repeat(1) @(posedge clk);
		end
			
		repeat(33) @(posedge clk);
		$finish;
	end
endmodule


