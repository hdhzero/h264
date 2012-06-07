source = ../src/vhdl/*.vhd
tests  = qpel_tb

qpel_tb:
	ghdl -i qpel_tb.vhd $(source)
	ghdl -m qpel_tb
	ghdl -r qpel_tb --stop-time=1us --wave=qpel_tb.ghw


clean:
	rm -rf *.cf *.o *.ghw $(tests)
