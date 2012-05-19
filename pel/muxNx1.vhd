library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.all;
use work.motion_estimation_8x8_package.all;


entity muxNx1 is
	generic
	(
		N				: integer 	:= 8;
		DATA_WIDTH		: integer  	:=	8
	);
	port
	(
		-- Input ports
		sel		: in integer RANGE 0 TO N-1;
		datas	: in  IN_MUX;
	-- Output ports
		data_out : out std_logic_vector(DATA_WIDTH-1 DOWNTO 0)
	);
end entity;

architecture behaviour of muxNx1 is
begin
	data_out <= datas(sel);
end behaviour;

