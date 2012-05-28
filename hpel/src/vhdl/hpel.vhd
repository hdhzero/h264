library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.hpel_package.all;

entity hpel is
    port (
        clock : in std_logic;
        reset : in std_logic;
        din   : in hpel_i;
        dout  : out hpel_o
    );
end hpel;

architecture hpel of hpel is
    signal mb_buffer_din  : hp_macroblock_buffer_i;
    signal mb_buffer_dout : hp_macroblock_buffer_o;

    signal hp_interpolator_din  : hp_interpolator_i;
    signal hp_interpolator_dout : hp_interpolator_o;
begin
    dout.done <= din.start;

    hp_macroblock_buffer_u : hp_macroblock_buffer
    port map (
        clock => clock,
        din   => mb_buffer_din,
        dout  => mb_buffer_dout
    );

    hp_interpolator_u : hp_interpolator
    port map (
        clock => clock,
        reset => reset,
        din   => hp_interpolator_din,
        dout  => hp_interpolator_dout
    );
end hpel;


