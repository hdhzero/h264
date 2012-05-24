library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.qpel_package.all;

entity row_interpolator_tb is
end row_interpolator_tb;

architecture row_interpolator_tb of row_interpolator_tb is
    signal a : std_logic_vector(151 downto 0);
    signal s : std_logic_vector(143 downto 0);
begin
    row_u : row_interpolator
    port map (a, s);

    process
    begin
        a   <= "00011000001100010011010100110010001100010011000100110001001100010011000100110001001100010011000000110000001100000011000000110000001100000011000000110000";
        wait for 100 ns;
        wait;
    end process;
end row_interpolator_tb;

