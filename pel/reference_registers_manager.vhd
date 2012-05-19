------------------------------------------------------------------------------
-- PROJETO: Estimação de Movimento
-- ENTIDADE : reference_registers_manager
------------------------------------------------------------------------------
-- DESCRIÇÃO: Este codigo implementa a logica do algoritmo da busca completa, 
-- indicando qual o deslocamento que os dados do banco de registradores de 
-- referencia devem sofrer (direita, esquerda ou para cima)
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.all;
use work.motion_estimation_8x8_package.all;

entity reference_registers_manager is
generic(
		LENGTH_VECTOR: INTEGER := LENGTH_MOTION_VECTOR; -- qtd de bits para representar cada componente do vetor de movimento
		INICIAL_X_VALUE: INTEGER := -12;
		INICIAL_Y_VALUE: INTEGER := -4;
		SHIFT_HORIZONTAL: INTEGER := 7; -- quantidade de deslocamentos na horizontal
		SHIFT_VERTICAL: INTEGER := 24; -- quantidade de deslocamentos na vertical
		INIT_BANK: INTEGER := 7
);
port(
	rst: in std_logic;
	clk: in std_logic;
	start_fill: in std_logic; -- preenchimento inicial do banco de registradores
	start_shifts: in std_logic; -- iniciar o mecanismo de deslocamento
	sel_muxes: out std_logic_vector(1 DOWNTO 0);
	vector_x: out std_logic_vector(LENGTH_MOTION_VECTOR-1 DOWNTO 0);
	vector_y: out std_logic_vector(LENGTH_MOTION_VECTOR-1 DOWNTO 0);
	end_search: out std_logic;
	we_refs: out WE_REG_ROWS
);
end entity;

architecture behaviour of reference_registers_manager is

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
	
	component comp_AeB is
	GENERIC (N: integer := 14);
	PORT
	(
		dataa		: IN STD_LOGIC_VECTOR (N-1 DOWNTO 0);
		datab		: IN STD_LOGIC_VECTOR (N-1 DOWNTO 0);
		AeB		: OUT STD_LOGIC 
	);
	END component;
	
	TYPE STATE_TYPE is (s0_start, s0_init_up, s1_wait, s1_hor_left, s2_up, s3_hor_right, s4_up);--, s1_0_LIMIT, s2_Columns_TO_memwords, s3_idle,s4_memwords_TO_0, s5_idle);
	
	SIGNAL shifts_hor_std, shifts_ver_std: std_logic_vector(DATA_WIDTH-1 DOWNTO 0);

	SIGNAL sig_mux_hor_dataout, sig_mux_ver_dataout, sig_add_sub_hor_out, sig_reg_hor_dataout, sig_reg_ver_dataout, sig_add_sub_ver_out: std_logic_vector(DATA_WIDTH-1 DOWNTO 0);
	SIGNAL sig_reg_hor_we, sig_reg_ver_we, sig_sel_mux_hor, sig_sel_mux_ver, sig_hor_add_sub, sig_ver_add_sub: std_logic;	
		
	SIGNAL init_value_x, init_value_y, sig_mux_x_dataout, sig_reg_x_dataout, sig_mux_y_dataout, sig_reg_y_dataout, sig_add_sub_x_out, sig_add_sub_y_out: std_logic_vector(LENGTH_VECTOR-1 DOWNTO 0);
	SIGNAL sig_reg_x_we, sig_reg_y_we, sig_sel_mux_x, sig_sel_mux_y, sig_x_add_sub, sig_y_add_sub: std_logic;

	signal sig_mux_up_dataout, sig_reg_up_dataout, sig_add_sub_up_out: std_logic_vector(DATA_WIDTH-1 DOWNTO 0);
	signal sig_reg_up_we, sig_sel_mux_up, sig_up_add_sub: std_logic;
	signal sig_others, reg_up_data_out_comp: std_logic_vector(DATA_WIDTH-1 DOWNTO 0);
	signal sig_value_1_data_width: std_logic_vector(DATA_WIDTH-1 DOWNTO 0);
	signal sig_value_1_length_vector: std_logic_vector(LENGTH_VECTOR-1 DOWNTO 0);
	SIGNAL state, next_state : STATE_TYPE;
	SIGNAL AeB_reg_up_data_out, AeB_reg_hor_dataout, AeB_reg_ver_dataout: std_logic;


begin
	
	sig_others <= (others => '0');
	shifts_hor_std <= std_logic_vector(to_unsigned(SHIFT_HORIZONTAL, DATA_WIDTH));
	shifts_ver_std <= std_logic_vector(to_unsigned(SHIFT_VERTICAL, DATA_WIDTH));
	init_value_x <= std_logic_vector(to_signed(INICIAL_X_VALUE, LENGTH_VECTOR));
	init_value_y <= std_logic_vector(to_signed(INICIAL_Y_VALUE, LENGTH_VECTOR));
	
	vector_x <= sig_reg_x_dataout;
	vector_y <= sig_reg_y_dataout;
	
	state_machine: process(state, start_fill, start_shifts, AeB_reg_up_data_out,AeB_reg_hor_dataout, AeB_reg_ver_dataout)
	begin		
		case (state) is
			
			when  s0_start =>
				
				end_search <= '0';
				
				if (start_fill = '1') then
					
					sig_sel_mux_hor <= '0'; 
					sig_sel_mux_ver <= '0'; 
					sig_reg_hor_we <= '1'; 
					sig_reg_ver_we <= '1'; 
					sig_hor_add_sub <= '0'; --dont care
					sig_ver_add_sub <= '0'; --dont care				
					
					sig_sel_mux_x <= '0';
					sig_sel_mux_y <= '0';
					sig_reg_x_we <= '1'; 
					sig_reg_y_we <= '1'; 
					sig_x_add_sub <= '0'; -- dont care
					sig_y_add_sub <= '0'; -- dont care 
					
					sig_reg_up_we <= '1';
					sig_sel_mux_up <= '0';
					sig_up_add_sub <= '0'; --dont care
					
					next_state <= s0_init_up;
					
				else
					
					sig_sel_mux_hor <= '0'; --dont care
					sig_sel_mux_ver <= '0'; --dont care
					sig_reg_hor_we <= '0'; --dont care
					sig_reg_ver_we <= '0'; --dont care
					sig_hor_add_sub <= '0'; --dont care
					sig_ver_add_sub <= '0'; --dont care
					
					sig_sel_mux_x <= '0'; -- dont care
					sig_sel_mux_y <= '0'; -- dont care
					sig_reg_x_we <= '0';  -- dont care
					sig_reg_y_we <= '0';  -- dont care
					sig_x_add_sub <= '0'; -- dont care
					sig_y_add_sub <= '0'; -- dont care 
					
					sig_reg_up_we <= '0';  -- dont care
					sig_sel_mux_up <= '0'; -- dont care
					sig_up_add_sub <= '0'; -- dont care
					
					next_state <= s0_start;
					
				end if;
				
				sel_muxes <= (others => '0'); --dont care
				we_refs <= (others => (others =>'0') );
			
			when s0_init_up => --Faz 8 deslocamentos para cima, inicializando o banco de registradores
				
				end_search <= '0';
				
				sig_sel_mux_hor <= '0'; 
				sig_sel_mux_ver <= '0'; 
				sig_reg_hor_we <= '0'; 
				sig_reg_ver_we <= '0'; 
				sig_hor_add_sub <= '0'; 
				sig_ver_add_sub <= '0';
				sel_muxes <= SEL_REGS_UP;
				
				sig_sel_mux_x <= '0';
				sig_sel_mux_y <= '0'; -- dont care
				sig_reg_x_we <= '0'; 
				sig_reg_y_we <= '0'; 
				sig_x_add_sub <= '0';
				sig_y_add_sub <= '0'; -- dont care 
			
				sig_reg_up_we <= '1';  
				sig_sel_mux_up <= '1'; -- dont care
				sig_up_add_sub <= '1'; -- dont care
					
				if (AeB_reg_up_data_out = '1' and start_shifts = '1') then
					next_state <= s1_hor_left;
				elsif(AeB_reg_up_data_out = '1' and start_shifts = '0') then
					next_state <= s1_wait;
				else
					next_state <= s0_init_up;
				end if;
				
				we_refs <= (others => (others =>'1') );
			
			when s1_wait =>
				end_search <= '0';
				
				sig_sel_mux_hor <= '0'; 
				sig_sel_mux_ver <= '0'; 
				sig_reg_hor_we <= '0'; 
				sig_reg_ver_we <= '0'; 
				sig_hor_add_sub <= '0'; 
				sig_ver_add_sub <= '0';
				sel_muxes <= SEL_REGS_LEFT;
				
				sig_sel_mux_x <= '1';
				sig_sel_mux_y <= '0'; -- dont care
				sig_reg_x_we <= '0'; 
				sig_reg_y_we <= '0'; 
				sig_x_add_sub <= '1';
				sig_y_add_sub <= '0'; -- dont care 
					
				sig_reg_up_we <= '0';  -- dont care
				sig_sel_mux_up <= '0'; -- dont care
				sig_up_add_sub <= '0'; -- dont care
			
				if (start_shifts = '1') then
					next_state <= s1_hor_left;
				else
					next_state <= s1_wait;
				end if;
				
				we_refs <= (others => (others =>'0') );
				
			when s1_hor_left =>
				
				end_search <= '0';
				
				sig_sel_mux_hor <= '1'; 
				sig_sel_mux_ver <= '0'; 
				sig_reg_hor_we <= '1'; 
				sig_reg_ver_we <= '0'; 
				sig_hor_add_sub <= '1'; 
				sig_ver_add_sub <= '0';
				sel_muxes <= SEL_REGS_LEFT;
				
				sig_sel_mux_x <= '1';
				sig_sel_mux_y <= '0'; -- dont care
				sig_reg_x_we <= '1'; 
				sig_reg_y_we <= '0'; 
				sig_x_add_sub <= '1';
				sig_y_add_sub <= '0'; -- dont care 
					
				sig_reg_up_we <= '0';  -- dont care
				sig_sel_mux_up <= '0'; -- dont care
				sig_up_add_sub <= '0'; -- dont care
				
				if (AeB_reg_hor_dataout = '1') then
					next_state <= s2_up;
				else
					next_state <= s1_hor_left;
				end if;
				
				we_refs <= (others => (others =>'1') );
				
			when s2_up => 
				
				end_search <= '0';
				
				sig_sel_mux_hor <= '0'; 
				sig_sel_mux_ver <= '1'; 
				sig_reg_hor_we <= '1'; 
				sig_reg_ver_we <= '1'; 
				sig_hor_add_sub <= '1'; 
				sig_ver_add_sub <= '1';
				sel_muxes <= SEL_REGS_UP; 
				
				sig_sel_mux_x <= '0'; --dont care
				sig_sel_mux_y <= '1';
				sig_reg_x_we <= '0'; 
				sig_x_add_sub <= '0'; --dont care
				sig_y_add_sub <= '1';  
					
				sig_reg_up_we <= '0';  -- dont care
				sig_sel_mux_up <= '0'; -- dont care
				sig_up_add_sub <= '0'; -- dont care

				if (AeB_reg_ver_dataout = '1') then 
					next_state <= s0_start;
					sig_reg_y_we <= '0'; 
					end_search <= '1';
				else
					sig_reg_y_we <= '1'; 
					next_state <= s3_hor_right;
					end_search <= '0';
				end if;
				
				we_refs <= (others => (others =>'1') );
			
			when s3_hor_right =>
				
				end_search <= '0';
				
				sig_sel_mux_hor <= '1'; 
				sig_sel_mux_ver <= '0'; 
				sig_reg_hor_we <= '1'; 
				sig_reg_ver_we <= '0'; 
				sig_hor_add_sub <= '1'; 
				sig_ver_add_sub <= '0';
				sel_muxes <= SEL_REGS_RIGHT; 
				
				sig_sel_mux_x <= '1'; 
				sig_sel_mux_y <= '0'; --dont care
				sig_reg_x_we <= '1';
				sig_reg_y_we <= '0'; 
				sig_x_add_sub <= '0'; --subtraindo
				sig_y_add_sub <= '0';  --dont care
					
				sig_reg_up_we <= '0';  -- dont care
				sig_sel_mux_up <= '0'; -- dont care
				sig_up_add_sub <= '0'; -- dont care				
					
				if (AeB_reg_hor_dataout = '1' ) then
					next_state <= s4_up;
				else
					next_state <= s3_hor_right;
				end if;
				
				we_refs <= (others => (others =>'1') );
			
			when s4_up => 
				
				
				sig_sel_mux_hor <= '0'; 
				sig_sel_mux_ver <= '1'; 
				sig_reg_hor_we <= '1'; 
				sig_reg_ver_we <= '1'; 
				sig_hor_add_sub <= '1'; 
				sig_ver_add_sub <= '1';
				sel_muxes <= SEL_REGS_UP; 
				
				sig_sel_mux_x <= '0'; 
				sig_sel_mux_y <= '1';
				sig_reg_x_we <= '0'; 
				sig_x_add_sub <= '0'; -- dont care
				sig_y_add_sub <= '1';
				
				sig_reg_up_we <= '0';  -- dont care
				sig_sel_mux_up <= '0'; -- dont care
				sig_up_add_sub <= '0'; -- dont care
					
				
				if (AeB_reg_ver_dataout = '1') then
					next_state <= s0_start;
					sig_reg_y_we <= '0'; --inclui isso aqui
					end_search <= '1';
				else
					sig_reg_y_we <= '1'; -- inclui isso aqui
					next_state <= s1_hor_left;
					end_search <= '0';
				end if;

				we_refs <= (others => (others =>'1') );
			
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


	regShifts_HOR: regNbits
		generic map
		(
			N	=> DATA_WIDTH
		)
		port map
		(
			-- Input ports
			clk		=> clk,
			data_in	=> sig_mux_hor_dataout,
			we		=> sig_reg_hor_we,

			-- Output ports
			data_out =>	sig_reg_hor_dataout
		);
	
	regShifts_VER: regNbits
		generic map
		(
			N	=> DATA_WIDTH
		)
		port map
		(
			-- Input ports
			clk		=> clk,
			data_in	=> sig_mux_ver_dataout,
			we		=> sig_reg_ver_we,

			-- Output ports
			data_out =>	sig_reg_ver_dataout
		);
		
	reg_UP: regNbits
		generic map
		(
			N	=> DATA_WIDTH
		)
		port map
		(
			-- Input ports
			clk		=> clk,
			data_in	=> sig_mux_up_dataout,
			we		=> sig_reg_up_we,

			-- Output ports
			data_out =>	sig_reg_up_dataout
		);
		

	regVector_X: regNbits
	generic map
	(
		N	=> LENGTH_VECTOR
	)
	port map
	(
		-- Input ports
		clk		=> clk,
		data_in	=> sig_mux_x_dataout,
		we		=> sig_reg_x_we,

		-- Output ports
		data_out =>	sig_reg_x_dataout
	);

	regVector_Y: regNbits
	generic map
	(
		N	=> LENGTH_VECTOR
	)
	port map
	(
		-- Input ports
		clk		=> clk,
		data_in	=> sig_mux_y_dataout,
		we		=> sig_reg_y_we,

		-- Output ports
		data_out =>	sig_reg_y_dataout
	);

	mux_HOR: mux2x1 
	generic map
	(
		N	=> DATA_WIDTH
	)
	port map
	(
		-- Input ports
		sel		=> sig_sel_mux_hor,
		data_a	=> sig_others,
		data_b	=> sig_add_sub_hor_out,
		-- Output ports
		data_out => sig_mux_hor_dataout
	);
	
	mux_VER: mux2x1 
	generic map
	(
		N	=> DATA_WIDTH
	)
	port map
	(
		-- Input ports
		sel		=> sig_sel_mux_ver,
		data_a	=> sig_others,
		data_b	=> sig_add_sub_ver_out,
		-- Output ports
		data_out => sig_mux_ver_dataout
	);
	
		
	mux_X: mux2x1 
	generic map
	(
		N	=> LENGTH_VECTOR
	)
	port map
	(
		-- Input ports
		sel		=> sig_sel_mux_x,
		data_a	=> init_value_x,
		data_b	=> sig_add_sub_x_out,
		-- Output ports
		data_out => sig_mux_x_dataout
	);	
		
	mux_Y: mux2x1 
	generic map
	(
		N	=> LENGTH_VECTOR
	)
	port map
	(
		-- Input ports
		sel		=> sig_sel_mux_y,
		data_a	=> init_value_y,
		data_b	=> sig_add_sub_y_out,
		-- Output ports
		data_out => sig_mux_y_dataout
	);	
		
	
	mux_UP: mux2x1 
	generic map
	(
		N	=> DATA_WIDTH
	)
	port map
	(
		-- Input ports
		sel		=> sig_sel_mux_up,
		data_a	=> sig_others,
		data_b	=> sig_add_sub_up_out,
		-- Output ports
		data_out => sig_mux_up_dataout
	);	
	
	
	sig_value_1_data_width <= std_logic_vector(to_unsigned(0, DATA_WIDTH-1)) & '1';
	sig_value_1_length_vector <= std_logic_vector(to_unsigned(0, LENGTH_VECTOR-1)) & '1';
			
	adderSub_HOR: unsigned_adder_subtractor
		generic map
		(
			DATA_WIDTH => DATA_WIDTH
		)
		port map
		(
			a		=> sig_reg_hor_dataout,
			b		=> sig_value_1_data_width,
			add_sub => sig_hor_add_sub,
			result	=> sig_add_sub_hor_out
		);
			
	adderSub_VER: unsigned_adder_subtractor
		generic map
		(
			DATA_WIDTH => DATA_WIDTH
		)
		port map
		(
			a		=> sig_reg_ver_dataout,
			b		=> sig_value_1_data_width,
			add_sub => sig_ver_add_sub,
			result	=> sig_add_sub_ver_out
		);
			
			
	adderSub_X: unsigned_adder_subtractor
		generic map
		(
			DATA_WIDTH => LENGTH_VECTOR
		)
		port map
		(
			a		=> sig_reg_x_dataout,
			b		=> sig_value_1_length_vector,
			add_sub => sig_x_add_sub,
			result	=> sig_add_sub_x_out
		);	
	
	adderSub_Y: unsigned_adder_subtractor
		generic map
		(
			DATA_WIDTH => LENGTH_VECTOR
		)
		port map
		(
			a		=> sig_reg_y_dataout,
			b		=> sig_value_1_length_vector,
			add_sub => sig_y_add_sub,
			result	=> sig_add_sub_y_out
		);		

		adderSub_UP: unsigned_adder_subtractor
		generic map
		(
			DATA_WIDTH => DATA_WIDTH
		)
		port map
		(
			a		=> sig_reg_up_dataout,
			b		=> sig_value_1_data_width,
			add_sub => sig_up_add_sub,
			result	=> sig_add_sub_up_out
		);				
			
			
		reg_up_data_out_comp <= std_logic_vector(to_unsigned(INIT_BANK, DATA_WIDTH));
		comp_process_1: process(sig_reg_up_dataout, reg_up_data_out_comp)
		begin
			if (sig_reg_up_dataout = reg_up_data_out_comp) then
				AeB_reg_up_data_out <= '1';
			else
				AeB_reg_up_data_out <= '0';
			end if;
			
		end process;

		comp_process_2: process(sig_reg_hor_dataout, shifts_hor_std)
		begin
			if (sig_reg_hor_dataout = shifts_hor_std) then
				AeB_reg_hor_dataout <= '1';
			else
				AeB_reg_hor_dataout <= '0';
			end if;
		end process;
		
		comp_process_3: process(sig_reg_ver_dataout, shifts_ver_std)
		begin
			if (sig_reg_ver_dataout = shifts_ver_std) then
				AeB_reg_ver_dataout <= '1';
			else
				AeB_reg_ver_dataout <= '0';
			end if;
		end process;
	
end behaviour;