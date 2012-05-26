library ieee;
use ieee.std_logic_1164.all
use ieee.numeric_std.all;

entity hp_diag_interpolator is
    port (
        lineA_i : in std_logic_vector(111 downto 0);
        dout_o  : out std_logic_vector(71 downto 0)
    );
end hp_diag_interpolator;

architecture hp_diag_interpolator of hp_diag_interpolator is
begin
    hp_filter0 : hp_filter
    port map (
        a => lineA_i(7 downto 0),
        b => lineA_i(15 downto 8),
        c => lineA_i(23 downto 16),
        d => lineA_i(31 downto 24),
        e => lineA_i(39 downto 32),
        f => lineA_i(47 downto 40)
    );

    hp_filter1 : hp_filter
    port map (
        a => lineA_i(15 downto 8),
        b => lineA_i(23 downto 16),
        c => lineA_i(31 downto 24),
        d => lineA_i(39 downto 32),
        e => lineA_i(47 downto 40),
        f => lineA_i(55 downto 48)
    );

    hp_filter2 : hp_filter
    port map (
        a => lineA_i(23 downto 16),
        b => lineA_i(31 downto 24),
        c => lineA_i(39 downto 32),
        d => lineA_i(47 downto 40),
        e => lineA_i(55 downto 48),
        f => lineA_i(63 downto 56)
    );

    hp_filter3 : hp_filter
    port map (
        a => lineA_i(31 downto 24),
        b => lineA_i(39 downto 32),
        c => lineA_i(47 downto 40),
        d => lineA_i(55 downto 48),
        e => lineA_i(63 downto 56),
        f => lineA_i(71 downto 64)
    );

    hp_filter4 : hp_filter
    port map (
        a => lineA_i(39 downto 32),
        b => lineA_i(47 downto 40),
        c => lineA_i(55 downto 48),
        d => lineA_i(63 downto 56),
        e => lineA_i(71 downto 64),
        f => lineA_i(79 downto 72)
    );

    hp_filter5 : hp_filter
    port map (
        a => lineA_i(47 downto 40),
        b => lineA_i(55 downto 48),
        c => lineA_i(63 downto 56),
        d => lineA_i(71 downto 64),
        e => lineA_i(79 downto 72),
        f => lineA_i(87 downto 80)
    );

    hp_filter6 : hp_filter
    port map (
        a => lineA_i(55 downto 48),
        b => lineA_i(63 downto 56),
        c => lineA_i(71 downto 64),
        d => lineA_i(79 downto 72),
        e => lineA_i(87 downto 80),
        f => lineA_i(95 downto 88)
    );

    hp_filter7 : hp_filter
    port map (
        a => lineA_i(63 downto 56),
        b => lineA_i(71 downto 64),
        c => lineA_i(79 downto 72),
        d => lineA_i(87 downto 80),
        e => lineA_i(95 downto 88),
        f => lineA_i(103 downto 96)
    );

    hp_filter8 : hp_filter
    port map (
        a => lineA_i(71 downto 64),
        b => lineA_i(79 downto 72),
        c => lineA_i(87 downto 80),
        d => lineA_i(95 downto 88),
        e => lineA_i(103 downto 96),
        f => lineA_i(111 downto 104)
    );


end hp_diag_interpolator;


