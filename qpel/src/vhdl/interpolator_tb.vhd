library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.qpel_package.all;
use work.io_package.all;

entity interpolator_tb is
end interpolator_tb;

architecture interpolator_tb of interpolator_tb is
    signal clock_i : std_logic;
    signal reset_i : std_logic;
    signal start_i : std_logic;
    signal din_i   : std_logic_vector(151 downto 0);
    signal done_o  : std_logic;
    signal col_o   : std_logic_vector(135 downto 0);
    signal row_o   : std_logic_vector(143 downto 0);
    signal diag_o  : std_logic_vector(143 downto 0);
    signal col_wren_o  : std_logic;
    signal row_wren_o  : std_logic;
    signal diag_wren_o : std_logic;
    signal col_addr_o  : std_logic_vector(5 downto 0);
    signal row_addr_o  : std_logic_vector(5 downto 0);
    signal diag_addr_o : std_logic_vector(5 downto 0);

begin
    process
    begin
        clock_i <= '1';
        wait for 5 ns;
        clock_i <= '0';
        wait for 5 ns;
    end process;

    process
        file inputFile  : text;
        variable file_line : line;
        variable str : string(152 downto 1);
    begin
        file_open(inputFile, "interpolator_tb.txt", READ_MODE);

        reset_i <= '0'; 
        start_i <= '0';
        din_i   <= (others => '0');
        wait until clock_i'event and clock_i = '1';
   
        reset_i <= '1';
        start_i <= '0';
        din_i   <= (others => '0');
        wait until clock_i'event and clock_i = '1';

        reset_i <= '0'; 
        start_i <= '0';
        din_i   <= (others => '0');
        wait until clock_i'event and clock_i = '1';
        wait until clock_i'event and clock_i = '1';
        wait until clock_i'event and clock_i = '1';

        reset_i <= '0';
        start_i <= '1';
        din_i   <= (others => '0');
        wait until clock_i'event and clock_i = '1';

        start_i <= '0';
        reset_i <= '0';

        while not endfile(inputFile) loop
            readline(inputFile, file_line);
            read(file_line, str);

            din_i <= str2vec(str);
            wait until clock_i'event and clock_i = '1';
        end loop;

        file_close(inputFile);
        wait until clock_i'event and clock_i = '1';
        wait;

    end process;

    interpolator_u : interpolator
    port map (clock_i, reset_i, start_i, din_i, done_o, col_o, row_o, diag_o, 
        col_wren_o, row_wren_o, diag_wren_o, col_addr_o, row_addr_o, diag_addr_o);

end interpolator_tb;

