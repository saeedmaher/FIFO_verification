package FIFO_coverage_pkg;
import FIFO_trans_pkg::*;

class FIFO_coverage;
    FIFO_transaction F_cvg_txn;

    covergroup enable_with_ops;

        //FIFO3 ~> FIFO15
        WR_eanble_CP: coverpoint F_cvg_txn.wr_en_c {
            bins on = {1};
            bins off = {0};
        }

        //FIFO3 ~> FIFO15
        RD_enable_CP: coverpoint F_cvg_txn.rd_en_c{
            bins on = {1};
            bins off = {0};
        }

        //FIFO7
        full_CP: coverpoint F_cvg_txn.full_c{
            bins on = {1};
            bins off = {0};
        }

        //FIFO8
        almostfull_CP: coverpoint F_cvg_txn.almostfull_c{
            bins on = {1};
            bins off = {0};
        }

        //FIFO6
        empty_CP: coverpoint F_cvg_txn.empty_c {
            bins on = {1};
            bins off = {0};
        }

        //FIFO9
        almostempty_CP: coverpoint F_cvg_txn.almostempty_c {
            bins on = {1};
            bins off = {0};
        }

        //FIFO3
        overflow_CP: coverpoint F_cvg_txn.overflow_c {
            bins on = {1};
            bins off = {0};
        }

        //FIFO4
        underflow_CP: coverpoint F_cvg_txn.underflow_c {
            bins on = {1};
            bins off = {0};
        }

        //FIFO3
        wr_ack_CP: coverpoint F_cvg_txn.wr_ack_c {
            bins on = {1};
            bins off = {0};
        }

        //crosses

        //FIFO7
        enable_with_full: cross WR_eanble_CP,RD_enable_CP,full_CP {
            ignore_bins x = binsof(RD_enable_CP.on) && binsof(full_CP.on);
        }

        //FIFO8
        enable_with_almostfull: cross WR_eanble_CP,RD_enable_CP,almostfull_CP;
        
        //FIFO6
        enable_with_empty: cross WR_eanble_CP,RD_enable_CP,empty_CP {
            ignore_bins x = binsof(WR_eanble_CP.on) && binsof(empty_CP.on);
        }

        //FIFO9
        enable_with_almostempty: cross WR_eanble_CP,RD_enable_CP,almostempty_CP;
        
        enable_with_overflow: cross WR_eanble_CP,RD_enable_CP,overflow_CP {
            ignore_bins x = binsof(WR_eanble_CP.off) && binsof(overflow_CP.on);
        }
        
        //FIFO5
        enable_with_underflow: cross WR_eanble_CP,RD_enable_CP,underflow_CP {
            ignore_bins x = binsof(RD_enable_CP.off) && binsof(underflow_CP.on);
        }
        
        //FIFO3
        enable_with_ack: cross WR_eanble_CP,RD_enable_CP,wr_ack_CP {
            ignore_bins x = binsof(WR_eanble_CP.off) && binsof(wr_ack_CP.on);
        }

    endgroup

    function void sample_data(FIFO_transaction F_txn);
        F_cvg_txn = F_txn;
        enable_with_ops.sample();
    endfunction

    function new ();
        enable_with_ops = new;
        F_cvg_txn = new;
    endfunction


endclass


endpackage