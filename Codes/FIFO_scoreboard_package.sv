package FIFO_scoreboard_pkg;
import FIFO_trans_pkg::*;
import shared_pkg::*;


class FIFO_scoreboard;
    
    parameter FIFO_WIDTH_SB = 16,   
              FIFO_DEPTH_SB = 8;

    //FIFO_transaction F_sb_test;
    logic [FIFO_WIDTH_SB-1:0] data_out_ref;
    logic wr_ack_ref, overflow_ref;
    logic full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;

    logic [FIFO_WIDTH_SB-1:0] data_queue [$];

    // bits to determine to do write operation and read operation in refernce model
    bit do_wr,do_rd ;

    task check_data(FIFO_transaction F_sb_test);
        reference_model(F_sb_test);
        //check data out
        if(F_sb_test.data_out_c === data_out_ref) begin
            correct_counter = correct_counter + 1;
        end  
        else begin
            $display("Error: data out exp: %h , got: %h",data_out_ref,F_sb_test.data_out_c);
            error_counter = error_counter + 1;
        end
    endtask

     //FIFO15
    task reference_model(FIFO_transaction F_sb_ref);
        if(!F_sb_ref.rst_n_c) begin
            data_queue.delete();
            wr_ack_ref = 0;
            underflow_ref = 0;
            overflow_ref = 0;
        end
        else begin
            //determine to do write and read operations or not
            if(F_sb_ref.wr_en_c && F_sb_ref.rd_en_c) begin
                //if empty write only
                if(data_queue.size() == 0) begin
                    do_wr = 1;
                    do_rd = 0;
                    underflow_ref = 1;
                end
                //if full read only
                else if (data_queue.size() == FIFO_DEPTH_SB) begin
                    do_wr = 0;
                    do_rd = 1;
                    overflow_ref = 1;
                end
                else begin
                    do_wr = 1;
                    do_rd = 1;
                end
            end
            else begin
                do_wr = F_sb_ref.wr_en_c;
                do_rd = F_sb_ref.rd_en_c;
            end

            //write operation
            if(do_wr) begin
                if (data_queue.size() < FIFO_DEPTH_SB ) begin
                    data_queue.push_back(F_sb_ref.data_in_c);
                    wr_ack_ref = 1;
                    overflow_ref = 0;
                end 
                else begin
                    overflow_ref = 1;
                    wr_ack_ref = 0;
                end
            end
            else begin
                wr_ack_ref = 0;
            end

            //read operation
             if(do_rd) begin
                if (data_queue.size() > 0 ) begin
                    data_out_ref = data_queue.pop_front();
                    underflow_ref = 0;
                end 
                else begin
                    underflow_ref = 1;
                end
            end

            //flags
            full_ref = (data_queue.size() == FIFO_DEPTH_SB);
            empty_ref = (data_queue.size() == 0);
            almostempty_ref = (data_queue.size() == 1);
            almostfull_ref = (data_queue.size() == (FIFO_DEPTH_SB-1));
        end
    endtask

endclass
endpackage