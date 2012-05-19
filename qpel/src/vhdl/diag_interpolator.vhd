library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.qpel_package.all;

entity diag_interpolator is
    port (
        sel : in std_logic;
        a : in std_logic_vector(151 downto 0);
        b : in std_logic_vector(151 downto 0);
        s : out std_logic_vector(143 downto 0)
    );
end diag_interpolator;

architecture diag_interpolator of diag_interpolator is
    signal s0 : std_logic_vector(143 downto 0);
    signal s1 : std_logic_vector(143 downto 0);
begin
    process(a, b, sel)
    begin
        case sel is
            when '0' =>
                s0(7 downto 0) <= a(7 downto 0);
                s1(7 downto 0) <= b(15 downto 8);
                s0(15 downto 8) <= a(23 downto 16);
                s1(15 downto 8) <= b(15 downto 8);
                s0(23 downto 16) <= a(23 downto 16);
                s1(23 downto 16) <= b(31 downto 24);
                s0(31 downto 24) <= a(39 downto 32);
                s1(31 downto 24) <= b(31 downto 24);
                s0(39 downto 32) <= a(39 downto 32);
                s1(39 downto 32) <= b(47 downto 40);
                s0(47 downto 40) <= a(55 downto 48);
                s1(47 downto 40) <= b(47 downto 40);
                s0(55 downto 48) <= a(55 downto 48);
                s1(55 downto 48) <= b(63 downto 56);
                s0(63 downto 56) <= a(71 downto 64);
                s1(63 downto 56) <= b(63 downto 56);
                s0(71 downto 64) <= a(71 downto 64);
                s1(71 downto 64) <= b(79 downto 72);
                s0(79 downto 72) <= a(87 downto 80);
                s1(79 downto 72) <= b(79 downto 72);
                s0(87 downto 80) <= a(87 downto 80);
                s1(87 downto 80) <= b(95 downto 88);
                s0(95 downto 88) <= a(103 downto 96);
                s1(95 downto 88) <= b(95 downto 88);
                s0(103 downto 96) <= a(103 downto 96);
                s1(103 downto 96) <= b(111 downto 104);
                s0(111 downto 104) <= a(119 downto 112);
                s1(111 downto 104) <= b(111 downto 104);
                s0(119 downto 112) <= a(119 downto 112);
                s1(119 downto 112) <= b(127 downto 120);
                s0(127 downto 120) <= a(135 downto 128);
                s1(127 downto 120) <= b(127 downto 120);
                s0(135 downto 128) <= a(135 downto 128);
                s1(135 downto 128) <= b(143 downto 136);
                s0(143 downto 136) <= a(151 downto 144);
                s1(143 downto 136) <= b(143 downto 136);
            when others =>
                s0(7 downto 0) <= a(15 downto 8);
                s1(7 downto 0) <= b(7 downto 0);
                s0(15 downto 8) <= a(15 downto 8);
                s1(15 downto 8) <= b(23 downto 16);
                s0(23 downto 16) <= a(31 downto 24);
                s1(23 downto 16) <= b(23 downto 16);
                s0(31 downto 24) <= a(31 downto 24);
                s1(31 downto 24) <= b(39 downto 32);
                s0(39 downto 32) <= a(47 downto 40);
                s1(39 downto 32) <= b(39 downto 32);
                s0(47 downto 40) <= a(47 downto 40);
                s1(47 downto 40) <= b(55 downto 48);
                s0(55 downto 48) <= a(63 downto 56);
                s1(55 downto 48) <= b(55 downto 48);
                s0(63 downto 56) <= a(63 downto 56);
                s1(63 downto 56) <= b(71 downto 64);
                s0(71 downto 64) <= a(79 downto 72);
                s1(71 downto 64) <= b(71 downto 64);
                s0(79 downto 72) <= a(79 downto 72);
                s1(79 downto 72) <= b(87 downto 80);
                s0(87 downto 80) <= a(95 downto 88);
                s1(87 downto 80) <= b(87 downto 80);
                s0(95 downto 88) <= a(95 downto 88);
                s1(95 downto 88) <= b(103 downto 96);
                s0(103 downto 96) <= a(111 downto 104);
                s1(103 downto 96) <= b(103 downto 96);
                s0(111 downto 104) <= a(111 downto 104);
                s1(111 downto 104) <= b(119 downto 112);
                s0(119 downto 112) <= a(127 downto 120);
                s1(119 downto 112) <= b(119 downto 112);
                s0(127 downto 120) <= a(127 downto 120);
                s1(127 downto 120) <= b(135 downto 128);
                s0(135 downto 128) <= a(143 downto 136);
                s1(135 downto 128) <= b(135 downto 128);
                s0(143 downto 136) <= a(143 downto 136);
                s1(143 downto 136) <= b(151 downto 144);
        end case;
    end process;

    fir_00 : filter
    port map (s0(7 downto 0), s1(7 downto 0), s(7 downto 0));

    fir_01 : filter
    port map (s0(15 downto 8), s1(15 downto 8), s(15 downto 8));

    fir_02 : filter
    port map (s0(23 downto 16), s1(23 downto 16), s(23 downto 16));

    fir_03 : filter
    port map (s0(31 downto 24), s1(31 downto 24), s(31 downto 24));

    fir_04 : filter
    port map (s0(39 downto 32), s1(39 downto 32), s(39 downto 32));

    fir_05 : filter
    port map (s0(47 downto 40), s1(47 downto 40), s(47 downto 40));

    fir_06 : filter
    port map (s0(55 downto 48), s1(55 downto 48), s(55 downto 48));

    fir_07 : filter
    port map (s0(63 downto 56), s1(63 downto 56), s(63 downto 56));

    fir_08 : filter
    port map (s0(71 downto 64), s1(71 downto 64), s(71 downto 64));

    fir_09 : filter
    port map (s0(79 downto 72), s1(79 downto 72), s(79 downto 72));

    fir_10 : filter
    port map (s0(87 downto 80), s1(87 downto 80), s(87 downto 80));

    fir_11 : filter
    port map (s0(95 downto 88), s1(95 downto 88), s(95 downto 88));

    fir_12 : filter
    port map (s0(103 downto 96), s1(103 downto 96), s(103 downto 96));

    fir_13 : filter
    port map (s0(111 downto 104), s1(111 downto 104), s(111 downto 104));

    fir_14 : filter
    port map (s0(119 downto 112), s1(119 downto 112), s(119 downto 112));

    fir_15 : filter
    port map (s0(127 downto 120), s1(127 downto 120), s(127 downto 120));

    fir_16 : filter
    port map (s0(135 downto 128), s1(135 downto 128), s(135 downto 128));

    fir_17 : filter
    port map (s0(143 downto 136), s1(143 downto 136), s(143 downto 136));

end diag_interpolator;
