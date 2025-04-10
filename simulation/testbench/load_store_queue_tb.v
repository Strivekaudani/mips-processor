`timescale 1ns / 1ps

module load_store_queue ();

    reg        clk;
    reg        rst_n;

    // Issue interface
    reg        issue_en;
    reg        is_store;
    reg [4:0]  rob_tag;
    reg [4:0]  addr_tag;
    reg        addr_ready;
    reg [31:0] addr_val;
    reg [4:0]  data_tag;
    reg        data_ready;
    reg [31:0] data_val;

    // CDB input
    reg        cdb_valid;
    reg [4:0]  cdb_tag;
    reg [31:0] cdb_data;

    // Memory issue
    wire         mem_req;
    wire         mem_we;
    wire [31:0]  mem_addr;
    wire [31:0]  mem_data;

    // Memory ack
    reg        mem_ack;
    reg [31:0] mem_read_val;

    // To ROB / CDB
    wire         lsu_done;
    wire [4:0]   lsu_tag;
    wire [31:0]  lsu_val;
 
 	load_store_queue DUT(
		.clk(clk),
		.rst_n(rst_n),
		.issue_en(issue_en),
		.is_store(is_store),
		.rob_tag(rob_tag),
		.addr_tag(addr_tag),
		.addr_ready(addr_ready),
		.addr_val(addr_val),
		.data_tag(data_tag),
		.data_ready(data_ready),
		.data_val(data_val),
		.cdb_valid(cdb_valid),
		.cdb_tag(cdb_tag),
		.cdb_data(cdb_data),
		.mem_req(mem_req),
		.mem_we(mem_we),
		.mem_addr(mem_addr),
		.mem_data(mem_data),
		.mem_ack(mem_ack),
		.mem_read_val(mem_read_val),
		.lsu_done(lsu_done),
		.lsu_tag(lsu_tag),
		.lsu_val(lsu_val)
		);

	always #5 clk = ~clk;

	initial begin
		clk = 0;
		rst_n = 0;
		
		issue_en = 1;
		is_store = 
		rob_tag = 
		addr_ready = 
		addr_tag = 
		addr_val = 
		data_tag = 
		data_ready = 
		data_val = 

