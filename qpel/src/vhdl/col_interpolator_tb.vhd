library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.qpel_package.all;

entity col_interpolator_tb is
end col_interpolator_tb;

architecture col_interpolator_tb of col_interpolator_tb is
    signal a : std_logic_vector(151 downto 0);
    signal b : std_logic_vector(151 downto 0);
    signal s : std_logic_vector(143 downto 0);
begin
    col_u : col_interpolator
    port map (a, b, s);

    process
    begin
        sel <= '0';
        b   <= "00001100000110010001101100011001000110010001100100011001000110010001100100011001000110010001100000011000000110000001100000011000000110000001100000011000";
        a   <= "00011000001100010011010100110010001100010011000100110001001100010011000100110001001100010011000000110000001100000011000000110000001100000011000000110000";
        wait for 100 ns;
        wait;
    end process;
end col_interpolator_tb;


