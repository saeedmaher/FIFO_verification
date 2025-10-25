package FIFO_trans_pkg;

class FIFO_transaction;
    
    parameter FIFO_WIDTH_TRANS = 16,   
              FIFO_DEPTH_TRANS = 8;

    rand logic [FIFO_WIDTH_TRANS-1:0] data_in_c;
    rand logic rst_n_c, wr_en_c, rd_en_c;
    logic [FIFO_WIDTH_TRANS-1:0] data_out_c;
    logic wr_ack_c, overflow_c;
    logic full_c, empty_c, almostfull_c, almostempty_c, underflow_c;

    integer RD_EN_ON_DIST,WR_EN_ON_DIST;

    constraint reset_rate {
        rst_n_c dist {1:=95,0:=5};
    }

    constraint write_rate {
        wr_en_c dist {1:=WR_EN_ON_DIST,0:=(100-WR_EN_ON_DIST)};
    }

    constraint read_rate {
        rd_en_c dist {1:=RD_EN_ON_DIST,0:=(100-RD_EN_ON_DIST)};
    }

    function new (int i_r = 30 , int i_w = 70);
        this.RD_EN_ON_DIST = i_r;
        this.WR_EN_ON_DIST = i_w;
    endfunction

endclass

endpackage