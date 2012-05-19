------------------------------------------------------------------------------
-- PROJETO: Estimação de Movimento
-- ENTIDADE : delay_motion_vectors
------------------------------------------------------------------------------
-- DESCRIÇÃO: Atrasa os valores dos vetores de movimento dos blocos candidatos
-- para entrarem no comparador somente quando o valor do SAD do respectivo
-- bloco estiver pronto.
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.all;
use work.motion_estimation_8x8_package.all;

entity delay_motion_vectors is
generic (
	LEVELS: 	integer := 8;
	LENGTH_VECTOR: integer := 5
);
port(
	clk: in std_logic;
	vector_x_in: in std_logic_vector(LENGTH_VECTOR-1 DOWNTO 0);
	vector_y_in: in std_logic_vector(LENGTH_VECTOR-1 DOWNTO 0);
	vector_x_out: out std_logic_vector(LENGTH_VECTOR-1 DOWNTO 0);
	vector_y_out: out std_logic_vector(LENGTH_VECTOR-1 DOWNTO 0)
);
end entity;

architecture behaviour of delay_motion_vectors is

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
	
	TYPE STDLV_REGISTER_VECTORS IS ARRAY (LEVELS-1 DOWNTO 0) OF STD_LOGIC_VECTOR(LENGTH_VECTOR-1 DOWNTO 0);
	SIGNAL i: INTEGER RANGE 0 TO LEVELS-1;
	SIGNAL we_regs_x, we_regs_y: std_logic_vector(LEVELS-1 DOWNTO 0);
	SIGNAL sig_registers_x_out, sig_registers_y_out: STDLV_REGISTER_VECTORS;

begin		
	
	vector_x_out <= sig_registers_x_out(LEVELS-1);
	vector_y_out <= sig_registers_y_out(LEVELS-1);
	we_regs_y <= (others => '1');
	we_regs_x <= (others => '1');
	
	for_generate_registers:
	FOR i IN 0 TO LEVELS-1 GENERATE
		
		if_regx_0:
		IF (i = 0) GENERATE
		map_regs_x_0: regNbits
			generic map
			(
				N	=> LENGTH_VECTOR
			)
			port map
			(
				-- Input ports
				clk		=> clk,
				data_in	=> vector_x_in,	
				we		=> we_regs_x(i),

				-- Output ports
				data_out =>	sig_registers_x_out(i)
			);
		END GENERATE;
		
		if_regy_0:
		IF (i = 0) GENERATE
			map_regs_y_0: regNbits
			generic map
			(
				N	=> LENGTH_VECTOR
			)
			port map
			(
				-- Input ports
				clk		=> clk,
				data_in	=> vector_y_in,	
				we		=> we_regs_y(i),

				-- Output ports
				data_out =>	sig_registers_y_out(i)
			);
		END GENERATE;
		
		if_regx:
		IF (i /= 0) GENERATE
			map_regs_x: regNbits
			generic map
			(
				N	=> LENGTH_VECTOR
			)
			port map
			(
				-- Input ports
				clk		=> clk,
				data_in	=> sig_registers_x_out(i-1),	
				we		=> we_regs_x(i),

				-- Output ports
				data_out =>	sig_registers_x_out(i)
			);
		END GENERATE;
		
		if_regy:
		IF (i /= 0) GENERATE
			map_regs_y: regNbits
			generic map
			(
				N	=> LENGTH_VECTOR
			)
			port map
			(
				-- Input ports
				clk		=> clk,
				data_in	=> sig_registers_y_out(i-1),	
				we		=> we_regs_y(i),

				-- Output ports
				data_out =>	sig_registers_y_out(i)
			);
		END GENERATE;
		
	END GENERATE;
	
	
end behaviour;