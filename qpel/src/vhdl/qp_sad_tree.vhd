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
    signal sad : std_logic_vector(15 downto 0);
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
    a <= unsigned(din.lineA.a) - unsigned(din.lineB.a) when unsigned(din.lineA.a) > unsigned(din.lineB.a) else
         unsigned(din.lineB.a) - unsigned(din.lineA.a);

    b <= unsigned(din.lineA.b) - unsigned(din.lineB.b) when unsigned(din.lineA.b) > unsigned(din.lineB.b) else
         unsigned(din.lineB.b) - unsigned(din.lineA.b);

    c <= unsigned(din.lineA.c) - unsigned(din.lineB.c) when unsigned(din.lineA.c) > unsigned(din.lineB.c) else
         unsigned(din.lineB.c) - unsigned(din.lineA.c);

    d <= unsigned(din.lineA.d) - unsigned(din.lineB.d) when unsigned(din.lineA.d) > unsigned(din.lineB.d) else
         unsigned(din.lineB.d) - unsigned(din.lineA.d);

    e <= unsigned(din.lineA.e) - unsigned(din.lineB.e) when unsigned(din.lineA.e) > unsigned(din.lineB.e) else
         unsigned(din.lineB.e) - unsigned(din.lineA.e);

    f <= unsigned(din.lineA.f) - unsigned(din.lineB.f) when unsigned(din.lineA.f) > unsigned(din.lineB.f) else
         unsigned(din.lineB.f) - unsigned(din.lineA.f);

    g <= unsigned(din.lineA.g) - unsigned(din.lineB.g) when unsigned(din.lineA.g) > unsigned(din.lineB.g) else
         unsigned(din.lineB.g) - unsigned(din.lineA.g);

    h <= unsigned(din.lineA.h) - unsigned(din.lineB.h) when unsigned(din.lineA.h) > unsigned(din.lineB.h) else
         unsigned(din.lineB.h) - unsigned(din.lineA.h);

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

            sad <= abcd + efgh;
        end if;
    end process;
end qp_sad_tree;





