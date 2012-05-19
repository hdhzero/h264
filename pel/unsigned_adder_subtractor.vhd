-- Quartus II VHDL Template
-- Unsigned Adder/Subtractor

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity unsigned_adder_subtractor is

	generic
	(
		DATA_WIDTH : natural := 8
	);

	port 
	(
		a		: in std_logic_vector ((DATA_WIDTH-1) downto 0);
		b		: in std_logic_vector  ((DATA_WIDTH-1) downto 0);
		add_sub : in std_logic;
		result	: out std_logic_vector  ((DATA_WIDTH-1) downto 0)
	);

end entity;

architecture rtl of unsigned_adder_subtractor is
begin

	process(a,b,add_sub)
	begin
		-- add if "add_sub" is 1, else subtract
		if (add_sub = '1') then
			result <= a + b;
		else
			result <= a - b;
		end if;
	end process;

end rtl;
