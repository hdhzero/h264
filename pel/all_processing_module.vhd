------------------------------------------------------------------------------
-- PROJETO: Estimação de Movimento
-- ENTIDADE : all_processing_module
------------------------------------------------------------------------------
-- DESCRIÇÃO: Integração dos 3 odulos de processamento da arquitetura.
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.all;
use work.motion_estimation_8x8_package.all;

entity all_processing_module is
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

		-- Sinais de controle
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
		
		--Saidas do modulo
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
		--Entrada de dados
		out_mux_mem_portB: in REG_COLS;
		out_muxes_memories_portA: in REG_COLS;
		portB_buffer_mp0: in REG_COLS;
		portB_buffer_mp1: in REG_COLS;
		portB_buffer_mp2: in REG_COLS
	);
	end entity;

architecture behaviour of all_processing_module is
	
	component processing_module is
	generic(
		LENGTH_VECTOR: INTEGER := 5; -- qtd de bits para representar cada componente do vetor de movimento
		INICIAL_X_VALUE: INTEGER := -12;
		INICIAL_Y_VALUE: INTEGER := -4;
		SHIFT_HORIZONTAL: INTEGER := 7; -- quantidade de deslocamentos na horizontal
		SHIFT_VERTICAL: INTEGER := 24 -- quantidade de deslocamentos na vertical
	);
	port
	(
		rst: in std_logic;
		clk: in std_logic;
		blk: in REG_ROWS; -- uma matriz MxN (os pixels do bloco)
		ref: in REG_COLS; -- um vetor N (pixels a serem gravadas no banco de registradores de referencia)
		
		start_sad_manager: in std_logic;
		start_reference_manager_fill : in std_logic;
		start_reference_manager_shifts : in std_logic;
		
		vector_x: out std_logic_vector(LENGTH_MOTION_VECTOR-1 DOWNTO 0);
		vector_y: out std_logic_vector(LENGTH_MOTION_VECTOR-1 DOWNTO 0);
		
		col_left: out REG_COLS;
		col_right: out REG_COLS;
		
		end_search: out std_logic;
		result: out std_logic_vector(DATA_WIDTH-1 + LEVELS-1 DOWNTO 0) -- resultado do SAD entre o BRB (banco de registradores de bloco)e o BRR (banco de registradores de referencia)
	);
	end component;
	
	component mux4x1_regCols is
	port
	(
		-- Input ports
		--clk		: in std_logic;
		sel		: in std_logic_vector(1 DOWNTO 0);
		data_a	: in REG_COLS;
		data_b	: in REG_COLS;
		data_c	: in REG_COLS;
		data_d	: in REG_COLS;
		-- Output ports
		data_out : out REG_COLS
	);
	end component;
	
	signal data_mp0_left, data_mp0_right, data_mp1_left, data_mp1_right, data_mp2_left, data_mp2_right, datas_in_ref_mp0, datas_in_ref_mp1, datas_in_ref_mp2: REG_COLS;
	signal end_search_mp0, end_search_mp1, end_search_mp2, sig_end_search: std_logic;
begin

	end_search <= sig_end_search;
	sig_end_search <= ( (end_search_mp0 and end_search_mp1) and end_search_mp2 );

	map_mp0: processing_module
	generic map(
		LENGTH_VECTOR 		=>  LENGTH_VECTOR, -- qtd de bits para representar cada componente do vetor de movimento
		INICIAL_X_VALUE 	=> INICIAL_X_VALUE_MP0,
		INICIAL_Y_VALUE		=> INICIAL_Y_VALUE_MP0,
		SHIFT_HORIZONTAL	=> SHIFT_HORIZONTAL, -- quantidade de deslocamentos na horizontal
		SHIFT_VERTICAL 		=> SHIFT_VERTICAL -- quantidade de deslocamentos na vertical
	)
	port map
	(
		rst				=> rst,
		clk				=> clk,
		blk				=> blk, 
		

		ref				=> datas_in_ref_mp0,
			
		start_sad_manager => start_sad_manager_mp0,
		start_reference_manager_fill => start_reference_manager_fill_mp0,
		start_reference_manager_shifts => start_reference_manager_shifts_mp0,
			
		col_left => data_mp0_left,
		col_right => data_mp0_right,
	
		vector_x 		=> vector_x_mp0,
		vector_y		=> vector_y_mp0,
		
		end_search		=> end_search_mp0,
		result			=> result_mp0
	);
	
	map_mp1: processing_module
	generic map(
		LENGTH_VECTOR 		=>  LENGTH_VECTOR, -- qtd de bits para representar cada componente do vetor de movimento
		INICIAL_X_VALUE 	=> INICIAL_X_VALUE_MP1,
		INICIAL_Y_VALUE		=> INICIAL_Y_VALUE_MP1,
		SHIFT_HORIZONTAL	=> SHIFT_HORIZONTAL, -- quantidade de deslocamentos na horizontal
		SHIFT_VERTICAL 		=> SHIFT_VERTICAL -- quantidade de deslocamentos na vertical
	)
	port map
	(
		rst				=> rst,
		clk				=> clk,
		blk				=> blk, 
		
		ref				=> datas_in_ref_mp1,--out_muxes_memories_mp0, -- vem das memorias -- mux 32x1 em cada entrada REG_COLS(i) para selecionar os valores das memorias
	
		start_sad_manager => start_sad_manager_mp1,
		start_reference_manager_fill => start_reference_manager_fill_mp1,
		start_reference_manager_shifts => start_reference_manager_shifts_mp1,
					
		col_left => data_mp1_left,
		col_right => data_mp1_right,
	
		vector_x 		=> vector_x_mp1,
		vector_y			=> vector_y_mp1,
		end_search		=> end_search_mp1,
		result			=> result_mp1	
	);

	map_mp2: processing_module
	generic map(
		LENGTH_VECTOR 		=>  LENGTH_VECTOR, -- qtd de bits para representar cada componente do vetor de movimento
		INICIAL_X_VALUE 	=> INICIAL_X_VALUE_MP2,
		INICIAL_Y_VALUE		=> INICIAL_Y_VALUE_MP2,
		SHIFT_HORIZONTAL	=> SHIFT_HORIZONTAL, -- quantidade de deslocamentos na horizontal
		SHIFT_VERTICAL 		=> SHIFT_VERTICAL -- quantidade de deslocamentos na vertical
	)
	port map
	(
		rst				=> rst,
		clk				=> clk,
		blk				=> blk, 
		
		ref				=> datas_in_ref_mp2,
		
		start_sad_manager => start_sad_manager_mp2,
		start_reference_manager_fill => start_reference_manager_fill_mp2,
		start_reference_manager_shifts => start_reference_manager_shifts_mp2,
			
			
		col_left => data_mp2_left,
		col_right => data_mp2_right,
	
		vector_x 		=> vector_x_mp2,
		vector_y		=> vector_y_mp2,
		end_search		=> end_search_mp2,
		result			=> result_mp2	
	);
	
	
	map_mux_mp0: mux4x1_regCols
	port map
	(
		--clk 		=> clk,
		-- Input ports
		sel		=> sel_mux_data_in_ref_mp0,
		data_a	=> out_mux_mem_portB, --porta de 64 bits
		data_b	=> out_muxes_memories_portA, 
		data_c	=> data_mp1_left,
		data_d	=> portB_buffer_mp0,
		-- Output ports
		data_out => datas_in_ref_mp0
	);
	
	map_mux_mp1: mux4x1_regCols
	port map
	(
		-- Input ports
		--clk		=> clk,
		sel		=> sel_mux_data_in_ref_mp1,
		data_a	=> out_mux_mem_portB,
		data_b	=> data_mp0_right,
		data_c	=> data_mp2_left,
		data_d	=> portB_buffer_mp1,
		-- Output ports
		data_out => datas_in_ref_mp1
	);
	
	map_mux_mp2: mux4x1_regCols
	port map
	(
		-- Input ports
		--clk		=> clk,
		sel		=> sel_mux_data_in_ref_mp2,
		data_a	=> out_mux_mem_portB,
		data_b	=> data_mp1_right,
		data_c	=>  out_muxes_memories_portA,
		data_d	=> portB_buffer_mp2,
		-- Output ports
		data_out => datas_in_ref_mp2
	);

end behaviour;
