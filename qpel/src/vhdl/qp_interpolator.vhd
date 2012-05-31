library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.qpel_package.all;

entity qp_interpolator is
    port (
        clock : in std_logic;
        reset : in std_logic;
        din   : in qp_interpolator_i;
        dout  : out qp_interpolator_o
    );
end qp_interpolator;

architecture qp_interpolator of qp_interpolator is
    signal lineA : std_logic_vector(151 downto 0);
    signal lineB : std_logic_vector(151 downto 0);

    signal col_s, col   : std_logic_vector(135 downto 0);
    signal row_s, row   : std_logic_vector(143 downto 0);
    signal diag_s, diag : std_logic_vector(143 downto 0);
begin
    dout.col  <= col;
    dout.row  <= row;
    dout.diag <= diag;

    process(clock, reset, col_s, diag_s, row_s, din.i)
    begin
        if reset = '1' then
            col   <= (others => '0');
            row   <= (others => '0');
            diag  <= (others => '0');

            lineA <= (others => '0');
            lineB <= (others => '0');
        elsif clock'event and clock = '1' then
            col   <= col_s;
            row   <= row_s;
            diag  <= diag_s;

            lineA <= lineB;
            lineB <= din.i;
        end if;
    end process;

    col_interpolator_u : qp_col_interpolator
    port map (
        din.a => lineA(143 downto 8), 
        din.b => lineB(143 downto 8), 
        dout.s => col_s
    );

    row_interpolator_u : qp_row_interpolator
    port map (
        din.a => lineA, 
        dout.s => row_s
    );

    diag_interpolator_u : qp_diag_interpolator
    port map (
        din.sel => din.sel, 
        din.a   => lineA, 
        din.b   => lineB, 
        dout.s  => diag_s
    );
end qp_interpolator;

