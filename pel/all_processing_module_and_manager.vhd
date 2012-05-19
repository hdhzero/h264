------------------------------------------------------------------------------
-- PROJETO: Estimação de Movimento
-- ENTIDADE : all_processing_module_and_manager
------------------------------------------------------------------------------
-- DESCRIÇÃO: Integração dos módulos de processamento aos controles locais.
------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
use std.textio.all; --
use work.motion_estimation_8x8_package.all;

ENTITY all_processing_module_and_manager IS
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
END entity;

architecture comportamento of all_processing_module_and_manager is
		 
		component all_processing_module is
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

			start_sad_manager_mp0: in std_logic;
			start_reference_manager_fill_mp0 : in std_logic;
			start_reference_manager_shifts_mp0 : in std_logic;
			
			start_sad_manager_mp1: in std_logic;
			start_reference_manager_fill_mp1 : in std_logic;
			start_reference_manager_shifts_mp1 : in std_logic;
			
			start_sad_manager_mp2: in std_logic;
			start_reference_manager_fill_mp2 : in std_logic;
			start_reference_manager_shifts_mp2 : in std_logic;
			
			sel_mux_data_in_ref_mp0: in std_logic_vector(1 DOWNTO 0);
			sel_mux_data_in_ref_mp1: in std_logic_vector(1 DOWNTO 0);
			sel_mux_data_in_ref_mp2: in std_logic_vector(1 DOWNTO 0); 
			
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
			portB_buffer_mp2: in REG_COLS
		);
		end component;

		COMPONENT control_all_processing_module IS
		generic(
				SHIFT_HORIZONTAL: INTEGER := 7; -- quantidade de deslocamentos na horizontal
				SHIFT_VERTICAL: INTEGER := 24 -- quantidade de deslocamentos na vertical
		);
		port(
			clk: in std_logic;
			rst: in std_logic;
			
			start_control: in std_logic;
			start_comparator: out std_logic;
		
			start_sad_manager_mp0: out std_logic;
			start_reference_manager_fill_mp0 : out std_logic;
			start_reference_manager_shifts_mp0 : out std_logic;
			
			start_sad_manager_mp1: out std_logic;
			start_reference_manager_fill_mp1 : out std_logic;
			start_reference_manager_shifts_mp1 : out std_logic;
			
			start_sad_manager_mp2: out std_logic;
			start_reference_manager_fill_mp2 : out std_logic;
			start_reference_manager_shifts_mp2 : out std_logic;
			
			sel_mux_data_in_ref_mp0: out std_logic_vector(1 DOWNTO 0);
			sel_mux_data_in_ref_mp1: out std_logic_vector(1 DOWNTO 0);
			sel_mux_data_in_ref_mp2: out std_logic_vector(1 DOWNTO 0)
		);
		END component;
	
		signal start_sad_manager_mp0: std_logic := '0';
		signal start_reference_manager_fill_mp0 : std_logic := '0';
		signal start_reference_manager_shifts_mp0 : std_logic := '0';
			
		signal start_sad_manager_mp1: std_logic := '0';
		signal start_reference_manager_fill_mp1 : std_logic := '0';
		signal start_reference_manager_shifts_mp1 : std_logic := '0';
			
		signal start_sad_manager_mp2: std_logic := '0';
		signal start_reference_manager_fill_mp2 : std_logic := '0';
		signal start_reference_manager_shifts_mp2 : std_logic := '0';
			 
		signal sel_mux_data_in_ref_mp0: std_logic_vector(1 DOWNTO 0) := "00";
		signal sel_mux_data_in_ref_mp1: std_logic_vector(1 DOWNTO 0) := "00";
		signal sel_mux_data_in_ref_mp2: std_logic_vector(1 DOWNTO 0) := "00"; 
		
begin
	
	MAP_ALL_PROCESSING_MODULE: all_processing_module
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
		
		blk => entrada_blk,

		start_sad_manager_mp0 => start_sad_manager_mp0,
		start_reference_manager_fill_mp0 => start_reference_manager_fill_mp0,
		start_reference_manager_shifts_mp0 => start_reference_manager_shifts_mp0,
		
		start_sad_manager_mp1 =>  start_sad_manager_mp1,
		start_reference_manager_fill_mp1 => start_reference_manager_fill_mp1,
		start_reference_manager_shifts_mp1 => start_reference_manager_shifts_mp1,
		
		start_sad_manager_mp2 => start_sad_manager_mp2,
		start_reference_manager_fill_mp2 => start_reference_manager_fill_mp2,
		start_reference_manager_shifts_mp2 => start_reference_manager_shifts_mp2,
		
		sel_mux_data_in_ref_mp0 => sel_mux_data_in_ref_mp0,
		sel_mux_data_in_ref_mp1 => sel_mux_data_in_ref_mp1,
		sel_mux_data_in_ref_mp2 => sel_mux_data_in_ref_mp2,
		
		vector_x_mp0 => vector_x_mp0,
		vector_y_mp0 => vector_y_mp0,
		vector_x_mp1 => vector_x_mp1,
		vector_y_mp1 => vector_y_mp1,
		vector_x_mp2 => vector_x_mp2, 
		vector_y_mp2 => vector_y_mp2,
		
		result_mp0 => result_mp0,
		result_mp1 => result_mp1,
		result_mp2 => result_mp2,
		
		end_search => end_search,
		
		out_mux_mem_portB => out_mux_mem_portB,
		out_muxes_memories_portA => out_muxes_memories_portA,
		portB_buffer_mp0 => portB_buffer_mp0,
		portB_buffer_mp1 => portB_buffer_mp1,
		portB_buffer_mp2 => portB_buffer_mp2
	);

	MAP_control_all_processing_module: control_all_processing_module
	generic map(
			SHIFT_HORIZONTAL => SHIFT_HORIZONTAL, -- quantidade de deslocamentos na horizontal
			SHIFT_VERTICAL => SHIFT_VERTICAL -- quantidade de deslocamentos na vertical
	)
	port map(
		clk => clk,
		rst => rst,
		
		start_control => start_control,
		start_comparator =>  start_comparator,
		start_sad_manager_mp0 => start_sad_manager_mp0,
		start_reference_manager_fill_mp0 => start_reference_manager_fill_mp0,
		start_reference_manager_shifts_mp0 => start_reference_manager_shifts_mp0,
		
		start_sad_manager_mp1 => start_sad_manager_mp1,
		start_reference_manager_fill_mp1 => start_reference_manager_fill_mp1,
		start_reference_manager_shifts_mp1 => start_reference_manager_shifts_mp1,
		
		start_sad_manager_mp2 => start_sad_manager_mp2,
		start_reference_manager_fill_mp2 => start_reference_manager_fill_mp2,
		start_reference_manager_shifts_mp2 => start_reference_manager_shifts_mp2,
		
		sel_mux_data_in_ref_mp0 => sel_mux_data_in_ref_mp0,
		sel_mux_data_in_ref_mp1 => sel_mux_data_in_ref_mp1,
		sel_mux_data_in_ref_mp2 => sel_mux_data_in_ref_mp2
	);

	start_reference_manager_fill_mp0_out <= start_reference_manager_fill_mp0;
	
end comportamento;
