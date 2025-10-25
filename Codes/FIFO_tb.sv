module FIFO_tb(FIFO_interface.TEST F_if);
    import shared_pkg::*;
    import FIFO_trans_pkg::*;
    FIFO_transaction object_rand;

    task assert_reset();
        F_if.rst_n = 0;
        @(negedge F_if.clk);
        check_reset();
        F_if.rst_n = 1;
    endtask

    task check_reset();
        bit flags_ok;

        if ( F_if.wr_ack == 0 &&
            F_if.underflow == 0 && F_if.overflow == 0
            && F_if.full == 0 && F_if.empty == 1 &&
            F_if.almostfull == 0 && F_if.almostempty == 0) begin
            flags_ok = 1;
        end

        if(flags_ok ) begin
            correct_counter ++;
        end
        else begin
            $display("Error in reset");
            if (!flags_ok) begin
                $display("Error in flags functionality");
            end
        end
    endtask
    
    initial begin

        object_rand = new;
        
        F_if.wr_en = 0;
        F_if.rd_en = 0;
        F_if.data_in = $random;
        assert_reset();
        
        repeat (200) begin
            assert (object_rand.randomize()) 
            F_if.rst_n = object_rand.rst_n_c;
            F_if.wr_en = object_rand.wr_en_c;
            F_if.rd_en = object_rand.rd_en_c;
            F_if.data_in = object_rand.data_in_c; 
            @(negedge F_if.clk);
           -> F_if.start_to_sample;
        end

       
        finish_flg = 1;
        @(negedge F_if.clk);
        -> F_if.start_to_sample;

        
    end
endmodule