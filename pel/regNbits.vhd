library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.all;


entity regNbits is
	generic
	(
		N	: integer  :=	32
	);
	
	port
	(
		-- Input ports
		clk		: in std_logic;
		data_in		: in  std_logic_vector(N-1 DOWNTO 0);
		we			: in  std_logic;

		-- Output ports
		data_out	: out std_logic_vector(N-1 DOWNTO 0)
	);
end regNbits;

architecture behaviour of regNbits is
begin

	process(clk, we) is 
	begin 
		if(clk'event AND clk = '1' and we = '1') then
			data_out <= data_in;
		end if;
	end process; 

end behaviour;

