library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.qpel_package.all;

entity interpolator_tb is
end interpolator_tb;

architecture interpolator_tb of interpolator_tb is
    signal clock : std_logic;
    signal reset : std_logic;
    signal din   : std_logic_vector(151 downto 0);
    signal col   : std_logic_vector(135 downto 0);
    signal row   : std_logic_vector(143 downto 0);
    signal diag  : std_logic_vector(143 downto 0);
begin
    process
    begin
        clock <= '1';
        wait for 5 ns;
        clock <= '0';
        wait for 5 ns;
    end process;

    process
    begin
        reset <= '1';
        start <= '0';
        din   <= (others => '0');
        wait for 21 ns;

        reset <= '0'; 
        start <= '0';
        din   <= (others => '0');
        wait for 50 ns;

        wait until clock'event and clock = '1' then
        start <= '1';

    end process;

    interpolator_u : interpolator_tb
    port map (clock, reset, start, din, col, row, diag);

end interpolator_tb;

