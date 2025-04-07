module load_store_queue (
    input  wire        clk,
    input  wire        rst_n,

    // Issue interface
    input  wire        issue_en,
    input  wire        is_store,
    input  wire [4:0]  rob_tag,
    input  wire [4:0]  addr_tag,
    input  wire        addr_ready,
    input  wire [31:0] addr_val,
    input  wire [4:0]  data_tag,
    input  wire        data_ready,
    input  wire [31:0] data_val,

    // CDB input
    input  wire        cdb_valid,
    input  wire [4:0]  cdb_tag,
    input  wire [31:0] cdb_data,

    // Memory issue
    output reg         mem_req,
    output reg         mem_we,
    output reg [31:0]  mem_addr,
    output reg [31:0]  mem_data,

    // Memory ack
    input  wire        mem_ack,
    input  wire [31:0] mem_read_val,

    // To ROB / CDB
    output reg         lsu_done,
    output reg [4:0]   lsu_tag,
    output reg [31:0]  lsu_val
);
    parameter LSQ_SIZE = 4;
    parameter NONE = 5'b11111;

    reg busy        [0:LSQ_SIZE-1];
    reg entry_store [0:LSQ_SIZE-1];
    reg [4:0] tag    [0:LSQ_SIZE-1];
    reg [4:0] addr_t [0:LSQ_SIZE-1];
    reg [4:0] data_t [0:LSQ_SIZE-1];
    reg [31:0] addr  [0:LSQ_SIZE-1];
    reg [31:0] data  [0:LSQ_SIZE-1];
    reg addr_rdy [0:LSQ_SIZE-1];
    reg data_rdy [0:LSQ_SIZE-1];

    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < LSQ_SIZE; i = i + 1) begin
                busy[i] <= 0;
                addr_rdy[i] <= 0;
                data_rdy[i] <= 0;
            end
            mem_req <= 0;
            lsu_done <= 0;
        end else begin
            mem_req <= 0;
            lsu_done <= 0;

            // === ISSUE NEW ENTRY ===
            if (issue_en) begin
                for (i = 0; i < LSQ_SIZE; i = i + 1) begin
                    if (!busy[i]) begin
                        busy[i]      <= 1;
                        entry_store[i] <= is_store;
                        tag[i]       <= rob_tag;
                        addr_t[i]    <= addr_ready ? NONE : addr_tag;
                        addr[i]      <= addr_ready ? addr_val : 32'bx;
                        addr_rdy[i]  <= addr_ready;
                        data_t[i]    <= data_ready ? NONE : data_tag;
                        data[i]      <= data_ready ? data_val : 32'bx;
                        data_rdy[i]  <= data_ready;
                        break;
                    end
                end
            end

            // === CDB UPDATE ===
            if (cdb_valid) begin
                for (i = 0; i < LSQ_SIZE; i = i + 1) begin
                    if (busy[i]) begin
                        if (!addr_rdy[i] && addr_t[i] == cdb_tag) begin
                            addr[i] <= cdb_data;
                            addr_rdy[i] <= 1;
                        end
                        if (!data_rdy[i] && data_t[i] == cdb_tag) begin
                            data[i] <= cdb_data;
                            data_rdy[i] <= 1;
                        end
                    end
                end
            end

            // === MEMORY ISSUE ===
            for (i = 0; i < LSQ_SIZE; i = i + 1) begin
                if (busy[i] && addr_rdy[i] && (!entry_store[i] || data_rdy[i])) begin
                    mem_req  <= 1;
                    mem_we   <= entry_store[i];
                    mem_addr <= addr[i];
                    mem_data <= data[i];
                    lsu_tag  <= tag[i];

                    if (mem_ack) begin
                        if (entry_store[i]) begin
                            lsu_done <= 1;
                            lsu_val  <= 32'b0;
                        end else begin
                            lsu_done <= 1;
                            lsu_val  <= mem_read_val;
                        end
                        busy[i] <= 0;
                    end
                    break; // issue only one mem op at a time
                end
            end
        end
    end
endmodule

