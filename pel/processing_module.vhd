------------------------------------------------------------------------------
-- PROJETO: Estimação de Movimento
-- ENTIDADE : processing_module
------------------------------------------------------------------------------
-- DESCRIÇÃO: Este componente é o Modulo de Processamento. Ele integra os 
-- bancos de registradores e os modulos de SAD.
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.all;
use work.motion_estimation_8x8_package.all;

entity processing_module is
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
end entity;

architecture behaviour of processing_module is

	SIGNAL sig_ref: REG_ROWS;
	SIGNAL sig_sad_entries_ref, sig_sad_entries_blk: SAD_ENTRIES;
	SIGNAL i: INTEGER RANGE 0 TO NUM_ROWS-1;
	SIGNAL j: INTEGER RANGE 0 TO NUM_COLS-1;	
	signal we_sad_levels: std_logic_vector(LEVELS-1 DOWNTO 0);  
	signal we_ref: WE_REG_ROWS;
	signal sel_mux_ref: std_logic_vector(1 DOWNTO 0);

	component sad_N is
	generic (
		N : 		integer := 8;
		LEVELS: 	integer := 7;
		ENTRIES:	integer	:= ENTRIES
	);
	port
	(
		clk: in std_logic;
		blk: in SAD_ENTRIES;
		ref: in SAD_ENTRIES;
		we_levels: in std_logic_vector(LEVELS-1 DOWNTO 0);
		
		result: out std_logic_vector(DATA_WIDTH-1 + LEVELS-1 DOWNTO 0)
	);
	end component;

	component reference_registers is
	generic ( N: integer := 8 );
	port
	(
		clk: in std_logic;
		sel_muxes: in std_logic_vector(1 DOWNTO 0);
		we_refs: in WE_REG_ROWS;
		words: in REG_COLS;
		ref: out REG_ROWS

	);
	end component;
	
	component reference_registers_manager is
	generic(
			LENGTH_VECTOR: INTEGER := 5; -- qtd de bits para representar cada componente do vetor de movimento
			INICIAL_X_VALUE: INTEGER := -12;
			INICIAL_Y_VALUE: INTEGER := -4;
			SHIFT_HORIZONTAL: INTEGER := 7; -- quantidade de deslocamentos na horizontal
			SHIFT_VERTICAL: INTEGER := 24 -- quantidade de deslocamentos na vertical
	);
	port(
		rst: in std_logic;
		clk: in std_logic;
		start_fill: in std_logic;
		start_shifts: in std_logic;
		sel_muxes: out std_logic_vector(1 DOWNTO 0);
		vector_x: out std_logic_vector(LENGTH_MOTION_VECTOR-1 DOWNTO 0);
		vector_y: out std_logic_vector(LENGTH_MOTION_VECTOR-1 DOWNTO 0);
		end_search: out std_logic;
		we_refs: out WE_REG_ROWS
	);
	end component;
	
	component sad_manager is
	port(
		rst: in std_logic;
		clk: in std_logic;
		start: in std_logic;
		we_levels: out std_logic_vector(LEVELS-1 DOWNTO 0)
		
	);
	end component;
	
begin

	map_reference_registers: reference_registers
	generic map ( N => 8 )
	port map
	(
		clk 		=>	clk,
		
		sel_muxes 	=> sel_mux_ref,
		we_refs		=> we_ref,
		words		=> ref,
		
		ref			=> sig_ref

	);
	
	map_sad_N: sad_N
	generic map(
		N		=> 8,
		LEVELS 	=> 7,
		ENTRIES	=> ENTRIES
	)
	port map
	(
		clk => clk,
		blk => sig_sad_entries_blk,
		ref => sig_sad_entries_ref,
		we_levels => we_sad_levels,
		
		result => result
	);
	
	map_rrm: reference_registers_manager
	generic map(
			LENGTH_VECTOR => LENGTH_VECTOR, -- qtd de bits para representar cada componente do vetor de movimento
			INICIAL_X_VALUE => INICIAL_X_VALUE,
			INICIAL_Y_VALUE => INICIAL_Y_VALUE,
			SHIFT_HORIZONTAL => SHIFT_HORIZONTAL, -- quantidade de deslocamentos na horizontal
			SHIFT_VERTICAL => SHIFT_VERTICAL -- quantidade de deslocamentos na vertical
	)
	port map(
		rst => rst,
		clk => clk,
		start_fill => start_reference_manager_fill,
		start_shifts => start_reference_manager_shifts,
		sel_muxes => sel_mux_ref,
		vector_x => vector_x,
		vector_y => vector_y,
		end_search =>  end_search,
		we_refs => we_ref
	);
	
	map_sm: sad_manager
	port map(
		rst	=> rst,
		clk	=> clk,
		start => start_sad_manager,
		we_levels => we_sad_levels
	);

	for_num_rows_blk: 
	for i in 0 to NUM_ROWS-1 generate
		for_num_cols_blk:
		for j in 0 to NUM_COLS-1 generate
			sig_sad_entries_blk(i*NUM_COLS + j) <= blk(i)(j);
		end generate;
	end generate;

	for_num_rows_ref: 
	for i in 0 to NUM_ROWS-1 generate
		for_num_cols_ref:
		for j in 0 to NUM_COLS-1 generate
			sig_sad_entries_ref(i*NUM_COLS + j) <= sig_ref(i)(j);
		end generate;
	end generate;
	
	for_col_left: 
	for i in 0 to NUM_ROWS-1 generate
		col_left(i) <= sig_ref(i)(0);
	end generate;
	
	for_col_right: 
	for i in 0 to NUM_ROWS-1 generate
		col_right(i) <= sig_ref(i)(NUM_COLS-1);
	end generate;
end behaviour;
