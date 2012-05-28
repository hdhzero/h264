library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.hpel_package.all;

entity hp_filter is
    port (
        din  : in hp_filter_i;
        dout : out hp_filter_o
    );
end hp_filter;

architecture hp_filter of hp_filter is
    signal af   : signed(15 downto 0);
    signal be   : signed(15 downto 0);
    signal cd   : signed(15 downto 0);
    signal cd4  : signed(15 downto 0);
    signal c2e  : signed(15 downto 0);
    signal c2e4 : signed(15 downto 0);
    signal res  : signed(15 downto 0);
    signal ress : signed(15 downto 0);
begin
    af   <= signed("00000000" & din.a) + signed("00000000" & din.f);
    be   <= signed("00000000" & din.b) + signed("00000000" & din.e);
    cd   <= signed("00000000" & din.c) + signed("00000000" & din.d);
    cd4  <= cd(13 downto 0) & "00";
    c2e  <= cd4 - be;
    c2e4 <= c2e(13 downto 0) & "00";
    res  <= af + c2e4 + c2e;
    ress <= "00000" & res(15 downto 5);

    process(ress)
    begin
        if ress(15) = '1' then
            dout.s <= (others => '0');
        elsif ress > "0000000011111111" then
            dout.s <= "11111111";
        else    
            dout.s <= std_logic_vector(ress(7 downto 0));
        end if;
    end process;
end hp_filter;
