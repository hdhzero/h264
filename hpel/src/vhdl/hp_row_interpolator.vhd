library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.hpel_package.all;

entity hp_row_interpolator is
    port (
        din  : in hp_row_interpolator_i;
        dout : out hp_row_interpolator_o
    );
end hp_row_interpolator;

architecture hp_row_interpolator of hp_row_interpolator is
begin
    hp_filter0 : hp_filter
    port map (
        din.a => din.lineA(47 downto 40),
        din.b => din.lineA(39 downto 32),
        din.c => din.lineA(31 downto 24),
        din.d => din.lineA(23 downto 16),
        din.e => din.lineA(15 downto 8),
        din.f => din.lineA(7 downto 0),
        dout.s => dout.res(7 downto 0)
    );

    hp_filter1 : hp_filter
    port map (
        din.a => din.lineA(55 downto 48),
        din.b => din.lineA(47 downto 40),
        din.c => din.lineA(39 downto 32),
        din.d => din.lineA(31 downto 24),
        din.e => din.lineA(23 downto 16),
        din.f => din.lineA(15 downto 8),
        dout.s => dout.res(15 downto 8)
    );

    hp_filter2 : hp_filter
    port map (
        din.a => din.lineA(63 downto 56),
        din.b => din.lineA(55 downto 48),
        din.c => din.lineA(47 downto 40),
        din.d => din.lineA(39 downto 32),
        din.e => din.lineA(31 downto 24),
        din.f => din.lineA(23 downto 16),
        dout.s => dout.res(23 downto 16)
    );

    hp_filter3 : hp_filter
    port map (
        din.a => din.lineA(71 downto 64),
        din.b => din.lineA(63 downto 56),
        din.c => din.lineA(55 downto 48),
        din.d => din.lineA(47 downto 40),
        din.e => din.lineA(39 downto 32),
        din.f => din.lineA(31 downto 24),
        dout.s => dout.res(31 downto 24)
    );

    hp_filter4 : hp_filter
    port map (
        din.a => din.lineA(79 downto 72),
        din.b => din.lineA(71 downto 64),
        din.c => din.lineA(63 downto 56),
        din.d => din.lineA(55 downto 48),
        din.e => din.lineA(47 downto 40),
        din.f => din.lineA(39 downto 32),
        dout.s => dout.res(39 downto 32)
    );

    hp_filter5 : hp_filter
    port map (
        din.a => din.lineA(87 downto 80),
        din.b => din.lineA(79 downto 72),
        din.c => din.lineA(71 downto 64),
        din.d => din.lineA(63 downto 56),
        din.e => din.lineA(55 downto 48),
        din.f => din.lineA(47 downto 40),
        dout.s => dout.res(47 downto 40)
    );

    hp_filter6 : hp_filter
    port map (
        din.a => din.lineA(95 downto 88),
        din.b => din.lineA(87 downto 80),
        din.c => din.lineA(79 downto 72),
        din.d => din.lineA(71 downto 64),
        din.e => din.lineA(63 downto 56),
        din.f => din.lineA(55 downto 48),
        dout.s => dout.res(55 downto 48)
    );

    hp_filter7 : hp_filter
    port map (
        din.a => din.lineA(103 downto 96),
        din.b => din.lineA(95 downto 88),
        din.c => din.lineA(87 downto 80),
        din.d => din.lineA(79 downto 72),
        din.e => din.lineA(71 downto 64),
        din.f => din.lineA(63 downto 56),
        dout.s => dout.res(63 downto 56)
    );

    hp_filter8 : hp_filter
    port map (
        din.a => din.lineA(111 downto 104),
        din.b => din.lineA(103 downto 96),
        din.c => din.lineA(95 downto 88),
        din.d => din.lineA(87 downto 80),
        din.e => din.lineA(79 downto 72),
        din.f => din.lineA(71 downto 64),
        dout.s => dout.res(71 downto 64)
    );
end hp_row_interpolator;


