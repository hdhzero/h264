library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.all;


entity regNbits_rst is
	generic
	(
		N	: integer  :=	32;
		RST_VALUE: std_logic :=  '1'
	);
	
	port
	(
		-- Input ports
		clk		: in std_logic;
		rst		: in std_logic;
		data_in		: in  std_logic_vector(N-1 DOWNTO 0);
		we			: in  std_logic;

		-- Output ports
		data_out	: out std_logic_vector(N-1 DOWNTO 0)
	);
end regNbits_rst;

architecture behaviour of regNbits_rst is
	SIGNAL sig_others : std_logic_vector(N-1 DOWNTO 0);
begin

	sig_others <= (others => RST_VALUE);
	process(clk, rst, we) is 
	begin 
		if (rst = '1') then
			data_out <= sig_others;
		elsif(clk'event AND clk = '1' and we = '1') then
			data_out <= data_in;
		end if;
	end process; 

end behaviour;
