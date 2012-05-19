library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.all;


entity regNinteger is
	generic
	(
		N	: integer  :=	32
	);
	
	port
	(
		-- Input ports
		clk		: in std_logic;
		data_in		: in  integer RANGE 0 TO N-1;
		we			: in  std_logic;

		-- Output ports
		data_out	: out integer RANGE 0 TO N-1
	);
end regNinteger;

architecture behaviour of regNinteger is
begin

	process(clk, we) is 
	begin 
		if(clk'event AND clk = '1' and we = '1') then
			data_out <= data_in;
		end if;
	end process; 

end behaviour;

