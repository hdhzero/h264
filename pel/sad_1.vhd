------------------------------------------------------------------------------
-- PROJETO: Estimação de Movimento
-- ENTIDADE : sad_1
------------------------------------------------------------------------------
-- DESCRIÇÃO: Componente que faz o calculo da diferenca absoluta entre um 
-- pixel do bloco e um pixel de referencia
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.all;
use work.motion_estimation_8x8_package.all;

entity sad_1 is
generic( N: integer:= 8 );
port
(
	clk: in std_logic;
	blk: in std_logic_vector(N-1 DOWNTO 0);
	ref: in std_logic_vector(N-1 DOWNTO 0);
	we: in std_logic;
	
	result: out std_logic_vector(N-1 DOWNTO 0)
	
);
end entity;

architecture behaviour of sad_1 is
	
	
	component regNbits is
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
	end component;
	
	component unsigned_adder_subtractor is
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
	end component;

	COMPONENT component_abs IS
	GENERIC (DATA_WIDTH: integer := 8);
	PORT
	(
		data		: IN STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0)
	);
	END COMPONENT;
	
	SIGNAL abs_in, sub_result, abs_result, result_temp: std_logic_vector(DATA_WIDTH DOWNTO 0);
	signal data_a_plus_1, data_b_plus_1: std_logic_vector(DATA_WIDTH DOWNTO 0);
begin

	data_a_plus_1 <= '0' & blk;
	data_b_plus_1 <= '0' & ref;
	
	result <= result_temp(DATA_WIDTH-1 DOWNTO 0);
	
	regResult : regNbits
	generic map
	(
		N => DATA_WIDTH + 1
	)
	port map 
	(
		-- Input ports
		clk		 => clk,
		data_in	 => abs_result,
		we		 => we,
		data_out => result_temp
	);

	subSad: unsigned_adder_subtractor
	generic map
	(
		DATA_WIDTH => DATA_WIDTH + 1
	)
	port map
	(
		a		=> data_a_plus_1,
		b		=> data_b_plus_1,
		add_sub => '0',
		result	=> abs_in
	);
	
	absSad: component_abs
	GENERIC MAP (DATA_WIDTH => DATA_WIDTH + 1)
	PORT MAP
	(
		data		=> abs_in,
		result		=> abs_result
	);
	
end behaviour;

	