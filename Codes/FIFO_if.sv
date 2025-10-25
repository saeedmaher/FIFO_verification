interface FIFO_interface(clk);

    parameter FIFO_DEPTH = 8,
              FIFO_WIDTH = 16;
    input clk;
    logic [FIFO_WIDTH-1:0] data_in;
    logic clk, rst_n, wr_en, rd_en;
    logic [FIFO_WIDTH-1:0] data_out;
    logic wr_ack, overflow;
    logic full, empty, almostfull, almostempty, underflow;

    event start_to_sample;


    modport DUT (
    input clk,data_in,rst_n,wr_en,rd_en,
    output data_out,wr_ack,overflow,full,
           empty,almostfull,almostempty,underflow
    );

    modport TEST(
    input clk,data_out,wr_ack,overflow,full,
           empty,almostfull,almostempty,underflow, start_to_sample,
    output data_in,rst_n,wr_en,rd_en
    );

    modport MONITOR (
    input clk,data_in,rst_n,wr_en,rd_en,
           data_out,wr_ack,overflow,full,start_to_sample,
           empty,almostfull,almostempty,underflow
    );

    
endinterface