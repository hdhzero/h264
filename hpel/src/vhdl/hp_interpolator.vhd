library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hp_interpolator is
    port (
        clock_i : in std_logic;
        reset_i : in std_logic;
        din_i   : in std_logic_vector(111 downto 0);
        col_o   : out std_logic_vector(79 downto 0);
        row_o   : out std_logic_vector(71 downto 0);
        diag_o  : out std_logic_vector(71 downto 0)
    );
end hp_interpolator;

architecture hp_interpolator of hp_interpolator is
    signal lineA : std_logic_vector(111 downto 0);
    signal lineB : std_logic_vector(111 downto 0);
    signal lineC : std_logic_vector(111 downto 0);
    signal lineD : std_logic_vector(111 downto 0);
    signal lineE : std_logic_vector(111 downto 0);
    signal lineF : std_logic_vector(111 downto 0);

    signal col_s, col_reg   : std_logic_vector(111 downto 0);
    signal row_s, row_reg   : std_logic_vector(71 downto 0);
    signal diag_s, diag_reg : std_logic_vector(71 downto 0);
begin
    process(clock_i, reset_i, din_i, col_s, row_s, diag_s)
    begin
        if reset_i = '1' then
            lineA <= (others => '0');
            lineB <= (others => '0');
            lineC <= (others => '0');
            lineD <= (others => '0');
            lineE <= (others => '0');
            lineF <= (others => '0');

            row_reg  <= (others => '0');
            col_reg  <= (others => '0');
            diag_reg <= (others => '0');

        elsif clock'event and clock = '1' then
            lineF <= din_i;
            lineE <= lineF;
            lineD <= lineE;
            lineC <= lineD;
            lineB <= lineC;
            lineA <= lineB;

            row_reg  <= row_s;
            col_reg  <= col_s;
            diag_reg <= diag_s;

        end if;
    end process;


end hp_interpolator;

