`timescale 1ns / 1ps

module reservation_station (
	input wire 			clk,
	input wire 			rst_n,

	// Issue Interface
	input wire 			issue_en,
	input wire [5:0] 	opcode,
	input wire [4:0]	tag_dest,
	input wire [4:0]	tag_rs,
	input wire			rs_ready,
	input wire [31:0] 	val_rs,
	input wire [4:0]	tag_rt,
	input wire			rt_ready,
	input wire [31:0] 	val_rt,
	output wire			stall,


	// ALU grant
	input wire			alu_ready,
	output reg			rs_valid_out,
	output reg [5:0]	alu_opcode,
	output reg [31:0]	alu_op1,
	output reg [31:0]	alu_op2,
	output reg [4:0] 	alu_dest_tag,

	// CDB input
	input wire 			cdb_valid,
	input wire [4:0] 	cdb_tag,
	input wire [31:0] 	cdb_data
	);

	parameter RS_SIZE 	= 2;
	parameter NONE		= 5'b11111;

	reg 				busy [0:RS_SIZE-1];
	reg [5:0] 			op [0:RS_SIZE-1];
	reg [31:0]			Vj [0:RS_SIZE-1];
	reg [31:0]			Vk [0:RS_SIZE-1];
	reg [4:0]			Qj [0:RS_SIZE-1];
	reg [4:0]			Qk [0:RS_SIZE-1];
	reg [4:0]			dest_tag [0:RS_SIZE-1];

	reg					i_toggle;
	reg					a_toggle;
	

	integer i;

	assign stall = ~(~busy[0] | ~busy[1]); // Stall if no RS is free

	always @(posedge clk or negedge rst_n) begin
		if (rst_n == 'b0) begin
			for (i = 0; i < RS_SIZE; i = i + 1) begin
				busy[i] 	<= 0;
				Qj[i]		<= NONE;
				Qk[i]		<= NONE;
			end
			rs_valid_out	<= 0;
			i_toggle		<= 0;
			a_toggle		<= 0;
		end else begin
			rs_valid_out 	<= 0;
			i_toggle		<= 0;
			a_toggle		<= 0;

			// Issue stage: find an empty slot
			if (issue_en) begin
				for (i = 0; i < RS_SIZE; i = i + 1) begin
					if (!busy[i] && !i_toggle) begin
						busy[i]		<= 1;
						op[i]		<= opcode;
						dest_tag[i] <= tag_dest;

						if (rs_ready) begin
							Vj[i] 	<= val_rs;
							Qj[i]	<= NONE;
						end else begin
							Qj[i]	<= tag_rs;
						end

						if (rt_ready) begin
							Vk[i]	<= val_rt;
							Qk[i]	<= NONE;
						end else begin
							Qk[i] 	<= tag_rt;
						end

						//break;
						i_toggle	<= 1;
					end
				end
			end

			// ALU Issue Stage
			if (alu_ready) begin
				for (i = 0; i < RS_SIZE; i = i + 1) begin
					if (!a_toggle && busy[i] && Qj[i] == NONE && Qk[i] == NONE) begin
						alu_opcode		<= op[i];
						alu_op1			<= Vj[i];
						alu_op2			<= Vk[i];
						alu_dest_tag	<= dest_tag[i];
						rs_valid_out	<= 1;
						busy[i]			<= 0;

						a_toggle		<= 1;
						//break;
					end
				end
			end

			// CDB update (writeback to RS)
			if (cdb_valid) begin
				for (i = 0; i < RS_SIZE; i = i + 1) begin
					if (busy[i]) begin
						if (Qj[i] == cdb_tag) begin
							Vj[i] <= cdb_data;
							Qj[i] <= NONE;
						end
						if (Qk[i] == cdb_tag) begin
							Vk[i] <= cdb_data;
							Qk[i] <= NONE;
						end
					end
				end
			end
		end
	end
endmodule



