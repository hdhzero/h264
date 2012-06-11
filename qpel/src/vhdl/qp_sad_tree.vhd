library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.qpel_package.all;


entity qp_sad_tree is
    port (
        clock : in std_logic;
        reset : in std_logic;
        din   : in qp_sad_tree_i;
        dout  : out qp_sad_tree_o
    );
end qp_sad_tree;

architecture qp_sad_tree of qp_sad_tree is
    signal sad : unsigned(15 downto 0);
    signal a   : unsigned(15 downto 0);
    signal b   : unsigned(15 downto 0);
    signal c   : unsigned(15 downto 0);
    signal d   : unsigned(15 downto 0);
    signal e   : unsigned(15 downto 0);
    signal f   : unsigned(15 downto 0);
    signal g   : unsigned(15 downto 0);
    signal h   : unsigned(15 downto 0);
    
    signal ab  : unsigned(15 downto 0);
    signal cd  : unsigned(15 downto 0);
    signal ef  : unsigned(15 downto 0);
    signal gh  : unsigned(15 downto 0);

    signal abcd : unsigned(15 downto 0);
    signal efgh : unsigned(15 downto 0);
    
begin

    dout.res <= std_logic_vector(sad);

    process (din)
    begin
        if unsigned(din.lineA.a) > unsigned(din.lineB.a) then
            a <= x"00" & (unsigned(din.lineA.a) - unsigned(din.lineB.a));
        else
            a <= x"00" & (unsigned(din.lineB.a) - unsigned(din.lineA.a));
        end if;

        if unsigned(din.lineA.b) > unsigned(din.lineB.b) then
            b <= x"00" & (unsigned(din.lineA.b) - unsigned(din.lineB.b));
        else
            b <= x"00" & (unsigned(din.lineB.b) - unsigned(din.lineA.b));
        end if;

        if unsigned(din.lineA.c) > unsigned(din.lineB.c) then
            c <= x"00" & (unsigned(din.lineA.c) - unsigned(din.lineB.c));
        else
            c <= x"00" & (unsigned(din.lineB.c) - unsigned(din.lineA.c));
        end if;

        if unsigned(din.lineA.d) > unsigned(din.lineB.d) then
            d <= x"00" & (unsigned(din.lineA.d) - unsigned(din.lineB.d));
        else
            d <= x"00" & (unsigned(din.lineB.d) - unsigned(din.lineA.d));
        end if;

        if unsigned(din.lineA.e) > unsigned(din.lineB.e) then
            e <= x"00" & (unsigned(din.lineA.e) - unsigned(din.lineB.e));
        else
            e <= x"00" & (unsigned(din.lineB.e) - unsigned(din.lineA.e));
        end if;

        if unsigned(din.lineA.f) > unsigned(din.lineB.f) then
            f <= x"00" & (unsigned(din.lineA.f) - unsigned(din.lineB.f));
        else
            f <= x"00" & (unsigned(din.lineB.f) - unsigned(din.lineA.f));
        end if;

        if unsigned(din.lineA.g) > unsigned(din.lineB.g) then
            g <= x"00" & (unsigned(din.lineA.g) - unsigned(din.lineB.g));
        else
            g <= x"00" & (unsigned(din.lineB.g) - unsigned(din.lineA.g));
        end if;

        if unsigned(din.lineA.h) > unsigned(din.lineB.h) then
            h <= x"00" & (unsigned(din.lineA.h) - unsigned(din.lineB.h));
        else
            h <= x"00" & (unsigned(din.lineB.h) - unsigned(din.lineA.h));
        end if;

    end process;

    abcd <= ab + cd;
    efgh <= ef + gh;

    process (clock, reset)
    begin
        if reset = '1' then
            ab  <= (others => '0');
            cd  <= (others => '0');
            ef  <= (others => '0');
            gh  <= (others => '0');
            sad <= (others => '0');
        elsif clock'event and clock = '1' then
            ab <= a + b;
            cd <= c + d;
            ef <= e + f;
            gh <= g + h;

            if din.clear = '1' then
                sad <= (others => '0');
            else
                sad <= abcd + efgh + sad;
            end if;
        end if;
    end process;
end qp_sad_tree;





