------------------------------------------------------------------------------
-- PROJETO: Estimação de Movimento
-- ENTIDADE : n_memories
------------------------------------------------------------------------------
-- DESCRIÇÃO: Instanciação das N memórias (32 inicialmente) que compoem 
-- a memoria local.
------------------------------------------------------------------------------
library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.all;
use work.motion_estimation_8x8_package.all;

entity n_memories is
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
end n_memories;

architecture behaviour of n_memories is

		COMPONENT memoria IS
			PORT
			(
				address_a		: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
				address_b		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
				clock		: IN STD_LOGIC ;
				data_a		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
				data_b		: IN STD_LOGIC_VECTOR (63 DOWNTO 0);
				wren_a		: IN STD_LOGIC  := '1';
				wren_b		: IN STD_LOGIC  := '1';
				q_a		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
				q_b		: OUT STD_LOGIC_VECTOR (63 DOWNTO 0)
			);
		END COMPONENT;

		
		signal i: integer range 0 to NUM_MEMORIES-1;
		signal sig_data_a_0: STD_LOGIC_VECTOR (7 DOWNTO 0);
		signal rea, reb: std_logic_vector(NUM_MEMORIES-1 DOWNTO 0);
		signal wea: std_logic;
begin
	
	rea  <= rden_a;
	reb  <= rden_b;
	wea <= '0';
	sig_data_a_0 <= (others => '0');
	
	for_memory: 
	for i in 0 to NUM_MEMORIES-1 generate
		memorie_generate: memoria
		PORT MAP
		(
			address_a => addrs_a(i),
			address_b => addrs_b(i),
			clock	  => clk,
			data_a	  => sig_data_a_0,
			data_b	  => datas_b(i),
			wren_a	  => wea,
			wren_b	  => wrens_b(i),
			q_a		  => qs_a(i),
			q_b		  => qs_b(i)
		);
	end generate;
	
end behaviour;
