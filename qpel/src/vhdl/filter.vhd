library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity filter is
    port (
        a : in std_logic_vector(7 downto 0);
        b : in std_logic_vector(7 downto 0);
        s : out std_logic_vector(7 downto 0)
    );
end filter;

architecture filter of filter is
    signal sum : unsigned(8 downto 0);
begin
    sum <= unsigned('0' & a) + unsigned('0' & b) + "1";
    s   <= std_logic_vector(sum(8 downto 1));
end filter;
