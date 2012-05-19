------------------------------------------------------------------------------
-- PROJETO: Estimação de Movimento
-- ENTIDADE : pm_comparator
------------------------------------------------------------------------------
-- DESCRIÇÃO: Integração dos modulos de processamento ao comparador de SADs
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.all;
use work.motion_estimation_8x8_package.all;

entity pm_comparator is

	generic(
		LENGTH_VECTOR: INTEGER := 5; -- qtd de bits para representar cada componente do vetor de movimento
		INICIAL_X_VALUE_MP0: INTEGER := -12;
		INICIAL_Y_VALUE_MP0: INTEGER := -12;
		INICIAL_X_VALUE_MP1: INTEGER := -4;
		INICIAL_Y_VALUE_MP1: INTEGER := -12;
		INICIAL_X_VALUE_MP2: INTEGER := 4;
		INICIAL_Y_VALUE_MP2: INTEGER := -12;
		SHIFT_HORIZONTAL: INTEGER := 7; -- quantidade de deslocamentos na horizontal
		SHIFT_VERTICAL: INTEGER := 24 -- quantidade de deslocamentos na vertical
	);
	port(
		clk: in std_logic;
		rst: in std_logic;
		
		blk : in REG_ROWS;
		start_pm: in std_logic;
		
		motion_vector_x: out std_logic_vector(4 DOWNTO 0);
		motion_vector_y: out std_logic_vector(4 DOWNTO 0);
		
		best_sad: out std_logic_vector(DATA_WIDTH-1 + LEVELS-1 DOWNTO 0);
		
		end_search: out std_logic;
		out_mux_mem_portB: in REG_COLS;
		out_muxes_memories_portA: in REG_COLS;
		portB_buffer_mp0: in REG_COLS;
		portB_buffer_mp1: in REG_COLS;
		portB_buffer_mp2: in REG_COLS;
		start_reference_manager_fill_mp0_out: out std_logic

	);
end entity;

architecture behaviour of pm_comparator is

	component all_processing_module_and_manager IS
	generic(
		LENGTH_VECTOR: INTEGER := 5; -- qtd de bits para representar cada componente do vetor de movimento
		INICIAL_X_VALUE_MP0: INTEGER := -12;
		INICIAL_Y_VALUE_MP0: INTEGER := -12;
		INICIAL_X_VALUE_MP1: INTEGER := -4;
		INICIAL_Y_VALUE_MP1: INTEGER := -12;
		INICIAL_X_VALUE_MP2: INTEGER := 4;
		INICIAL_Y_VALUE_MP2: INTEGER := -12;
		SHIFT_HORIZONTAL: INTEGER := 7; -- quantidade de deslocamentos na horizontal
		SHIFT_VERTICAL: INTEGER := 24 -- quantidade de deslocamentos na vertical
		);
	port(
		clk: in std_logic;
		rst: in std_logic;
		entrada_blk: in REG_ROWS;
		start_control: in std_logic;
		start_comparator: out std_logic;
		
		vector_x_mp0: out std_logic_vector(LENGTH_MOTION_VECTOR-1 DOWNTO 0);
		vector_y_mp0: out std_logic_vector(LENGTH_MOTION_VECTOR-1 DOWNTO 0);
		vector_x_mp1: out std_logic_vector(LENGTH_MOTION_VECTOR-1 DOWNTO 0);
		vector_y_mp1: out std_logic_vector(LENGTH_MOTION_VECTOR-1 DOWNTO 0);
		vector_x_mp2: out std_logic_vector(LENGTH_MOTION_VECTOR-1 DOWNTO 0);
		vector_y_mp2: out std_logic_vector(LENGTH_MOTION_VECTOR-1 DOWNTO 0);
		
		result_mp0: out std_logic_vector(DATA_WIDTH-1 + LEVELS-1 DOWNTO 0);
		result_mp1: out std_logic_vector(DATA_WIDTH-1 + LEVELS-1 DOWNTO 0);
		result_mp2: out std_logic_vector(DATA_WIDTH-1 + LEVELS-1 DOWNTO 0);
		
		end_search: out std_logic;
		out_mux_mem_portB: in REG_COLS;
		out_muxes_memories_portA: in REG_COLS;
		portB_buffer_mp0: in REG_COLS;
		portB_buffer_mp1: in REG_COLS;
		portB_buffer_mp2: in REG_COLS;
		start_reference_manager_fill_mp0_out: out std_logic
	);
	END component;

	
	component comparador_3valores is
	generic(
		COMPARE_VALUES_SIZE: integer := 14;
		VECTOR_SIZE: integer := 10
	);
	port(
		
		clk: in std_logic;
		rst: in std_logic;
		
		sad_result1: in std_logic_vector(COMPARE_VALUES_SIZE-1 DOWNTO 0);
		sad_result2: in std_logic_vector(COMPARE_VALUES_SIZE-1 DOWNTO 0);
		sad_result3: in std_logic_vector(COMPARE_VALUES_SIZE-1 DOWNTO 0);
			
		vector1: in std_logic_vector(VECTOR_SIZE-1 DOWNTO 0); -- VECTOR_SIZE/2  bits para a posicao x e VECTOR_SIZE/2 bits para y
		vector2: in std_logic_vector(VECTOR_SIZE-1 DOWNTO 0);
		vector3: in std_logic_vector(VECTOR_SIZE-1 DOWNTO 0);
		
		best_sad: out std_logic_vector(COMPARE_VALUES_SIZE-1 DOWNTO 0);
		
		motion_vector: out std_logic_vector(VECTOR_SIZE-1 DOWNTO 0)
		
	);
	end component;

	component delay_motion_vectors is
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
	end component;
	
	SIGNAL sig_vector_x_mp0, sig_vector_x_mp1, sig_vector_x_mp2, sig_vector_y_mp0, sig_vector_y_mp1, sig_vector_y_mp2, sig_vector_x_delay_mp0, sig_vector_x_delay_mp1, sig_vector_x_delay_mp2, sig_vector_y_delay_mp0, sig_vector_y_delay_mp1, sig_vector_y_delay_mp2: std_logic_vector(LENGTH_MOTION_VECTOR-1 DOWNTO 0);
	SIGNAL sig_motion_vector, sig_vector1, sig_vector2, sig_vector3: std_logic_vector(LENGTH_MOTION_VECTOR*2-1 DOWNTO 0);
	SIGNAL sig_result_mp0, sig_result_mp1, sig_result_mp2, sig_best_sad: std_logic_vector(DATA_WIDTH-1 + LEVELS-1 DOWNTO 0);
	SIGNAL sig_start_comparator: std_logic;
	SIGNAL sig_start_reference_manager_fill_mp0_out:  std_logic;
begin	
	
	sig_vector1 <= sig_vector_x_delay_mp0 & sig_vector_y_delay_mp0;
	sig_vector2 <= sig_vector_x_delay_mp1 & sig_vector_y_delay_mp1;
	sig_vector3 <= sig_vector_x_delay_mp2 & sig_vector_y_delay_mp2;
	
	motion_vector_x <= sig_motion_vector(9 DOWNTO 5);
	motion_vector_y <= sig_motion_vector(4 DOWNTO 0);
	
	best_sad <= sig_best_sad;


	map_all_processing_module_and_manager: all_processing_module_and_manager
	generic map(
			LENGTH_VECTOR => LENGTH_VECTOR, -- qtd de bits para representar cada componente do vetor de movimento
			INICIAL_X_VALUE_MP0 => INICIAL_X_VALUE_MP0,
			INICIAL_Y_VALUE_MP0 => INICIAL_Y_VALUE_MP0,
			INICIAL_X_VALUE_MP1 => INICIAL_X_VALUE_MP1,
			INICIAL_Y_VALUE_MP1 => INICIAL_Y_VALUE_MP1,
			INICIAL_X_VALUE_MP2 => INICIAL_X_VALUE_MP2,
			INICIAL_Y_VALUE_MP2 => INICIAL_Y_VALUE_MP2,
			SHIFT_HORIZONTAL => SHIFT_HORIZONTAL, -- quantidade de deslocamentos na horizontal
			SHIFT_VERTICAL => SHIFT_VERTICAL -- quantidade de deslocamentos na vertical
	)
	port map(
			clk => clk,
			rst => rst,
			entrada_blk => blk,
			start_control => start_pm,
			start_comparator => sig_start_comparator,
			
			vector_x_mp0 => sig_vector_x_mp0,
			vector_y_mp0 => sig_vector_y_mp0,
			vector_x_mp1 => sig_vector_x_mp1,
			vector_y_mp1 => sig_vector_y_mp1,
			vector_x_mp2 => sig_vector_x_mp2,
			vector_y_mp2 => sig_vector_y_mp2,
			
			result_mp0 => sig_result_mp0,
			result_mp1 => sig_result_mp1,
			result_mp2 => sig_result_mp2,
			
			end_search => end_search,
			out_mux_mem_portB => out_mux_mem_portB,
			out_muxes_memories_portA => out_muxes_memories_portA,
			portB_buffer_mp0 => portB_buffer_mp0,
			portB_buffer_mp1 => portB_buffer_mp1,
			portB_buffer_mp2 => portB_buffer_mp2,
			start_reference_manager_fill_mp0_out => sig_start_reference_manager_fill_mp0_out
	);
	
	map_comparador: comparador_3valores
	generic map(
		COMPARE_VALUES_SIZE => (DATA_WIDTH + LEVELS -1),
		VECTOR_SIZE => LENGTH_MOTION_VECTOR*2
	)
	port map(
		
		clk => clk,
		rst => sig_start_comparator, 
		
		sad_result1 => sig_result_mp0,
		sad_result2 => sig_result_mp1,
		sad_result3 => sig_result_mp2,
			
		vector1 => sig_vector1,
		vector2 => sig_vector2,
		vector3 => sig_vector3,
		
		best_sad => sig_best_sad,
		
		motion_vector => sig_motion_vector
		
	);
	
	map_delay_motion_vector_mp0: delay_motion_vectors
	generic map(
		LEVELS => LEVELS,
		LENGTH_VECTOR => LENGTH_MOTION_VECTOR
	)
	port map(
		clk => clk,
		vector_x_in => sig_vector_x_mp0,
		vector_y_in => sig_vector_y_mp0,
		vector_x_out => sig_vector_x_delay_mp0,
		vector_y_out => sig_vector_y_delay_mp0
	);
	
	map_delay_motion_vector_mp1: delay_motion_vectors
	generic map(
		LEVELS => LEVELS,
		LENGTH_VECTOR => LENGTH_MOTION_VECTOR
	)
	port map(
		clk => clk,
		vector_x_in => sig_vector_x_mp1,
		vector_y_in => sig_vector_y_mp1,
		vector_x_out => sig_vector_x_delay_mp1,
		vector_y_out => sig_vector_y_delay_mp1
	);
	
	map_delay_motion_vector_mp2: delay_motion_vectors
	generic map(
		LEVELS => LEVELS,
		LENGTH_VECTOR => LENGTH_MOTION_VECTOR
	)
	port map(
		clk => clk,
		vector_x_in => sig_vector_x_mp2,
		vector_y_in => sig_vector_y_mp2,
		vector_x_out => sig_vector_x_delay_mp2,
		vector_y_out => sig_vector_y_delay_mp2
	);

	start_reference_manager_fill_mp0_out <= sig_start_reference_manager_fill_mp0_out;
end behaviour;