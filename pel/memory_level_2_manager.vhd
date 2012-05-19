------------------------------------------------------------------------------
-- PROJETO: Estimação de Movimento
-- ENTIDADE : memory_level_2_manager
------------------------------------------------------------------------------
-- DESCRIÇÃO: Controle para gerenciar as leituras e escritas na memória 
-- secundária
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.motion_estimation_8x8_package.all;

entity memory_level_2_manager is

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
		wrens_b_buffer	 		: out std_logic_vector( (NUM_MEMORIES-1) DOWNTO 0)
	);

end entity;

architecture behaviour of memory_level_2_manager is

	component memory_level_2 is
	generic 
	(
		DATA_WIDTH : natural := 64;
		ADDR_WIDTH : natural := 5
	);

	port 
	(
		clk		: in std_logic;
		addr	: in integer range 0 to 2**ADDR_WIDTH - 1;
		data	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		we		: in std_logic := '1';
		q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
	);
	end component;
	
	component shift_circular is
	generic
	(
		NUM_STAGES : natural := 4
	);
	port 
	(
		clk	    : in std_logic;
		enable	: in std_logic;
		start   : in std_logic;
		sr_out	: out SR_LENGTH
	);
	end component;

	TYPE STATE_TYPE is (s0_start, s0_init_memory, s0_read_memory);
	SIGNAL state, next_state: STATE_TYPE;
	
	signal reg_addr_in, reg_addr_out, sig_soma_addr: integer range 0 to 2**ADDR_WIDTH;
	signal we, we_addr, sel_in_addr: std_logic;
	signal sig_mem_port_b_we_in, sig_mem_port_b_we_out, delay_port_b_we_out , delay_port_b_we_in: std_logic_vector( (NUM_MEMORIES-1) DOWNTO 0);
begin
	
	wrens_b_buffer <= sig_mem_port_b_we_out; --delay de um ciclo para dar tempo de receber a palavra, após realizar a leitura
	
	state_machine: process(state, start_write, start_read, reg_addr_out)
	begin
		case (state) is
					
			when s0_start =>
				
				sel_in_addr <= '0';
				we_addr <= '1';
				we <= '0';
				finished_read <= '0';
				
				if (start_write = '1') then
					next_state <= s0_init_memory;
				elsif (start_read = '1') then
					next_state <= s0_read_memory;
				else
					next_state <= s0_start;
				end if;
							
			when s0_init_memory =>
				
				sel_in_addr <= '1';
				we <= '1';
				finished_read <= '0';
				
				if (reg_addr_out = 31) then
					we_addr <= '0';					
					next_state <= s0_start;
				else
					we_addr <= '1';
					next_state <= s0_init_memory;
				end if;
							
			when s0_read_memory =>
				
				sel_in_addr <= '1';
				we <= '0';
				
				if (reg_addr_out = 31) then
					we_addr <= '0';			
					finished_read <= '1';		
					next_state <= s0_start;
				else
					we_addr <= '1';
					finished_read <= '0';
					next_state <= s0_read_memory;
				end if;
				
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
	
	
	sig_soma_addr <= reg_addr_out + 1;

	reg_addr: process(clk, we_addr)
	begin
		if (clk'event and clk='1' and we_addr = '1') then
			reg_addr_out <= reg_addr_in;
		end if;
	end process;
	
	reg_we: process(clk)
	begin
		if (clk'event and clk='1') then
			sig_mem_port_b_we_out <= sig_mem_port_b_we_in;
			delay_port_b_we_out <= delay_port_b_we_in;
		end if;
	end process;
	
	mux_addr:
		with sel_in_addr select
		reg_addr_in <= 
					0 when '0',
					sig_soma_addr when '1',
					0 when others;
	
	
	map_memory_level_2_manager: memory_level_2
	generic map
	(
		DATA_WIDTH => 64,
		ADDR_WIDTH => 5
	)
	port map
	(
		clk		=> clk,
		addr	=> reg_addr_out,
		data	=> data,
		we		=> we,
		q		=> q
	);
	
	map_shift_circular: shift_circular
	generic map
	(
		NUM_STAGES => 4
	)
	port map
	(
		clk	  	=> clk,
		start   => start_init_memory,
		enable	=> start_read,
		sr_out	=> map_addr_local_memory
	);
	
	

	mux_we_mem_port_b:
	with std_logic_vector(to_unsigned(reg_addr_out, MEM_PORT_A_WIDTHAD)) select
		sig_mem_port_b_we_in <= 
			"00000000000000000000000000000001"	when "00000",
			"00000000000000000000000000000010"	when "00001",
			"00000000000000000000000000000100"	when "00010",
			"00000000000000000000000000001000"	when "00011",
	        "00000000000000000000000000010000"  when "00100",
            "00000000000000000000000000100000"  when "00101",
	        "00000000000000000000000001000000"  when "00110",
	        "00000000000000000000000010000000"  when "00111",
	        "00000000000000000000000100000000"  when "01000",
	        "00000000000000000000001000000000"  when "01001",
	        "00000000000000000000010000000000"  when "01010",
	        "00000000000000000000100000000000"  when "01011",
	        "00000000000000000001000000000000"  when "01100",
	        "00000000000000000010000000000000"  when "01101",
	        "00000000000000000100000000000000"  when "01110",
	        "00000000000000001000000000000000"  when "01111",
			"00000000000000010000000000000000"	when "10000",
	        "00000000000000100000000000000000"  when "10001",
	        "00000000000001000000000000000000"  when "10010",
	        "00000000000010000000000000000000"  when "10011",
	        "00000000000100000000000000000000"  when "10100",
	        "00000000001000000000000000000000"  when "10101",
	        "00000000010000000000000000000000"  when "10110",
	        "00000000100000000000000000000000"  when "10111",
	        "00000001000000000000000000000000"  when "11000",
	        "00000010000000000000000000000000"  when "11001",
	        "00000100000000000000000000000000"  when "11010",
	        "00001000000000000000000000000000"  when "11011",
	        "00010000000000000000000000000000"  when "11100",
			"00100000000000000000000000000000"  when "11101",
            "01000000000000000000000000000000"  when "11110",
            "10000000000000000000000000000000"  when "11111",
			"00000000000000000000000000000000"  when others;
	                                                 
end behaviour;                                       
                                                     
