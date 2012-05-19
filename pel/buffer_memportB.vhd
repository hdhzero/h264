------------------------------------------------------------------------------
-- PROJETO: Estimação de Movimento
-- ENTIDADE : buffer_memportB
------------------------------------------------------------------------------
-- DESCRIÇÃO: Buffers que irão receber os dados de 64 bits para serem gravados
-- nos bancos de registradores de referencia quando ocorre um deslocamento para
-- cima
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.all;
use work.motion_estimation_8x8_package.all;

entity buffer_memportB is
generic(
	N: integer := 64
);
port(
	clk: in std_logic;
	rst: in std_logic;
	we_reg_mp0: in std_logic; -- diz quando gravar valor no registradores
	we_reg_mp1: in std_logic;
	we_reg_mp2: in std_logic;
	
	mem_port_b_value: in REG_COLS;
	
	value_portB_mp0: out REG_COLS;
	value_portB_mp1: out REG_COLS;
	value_portB_mp2: out REG_COLS

);
end entity;

architecture behaviour of buffer_memportB is

begin

	registers: process(clk, we_reg_mp0, we_reg_mp1, we_reg_mp2)
	begin
		if (clk'event and clk = '1') then
			
			if (we_reg_mp0 = '1') then
				value_portB_mp0 <= mem_port_b_value;
			end if;
			
			if (we_reg_mp1 = '1')  then
				value_portB_mp1 <= mem_port_b_value;
			end if;
			
			if (we_reg_mp2 = '1') then
				value_portB_mp2 <= mem_port_b_value;
			end if;
		
		end if;
		
	end process;


end behaviour;