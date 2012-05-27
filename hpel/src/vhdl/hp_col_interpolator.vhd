library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.hpel_package.all;

entity hp_col_interpolator is
    port (
        lineA_i : in std_logic_vector(111 downto 0);
        lineB_i : in std_logic_vector(111 downto 0);
        lineC_i : in std_logic_vector(111 downto 0);
        lineD_i : in std_logic_vector(111 downto 0);
        lineE_i : in std_logic_vector(111 downto 0);
        lineF_i : in std_logic_vector(111 downto 0);
        dout_o  : out std_logic_vector(111 downto 0)
    );
end hp_col_interpolator;

architecture hp_col_interpolator of hp_col_interpolator is
begin

    hp_filter0 : hp_filter
    port map (
        a => lineA_i(7 downto 0),
        b => lineB_i(7 downto 0),
        c => lineC_i(7 downto 0),
        d => lineD_i(7 downto 0),
        e => lineE_i(7 downto 0),
        f => lineF_i(7 downto 0),
        s => dout_o(7 downto 0)
    );

    hp_filter1 : hp_filter
    port map (
        a => lineA_i(15 downto 8),
        b => lineB_i(15 downto 8),
        c => lineC_i(15 downto 8),
        d => lineD_i(15 downto 8),
        e => lineE_i(15 downto 8),
        f => lineF_i(15 downto 8),
        s => dout_o(15 downto 8)
    );

    hp_filter2 : hp_filter
    port map (
        a => lineA_i(23 downto 16),
        b => lineB_i(23 downto 16),
        c => lineC_i(23 downto 16),
        d => lineD_i(23 downto 16),
        e => lineE_i(23 downto 16),
        f => lineF_i(23 downto 16),
        s => dout_o(23 downto 16)
    );

    hp_filter3 : hp_filter
    port map (
        a => lineA_i(31 downto 24),
        b => lineB_i(31 downto 24),
        c => lineC_i(31 downto 24),
        d => lineD_i(31 downto 24),
        e => lineE_i(31 downto 24),
        f => lineF_i(31 downto 24),
        s => dout_o(31 downto 24)
    );

    hp_filter4 : hp_filter
    port map (
        a => lineA_i(39 downto 32),
        b => lineB_i(39 downto 32),
        c => lineC_i(39 downto 32),
        d => lineD_i(39 downto 32),
        e => lineE_i(39 downto 32),
        f => lineF_i(39 downto 32),
        s => dout_o(39 downto 32)
    );

    hp_filter5 : hp_filter
    port map (
        a => lineA_i(47 downto 40),
        b => lineB_i(47 downto 40),
        c => lineC_i(47 downto 40),
        d => lineD_i(47 downto 40),
        e => lineE_i(47 downto 40),
        f => lineF_i(47 downto 40),
        s => dout_o(47 downto 40)
    );

    hp_filter6 : hp_filter
    port map (
        a => lineA_i(55 downto 48),
        b => lineB_i(55 downto 48),
        c => lineC_i(55 downto 48),
        d => lineD_i(55 downto 48),
        e => lineE_i(55 downto 48),
        f => lineF_i(55 downto 48),
        s => dout_o(55 downto 48)
    );

    hp_filter7 : hp_filter
    port map (
        a => lineA_i(63 downto 56),
        b => lineB_i(63 downto 56),
        c => lineC_i(63 downto 56),
        d => lineD_i(63 downto 56),
        e => lineE_i(63 downto 56),
        f => lineF_i(63 downto 56),
        s => dout_o(63 downto 56)
    );

    hp_filter8 : hp_filter
    port map (
        a => lineA_i(71 downto 64),
        b => lineB_i(71 downto 64),
        c => lineC_i(71 downto 64),
        d => lineD_i(71 downto 64),
        e => lineE_i(71 downto 64),
        f => lineF_i(71 downto 64),
        s => dout_o(71 downto 64)
    );

    hp_filter9 : hp_filter
    port map (
        a => lineA_i(79 downto 72),
        b => lineB_i(79 downto 72),
        c => lineC_i(79 downto 72),
        d => lineD_i(79 downto 72),
        e => lineE_i(79 downto 72),
        f => lineF_i(79 downto 72),
        s => dout_o(79 downto 72)
    );

    hp_filter10 : hp_filter
    port map (
        a => lineA_i(87 downto 80),
        b => lineB_i(87 downto 80),
        c => lineC_i(87 downto 80),
        d => lineD_i(87 downto 80),
        e => lineE_i(87 downto 80),
        f => lineF_i(87 downto 80),
        s => dout_o(87 downto 80)
    );

    hp_filter11 : hp_filter
    port map (
        a => lineA_i(95 downto 88),
        b => lineB_i(95 downto 88),
        c => lineC_i(95 downto 88),
        d => lineD_i(95 downto 88),
        e => lineE_i(95 downto 88),
        f => lineF_i(95 downto 88),
        s => dout_o(95 downto 88)
    );

    hp_filter12 : hp_filter
    port map (
        a => lineA_i(103 downto 96),
        b => lineB_i(103 downto 96),
        c => lineC_i(103 downto 96),
        d => lineD_i(103 downto 96),
        e => lineE_i(103 downto 96),
        f => lineF_i(103 downto 96),
        s => dout_o(103 downto 96)
    );

    hp_filter13 : hp_filter
    port map (
        a => lineA_i(111 downto 104),
        b => lineB_i(111 downto 104),
        c => lineC_i(111 downto 104),
        d => lineD_i(111 downto 104),
        e => lineE_i(111 downto 104),
        f => lineF_i(111 downto 104),
        s => dout_o(111 downto 104)
    );


end hp_col_interpolator;
