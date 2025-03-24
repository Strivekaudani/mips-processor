`timescale 1ns / 1ps

module memory ( 
				input wire 			clk,
				input wire 			mem_read,
				input wire 			mem_write,
				input wire [31:0] 	addr,
				input wire [31:0] 	write_data,
				output reg [31:0] 	read_data
				);
					
	reg [31:0] data_mem [0:255];

	always @(posedge clk) begin
		if (mem_write)
			data_mem[addr >> 2] <= write_data;
	end

	always @(*) begin
		if (mem_read)
			read_data = data_mem[addr >> 2];
		else 
			read_data = 32'h0000;
	end
endmodule
