library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity col_interpolator is
    port (
        a : in std_logic_vector(135 downto 0);
        b : in std_logic_vector(135 downto 0);
        s : out std_logic_vector(135 downto 0)
    );
end col_interpolator;

architecture col_interpolator of col_interpolator is
begin

    fir_00 : filter
    port map (a(7 downto 0), b(7 downto 0), s(7 downto 0));

    fir_01 : filter
    port map (a(15 downto 8), b(15 downto 8), s(15 downto 8));

    fir_02 : filter
    port map (a(23 downto 16), b(23 downto 16), s(23 downto 16));

    fir_03 : filter
    port map (a(31 downto 24), b(31 downto 24), s(31 downto 24));

    fir_04 : filter
    port map (a(39 downto 32), b(39 downto 32), s(39 downto 32));

    fir_05 : filter
    port map (a(47 downto 40), b(47 downto 40), s(47 downto 40));

    fir_06 : filter
    port map (a(55 downto 48), b(55 downto 48), s(55 downto 48));

    fir_07 : filter
    port map (a(63 downto 56), b(63 downto 56), s(63 downto 56));

    fir_08 : filter
    port map (a(71 downto 64), b(71 downto 64), s(71 downto 64));

    fir_09 : filter
    port map (a(79 downto 72), b(79 downto 72), s(79 downto 72));

    fir_10 : filter
    port map (a(87 downto 80), b(87 downto 80), s(87 downto 80));

    fir_11 : filter
    port map (a(95 downto 88), b(95 downto 88), s(95 downto 88));

    fir_12 : filter
    port map (a(103 downto 96), b(103 downto 96), s(103 downto 96));

    fir_13 : filter
    port map (a(111 downto 104), b(111 downto 104), s(111 downto 104));

    fir_14 : filter
    port map (a(119 downto 112), b(119 downto 112), s(119 downto 112));

    fir_15 : filter
    port map (a(127 downto 120), b(127 downto 120), s(127 downto 120));

    fir_16 : filter
    port map (a(135 downto 128), b(135 downto 128), s(135 downto 128));

end col_interpolator;
