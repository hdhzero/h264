library ieee;
use ieee.std_logic_1164.all;

entity filter_tb is
end filter_tb;

architecture filter_tb of filter_tb is
    component filter is
        port (
            a : in std_logic_vector(7 downto 0);
            b : in std_logic_vector(7 downto 0);
            c : in std_logic_vector(7 downto 0);
            d : in std_logic_vector(7 downto 0);
            e : in std_logic_vector(7 downto 0);
            f : in std_logic_vector(7 downto 0);
            s : out std_logic_vector(7 downto 0)
        );
    end component filter;

    signal a, b, c, d, e, f, s : std_logic_vector(7 downto 0);
begin
    fir : filter
    port map (a, b, c, d, e, f, s);

    process
    begin
        a <= x"10";
        b <= x"10";
        c <= x"10";
        d <= x"10";
        e <= x"10";
        f <= x"10";
        wait for 100 ns;
        wait;
    end process;
end filter_tb;
