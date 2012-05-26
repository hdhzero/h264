library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.qpel_package.all;

entity interpolator is
    port (
        clock_i : in std_logic;
        reset_i : in std_logic;
        din_i   : in std_logic_vector(151 downto 0);
        sel_i   : in std_logic;
        col_o   : out std_logic_vector(135 downto 0);
        row_o   : out std_logic_vector(143 downto 0);
        diag_o  : out std_logic_vector(143 downto 0)
    );
end interpolator;

architecture interpolator of interpolator is
    signal lineA : std_logic_vector(151 downto 0);
    signal lineB : std_logic_vector(151 downto 0);

    signal col_s, col   : std_logic_vector(135 downto 0);
    signal row_s, row   : std_logic_vector(143 downto 0);
    signal diag_s, diag : std_logic_vector(143 downto 0);
begin
    col_o  <= col;
    row_o  <= row;
    diag_o <= diag;

    process(clock_i, reset_i, col_s, diag_s, row_s, din_i)
    begin
        if reset_i = '1' then
            col   <= (others => '0');
            row   <= (others => '0');
            diag  <= (others => '0');

            lineA <= (others => '0');
            lineB <= (others => '0');
        elsif clock_i'event and clock_i = '1' then
            col   <= col_s;
            row   <= row_s;
            diag  <= diag_s;

            lineA <= lineB;
            lineB <= din_i;
        end if;
    end process;

    col_interpolator_u : col_interpolator
    port map (lineA(143 downto 8), lineB(143 downto 8), col_s);

    row_interpolator_u : row_interpolator
    port map (lineA, row_s);

    diag_interpolator_u : diag_interpolator
    port map (sel_i, lineA, lineB, diag_s);
end interpolator;

