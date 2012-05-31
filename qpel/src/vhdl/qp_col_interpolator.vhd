library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.qpel_package.all;

entity qp_col_interpolator is
    port (
        din  : in qp_col_interpolator_i;
        dout : out qp_col_interpolator_o
    );
end qp_col_interpolator;

architecture qp_col_interpolator of qp_col_interpolator is
begin

    fir_00 : qp_filter
    port map (
        din.a => din.a(7 downto 0), din.b => din.b(7 downto 0), dout.s => dout.s(7 downto 0));

    fir_01 : qp_filter
    port map (din.a => din.a(15 downto 8), din.b => din.b(15 downto 8), dout.s => dout.s(15 downto 8));

    fir_02 : qp_filter
    port map (din.a => din.a(23 downto 16), din.b => din.b(23 downto 16), dout.s => dout.s(23 downto 16));

    fir_03 : qp_filter
    port map (din.a => din.a(31 downto 24), din.b => din.b(31 downto 24), dout.s => dout.s(31 downto 24));

    fir_04 : qp_filter
    port map (din.a => din.a(39 downto 32), din.b => din.b(39 downto 32), dout.s => dout.s(39 downto 32));

    fir_05 : qp_filter
    port map (din.a => din.a(47 downto 40), din.b => din.b(47 downto 40), dout.s => dout.s(47 downto 40));

    fir_06 : qp_filter
    port map (din.a => din.a(55 downto 48), din.b => din.b(55 downto 48), dout.s => dout.s(55 downto 48));

    fir_07 : qp_filter
    port map (din.a => din.a(63 downto 56), din.b => din.b(63 downto 56), dout.s => dout.s(63 downto 56));

    fir_08 : qp_filter
    port map (din.a => din.a(71 downto 64), din.b => din.b(71 downto 64), dout.s => dout.s(71 downto 64));

    fir_09 : qp_filter
    port map (din.a => din.a(79 downto 72), din.b => din.b(79 downto 72), dout.s => dout.s(79 downto 72));

    fir_10 : qp_filter
    port map (din.a => din.a(87 downto 80), din.b => din.b(87 downto 80), dout.s => dout.s(87 downto 80));

    fir_11 : qp_filter
    port map (din.a => din.a(95 downto 88), din.b => din.b(95 downto 88), dout.s => dout.s(95 downto 88));

    fir_12 : qp_filter
    port map (din.a => din.a(103 downto 96), din.b => din.b(103 downto 96), dout.s => dout.s(103 downto 96));

    fir_13 : qp_filter
    port map (din.a => din.a(111 downto 104), din.b => din.b(111 downto 104), dout.s => dout.s(111 downto 104));

    fir_14 : qp_filter
    port map (din.a => din.a(119 downto 112), din.b => din.b(119 downto 112), dout.s => dout.s(119 downto 112));

    fir_15 : qp_filter
    port map (din.a => din.a(127 downto 120), din.b => din.b(127 downto 120), dout.s => dout.s(127 downto 120));

    fir_16 : qp_filter
    port map (din.a => din.a(135 downto 128), din.b => din.b(135 downto 128), dout.s => dout.s(135 downto 128));

end qp_col_interpolator;
