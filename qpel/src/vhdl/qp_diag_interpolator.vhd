library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.qpel_package.all;

entity qp_diag_interpolator is
    port (
        din  : in qp_diag_interpolator_i;
        dout : out qp_diag_interpolator_o
    );
end qp_diag_interpolator;

architecture qp_diag_interpolator of qp_diag_interpolator is
    signal s0 : std_logic_vector(143 downto 0);
    signal s1 : std_logic_vector(143 downto 0);
begin
    process(din.a, din.b, din.sel)
    begin
        case din.sel is
            when '0' =>
                s0(7 downto 0) <= din.a(7 downto 0);
                s1(7 downto 0) <= din.b(15 downto 8);
                s0(15 downto 8) <= din.a(23 downto 16);
                s1(15 downto 8) <= din.b(15 downto 8);
                s0(23 downto 16) <= din.a(23 downto 16);
                s1(23 downto 16) <= din.b(31 downto 24);
                s0(31 downto 24) <= din.a(39 downto 32);
                s1(31 downto 24) <= din.b(31 downto 24);
                s0(39 downto 32) <= din.a(39 downto 32);
                s1(39 downto 32) <= din.b(47 downto 40);
                s0(47 downto 40) <= din.a(55 downto 48);
                s1(47 downto 40) <= din.b(47 downto 40);
                s0(55 downto 48) <= din.a(55 downto 48);
                s1(55 downto 48) <= din.b(63 downto 56);
                s0(63 downto 56) <= din.a(71 downto 64);
                s1(63 downto 56) <= din.b(63 downto 56);
                s0(71 downto 64) <= din.a(71 downto 64);
                s1(71 downto 64) <= din.b(79 downto 72);
                s0(79 downto 72) <= din.a(87 downto 80);
                s1(79 downto 72) <= din.b(79 downto 72);
                s0(87 downto 80) <= din.a(87 downto 80);
                s1(87 downto 80) <= din.b(95 downto 88);
                s0(95 downto 88) <= din.a(103 downto 96);
                s1(95 downto 88) <= din.b(95 downto 88);
                s0(103 downto 96) <= din.a(103 downto 96);
                s1(103 downto 96) <= din.b(111 downto 104);
                s0(111 downto 104) <= din.a(119 downto 112);
                s1(111 downto 104) <= din.b(111 downto 104);
                s0(119 downto 112) <= din.a(119 downto 112);
                s1(119 downto 112) <= din.b(127 downto 120);
                s0(127 downto 120) <= din.a(135 downto 128);
                s1(127 downto 120) <= din.b(127 downto 120);
                s0(135 downto 128) <= din.a(135 downto 128);
                s1(135 downto 128) <= din.b(143 downto 136);
                s0(143 downto 136) <= din.a(151 downto 144);
                s1(143 downto 136) <= din.b(143 downto 136);
            when others =>
                s0(7 downto 0) <= din.a(15 downto 8);
                s1(7 downto 0) <= din.b(7 downto 0);
                s0(15 downto 8) <= din.a(15 downto 8);
                s1(15 downto 8) <= din.b(23 downto 16);
                s0(23 downto 16) <= din.a(31 downto 24);
                s1(23 downto 16) <= din.b(23 downto 16);
                s0(31 downto 24) <= din.a(31 downto 24);
                s1(31 downto 24) <= din.b(39 downto 32);
                s0(39 downto 32) <= din.a(47 downto 40);
                s1(39 downto 32) <= din.b(39 downto 32);
                s0(47 downto 40) <= din.a(47 downto 40);
                s1(47 downto 40) <= din.b(55 downto 48);
                s0(55 downto 48) <= din.a(63 downto 56);
                s1(55 downto 48) <= din.b(55 downto 48);
                s0(63 downto 56) <= din.a(63 downto 56);
                s1(63 downto 56) <= din.b(71 downto 64);
                s0(71 downto 64) <= din.a(79 downto 72);
                s1(71 downto 64) <= din.b(71 downto 64);
                s0(79 downto 72) <= din.a(79 downto 72);
                s1(79 downto 72) <= din.b(87 downto 80);
                s0(87 downto 80) <= din.a(95 downto 88);
                s1(87 downto 80) <= din.b(87 downto 80);
                s0(95 downto 88) <= din.a(95 downto 88);
                s1(95 downto 88) <= din.b(103 downto 96);
                s0(103 downto 96) <= din.a(111 downto 104);
                s1(103 downto 96) <= din.b(103 downto 96);
                s0(111 downto 104) <= din.a(111 downto 104);
                s1(111 downto 104) <= din.b(119 downto 112);
                s0(119 downto 112) <= din.a(127 downto 120);
                s1(119 downto 112) <= din.b(119 downto 112);
                s0(127 downto 120) <= din.a(127 downto 120);
                s1(127 downto 120) <= din.b(135 downto 128);
                s0(135 downto 128) <= din.a(143 downto 136);
                s1(135 downto 128) <= din.b(135 downto 128);
                s0(143 downto 136) <= din.a(143 downto 136);
                s1(143 downto 136) <= din.b(151 downto 144);
        end case;
    end process;

    fir_00 : qp_filter
    port map (din.a => s0(7 downto 0), din.b => s1(7 downto 0), dout.s => dout.s(7 downto 0));

    fir_01 : qp_filter
    port map (din.a => s0(15 downto 8), din.b => s1(15 downto 8), dout.s => dout.s(15 downto 8));

    fir_02 : qp_filter
    port map (din.a => s0(23 downto 16), din.b => s1(23 downto 16), dout.s => dout.s(23 downto 16));

    fir_03 : qp_filter
    port map (din.a => s0(31 downto 24), din.b => s1(31 downto 24), dout.s => dout.s(31 downto 24));

    fir_04 : qp_filter
    port map (din.a => s0(39 downto 32), din.b => s1(39 downto 32), dout.s => dout.s(39 downto 32));

    fir_05 : qp_filter
    port map (din.a => s0(47 downto 40), din.b => s1(47 downto 40), dout.s => dout.s(47 downto 40));

    fir_06 : qp_filter
    port map (din.a => s0(55 downto 48), din.b => s1(55 downto 48), dout.s => dout.s(55 downto 48));

    fir_07 : qp_filter
    port map (din.a => s0(63 downto 56), din.b => s1(63 downto 56), dout.s => dout.s(63 downto 56));

    fir_08 : qp_filter
    port map (din.a => s0(71 downto 64), din.b => s1(71 downto 64), dout.s => dout.s(71 downto 64));

    fir_09 : qp_filter
    port map (din.a => s0(79 downto 72), din.b => s1(79 downto 72), dout.s => dout.s(79 downto 72));

    fir_10 : qp_filter
    port map (din.a => s0(87 downto 80), din.b => s1(87 downto 80), dout.s => dout.s(87 downto 80));

    fir_11 : qp_filter
    port map (din.a => s0(95 downto 88), din.b => s1(95 downto 88), dout.s => dout.s(95 downto 88));

    fir_12 : qp_filter
    port map (din.a => s0(103 downto 96), din.b => s1(103 downto 96), dout.s => dout.s(103 downto 96));

    fir_13 : qp_filter
    port map (din.a => s0(111 downto 104), din.b => s1(111 downto 104), dout.s => dout.s(111 downto 104));

    fir_14 : qp_filter
    port map (din.a => s0(119 downto 112), din.b => s1(119 downto 112), dout.s => dout.s(119 downto 112));

    fir_15 : qp_filter
    port map (din.a => s0(127 downto 120), din.b => s1(127 downto 120), dout.s => dout.s(127 downto 120));

    fir_16 : qp_filter
    port map (din.a => s0(135 downto 128), din.b => s1(135 downto 128), dout.s => dout.s(135 downto 128));

    fir_17 : qp_filter
    port map (din.a => s0(143 downto 136), din.b => s1(143 downto 136), dout.s => dout.s(143 downto 136));

end qp_diag_interpolator;
