------------------------------------------------------------------------------
-- PROJETO: Estimação de Movimento
-- ENTIDADE : global_control
------------------------------------------------------------------------------
-- DESCRIÇÃO: Controle global do projeto
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.all;
use work.motion_estimation_8x8_package.all;

entity global_control is
port(
	clk: in std_logic;
	rst: in std_logic;
	
	init_read_buffer: in std_logic;
	start_architecture: in std_logic;
	end_search: in std_logic;
	vectors_ready: out std_logic;
	start_init_line: out std_logic;
	start_read_buffer: out std_logic;
	start_write_buffer: out std_logic	
);
end entity;

architecture behaviour of global_control is

	TYPE STATE_TYPE is (start, s01, s02, s03, s04, s05, s06);
	TYPE STATE_TYPE_MV is (start, s0);
	SIGNAL sig_count, count_in, count_out: INTEGER RANGE 0 TO 255 := 0;
	SIGNAL sig_count_mv, count_mv_in, count_mv_out: INTEGER RANGE 0 TO 255 := 0;
	SIGNAL sig_count_blocks, count_blocks_in, count_blocks_out: INTEGER RANGE 0 TO BLOCKS_PER_LINE+1 := 0;
	SIGNAL state, next_state: STATE_TYPE;
	SIGNAL state_mv, next_state_mv: STATE_TYPE_MV;
	SIGNAL sel_count_blocks, sel_count_mv, sel_count, we_count, we_count_blocks, we_count_mv: std_logic := '0';
	CONSTANT TIME_WRITE_LOCAL_MEMORY: INTEGER := 128;
	CONSTANT TIME_WRITE_BUFFER: INTEGER := 32;
	CONSTANT TIME_READ_BUFFER: INTEGER := 32;
	CONSTANT TIME_WAIT_VECTORS: INTEGER := 11;
begin

	state_machine: process(state, start_architecture, end_search, count_out, count_blocks_out, init_read_buffer)
	begin
		
		case (state) is
		
			when start => --inicia a leitura da memoria
	
				if (start_architecture = '1') then
					start_init_line 	<= '1';
					next_state <= s01;
				else
					start_init_line 	<= '0';
					next_state <= start;
				end if;

				start_read_buffer	<= '0';
				start_write_buffer	<= '0';
				
				sel_count <= '0';
				sel_count_blocks <= '0';
				we_count <= '1';
				we_count_blocks <= '1';
				
			when s01 => --escrevendo dados na memoria local 
						--espera X ciclos para terminar a escrita dos dados na memoria local
				 
				we_count <= '1';
				
				if (count_out = TIME_WRITE_LOCAL_MEMORY) then
					next_state <= s02;
					start_write_buffer	<= '1';
					sel_count <= '0';
				else
					next_state <= s01;
					start_write_buffer	<= '0';	
					sel_count <= '1';
				end if;
				
				sel_count_blocks <= '0';
				we_count_blocks <= '0';
				
				start_init_line 	<= '0';
				start_read_buffer	<= '0';
			
			when s02 => --escrevendo dados no buffer 
						--espera X ciclos para terminar a escrita dos dados no buffer
				 
				if (count_out = TIME_WRITE_BUFFER) then
					next_state <= s03;
					sel_count <= '0';
				else
					next_state <= s02;
					sel_count <= '1';
				end if;
			
				sel_count_blocks <= '0';
				we_count <= '1';
				we_count_blocks <= '0';
				
				start_write_buffer	<= '0';
				start_init_line 	<= '0';
				start_read_buffer	<= '0';
				
			
			when s03 => --espera a busca acabar
				 
				start_init_line 	<= '0';
				start_read_buffer	<= '0';
				start_write_buffer	<= '0';
				we_count_blocks <= '1';
				we_count <= '0';
				sel_count <= '0';
				
				if (count_blocks_out = BLOCKS_PER_LINE-1) then
					--vai para o estado s05, esperar a busca acabar e comecar uma nova linha
					next_state <= s05;
					sel_count_blocks <= '0';
				else
					--vai para o estado s04 esperar para começar a escrever do buffer na memoria local
					next_state <= s04;
					sel_count_blocks <= '1';
				end if;
	
			when s04 => --espera a busca acabar
			 
				start_init_line 	<= '0';
				start_write_buffer	<= '0';
				we_count_blocks <= '0';
				we_count <= '0';
				sel_count <= '0';
				sel_count_blocks <= '0';
				
				if (init_read_buffer = '1') then
					--vai para o estado s06, ler do buffer e escrever na memoria local
					start_read_buffer	<= '1';
					next_state <= s06;
				else
					--permanece aqui	
					start_read_buffer	<= '0';
					next_state <= s04;
				end if;
					
			when s05 => --inciando a leitura dos dados do buffer e gravando na memoria local
				
				start_read_buffer	<= '0';
					
				if (end_search = '1') then
					start_init_line 	<= '1';
					next_state <= s01;
				else
					start_init_line 	<= '0';
					next_state <= s05;
				end if;
				
				sel_count_blocks <= '0';
				we_count_blocks <= '0';
				sel_count <= '0';
				we_count <= '0';
				start_write_buffer	<= '0';
							
			when s06 => --espera a leitura de dados do buffer acabar
				
				we_count <= '1';
				
				if (count_out = TIME_READ_BUFFER) then
					sel_count <= '0';
					start_write_buffer	<= '1';
					next_state <= s02;
				else
					sel_count <= '1';
					start_write_buffer	<= '0';
					next_state <= s06;
				end if;

				sel_count_blocks <= '0';
				we_count_blocks <= '0';
				
				start_init_line 	<= '0';
				start_read_buffer	<= '0';
			
			end case;
			
	end process;
		
	notify_vectors_ready: process (clk, rst, end_search, count_mv_out)	
	begin
		case (state_mv) is
	
			when start => 
				sel_count_mv <= '0';
				we_count_mv <= '1';
				vectors_ready <= '0';
				
				if (end_search = '1') then
					next_state_mv <= s0;
				else
					next_state_mv <= start;
				end if;
			
			when s0 => 
				sel_count_mv <= '1';
				we_count_mv <= '1';
				
				if (count_mv_out = TIME_WAIT_VECTORS) then
					vectors_ready <= '1';
					next_state_mv <= start;
				else
					vectors_ready <= '0';
					next_state_mv <= s0;
				end if;
		
		end case;
	end process;

	update_state: process (clk, rst)
	begin
		if (rst = '1') then
			state <= start;
			state_mv <= start;
		elsif (clk'event and clk = '1') then
			state <= next_state;
			state_mv <= next_state_mv;
		end if;	
	end process;

	registers: process(clk, rst)
	begin
		if (clk'event and clk = '1') then
			if (we_count = '1') then
				count_out <= count_in;
			end if;
			
			if (we_count_blocks = '1') then
				count_blocks_out <= count_blocks_in;
			end if;
			
			if (we_count_mv = '1') then
				count_mv_out <= count_mv_in;
			end if;

		end if;
	end process;
	
	sig_count <= count_out + 1;
	sig_count_blocks <= count_blocks_out + 1;
	sig_count_mv <= count_mv_out + 1;
	
	mux_reg_count:
		with sel_count select
			count_in <= 
					0 			when '0',
					sig_count 	when '1',
					0			when others;
		
	
	mux_reg_count_count_blocks:
		with sel_count_blocks select
			count_blocks_in <= 
					0 					when '0',
					sig_count_blocks 	when '1',
					0					when others;
		
	
	mux_reg_count_mv:
		with sel_count_mv select
			count_mv_in <= 
					0 					when '0',
					sig_count_mv	 	when '1',
					0					when others;
end behaviour; 
