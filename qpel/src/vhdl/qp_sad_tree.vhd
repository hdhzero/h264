library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

type mb_line_t is record
    a : std_logic_vector(7 downto 0);
    b : std_logic_vector(7 downto 0);
    c : std_logic_vector(7 downto 0);
    d : std_logic_vector(7 downto 0);
    e : std_logic_vector(7 downto 0);
    f : std_logic_vector(7 downto 0);
    g : std_logic_vector(7 downto 0);
    h : std_logic_vector(7 downto 0);
end record;
    
type qp_sad_tree_i is record
    clear : std_logic;
    lineA : mb_line_t;
    lineB : mb_line_t;
end record;

type qp_sad_tree_o is record
    res : std_logic_vector(15 downto 0);
end record;

entity qp_sad_tree is
    port (
        clock : in std_logic;
        reset : in std_logic;
        din   : in qp_sad_tree_i;
        dout  : out qp_sad_tree_o
    );
end qp_sad_tree;

architecture qp_sad_tree of qp_sad_tree is
    sad : std_logic_vector(15 downto 0);
begin
    process (clock, reset)
    begin
        if reset = '1' then
            sad <= (others => '0');
    end process;
end qp_sad_tree;





