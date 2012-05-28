library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.hpel_package.all;

entity hp_interpolator is
    port (
        clock : in std_logic;
        reset : in std_logic;
        din   : in hp_interpolator_i;
        dout  : out hp_interpolator_o
    );
end hp_interpolator;

architecture hp_interpolator of hp_interpolator is
    signal col_din   : hp_col_interpolator_i;
    signal col_dout  : hp_col_interpolator_o;
    signal row_din   : hp_row_interpolator_i;
    signal row_dout  : hp_row_interpolator_o;
    signal diag_din  : hp_diag_interpolator_i;
    signal diag_dout : hp_diag_interpolator_o;

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
    dout.col  <= col_reg(95 downto 16);
    dout.row  <= row_reg;
    dout.diag <= diag_reg;

    col_din.lineA <= lineA;
    col_din.lineB <= lineB;
    col_din.lineC <= lineC;
    col_din.lineD <= lineD;
    col_din.lineE <= lineE;
    col_din.lineF <= lineF;

    row_din.lineA  <= lineA;
    diag_din.lineA <= col_reg;

    col_s  <= col_dout.res;
    row_s  <= row_dout.res;
    diag_s <= diag_dout.res;

    process(clock, reset, din, col_s, row_s, diag_s)
    begin
        if reset = '1' then
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
            lineF <= din.input;
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

    row_interpolation_u : hp_row_interpolator
    port map (row_din, row_dout);

    col_interpolation_u : hp_col_interpolator
    port map (col_din, col_dout);

    diag_interpolation_u : hp_diag_interpolator
    port map (diag_din, diag_dout);
end hp_interpolator;

