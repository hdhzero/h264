library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity filter is
    port (
        a : in std_logic_vector(7 downto 0);
        b : in std_logic_vector(7 downto 0);
        c : in std_logic_vector(7 downto 0);
        d : in std_logic_vector(7 downto 0);
        e : in std_logic_vector(7 downto 0);
        f : in std_logic_vector(7 downto 0);
        s : out std_logic_vector(7 downto 0)
    );
end filter;

architecture filter of filter is
    signal af   : signed(15 downto 0);
    signal be   : signed(15 downto 0);
    signal cd   : signed(15 downto 0);
    signal cd4  : signed(15 downto 0);
    signal c2e  : signed(15 downto 0);
    signal c2e4 : signed(15 downto 0);
    signal res  : signed(15 downto 0);
begin
    af   <= signed("00000000" & a) + signed("00000000" & f);
    be   <= signed("00000000" & b) + signed("00000000" & e);
    cd   <= signed("00000000" & c) + signed("00000000" & d);
    cd4  <= cd(13 downto 0) & "00";
    c2e  <= cd4 - be;
    c2e4 <= c2e(13 downto 0) & "00";
    res  <= af + c2e4 + c2e;
    
    s    <= std_logic_vector(res(7 downto 0));
end filter;
