------------------------------------------------------------------------------
-- PROJETO: Estimação de Movimento
-- ENTIDADE : comp_AeB
------------------------------------------------------------------------------
-- DESCRIÇÃO: Comparador para verificar se dois valores sao iguais
------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY comp_AeB IS
	GENERIC (N: integer := 14);
	PORT
	(
		dataa		: IN STD_LOGIC_VECTOR (N-1 DOWNTO 0);
		datab		: IN STD_LOGIC_VECTOR (N-1 DOWNTO 0);
		AeB		: OUT STD_LOGIC 
	);
END comp_AeB;


ARCHITECTURE SYN OF comp_AeB IS

BEGIN
	comp_process: process(dataa, datab)
	begin
		if (dataa = datab) then
			AeB <= '1';
		else
			AeB <= '0';
		end if;
	end process;
END SYN;