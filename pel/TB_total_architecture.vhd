LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
use std.textio.all; --
use work.motion_estimation_8x8_package.all;

ENTITY TB_total_architecture IS
END TB_total_architecture;

	architecture comportamento of TB_total_architecture is
		 
		component total_architecture is
		port(
			clk: in std_logic;
			rst: in std_logic;
			
			word_external_memory: in std_logic_vector(MEM_PORT_B_WIDTH-1 DOWNTO 0);
			
			words_blk: in std_logic_vector(MEM_PORT_B_WIDTH-1 DOWNTO 0);
			start_architecture: in std_logic;
		
			vectors_ready: out std_logic;
			motion_vector_x: out std_logic_vector(4 DOWNTO 0);
			motion_vector_y: out std_logic_vector(4 DOWNTO 0);
			out_start_write_buffer: out std_logic;
			out_start_init_line: out std_logic;
			end_search: out std_logic;
			best_sad: out std_logic_vector(DATA_WIDTH-1 + LEVELS-1 DOWNTO 0);
			start_reference_manager_fill_mp0_out: out std_logic
			
		);			
		end component;

   --funcao
   function str_to_stdvec(inp: string) return std_logic_vector is
		variable temp: std_logic_vector(inp'range);
	begin
		for i in inp'range loop
			if (inp(i) = '1') then
				temp(i) := '1';
			elsif (inp(i) = '0') then
				temp(i) := '0';
			end if;
		end loop;
		return temp;
	end function str_to_stdvec;
   
   --funcao
	function stdvec_to_str(inp: std_logic_vector) return string is
		variable temp: string(inp'left+1 downto 1);
	begin
		for i in inp'reverse_range loop
			if (inp(i) = '1') then
				temp(i+1) := '1';
			elsif (inp(i) = '0') then
				temp(i+1) := '0';
			end if;
		end loop;
		return temp;
	end function stdvec_to_str;
   
	   --entradas e saídas
	signal flag: std_logic := '0';
	signal flag_never: std_logic := '0';
	signal clk,reset: std_logic := '1';
	signal dinb 	: std_logic_vector(63 DOWNTO 0);
	signal i: integer range 0 to NUM_MEMORIES-1;

	signal start, start_architecture, start_write_buffer, delay_start_write_buffer, start_read_buffer, start_init_line, delay_start_init_line, vectors_ready: std_logic := '0';
	signal sig_fill_blk: std_logic;
	file infile, infile_blk, outfile: text;
	
	
	signal motion_vector_x: std_logic_vector(4 DOWNTO 0);
	signal motion_vector_y: std_logic_vector(4 DOWNTO 0);
	
	signal best_sad: std_logic_vector(DATA_WIDTH-1 + LEVELS-1 DOWNTO 0);
	signal end_search: std_logic;
	signal entrada_blk: REG_ROWS;

	signal words_blk: std_logic_vector(MEM_PORT_B_WIDTH-1 DOWNTO 0);
				
begin

	clockgen :PROCESS 
	BEGIN
		clk <= '1', '0' AFTER 20 ns;
		WAIT FOR 40 ns;
	END PROCESS;
	
	resetgen :PROCESS 
	BEGIN
		wait until (clk'event and clk='0');
		wait until (clk'event and clk='0');
		reset <= '0';
		wait until (clk'event and clk='0' and flag_never = '1');
		
	END PROCESS;

	delayBuffer: PROCESS
	BEGIN
		wait until (start_write_buffer = '1');
		wait until (clk'event and clk='0');
		wait until (clk'event and clk='0');
		delay_start_write_buffer <= '1';
		wait until (clk'event and clk='0');
		delay_start_write_buffer <= '0';
	END PROCESS;
	
	delayInit: PROCESS
	BEGIN
		wait until (start_init_line = '1');
		wait until (clk'event and clk='0');
		wait until (clk'event and clk='0');
		delay_start_init_line <= '1';
		wait until (clk'event and clk='0');
		delay_start_init_line <= '0';
	END PROCESS;
	
	startgen :PROCESS 
		variable i: integer;
	BEGIN
		
		wait until (reset = '0');
		wait until (clk'event and clk='0');
		start_architecture <= '1';
		wait until (clk'event and clk='0');
		start_architecture <= '0';
		wait until (clk'event and clk='0' and flag_never = '1');
		
	END PROCESS;
	
	estimulos_entrada_blk: process
		variable i, j, k, count: integer;
		variable linha: line;
		variable linhaStr: string(8 downto 1);
		variable linhaVec: std_logic_vector(7 downto 0);
		variable blocksPerLine: integer := BLOCKS_PER_LINE;
	begin
      
		FILE_OPEN(infile_blk, "..\C\entrada_bloco.txt", READ_MODE);
		
		while not endfile(infile_blk) loop
		
			wait until (sig_fill_blk = '1');
			wait until (clk'event and clk='0');
			wait until (clk'event and clk='0');
			--Lendo os valores do bloco
			i:=0;
			while(i<8) loop
				j:=0;
				while (j<8) loop
					readline(infile_blk, linha);
					read(linha, linhaStr);
					words_blk((((j+1)*8)-1) DOWNTO j*8) <= str_to_stdvec(linhaStr);	
					j := j+1;
				end loop;
				i := i+1;
				wait until (clk'event and clk='0');
			end loop;
		end loop;
		
		file_close(infile);
		wait until (flag_never = '1');
	
	end process;
	
	estimulos_entrada: process
		variable i, j, k, count: integer;
		variable linha: line;
		variable linhaStr: string(8 downto 1);
		variable linhaVec: std_logic_vector(7 downto 0);
		variable blocksPerLine: integer := BLOCKS_PER_LINE;
	begin
      
		
		--FILE_OPEN(infile, "..\C\2010_12_02_bloco_16_48.txt", READ_MODE);	
		--FILE_OPEN(infile, "..\C\2010_12_02_entrada_TODOS.txt", READ_MODE);	
		--FILE_OPEN(infile, "..\C\2010_12_04_entrada_VARIOS_QUADROS.txt", READ_MODE);
		--FILE_OPEN(infile, "..\C\2010_12_03_entrada_blk_24_80.txt", READ_MODE);	
		--FILE_OPEN(infile, "..\C\2010_12_09_entrada_varios_quadros_akiyo.txt", READ_MODE);
		FILE_OPEN(infile, "..\C\entrada_ref.txt", READ_MODE);
		
		--Primeira linha
		count := 0;
	
		wait until (start_architecture = '1');
		wait until (clk'event and clk='0');
		
		--lendo valores da área de pesquisa
		k := 0;
		while (k<32) loop			
			i:=0;
			while(i<4) loop
				j:=0;
				while (j<8) loop
					readline(infile, linha);
					read(linha, linhaStr);
					dinb((((j+1)*8)-1) DOWNTO j*8) <= str_to_stdvec(linhaStr);
					j := j+1;
				end loop;
				i := i+1;
				wait until (clk'event and clk='0');
			end loop;
			k:= k+1;
		end loop;
		
		count := count + 1;
		
		while ( (count < blocksPerLine) and (not endfile(infile)) ) loop
			
			wait until (delay_start_write_buffer = '1');
			--wait until (clk'event and clk = '1');
					
			--lendo valores do 1/4 da área de pesquisa
			k := 0;
			while (k<32) loop			
				j:=0;
				while (j<8) loop
					readline(infile, linha);
					read(linha, linhaStr);
					dinb((((j+1)*8)-1) DOWNTO j*8) <= str_to_stdvec(linhaStr);
					j := j+1;
				end loop;
				wait until (clk'event and clk='0');
				k:= k+1;
			end loop;
			
			wait until ( end_search = '1');
			
			wait until (clk'event and clk='0');
			wait until (clk'event and clk='0');
			wait until (clk'event and clk='0');
			wait until (clk'event and clk='0');
			wait until (clk'event and clk='0');
			wait until (clk'event and clk='0');
			wait until (clk'event and clk='0');
			
			wait until (clk'event and clk='0');
						
			count := count + 1;

		end loop;
		
		
		--Segunda linha em diante
		
		while not endfile(infile) loop
			
			count := 0;
		
			wait until (delay_start_init_line = '1');
			
			--lendo valores da área de pesquisa
			k := 0;
			while (k<32) loop			
				i:=0;
				while(i<4) loop
					j:=0;
					while (j<8) loop
						readline(infile, linha);
						read(linha, linhaStr);
						dinb((((j+1)*8)-1) DOWNTO j*8) <= str_to_stdvec(linhaStr);
						j := j+1;
					end loop;
					i := i+1;
					wait until (clk'event and clk='0');
				end loop;
				k:= k+1;
			end loop;
			
			count := count + 1;
			
			while ( (count < blocksPerLine) and (not endfile(infile)) ) loop
				
				wait until (delay_start_write_buffer = '1');
				--wait until (clk'event and clk = '1');
						
				--lendo valores do 1/4 da área de pesquisa
				k := 0;
				while (k<32) loop			
					j:=0;
					while (j<8) loop
						readline(infile, linha);
						read(linha, linhaStr);
						dinb((((j+1)*8)-1) DOWNTO j*8) <= str_to_stdvec(linhaStr);
						j := j+1;
					end loop;
					wait until (clk'event and clk='0');
					k:= k+1;
				end loop;
				
				wait until ( end_search = '1');
				
				wait until (clk'event and clk='0');
				wait until (clk'event and clk='0');
				wait until (clk'event and clk='0');
				wait until (clk'event and clk='0');
				wait until (clk'event and clk='0');
				wait until (clk'event and clk='0');
				wait until (clk'event and clk='0');
							
				count := count + 1;

			end loop;
			
			--wait until (flag_never = '1');
	
		end loop;

		flag <= '1';

		file_close(infile);
		wait until (flag_never = '1');
	
	end process;
		
	estimulos_saida: process
	variable i,j: integer;
	variable outVector: string(5 downto 1);
	variable outSad: string(14 downto 1);
	variable linha: line;
	variable vecX, vecY: integer;
	variable sadResult: integer;
	--
	begin
		--FILE_OPEN(outfile,"..\C\2010_12_02_BLK_24_80_motion_vectors_sads_HW.txt", WRITE_MODE);
		--FILE_OPEN(outfile,"..\C\2010_12_03_TODOS_motion_vectors_sads_HW.txt", WRITE_MODE);
		--FILE_OPEN(outfile,"..\C\2010_12_04_VARIOS_QUADROS_motion_vectors_sads_HW.txt", WRITE_MODE);
		--FILE_OPEN(outfile,"..\C\2010_12_09_VARIOS_QUADROS_motion_vectors_sads_HW_akiyo.txt", WRITE_MODE);
		FILE_OPEN(outfile,"..\C\2011_11_13_results_HW_akyio.txt", WRITE_MODE);
	
		while (flag /= '1') loop
		
			wait until (vectors_ready = '1');
			
			vecX :=  to_integer(signed(motion_vector_x));
			vecY := to_integer(signed(motion_vector_y));
			sadResult := to_integer(unsigned(best_sad));
			
			--outVector := stdvec_to_str(motion_vector_x);
			--write(linha,outVector);
			--writeline(outfile,linha);
			write(linha,vecX);
			writeline(outfile,linha);
			
			--outVector := stdvec_to_str(motion_vector_y);
			--write(linha,outVector);
			--writeline(outfile,linha);
			write(linha,vecY);
			writeline(outfile,linha);
			
			--outSad := stdvec_to_str(best_sad);
			--write(linha,outSad);
			--writeline(outfile,linha);
			write(linha,sadResult);
			writeline(outfile,linha);
			
			wait until(clk'event and clk='0');
		end loop;

		wait until (vectors_ready = '1');
			
		vecX :=  to_integer(signed(motion_vector_x));
		vecY := to_integer(signed(motion_vector_y));
		sadResult := to_integer(unsigned(best_sad));
		
		outVector := stdvec_to_str(motion_vector_x);
		--write(linha,outVector);
		--writeline(outfile,linha);
		write(linha,vecX);
		writeline(outfile,linha);
		
		outVector := stdvec_to_str(motion_vector_y);
		--write(linha,outVector);
		--writeline(outfile,linha);
		write(linha,vecY);
		writeline(outfile,linha);
		
		outSad := stdvec_to_str(best_sad);
		--write(linha,outSad);
		--writeline(outfile,linha);
		write(linha,sadResult);
		writeline(outfile,linha);
		
		file_close(outfile);

	end process;
	
		
	MAP_Total_Architecture: total_architecture 
		port map(
			clk => clk,
			rst => reset,
			
			word_external_memory => dinb,
			start_architecture => start_architecture,
			out_start_write_buffer => start_write_buffer,
			out_start_init_line => start_init_line,
			words_blk	=> words_blk,
			--sig_blk => entrada_blk,
			vectors_ready		=> vectors_ready,
			
			motion_vector_x => motion_vector_x,
			motion_vector_y => motion_vector_y,
		
			end_search		=> end_search,
			best_sad		=> best_sad,
			start_reference_manager_fill_mp0_out => sig_fill_blk
			
		);
		
end comportamento;
