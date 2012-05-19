------------------------------------------------------------------------------
-- PROJETO: Estimação de Movimento
-- ENTIDADE : init_memory_manager
------------------------------------------------------------------------------
-- DESCRIÇÃO: Preenche os bancos de registradores de referencia com os dados
-- da memória local
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.all;
use work.motion_estimation_8x8_package.all;

entity init_memory_manager is
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
end entity;

architecture behaviour of init_memory_manager is


	TYPE STATE_TYPE is (s0_start, s0_init_memory);
	SIGNAL count_in, count_out, add_count, sig_count_widthad_0, sig_count_widthad_1: std_logic_vector(MEM_PORT_A_WIDTHAD-1 DOWNTO 0);
	
	signal sig_mem_port_b_in, sig_mem_port_b_out, addr_port_b_add, sig_portb_widthad_0, sig_portb_widthad_1: std_logic_vector(MEM_PORT_B_WIDTHAD-1 DOWNTO 0);
	SIGNAL state, next_state : STATE_TYPE;
	signal sig_reg_mem_port_b_we, sig_count_we, sel_mux_port_b, sel_count, we_count: std_logic;
	signal i: INTEGER RANGE 0 TO NUM_MEMORIES-1;
	signal mem_port_b_we_out, sig_mem_port_b_we, sig_0: std_logic_vector(NUM_MEMORIES-1 DOWNTO 0);
	
begin
	
	sig_portb_widthad_1 <= (others => '1');
	sig_count_widthad_1 <= (others => '1');
	sig_0 <= (others => '0');
	
	i <= to_integer(unsigned(count_out));
			
	mem_port_b_addr <=  sig_mem_port_b_out;

	state_machine: process(state, start, count_out, sig_mem_port_b_out, sig_portb_widthad_1, sig_count_widthad_1, i, sig_0, sig_mem_port_b_we)
	begin
		
		case (state) is
					
			when s0_start =>
				
				if (start = '1') then
					next_state <= s0_init_memory;
				else
					next_state <= s0_start;
				end if;

				sig_reg_mem_port_b_we <= '1';
				sel_mux_port_b <= '0';
				we_count <= '1';
				sel_count <= '0';
				mem_port_b_we <= sig_0;
				finished <= '0';
				
			when s0_init_memory=>

				if ( sig_mem_port_b_out = sig_portb_widthad_1) then					
					we_count <= '1';
					sel_count <= '1';	
				else
					we_count <= '0';
					sel_count <= '1';
				end if;
				
				if ((count_out = sig_count_widthad_1) AND (sig_mem_port_b_out = sig_portb_widthad_1) ) then
					next_state <= s0_start;
					finished <= '1';
				else
					next_state <= s0_init_memory;
					finished <= '0';
				end if;
				
				sig_reg_mem_port_b_we <= '1';
				sel_mux_port_b <= '1';
				mem_port_b_we <= sig_mem_port_b_we;
		
		end case;
	end process;
	
	reg_addr_port_b: process(clk, sig_reg_mem_port_b_we)
	begin
		if (clk'event and clk='1' and sig_reg_mem_port_b_we='1') then
			sig_mem_port_b_out <= sig_mem_port_b_in;
		end if;
	end process;					

	sig_portb_widthad_0 <= (others => '0');
	addr_port_b_add <= sig_mem_port_b_out + 1;
	
	mux_port_b:
	with sel_mux_port_b select
		sig_mem_port_b_in <= 
					sig_portb_widthad_0 when '0',
					addr_port_b_add when '1',
					sig_portb_widthad_0 when others;

	reg_count: process(clk, we_count)
	begin
		if (clk'event and clk='1' and we_count='1') then
			count_out <= count_in;
		end if;
	end process;					
	
	sig_count_widthad_0 <= (others => '0');
	add_count <= count_out + 1;

	mux_count:
	with sel_count select
		count_in <= 
					sig_count_widthad_0 when '0',
					add_count when '1',
					sig_count_widthad_0 when others;
					
	update_state: process(clk, rst)
	begin
		if (rst = '1') then
			state <= s0_start;
		elsif (clk'event and clk = '1') then
			state <= next_state;
		end if;
	end process;
	
	mux_we_mem_port_b:
	with count_out select
		sig_mem_port_b_we <= 
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