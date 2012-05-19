------------------------------------------------------------------------------
-- PROJETO: Estimação de Movimento
-- ENTIDADE : map_addr_a_circular
------------------------------------------------------------------------------
-- DESCRIÇÃO: Faz o deslocamento lógicos dos endereços da memória local para
-- que somente os dados da área de pesquisa que não serão mais utilizados 
-- para o próximo bloco sejam substituídos
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use work.motion_estimation_8x8_package.all;
use ieee.numeric_std.all;

entity map_addr_a_circular is

	generic
	(
		INIT_0: integer := 0;
		INIT_1: integer := 8;
		INIT_2: integer := 16;
 		INIT_3: integer := 24
	);
	port 
	(
		addr    		: in std_logic_vector(MEM_PORT_A_WIDTHAD-1 DOWNTO 0);
		sel				: in std_logic_vector(1 DOWNTO 0);
		map_actual_addr	: out std_logic_vector(MEM_PORT_A_WIDTHAD-1 DOWNTO 0)
	);

end entity;

architecture rtl of map_addr_a_circular is

	-- Build an array type for the shift register
	--type sr_length is array ((NUM_STAGES-1) downto 0) of std_logic_vector(1 DOWNTO 0);
	signal out_mux_addr_a: std_logic_vector(MEM_PORT_A_WIDTHAD-1 DOWNTO 0);
	-- Declare the shift register signal
	signal map_0, map_1, map_2, map_3: MEM_PORT_A_ADDRS;
	signal i: integer;
	
begin

	map_actual_addr	<= out_mux_addr_a; 

	--map_0(0) <= INIT_0;
	--map_0(1) <= INIT_0;
	--map_0(2) <= INIT_0;
	--map_0(3) <= INIT_0;
	--map_0(4) <= INIT_0;
	--map_0(5) <= INIT_0;
	--map_0(6) <= INIT_0;
	--map_0(7) <= INIT_0;
	--map_0(8) <= INIT_0;
	--map_0(9) <= INIT_0;
	--map_0(10) <= INIT_0;
	--map_0(11) <= INIT_0;
	--map_0(12) <= INIT_0;
	--map_0(13) <= INIT_0;
	--map_0(14) <= INIT_0;
	--map_0(15) <= INIT_0;
	--map_0(16) <= INIT_0;
	--map_0(17) <= INIT_0;
	--map_0(18) <= INIT_0;
	--map_0(19) <= INIT_0;
	--map_0(20) <= INIT_0;
	--map_0(21) <= INIT_0;
	--map_0(22) <= INIT_0;
	--map_0(23) <= INIT_0;
	--map_0(24) <= INIT_0;
	--map_0(25) <= INIT_0;
	--map_0(26) <= INIT_0;
	--map_0(27) <= INIT_0;
	--map_0(28) <= INIT_0;
	--map_0(29) <= INIT_0;
	--map_0(30) <= INIT_0;
	--map_0(31) <= INIT_0;
	
	--map_1(0) <= INIT_1;
	--map_2(0) <= INIT_2;
	--map_3(0) <= INIT_3;
	
	for_maps:
	for i in 0 to NUM_MEMORIES-1 generate
		map_0(i) <= std_logic_vector(to_unsigned(i+INIT_0, MEM_PORT_A_WIDTHAD)); 
		map_1(i) <= std_logic_vector(to_unsigned(i+INIT_1, MEM_PORT_A_WIDTHAD)); 
		map_2(i) <= std_logic_vector(to_unsigned(i+INIT_2, MEM_PORT_A_WIDTHAD)); 
		map_3(i) <= std_logic_vector(to_unsigned(i+INIT_3, MEM_PORT_A_WIDTHAD)); 
	end generate;

	mux_addr:
		with sel select
			out_mux_addr_a <= 
					map_0(to_integer(unsigned(addr))) when "00",
					map_1(to_integer(unsigned(addr))) when "01",
					map_2(to_integer(unsigned(addr))) when "10",
					map_3(to_integer(unsigned(addr))) when "11",
					map_0(to_integer(unsigned(addr))) when others;

end rtl;