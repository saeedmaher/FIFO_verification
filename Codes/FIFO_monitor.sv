module FIFO_monitor(FIFO_interface.MONITOR F_if);
import FIFO_coverage_pkg::*;
import FIFO_trans_pkg::*;
import FIFO_scoreboard_pkg::*;
import shared_pkg::*;

FIFO_coverage F_cvr_mon = new;
FIFO_transaction F_trans_mon = new;
FIFO_scoreboard F_sb_mon = new;

initial begin
    forever begin
        //trigger
         @(F_if.start_to_sample);
        @(negedge F_if.clk);
        //save the interface in the object to be sampled and checked
        F_trans_mon.data_in_c = F_if.data_in;
        F_trans_mon.wr_en_c = F_if.wr_en;
        F_trans_mon.rd_en_c = F_if.rd_en;
        F_trans_mon.rst_n_c = F_if.rst_n;
        F_trans_mon.data_out_c = F_if.data_out;
        F_trans_mon.full_c = F_if.full;
        F_trans_mon.almostfull_c = F_if.almostfull;
        F_trans_mon.empty_c = F_if.empty;
        F_trans_mon.almostempty_c = F_if.almostempty;
        F_trans_mon.overflow_c = F_if.overflow;
        F_trans_mon.underflow_c = F_if.underflow;
        F_trans_mon.wr_ack_c = F_if.wr_ack;

        fork
            begin
                if(F_if.rst_n) begin
                   F_cvr_mon.sample_data(F_trans_mon); 
                end
            end
            begin
                F_sb_mon.check_data(F_trans_mon);
            end
        join

        if (finish_flg) begin
            $display("Test is finished");
            $display("error count: %d & correct count: %d",error_counter,correct_counter);
            $stop;
        end

    end
end

endmodule