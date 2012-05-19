------------------------------------------------------------------------------
-- PROJETO: Estimação de Movimento
-- ENTIDADE : sad_manager
------------------------------------------------------------------------------
-- DESCRIÇÃO: Controle do modulo de SAD
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.all;
use work.motion_estimation_8x8_package.all;

entity sad_manager is
port(
	rst: in std_logic;
	clk: in std_logic;
	start: in std_logic;
	we_levels: out std_logic_vector(LEVELS-1 DOWNTO 0)
);
end entity;

architecture behaviour of sad_manager is

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
	
	TYPE STATE_TYPE is (s0_start, s1_init_sads);--, s2_count_matches);
	
	SIGNAL state, next_state: STATE_TYPE;
	
begin
	
	state_machine: process(state, start)
	begin
	
	case (state) is
				
		when  s0_start =>
		
			we_levels <= (others => '0');
--			sig_count <= LEVELS-1; -- A quantidade de ciclos que leva para o valor está pronto é igual a profundidade do pipeline.
--			sig_count_matches <= 0;
			
			if (start = '1') then
				next_state <= s1_init_sads;
			else 
				next_state <= s0_start;
			end if;
			
		when s1_init_sads =>		-- tempo para o primeiro resultado estar pronto! Contando a quantidade de ciclos que leva para o primeiro resultado 
									-- ser devolvido. Assim que o primeiro resultado esta pronto, entao inicia a contagem da quantidade de casamentos
	
			--sig_count_matches <= 0;
			we_levels <= (others => '1');
			
--			if (count /= 0) then
--				sig_count <= count-1;
				next_state <= s1_init_sads;
--			else
--				sig_count <= count;
--				next_state <= s2_count_matches;
--			end if;
		
--		when s2_count_matches =>	-- mantem a maquina funcionando enquanto não se completa a quantidade certa de casamentos	
			
--			if (count_matches /= NUM_MATCHES-1) then
			
--				we_levels <= (others => '1');
--				sig_count <= count;
--				sig_count_matches <= count_matches + 1;
--		
--				next_state <= s2_count_matches;
		
--			else
					
--				we_levels <= (others => '1');
--				sig_count <= count;
--				sig_count_matches <= count_matches + 1;
		
--				next_state <= s0_start;
				
--			end if;
			
	end case;
	end process;


	update_state: process(clk, rst)
	begin
		if (rst = '1') then
			state <= s0_start;
		
--			count <= 0;
--			count_matches <= 0;
			
		elsif (clk'event and clk = '1') then
			state <= next_state;
			
	--		count <= sig_count;
	--	count_matches <= sig_count_matches;
		end if;
	end process;
										
end behaviour;