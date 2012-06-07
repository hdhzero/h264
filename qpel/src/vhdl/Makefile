all:
	ghdl -i *.vhd
	ghdl -m qpel_tb
	ghdl -r qpel_tb --stop-time=1us --wave=x.ghw


clean:
	rm -rf *.cf *.o *.ghw qpel_tb
