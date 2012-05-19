------------------------------------------------------------------------------
-- PROJETO: Estimação de Movimento
-- ENTIDADE : memory_manager
------------------------------------------------------------------------------
-- DESCRIÇÃO: Controle de leitura e escrita na memória local
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.all;
use work.motion_estimation_8x8_package.all;

entity memory_manager is
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
end entity;

architecture behaviour of memory_manager is

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

	component unsigned_adder_subtractor is
		generic
		(
			DATA_WIDTH : natural := 8
		);

		port 
		(
			a		: in std_logic_vector ((DATA_WIDTH-1) downto 0);
			b		: in std_logic_vector  ((DATA_WIDTH-1) downto 0);
			add_sub : in std_logic;
			result	: out std_logic_vector  ((DATA_WIDTH-1) downto 0)
		);
	end component;
	
	
	component mux4x1 is
	generic
	(
		N	: integer  :=	32
	);
	port
	(
		-- Input ports
		sel		: in std_logic_vector(1 DOWNTO 0);
		data_a	: in  std_logic_vector(N-1 DOWNTO 0);
		data_b	: in  std_logic_vector(N-1 DOWNTO 0);
		data_c	: in  std_logic_vector(N-1 DOWNTO 0);
		data_d	: in  std_logic_vector(N-1 DOWNTO 0);
		-- Output ports
		data_out : out std_logic_vector(N-1 DOWNTO 0)
	);
	end component;
	
	component mux2x1 is
	generic
	(
		N	: integer  :=	32
	);
	port
	(
		-- Input ports
		sel		: in std_logic;
		data_a	: in  std_logic_vector(N-1 DOWNTO 0);
		data_b	: in  std_logic_vector(N-1 DOWNTO 0);
		-- Output ports
		data_out : out std_logic_vector(N-1 DOWNTO 0)
	);
	end component;

	TYPE STATE_TYPE is (s0_start, s0_init_mp0, s0_init_mp1, s0_init_mp2, s1_inc, s2_read_mem_inc, s3_inc, s4_mux_sel, s5_dec, s6_read_mem_dec, s7_read_mem_dec, s8_mux_sel);
	SIGNAL i: INTEGER RANGE 0 TO NUM_ROWS-1;
	
	SIGNAL state, next_state : STATE_TYPE;
		
	SIGNAL saida_mux_addr_a, sig_add_sub_mem_addr_a_out, sig_reg_mem_addr_a_in, sig_reg_mem_addr_a_out: std_logic_vector(MEM_PORT_A_WIDTHAD-1 DOWNTO 0);
	SIGNAL sel_ativa_saida_addra_a, sig_add_sub_mem_addr_b, sig_add_sub_mem_addr_a, sig_reg_mem_addr_b_we, sig_reg_mem_addr_a_we: std_logic;
	SIGNAL sig_sel_mux_mem_addr_a, sig_sel_mux_mem_addr_b: std_logic_vector(1 DOWNTO 0);
	
	SIGNAL sig_add_sub_mem_addr_b_out, sig_reg_mem_addr_b_in, sig_reg_mem_addr_b_out:std_logic_vector(MEM_PORT_B_WIDTHAD-1 DOWNTO 0);
	
	SIGNAL sig_add_sub_mux_sel, sig_reg_we_sel_mux_mp, sig_sel_mux_mp:std_logic_vector(NUM_ROWS-1 DOWNTO 0);
	SIGNAL sig_reg_mux_sel_in, sig_reg_mux_sel_out, sig_add_sub_mux_sel_out: VECTOR_MUX;
	
	SIGNAL sig_width_sel_mux_memories_1 : std_logic_vector(WIDTH_SELMUX_MEMORIES-1 DOWNTO 0);
	SIGNAL sig_mem_port_b_widthad_0, sig_mem_port_b_widthad_1: std_logic_vector(MEM_PORT_B_WIDTHAD-1 DOWNTO 0);
	SIGNAL sig_mem_port_a_widthad_0, sig_mem_port_a_widthad_15, sig_mem_port_a_widthad_1: std_logic_vector(MEM_PORT_A_WIDTHAD-1 DOWNTO 0);	
	SIGNAL sig_block_dimension: std_logic_vector(MEM_PORT_A_WIDTH-1 DOWNTO 0);
begin
	
	sig_mem_port_a_widthad_15 <= "11000";
	sel_mux_mp <= sig_reg_mux_sel_out;
	--sel_mux_memportB <= sig_reg_mux_sel_out(NUM_COLS-1) + 1;
	mem_port_a_addr <= saida_mux_addr_a;--sig_reg_mem_addr_a_out;
	mem_port_b_addr <= sig_reg_mem_addr_b_out;
	
	sig_block_dimension <= std_logic_vector(to_unsigned(BLOCK_DIMENSION-1, MEM_PORT_A_WIDTH));
	
	
	state_machine: process(state, start, sig_reg_mem_addr_a_out, sig_reg_mux_sel_out, sig_block_dimension)
	begin
		
		case (state) is
					
			when s0_start =>
	
				sig_reg_mem_addr_a_we <= '1'; -- write enable do registrador de endereco da memoria porta A 
				sig_add_sub_mem_addr_a <= '1'; -- (dont care) -- somar ou subtrair o valor do registrador de endereco porta A (1 para soma, 0 subtracao)
				sig_sel_mux_mem_addr_a <= "00"; -- selecao do mux para passagem do valor para o registrador endereco porta A 
									   -- 00 ( 0 ) | 01 START_MEM_ADDR_INC | 10 START_MEM_ADDR_DEC | 11 RESULTADO DA SOMA
	
				sig_reg_mem_addr_b_we <= '1';-- write enable do registrador de endereco da memoria porta B
				sig_add_sub_mem_addr_b <= '-'; --(dont care)-- somar ou subtrair o valor do registrador de endereco porta B (1 para soma, 0 subtracao)
				sig_sel_mux_mem_addr_b <= "00";-- selecao do mux para passagem do valor para o registrador endereco porta B
									   -- 00 ( 0 ) | 01 (1) | 10 (dont care) | 11 RESULTADO DA SOMA
	
				sig_reg_we_sel_mux_mp <= (others => '1'); -- write enable dos registradores do valor da selecao do MUX 
				sig_add_sub_mux_sel <= (others => '-'); --(dont care)-- somar ou subtrair o valor do registrador da selecao do MUX (1 para soma, 0 subtracao)
				sig_sel_mux_mp <= (others => '0');-- selecao do mux para passagem do valor para o registrador 
								  -- 0 (i) |  1 (valor da soma )
			
				we_reg_mp0 <= '0';
				we_reg_mp1 <= '0';
				we_reg_mp2 <= '0';

				sel_mux_memportB <= sig_reg_mux_sel_out(0);
				sel_ativa_saida_addra_a <= '0';
				
				init_read_buffer <= '0';
				
				if (start = '1') then
					next_state <= s0_init_mp0;
				else
					next_state <= s0_start;
				end if;
			
			when s0_init_mp0 =>
				
				if (sig_reg_mem_addr_a_out = sig_block_dimension ) then 
					sig_reg_mem_addr_a_we <= '1'; -- write enable do registrador de endereco da memoria porta A 
					sig_add_sub_mem_addr_a <= '1'; -- (dont care) -- somar ou subtrair o valor do registrador de endereco porta A (1 para soma, 0 subtracao)
					sig_sel_mux_mem_addr_a <= "00"; -- selecao do mux para passagem do valor para o registrador endereco porta A 
									   -- 00 ( 0 ) | 01 START_MEM_ADDR_INC | 10 START_MEM_ADDR_DEC | 11 RESULTADO DA SOMA
									   									   
					sig_reg_mem_addr_b_we <= '1';-- write enable do registrador de endereco da memoria porta B
					sig_add_sub_mem_addr_b <= '1'; --(dont care)-- somar ou subtrair o valor do registrador de endereco porta B (1 para soma, 0 subtracao)
					sig_sel_mux_mem_addr_b <= "11";-- selecao do mux para passagem do valor para o registrador endereco porta B
										   -- 00 ( 0 ) | 01 (1) | 10 (dont care) | 11 RESULTADO DA SOMA				   

					sig_reg_we_sel_mux_mp <= (others => '1'); -- write enable dos registradores do valor da selecao do MUX 
					sig_add_sub_mux_sel <= (others => '0'); --(dont care)-- somar ou subtrair o valor do registrador da selecao do MUX (1 para soma, 0 subtracao)
					sig_sel_mux_mp <= (others => '0');-- selecao do mux para passagem do valor para o registrador 
									  -- 0 (i) |  1 (valor da soma )
										   
					next_state <= s0_init_mp1;
				else
					sig_reg_mem_addr_a_we <= '1'; -- write enable do registrador de endereco da memoria porta A 
					sig_add_sub_mem_addr_a <= '1'; -- (dont care) -- somar ou subtrair o valor do registrador de endereco porta A (1 para soma, 0 subtracao)
					sig_sel_mux_mem_addr_a <= "11"; -- selecao do mux para passagem do valor para o registrador endereco porta A 
										   -- 00 ( 0 ) | 01 START_MEM_ADDR_INC | 10 START_MEM_ADDR_DEC | 11 RESULTADO DA SOMA
											   
					sig_reg_mem_addr_b_we <= '0';-- write enable do registrador de endereco da memoria porta B
					sig_add_sub_mem_addr_b <= '-'; --(dont care)-- somar ou subtrair o valor do registrador de endereco porta B (1 para soma, 0 subtracao)
					sig_sel_mux_mem_addr_b <= "00";-- selecao do mux para passagem do valor para o registrador endereco porta B
										   -- 00 ( 0 ) | 01 (1) | 10 (dont care) | 11 RESULTADO DA SOMA				   
					
					sig_reg_we_sel_mux_mp <= (others => '1'); -- write enable dos registradores do valor da selecao do MUX 
					sig_add_sub_mux_sel <= (others => '1'); --(dont care)-- somar ou subtrair o valor do registrador da selecao do MUX (1 para soma, 0 subtracao)
					sig_sel_mux_mp <= (others => '1');-- selecao do mux para passagem do valor para o registrador 
									  -- 0 (i) |  1 (valor da soma )
							
					init_read_buffer <= '0';		  
					next_state <= s0_init_mp0;
				end if;

				sel_mux_memportB <= sig_reg_mux_sel_out(0);
				sel_ativa_saida_addra_a <= '0';
				
				we_reg_mp0 <= '0';
				we_reg_mp1 <= '0';
				we_reg_mp2 <= '0';
				
			when s0_init_mp1 =>
				if (sig_reg_mem_addr_a_out = sig_block_dimension ) then --poderia ser um contador
					
					sig_reg_mem_addr_a_we <= '1'; -- write enable do registrador de endereco da memoria porta A 
					sig_add_sub_mem_addr_a <= '1'; -- (dont care) -- somar ou subtrair o valor do registrador de endereco porta A (1 para soma, 0 subtracao)
					sig_sel_mux_mem_addr_a <= "00"; -- selecao do mux para passagem do valor para o registrador endereco porta A 
									   -- 00 ( 0 ) | 01 START_MEM_ADDR_INC | 10 START_MEM_ADDR_DEC | 11 RESULTADO DA SOMA
					
											   
					sig_reg_mem_addr_b_we <= '1';-- write enable do registrador de endereco da memoria porta B
					sig_add_sub_mem_addr_b <= '1'; --(dont care)-- somar ou subtrair o valor do registrador de endereco porta B (1 para soma, 0 subtracao)
					sig_sel_mux_mem_addr_b <= "11";-- selecao do mux para passagem do valor para o registrador endereco porta B
										   -- 00 ( 0 ) | 01 (1) | 10 (dont care) | 11 RESULTADO DA SOMA				   
					
					sig_reg_we_sel_mux_mp <= (others => '1'); -- write enable dos registradores do valor da selecao do MUX 
					sig_add_sub_mux_sel <= (others => '1'); --(dont care)-- somar ou subtrair o valor do registrador da selecao do MUX (1 para soma, 0 subtracao)
					sig_sel_mux_mp <= (others => '0');-- selecao do mux para passagem do valor para o registrador 
									  -- 0 (i) |  1 (valor da soma )				  
									   
					next_state <= s0_init_mp2;
				else
					sig_reg_mem_addr_a_we <= '1'; -- write enable do registrador de endereco da memoria porta A 
					sig_add_sub_mem_addr_a <= '1'; -- (dont care) -- somar ou subtrair o valor do registrador de endereco porta A (1 para soma, 0 subtracao)
					sig_sel_mux_mem_addr_a <= "11"; -- selecao do mux para passagem do valor para o registrador endereco porta A 
										   -- 00 ( 0 ) | 01 START_MEM_ADDR_INC | 10 START_MEM_ADDR_DEC | 11 RESULTADO DA SOMA
					
					sig_reg_mem_addr_b_we <= '0';-- write enable do registrador de endereco da memoria porta B
					sig_add_sub_mem_addr_b <= '-'; --(dont care)-- somar ou subtrair o valor do registrador de endereco porta B (1 para soma, 0 subtracao)
					sig_sel_mux_mem_addr_b <= "01";-- selecao do mux para passagem do valor para o registrador endereco porta B
									   -- 00 ( 0 ) | 01 (1) | 10 (dont care) | 11 RESULTADO DA SOMA
							  
					sig_reg_we_sel_mux_mp <= (others => '1'); -- write enable dos registradores do valor da selecao do MUX 
					sig_add_sub_mux_sel <= (others => '1'); --(dont care)-- somar ou subtrair o valor do registrador da selecao do MUX (1 para soma, 0 subtracao)
					sig_sel_mux_mp <= (others => '1');-- selecao do mux para passagem do valor para o registrador 
									  -- 0 (i) |  1 (valor da soma )
					
					next_state <= s0_init_mp1;
				end if;

				sel_mux_memportB <= sig_reg_mux_sel_out(0);
				sel_ativa_saida_addra_a <= '0';
				
				init_read_buffer <= '0';		  
				we_reg_mp0 <= '0';
				we_reg_mp1 <= '0';
				we_reg_mp2 <= '0';
				
			when s0_init_mp2 =>
			
				if (sig_reg_mem_addr_a_out = sig_block_dimension ) then --poderia ser um contador
					sig_reg_mem_addr_a_we <= '1'; -- write enable do registrador de endereco da memoria porta A 
					sig_add_sub_mem_addr_a <= '0'; -- (dont care) -- somar ou subtrair o valor do registrador de endereco porta A (1 para soma, 0 subtracao)
					sig_sel_mux_mem_addr_a <= "01"; -- selecao do mux para passagem do valor para o registrador endereco porta A 
									   -- 00 ( 0 ) | 01 START_MEM_ADDR_INC | 10 START_MEM_ADDR_DEC | 11 RESULTADO DA SOMA
				
					sig_reg_mem_addr_b_we <= '1';-- write enable do registrador de endereco da memoria porta B
					sig_add_sub_mem_addr_b <= '-'; --(dont care)-- somar ou subtrair o valor do registrador de endereco porta B (1 para soma, 0 subtracao)
					sig_sel_mux_mem_addr_b <= "01";-- selecao do mux para passagem do valor para o registrador endereco porta B
										   -- 00 ( 0 ) | 01 (1) | 10 (dont care) | 11 RESULTADO DA SOMA				   
			
					sig_reg_we_sel_mux_mp <= (others => '1'); -- write enable dos registradores do valor da selecao do MUX 
					sig_add_sub_mux_sel <= (others => '1'); --(dont care)-- somar ou subtrair o valor do registrador da selecao do MUX (1 para soma, 0 subtracao)
					sig_sel_mux_mp <= (others => '0');-- selecao do mux para passagem do valor para o registrador 
								  -- 0 (i) |  1 (valor da soma )
				
					next_state <= s1_inc;
				else
					sig_reg_mem_addr_a_we <= '1'; -- write enable do registrador de endereco da memoria porta A 
					sig_add_sub_mem_addr_a <= '1'; -- (dont care) -- somar ou subtrair o valor do registrador de endereco porta A (1 para soma, 0 subtracao)
					sig_sel_mux_mem_addr_a <= "11"; -- selecao do mux para passagem do valor para o registrador endereco porta A 
										   -- 00 ( 0 ) | 01 START_MEM_ADDR_INC | 10 START_MEM_ADDR_DEC | 11 RESULTADO DA SOMA
					sig_reg_mem_addr_b_we <= '0';-- write enable do registrador de endereco da memoria porta B
					sig_add_sub_mem_addr_b <= '-'; --(dont care)-- somar ou subtrair o valor do registrador de endereco porta B (1 para soma, 0 subtracao)
					sig_sel_mux_mem_addr_b <= "00";-- selecao do mux para passagem do valor para o registrador endereco porta B
										   -- 00 ( 0 ) | 01 (1) | 10 (dont care) | 11 RESULTADO DA SOMA				   
					
					sig_reg_we_sel_mux_mp <= (others => '1'); -- write enable dos registradores do valor da selecao do MUX 
					sig_add_sub_mux_sel <= (others => '1'); --(dont care)-- somar ou subtrair o valor do registrador da selecao do MUX (1 para soma, 0 subtracao)
					sig_sel_mux_mp <= (others => '1');-- selecao do mux para passagem do valor para o registrador 
								  -- 0 (i) |  1 (valor da soma )
	
					next_state <= s0_init_mp2;
				end if;

				sel_mux_memportB <= sig_reg_mux_sel_out(0);
				sel_ativa_saida_addra_a <= '0';
				
				init_read_buffer <= '0';		  
				we_reg_mp0 <= '0';
				we_reg_mp1 <= '0';
				we_reg_mp2 <= '0';
			
			when s1_inc => 
				
				sig_reg_mem_addr_a_we <= '1'; -- write enable do registrador de endereco da memoria porta A 
				sig_add_sub_mem_addr_a <= '1'; -- somar ou subtrair o valor do registrador de endereco porta A (1 para soma, 0 subtracao)
				sig_sel_mux_mem_addr_a <= "11"; -- selecao do mux para passagem do valor para o registrador endereco porta A 
									   -- 00 ( 0 ) | 01 START_MEM_ADDR_INC | 10 START_MEM_ADDR_DEC | 11 RESULTADO DA SOMA
	
				sig_reg_mem_addr_b_we <= '1';-- write enable do registrador de endereco da memoria porta B
				sig_add_sub_mem_addr_b <= '1'; -- somar ou subtrair o valor do registrador de endereco porta B (1 para soma, 0 subtracao)
				sig_sel_mux_mem_addr_b <= "11";-- selecao do mux para passagem do valor para o registrador endereco porta B
									   -- 00 ( 0 ) | 01 (1) | 10 (dont care) | 11 RESULTADO DA SOMA
	
				sig_reg_we_sel_mux_mp <= (others => '0'); -- write enable dos registradores do valor da selecao do MUX 
				sig_add_sub_mux_sel <= (others => '-'); --(dont care)-- somar ou subtrair o valor do registrador da selecao do MUX (1 para soma, 0 subtracao)
				sig_sel_mux_mp <= (others => '-'); --(don't care)-- selecao do mux para passagem do valor para o registrador 
								  -- 0 (i) |  1 (valor da soma )
								  
				we_reg_mp0 <= '1'; 
				we_reg_mp1 <= '0';
				we_reg_mp2 <= '0';

				
				sel_mux_memportB <= sig_reg_mux_sel_out(NUM_COLS-1) + 1;
				sel_ativa_saida_addra_a <= '1';
				
				init_read_buffer <= '0';		  
				next_state <= s2_read_mem_inc;				
			
			
			when s2_read_mem_inc =>

				sig_reg_mem_addr_a_we <= '1'; -- write enable do registrador de endereco da memoria porta A 
				sig_add_sub_mem_addr_a <= '1'; -- somar ou subtrair o valor do registrador de endereco porta A (1 para soma, 0 subtracao)
				sig_sel_mux_mem_addr_a <= "11"; -- selecao do mux para passagem do valor para o registrador endereco porta A 
									   -- 00 ( 0 ) | 01 START_MEM_ADDR_INC | 10 START_MEM_ADDR_DEC | 11 RESULTADO DA SOMA
	
				sig_reg_mem_addr_b_we <= '1';-- write enable do registrador de endereco da memoria porta B
				sig_add_sub_mem_addr_b <= '1'; -- somar ou subtrair o valor do registrador de endereco porta B (1 para soma, 0 subtracao)
				sig_sel_mux_mem_addr_b <= "11";-- selecao do mux para passagem do valor para o registrador endereco porta B
									   -- 00 ( 0 ) | 01 (1) | 10 (dont care) | 11 RESULTADO DA SOMA
	
				sig_reg_we_sel_mux_mp <= (others => '0'); -- write enable dos registradores do valor da selecao do MUX 
				sig_add_sub_mux_sel <= (others => '-'); --(dont care)-- somar ou subtrair o valor do registrador da selecao do MUX (1 para soma, 0 subtracao)
				sig_sel_mux_mp <= (others => '-'); --(don't care)-- selecao do mux para passagem do valor para o registrador 
								  -- 0 (i) |  1 (valor da soma )

							
				we_reg_mp0 <= '0';
				we_reg_mp1 <= '1';
				we_reg_mp2 <= '0';

				next_state <= s3_inc;				
			
				init_read_buffer <= '0';		  
				sel_mux_memportB <= sig_reg_mux_sel_out(NUM_COLS-1) + 1;
				sel_ativa_saida_addra_a <= '1';
			
			when s3_inc =>
				
				sig_reg_mem_addr_a_we <= '1'; -- write enable do registrador de endereco da memoria porta A 
				sig_add_sub_mem_addr_a <= '1'; -- somar ou subtrair o valor do registrador de endereco porta A (1 para soma, 0 subtracao)
				sig_sel_mux_mem_addr_a <= "11"; -- selecao do mux para passagem do valor para o registrador endereco porta A 
									   -- 00 ( 0 ) | 01 START_MEM_ADDR_INC | 10 START_MEM_ADDR_DEC | 11 RESULTADO DA SOMA
	
				sig_reg_mem_addr_b_we <= '-';-- write enable do registrador de endereco da memoria porta B
				sig_add_sub_mem_addr_b <= '-'; -- somar ou subtrair o valor do registrador de endereco porta B (1 para soma, 0 subtracao)
				sig_sel_mux_mem_addr_b <= "--";-- selecao do mux para passagem do valor para o registrador endereco porta B
									   -- 00 ( 0 ) | 01 (1) | 10 (dont care) | 11 RESULTADO DA SOMA
	
				sig_reg_we_sel_mux_mp <= (others => '0'); -- write enable dos registradores do valor da selecao do MUX 
				sig_add_sub_mux_sel <= (others => '-'); --(dont care)-- somar ou subtrair o valor do registrador da selecao do MUX (1 para soma, 0 subtracao)
				sig_sel_mux_mp <= (others => '-'); --(don't care)-- selecao do mux para passagem do valor para o registrador 
								  -- 0 (i) |  1 (valor da soma )
				
				
				if (sig_reg_mem_addr_a_out = std_logic_vector(to_unsigned(END_MEM_ADDR_INC, MEM_PORT_A_WIDTH)) ) then
					next_state <= s4_mux_sel;				
				else
					next_state <= s3_inc;
				end if;
				
				
				we_reg_mp0 <= '0';
				we_reg_mp1 <= '0';

				if (sig_reg_mem_addr_a_out = std_logic_vector(to_unsigned(END_MEM_ADDR_INC-5, MEM_PORT_A_WIDTH)) ) then
					we_reg_mp2 <= '1';
				else
					we_reg_mp2 <= '0';
				end if;
				
				init_read_buffer <= '0';
				sel_mux_memportB <= sig_reg_mux_sel_out(NUM_COLS-1) + 1;
				sel_ativa_saida_addra_a <= '1';
				
			when s4_mux_sel => -- passando para a proxima linha
			
				sig_reg_mem_addr_a_we <= '1'; -- write enable do registrador de endereco da memoria porta A 
				sig_add_sub_mem_addr_a <= '-'; -- somar ou subtrair o valor do registrador de endereco porta A (1 para soma, 0 subtracao)
				sig_sel_mux_mem_addr_a <= "10"; -- selecao do mux para passagem do valor para o registrador endereco porta A 
									   -- 00 ( 0 ) | 01 START_MEM_ADDR_INC | 10 START_MEM_ADDR_DEC | 11 RESULTADO DA SOMA
	
				sig_reg_mem_addr_b_we <= '1';-- write enable do registrador de endereco da memoria porta B
				sig_add_sub_mem_addr_b <= '-'; -- somar ou subtrair o valor do registrador de endereco porta B (1 para soma, 0 subtracao)
				sig_sel_mux_mem_addr_b <= "00";-- selecao do mux para passagem do valor para o registrador endereco porta B
									   -- 00 ( 0 ) | 01 (1) | 10 (dont care) | 11 RESULTADO DA SOMA
	
				sig_reg_we_sel_mux_mp <= (others => '1'); -- write enable dos registradores do valor da selecao do MUX 
				sig_add_sub_mux_sel <= (others => '1'); --(dont care)-- somar ou subtrair o valor do registrador da selecao do MUX (1 para soma, 0 subtracao)
				sig_sel_mux_mp <= (others => '1'); --(don't care)-- selecao do mux para passagem do valor para o registrador 
								  -- 0 (i) |  1 (valor da soma )
				
				we_reg_mp0 <= '0'; 
				we_reg_mp1 <= '0';
				we_reg_mp2 <= '0';
				
				if ( sig_reg_mux_sel_out(NUM_ROWS-1) = std_logic_vector(to_unsigned(NUM_MEMORIES-3,WIDTH_SELMUX_MEMORIES))   ) then
					init_read_buffer <= '1';
				else
					init_read_buffer <= '0';
				end if;
				--init_read_buffer <= '0';
				
				if ( sig_reg_mux_sel_out(NUM_ROWS-1) = std_logic_vector(to_unsigned(NUM_MEMORIES-1,WIDTH_SELMUX_MEMORIES))   ) then
					next_state <= s0_start;
				else
					next_state <= s5_dec;
				end if;
				
			
				sel_mux_memportB <= sig_reg_mux_sel_out(NUM_COLS-1) + 1;
				sel_ativa_saida_addra_a <= '1';
				
			when s5_dec =>
			
				sig_reg_mem_addr_a_we <= '1'; -- write enable do registrador de endereco da memoria porta A 
				sig_add_sub_mem_addr_a <= '0'; -- somar ou subtrair o valor do registrador de endereco porta A (1 para soma, 0 subtracao)
				sig_sel_mux_mem_addr_a <= "11"; -- selecao do mux para passagem do valor para o registrador endereco porta A 
									   -- 00 ( 0 ) | 01 START_MEM_ADDR_INC | 10 START_MEM_ADDR_DEC | 11 RESULTADO DA SOMA
	
				sig_reg_mem_addr_b_we <= '1';-- write enable do registrador de endereco da memoria porta B
				sig_add_sub_mem_addr_b <= '1'; -- somar ou subtrair o valor do registrador de endereco porta B (1 para soma, 0 subtracao)
				sig_sel_mux_mem_addr_b <= "11";-- selecao do mux para passagem do valor para o registrador endereco porta B
									   -- 00 ( 0 ) | 01 (1) | 10 (dont care) | 11 RESULTADO DA SOMA
	
				sig_reg_we_sel_mux_mp <= (others => '0'); -- write enable dos registradores do valor da selecao do MUX 
				sig_add_sub_mux_sel <= (others => '-'); --(dont care)-- somar ou subtrair o valor do registrador da selecao do MUX (1 para soma, 0 subtracao)
				sig_sel_mux_mp <= (others => '-'); --(don't care)-- selecao do mux para passagem do valor para o registrador 
								  -- 0 (i) |  1 (valor da soma )


				we_reg_mp0 <= '1'; 
				we_reg_mp1 <= '0';
				we_reg_mp2 <= '0';
				
				
				init_read_buffer <= '0';		  
				sel_mux_memportB <= sig_reg_mux_sel_out(NUM_COLS-1) + 1;
				sel_ativa_saida_addra_a <= '1';
				
				next_state <= s6_read_mem_dec ;				
			
			
			when s6_read_mem_dec =>
			
				sig_reg_mem_addr_a_we <= '1'; -- write enable do registrador de endereco da memoria porta A 
				sig_add_sub_mem_addr_a <= '0'; -- somar ou subtrair o valor do registrador de endereco porta A (1 para soma, 0 subtracao)
				sig_sel_mux_mem_addr_a <= "11"; -- selecao do mux para passagem do valor para o registrador endereco porta A 
									   -- 00 ( 0 ) | 01 START_MEM_ADDR_INC | 10 START_MEM_ADDR_DEC | 11 RESULTADO DA SOMA
	
				sig_reg_mem_addr_b_we <= '1';-- write enable do registrador de endereco da memoria porta B
				sig_add_sub_mem_addr_b <= '1'; -- somar ou subtrair o valor do registrador de endereco porta B (1 para soma, 0 subtracao)
				sig_sel_mux_mem_addr_b <= "11";-- selecao do mux para passagem do valor para o registrador endereco porta B
									   -- 00 ( 0 ) | 01 (1) | 10 (dont care) | 11 RESULTADO DA SOMA
	
				sig_reg_we_sel_mux_mp <= (others => '0'); -- write enable dos registradores do valor da selecao do MUX 
				sig_add_sub_mux_sel <= (others => '-'); --(dont care)-- somar ou subtrair o valor do registrador da selecao do MUX (1 para soma, 0 subtracao)
				sig_sel_mux_mp <= (others => '-'); --(don't care)-- selecao do mux para passagem do valor para o registrador 
								  -- 0 (i) |  1 (valor da soma )

				we_reg_mp0 <= '0'; 
				we_reg_mp1 <= '1';
				we_reg_mp2 <= '0';

				init_read_buffer <= '0';		  
				sel_mux_memportB <= sig_reg_mux_sel_out(NUM_COLS-1) + 1;
				sel_ativa_saida_addra_a <= '1';
				
				next_state <= s7_read_mem_dec;			
			
			
			when s7_read_mem_dec =>
			
				sig_reg_mem_addr_a_we <= '1'; -- write enable do registrador de endereco da memoria porta A 
				sig_add_sub_mem_addr_a <= '0'; -- somar ou subtrair o valor do registrador de endereco porta A (1 para soma, 0 subtracao)
				sig_sel_mux_mem_addr_a <= "11"; -- selecao do mux para passagem do valor para o registrador endereco porta A 
									   -- 00 ( 0 ) | 01 START_MEM_ADDR_INC | 10 START_MEM_ADDR_DEC | 11 RESULTADO DA SOMA
	
				sig_reg_mem_addr_b_we <= '-';-- write enable do registrador de endereco da memoria porta B
				sig_add_sub_mem_addr_b <= '-'; -- somar ou subtrair o valor do registrador de endereco porta B (1 para soma, 0 subtracao)
				sig_sel_mux_mem_addr_b <= "--";-- selecao do mux para passagem do valor para o registrador endereco porta B
									   -- 00 ( 0 ) | 01 (1) | 10 (dont care) | 11 RESULTADO DA SOMA
	
				sig_reg_we_sel_mux_mp <= (others => '0'); -- write enable dos registradores do valor da selecao do MUX 
				sig_add_sub_mux_sel <= (others => '-'); --(dont care)-- somar ou subtrair o valor do registrador da selecao do MUX (1 para soma, 0 subtracao)
				sig_sel_mux_mp <= (others => '-'); --(don't care)-- selecao do mux para passagem do valor para o registrador 
								  -- 0 (i) |  1 (valor da soma )
				
				if (sig_reg_mem_addr_a_out = std_logic_vector(to_unsigned(END_MEM_ADDR_DEC, MEM_PORT_A_WIDTH)) ) then
					next_state <= s8_mux_sel;				
				else
					next_state <= s7_read_mem_dec;
				end if;
				
				
				we_reg_mp0 <= '0';
				we_reg_mp1 <= '0';

				if (sig_reg_mem_addr_a_out = std_logic_vector(to_unsigned(END_MEM_ADDR_DEC+5, MEM_PORT_A_WIDTH)) ) then
					we_reg_mp2 <= '1';
				else
					we_reg_mp2 <= '0';
				end if;
				
				init_read_buffer <= '0';		  
				sel_mux_memportB <= sig_reg_mux_sel_out(NUM_COLS-1) + 1;
				sel_ativa_saida_addra_a <= '1';
			
			when s8_mux_sel => -- passando para a proxima linha
			
				sig_reg_mem_addr_a_we <= '1'; -- write enable do registrador de endereco da memoria porta A 
				sig_add_sub_mem_addr_a <= '-'; -- somar ou subtrair o valor do registrador de endereco porta A (1 para soma, 0 subtracao)
				sig_sel_mux_mem_addr_a <= "01"; -- selecao do mux para passagem do valor para o registrador endereco porta A 
									   -- 00 ( 0 ) | 01 START_MEM_ADDR_INC | 10 START_MEM_ADDR_DEC | 11 RESULTADO DA SOMA
	
				sig_reg_mem_addr_b_we <= '1';-- write enable do registrador de endereco da memoria porta B
				sig_add_sub_mem_addr_b <= '-'; -- somar ou subtrair o valor do registrador de endereco porta B (1 para soma, 0 subtracao)
				sig_sel_mux_mem_addr_b <= "01";-- selecao do mux para passagem do valor para o registrador endereco porta B
									   -- 00 ( 0 ) | 01 (1) | 10 (dont care) | 11 RESULTADO DA SOMA
	
				sig_reg_we_sel_mux_mp <= (others => '1'); -- write enable dos registradores do valor da selecao do MUX 
				sig_add_sub_mux_sel <= (others => '1'); --(dont care)-- somar ou subtrair o valor do registrador da selecao do MUX (1 para soma, 0 subtracao)
				sig_sel_mux_mp <= (others => '1'); --(don't care)-- selecao do mux para passagem do valor para o registrador 
								  -- 0 (i) |  1 (valor da soma )
				
				we_reg_mp0 <= '0'; 
				we_reg_mp1 <= '0';
				we_reg_mp2 <= '0';
				
				if ( sig_reg_mux_sel_out(NUM_ROWS-1) = std_logic_vector(to_unsigned(NUM_MEMORIES-1,WIDTH_SELMUX_MEMORIES))   ) then
					next_state <= s0_start;
				else
					next_state <= s1_inc;
				end if;
				
				--if ( sig_reg_mux_sel_out(NUM_ROWS-1) = std_logic_vector(to_unsigned(NUM_MEMORIES-2,WIDTH_SELMUX_MEMORIES))   ) then
				--	init_read_buffer <= '1';
				--else
				--	init_read_buffer <= '0';
				--end if;
				init_read_buffer <= '0';		  
				
				sel_ativa_saida_addra_a <= '1';
				sel_mux_memportB <= sig_reg_mux_sel_out(NUM_COLS-1) + 1;
				
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
	
	----------------------------------------------
		mapRegMemAddr_A:regNbits
		generic map
		(
			N	=> MEM_PORT_A_WIDTHAD
		)
		port map
		(
			-- Input ports
			clk		=> clk,
			data_in	=> sig_reg_mem_addr_a_in,
			we		=> sig_reg_mem_addr_a_we,

			-- Output ports
			data_out=> sig_reg_mem_addr_a_out
		);

	sig_mem_port_a_widthad_1 <= std_logic_vector(to_unsigned(0,MEM_PORT_A_WIDTHAD-1)) & '1';
	
		mapAddSubMemAddr_A: unsigned_adder_subtractor
			generic map
			(
				DATA_WIDTH => MEM_PORT_A_WIDTHAD
			)
			port map
			(
				a		=> sig_reg_mem_addr_a_out,
				b		=> sig_mem_port_a_widthad_1,
				add_sub => sig_add_sub_mem_addr_a,
				result	=> sig_add_sub_mem_addr_a_out
			);
		
		sig_mem_port_a_widthad_0 <= (others => '0'); 		
		
		mapMuxMemAddr_A: mux4x1
		generic map
		(
			N	=> MEM_PORT_A_WIDTHAD
		)
		port map
		(
			-- Input ports
			sel		=> sig_sel_mux_mem_addr_a,
			data_a	=> sig_mem_port_a_widthad_0,
			data_b	=> std_logic_vector(to_unsigned(START_MEM_ADRR_INC, MEM_PORT_A_WIDTHAD)),
			data_c  => std_logic_vector(to_unsigned(START_MEM_ADRR_DEC, MEM_PORT_A_WIDTHAD)),
			data_d  => sig_add_sub_mem_addr_a_out,
			-- Output ports
			data_out => sig_reg_mem_addr_a_in
		);
	
	----------------------------------------------
	
	
	----------------------------------------------
				
		mapRegMemAddr_B:regNbits
		generic map
		(
			N	=> MEM_PORT_B_WIDTHAD
		)
		port map
		(
			-- Input ports
			clk		=> clk,
			data_in	=> sig_reg_mem_addr_b_in,
			we		=> sig_reg_mem_addr_b_we,

			-- Output ports
			data_out=> sig_reg_mem_addr_b_out
		);
		
		
		sig_mem_port_b_widthad_1 <= std_logic_vector(to_unsigned(0,MEM_PORT_B_WIDTHAD-1)) & '1';
		
		mapAddSubMemAddr_B: unsigned_adder_subtractor
			generic map
			(
				DATA_WIDTH => MEM_PORT_B_WIDTHAD
			)
			port map
			(
				a		=> sig_reg_mem_addr_b_out,
				b		=> sig_mem_port_b_widthad_1,
				add_sub => sig_add_sub_mem_addr_b,
				result	=> sig_add_sub_mem_addr_b_out
			);
	
		sig_mem_port_b_widthad_0 <= (others => '0');
		
		mapMuxMemAddr_B: mux4x1
		generic map
		(
			N	=> MEM_PORT_B_WIDTHAD
		)
		port map
		(
			-- Input ports
			sel		=> sig_sel_mux_mem_addr_b,
			data_a	=> sig_mem_port_b_widthad_0,
			data_b	=> sig_mem_port_b_widthad_1,
			data_c  => sig_mem_port_b_widthad_0, --dont't care
			data_d  => sig_add_sub_mem_addr_b_out,
			-- Output ports
			data_out => sig_reg_mem_addr_b_in
		);
	
	
	----------------------------------------------
	
	
	----------------------------------------------
	forMuxSel:
	FOR i IN 0 TO NUM_ROWS-1 GENERATE
											
		mapRegSelMux:regNbits
		generic map
		(
			N	=> WIDTH_SELMUX_MEMORIES
		)
		port map
		(
			-- Input ports
			clk		=> clk,
			data_in	=> sig_reg_mux_sel_in(i),
			we		=> sig_reg_we_sel_mux_mp(i),

			-- Output ports
			data_out=> sig_reg_mux_sel_out(i)
		);
		
		
		sig_width_sel_mux_memories_1 <= std_logic_vector(to_unsigned(0,WIDTH_SELMUX_MEMORIES-1)) & '1';
		
		mapAddSubMuxSel: unsigned_adder_subtractor
		generic map
		(
			DATA_WIDTH => WIDTH_SELMUX_MEMORIES
		)
		port map
		(
			a		=> sig_reg_mux_sel_out(i),
			b		=> sig_width_sel_mux_memories_1,
			add_sub => sig_add_sub_mux_sel(i),
			result	=> sig_add_sub_mux_sel_out(i)
		);

	
		mapMuxMuxSel: mux2x1
		generic map
		(
			N	=> WIDTH_SELMUX_MEMORIES
		)
		port map
		(
			-- Input ports
			sel		=> sig_sel_mux_mp(i),
			data_a	=> std_logic_vector(to_unsigned(i, WIDTH_SELMUX_MEMORIES)),
			data_b	=> sig_add_sub_mux_sel_out(i),
			-- Output ports
			data_out => sig_reg_mux_sel_in(i)
		);
		
	END GENERATE;
	----------------------------------------------
	mux_ativa_saida_addr_a:
	with sel_ativa_saida_addra_a select
		saida_mux_addr_a <= 
					sig_mem_port_a_widthad_15 when '0',
					sig_reg_mem_addr_a_out when '1',
					sig_mem_port_a_widthad_0 when others;
				
	
										
end behaviour;