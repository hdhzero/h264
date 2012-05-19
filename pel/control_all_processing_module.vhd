------------------------------------------------------------------------------
-- PROJETO: Estimação de Movimento
-- ENTIDADE : control_all_processing_module
------------------------------------------------------------------------------
-- DESCRIÇÃO: Controle dos modulos de processamento
------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
--use std.textio.all; --
use work.motion_estimation_8x8_package.all;

ENTITY control_all_processing_module IS
	generic(
			SHIFT_HORIZONTAL: INTEGER := 7; -- quantidade de deslocamentos na horizontal
			SHIFT_VERTICAL: INTEGER := 24 -- quantidade de deslocamentos na vertical
	);
	port(
		clk: in std_logic;
		rst: in std_logic;
		
		start_control: in std_logic;
		start_comparator: out std_logic;
		start_sad_manager_mp0: out std_logic;
		start_reference_manager_fill_mp0 : out std_logic;
		start_reference_manager_shifts_mp0 : out std_logic;
		
		start_sad_manager_mp1: out std_logic;
		start_reference_manager_fill_mp1 : out std_logic;
		start_reference_manager_shifts_mp1 : out std_logic;
		
		start_sad_manager_mp2: out std_logic;
		start_reference_manager_fill_mp2 : out std_logic;
		start_reference_manager_shifts_mp2 : out std_logic;
		
		sel_mux_data_in_ref_mp0: out std_logic_vector(1 DOWNTO 0);
		sel_mux_data_in_ref_mp1: out std_logic_vector(1 DOWNTO 0);
		sel_mux_data_in_ref_mp2: out std_logic_vector(1 DOWNTO 0)
	);
END control_all_processing_module;
   
architecture behaviour of  control_all_processing_module is
   
   	TYPE STATE_TYPE is (s0_start, init_brr_mp0, init_brr_mp1, init_brr_mp2, start_shifts, shifts_left, shifts_right, shifts_buffer_0, shifts_buffer_1); --, s1_inc, s2_read_mem_inc, s3_inc, s4_mux_sel, s5_dec, s6_read_mem_dec, s7_read_mem_dec, s8_mux_sel);
   	TYPE STATE_TYPE_COMP is (s0_wait, s1_wait, s2_wait, s3_wait, s4_wait, s5_wait, s6_wait, s7_wait);--, s8_wait); --, s1_inc, s2_read_mem_inc, s3_inc, s4_mux_sel, s5_dec, s6_read_mem_dec, s7_read_mem_dec, s8_mux_sel);
	SIGNAL state, next_state : STATE_TYPE;
	SIGNAL state_comp, next_state_comp : STATE_TYPE_COMP;
	SIGNAL compare_limit, AeB_hor, AeB_ver, sel_mux_count_fill, sel_mux_count_shifts_hor, sel_mux_count_shifts_ver, we_count_fill, we_count_shifts_hor, we_count_shifts_ver: std_logic;
	SIGNAL sig_others, sig_add_count_fill, sig_add_shifts_ver, sig_add_shifts_hor: std_logic_vector(DATA_WIDTH-1 DOWNTO 0);
	SIGNAL shifts_hor_std, shifts_ver_std, count_shifts_hor_out, count_shifts_hor_in, count_shifts_ver_out, count_shifts_ver_in, count_fill_in, count_fill_out: std_logic_vector(DATA_WIDTH-1 DOWNTO 0);
	SIGNAL sig_start_sad_manager: std_logic;
	CONSTANT LIMIT_INIT_BANK: std_logic_vector := "00000111";
	
begin
  
	shifts_hor_std <= std_logic_vector(to_unsigned(SHIFT_HORIZONTAL, DATA_WIDTH)); --alterando aqui /tirando o -1
	shifts_ver_std <= std_logic_vector(to_unsigned(SHIFT_VERTICAL, DATA_WIDTH)); -- alterando aqui /tirando o -1 
	
	sig_others <= (others => '0');
  	state_machine: process(state, start_control, compare_limit, AeB_hor, AeB_ver)
	begin
		
		case (state) is
					
			when s0_start =>
				
				if (start_control = '1') then
					we_count_fill <= '1';
					start_reference_manager_fill_mp0  <= '1';
					next_state <= init_brr_mp0;
				else
					we_count_fill <= '0';
					start_reference_manager_fill_mp0  <= '0';
					next_state <= s0_start;
				end if;
				
				sel_mux_count_fill <= '0';
				sel_mux_count_shifts_hor <= '0';
				sel_mux_count_shifts_ver <= '0';
				we_count_shifts_hor <= '0';
				we_count_shifts_ver <= '0';
				
				start_sad_manager_mp0 <= '0';
				start_reference_manager_shifts_mp0  <= '0';
				
				start_sad_manager_mp1 <= '0';
				start_reference_manager_fill_mp1 <= '0';
				start_reference_manager_shifts_mp1 <= '0';
				
				start_sad_manager_mp2 <= '0';
				start_reference_manager_fill_mp2  <= '0';
				start_reference_manager_shifts_mp2  <= '0';
				
				sel_mux_data_in_ref_mp0 <= SEL_MUX_MP_PORT_B;
				sel_mux_data_in_ref_mp1 <= SEL_MUX_MP_PORT_B;
				sel_mux_data_in_ref_mp2 <= SEL_MUX_MP_PORT_B;
				
				sig_start_sad_manager <= '0';
			when init_brr_mp0 =>
		
				if (compare_limit = '1') then
					sel_mux_count_fill <= '0';
					next_state <= init_brr_mp1;
					start_reference_manager_fill_mp1 <= '1';
				else
					sel_mux_count_fill <= '1';
					next_state <= init_brr_mp0;
					start_reference_manager_fill_mp1 <= '0';
				end if;
				
				sel_mux_count_shifts_hor <= '0';
				sel_mux_count_shifts_ver <= '0';
				we_count_fill <= '1';
				we_count_shifts_hor <= '0';
				we_count_shifts_ver <= '0';
				
				start_sad_manager_mp0 <= '0';
				start_reference_manager_fill_mp0  <= '0';
				start_reference_manager_shifts_mp0  <= '0';
				
				start_sad_manager_mp1 <= '0';
				start_reference_manager_shifts_mp1 <= '0';
				
				start_sad_manager_mp2 <= '0';
				start_reference_manager_fill_mp2  <= '0';
				start_reference_manager_shifts_mp2  <= '0';
				
				sel_mux_data_in_ref_mp0 <= SEL_MUX_MP_PORT_B;
				sel_mux_data_in_ref_mp1 <= SEL_MUX_MP_PORT_B;
				sel_mux_data_in_ref_mp2 <= SEL_MUX_MP_PORT_B;
				sig_start_sad_manager <= '0';
				
			when init_brr_mp1 =>
		
				if (compare_limit = '1') then
					sel_mux_count_fill <= '0';
					next_state <= init_brr_mp2;
					start_reference_manager_fill_mp2 <= '1';
				else
					sel_mux_count_fill <= '1';
					next_state <= init_brr_mp1;
					start_reference_manager_fill_mp2 <= '0';
				end if;

				sel_mux_count_shifts_hor <= '0';
				sel_mux_count_shifts_ver <= '0';
				we_count_fill <= '1';
				we_count_shifts_hor <= '0';
				we_count_shifts_ver <= '0';
				
				start_sad_manager_mp0 <= '0';
				start_reference_manager_fill_mp0  <= '0';
				start_reference_manager_shifts_mp0  <= '0';
				
				start_sad_manager_mp1 <= '0';
				start_reference_manager_fill_mp1  <= '0';
				start_reference_manager_shifts_mp1  <= '0';
				
				start_sad_manager_mp2 <= '0';
				start_reference_manager_shifts_mp2 <= '0';
				
				sel_mux_data_in_ref_mp0 <= SEL_MUX_MP_PORT_B;
				sel_mux_data_in_ref_mp1 <= SEL_MUX_MP_PORT_B;
				sel_mux_data_in_ref_mp2 <= SEL_MUX_MP_PORT_B;
				sig_start_sad_manager <= '0';
			
		
			when init_brr_mp2 =>
		
				if (compare_limit = '1') then
					sel_mux_count_fill <= '0';
					next_state <= start_shifts;
					else
					sel_mux_count_fill <= '1';
					next_state <= init_brr_mp2;
				end if;

				sel_mux_count_shifts_hor <= '0';
				sel_mux_count_shifts_ver <= '0';
				we_count_fill <= '1';
				we_count_shifts_hor <= '0';
				we_count_shifts_ver <= '0';

				start_sad_manager_mp0 <= '0';
				start_reference_manager_fill_mp0  <= '0';
				start_reference_manager_shifts_mp0  <= '0';
				
				start_sad_manager_mp1 <= '0';
				start_reference_manager_fill_mp1  <= '0';
				start_reference_manager_shifts_mp1  <= '0';
				
				start_sad_manager_mp2 <= '0';
				start_reference_manager_fill_mp2 <= '0';
				start_reference_manager_shifts_mp2 <= '0';
				
				sel_mux_data_in_ref_mp0 <= SEL_MUX_MP_PORT_B;
				sel_mux_data_in_ref_mp1 <= SEL_MUX_MP_PORT_B;
				sel_mux_data_in_ref_mp2 <= SEL_MUX_MP_PORT_B;
				sig_start_sad_manager <= '0';
				
		
			when start_shifts =>
		
				next_state <= shifts_left;
				
				sel_mux_count_shifts_hor <= '0';
				sel_mux_count_shifts_ver <= '0';
				sel_mux_count_fill <= '0';
				we_count_fill <= '0';
				we_count_shifts_hor <= '1';
				we_count_shifts_ver <= '1';
				
				start_sad_manager_mp0 <= '1';
				start_reference_manager_fill_mp0  <= '0';
				start_reference_manager_shifts_mp0  <= '1';
				
				start_sad_manager_mp1 <= '1';
				start_reference_manager_fill_mp1  <= '0';
				start_reference_manager_shifts_mp1  <= '1';
				
				start_sad_manager_mp2 <= '1';
				start_reference_manager_fill_mp2 <= '0';
				start_reference_manager_shifts_mp2 <= '1';
				
				sel_mux_data_in_ref_mp0 <= SEL_MUX_MP_RIGHT;
				sel_mux_data_in_ref_mp1 <= SEL_MUX_MP_RIGHT;
				sel_mux_data_in_ref_mp2 <= SEL_MUX_MP_RIGHT;
				sig_start_sad_manager <= '1';
				
		
			when shifts_left =>
		
				if (AeB_hor = '1') then
					next_state <= shifts_buffer_0;
				else
					next_state <= shifts_left;
				end if;
				
				sel_mux_count_shifts_hor <= '1';
				sel_mux_count_shifts_ver <= '0';
				sel_mux_count_fill <= '0';
				we_count_fill <= '0';
				we_count_shifts_hor <= '1';
				we_count_shifts_ver <= '0';
				
				start_sad_manager_mp0 <= '0';
				start_reference_manager_fill_mp0  <= '0';
				start_reference_manager_shifts_mp0  <= '0';
				
				start_sad_manager_mp1 <= '0';
				start_reference_manager_fill_mp1  <= '0';
				start_reference_manager_shifts_mp1  <= '0';
				
				start_sad_manager_mp2 <= '0';
				start_reference_manager_fill_mp2 <= '0';
				start_reference_manager_shifts_mp2 <= '0';
				
				sel_mux_data_in_ref_mp0 <= SEL_MUX_MP_RIGHT;
				sel_mux_data_in_ref_mp1 <= SEL_MUX_MP_RIGHT;
				sel_mux_data_in_ref_mp2 <= SEL_MUX_MP_RIGHT;
				sig_start_sad_manager <= '0';
				
		
			when shifts_buffer_0 =>
		
				if (AeB_ver = '1') then
					next_state <= s0_start;
				else
					next_state <= shifts_right;
				end if;
		
				sel_mux_count_shifts_hor <= '0';
				sel_mux_count_shifts_ver <= '1';
				sel_mux_count_fill <= '0';
				we_count_fill <= '0';
				we_count_shifts_hor <= '1';
				we_count_shifts_ver <= '1';
				
				start_sad_manager_mp0 <= '0';
				start_reference_manager_fill_mp0  <= '0';
				start_reference_manager_shifts_mp0  <= '0';
				
				start_sad_manager_mp1 <= '0';
				start_reference_manager_fill_mp1  <= '0';
				start_reference_manager_shifts_mp1  <= '0';
				
				start_sad_manager_mp2 <= '0';
				start_reference_manager_fill_mp2 <= '0';
				start_reference_manager_shifts_mp2 <= '0';
				
				sel_mux_data_in_ref_mp0 <= SEL_MUX_MP_BUFFER;
				sel_mux_data_in_ref_mp1 <= SEL_MUX_MP_BUFFER;
				sel_mux_data_in_ref_mp2 <= SEL_MUX_MP_BUFFER;
				sig_start_sad_manager <= '0';
				
		
			when shifts_right =>
		
				if (AeB_hor = '1') then
					next_state <= shifts_buffer_1;
				else
					next_state <= shifts_right;
				end if;
				
				sel_mux_count_shifts_hor <= '1';
				sel_mux_count_shifts_ver <= '0';
				sel_mux_count_fill <= '0';
				we_count_fill <= '0';
				we_count_shifts_hor <= '1';
				we_count_shifts_ver <= '0';
				
				start_sad_manager_mp0 <= '0';
				start_reference_manager_fill_mp0  <= '0';
				start_reference_manager_shifts_mp0  <= '0';
				
				start_sad_manager_mp1 <= '0';
				start_reference_manager_fill_mp1  <= '0';
				start_reference_manager_shifts_mp1  <= '0';
				
				start_sad_manager_mp2 <= '0';
				start_reference_manager_fill_mp2 <= '0';
				start_reference_manager_shifts_mp2 <= '0';
				
				sel_mux_data_in_ref_mp0 <= SEL_MUX_MP_LEFT;
				sel_mux_data_in_ref_mp1 <= SEL_MUX_MP_LEFT;
				sel_mux_data_in_ref_mp2 <= SEL_MUX_MP_LEFT;
				sig_start_sad_manager <= '0';
			
						
				
			when shifts_buffer_1 =>
		
				if (AeB_ver = '1') then
					next_state <= s0_start;
				else
					next_state <= shifts_left;
				end if;
				
				sel_mux_count_shifts_hor <= '0';
				sel_mux_count_shifts_ver <= '1';
				sel_mux_count_fill <= '0';
				we_count_fill <= '0';
				we_count_shifts_hor <= '1';
				we_count_shifts_ver <= '1';
				
				start_sad_manager_mp0 <= '0';
				start_reference_manager_fill_mp0  <= '0';
				start_reference_manager_shifts_mp0  <= '0';
				
				start_sad_manager_mp1 <= '0';
				start_reference_manager_fill_mp1  <= '0';
				start_reference_manager_shifts_mp1  <= '0';
				
				start_sad_manager_mp2 <= '0';
				start_reference_manager_fill_mp2 <= '0';
				start_reference_manager_shifts_mp2 <= '0';
				
				sel_mux_data_in_ref_mp0 <= SEL_MUX_MP_BUFFER;
				sel_mux_data_in_ref_mp1 <= SEL_MUX_MP_BUFFER;
				sel_mux_data_in_ref_mp2 <= SEL_MUX_MP_BUFFER;
				sig_start_sad_manager <= '0';
							
				
		end case;
	end process;

	
	comparator_wait: process(state_comp, sig_start_sad_manager)
	begin
		case (state_comp) is
					
			when s0_wait =>
				if (sig_start_sad_manager = '1') then
					next_state_comp <= s1_wait;
				else
					next_state_comp <= s0_wait;
				end if;
			
				start_comparator <= '0';
			
			when s1_wait =>
				next_state_comp <= s2_wait;
				start_comparator <= '0';
			
			
			when s2_wait =>
				next_state_comp <= s3_wait;
				start_comparator <= '0';
					
			
			when s3_wait =>
				next_state_comp <= s4_wait;
				start_comparator <= '0';
			
			
			when s4_wait =>
				next_state_comp <= s5_wait;
				start_comparator <= '0';
				
			
			when s5_wait =>
				next_state_comp <= s6_wait;
				start_comparator <= '0';
			
			when s6_wait =>
				next_state_comp <= s7_wait;
				start_comparator <= '1';
			
			when s7_wait =>
				next_state_comp <= s0_wait;
				start_comparator <= '1';
		
			--when s8_wait =>
			--	next_state_comp <= s0_wait;
			--	start_comparator <= '1';
			--	
		end case;
		
	end process;
	
	
	compare_fill_process: process(clk, count_fill_out)
	begin
		if(count_fill_out = LIMIT_INIT_BANK) then
			compare_limit <= '1';
		else
			compare_limit <= '0';
		end if;
	end process;
	
	comp_shifts_hor: process(count_shifts_hor_out, shifts_hor_std)
	begin
		if (count_shifts_hor_out = shifts_hor_std) then
			AeB_hor <= '1';
		else
			AeB_hor <= '0';
		end if;
	end process;
	
	comp_shifts_ver: process(count_shifts_ver_out, shifts_ver_std)
	begin
		if (count_shifts_ver_out = shifts_ver_std) then
			AeB_ver <= '1';
		else
			AeB_ver <= '0';
		end if;
	end process;
	
	
	regs_process: process(clk, we_count_fill, we_count_shifts_ver, we_count_shifts_hor)
	begin
		if (clk'event and clk = '1') then
			
			if (we_count_fill = '1') then
				count_fill_out <=  count_fill_in;
			end if;
			
			if (we_count_shifts_ver = '1') then
				count_shifts_ver_out <=  count_shifts_ver_in;
			end if;
			
			if (we_count_shifts_hor = '1') then
				count_shifts_hor_out <=  count_shifts_hor_in;
			end if;
		end if;
	end process;

	sig_add_count_fill <= count_fill_out + 1;
	mux_count_fill: 
	with sel_mux_count_fill select
		count_fill_in <= 
						sig_others when '0',
						sig_add_count_fill when '1',
						sig_others when others;

	
	sig_add_shifts_ver <= count_shifts_ver_out + 1;
	mux_count_shifts_hor: 
	with sel_mux_count_shifts_ver select
		count_shifts_ver_in <= 
						sig_others when '0',
						sig_add_shifts_ver when '1',
						sig_others when others;
						
		
	sig_add_shifts_hor <= count_shifts_hor_out + 1;
	mux_count_shifts_ver: 
	with sel_mux_count_shifts_hor select
		count_shifts_hor_in <= 
						sig_others when '0',
						sig_add_shifts_hor when '1',
						sig_others when others;
						
						
						
						
update_state: process(clk, rst)
	begin
		if (rst = '1') then
			state_comp <= s0_wait;
			state <= s0_start;
		elsif (clk'event and clk = '1') then
			state <= next_state;
			state_comp <= next_state_comp;
		end if;
	end process;

end behaviour;
