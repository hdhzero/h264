------------------------------------------------------------------------------
-- PROJETO: Estimação de Movimento
-- ENTIDADE : memories_and_memories_manager
------------------------------------------------------------------------------
-- DESCRIÇÃO: Integração e controle da memória local e memória secundária
------------------------------------------------------------------------------

library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.all;
use work.motion_estimation_8x8_package.all;

entity memories_and_memories_manager is
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
end memories_and_memories_manager;

architecture behaviour of memories_and_memories_manager is
	
	TYPE STATE_TYPE is (s0_start, s1_memory_manager, s2_read_buffer, s2_delay);
	SIGNAL state, next_state : STATE_TYPE;
	
	signal wrens_b, wrens_b_init, wrens_b_buffer: std_logic_vector(NUM_MEMORIES-1 DOWNTO 0);
	signal mem_port_b_addr_shifts, mem_port_b_addr_init, mem_port_b_addr_buffer, mem_port_b_addr_choice, mem_port_b_addr_choice_lasts: std_logic_vector(MEM_PORT_B_WIDTHAD-1 DOWNTO 0);
	signal sel_data_b_memory, finished_init_memory, init_pm_comparator, finished_read_buffer, delay_01_reg_start_pm_comparator_in, delay_01_reg_start_pm_comparator_out, delay_02_reg_start_pm_comparator_in, delay_02_reg_start_pm_comparator_out, delay_03_reg_start_pm_comparator_in, delay_03_reg_start_pm_comparator_out, delay_04_reg_start_pm_comparator_in, delay_04_reg_start_pm_comparator_out: std_logic := '0';
	signal delay_01_sel_mux_in, delay_01_sel_mux_out, delay_02_sel_mux_in, delay_02_sel_mux_out: std_logic_vector(WIDTH_SELMUX_MEMORIES-1 DOWNTO 0);
	signal sel_wrens_b, sel_mux_addr_b_lasts, sel_count_rb, we_count_rb : std_logic := '0';
	signal sel_mux_addr_b: std_logic_vector(1 DOWNTO 0);
	signal delay_01_sel_mux_mp_in, delay_01_sel_mux_mp_out,  delay_02_sel_mux_mp_in, delay_02_sel_mux_mp_out: VECTOR_MUX;
	
	signal sig_addr_a_0, delay_01_mem_port_a_addr_in, delay_01_mem_port_a_addr_out: std_logic_vector(MEM_PORT_A_WIDTHAD-1 DOWNTO 0);
	signal mem_port_a_addr: std_logic_vector(MEM_PORT_A_WIDTHAD-1 DOWNTO 0);
	signal addrs_a : MEM_PORT_A_ADDRS;
	signal addrs_b : MEM_PORT_B_ADDRS;
	signal delay_01_we_mp0_in, delay_01_we_mp0_out, delay_01_we_mp1_in, delay_01_we_mp1_out, delay_01_we_mp2_in, delay_01_we_mp2_out: std_logic;
	signal delay_02_we_mp0_in, delay_02_we_mp0_out, delay_02_we_mp1_in, delay_02_we_mp1_out, delay_02_we_mp2_in, delay_02_we_mp2_out: std_logic;
	signal datas_b: MEM_PORT_B_DATAS;
	signal data_b_memory, word_from_buffer: STD_LOGIC_VECTOR(MEM_PORT_B_WIDTH-1 DOWNTO 0 );
	signal sig_1:  STD_LOGIC_VECTOR(NUM_MEMORIES-1 DOWNTO 0);
	signal k: integer;
	signal map_addr_local_memory, map_addr_local_memory_anterior, choice_map_addr_local_memory: SR_LENGTH;
	signal sel_addr_a_0: std_logic_vector(1 DOWNTO 0);
	signal flag, sel_mux_addr_a_map: std_logic:= '0';
	SIGNAL sig_count_rb, count_rb_in, count_rb_out: INTEGER RANGE 0 TO 63 := 0;
	
	component map_addr_a_circular is
	generic
	(
		INIT_0: integer := 8;
		INIT_1: integer := 16;
		INIT_2: integer := 24;
 		INIT_3: integer := 0
	);
	port 
	(
		addr    		: in std_logic_vector(MEM_PORT_A_WIDTHAD-1 DOWNTO 0);
		sel				: in std_logic_vector(1 DOWNTO 0);
		map_actual_addr	: out std_logic_vector(MEM_PORT_A_WIDTHAD-1 DOWNTO 0)
	);

	end component;
	
	component n_memories is
	port
	(
		clk		: IN STD_LOGIC ;
		datas_b : IN MEM_PORT_B_DATAS;
		addrs_a	: IN MEM_PORT_A_ADDRS; -- vetor com o endereco a ser lido de cada uma das memorias (0 a N-1)
		addrs_b : IN MEM_PORT_B_ADDRS;
		wrens_b	: IN STD_LOGIC_VECTOR(NUM_MEMORIES-1 DOWNTO 0); --vetor com os bits de escrita em cada uma das memorias (0 a N-1)
		rden_a	: IN STD_LOGIC_VECTOR(NUM_MEMORIES-1 DOWNTO 0);
		rden_b	: IN STD_LOGIC_VECTOR(NUM_MEMORIES-1 DOWNTO 0);
		qs_a	: OUT MEM_PORT_A_DATAS; -- vetor com os dados de saida de cada uma das memorias
		qs_b	: OUT MEM_PORT_B_DATAS -- vetor com os dados de saida de cada uma das memorias
	);
	end component;
	
	component memory_manager is
	generic (
		START_MEM_ADRR_INC: integer := 24;
		END_MEM_ADDR_INC: integer := 31;
		START_MEM_ADRR_DEC: integer := 7;
		END_MEM_ADDR_DEC: integer := 0
	);
	port(
		rst: in std_logic;
		
		clk: in std_logic;
		start: in std_logic;
		sel_mux_mp: out VECTOR_MUX;
		sel_mux_memportB: out std_logic_vector(WIDTH_SELMUX_MEMORIES-1 DOWNTO 0);

		we_reg_mp0: out std_logic; -- buffer
		we_reg_mp1: out std_logic; -- buffer
		we_reg_mp2: out std_logic; -- buffer
		init_read_buffer: out std_logic;

		mem_port_a_addr: out std_logic_vector(MEM_PORT_A_WIDTHAD-1 DOWNTO 0);
		mem_port_b_addr: out std_logic_vector(MEM_PORT_B_WIDTHAD-1 DOWNTO 0)
	);
	end component;
	
	component init_memory_manager is
	generic (
		START_MEM_ADRR_INC: integer := 24;
		END_MEM_ADDR_INC: integer := 31;
		START_MEM_ADRR_DEC: integer := 7;
		END_MEM_ADDR_DEC: integer := 0
	);
	port(
		rst: in std_logic;
		clk: in std_logic;
		start: in std_logic;
		finished: out std_logic;
		mem_port_b_we: out std_logic_vector(NUM_MEMORIES-1 DOWNTO 0);
		mem_port_b_addr: out std_logic_vector(MEM_PORT_B_WIDTHAD-1 DOWNTO 0)
	);
	end component;

	component memory_level_2_manager is
	generic 
	(
		DATA_WIDTH : natural := 64;
		ADDR_WIDTH : natural := 5
	);
	port 
	(
		clk						: in std_logic;
		rst						: in std_logic;
		start_write				: in std_logic;
		start_read				: in std_logic;
		start_init_memory		: in std_logic;
		finished_read			: out std_logic;
		data					: in std_logic_vector((DATA_WIDTH-1) downto 0);
		q						: out std_logic_vector((DATA_WIDTH -1) downto 0);
		map_addr_local_memory	: out SR_LENGTH;
		wrens_b_buffer	 		: out std_logic_vector(NUM_MEMORIES-1 DOWNTO 0)
	);
	end component;


	
begin
	sel_addr_a_0 <= (others => '0');
	sig_1  <= (others =>'1');
	sig_addr_a_0 <= (others => '0');
	
	delay_01_reg_start_pm_comparator_in <= init_pm_comparator; --finished_init_memory;--
	delay_02_reg_start_pm_comparator_in <= delay_01_reg_start_pm_comparator_out;
	delay_03_reg_start_pm_comparator_in <= delay_02_reg_start_pm_comparator_out;
	delay_04_reg_start_pm_comparator_in <= delay_03_reg_start_pm_comparator_out;
	
	delay_02_sel_mux_in <= delay_01_sel_mux_out;
	
	start_pm_comparator <= delay_03_reg_start_pm_comparator_out; 
	sel_mux_memportB <= delay_02_sel_mux_out;
	
	delay_02_sel_mux_mp_in <= delay_01_sel_mux_mp_out;
	sel_mux_mp <= delay_02_sel_mux_mp_out;
	
	delay_02_we_mp0_in <= delay_01_we_mp0_out;
	delay_02_we_mp1_in <= delay_01_we_mp1_out;
	delay_02_we_mp2_in <= delay_01_we_mp2_out;
	
	we_reg_mp0  <= delay_02_we_mp0_out; 
	we_reg_mp1  <= delay_02_we_mp1_out; --
	we_reg_mp2  <= delay_02_we_mp2_out; --
	
	map_n_memories: n_memories
	port map
	(              
		clk		=> clk,
		datas_b => datas_b,
		addrs_a	=> addrs_a,
		addrs_b => addrs_b,
		wrens_b	=> wrens_b, --incluí o INIT aqui
		rden_a	=> sig_1,
		rden_b	=> sig_1,
		qs_a	=> qs_a,
		qs_b	=> qs_b
	);             
	
	map_memory_manager: memory_manager
	generic map(
		START_MEM_ADRR_INC	=> 24,
		END_MEM_ADDR_INC	=> 31,
		START_MEM_ADRR_DEC	=> 7,
		END_MEM_ADDR_DEC	=> 0
	)
	port map(
		rst			=> rst,
		clk			=> clk,
		start		=> delay_01_reg_start_pm_comparator_out,
		
		sel_mux_mp	=> delay_01_sel_mux_mp_in,--sel_mux_mp,
		sel_mux_memportB => delay_01_sel_mux_in,--sel_mux_memportB;--

		we_reg_mp0 => delay_01_we_mp0_in,
		we_reg_mp1 => delay_01_we_mp1_in,
		we_reg_mp2 => delay_01_we_mp2_in,
		
		init_read_buffer => init_read_buffer,

		mem_port_a_addr => delay_01_mem_port_a_addr_in,
		mem_port_b_addr => mem_port_b_addr_shifts
	);
	
	mmap_memory_level_2_manager:memory_level_2_manager 
	generic map
	(
		DATA_WIDTH => 64,
		ADDR_WIDTH => 5
	)
	port map
	(
		clk						=> clk,
		rst						=> rst,
		start_write				=> start_write_buffer,
		start_read				=> start_read_buffer,
		start_init_memory		=> start_init_line,
		finished_read			=> finished_read_buffer,
		data					=> word_external_memory,
		q						=> word_from_buffer,
		wrens_b_buffer			=> wrens_b_buffer,
		map_addr_local_memory	=> map_addr_local_memory --mem_port_b_addr_buffer
	);
	
	map_init_memory_manager: init_memory_manager
	generic map(
		START_MEM_ADRR_INC	=> 24,
		END_MEM_ADDR_INC	=> 31,
		START_MEM_ADRR_DEC	=> 7,
		END_MEM_ADDR_DEC	=> 0
	)
	port map(
		rst				=> rst,
		clk				=> clk,
		start			=> start_init_line,
		finished		=> finished_init_memory,
		mem_port_b_we	=> wrens_b_init,
		mem_port_b_addr	=> mem_port_b_addr_init
	);

	for_addrs_a: 
	for i in 0 to NUM_MEMORIES-1 generate
		addrs_a(i) <= mem_port_a_addr;--delay_01_mem_port_a_addr_out; 
	end generate;
	
	for_addrs_b: 
	for j in 0 to NUM_MEMORIES-9 generate
		addrs_b(j) <= mem_port_b_addr_choice;
	end generate;

	for_addrs_b_lasts: 
	for j in NUM_MEMORIES-8 to NUM_MEMORIES-1 generate
		addrs_b(j) <= mem_port_b_addr_choice_lasts;
	end generate;
	
	state_machine: process(state, start_init_line, start_read_buffer, finished_init_memory, mem_port_b_addr_init, mem_port_b_addr_shifts,mem_port_b_addr_buffer, wrens_b_buffer)
	begin
		
		case (state) is
		
			when s0_start =>
		
				--mem_port_b_addr_choice <= mem_port_b_addr_init;--map_addr_local_memory(to_integer(unsigned(mem_port_b_addr_init)));
				--wrens_b <= wrens_b_init;
				sel_mux_addr_b <= "00";
				sel_wrens_b <= '0';
				sel_data_b_memory <= '0';
				sel_mux_addr_b_lasts <= '0';
				
				if (finished_init_memory = '1') then
					init_pm_comparator <= '1';
	 				next_state <= s1_memory_manager;
				else
					init_pm_comparator <= '0';
					next_state <= s0_start;
				end if;
				
				we_count_rb <= '0';
				sel_count_rb <= '0';
				sel_mux_addr_a_map <= '0';
			
			when s1_memory_manager =>
			
				--mem_port_b_addr_choice <= mem_port_b_addr_shifts;--map_addr_local_memory(to_integer(unsigned(mem_port_b_addr_shifts)));	
				
				--wrens_b <= wrens_b_init;
				sel_mux_addr_b <= "01";
				sel_wrens_b <= '0';
				sel_data_b_memory <= '0';
				
				init_pm_comparator <= '0';
	 				
				if (start_init_line = '1') then
					we_count_rb <= '0';
					next_state <= s0_start;
				elsif(start_read_buffer = '1') then
					we_count_rb <= '1';
					next_state <= s2_read_buffer;
				else
					we_count_rb <= '0';
					next_state <= s1_memory_manager;
				end if;			
				
				sel_count_rb <= '0';
				sel_mux_addr_b_lasts <= '0';
				sel_mux_addr_a_map <= '0';
				
			when s2_read_buffer => --Lendo do buffer e gravando na memoria local
			
				--mem_port_b_addr_choice <= map_addr_local_memory(0); --mem_port_b_addr_shifts; --mem_port_b_addr_buffer;
				sel_mux_addr_b <= "10";
				sel_wrens_b <= '1';
				--wrens_b <= wrens_b_buffer;
				sel_data_b_memory <= '1';
				
				we_count_rb <= '1';
				sel_count_rb <= '1';
				
				if (finished_read_buffer = '1') then
					init_pm_comparator <= '1';
					next_state <= s2_delay;--s1_memory_manager;
				else
					init_pm_comparator <= '0';
					next_state <= s2_read_buffer;
				end if;
				
				sel_mux_addr_a_map <= '1';
				
				-- enquanto menor que 24
				if (count_rb_out < 24) then
					sel_mux_addr_b_lasts <= '1';
				else
					sel_mux_addr_b_lasts <= '0';
				end if;
				
			when s2_delay => --Tempo de gravar o último valor do buffer na memória local
			
				--mem_port_b_addr_choice <= map_addr_local_memory(to_integer(unsigned(mem_port_b_addr_shifts)));	
				--wrens_b <= wrens_b_buffer;
				we_count_rb <= '1';
				sel_count_rb <= '0';
			
				sel_mux_addr_b_lasts <= '0';
				sel_mux_addr_b <= "10";
				sel_wrens_b <= '1';
				sel_data_b_memory <= '1';
				init_pm_comparator <= '0';
				next_state <= s1_memory_manager;
				sel_mux_addr_a_map <= '1';
				
		end case;
	end process;
	
	update_state: process(clk, rst)
	begin
		if (rst = '1') then
			state <= s0_start;
		elsif (clk'event and clk = '1') then
			state <= next_state;
		end if;
	end process;
	
	delay_reg_start_pm_comparator: process(clk, rst)
	begin
		if (clk'event and clk = '1') then
			delay_01_reg_start_pm_comparator_out <= delay_01_reg_start_pm_comparator_in;
			delay_02_reg_start_pm_comparator_out <= delay_02_reg_start_pm_comparator_in;
			delay_03_reg_start_pm_comparator_out <= delay_03_reg_start_pm_comparator_in;
			delay_04_reg_start_pm_comparator_out <= delay_04_reg_start_pm_comparator_in;
		end if;
	end process;
	
	delay_01_sel_mux: process(clk, rst)
	begin
		if (clk'event and clk = '1') then
			delay_01_sel_mux_out <= delay_01_sel_mux_in;
			delay_02_sel_mux_out <= delay_02_sel_mux_in;
		end if;
	end process;
	
	delay_sel_mux_mp: process(clk, rst)
	begin
		if (clk'event and clk = '1') then
			delay_01_sel_mux_mp_out <= delay_01_sel_mux_mp_in;
			delay_02_sel_mux_mp_out <= delay_02_sel_mux_mp_in;
		end if;
	end process;
	
	delay_01_mem_port_a_addr: process(clk, rst)
	begin
		if (clk'event and clk = '1') then
			delay_01_mem_port_a_addr_out <= delay_01_mem_port_a_addr_in;
		end if;
	end process;
	
	delay_wens: process(clk, rst)
	begin
		if (clk'event and clk = '1') then
			delay_01_we_mp0_out <= delay_01_we_mp0_in;
			delay_01_we_mp1_out <= delay_01_we_mp1_in;
			delay_01_we_mp2_out <= delay_01_we_mp2_in;
			
			delay_02_we_mp0_out <= delay_02_we_mp0_in;
			delay_02_we_mp1_out <= delay_02_we_mp1_in;
			delay_02_we_mp2_out <= delay_02_we_mp2_in;
			
		end if;
	end process;
	
	--delay_02_sel_mux: process(clk, rst)
	--begin
	--	if (clk'event and clk = '1') then
	--		delay_02_sel_mux_out <= delay_02_sel_mux_in;
	--	end if;
	--end process;
	
	reg_count_rb: process(clk, rst, we_count_rb)
	begin
		if (clk'event and clk = '1' and we_count_rb = '1') then
			count_rb_out <= count_rb_in;
		end if;
	end process;
	
	reg_map_addr_local_memory: process(clk, rst, start_write_buffer)
	begin
		if (clk'event and clk = '1' and start_write_buffer = '1') then
			map_addr_local_memory_anterior <= map_addr_local_memory;
		end if;
	end process;
	
	sig_count_rb <= count_rb_out + 1;
	
	mux_reg_count_rb:
		with sel_count_rb select
			count_rb_in <= 
					0 				when '0',
					sig_count_rb 	when '1',
					0				when others;
		
	mux_wrens_b:
		with sel_wrens_b select
			wrens_b <= 
				wrens_b_init	when '0',
				wrens_b_buffer 	when '1',
				wrens_b_init	when others;
	
	
	mux_addr_b_lasts:
		with sel_mux_addr_b_lasts select
			mem_port_b_addr_choice_lasts <= 
				mem_port_b_addr_choice 																when '0',
				map_addr_local_memory_anterior(to_integer(unsigned(mem_port_b_addr_shifts)))		when '1',
				mem_port_b_addr_choice 																when others;
	
	mux_addr_b:
		with sel_mux_addr_b select
			mem_port_b_addr_choice <= 
				mem_port_b_addr_init													when "00",
				map_addr_local_memory(to_integer(unsigned(mem_port_b_addr_shifts))) 	when "01",
				map_addr_local_memory(3)											 	when "10",
				mem_port_b_addr_init												 	when "11",
				mem_port_b_addr_init		
				when others;
	
	mux_addr_a_map:
		with sel_mux_addr_a_map select
			choice_map_addr_local_memory <=
				map_addr_local_memory			when '0',
				map_addr_local_memory_anterior	when '1',
				map_addr_local_memory			when others;
			
	map_map_addr_a_circular: map_addr_a_circular
	generic map
	(
		INIT_0 => 0,
		INIT_1 => 8,
		INIT_2 => 16,
 		INIT_3 => 24
	)
	port map
	(
		addr    		=> delay_01_mem_port_a_addr_out,
		sel				=> choice_map_addr_local_memory(0),--sel_addr_a_0,--sel_addr_a_0,
		map_actual_addr	=> mem_port_a_addr
	);
	
	
	mux_data_b_memory:
		with sel_data_b_memory select
			data_b_memory <= 
				word_external_memory when '0',
				word_from_buffer when '1',
				word_external_memory when others;
				
	for_datas_port_b:
	for k in 0 to NUM_MEMORIES-1 generate
		datas_b(k) <= data_b_memory;
	end generate;
	
end behaviour;
