////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(FIFO_interface.DUT F_if); 

localparam max_fifo_addr = $clog2(F_if.FIFO_DEPTH);

reg [F_if.FIFO_WIDTH-1:0] mem [F_if.FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge F_if.clk or negedge F_if.rst_n) begin
	if (!F_if.rst_n) begin
		wr_ptr <= 0;
		F_if.wr_ack <= 0;
		F_if.overflow <= 0;
	end
	else if (F_if.wr_en && count < F_if.FIFO_DEPTH) begin
		mem[wr_ptr] <= F_if.data_in;
		F_if.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
		F_if.overflow <= 0;
	end
	else begin 
		F_if.wr_ack <= 0; 
		if (F_if.full && F_if.wr_en)
			F_if.overflow <= 1;
		else
			F_if.overflow <= 0;
	end
end

always @(posedge F_if.clk or negedge F_if.rst_n) begin
	if (!F_if.rst_n) begin
		rd_ptr <= 0;
		F_if.underflow <= 0;
	end
	else if (F_if.rd_en && count != 0) begin
		F_if.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
		F_if.underflow <= 0;
	end
	else begin 
		if (F_if.empty && F_if.rd_en) begin
			F_if.underflow <= 1;
		end
		else begin
			F_if.underflow <= 0;
		end
	end
end

always @(posedge F_if.clk or negedge F_if.rst_n) begin
	if (!F_if.rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({F_if.wr_en, F_if.rd_en} == 2'b10) && !F_if.full) begin
			count <= count + 1;
		end
		else if ( ({F_if.wr_en, F_if.rd_en} == 2'b01) && !F_if.empty) begin
			count <= count - 1;
		end
		else if (({F_if.wr_en, F_if.rd_en} == 2'b11) && F_if.empty) begin
			count <= count + 1;
		end
		else if ( ({F_if.wr_en, F_if.rd_en} == 2'b11) && F_if.full) begin
			count <= count - 1;
		end
	end
end

assign F_if.full = (count == F_if.FIFO_DEPTH)? 1 : 0;
assign F_if.empty = (count == 0)? 1 : 0;
assign F_if.almostfull = (count == F_if.FIFO_DEPTH-1)? 1 : 0; 
assign F_if.almostempty = (count == 1)? 1 : 0;


//assertions

//FIFO2 7 FIFO6 ~> FIFO9
always_comb begin
	//FIFO2
	if(!F_if.rst_n) begin
		reset_assertion: assert final(count == 0 && wr_ptr == 0 && 
									F_if.wr_ack == 0 && F_if.overflow == 0 && 
									rd_ptr == 0 && F_if.underflow == 0);
		reset_cover : cover final(count == 0 && wr_ptr == 0 && 
									F_if.wr_ack == 0 && F_if.overflow == 0 && 
									rd_ptr == 0 && F_if.underflow == 0);	  
	end

	//FIFO6
	if (count == 0) begin
		empty_flag_assertion: assert (F_if.empty);
		empty_flag_cover: cover (F_if.empty);
	end

	//FIFO7
	if (count == F_if.FIFO_DEPTH) begin
		full_flag_assertion: assert (F_if.full);
		full_flag_cover: cover (F_if.full);
	end

	//FIFO8
	if (count == F_if.FIFO_DEPTH-1) begin
		almostfull_flag_assertion: assert (F_if.almostfull);
		almostfull_flag_cover: cover (F_if.almostfull);
	end

	//FIFO9
	if (count == 1) begin
		almostempty_flag_assertion: assert (F_if.almostempty);
		almostempty_flag_cover: cover (F_if.almostempty);
	end
end

//FIFO3
property acknowledge;
	@(posedge F_if.clk) disable iff(!F_if.rst_n)
	(F_if.wr_en && !(F_if.full)) |=> F_if.wr_ack; 
endproperty

assert property (acknowledge);
cover property (acknowledge);


//FIFO4
property overflow_attempt;
	@(posedge F_if.clk) disable iff(!F_if.rst_n)
	(F_if.wr_en && F_if.full) |=> F_if.overflow; 
endproperty

assert property (overflow_attempt);
cover property (overflow_attempt);

//FIFO5
property underflow_attempt;
	@(posedge F_if.clk) disable iff(!F_if.rst_n)
	(F_if.rd_en && F_if.empty) |=> F_if.underflow; 
endproperty

assert property (underflow_attempt);
cover property (underflow_attempt);

//FIFO10
property wraparound_write_pointer;
	@(posedge F_if.clk) disable iff(!F_if.rst_n)
	((wr_ptr == F_if.FIFO_DEPTH-1) && !F_if.full && F_if.wr_en) |=> (wr_ptr == 0); 
endproperty

assert property (wraparound_write_pointer);
cover property (wraparound_write_pointer);

//FIFO11
property wraparound_read_pointer;
	@(posedge F_if.clk) disable iff(!F_if.rst_n)
	((rd_ptr == F_if.FIFO_DEPTH-1) && !F_if.empty && F_if.rd_en) |=> (rd_ptr == 0); 
endproperty

assert property (wraparound_read_pointer);
cover property (wraparound_read_pointer);

//FIFO13
property read_pointer_boundry;
	@(posedge F_if.clk) disable iff(!F_if.rst_n)
	(rd_ptr == F_if.FIFO_DEPTH-1) |=> !(rd_ptr >= F_if.FIFO_DEPTH);
endproperty

assert property (read_pointer_boundry);
cover property (read_pointer_boundry);

//FIFO12
property write_pointer_boundry;
	@(posedge F_if.clk) disable iff(!F_if.rst_n)
	(wr_ptr == F_if.FIFO_DEPTH-1) |=> !(wr_ptr >= F_if.FIFO_DEPTH);
endproperty

assert property (write_pointer_boundry);
cover property (write_pointer_boundry);

//FIFO14
property counter_boundry;
	@(posedge F_if.clk) disable iff(!F_if.rst_n)
	(count == F_if.FIFO_DEPTH) |=> !(count > F_if.FIFO_DEPTH);
endproperty

assert property (counter_boundry);
cover property (counter_boundry);





endmodule