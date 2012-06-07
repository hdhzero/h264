library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.qpel_package.all;

entity qp_compare is
    port (
        clock : in std_logic;
        reset : in std_logic;
        din   : in qp_compare_i;
        dout  : out qp_compare_o
    );
end qp_compare;

architecture qp_compare of qp_compare is
    type reg_t is record
        best    : match_t;
        hp      : match_t;
        row     : match_t;
        col     : match_t;
        diag    : match_t;
        hpcol   : match_t;
        rowdiag : match_t;
        tobest  : match_t;
    end record;

    signal r : reg_t;
begin

    dout.result <= r.best;

    process (clock, reset)
    begin
        if reset = '1' then
            r.best    <= (vec_x => "00", vec_y => "00", sad => (others => '1'));
            r.hp      <= (vec_x => "00", vec_y => "00", sad => (others => '1'));
            r.row     <= (vec_x => "00", vec_y => "00", sad => (others => '1'));
            r.diag    <= (vec_x => "00", vec_y => "00", sad => (others => '1'));
            r.col     <= (vec_x => "00", vec_y => "00", sad => (others => '1'));
            r.hpcol   <= (vec_x => "00", vec_y => "00", sad => (others => '1'));
            r.rowdiag <= (vec_x => "00", vec_y => "00", sad => (others => '1'));
        elsif clock'event and clock = '1' then
            if din.clear = '1' then
                r.best    <= (vec_x => "00", vec_y => "00", sad => (others => '1'));
                r.hp      <= (vec_x => "00", vec_y => "00", sad => (others => '1'));
                r.row     <= (vec_x => "00", vec_y => "00", sad => (others => '1'));
                r.diag    <= (vec_x => "00", vec_y => "00", sad => (others => '1'));
                r.col     <= (vec_x => "00", vec_y => "00", sad => (others => '1'));
                r.hpcol   <= (vec_x => "00", vec_y => "00", sad => (others => '1'));
                r.rowdiag <= (vec_x => "00", vec_y => "00", sad => (others => '1'));
            else
                r.hp   <= din.hp;
                r.row  <= din.row;
                r.col  <= din.col;
                r.diag <= din.diag;

                if unsigned(r.hp.sad) < unsigned(r.col.sad) then
                    r.hpcol <= r.hp;
                else
                    r.hpcol <= r.col;
                end if;

                if unsigned(r.row.sad) < unsigned(r.diag.sad) then
                    r.rowdiag <= r.row;
                else
                    r.rowdiag <= r.diag;
                end if;

                if unsigned(r.rowdiag.sad) < unsigned(r.hpcol.sad) then
                    r.tobest <= r.rowdiag;
                else
                    r.tobest <= r.hpcol;
                end if;

                if unsigned(r.tobest.sad) < unsigned(r.best.sad) then
                    r.best <= r.tobest;
                else
                    r.best <= r.best;
                end if;
            end if;
        end if;
    end process;
end qp_compare;

