`timescale 1ns / 1ps

module reorder_buffer (
    input  wire        clk,
    input  wire        rst_n,

    // New entry allocation
    input  wire        allocate,
    input  wire [4:0]  dest_arch_reg,
    input  wire        is_store,
    output reg  [4:0]  alloc_tag,
    output wire        rob_full,

    // CDB update
    input  wire        cdb_valid,
    input  wire [4:0]  cdb_tag,
    input  wire [31:0] cdb_val,

    // Commit
    output reg  [4:0]  commit_arch_reg,
    output reg  [31:0] commit_val,
    output reg         commit_en,
    output reg         commit_is_store,
    input  wire        commit_ack
);
    parameter ROB_SIZE 	= 8;
    parameter NONE 		= 5'b11111;

    reg 		valid    [0:ROB_SIZE-1];
    reg 		ready    [0:ROB_SIZE-1];
    reg [4:0] 	arch_reg [0:ROB_SIZE-1];
    reg [31:0] 	value    [0:ROB_SIZE-1];
    reg 		is_str   [0:ROB_SIZE-1];

    reg [2:0] 	head, tail;

	wire empty, full;
	integer i;


    assign empty = (head == tail) && !valid[head];
    assign full = (head == tail) && valid[head];
    assign rob_full = full;


    always @(posedge clk or negedge rst_n) begin
        if (rst_n == 1'b0) begin
            head 		<= 0;
            tail 		<= 0;
            commit_en 	<= 0;
            for (i = 0; i < ROB_SIZE; i = i + 1) begin
                valid[i] <= 0;
                ready[i] <= 0;
            end
        end else begin
            // === Allocate ===
            if (allocate && !rob_full) begin
                valid[tail]     <= 1;
                ready[tail]     <= 0;
                arch_reg[tail]  <= dest_arch_reg;
                is_str[tail]    <= is_store;
                alloc_tag       <= tail;
                tail            <= (tail + 1) % ROB_SIZE;
            end else begin
                alloc_tag <= NONE;
            end

            // === CDB Broadcast ===
            if (cdb_valid) begin
                ready[cdb_tag] <= 1;
                value[cdb_tag] <= cdb_val;
            end

            // === Commit ===
            commit_en <= 0;
            if (valid[head] && ready[head]) begin
                commit_arch_reg <= arch_reg[head];
                commit_val      <= value[head];
                commit_is_store <= is_str[head];
                commit_en       <= 1;

                if (commit_ack) begin
                    valid[head] <= 0;
                    head <= (head + 1) % ROB_SIZE;
                end
            end
        end
    end


endmodule
