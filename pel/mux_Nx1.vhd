library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.all;
use work.motion_estimation_8x8_package.all;


ENTITY mux_Nx1 is
	GENERIC(
		VECT_SIZE : integer := 8;
		INPUT_LENGTH : integer := 32;
		SEL_LENGTH : integer := 5
	);
	PORT ( 
		muxin : in MEM_PORT_A_DATAS;
		muxout : out std_logic_vector(VECT_SIZE - 1 downto 0);
		sel : in std_logic_vector(SEL_LENGTH - 1 downto 0)
	);
end mux_Nx1;

architecture behaviour of mux_Nx1 is

begin
	muxout <= muxin(to_integer(unsigned(sel)));
end behaviour;

