library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.hpel_package.all;

entity hp_col_interpolator is
    port (
        din  : in hp_col_interpolator_i;
        dout : out hp_col_interpolator_o
    );
end hp_col_interpolator;

architecture hp_col_interpolator of hp_col_interpolator is
begin

    hp_filter0 : hp_filter
    port map (
        din.a => din.lineA(7 downto 0),
        din.b => din.lineB(7 downto 0),
        din.c => din.lineC(7 downto 0),
        din.d => din.lineD(7 downto 0),
        din.e => din.lineE(7 downto 0),
        din.f => din.lineF(7 downto 0),
        dout.s => dout.res(7 downto 0)
    );

    hp_filter1 : hp_filter
    port map (
        din.a => din.lineA(15 downto 8),
        din.b => din.lineB(15 downto 8),
        din.c => din.lineC(15 downto 8),
        din.d => din.lineD(15 downto 8),
        din.e => din.lineE(15 downto 8),
        din.f => din.lineF(15 downto 8),
        dout.s => dout.res(15 downto 8)
    );

    hp_filter2 : hp_filter
    port map (
        din.a => din.lineA(23 downto 16),
        din.b => din.lineB(23 downto 16),
        din.c => din.lineC(23 downto 16),
        din.d => din.lineD(23 downto 16),
        din.e => din.lineE(23 downto 16),
        din.f => din.lineF(23 downto 16),
        dout.s => dout.res(23 downto 16)
    );

    hp_filter3 : hp_filter
    port map (
        din.a => din.lineA(31 downto 24),
        din.b => din.lineB(31 downto 24),
        din.c => din.lineC(31 downto 24),
        din.d => din.lineD(31 downto 24),
        din.e => din.lineE(31 downto 24),
        din.f => din.lineF(31 downto 24),
        dout.s => dout.res(31 downto 24)
    );

    hp_filter4 : hp_filter
    port map (
        din.a => din.lineA(39 downto 32),
        din.b => din.lineB(39 downto 32),
        din.c => din.lineC(39 downto 32),
        din.d => din.lineD(39 downto 32),
        din.e => din.lineE(39 downto 32),
        din.f => din.lineF(39 downto 32),
        dout.s => dout.res(39 downto 32)
    );

    hp_filter5 : hp_filter
    port map (
        din.a => din.lineA(47 downto 40),
        din.b => din.lineB(47 downto 40),
        din.c => din.lineC(47 downto 40),
        din.d => din.lineD(47 downto 40),
        din.e => din.lineE(47 downto 40),
        din.f => din.lineF(47 downto 40),
        dout.s => dout.res(47 downto 40)
    );

    hp_filter6 : hp_filter
    port map (
        din.a => din.lineA(55 downto 48),
        din.b => din.lineB(55 downto 48),
        din.c => din.lineC(55 downto 48),
        din.d => din.lineD(55 downto 48),
        din.e => din.lineE(55 downto 48),
        din.f => din.lineF(55 downto 48),
        dout.s => dout.res(55 downto 48)
    );

    hp_filter7 : hp_filter
    port map (
        din.a => din.lineA(63 downto 56),
        din.b => din.lineB(63 downto 56),
        din.c => din.lineC(63 downto 56),
        din.d => din.lineD(63 downto 56),
        din.e => din.lineE(63 downto 56),
        din.f => din.lineF(63 downto 56),
        dout.s => dout.res(63 downto 56)
    );

    hp_filter8 : hp_filter
    port map (
        din.a => din.lineA(71 downto 64),
        din.b => din.lineB(71 downto 64),
        din.c => din.lineC(71 downto 64),
        din.d => din.lineD(71 downto 64),
        din.e => din.lineE(71 downto 64),
        din.f => din.lineF(71 downto 64),
        dout.s => dout.res(71 downto 64)
    );

    hp_filter9 : hp_filter
    port map (
        din.a => din.lineA(79 downto 72),
        din.b => din.lineB(79 downto 72),
        din.c => din.lineC(79 downto 72),
        din.d => din.lineD(79 downto 72),
        din.e => din.lineE(79 downto 72),
        din.f => din.lineF(79 downto 72),
        dout.s => dout.res(79 downto 72)
    );

    hp_filter10 : hp_filter
    port map (
        din.a => din.lineA(87 downto 80),
        din.b => din.lineB(87 downto 80),
        din.c => din.lineC(87 downto 80),
        din.d => din.lineD(87 downto 80),
        din.e => din.lineE(87 downto 80),
        din.f => din.lineF(87 downto 80),
        dout.s => dout.res(87 downto 80)
    );

    hp_filter11 : hp_filter
    port map (
        din.a => din.lineA(95 downto 88),
        din.b => din.lineB(95 downto 88),
        din.c => din.lineC(95 downto 88),
        din.d => din.lineD(95 downto 88),
        din.e => din.lineE(95 downto 88),
        din.f => din.lineF(95 downto 88),
        dout.s => dout.res(95 downto 88)
    );

    hp_filter12 : hp_filter
    port map (
        din.a => din.lineA(103 downto 96),
        din.b => din.lineB(103 downto 96),
        din.c => din.lineC(103 downto 96),
        din.d => din.lineD(103 downto 96),
        din.e => din.lineE(103 downto 96),
        din.f => din.lineF(103 downto 96),
        dout.s => dout.res(103 downto 96)
    );

    hp_filter13 : hp_filter
    port map (
        din.a => din.lineA(111 downto 104),
        din.b => din.lineB(111 downto 104),
        din.c => din.lineC(111 downto 104),
        din.d => din.lineD(111 downto 104),
        din.e => din.lineE(111 downto 104),
        din.f => din.lineF(111 downto 104),
        dout.s => dout.res(111 downto 104)
    );

end hp_col_interpolator;
