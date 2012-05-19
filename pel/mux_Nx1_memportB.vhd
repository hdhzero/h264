library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.all;
use work.motion_estimation_8x8_package.all;


ENTITY mux_Nx1_memportB is
	GENERIC(
		VECT_SIZE : integer := 64;
		INPUT_LENGTH : integer := 32;
		SEL_LENGTH : integer := 5
	);
	PORT ( 
		muxin : in MEM_PORT_B_DATAS;
		muxout : out std_logic_vector(VECT_SIZE - 1 downto 0);
		sel : in std_logic_vector(SEL_LENGTH - 1 downto 0)
	);
end mux_Nx1_memportB;

architecture behaviour of mux_Nx1_memportB is

begin
	selection:
		with sel select
		muxout <= 
					muxin(0) when "00000",
					muxin(1) when "00001",
					muxin(2) when "00010",
					muxin(3) when "00011",
					muxin(4) when "00100",
					muxin(5) when "00101",
					muxin(6) when "00110",
					muxin(7) when "00111",
					
					muxin(8) when "01000",
					muxin(9) when "01001",
					muxin(10) when "01010",
					muxin(11) when "01011",
					muxin(12) when "01100",
					muxin(13) when "01101",
					muxin(14) when "01110",
					muxin(15) when "01111",
					
					muxin(16) when "10000",
					muxin(17) when "10001",
					muxin(18) when "10010",
					muxin(19) when "10011",
					muxin(20) when "10100",
					muxin(21) when "10101",
					muxin(22) when "10110",
					muxin(23) when "10111",
					
					muxin(24) when "11000",
					muxin(25) when "11001",
					muxin(26) when "11010",
					muxin(27) when "11011",
					muxin(28) when "11100",
					muxin(29) when "11101",
					muxin(30) when "11110",
					muxin(31) when "11111";
end behaviour;

