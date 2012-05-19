------------------------------------------------------------------------------
-- PROJETO: Estimação de Movimento
-- ENTIDADE : component_abs
------------------------------------------------------------------------------
-- DESCRIÇÃO: Retorna o valor absoluto de um numero
------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_SIGNED.ALL;
USE ieee.numeric_std.all;


ENTITY component_abs IS
	GENERIC (DATA_WIDTH: integer := 12);
	PORT
	(
		data		: IN STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0)
	);
END component_abs;

ARCHITECTURE SYN OF component_abs IS

	SIGNAL data_abs: integer;
	SIGNAL s_result: std_logic_vector(DATA_WIDTH-1 DOWNTO 0);

BEGIN

	data_abs <= abs(to_integer(signed(data))); --abs(to_integer(signed(data)));
	s_result <= std_logic_vector(to_unsigned(data_abs, DATA_WIDTH));
	result    <= s_result;

END SYN;
