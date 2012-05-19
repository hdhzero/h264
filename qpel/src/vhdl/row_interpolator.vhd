library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.qpel_package.all;

entity row_interpolator is
    port (
        a : in std_logic_vector(151 downto 0);
        s : out std_logic_vector(143 downto 0)
    );
end row_interpolator;

architecture row_interpolator of row_interpolator is
begin
    fir_00 : filter
    port map (a(15 downto 8), a(7 downto 0), s(7 downto 0));

    fir_01 : filter
    port map (a(23 downto 16), a(15 downto 8), s(15 downto 8));

    fir_02 : filter
    port map (a(31 downto 24), a(23 downto 16), s(23 downto 16));

    fir_03 : filter
    port map (a(39 downto 32), a(31 downto 24), s(31 downto 24));

    fir_04 : filter
    port map (a(47 downto 40), a(39 downto 32), s(39 downto 32));

    fir_05 : filter
    port map (a(55 downto 48), a(47 downto 40), s(47 downto 40));

    fir_06 : filter
    port map (a(63 downto 56), a(55 downto 48), s(55 downto 48));

    fir_07 : filter
    port map (a(71 downto 64), a(63 downto 56), s(63 downto 56));

    fir_08 : filter
    port map (a(79 downto 72), a(71 downto 64), s(71 downto 64));

    fir_09 : filter
    port map (a(87 downto 80), a(79 downto 72), s(79 downto 72));

    fir_10 : filter
    port map (a(95 downto 88), a(87 downto 80), s(87 downto 80));

    fir_11 : filter
    port map (a(103 downto 96), a(95 downto 88), s(95 downto 88));

    fir_12 : filter
    port map (a(111 downto 104), a(103 downto 96), s(103 downto 96));

    fir_13 : filter
    port map (a(119 downto 112), a(111 downto 104), s(111 downto 104));

    fir_14 : filter
    port map (a(127 downto 120), a(119 downto 112), s(119 downto 112));

    fir_15 : filter
    port map (a(135 downto 128), a(127 downto 120), s(127 downto 120));

    fir_16 : filter
    port map (a(143 downto 136), a(135 downto 128), s(135 downto 128));

    fir_17 : filter
    port map (a(151 downto 144), a(143 downto 136), s(143 downto 136));

end row_interpolator;
