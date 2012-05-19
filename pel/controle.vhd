library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.all;
use work.motion_estimation_8x8_package.all;

entity controle is
port(

	rst: in std_logic;
	clk: in std_logic;
	
	words_blk_we: 	out WE_REG_ROWS;
	word_external_memory_we: out std_logic;
	
	--mems_datas:	 	in MEM_WRITE_DATAS;
	mems_raddrs: 	out MEM_PORT_A_ADDRS;
	mems_waddrs: 	out MEM_PORT_B_ADDRS;
	mems_rdens: 	out std_logic_vector(NUM_MEMORIES-1 DOWNTO 0);
	mems_wrens: 	out std_logic_vector(NUM_MEMORIES-1 DOWNTO 0);
	
	sel_mux_mems_mp0:	out integer RANGE 0 TO ENTRIES_PER_MUX;

	sel_mux_ref_mp0:	out std_logic_vector(1 DOWNTO 0);
	we_reg_ref_mp0:		out WE_REG_ROWS;
	
	we_sad_levels_mp0:	out std_logic_vector(LEVELS-1 DOWNTO 0)
	
);
end entity;

architecture behaviour of controle is

	TYPE STATE_TYPE is (start, s01, s02);
	SIGNAL state, next_state: STATE_TYPE;
	
	component memory_manager is
	port(
		rst: in std_logic;
		clk: in std_logic;
		start: in std_logic;
		sel_mux: out integer RANGE 0 TO ENTRIES_PER_MUX;
		rden	: out std_logic;
		mem_addr: out std_logic_vector(MEM_PORT_A_WIDTHAD-1 DOWNTO 0)
	);
	end component;

begin

	state_machine: process(state)
	begin
	
		case (state) is
		
			when start =>
				
				words_blk_we	<= (others => (others => '0') );
				word_external_memory_we <= '0';
				
				mems_raddrs		<= (others => (others => '0') );
				mems_waddrs		<= (others => (others => '0') );
				mems_rdens		<= (others => '0');
				mems_wrens		<= (others => '0');
				
				sel_mux_mems_mp0	<= 0;

				sel_mux_ref_mp0		<= (others => '0');
				we_reg_ref_mp0		<= (others => (others => '0') );
				
				we_sad_levels_mp0	<= (others => '0') ;
				
				next_state <= s01;
				
			
			when s01 =>
			
				words_blk_we	<= (others => (others => '0') );
				word_external_memory_we <= '0';
				
				mems_raddrs		<= (others => (others => '0') );
				mems_waddrs		<= (others => (others => '0') );
				mems_rdens		<= (others => '0');
				mems_wrens		<= (others => '0');
				
				sel_mux_mems_mp0	<= 0;

				sel_mux_ref_mp0		<= (others => '0');
				we_reg_ref_mp0		<= (others => (others => '0') );
				
				we_sad_levels_mp0	<= (others => '0') ;
				
				next_state <= s02;
				
			when s02 =>
		
				words_blk_we	<= (others => (others => '0') );
				word_external_memory_we <= '0';
				
				mems_raddrs		<= (others => (others => '0') );
				mems_waddrs		<= (others => (others => '0') );
				mems_rdens		<= (others => '0');
				mems_wrens		<= (others => '0');
				
				sel_mux_mems_mp0	<= 0;

				sel_mux_ref_mp0		<= (others => '0');
				we_reg_ref_mp0		<= (others => (others => '0') );
				
				we_sad_levels_mp0	<= (others => '0') ;
				
				next_state <= start;
				
		end case;
	
	end process;
	
--	component memory_manager is
--	port(
--		rst: in std_logic;
--		clk: in std_logic;
--		start: in std_logic;
--		sel_mux: out integer RANGE 0 TO ENTRIES_PER_MUX;
--		rden	: out std_logic;
--		mem_addr: out std_logic_vector(MEM_ADDR_WIDTH_READ-1 DOWNTO 0)
--	);
--	end entity;
	
	update_state: process (clk, rst)
	begin
		if (rst = '1') then
			state <= start;
		elsif (clk'event and clk = '1') then
			state <= next_state;
		end if;
	end process;

end behaviour;