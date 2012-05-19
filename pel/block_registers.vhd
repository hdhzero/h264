------------------------------------------------------------------------------
-- PROJETO: Estimação de Movimento
-- ENTIDADE : block_registers
------------------------------------------------------------------------------
-- DESCRIÇÃO: Banco de registradores de bloco
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.all;
use work.motion_estimation_8x8_package.all;

entity block_registers is
	port
	(
		clk: in std_logic;
		-- Input ports
		words	: in REG_COLS;
		we_blk: in WE_REG_ROWS;
		
		blk: out REG_ROWS

	);
end block_registers;



architecture behaviour of  block_registers is

	
	component regNbits is
		generic
		(
			N	: integer  :=	32
		);
		
		port
		(
			-- Input ports
			clk		: in std_logic;
			data_in		: in  std_logic_vector(DATA_WIDTH-1 DOWNTO 0);
			we			: in  std_logic;

			-- Output ports
			data_out	: out std_logic_vector(DATA_WIDTH-1 DOWNTO 0)
		);
	end component;


	SIGNAL i: INTEGER RANGE 0 TO NUM_ROWS-1;
	SIGNAL j: INTEGER RANGE 0 TO NUM_COLS-1;
	
	signal blk_registers_data_in, blk_registers_data_out: REG_ROWS;
	
	begin
	
			Row_NUM_ROWS_less_1:
			FOR j IN 0 TO NUM_COLS-1 GENERATE
				register_blk: regNbits
				generic map ( N => 8 )
				port map(
					clk			=> clk, 
					data_in		=> words(j),
					we			=> we_blk(NUM_ROWS-1)(j),
					data_out	=> blk_registers_data_out(NUM_ROWS-1)(j)
				);
			END GENERATE;
			
			Row:
			FOR i IN 0 TO NUM_ROWS-1 GENERATE
				Cols:
				FOR j IN 0 TO NUM_COLS-1 GENERATE
				
					ifgenerate:
					IF (i /= NUM_ROWS-1) GENERATE
			
						register_blk: regNbits
						generic map ( N => DATA_WIDTH )
						port map(
							clk			=> clk, 
							data_in		=> blk_registers_data_out(i+1)(j),
							we			=> we_blk(i)(j),
							data_out	=> blk_registers_data_out(i)(j)
						);
						
					END GENERATE;
				
				END GENERATE;
				
			END GENERATE;

		
		blk <= blk_registers_data_out;
		
end behaviour;

