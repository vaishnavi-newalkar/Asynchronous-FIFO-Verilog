`timescale 1ns/1ps

module fifo_tb;

parameter DATA_WIDTH = 8;
parameter ADDR_WIDTH = 4;

reg wr_clk;
reg rd_clk;
reg rst;

reg wr_en;
reg rd_en;

reg [DATA_WIDTH-1:0] din;
wire [DATA_WIDTH-1:0] dout;

wire full;
wire empty;

async_fifo #(DATA_WIDTH, ADDR_WIDTH) uut (
    .wr_clk(wr_clk),
    .rd_clk(rd_clk),
    .rst(rst),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .din(din),
    .dout(dout),
    .full(full),
    .empty(empty)
);

always #5 wr_clk = ~wr_clk;   // write clock (100MHz)
always #7 rd_clk = ~rd_clk;   // read clock (different frequency)

initial begin
    wr_clk = 0;
    rd_clk = 0;
    rst = 1;
    wr_en = 0;
    rd_en = 0;
    din = 0;

    #20 rst = 0;

    // Write data
    #10 wr_en = 1;
    repeat(10) begin
        #10 din = din + 1;
    end
    wr_en = 0;

    // Read data
    #50 rd_en = 1;
    #200 rd_en = 0;

    #100 $finish;
end

endmodule