------------------------------------------------------------------------------
-- PROJETO: Estimação de Movimento
-- ENTIDADE : total_architecture
------------------------------------------------------------------------------
-- DESCRIÇÃO: Integração da arquitetura completa. Módulo principal da
-- arquitetura.
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.all;
use work.motion_estimation_8x8_package.all;

entity total_architecture is
port(
	clk: in std_logic;
	rst: in std_logic;
	
	word_external_memory: in std_logic_vector(MEM_PORT_B_WIDTH-1 DOWNTO 0);
	
	words_blk: in std_logic_vector(MEM_PORT_B_WIDTH-1 DOWNTO 0);
	--words_blk_we: 	in WE_REG_ROWS;
	start_architecture: in std_logic;
	--sig_blk: in REG_ROWS;
	vectors_ready: out std_logic;
	motion_vector_x: out std_logic_vector(4 DOWNTO 0);
	motion_vector_y: out std_logic_vector(4 DOWNTO 0);
	out_start_write_buffer: out std_logic;
	out_start_init_line: out std_logic;
	end_search: out std_logic;
	best_sad: out std_logic_vector(DATA_WIDTH-1 + LEVELS-1 DOWNTO 0);
	start_reference_manager_fill_mp0_out: out std_logic
	
);
end entity;

architecture behaviour of total_architecture is

	signal mems_port_b_datas: MEM_PORT_B_DATAS;
	
	signal mems_port_a_qs: MEM_PORT_A_DATAS;
	signal mems_port_b_qs: MEM_PORT_B_DATAS;

	signal sig_out_mux_mem_portB: REG_COLS;
	signal out_muxes_memories: REG_COLS;
	signal sel_muxes_memories: VECTOR_MUX;
	
	signal i, m, o : INTEGER RANGE 0 TO NUM_COLS-1;
	signal j : INTEGER RANGE 0 TO NUM_ROWS-1;
	signal k : INTEGER RANGE 0 TO NUM_MEMORIES-1;
	
	SIGNAL start_pm_comparator, start_init_line, start_read_buffer, start_write_buffer, sig_end_search, init_read_buffer: std_logic;
	SIGNAL sig_we_reg_mp0, sig_we_reg_mp1, sig_we_reg_mp2: std_logic;
	SIGNAL out_mux_mem_portB: std_logic_vector(MEM_PORT_B_WIDTH-1 DOWNTO 0);
	SIGNAL sig_value_portB_buffer_mp0, sig_value_portB_buffer_mp1, sig_value_portB_buffer_mp2 : REG_COLS;
	SIGNAL sig_sel_mux_memportB: std_logic_vector(WIDTH_SELMUX_MEMORIES-1 DOWNTO 0);
	
	SIGNAL sig_best_vector_x, sig_best_vector_y: std_logic_vector(LENGTH_MOTION_VECTOR-1 DOWNTO 0);
	SIGNAL sig_bestSad: std_logic_vector(DATA_WIDTH-1 + LEVELS-1 DOWNTO 0);
	SIGNAL sig_start_reference_manager_fill_mp0_out: std_logic;
	SIGNAL sig_words_blk: REG_COLS;
	SIGNAL in_words_blk: std_logic_vector(MEM_PORT_B_WIDTH-1 DOWNTO 0);
	
	SIGNAL sig_blk: REG_ROWS;
	signal words_blk_we: WE_REG_ROWS; 
	
	component global_control is
	port(
		clk: in std_logic;
		rst: in std_logic;
		
		start_architecture: in std_logic;
		init_read_buffer: in std_logic;
		end_search: in std_logic;
		vectors_ready: out std_logic;
		start_init_line: out std_logic;
		start_read_buffer: out std_logic;
		start_write_buffer: out std_logic	
	);
	end component;
	
	component memories_and_memories_manager is
	port
	(
		clk					 : IN STD_LOGIC;
		rst					 : IN STD_LOGIC;
		start_init_line		 : IN STD_LOGIC;
		init_read_buffer	 : OUT STD_LOGIC;
		start_read_buffer	 : IN STD_LOGIC;
		start_write_buffer	 : IN STD_LOGIC;
		word_external_memory : IN STD_LOGIC_VECTOR(MEM_PORT_B_WIDTH-1 DOWNTO 0 );
		qs_a	: OUT MEM_PORT_A_DATAS; -- vetor com os dados de saida de cada uma das memorias
		qs_b	: OUT MEM_PORT_B_DATAS; -- vetor com os dados de saida de cada uma das memorias
	
		sel_mux_mp: out VECTOR_MUX;
		sel_mux_memportB: out std_logic_vector(WIDTH_SELMUX_MEMORIES-1 DOWNTO 0);

		start_pm_comparator: out std_logic;
		
		we_reg_mp0: out std_logic; -- buffer
		we_reg_mp1: out std_logic; -- buffer
		we_reg_mp2: out std_logic -- buffer

	);
	end component;
	
	component block_registers is
		port
		(
			clk: in std_logic;
			-- Input ports
			words	: in REG_COLS;
			we_blk: in WE_REG_ROWS;
			
			blk: out REG_ROWS
		);
	end component;

	component block_registers_manager is
	port
	(
		rst: in std_logic;
		clk: in std_logic;
		-- Input ports
		we_start_blk: in std_logic;
		we_blk: out WE_REG_ROWS
	);
	end component;

	component pm_comparator is
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
	end component;

	component mux_Nx1 is
	generic(
		VECT_SIZE : integer := 8;
		INPUT_LENGTH : integer := 32;
		SEL_LENGTH : integer := 5
	);
	port ( 
		muxin : in MEM_PORT_A_DATAS;
		muxout : out std_logic_vector(VECT_SIZE - 1 downto 0);
		sel : in std_logic_vector(SEL_LENGTH - 1 downto 0)
	);
	end component;
	
	component buffer_memportB is
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
	end component;

	component mux_32x1 is
	GENERIC(
		VECT_SIZE : integer := 64
	);
	PORT ( 
		muxin_0 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_1 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_2 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_3 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_4 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_5 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_6 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_7 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_8 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_9 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_10 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_11 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_12 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_13 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_14 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_15 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_16 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_17 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_18 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_19 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_20 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_21 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_22 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_23 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_24 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_25 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_26 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_27 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_28 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_29 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_30 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_31 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxout : out std_logic_vector(VECT_SIZE - 1 downto 0);
		sel : in std_logic_vector(4 downto 0)
	);
	end component;

	signal zero: std_logic := '0';

begin

	start_reference_manager_fill_mp0_out <= sig_start_reference_manager_fill_mp0_out;
	end_search <= sig_end_search;
	out_start_write_buffer <= start_write_buffer;
	out_start_init_line <= start_init_line;
	in_words_blk <= words_blk;
	
	map_global_control: global_control
	port map(
		clk					=> clk,
		rst					=> rst,
		
		start_architecture	=> start_architecture,
		end_search			=> sig_end_search,
		vectors_ready		=> vectors_ready, 
		init_read_buffer	=> init_read_buffer,
		start_init_line		=> start_init_line,
		start_read_buffer	=> start_read_buffer,
		start_write_buffer	=> start_write_buffer	
	);
	
	map_memories_and_memories_manager: memories_and_memories_manager
	port map
	(
		clk					 	=> clk,
		rst					 	=> rst,
		start_init_line		 	=> start_init_line,
		init_read_buffer		=> init_read_buffer,
		start_read_buffer	 	=> start_read_buffer,
		start_write_buffer	 	=> start_write_buffer,
		word_external_memory 	=> word_external_memory,
		
		qs_a					=> mems_port_a_qs, -- vetor com os dados de saida de cada uma das memorias
		qs_b					=> mems_port_b_qs, -- vetor com os dados de saida de cada uma das memorias
	
		start_pm_comparator => start_pm_comparator,
		
		sel_mux_mp => sel_muxes_memories,
		sel_mux_memportB => sig_sel_mux_memportB,

		we_reg_mp0 => sig_we_reg_mp0,
		we_reg_mp1 => sig_we_reg_mp1,
		we_reg_mp2 => sig_we_reg_mp2
	);
	
	map_pm_comparator: pm_comparator
	generic map(
		LENGTH_VECTOR 		=> 5, -- qtd de bits para representar cada componente do vetor de movimento
		INICIAL_X_VALUE_MP0 => -12,
		INICIAL_Y_VALUE_MP0 => -12,
		INICIAL_X_VALUE_MP1 => -4,
		INICIAL_Y_VALUE_MP1 => -12,
		INICIAL_X_VALUE_MP2 => 4,
		INICIAL_Y_VALUE_MP2 => -12,
		SHIFT_HORIZONTAL	=> 7, -- quantidade de deslocamentos na horizontal
		SHIFT_VERTICAL 		=> 24 -- quantidade de deslocamentos na vertical
	)
	port map(
		clk => clk,
		rst => rst,
		
		blk => sig_blk,
		start_pm => start_pm_comparator,
	
		motion_vector_x => motion_vector_x,
		motion_vector_y => motion_vector_y,
		
		best_sad => best_sad,
		
		end_search => sig_end_search,
		out_mux_mem_portB => sig_out_mux_mem_portB,
		out_muxes_memories_portA => out_muxes_memories,
		portB_buffer_mp0 => sig_value_portB_buffer_mp0,
		portB_buffer_mp1 => sig_value_portB_buffer_mp1,
		portB_buffer_mp2 => sig_value_portB_buffer_mp2,
		start_reference_manager_fill_mp0_out => sig_start_reference_manager_fill_mp0_out
	);

	map_blk_registers: block_registers
	port map
	(
		clk		=> clk,
		-- Input ports
		words	=> sig_words_blk,
		we_blk	=> words_blk_we,
			
		blk		=> sig_blk
	);
	
	map_block_registers_manager: block_registers_manager
	port map
	(
		rst => rst,
		clk => clk,
		-- Input ports
		we_start_blk => sig_start_reference_manager_fill_mp0_out,
		we_blk => words_blk_we
	);
	
	port_buffer_memportB: buffer_memportB
	generic map(
		N => MEM_PORT_B_WIDTH
	)
	port map(
		clk => clk,
		rst => rst,
		
		we_reg_mp0 => sig_we_reg_mp0,
		we_reg_mp1 => sig_we_reg_mp1,
		we_reg_mp2 => sig_we_reg_mp2,
		
		mem_port_b_value => sig_out_mux_mem_portB,
		
		value_portB_mp0 => sig_value_portB_buffer_mp0,
		value_portB_mp1 => sig_value_portB_buffer_mp1,
		value_portB_mp2 => sig_value_portB_buffer_mp2
	
	);
	
	
	map_mux_memPortB: mux_32x1
	GENERIC MAP(
		VECT_SIZE => 64
	)
	PORT MAP( 
		muxin_0  => mems_port_b_qs(0), 
		muxin_1  => mems_port_b_qs(1), 
		muxin_2  => mems_port_b_qs(2), 
		muxin_3  => mems_port_b_qs(3), 
		muxin_4  => mems_port_b_qs(4), 
		muxin_5  => mems_port_b_qs(5), 
		muxin_6  => mems_port_b_qs(6), 
		muxin_7  => mems_port_b_qs(7), 
		muxin_8  => mems_port_b_qs(8), 
		muxin_9  => mems_port_b_qs(9), 
		muxin_10 => mems_port_b_qs(10), 
		muxin_11 => mems_port_b_qs(11), 
		muxin_12 => mems_port_b_qs(12), 
		muxin_13 => mems_port_b_qs(13), 
		muxin_14 => mems_port_b_qs(14), 
		muxin_15 => mems_port_b_qs(15), 
		muxin_16 => mems_port_b_qs(16), 
		muxin_17 => mems_port_b_qs(17), 
		muxin_18 => mems_port_b_qs(18), 
		muxin_19 => mems_port_b_qs(19), 
		muxin_20 => mems_port_b_qs(20), 
		muxin_21 => mems_port_b_qs(21), 
		muxin_22 => mems_port_b_qs(22), 
		muxin_23 => mems_port_b_qs(23), 
		muxin_24 => mems_port_b_qs(24), 
		muxin_25 => mems_port_b_qs(25), 
		muxin_26 => mems_port_b_qs(26), 
		muxin_27 => mems_port_b_qs(27), 
		muxin_28 => mems_port_b_qs(28), 
		muxin_29 => mems_port_b_qs(29), 
		muxin_30 => mems_port_b_qs(30), 
		muxin_31 => mems_port_b_qs(31), 
		muxout 	 => out_mux_mem_portB,
		sel 	 => sig_sel_mux_memportB
	);
	
	
	for_muxMemories_MP0:
	FOR i IN 0 TO NUM_COLS-1 GENERATE
		
		muxMemories_MP0: mux_Nx1
		generic map(
			VECT_SIZE => DATA_WIDTH,
			INPUT_LENGTH => NUM_MEMORIES,
			SEL_LENGTH => WIDTH_SELMUX_MEMORIES
		)
		port map( 
			muxin  => mems_port_a_qs,
			muxout => out_muxes_memories(i),
			sel => sel_muxes_memories(i)
		);
			
	END GENERATE;
	
	-- Transformando a palavra de 64 bits em um vetor de 8 posicoes
	for_pos_port_b:
	for m in 0 to NUM_COLS-1 generate
		sig_out_mux_mem_portB(m) <= out_mux_mem_portB( ( (m+1)*NUM_COLS-1 )  DOWNTO m*NUM_COLS );
	end generate;

	for_word_blk:
	for o in 0 to NUM_COLS-1 generate
		sig_words_blk(o) <= in_words_blk( ( (o+1)*NUM_COLS-1 )  DOWNTO o*NUM_COLS );
	end generate;

	
end behaviour;
