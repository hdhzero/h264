------------------------------------------------------------------------------
-- PROJETO: Estimação de Movimento
-- ENTIDADE : block_registers_manager
------------------------------------------------------------------------------
-- DESCRIÇÃO: Controle do Banco de registradores de bloco
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.all;
use work.motion_estimation_8x8_package.all;

entity block_registers_manager is
	port
	(
		rst: in std_logic;
		clk: in std_logic;
		-- Input ports
		we_start_blk: in std_logic;
		we_blk: out WE_REG_ROWS
	);
end block_registers_manager;


architecture behaviour of  block_registers_manager is

	TYPE STATE_TYPE is (start, s01);
	
	SIGNAL sig_count, count_in, count_out: INTEGER RANGE 0 TO (BLOCK_DIMENSION+1) := 0;
	SIGNAL sel_count, we_count: std_logic;
	SIGNAL state, next_state: STATE_TYPE;
	SIGNAL sig_we_blk: WE_REG_ROWS;
	
	begin
		
	we_blk <= sig_we_blk;
	
	state_machine: process(state, we_start_blk, count_out)
	begin
		case (state) is
		
			when start => -- monitora o we do banco de registradores de bloco
	
				if (we_start_blk = '1') then
					next_state <= s01;
					we_count <= '1';
				else
					we_count <= '0';
					next_state <= start;
				end if;
	
				sel_count <= '0';
				sig_we_blk <= (others => (others => '0'));
				
			when s01 =>
				if (count_out = (BLOCK_DIMENSION-1)) then
					next_state <= start;
					we_count <= '0';
				else
					next_state <= s01;
					we_count <= '1';				
				end if;
				
				sel_count <= '1';
				
				sig_we_blk <= (others => (others => '1'));
		end case;
	end process;
	
	
	registers: process(clk)
	begin
		if (clk'event and clk = '1') then
			if (we_count = '1') then
				count_out <= count_in;
			end if;
		end if;
	end process;
	
	update_state: process (clk, rst)
	begin
		if (rst = '1') then
			state <= start;
		elsif (clk'event and clk = '1') then
			state <= next_state;
		end if;	
	end process;
	
	sig_count <= count_out + 1;
	
	mux_reg_count:
		with sel_count select
			count_in <= 
					0 			when '0',
					sig_count 	when '1',
					0			when others;

end behaviour;

