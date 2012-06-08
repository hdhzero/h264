source = ../src/vhdl/*.vhd
tests  = qpel_tb qp_sad_tree_tb qp_compare_tb

qpel_tb:
	ghdl -i qpel_tb.vhd $(source)
	ghdl -m qpel_tb
	ghdl -r qpel_tb --stop-time=1us --wave=qpel_tb.ghw

qp_sad:
	ghdl -i qp_sad_tree_tb.vhd $(source)
	ghdl -m qp_sad_tree_tb
	ghdl -r qp_sad_tree_tb --stop-time=1us --wave=qp_sad_tree_tb.ghw

qp_compare:
	ghdl -i qp_compare_tb.vhd $(source)
	ghdl -m qp_compare_tb
	ghdl -r qp_compare_tb --stop-time=1us --wave=qp_compare_tb.ghw

clean:
	rm -rf *.cf *.o *.ghw $(tests)
