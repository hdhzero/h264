library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.hpel_package.all;
use work.io_package.all;
use std.textio.all;

entity hpel_tb is
end hpel_tb;

architecture hpel_tb of hpel_tb is
    signal clock : std_logic;
    signal reset : std_logic;
    signal start : std_logic;

    signal ref : std_logic_vector(111 downto 0);
    signal pel : std_logic_vector(63 downto 0);
    signal done  : std_logic; 

    signal hpel_din  : hpel_i;
    signal hpel_dout : hpel_o;
begin
    process
    begin
        clock <= '1';
        wait for 5 ns;
        clock <= '0';
        wait for 5 ns;
    end process;

    process
        file inputFile : text;
        variable file_line : line;
        variable str : string(112 downto 1);
    begin
        file_open(inputFile, "interpolator_tb.txt", READ_MODE);

        reset <= '1';
        hpel_din.mb_ref <= (others => '0');
        start <= '0';
        wait for 20 ns;
        reset <= '0';

        wait until clock'event and clock = '1';
        wait until clock'event and clock = '1';
        wait until clock'event and clock = '1';

        start <= '1';
        wait until clock'event and clock = '1';
        start <= '0';

        while not endfile(inputFile) loop
            readline(inputFile, file_line);
            read(file_line, str);

            hpel_din.mb_ref <= str2vec(str);
            wait until clock'event and clock = '1';
        end loop;

        file_close(inputFile);
        wait until clock'event and clock = '1';


        wait until clock'event and clock = '1';
        wait until clock'event and clock = '1';
        wait until clock'event and clock = '1';
        wait until clock'event and clock = '1';
        wait until clock'event and clock = '1';
        wait until clock'event and clock = '1';

        wait;
    end process;

    hpel_u : hpel
    port map (
        clock => clock,
        reset => reset,
        din   => hpel_din,
        dout  => hpel_dout
    );
end hpel_tb;
