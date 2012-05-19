library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.all;
use work.motion_estimation_8x8_package.all;


ENTITY mux_32x1 is
	GENERIC(
		VECT_SIZE : integer := 64
	);
	PORT ( 
		muxin_0 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_1 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_2 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_3 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_4 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_5 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_6 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_7 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_8 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_9 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_10 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_11 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_12 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_13 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_14 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_15 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_16 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_17 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_18 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_19 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_20 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_21 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_22 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_23 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_24 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_25 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_26 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_27 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_28 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_29 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_30 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxin_31 : in std_logic_vector(VECT_SIZE - 1 downto 0);
		muxout : out std_logic_vector(VECT_SIZE - 1 downto 0);
		sel : in std_logic_vector(4 downto 0)
	);
end mux_32x1;

architecture behaviour of mux_32x1 is

begin
	selection:
		with sel select
		muxout <= 
					muxin_0 when "00000",
					muxin_1 when "00001",
					muxin_2 when "00010",
					muxin_3 when "00011",
					muxin_4 when "00100",
					muxin_5 when "00101",
					muxin_6 when "00110",
					muxin_7 when "00111",
					
					muxin_8 when "01000",
					muxin_9 when "01001",
					muxin_10 when "01010",
					muxin_11 when "01011",
					muxin_12 when "01100",
					muxin_13 when "01101",
					muxin_14 when "01110",
					muxin_15 when "01111",
					
					muxin_16 when "10000",
					muxin_17 when "10001",
					muxin_18 when "10010",
					muxin_19 when "10011",
					muxin_20 when "10100",
					muxin_21 when "10101",
					muxin_22 when "10110",
					muxin_23 when "10111",
					
					muxin_24 when "11000",
					muxin_25 when "11001",
					muxin_26 when "11010",
					muxin_27 when "11011",
					muxin_28 when "11100",
					muxin_29 when "11101",
					muxin_30 when "11110",
					muxin_31 when "11111",
					
					muxin_0 when others;
end behaviour;

