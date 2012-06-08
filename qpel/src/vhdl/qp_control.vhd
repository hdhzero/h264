library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.qpel_package.all;


entity qp_control is
    port (
        clock : in std_logic;
        reset : in std_logic;
        din   : in qp_control_i;
        dout  : out qp_control_o
    );
end qp_control;

architecture qp_control of qp_control is
    type state_t is (idle, interpolating1, interpolating2, interpolating1A,
        interpolating3, interpolating4, interpolating5, interpolating6, end_interpolation);

    type reg_type is record
        state : state_t;
        pel   : qp_pel_mem_ctrl_i;
        col   : qp_col_mem_ctrl_i;
        row   : qp_row_mem_ctrl_i;
        diag  : qp_diag_mem_ctrl_i;
        done  : std_logic;
        sel   : std_logic;
        cont  : integer;
    end record;

    signal cur : reg_type;
    signal nxt : reg_type;
begin
    dout.done <= cur.done;
    dout.pel  <= cur.pel;
    dout.col  <= cur.col;
    dout.diag <= cur.diag;
   
    process (clock, reset, nxt)
    begin
        if reset = '1' then
            cur.state   <= idle;
            cur.done    <= '0';
            cur.cont <= 0;

            cur.pel.wren  <= '0';
            cur.col.wren  <= '0';
            cur.row.wren  <= '0';
            cur.diag.wren <= '0';

            cur.pel.addr  <= "000";
            cur.col.addr  <= "00000";
            cur.row.addr  <= "00000";
            cur.diag.addr <= "00000";
            
        elsif clock'event and clock = '1' then
            cur <= nxt;
        end if;
    end process;

    process (cur, din)
    begin
        case cur.state is
            when idle =>
                nxt.done <= '0';
                nxt.sel  <= '0';
                nxt.cont <= 0;

                nxt.col.wren  <= '0';
                nxt.row.wren  <= '0';
                nxt.diag.wren <= '0';

                nxt.col.addr  <= "00000";
                nxt.row.addr  <= "00000";
                nxt.diag.addr <= "00000";

                if din.start = '1' then
                    nxt.state <= interpolating1;
                else
                    nxt.state <= idle;
                end if;

            when interpolating1 =>
                nxt.done <= '0';
                nxt.sel  <= '0';
                nxt.cont <= cur.cont + 1;

                nxt.col.wren <= '0';
                nxt.row.wren <= '0';
                nxt.diag.wren <= '0';

                nxt.col.addr  <= "00000";
                nxt.row.addr  <= "00000";
                nxt.diag.addr <= "00000";

                if cur.cont < 1 then
                    nxt.state <= interpolating1;
                else
                    nxt.state <= interpolating2;
                end if;

            when interpolating2 =>
                nxt.done <= '0';
                nxt.sel  <= '0';
                nxt.cont <= 0;

                nxt.col.wren <= '1';
                nxt.row.wren <= '0';
                nxt.diag.wren <= '1';

                nxt.col.addr  <= "00000";
                nxt.row.addr  <= "00000";
                nxt.diag.addr <= "00000";

                nxt.state <= interpolating3;

            when interpolating3 =>
                nxt.done <= '0';
                nxt.sel  <= not cur.sel;
                nxt.cont <= 0;

                nxt.col.wren <= '1';
                nxt.row.wren <= '1';
                nxt.diag.wren <= '1';

                nxt.col.addr  <= std_logic_vector(unsigned(cur.col.addr) + "00001");
                nxt.row.addr  <= "00000";
                nxt.diag.addr <= std_logic_vector(unsigned(cur.diag.addr) + "00001");

                nxt.state <= interpolating4;

            when interpolating4 =>
                nxt.done <= '0';
                nxt.sel  <= not cur.sel;
                nxt.cont <= cur.cont + 1;

                nxt.col.wren <= '1';
                nxt.row.wren <= '1';
                nxt.diag.wren <= '1';

                nxt.col.addr  <= std_logic_vector(unsigned(cur.col.addr) + "00001");
                nxt.row.addr  <= std_logic_vector(unsigned(cur.row.addr) + "00001");
                nxt.diag.addr <= std_logic_vector(unsigned(cur.diag.addr) + "00001");

                if cur.cont < 15 then
                    nxt.state <= interpolating4;
                else
                    nxt.state <= interpolating5;
                end if;

            when interpolating5 =>
                nxt.done <= '0';
                nxt.sel  <= not cur.sel;
                nxt.cont <= 0;

                nxt.col.wren <= '1';
                nxt.row.wren <= '0';
                nxt.diag.wren <= '1';

                nxt.col.addr  <= std_logic_vector(unsigned(cur.col.addr) + "00001");
                nxt.row.addr  <= "00000";
                nxt.diag.addr <= std_logic_vector(unsigned(cur.diag.addr) + "00001");
                nxt.state <= end_interpolation;

            when end_interpolation=>
                nxt.done <= '1';
                nxt.sel  <= '0';
                nxt.cont <= 0;

                nxt.col.wren <= '0';
                nxt.row.wren <= '0';
                nxt.diag.wren <= '0';

                nxt.col.addr  <= "00000";
                nxt.row.addr  <= "00000";
                nxt.diag.addr <= "00000";

                nxt.state <= idle;

            when others =>
                nxt.done    <= '0';
                nxt.sel     <= '0';
                nxt.cont <= 0;

                nxt.col.wren  <= '0';
                nxt.row.wren  <= '0';
                nxt.diag.wren <= '0';

                nxt.col.addr  <= "00000";
                nxt.row.addr  <= "00000";
                nxt.diag.addr <= "00000";

                nxt.state <= idle;
        end case;
    end process;

end qp_control;

