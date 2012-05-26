library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.qpel_package.all;


entity control is
    port (
        clock_i : in std_logic;
        reset_i : in std_logic;
        start_i : in std_logic;

        pel_wren_o  : out std_logic;
        col_wren_o  : out std_logic;
        row_wren_o  : out std_logic;
        diag_wren_o : out std_logic;

        pel_addr_o  : out std_logic_vector(2 downto 0);
        col_addr_o  : out std_logic_vector(4 downto 0);
        row_addr_o  : out std_logic_vector(4 downto 0);
        diag_addr_o : out std_logic_vector(4 downto 0);

        diag_int_sel_o : out std_logic;
        done_o : out std_logic
    );
end control;

architecture control of control is
    type state is (idle, interpolating1, interpolating2, 
        interpolating3, interpolating4, interpolating5, end_interpolation);

    signal current_state : state;
    signal next_state    : state;

    signal done_s, done       : std_logic;
    signal sel_s, sel         : std_logic;
    signal counter_s, counter : integer;

    signal col_wren_s, col_wren   : std_logic;
    signal row_wren_s, row_wren   : std_logic;
    signal diag_wren_s, diag_wren : std_logic;

    signal col_addr_s, col_addr   : std_logic_vector(4 downto 0);
    signal row_addr_s, row_addr   : std_logic_vector(4 downto 0);
    signal diag_addr_s, diag_addr : std_logic_vector(4 downto 0);
begin

    -- modificar depois!
    pel_wren_o <= '0';
    pel_addr_o <= (others => '0');
    --end

    done_o <= done;
    
    col_addr_o  <= col_addr;
    row_addr_o  <= row_addr;
    diag_addr_o <= diag_addr;

    col_wren_o  <= col_wren;
    row_wren_o  <= row_wren;
    diag_wren_o <= diag_wren;

    process(clock_i, reset_i, col_wren_s, row_wren_s, diag_wren_s, next_state, 
        done_s, counter_s, col_addr_s, row_addr_s, diag_addr_s)
    begin
        if reset_i = '1' then
            current_state <= idle;
            done <= '0';
            counter <= 0;

            col_wren  <= '0';
            row_wren  <= '0';
            diag_wren <= '0';

            col_addr  <= "00000";
            row_addr  <= "00000";
            diag_addr <= "00000";
            
        elsif clock_i'event and clock_i = '1' then
            current_state <= next_state;
            done <= done_s;
            counter <= counter_s;

            col_wren  <= col_wren_s;
            row_wren  <= row_wren_s;
            diag_wren <= diag_wren_s;

            col_addr  <= col_addr_s;
            row_addr  <= row_addr_s;
            diag_addr <= diag_addr_s;

        end if;
    end process;

    process(current_state, start_i, counter, col_addr, row_addr, diag_addr, sel)
    begin
        case current_state is
            when idle =>
                done_s    <= '0';
                sel_s     <= '0';
                counter_s <= 0;

                col_wren_s  <= '0';
                row_wren_s  <= '0';
                diag_wren_s <= '0';

                col_addr_s  <= "00000";
                row_addr_s  <= "00000";
                diag_addr_s <= "00000";

                if start_i = '1' then
                    next_state <= interpolating1;
                else
                    next_state <= idle;
                end if;

            when interpolating1 =>
                done_s    <= '0';
                sel_s     <= '0';
                counter_s <= 0;

                col_wren_s  <= '0';
                row_wren_s  <= '0';
                diag_wren_s <= '0';

                col_addr_s  <= "00000";
                row_addr_s  <= "00000";
                diag_addr_s <= "00000";

                next_state <= interpolating2;

            when interpolating2 =>
                done_s    <= '0';
                sel_s     <= '0';
                counter_s <= 0;

                col_wren_s  <= '0';
                row_wren_s  <= '0';
                diag_wren_s <= '0';

                col_addr_s  <= "00000";
                row_addr_s  <= "00000";
                diag_addr_s <= "00000";

                next_state <= interpolating3;

            when interpolating3 =>
                done_s    <= '0';
                sel_s     <= not sel;
                counter_s <= 0;

                col_wren_s  <= '1';
                row_wren_s  <= '0';
                diag_wren_s <= '1';

                col_addr_s  <= std_logic_vector(unsigned(col_addr) + "00001");
                row_addr_s  <= "00000";
                diag_addr_s <= std_logic_vector(unsigned(diag_addr) + "00001");

                next_state <= interpolating4;

             when interpolating4 =>
                done_s    <= '0';
                sel_s     <= not sel;
                counter_s <= counter + 1;

                col_wren_s  <= '1';
                row_wren_s  <= '1';
                diag_wren_s <= '1';

                col_addr_s  <= std_logic_vector(unsigned(col_addr) + "00001");
                row_addr_s  <= std_logic_vector(unsigned(row_addr) + "00001");
                diag_addr_s <= std_logic_vector(unsigned(diag_addr) + "00001");
               
                if counter < 17 then
                    next_state <= interpolating4;
                else
                    next_state <= interpolating5;
                end if;

            when interpolating5 =>
                done_s    <= '0';
                sel_s     <= not sel;
                counter_s <= 0;

                col_wren_s  <= '1';
                row_wren_s  <= '0';
                diag_wren_s <= '1';

                col_addr_s  <= std_logic_vector(unsigned(col_addr) + "00001");
                row_addr_s  <= "00000";
                diag_addr_s <= std_logic_vector(unsigned(diag_addr) + "00001");

                next_state <= end_interpolation;

            when end_interpolation =>
                done_s    <= '1';
                sel_s     <= '0';
                counter_s <= 0;

                col_wren_s  <= '0';
                row_wren_s  <= '0';
                diag_wren_s <= '0';

                col_addr_s  <= "00000";
                row_addr_s  <= "00000";
                diag_addr_s <= "00000";

                next_state <= idle;

            when others =>
                sel_s <= '0';

                col_wren_s  <= '0';
                row_wren_s  <= '0';
                diag_wren_s <= '0';

                col_addr_s  <= "00000";
                row_addr_s  <= "00000";
                diag_addr_s <= "00000";

                next_state <= idle;
        end case;
    end process;

end control;

