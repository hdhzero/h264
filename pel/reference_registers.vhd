------------------------------------------------------------------------------
-- PROJETO: Estimação de Movimento
-- ENTIDADE : reference_registers
------------------------------------------------------------------------------
-- DESCRIÇÃO: Banco de registradores de referencia que realiza os deslocamentos
-- de dados para as 4 direções.
------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.all;
use work.motion_estimation_8x8_package.all;

entity reference_registers is
	generic ( N: integer := 8 );
	port
	(
		clk: in std_logic;	
		sel_muxes: in std_logic_vector(1 DOWNTO 0);
		we_refs: in WE_REG_ROWS;
		words: in REG_COLS;
		ref: out REG_ROWS
	);
end reference_registers;

architecture behaviour of  reference_registers is

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

	SIGNAL i: INTEGER RANGE 0 TO NUM_ROWS-1;
	SIGNAL j: INTEGER RANGE 0 TO NUM_COLS-1;
	SIGNAL sig_others : std_logic_vector(DATA_WIDTH-1 DOWNTO 0);
	signal ref_registers_data_in, ref_registers_data_out: REG_ROWS;
begin

		sig_others <= (others =>'0');
	
		ref <= ref_registers_data_out;

		Colomn_Ref:
		  FOR i IN 0 TO NUM_ROWS-1 GENERATE
			Row_Ref:
			FOR j IN 0 TO NUM_COLS-1 GENERATE
			
				register_ref: regNbits
				generic map ( N => DATA_WIDTH )
				port map(
					clk			=> clk, 
					data_in		=> ref_registers_data_in(i)(j),
					we			=> we_refs(i)(j),
					data_out	=> ref_registers_data_out(i)(j)
				);
			
			END GENERATE;

		END GENERATE;
		
		
		-- Port map do mux para a ultima linha da matriz de registradores
			Row_NUM_ROWS_less_1:
			FOR j IN 0 TO NUM_COLS-1 GENERATE
				if_NUM_ROWS_less_1_different_0:
				if (j > 0 AND j < NUM_COLS-1) GENERATE
					mux_ref_num_rows_less_1: mux4x1
					generic map (N => DATA_WIDTH)
					port map 
					(
						-- Input ports
						sel		=> sel_muxes,
						data_a	=> sig_others, 						--UP
						data_b	=> words(j),								--DOWN
						data_c	=> ref_registers_data_out(NUM_ROWS-1)(j-1),	--LEFT
						data_d  => ref_registers_data_out(NUM_ROWS-1)(j+1),	--RIGHT
						-- Output ports
						data_out => ref_registers_data_in(NUM_ROWS-1)(j)
					);
				END GENERATE;
			END GENERATE;
			
		-- Port map do mux para a primeira coluna da matriz de registradores registradores(i)(0)
		Map_COLS_0:
			FOR i IN 0 TO NUM_ROWS-1 GENERATE
				ifgenerate_Cols_0:
				IF (i /= NUM_ROWS-1) GENERATE
					mux_ref_cols_0: mux4x1
					generic map (N => DATA_WIDTH)
					port map 
					(
						-- Input ports
						sel		=> sel_muxes,	
						data_a	=> sig_others, 				--UP
						data_b	=> ref_registers_data_out(i+1)(0),	--DOWN
						data_c	=> words(i),						--LEFT
						data_d  => ref_registers_data_out(i)(1),	--RIGHT
						-- Output ports
						data_out => ref_registers_data_in(i)(0)
					);
				END GENERATE;
			END GENERATE;
			
		-- Port map do mux para a ultima coluna da matriz de registradores (i)(NUM_COLS-1)
		Map_COLS_NUM_COLS_less_1:
			FOR i IN 0 TO NUM_ROWS-1 GENERATE
				ifgenerate_Cols_NUM_COLS_less_1:
				IF (i /= NUM_ROWS-1) GENERATE
					mux_ref_cols_less_1: mux4x1
					generic map (N => DATA_WIDTH)
					port map 
					(
						-- Input ports
						sel		=> sel_muxes,	
						data_a	=> sig_others, 						--UP
						data_b	=> ref_registers_data_out(i+1)(NUM_COLS-1),	--DOWN
						data_c	=> ref_registers_data_out(i)(NUM_COLS-2), 	--LEFT
						data_d  => words(i),								--RIGHT
						-- Output ports
						data_out => ref_registers_data_in(i)(NUM_COLS-1)
					);
				END GENERATE;
			END GENERATE;
			
			-- Port map do mux para as demais celulas da matriz de registradores (i)(NUM_COLS-1)
			Row_All:
			FOR i IN 0 TO NUM_ROWS-1 GENERATE
				Cols_All:
				FOR j IN 0 TO NUM_COLS-1 GENERATE
				
					ifgenerate_row_cols_all:
					IF ( (i /= NUM_ROWS-1) AND  ( j > 0 ) AND (j < NUM_COLS-1)  ) GENERATE
			
						mux_ref_cols_less_1: mux4x1
						generic map (N => DATA_WIDTH)
						port map 
						(
							-- Input ports
							sel		=> sel_muxes,	
							data_a	=> sig_others, 						--UP
							data_b	=> ref_registers_data_out(i+1)(j),			--DOWN
							data_c	=> ref_registers_data_out(i)(j-1), 			--LEFT
							data_d  => ref_registers_data_out(i)(j+1),			--RIGHT
							-- Output ports
							data_out => ref_registers_data_in(i)(j)
						);
						
					END GENERATE;
				
				END GENERATE;
				
			END GENERATE;
			
			-- Port map do mux para as demais celulas da matriz de registradores (i)(NUM_COLS-1)
			mux_ref_num_rows_less_1_cols_0: mux4x1
			generic map (N => DATA_WIDTH)
			port map 
			(
				-- Input ports
				sel		=> sel_muxes,	
				data_a	=> sig_others, 						--UP
				data_b	=> words(0),								--DOWN
				data_c	=> words(NUM_ROWS-1), 						--LEFT
				data_d  => ref_registers_data_out(NUM_ROWS-1)(1),	--RIGHT
				-- Output ports
				data_out => ref_registers_data_in(NUM_ROWS-1)(0)
			);
			
			-- Port map do mux para as demais celulas da matriz de registradores (NUM_ROWS-1)(NUM_COLS-1)
			mux_ref_num_rows_less_1_num_cols_less_1: mux4x1
			generic map (N => DATA_WIDTH)
			port map 
			(
				-- Input ports
				sel		=> sel_muxes,	
				data_a	=> sig_others, 								--UP
				data_b	=> words(NUM_COLS-1),								--DOWN
				data_c	=> ref_registers_data_out(NUM_ROWS-1)(NUM_COLS-2),	--LEFT
				data_d  => words(NUM_ROWS-1),								--RIGHT
				-- Output ports
				data_out => ref_registers_data_in(NUM_ROWS-1)(NUM_COLS-1)
			);
		
--		--map_out_i:
--		--FOR i IN 0 TO NUM_ROWS-1 GENERATE
--			map_out_j:
--			FOR j IN 0 TO NUM_COLS-1 GENERATE
--				ref7(j) <= ref_registers_data_out(TEMP)(j);
--			END GENERATE;	
--		--END GENERATE;
--			
--			
--			map_out_6:
--			FOR j IN 0 TO NUM_COLS-1 GENERATE
--				ref6(j) <= ref_registers_data_out(6)(j);
--			END GENERATE;	
--		
--			map_out_5:
--			FOR j IN 0 TO NUM_COLS-1 GENERATE
--				ref5(j) <= ref_registers_data_out(5)(j);
--			END GENERATE;	
--		
--			map_out_4:
--			FOR j IN 0 TO NUM_COLS-1 GENERATE
--				ref4(j) <= ref_registers_data_out(4)(j);
--			END GENERATE;		
--			
--			map_out_3:
--			FOR j IN 0 TO NUM_COLS-1 GENERATE
--				ref3(j) <= ref_registers_data_out(3)(j);
--			END GENERATE;		
--			
--			map_out_2:
--			FOR j IN 0 TO NUM_COLS-1 GENERATE
--				ref2(j) <= ref_registers_data_out(2)(j);
--			END GENERATE;		
--			
--			map_out_1:
--			FOR j IN 0 TO NUM_COLS-1 GENERATE
--				ref1(j) <= ref_registers_data_out(1)(j);
--			END GENERATE;			
--			
--			map_out_0:
--			FOR j IN 0 TO NUM_COLS-1 GENERATE
--				ref0(j) <= ref_registers_data_out(0)(j);
--			END GENERATE;
--		
end behaviour;

