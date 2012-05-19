library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.motion_estimation_8x8_package.all;
use work.all;

entity mux4x1_regCols is
	port
	(
		--clk: in std_logic;
		-- Input ports
		sel		: in std_logic_vector(1 DOWNTO 0);
		data_a	: in REG_COLS;
		data_b	: in REG_COLS;
		data_c	: in REG_COLS;
		data_d	: in REG_COLS;
		-- Output ports
		data_out : out REG_COLS
	);
end mux4x1_regCols;

architecture behaviour of mux4x1_regCols is

	signal registerOutMux_in, registerOutMux_out: REG_COLS;
begin

	--data_out <= registerOutMux_out;
	
	selection:
		with sel select
	--	registerOutMux_in <= 
	data_out <=
					data_a when "00",
					data_b when "01",
					data_c when "10",
					data_d when "11",
					data_a when others;
					
		--reg: process(clk)
		--begin
		--	if (clk'event and clk = '1') then
		--		registerOutMux_out <= registerOutMux_in;
		--	end if;
		--end process;
end behaviour;

