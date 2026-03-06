module async_fifo #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 4
)(
    input  wire wr_clk,
    input  wire rd_clk,
    input  wire rst,

    input  wire wr_en,
    input  wire rd_en,

    input  wire [DATA_WIDTH-1:0] din,
    output reg  [DATA_WIDTH-1:0] dout,

    output wire full,
    output wire empty
);

localparam DEPTH = (1 << ADDR_WIDTH);

reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

reg [ADDR_WIDTH:0] wr_ptr_bin = 0;
reg [ADDR_WIDTH:0] rd_ptr_bin = 0;

reg [ADDR_WIDTH:0] wr_ptr_gray = 0;
reg [ADDR_WIDTH:0] rd_ptr_gray = 0;

reg [ADDR_WIDTH:0] rd_ptr_gray_sync1, rd_ptr_gray_sync2;
reg [ADDR_WIDTH:0] wr_ptr_gray_sync1, wr_ptr_gray_sync2;

integer i;

always @(posedge wr_clk or posedge rst) begin
    if (rst) begin
        wr_ptr_bin  <= 0;
        wr_ptr_gray <= 0;
    end
    else if (wr_en && !full) begin
        mem[wr_ptr_bin[ADDR_WIDTH-1:0]] <= din;
        wr_ptr_bin <= wr_ptr_bin + 1;
        wr_ptr_gray <= (wr_ptr_bin + 1) ^ ((wr_ptr_bin + 1) >> 1);
    end
end

always @(posedge rd_clk or posedge rst) begin
    if (rst) begin
        rd_ptr_bin  <= 0;
        rd_ptr_gray <= 0;
        dout <= 0;
    end
    else if (rd_en && !empty) begin
        dout <= mem[rd_ptr_bin[ADDR_WIDTH-1:0]];
        rd_ptr_bin <= rd_ptr_bin + 1;
        rd_ptr_gray <= (rd_ptr_bin + 1) ^ ((rd_ptr_bin + 1) >> 1);
    end
end

always @(posedge wr_clk or posedge rst) begin
    if (rst) begin
        rd_ptr_gray_sync1 <= 0;
        rd_ptr_gray_sync2 <= 0;
    end
    else begin
        rd_ptr_gray_sync1 <= rd_ptr_gray;
        rd_ptr_gray_sync2 <= rd_ptr_gray_sync1;
    end
end

always @(posedge rd_clk or posedge rst) begin
    if (rst) begin
        wr_ptr_gray_sync1 <= 0;
        wr_ptr_gray_sync2 <= 0;
    end
    else begin
        wr_ptr_gray_sync1 <= wr_ptr_gray;
        wr_ptr_gray_sync2 <= wr_ptr_gray_sync1;
    end
end

assign full = (wr_ptr_gray == {~rd_ptr_gray_sync2[ADDR_WIDTH:ADDR_WIDTH-1],
                              rd_ptr_gray_sync2[ADDR_WIDTH-2:0]});

assign empty = (rd_ptr_gray == wr_ptr_gray_sync2);

endmodule