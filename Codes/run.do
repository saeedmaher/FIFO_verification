vlib work
vlog *v  +cover
vsim -voptargs=+acc top -cover
run 0
add wave *
add wave -position insertpoint  \
sim:/top/MONITOR/F_sb_mon \
sim:/top/MONITOR/F_trans_mon
add wave /top/reset_top_assertion /top/DUT/reset_assertion /top/DUT/empty_flag_assertion /top/DUT/full_flag_assertion /top/DUT/almostfull_flag_assertion /top/DUT/almostempty_flag_assertion /top/DUT/assert__acknowledge /top/DUT/assert__overflow_attempt /top/DUT/assert__underflow_attempt /top/DUT/assert__wraparound_write_pointer /top/DUT/assert__wraparound_read_pointer /top/DUT/assert__read_pointer_boundry /top/DUT/assert__write_pointer_boundry /top/DUT/assert__counter_boundry
coverage save FIFO_top.ucdb -onexit
run -all
vcover report FIFO_top.ucdb -details -annotate -all -output coverage_rpt_FIFO.txt