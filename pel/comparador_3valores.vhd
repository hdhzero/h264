------------------------------------------------------------------------------
-- PROJETO: Estimação de Movimento
-- ENTIDADE : comparador_3valores
------------------------------------------------------------------------------
-- DESCRIÇÃO: Verifica qual dos 3 valores de SAD de saída dos módulos de
-- processamento é o maior e identifica o vetor de movimento do melhor valor.
------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity comparador_3valores is
generic(
	COMPARE_VALUES_SIZE: integer := 14;
	VECTOR_SIZE: integer := 10
);
port(
	
	clk: in std_logic;
	rst: in std_logic;
	
	sad_result1: in std_logic_vector(COMPARE_VALUES_SIZE-1 DOWNTO 0);
	sad_result2: in std_logic_vector(COMPARE_VALUES_SIZE-1 DOWNTO 0);
	sad_result3: in std_logic_vector(COMPARE_VALUES_SIZE-1 DOWNTO 0);
		
	vector1: in std_logic_vector(VECTOR_SIZE-1 DOWNTO 0); -- VECTOR_SIZE/2  bits para a posicao x e VECTOR_SIZE/2 bits para y
	vector2: in std_logic_vector(VECTOR_SIZE-1 DOWNTO 0);
	vector3: in std_logic_vector(VECTOR_SIZE-1 DOWNTO 0);
	
	best_sad: out std_logic_vector(COMPARE_VALUES_SIZE-1 DOWNTO 0);
	
	motion_vector: out std_logic_vector(VECTOR_SIZE-1 DOWNTO 0)
	
);
end entity;

architecture behaviour of comparador_3valores is

	component regNbits_rst is
	generic
	(
		N	: integer  :=	32;
		RST_VALUE: std_logic :=  '1'
	);
	
	port
	(
		-- Input ports
		clk		: in std_logic;
		rst		: in std_logic;
		data_in		: in  std_logic_vector(N-1 DOWNTO 0);
		we			: in  std_logic;

		-- Output ports
		data_out	: out std_logic_vector(N-1 DOWNTO 0)
	);
	end component;

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

	component comp is
	GENERIC (N: integer := 14);
	PORT
	(
		dataa		: IN STD_LOGIC_VECTOR (N-1 DOWNTO 0);
		datab		: IN STD_LOGIC_VECTOR (N-1 DOWNTO 0);
		AgB		: OUT STD_LOGIC 
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


	TYPE STATE_TYPE is (start, s0, s1, s2);--, s2, s3);
	--TYPE STATE_TYPE is (start, s0, s1, s2);
	
	SIGNAL sel_mux_comp1, sel_mux_comp2, sel_mux_final_comp, rst_best_sad, reg_best_sad_we, reg_sad_result3_we, reg_comp1_we, reg_comp2_we: std_logic;
	SIGNAL actual_best_sad, reg_best_sad_in, reg_best_sad_out, reg_comp1_in, reg_comp1_out, reg_comp2_in, reg_comp2_out, reg_sad_result3_in, reg_sad_result3_out: std_logic_vector(COMPARE_VALUES_SIZE-1 DOWNTO 0);
	SIGNAL reg_sad1_in, reg_sad1_out, reg_sad2_in, reg_sad2_out, reg_sad3_in, reg_sad3_out: std_logic_vector(COMPARE_VALUES_SIZE-1 DOWNTO 0);
	SIGNAL reg_sad1_we, reg_sad2_we, reg_sad3_we: std_logic;
	SIGNAL reg_best_vec_we, reg_vec3_we, reg_vec2_we, reg_vec1_we, reg_vec3_comp2_we, reg_vec3_pipe_we, reg_comp1_vec_we, reg_comp2_vec_we: std_logic;
	SIGNAL reg_best_vec_out, actual_best_vec, reg_vec3_out, reg_vec2_out, reg_vec1_out, reg_vec3_comp2_out, reg_vec3_pipe_out, reg_comp1_vec_in, reg_comp1_vec_out, reg_comp2_vec_in, reg_comp2_vec_out: std_logic_vector(VECTOR_SIZE-1 DOWNTO 0);
	SIGNAL state, next_state: STATE_TYPE;

begin

	best_sad <= reg_best_sad_out;
	motion_vector <= reg_best_vec_out;
	
	
	reg_sad1: regNbits
	generic map( N	=> COMPARE_VALUES_SIZE )
	port map
	(
		clk			=> clk, 
		data_in		=> sad_result1,
		we			=> reg_sad1_we,

		-- Output ports
		data_out 	=> reg_sad1_out
	);
	
	
	reg_vec1: regNbits
	generic map( N	=> VECTOR_SIZE )
	port map
	(
		clk			=> clk, 
		data_in		=> vector1,
		we			=> reg_vec1_we,

		-- Output ports
		data_out 	=> reg_vec1_out
	);
	
	reg_sad2: regNbits
	generic map( N	=> COMPARE_VALUES_SIZE )
	port map
	(
		clk			=> clk, 
		data_in		=> sad_result2,
		we			=> reg_sad2_we,

		-- Output ports
		data_out 	=> reg_sad2_out
	);
	
	
	reg_vec2: regNbits
	generic map( N	=> VECTOR_SIZE )
	port map
	(
		clk			=> clk, 
		data_in		=> vector2,
		we			=> reg_vec2_we,

		-- Output ports
		data_out 	=> reg_vec2_out
	);
	
	reg_sad3: regNbits
	generic map( N	=> COMPARE_VALUES_SIZE )
	port map
	(
		clk			=> clk, 
		data_in		=> sad_result3,
		we			=> reg_sad3_we,

		-- Output ports
		data_out 	=> reg_sad3_out
	);
	
	reg_vec3: regNbits
	generic map( N	=> VECTOR_SIZE )
	port map
	(
		clk			=> clk, 
		data_in		=> vector3,
		we			=> reg_vec3_we,

		-- Output ports
		data_out 	=> reg_vec3_out
	);
	
	map_reg_best_sad: regNbits_rst
	generic map( N	=> COMPARE_VALUES_SIZE, RST_VALUE => '1' )
	port map
	(
		clk			=> clk, 
		rst			=> rst_best_sad,
		data_in		=> actual_best_sad,
		we			=> reg_best_sad_we,

		-- Output ports
		data_out 	=> reg_best_sad_out
	);
	
	map_reg_best_vec: regNbits
	generic map( N	=> VECTOR_SIZE )
	port map
	(
		clk			=> clk, 
		data_in		=> actual_best_vec,
		we			=> reg_best_vec_we,

		-- Output ports
		data_out 	=> reg_best_vec_out
	);

	
	map_reg_comp1: regNbits
	generic map( N	=> COMPARE_VALUES_SIZE )
	port map
	(
		clk			=> clk, 
		data_in		=> reg_comp1_in,
		we			=> reg_comp1_we,

		-- Output ports
		data_out 	=> reg_comp1_out
	);

	map_vec_comp1: regNbits
	generic map( N	=> VECTOR_SIZE )
	port map
	(
		clk			=> clk, 
		data_in		=> reg_comp1_vec_in,
		we			=> reg_comp1_vec_we,

		-- Output ports
		data_out 	=> reg_comp1_vec_out
	);
	
	
	map_reg_comp2: regNbits
	generic map( N	=> COMPARE_VALUES_SIZE )
	port map
	(
		clk			=> clk, 
		data_in		=> reg_comp2_in,
		we			=> reg_comp2_we,

		-- Output ports
		data_out 	=> reg_comp2_out
	);
	
	
	map_vec_comp2: regNbits
	generic map( N	=> VECTOR_SIZE )
	port map
	(
		clk			=> clk, 
		data_in		=> reg_comp2_vec_in,
		we			=> reg_comp2_vec_we,

		-- Output ports
		data_out 	=> reg_comp2_vec_out
	);
	
	map_reg_sad_result3: regNbits
	generic map( N	=> COMPARE_VALUES_SIZE )
	port map
	(
		clk			=> clk, 
		data_in		=> reg_sad3_out,
		we			=> reg_sad_result3_we,

		-- Output ports
		data_out 	=> reg_sad_result3_out
	);
	
	map_reg_vec3_pipe: regNbits
	generic map( N	=> VECTOR_SIZE )
	port map
	(
		clk			=> clk, 
		data_in		=> reg_vec3_out,
		we			=> reg_vec3_pipe_we,

		-- Output ports
		data_out 	=> reg_vec3_pipe_out
	);
	
	comp1: comp
	PORT MAP
	(
		dataa		=> reg_sad1_out,
		datab		=> reg_sad2_out,
		AgB			=> sel_mux_comp1
	);

	comp2: comp
	PORT MAP
	(
		dataa		=> reg_sad_result3_out,
		datab		=> reg_comp1_out,
		AgB			=> sel_mux_comp2
	);
	
	final_comp: comp
	PORT MAP
	(
		dataa		=> reg_comp2_out,
		datab		=> reg_best_sad_out,
		AgB			=> sel_mux_final_comp
	);
	
	
	mux2x1_comp1: mux2x1
	generic map( N	=> COMPARE_VALUES_SIZE )
	port map
	(
		-- Input ports
		sel		=> sel_mux_comp1,
		data_a	=> reg_sad1_out,
		data_b	=> reg_sad2_out,
		-- Output ports
		data_out => reg_comp1_in
	);
	
	
	mux2x1_vec_comp1: mux2x1
	generic map( N	=> VECTOR_SIZE )
	port map
	(
		-- Input ports
		sel		=> sel_mux_comp1,
		data_a	=> reg_vec1_out,
		data_b	=> reg_vec2_out,
		-- Output ports
		data_out => reg_comp1_vec_in
	);
	
	mux2x1_comp2: mux2x1
	generic map( N	=> COMPARE_VALUES_SIZE )
	port map
	(
		-- Input ports
		sel		=> sel_mux_comp2,
		data_a	=> reg_sad_result3_out,
		data_b	=> reg_comp1_out,
		-- Output ports
		data_out => reg_comp2_in
	);
	
	mux2x1_vec_comp2: mux2x1
	generic map( N	=> VECTOR_SIZE )
	port map
	(
		-- Input ports
		sel		=> sel_mux_comp2,
		data_a	=> reg_vec3_pipe_out,
		data_b	=> reg_comp1_vec_out,
		-- Output ports
		data_out => reg_comp2_vec_in
	);
	
	mux2x1_final_comp: mux2x1
	generic map( N	=> COMPARE_VALUES_SIZE )
	port map
	(
		-- Input ports
		sel		=> sel_mux_final_comp,
		data_a	=> reg_comp2_out,
		data_b	=> reg_best_sad_out,
		-- Output ports
		data_out => actual_best_sad
	);
	
	mux2x1_vec_final_comp: mux2x1
	generic map( N	=> VECTOR_SIZE )
	port map
	(
		-- Input ports
		sel		=> sel_mux_final_comp,
		data_a	=> reg_comp2_vec_out,
		data_b	=> reg_best_vec_out,
		-- Output ports
		data_out => actual_best_vec
	);
	
	update_state:process (clk, rst)
	begin
		if (rst = '1') then
			state <= start;
		elsif (clk'event and clk='1') then
			state <= next_state;
		end if;
	end process;

	state_machine: process (state, rst)
	begin
		case (state) is
		
			when start => -- grava os valores de entrada nos registradores.
				
				reg_vec1_we <= '1';
				reg_vec2_we <= '1';
				reg_vec3_we <= '1';
				reg_vec3_pipe_we <= '0';
				reg_comp1_vec_we <= '0';
				reg_comp2_vec_we <= '0';
				reg_best_vec_we <= '0';
				
				reg_sad1_we <= '1';
				reg_sad2_we <= '1';
				reg_sad3_we <= '1';
				reg_best_sad_we <= '1'; 
				reg_sad_result3_we <= '0'; 
				reg_comp1_we <= '0'; 
				reg_comp2_we <= '0';
			
				rst_best_sad <= '1';
			
				next_state <= s0;
					
			when s0 => -- 1a comparação. os valores são comparados e é passado pelo mux o resultado da comparacao, gravando o resultado no reg.
				
				reg_vec1_we <= '1';
				reg_vec2_we <= '1';
				reg_vec3_we <= '1';
				reg_vec3_pipe_we <= '1';
				reg_comp1_vec_we <= '1';
				reg_comp2_vec_we <= '0';
				reg_best_vec_we <= '0';
				
				reg_sad1_we <= '1';
				reg_sad2_we <= '1';
				reg_sad3_we <= '1';
				reg_best_sad_we <= '0'; 
				reg_sad_result3_we <= '1'; -- gravando no registrador o valor a ser comparado
				reg_comp1_we <= '1'; -- gravando no registrador o valor a ser comparado
				reg_comp2_we <= '0';
		
				rst_best_sad <= '1';
		
				next_state <= s1;
				
			when s1 => -- é feita a 2a comparação.
				
				reg_vec1_we <= '1';
				reg_vec2_we <= '1';
				reg_vec3_we <= '1';
				reg_vec3_pipe_we <= '1';
				reg_comp1_vec_we <= '1';
				reg_comp2_vec_we <= '1';
				reg_best_vec_we <= '0';
				
				reg_sad1_we <= '1';
				reg_sad2_we <= '1';
				reg_sad3_we <= '1';
				reg_best_sad_we <= '0'; 
				reg_sad_result3_we <= '1'; 
				reg_comp1_we <= '1'; 
				reg_comp2_we <= '1'; --gravando resultado da 2a comparação
				
				rst_best_sad <= '1';
		
				next_state <= s2;
				
			when s2 => --  3a comparação, passagem pelo mux e gravação no registrador	
				
				
				reg_vec1_we <= '1';
				reg_vec2_we <= '1';
				reg_vec3_we <= '1';
				reg_vec3_pipe_we <= '1';
				reg_comp1_vec_we <= '1';
				reg_comp2_vec_we <= '1';
				reg_best_vec_we <= '1';
				
				reg_sad1_we <= '1';
				reg_sad2_we <= '1';
				reg_sad3_we <= '1';
				reg_best_sad_we <= '1'; 
				reg_sad_result3_we <= '1'; 
				reg_comp1_we <= '1'; 
				reg_comp2_we <= '1';
				
				rst_best_sad <= '0';
		
				if (rst = '1') then
					next_state <= start;
				else
					next_state <= s2;
				end if;
				
--			when s3 => --  3a comparação, passagem pelo mux e gravação no registrador	
--				
--				reg_vec1_we <= '1';
--				reg_vec2_we <= '1';
--				reg_vec3_we <= '1';
--				reg_vec3_pipe_we <= '1';
--				reg_comp1_vec_we <= '1';
--				reg_comp2_vec_we <= '1';
--				reg_best_vec_we <= '1';
--				
--				reg_sad1_we <= '1';
--				reg_sad2_we <= '1';
--				reg_sad3_we <= '1';
--				reg_best_sad_we <= '1'; 
--				reg_sad_result3_we <= '1'; 
--				reg_comp1_we <= '1'; 
--				reg_comp2_we <= '1';
--
--				next_state <= s3;
--				
		end case;

	end process;

end behaviour;
