`timescale 1ns / 1ps

module reservation_station_tb ();
	reg 		clk;
	reg			rst_n;

	// Issue Interface
	reg 		issue_en;
	reg [5:0] 	opcode;
	reg [4:0]	tag_dest;
	reg [4:0]	tag_rs;
	reg			rs_ready;
	reg [31:0] 	val_rs;
	reg [4:0]	tag_rt;
	reg			rt_ready;
	reg [31:0] 	val_rt;
	wire		stall;


	// ALU grant
	reg			alu_ready;
	wire		rs_valid_out;
	wire [5:0]	alu_opcode;
	wire [31:0]	alu_op1;
	wire [31:0]	alu_op2;
	wire [4:0] 	alu_dest_tag;

	// CDB input
	reg 		cdb_valid;
	reg [4:0] 	cdb_tag;
	reg [31:0] 	cdb_data;

	integer i;

	reservation_station DUT (
		.clk(clk),
		.rst_n(rst_n),
		.issue_en(issue_en),
		.opcode(opcode),
		.tag_dest(tag_dest),
		.tag_rs(tag_rs),
		.rs_ready(rs_ready),
		.val_rs(val_rs),
		.tag_rt(tag_rt),
		.rt_ready(rt_ready),
		.val_rt(val_rt),
		.stall(stall),
		.alu_ready(alu_ready),
		.rs_valid_out(rs_valid_out),
		.alu_opcode(alu_opcode),
		.alu_op1(alu_op1),
		.alu_op2(alu_op2),
		.alu_dest_tag(alu_dest_tag),
		.cdb_valid(cdb_valid),
		.cdb_tag(cdb_tag),
		.cdb_data(cdb_data)
		);

	always #5 clk = ~clk;

	initial begin

		clk = 0;
		rst_n = 0;
		issue_en = 0;

		repeat(10) @(posedge clk);
		
		rst_n = 1;

		for (i = 0; i < 32; i = i + 1) begin
			// Issue testing
			issue_en = $random;
			opcode = $random;
			tag_dest = $random;
			rs_ready = $random;
			val_rs = $random;
			tag_rs = $random;
			rt_ready = $random;
			val_rt = $random;
			tag_rt = $random;

			//alu issue testing
			alu_ready = $random;

			// CDB update testing
			cdb_valid = $random;
			cdb_tag = $random;
			cdb_data = $random;

			@(posedge clk);
		end

		repeat(10) @(posedge clk);
		$finish;
	end
endmodule
