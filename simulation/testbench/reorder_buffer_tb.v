`timescale 1ns / 1ps

module reorder_buffer_tb ();
	
	reg        	clk;
    reg        	rst_n;
	
    // New entry allocation
    reg        	allocate;
    reg  [4:0]  dest_arch_reg;
    reg        	is_store;
    wire [4:0]	alloc_tag;
    wire        rob_full;

    // CDB update
    reg        	cdb_valid;
    reg [4:0]  	cdb_tag;
    reg [31:0] 	cdb_val;

    // Commit
    wire [4:0] 	commit_arch_reg;
    wire [31:0] commit_val;
    wire        commit_en;
    wire        commit_is_store;
    reg        	commit_ack;

	reorder_buffer DUT (
		.clk(clk),
		.rst_n(rst_n),
		.allocate(allocate),
		.dest_arch_reg(dest_arch_reg),
		.is_store(is_store),
		.alloc_tag(alloc_tag),
		.rob_full(rob_full),
		.cdb_valid(cdb_valid),
		.cdb_tag(cdb_tag),
		.cdb_val(cdb_val),
		.commit_arch_reg(commit_arch_reg),
		.commit_val(commit_val),
		.commit_en(commit_en),
		.commit_is_store(commit_is_store),
		.commit_ack(commit_ack)
		);

	always #5 clk = ~clk;

	initial begin

		clk 		= 0;
		rst_n		= 0;
		allocate 	= 0;
		dest_arch_reg = 0;
		is_store	= 0;
		cdb_valid 	= 0;
		cdb_val 	= 0;
		cdb_tag		= 0;
		commit_ack 	= 0;


		repeat(10) @(posedge clk);
		rst_n	= 1;

		allocate 		= 1;
		dest_arch_reg 	= 1;
		is_store		= 1;
		
		repeat(5) @(posedge clk);
		allocate		= 0;
		cdb_valid		= 1;
		cdb_val			= $random;
		cdb_tag			= 0;

		repeat(5) @(posedge clk);
		commit_ack		= 1;
		repeat(5) @(posedge clk);
		
		$finish;
	end
endmodule


