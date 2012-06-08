library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.qpel_package.all;

entity qp_compare_tb is
end qp_compare_tb;

architecture qp_compare_tb of qp_compare_tb is
    signal clock : std_logic;
    signal reset : std_logic;
    signal qp_compare_din  : qp_compare_i;
    signal qp_compare_dout : qp_compare_o;
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
        qp_compare_din.clear <= '0';
        qp_compare_din.hp    <= (vec_x => "00", vec_y => "00", sad => x"0000");
        qp_compare_din.row   <= (vec_x => "00", vec_y => "00", sad => x"0000");
        qp_compare_din.col   <= (vec_x => "00", vec_y => "00", sad => x"0000");
        qp_compare_din.diag  <= (vec_x => "00", vec_y => "00", sad => x"0000");
        wait until clock'event and clock = '1';

        reset <= '0';
        qp_compare_din.clear <= '0';
        qp_compare_din.hp    <= (vec_x => "00", vec_y => "00", sad => x"0000");
        qp_compare_din.row   <= (vec_x => "00", vec_y => "00", sad => x"0000");
        qp_compare_din.col   <= (vec_x => "00", vec_y => "00", sad => x"0000");
        qp_compare_din.diag  <= (vec_x => "00", vec_y => "00", sad => x"0000");
        wait until clock'event and clock = '1';

        reset <= '1';
        qp_compare_din.clear <= '0';
        qp_compare_din.hp    <= (vec_x => "00", vec_y => "00", sad => x"0000");
        qp_compare_din.row   <= (vec_x => "00", vec_y => "00", sad => x"0000");
        qp_compare_din.col   <= (vec_x => "00", vec_y => "00", sad => x"0000");
        qp_compare_din.diag  <= (vec_x => "00", vec_y => "00", sad => x"0000");
        wait until clock'event and clock = '1';

        reset <= '0';
        qp_compare_din.clear <= '0';
        qp_compare_din.hp    <= (vec_x => "10", vec_y => "01", sad => x"0004");
        qp_compare_din.row   <= (vec_x => "11", vec_y => "00", sad => x"0001");
        qp_compare_din.col   <= (vec_x => "00", vec_y => "00", sad => x"0002");
        qp_compare_din.diag  <= (vec_x => "00", vec_y => "00", sad => x"0003");
        wait until clock'event and clock = '1';

        reset <= '0';
        qp_compare_din.clear <= '0';
        qp_compare_din.hp    <= (vec_x => "00", vec_y => "00", sad => x"0007");
        qp_compare_din.row   <= (vec_x => "00", vec_y => "00", sad => x"0008");
        qp_compare_din.col   <= (vec_x => "00", vec_y => "00", sad => x"0005");
        qp_compare_din.diag  <= (vec_x => "00", vec_y => "00", sad => x"0006");
        wait until clock'event and clock = '1';

        reset <= '0';
        qp_compare_din.clear <= '0';
        qp_compare_din.hp    <= (vec_x => "00", vec_y => "00", sad => x"2100");
        qp_compare_din.row   <= (vec_x => "00", vec_y => "00", sad => x"3000");
        qp_compare_din.col   <= (vec_x => "00", vec_y => "00", sad => x"0500");
        qp_compare_din.diag  <= (vec_x => "00", vec_y => "00", sad => x"0300");
        wait until clock'event and clock = '1';

        reset <= '0';
        qp_compare_din.clear <= '0';
        qp_compare_din.hp    <= (vec_x => "10", vec_y => "01", sad => x"0004");
        qp_compare_din.row   <= (vec_x => "11", vec_y => "00", sad => x"0001");
        qp_compare_din.col   <= (vec_x => "00", vec_y => "00", sad => x"0002");
        qp_compare_din.diag  <= (vec_x => "00", vec_y => "00", sad => x"0003");
        wait until clock'event and clock = '1';

        reset <= '0';
        qp_compare_din.clear <= '1';
        qp_compare_din.hp    <= (vec_x => "00", vec_y => "00", sad => x"0000");
        qp_compare_din.row   <= (vec_x => "00", vec_y => "00", sad => x"0000");
        qp_compare_din.col   <= (vec_x => "00", vec_y => "00", sad => x"0000");
        qp_compare_din.diag  <= (vec_x => "00", vec_y => "00", sad => x"0000");
        wait until clock'event and clock = '1';

        reset <= '0';
        qp_compare_din.clear <= '0';
        qp_compare_din.hp    <= (vec_x => "00", vec_y => "00", sad => x"0000");
        qp_compare_din.row   <= (vec_x => "00", vec_y => "00", sad => x"0000");
        qp_compare_din.col   <= (vec_x => "00", vec_y => "00", sad => x"0000");
        qp_compare_din.diag  <= (vec_x => "00", vec_y => "00", sad => x"0000");
        wait until clock'event and clock = '1';

        reset <= '0';
        qp_compare_din.clear <= '0';
        qp_compare_din.hp    <= (vec_x => "10", vec_y => "01", sad => x"0004");
        qp_compare_din.row   <= (vec_x => "11", vec_y => "00", sad => x"0001");
        qp_compare_din.col   <= (vec_x => "00", vec_y => "00", sad => x"0002");
        qp_compare_din.diag  <= (vec_x => "00", vec_y => "00", sad => x"0003");
        wait until clock'event and clock = '1';

        reset <= '0';
        qp_compare_din.clear <= '0';
        qp_compare_din.hp    <= (vec_x => "00", vec_y => "00", sad => x"0000");
        qp_compare_din.row   <= (vec_x => "00", vec_y => "00", sad => x"0000");
        qp_compare_din.col   <= (vec_x => "00", vec_y => "00", sad => x"0000");
        qp_compare_din.diag  <= (vec_x => "00", vec_y => "00", sad => x"0000");
        wait until clock'event and clock = '1';

        reset <= '0';
        qp_compare_din.clear <= '0';
        qp_compare_din.hp    <= (vec_x => "00", vec_y => "00", sad => x"0000");
        qp_compare_din.row   <= (vec_x => "00", vec_y => "00", sad => x"0000");
        qp_compare_din.col   <= (vec_x => "00", vec_y => "00", sad => x"0000");
        qp_compare_din.diag  <= (vec_x => "00", vec_y => "00", sad => x"0000");
        wait until clock'event and clock = '1';

        wait;
    end process;

    qp_compare_u : qp_compare
    port map (
        clock => clock,
        reset => reset,
        din   => qp_compare_din,
        dout  => qp_compare_dout
    );

end qp_compare_tb;

