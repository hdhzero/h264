------------------------------------------------------------------------------
-- PROJETO: Estimação de Movimento
-- ENTIDADE : sad_N
------------------------------------------------------------------------------
-- DESCRIÇÃO: Componente que implementa o modulo de SAD completo, a soma
-- das diferencas absolutas. Utiliza valores genericos e pode ser criado
-- de qualquer tamanho. 
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.all;
use work.motion_estimation_8x8_package.all;

entity sad_N is
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
end entity;


architecture behaviour of sad_N is
	
	component sad_1 is
	generic( N: integer:= 8 );
	port
	(
		clk: in std_logic;
		blk: in std_logic_vector(N-1 DOWNTO 0);
		ref: in std_logic_vector(N-1 DOWNTO 0);
		we: in std_logic;
		
		result: out std_logic_vector(N-1 DOWNTO 0)
		
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
	
	SIGNAL se: INTEGER RANGE 0 TO ENTRIES-1;
	SIGNAL i: INTEGER RANGE 0 TO NUM_ROWS-1;
	SIGNAL j: INTEGER RANGE 0 TO NUM_COLS-1;
	SIGNAL l7: INTEGER RANGE 0 TO 31;
	SIGNAL l6: INTEGER RANGE 0 TO 15;
	SIGNAL l5: INTEGER RANGE 0 TO 7;
	SIGNAL l4: INTEGER RANGE 0 TO 3;
	SIGNAL l3: INTEGER RANGE 0 TO 2;
	
	--MAX 7 levels
	--TYPE sad_results_level_1  std_logic_vector(DATA_WIDTH-1 + LEVELS DOWNTO 0);
	
	TYPE type_sad_results_level_2 IS ARRAY (1 DOWNTO 0)  OF std_logic_vector(DATA_WIDTH-1 + LEVELS-2 DOWNTO 0);
	TYPE type_sad_results_level_3 IS ARRAY (3 DOWNTO 0)  OF std_logic_vector(DATA_WIDTH-1 + LEVELS-3 DOWNTO 0);
	TYPE type_sad_results_level_4 IS ARRAY (7 DOWNTO 0)  OF std_logic_vector(DATA_WIDTH-1 + LEVELS-4 DOWNTO 0);
	TYPE type_sad_results_level_5 IS ARRAY (15 DOWNTO 0) OF std_logic_vector(DATA_WIDTH-1 + LEVELS-5 DOWNTO 0);
	TYPE type_sad_results_level_6 IS ARRAY (31 DOWNTO 0) OF std_logic_vector(DATA_WIDTH-1 + LEVELS-6 DOWNTO 0);
	TYPE type_sad_results_level_7 IS ARRAY (63 DOWNTO 0) OF std_logic_vector(DATA_WIDTH-1 + LEVELS-7 DOWNTO 0);
	
	--TYPE type_sig_level_7 IS ARRAY (31 DOWNTO 0) OF std_logic_vector(DATA_WIDTH-1 + LEVELS - 6 DOWNTO 0);
	
	SIGNAL out_sub_abs, out_sub_abs_reg: SAD_ENTRIES;
	
	SIGNAL sad_results_level_1, sad_results_level_1_reg: std_logic_vector(DATA_WIDTH-1 + LEVELS-1 DOWNTO 0);
	SIGNAL sad_results_level_2, sad_results_level_2_reg: type_sad_results_level_2;
	SIGNAL sad_results_level_3, sad_results_level_3_reg: type_sad_results_level_3;
	SIGNAL sad_results_level_4, sad_results_level_4_reg: type_sad_results_level_4;
	SIGNAL sad_results_level_5, sad_results_level_5_reg: type_sad_results_level_5;
	SIGNAL sad_results_level_6, sad_results_level_6_reg: type_sad_results_level_6;
	SIGNAL sad_results_level_7, sad_results_level_7_reg: type_sad_results_level_7;
	
	
	SIGNAL sig_level_7_a, sig_level_7_b: type_sad_results_level_6;
	SIGNAL sig_level_6_a, sig_level_6_b: type_sad_results_level_5;
	SIGNAL sig_level_5_a, sig_level_5_b: type_sad_results_level_4;
	SIGNAL sig_level_4_a, sig_level_4_b: type_sad_results_level_3;
	SIGNAL sig_level_3_a, sig_level_3_b: type_sad_results_level_2;
	SIGNAL sig_level_2_a, sig_level_2_b: std_logic_vector(DATA_WIDTH-1 + LEVELS-1 DOWNTO 0);
begin

	map_SAD1_Rows:
		
		FOR se IN 0 TO ENTRIES-1 GENERATE
			multiples_sads : sad_1
			generic map ( N => DATA_WIDTH )
			port map 
			(
				clk => clk,
				blk => blk(se),
				ref => ref(se),
				we => we_levels(LEVELS-1),
				result => out_sub_abs( se )
			);
			
			if_map_level_7:
			IF (LEVELS = 7) GENERATE
				sad_results_level_7_reg(se) <=  out_sub_abs(se);
			END GENERATE;
			
			
			if_map_level_6:
			IF (LEVELS = 6) GENERATE
				sad_results_level_6_reg(se) <=  out_sub_abs(se);
	
			END GENERATE;
			
			if_map_level_5:
			IF (LEVELS = 5) GENERATE
				sad_results_level_5_reg(se) <=  out_sub_abs(se);
			END GENERATE;
			
			if_map_level_4:
			IF (LEVELS = 4) GENERATE
				sad_results_level_4_reg(se) <=  out_sub_abs(se);
			END GENERATE;
			
			if_map_level_3:
			IF (LEVELS = 3) GENERATE
				sad_results_level_3_reg(se) <=  out_sub_abs(se);
			END GENERATE;
			
			
			if_map_level_2:
			IF (LEVELS = 2) GENERATE
				sad_results_level_2_reg(se) <=  out_sub_abs(se);
			END GENERATE;
			
		END GENERATE;



	if_level_7:
	IF (LEVELS >= 7) GENERATE
		for_level_7:
		FOR l7 IN 0 TO 31 GENERATE
	
			sig_level_7_a(l7) <= '0' & sad_results_level_7_reg(l7);
			sig_level_7_b(l7) <= '0' & sad_results_level_7_reg(ENTRIES-l7-1);
	
			map_add: unsigned_adder_subtractor
			generic map
			(
				--pensar em como lidar com esta situacao
				DATA_WIDTH => DATA_WIDTH + LEVELS - 6
			)
			port map
			(
				a		=> sig_level_7_a(l7),
				b		=> sig_level_7_b(l7),
				add_sub => '1',
				result	=> sad_results_level_6(l7)
			);
			
			map_regN: regNbits
			generic map
			(
				N	=> DATA_WIDTH + LEVELS - 6
			)
			port map
			(
				-- Input ports
				clk			=> clk,
				data_in		=> sad_results_level_6(l7),
				we			=> we_levels(5),

				-- Output ports
				data_out	=> sad_results_level_6_reg(l7)
			);
		END GENERATE;
	END GENERATE;
	
	
	if_level_6:
	IF (LEVELS >= 6) GENERATE
		for_level_6:
		FOR l6 IN 0 TO 15 GENERATE
	
			sig_level_6_a(l6) <= '0' & sad_results_level_6_reg(l6);
			sig_level_6_b(l6) <= '0' & sad_results_level_6_reg(32-l6-1);
	
			map_add: unsigned_adder_subtractor
			generic map
			(
				--pensar em como lidar com esta situacao
				DATA_WIDTH => DATA_WIDTH + LEVELS - 5
			)
			port map
			(
				a		=> sig_level_6_a(l6),
				b		=> sig_level_6_b(l6),
				add_sub => '1',
				result	=> sad_results_level_5(l6)
			);
			
			map_regN: regNbits
			generic map
			(
				N	=> DATA_WIDTH + LEVELS - 5
			)
			port map
			(
				-- Input ports
				clk			=> clk,
				data_in		=> sad_results_level_5(l6),
				we			=> we_levels(4),

				-- Output ports
				data_out	=> sad_results_level_5_reg(l6)
			);
			
		END GENERATE;
	END GENERATE;
	
	
	if_level_5:
	IF (LEVELS >= 5) GENERATE
		for_level_5:
		FOR l5 IN 0 TO 7 GENERATE
	
			sig_level_5_a(l5) <= '0' & sad_results_level_5_reg(l5);
			sig_level_5_b(l5) <= '0' & sad_results_level_5_reg(16-l5-1);
	
			map_add: unsigned_adder_subtractor
			generic map
			(
				--pensar em como lidar com esta situacao
				DATA_WIDTH => DATA_WIDTH + LEVELS - 4
			)
			port map
			(
				a		=> sig_level_5_a(l5),
				b		=> sig_level_5_b(l5),
				add_sub => '1',
				result	=> sad_results_level_4(l5)
			);
			
			map_regN: regNbits
			generic map
			(
				N	=> DATA_WIDTH + LEVELS - 4
			)
			port map
			(
				-- Input ports
				clk			=> clk,
				data_in		=> sad_results_level_4(l5),
				we			=> we_levels(3),

				-- Output ports
				data_out	=> sad_results_level_4_reg(l5)
			);
			
			
		END GENERATE;
	END GENERATE;

	
	if_level_4:
	IF (LEVELS >= 4) GENERATE
		for_level_4:
		FOR l4 IN 0 TO 3 GENERATE
	
			sig_level_4_a(l4) <= '0' & sad_results_level_4_reg(l4);
			sig_level_4_b(l4) <= '0' & sad_results_level_4_reg(8-l4-1);
	
	
			map_add: unsigned_adder_subtractor
			generic map
			(
				--pensar em como lidar com esta situacao
				DATA_WIDTH => DATA_WIDTH + LEVELS - 3
			)
			port map
			(
				a		=> sig_level_4_a(l4),
				b		=> sig_level_4_b(l4),
				add_sub => '1',
				result	=> sad_results_level_3(l4)
			);
			
			map_regN: regNbits
			generic map
			(
				N	=> DATA_WIDTH + LEVELS - 3
			)
			port map
			(
				-- Input ports
				clk			=> clk,
				data_in		=> sad_results_level_3(l4),
				we			=> we_levels(2),

				-- Output ports
				data_out	=> sad_results_level_3_reg(l4)
			);
			
		END GENERATE;
	END GENERATE;

	
	if_level_3:
	IF (LEVELS >= 3) GENERATE
		for_level_3:
		FOR l3 IN 0 TO 1 GENERATE
			
			sig_level_3_a(l3) <= '0' & sad_results_level_3_reg(l3);
			sig_level_3_b(l3) <= '0' & sad_results_level_3_reg(4-l3-1);
	
	
			map_add: unsigned_adder_subtractor
			generic map
			(
				--pensar em como lidar com esta situacao
				DATA_WIDTH => DATA_WIDTH + LEVELS - 2
			)
			port map
			(
				a		=> sig_level_3_a(l3),
				b		=> sig_level_3_b(l3),
				add_sub => '1',
				result	=> sad_results_level_2(l3)
			);
			
			map_regN: regNbits
			generic map
			(
				N	=> DATA_WIDTH + LEVELS - 2
			)
			port map
			(
				-- Input ports
				clk			=> clk,
				data_in		=> sad_results_level_2(l3),
				we			=> we_levels(1),

				-- Output ports
				data_out	=> sad_results_level_2_reg(l3)
			);
			
		END GENERATE;
	END GENERATE;

	
	if_level_2:
	IF (LEVELS >= 2) GENERATE


			sig_level_2_a <= '0' & sad_results_level_2_reg(0);
			sig_level_2_b <= '0' & sad_results_level_2_reg(1);
	
			map_add: unsigned_adder_subtractor
			generic map
			(
				--pensar em como lidar com esta situacao
				DATA_WIDTH => DATA_WIDTH + LEVELS - 1
			)
			port map
			(
				a		=> sig_level_2_a,
				b		=> sig_level_2_b,
				add_sub => '1',
				result	=> sad_results_level_1
			);
			
			map_regN: regNbits
			generic map
			(
				N	=> DATA_WIDTH + LEVELS - 1
			)
			port map
			(
				-- Input ports
				clk			=> clk,
				data_in		=> sad_results_level_1,
				we			=> we_levels(0),

				-- Output ports
				data_out	=> sad_results_level_1_reg
			);
			
		END GENERATE;
			
	result <= sad_results_level_1_reg;

end behaviour;
