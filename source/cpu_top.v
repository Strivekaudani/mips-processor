 `timescale 1ns / 1ps

module cpu_top (
    input wire 			clk,
    input wire 			rst_n,
	input wire 			load_mem_en,
	input wire [31:0] 	load_mem_data,
	input wire [4:0]	load_mem_addr
);
    // Wires to interconnect modules
    wire [31:0] instr, pc;
    wire [5:0] opcode;
    wire [4:0] rs, rt, rd;
    wire [15:0] imm;
    wire is_alu, is_store, is_load;

    // Rename Unit <-> ROB
    wire [4:0] rob_tag_alloc;
    wire rob_full;

    // Register renaming outputs
    wire [4:0] rs_tag, rt_tag, dest_tag;
    wire rs_ready, rt_ready;

    // Reservation station outputs
    wire alu_ready, rs_valid_out;
    wire [5:0] alu_opcode;
    wire [31:0] alu_op1, alu_op2;
    wire [4:0] alu_dest_tag;

    // ALU -> CDB
    wire alu_done;
    wire [4:0] alu_out_tag;
    wire [31:0] alu_result;

    // Common Data Bus
    wire cdb_valid;
    wire [4:0] cdb_tag;
    wire [31:0] cdb_data;

    // LSQ
    wire mem_req, mem_we, mem_ack;
    wire [31:0] mem_addr, mem_wdata, mem_rdata;
    wire lsu_done;
    wire [4:0] lsu_tag;
    wire [31:0] lsu_val;

    // ROB -> Commit
    wire [4:0] commit_arch_reg;
    wire [31:0] commit_val;
    wire commit_en, commit_is_store;
    reg commit_ack;

    // Architectural register file
    wire [31:0] rdata1, rdata2;

    // === Instantiate Modules ===

    instruction_fetch IF (
					.clk(clk), 
					.rst_n(rst_n), 
					.stall(1'b0),
					.load_mem_en(load_mem_en),
					.load_mem_data(load_mem_data),
					.load_mem_addr(load_mem_addr),
					.instr(instr), 
					.pc_out(pc));

    instruction_decode ID (
        					.instr(instr), 
							.opcode(opcode), 
							.rs(rs), 
							.rt(rt), 
							.rd(rd), 
							.imm(imm),
							.is_load(is_load), 
							.is_store(is_store), 
							.is_alu(is_alu));

    rename_unit RU (
        			.clk(clk), 
					.rst_n(rst_n), 
					.rs(rs), 
					.rt(rt), 
					.rd(rd),
        			.has_dest(is_store | is_alu | is_load), 
					.issue_enable(1'b1),
        			.rob_tag_alloc(rob_tag_alloc), 
					.rs_tag_out(rs_tag), 
					.rt_tag_out(rt_tag),
        			.rs_ready(rs_ready), 
					.rt_ready(rt_ready), 
					.dest_rob_tag_out(dest_tag), 
					.stall());

    reservation_station RS (
        					.clk(clk), 
							.rst_n(rst_n), 
							.issue_en(1'b1), 
							.opcode(opcode), 
							.tag_dest(dest_tag),
        					.tag_rs(rs_tag), 
							.rs_ready(rs_ready), 
							.val_rs(32'b0),
        					.tag_rt(rt_tag), 
							.rt_ready(rt_ready), 
							.val_rt(32'b0),
        					.stall(), 
							.alu_ready(alu_ready), 
							.rs_valid_out(rs_valid_out),
        					.alu_opcode(alu_opcode), 
							.alu_op1(alu_op1), 
							.alu_op2(alu_op2), 
							.alu_dest_tag(alu_dest_tag),
        					.cdb_valid(cdb_valid), 
							.cdb_tag(cdb_tag), 
							.cdb_data(cdb_data));

    alu ALU (
        	.clk(clk),
			.rst_n(rst_n),
			.opcode(alu_opcode), 
			.op1(alu_op1), 
			.op2(alu_op2), 
			.dest_tag(alu_dest_tag),
        	.start(rs_valid_out), 
			.done(alu_done), 
			.out_tag(alu_out_tag), 
			.result(alu_result)
    );

    common_data_bus CDB (
        				.clk(clk),
						.rst_n(rst_n),
						.valid_in(alu_done | lsu_done),
        				.tag_in(alu_done ? alu_out_tag : lsu_tag),
        				.data_in(alu_done ? alu_result : lsu_val),
        				.valid_out(cdb_valid), 
						.tag_out(cdb_tag), 
						.data_out(cdb_data));

    load_store_queue LSQ (
        				.clk(clk), 
						.rst_n(rst_n), 
						.issue_en(is_store | is_load), 
						.is_store(is_store),
        				.rob_tag(dest_tag), 
						.addr_tag(rs_tag), 
						.addr_ready(rs_ready), 
						.addr_val(alu_op1),
        				.data_tag(rt_tag), 
						.data_ready(rt_ready), 
						.data_val(alu_op2),
        				.cdb_valid(cdb_valid), 
						.cdb_tag(cdb_tag), 
						.cdb_data(cdb_data),
        				.mem_req(mem_req), 
						.mem_we(mem_we), 
						.mem_addr(mem_addr), 
						.mem_data(mem_wdata),
        				.mem_ack(mem_ack), 
						.mem_read_val(mem_rdata),
        				.lsu_done(lsu_done), 
						.lsu_tag(lsu_tag), 
						.lsu_val(lsu_val));

    memory_unit MEM (
        			.clk(clk),
					.rst_n(rst_n),
					.we(mem_we), 
					.addr(mem_addr), 
					.wdata(mem_wdata), 
					.req(mem_req),
        			.ack(mem_ack), 
					.rdata(mem_rdata));

    reorder_buffer ROB (
        				.clk(clk), 
						.rst_n(rst_n), 
						.allocate(1'b1), 
						.dest_arch_reg(rd), 
						.is_store(is_store),
        				.alloc_tag(rob_tag_alloc), 
						.rob_full(rob_full),
        				.cdb_valid(cdb_valid), 
						.cdb_tag(cdb_tag), 
						.cdb_val(cdb_data),
        				.commit_arch_reg(commit_arch_reg), 
						.commit_val(commit_val),
        				.commit_en(commit_en), 
						.commit_is_store(commit_is_store), 
						.commit_ack(commit_ack));

    reg_file RF (
        		.clk(clk), 
				.rst_n(rst_n), 
				.raddr1(rs), 
				.raddr2(rt),
        		.rdata1(rdata1), 
				.rdata2(rdata2),
        		.we(commit_en & ~commit_is_store), 
				.waddr(commit_arch_reg), 
				.wdata(commit_val));

    // Generate commit ack
    always @(posedge clk or negedge rst_n) begin
        if (rst_n == 1'b0) begin
            commit_ack <= 0;
        end else begin
            commit_ack <= commit_en;
        end
    end

endmodule

