------------------------------------------------------------------------------
-- PROJETO: Estimação de Movimento
-- ENTIDADE : comp
------------------------------------------------------------------------------
-- DESCRIÇÃO: Compara dois valores
------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY comp IS
	GENERIC (N: integer := 14);
	PORT
	(
		dataa		: IN STD_LOGIC_VECTOR (N-1 DOWNTO 0);
		datab		: IN STD_LOGIC_VECTOR (N-1 DOWNTO 0);
		AgB		: OUT STD_LOGIC 
	);
END comp;


ARCHITECTURE SYN OF comp IS

BEGIN
	
	comp_process: process(dataa, datab)
	begin
		if (dataa > datab) then
			AgB <= '1';
		else
			AgB <= '0';
		end if;
	end process;

END SYN;