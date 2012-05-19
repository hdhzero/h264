library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity mux8x1 is
	generic
	(
		N		: integer  	:=	8
	);
	port
	(
		-- Input ports
		sel		: in std_logic_vector(2 DOWNTO 0);
		data_0	: in  std_logic_vector(N-1 DOWNTO 0);
		data_1	: in  std_logic_vector(N-1 DOWNTO 0);
		data_2	: in  std_logic_vector(N-1 DOWNTO 0);
		data_3	: in  std_logic_vector(N-1 DOWNTO 0);
		data_4	: in  std_logic_vector(N-1 DOWNTO 0);
		data_5	: in  std_logic_vector(N-1 DOWNTO 0);
		data_6	: in  std_logic_vector(N-1 DOWNTO 0);
		data_7	: in  std_logic_vector(N-1 DOWNTO 0);
	-- Output ports
		data_out : out std_logic_vector(N-1 DOWNTO 0)
	);
end entity;

architecture behaviour of mux8x1 is
begin
	selection:
		with sel select
		data_out <= 
					data_0 when "000",
					data_1 when "001",
					data_2 when "010",
					data_3 when "011",
					data_4 when "100",
					data_5 when "101",
					data_6 when "110",
					data_7 when "111",
					data_0 when others;
end behaviour;

