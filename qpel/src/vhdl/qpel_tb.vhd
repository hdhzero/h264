library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.qpel_package.all;
use work.io_package.all;
use std.textio.all;

entity qpel_tb is
end qpel_tb;

architecture qpel_tb of qpel_tb is
    signal clock_i : std_logic;
    signal reset_i : std_logic;
    signal start_i : std_logic;

    signal hp_mb_i : std_logic_vector(151 downto 0);
    signal done_o  : std_logic; 
begin
    process
    begin
        clock_i <= '1';
        wait for 5 ns;
        clock_i <= '0';
        wait for 5 ns;
    end process;

    process
        file inputFile : text;
        variable file_line : line;
        variable str : string(152 downto 1);
    begin
        file_open(inputFile, "interpolator_tb.txt", READ_MODE);

        reset_i <= '1';
        hp_mb_i <= (others => '0');
        start_i <= '0';
        wait for 20 ns;
        reset_i <= '0';

        wait until clock_i'event and clock_i = '1';
        wait until clock_i'event and clock_i = '1';
        wait until clock_i'event and clock_i = '1';

        start_i <= '1';
        wait until clock_i'event and clock_i = '1';
        start_i <= '0';

        while not endfile(inputFile) loop
            readline(inputFile, file_line);
            read(file_line, str);

            hp_mb_i <= str2vec(str);
            wait until clock_i'event and clock_i = '1';
        end loop;

        file_close(inputFile);
        wait until clock_i'event and clock_i = '1';
        wait;
    end process;

    qpel_u : qpel
    port map (
        clock_i => clock_i,
        reset_i => reset_i,
        start_i => start_i,
        hp_mb_i => hp_mb_i,
        done_o  => done_o
    );
end qpel_tb;
