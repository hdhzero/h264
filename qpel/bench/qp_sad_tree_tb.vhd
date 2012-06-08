library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.qpel_package.all;

entity qp_sad_tree_tb is
end qp_sad_tree_tb;

architecture qp_sad_tree_tb of qp_sad_tree_tb is
    signal clock : std_logic;
    signal reset : std_logic;
    signal qp_sad_tree_din  : qp_sad_tree_i;
    signal qp_sad_tree_dout : qp_sad_tree_o;
begin

    process
    begin
        clock <= '1';
        wait for 5 ns;
        clock <= '0';
        wait for 5 ns;
    end process;

    process
    begin
        reset <= '0';
        qp_sad_tree_din.lineA.a <= (others => '0');
        qp_sad_tree_din.lineA.b <= (others => '0');
        qp_sad_tree_din.lineA.c <= (others => '0');
        qp_sad_tree_din.lineA.d <= (others => '0');
        qp_sad_tree_din.lineA.e <= (others => '0');
        qp_sad_tree_din.lineA.f <= (others => '0');
        qp_sad_tree_din.lineA.g <= (others => '0');
        qp_sad_tree_din.lineA.h <= (others => '0');

        qp_sad_tree_din.lineB.a <= (others => '0');
        qp_sad_tree_din.lineB.b <= (others => '0');
        qp_sad_tree_din.lineB.c <= (others => '0');
        qp_sad_tree_din.lineB.d <= (others => '0');
        qp_sad_tree_din.lineB.e <= (others => '0');
        qp_sad_tree_din.lineB.f <= (others => '0');
        qp_sad_tree_din.lineB.g <= (others => '0');
        qp_sad_tree_din.lineB.h <= (others => '0');
        wait until clock'event and clock = '1';

        reset <= '1';
        qp_sad_tree_din.lineA.a <= (others => '0');
        qp_sad_tree_din.lineA.b <= (others => '0');
        qp_sad_tree_din.lineA.c <= (others => '0');
        qp_sad_tree_din.lineA.d <= (others => '0');
        qp_sad_tree_din.lineA.e <= (others => '0');
        qp_sad_tree_din.lineA.f <= (others => '0');
        qp_sad_tree_din.lineA.g <= (others => '0');
        qp_sad_tree_din.lineA.h <= (others => '0');

        qp_sad_tree_din.lineB.a <= (others => '0');
        qp_sad_tree_din.lineB.b <= (others => '0');
        qp_sad_tree_din.lineB.c <= (others => '0');
        qp_sad_tree_din.lineB.d <= (others => '0');
        qp_sad_tree_din.lineB.e <= (others => '0');
        qp_sad_tree_din.lineB.f <= (others => '0');
        qp_sad_tree_din.lineB.g <= (others => '0');
        qp_sad_tree_din.lineB.h <= (others => '0');
        wait until clock'event and clock = '1';

        reset <= '0';
        qp_sad_tree_din.lineA.a <= x"08";
        qp_sad_tree_din.lineA.b <= x"02";
        qp_sad_tree_din.lineA.c <= x"00";
        qp_sad_tree_din.lineA.d <= x"00";
        qp_sad_tree_din.lineA.e <= x"00";
        qp_sad_tree_din.lineA.f <= x"00";
        qp_sad_tree_din.lineA.g <= x"00";
        qp_sad_tree_din.lineA.h <= x"00";

        qp_sad_tree_din.lineB.a <= x"06";
        qp_sad_tree_din.lineB.b <= x"06";
        qp_sad_tree_din.lineB.c <= x"00";
        qp_sad_tree_din.lineB.d <= x"00";
        qp_sad_tree_din.lineB.e <= x"00";
        qp_sad_tree_din.lineB.f <= x"00";
        qp_sad_tree_din.lineB.g <= x"00";
        qp_sad_tree_din.lineB.h <= x"00";
        wait until clock'event and clock = '1';

        reset <= '0';
        qp_sad_tree_din.lineA.a <= x"00";
        qp_sad_tree_din.lineA.b <= x"00";
        qp_sad_tree_din.lineA.c <= x"00";
        qp_sad_tree_din.lineA.d <= x"00";
        qp_sad_tree_din.lineA.e <= x"00";
        qp_sad_tree_din.lineA.f <= x"00";
        qp_sad_tree_din.lineA.g <= x"00";
        qp_sad_tree_din.lineA.h <= x"00";

        qp_sad_tree_din.lineB.a <= x"00";
        qp_sad_tree_din.lineB.b <= x"00";
        qp_sad_tree_din.lineB.c <= x"00";
        qp_sad_tree_din.lineB.d <= x"00";
        qp_sad_tree_din.lineB.e <= x"00";
        qp_sad_tree_din.lineB.f <= x"00";
        qp_sad_tree_din.lineB.g <= x"00";
        qp_sad_tree_din.lineB.h <= x"00";
        wait until clock'event and clock = '1';


        reset <= '0';
        qp_sad_tree_din.lineA.a <= x"00";
        qp_sad_tree_din.lineA.b <= x"00";
        qp_sad_tree_din.lineA.c <= x"00";
        qp_sad_tree_din.lineA.d <= x"00";
        qp_sad_tree_din.lineA.e <= x"00";
        qp_sad_tree_din.lineA.f <= x"00";
        qp_sad_tree_din.lineA.g <= x"00";
        qp_sad_tree_din.lineA.h <= x"00";

        qp_sad_tree_din.lineB.a <= x"00";
        qp_sad_tree_din.lineB.b <= x"00";
        qp_sad_tree_din.lineB.c <= x"00";
        qp_sad_tree_din.lineB.d <= x"00";
        qp_sad_tree_din.lineB.e <= x"00";
        qp_sad_tree_din.lineB.f <= x"00";
        qp_sad_tree_din.lineB.g <= x"00";
        qp_sad_tree_din.lineB.h <= x"00";
        wait until clock'event and clock = '1';

        reset <= '0';
        qp_sad_tree_din.lineA.a <= x"00";
        qp_sad_tree_din.lineA.b <= x"00";
        qp_sad_tree_din.lineA.c <= x"00";
        qp_sad_tree_din.lineA.d <= x"00";
        qp_sad_tree_din.lineA.e <= x"00";
        qp_sad_tree_din.lineA.f <= x"00";
        qp_sad_tree_din.lineA.g <= x"00";
        qp_sad_tree_din.lineA.h <= x"00";

        qp_sad_tree_din.lineB.a <= x"00";
        qp_sad_tree_din.lineB.b <= x"00";
        qp_sad_tree_din.lineB.c <= x"00";
        qp_sad_tree_din.lineB.d <= x"00";
        qp_sad_tree_din.lineB.e <= x"00";
        qp_sad_tree_din.lineB.f <= x"00";
        qp_sad_tree_din.lineB.g <= x"00";
        qp_sad_tree_din.lineB.h <= x"00";
        wait until clock'event and clock = '1';

        wait;
    end process;

    qp_sad_tree_u : qp_sad_tree
    port map (
        clock => clock,
        reset => reset,
        din   => qp_sad_tree_din,
        dout  => qp_sad_tree_dout
    );

end qp_sad_tree_tb;
