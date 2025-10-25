module top();
    bit clk;
    always begin
        #10
        clk=~clk;
    end

    FIFO_interface F_if (clk);
    FIFO DUT (F_if);
    FIFO_tb TEST (F_if);
    FIFO_monitor MONITOR (F_if);

    //FIFO1
    always_comb begin
        if(!F_if.rst_n) begin
		    reset_top_assertion: assert final(F_if.wr_ack == 0 && 
                                              F_if.overflow == 0 && 
                                              F_if.underflow == 0);
    		reset_top_cover : cover final(F_if.wr_ack == 0 && 
                                          F_if.overflow == 0 && 
                                          F_if.underflow == 0);  
	    end
    end
endmodule