library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.qpel_package.all;
use work.io_package.all;

entity interpolator_tb is
end interpolator_tb;

architecture interpolator_tb of interpolator_tb is
    signal clock : std_logic;
    signal reset : std_logic;
    signal start : std_logic;
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
        file inputFile  : text;
        variable file_line : line;
        variable str : string(152 downto 1);
    begin
        file_open(inputFile, "interpolator_tb.txt", READ_MODE);

        reset <= '0'; 
        start <= '0';
        din   <= (others => '0');
        wait until clock'event and clock = '1';
   
        reset <= '1';
        start <= '0';
        din   <= (others => '0');
        wait until clock'event and clock = '1';

        reset <= '0'; 
        start <= '0';
        din   <= (others => '0');
        wait until clock'event and clock = '1';
        wait until clock'event and clock = '1';
        wait until clock'event and clock = '1';

        reset <= '0';
        start <= '1';
        din   <= (others => '0');
        wait until clock'event and clock = '1';

        start <= '0';
        reset <= '0';

        while not endfile(inputFile) loop
            readline(inputFile, file_line);
            read(file_line, str);

            din <= str2vec(str);
            wait until clock'event and clock = '1';
        end loop;

        file_close(inputFile);
        wait until clock'event and clock = '1';
        wait;

    end process;

    interpolator_u : interpolator
    port map (clock, reset, start, din, col, row, diag);

end interpolator_tb;

