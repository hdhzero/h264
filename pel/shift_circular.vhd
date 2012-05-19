------------------------------------------------------------------------------
-- PROJETO: Estimação de Movimento
-- ENTIDADE : shift_circular
------------------------------------------------------------------------------
-- DESCRIÇÃO: Lista circular de endereços de leitura da memória local para
-- possibilitar o deslocamento apenas lógico de dados.
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use work.motion_estimation_8x8_package.all;
use ieee.numeric_std.all;

entity shift_circular is

	generic
	(
		NUM_STAGES : natural := 4
	);
	port 
	(
		clk	    : in std_logic;
		enable	: in std_logic;
		start   : in std_logic;
		sr_out	: out SR_LENGTH
	);

end entity;

architecture rtl of shift_circular is

	-- Build an array type for the shift register
	--type sr_length is array ((NUM_STAGES-1) downto 0) of std_logic_vector(1 DOWNTO 0);

	-- Declare the shift register signal
	signal sr: SR_LENGTH;
	signal i: integer;
begin

	process (clk, start, enable)
	begin
		if (start = '1') then
			
			sr(0) <= std_logic_vector(to_unsigned(0, MEM_PORT_B_WIDTHAD));
			sr(1) <= std_logic_vector(to_unsigned(1, MEM_PORT_B_WIDTHAD));
			sr(2) <= std_logic_vector(to_unsigned(2, MEM_PORT_B_WIDTHAD));
			sr(3) <= std_logic_vector(to_unsigned(3, MEM_PORT_B_WIDTHAD));
			
		elsif (rising_edge(clk)) then

			if (enable = '1') then

				sr(0) <= sr(1);
				sr(1) <= sr(2); 
				sr(2) <= sr(3);
				sr(3) <= sr(0);

			end if;
		end if;
	end process;

	sr_out <= sr;

end rtl;