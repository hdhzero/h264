library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity mux16x1 is
	generic
	(
		N	: integer  :=	4;
		SIZE_SEL: integer := 4
	);
	port
	(
		-- Input ports
		sel		: in std_logic_vector(SIZE_SEL-1 DOWNTO 0);
		data_0	: in  std_logic_vector(N-1 DOWNTO 0);
		data_1	: in  std_logic_vector(N-1 DOWNTO 0);
		data_2	: in  std_logic_vector(N-1 DOWNTO 0);
		data_3	: in  std_logic_vector(N-1 DOWNTO 0);
		data_4	: in  std_logic_vector(N-1 DOWNTO 0);
		data_5	: in  std_logic_vector(N-1 DOWNTO 0);
		data_6	: in  std_logic_vector(N-1 DOWNTO 0);
		data_7	: in  std_logic_vector(N-1 DOWNTO 0);
		data_8	: in  std_logic_vector(N-1 DOWNTO 0);
		data_9	: in  std_logic_vector(N-1 DOWNTO 0);
		data_10	: in  std_logic_vector(N-1 DOWNTO 0);
		data_11	: in  std_logic_vector(N-1 DOWNTO 0);
		data_12	: in  std_logic_vector(N-1 DOWNTO 0);
		data_13	: in  std_logic_vector(N-1 DOWNTO 0);
		data_14	: in  std_logic_vector(N-1 DOWNTO 0);
		data_15	: in  std_logic_vector(N-1 DOWNTO 0);
		-- Output ports
		data_out : out std_logic_vector(N-1 DOWNTO 0)
	);
end entity;

architecture behaviour of mux16x1 is
begin
	selection:
		with sel select
		data_out <= 
					data_0 when "0000",
					data_1 when "0001",
					data_2 when "0010",
					data_3 when "0011",
					data_4 when "0100",
					data_5 when "0101",
					data_6 when "0110",
					data_7 when "0111",
					data_8 when "1000",
					data_9 when "1001",
					data_10 when "1010",
					data_11 when "1011",	
					data_12 when "1100",
					data_13 when "1101",
					data_14 when "1110",
					data_15 when "1111",
					data_0 when others;
end behaviour;

