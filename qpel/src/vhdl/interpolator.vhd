library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.qpel_package.all;

entity interpolator is
    port (
        clock : in std_logic;
        reset : in std_logic;
        start : in std_logic;
        din   : in  std_logic_vector(151 downto 0);
        col   : out std_logic_vector(135 downto 0);
        row   : out std_logic_vector(143 downto 0);
        diag  : out std_logic_vector(143 downto 0);
        col_wren  : out std_logic;
        row_wren  : out std_logic;
        diag_wren : out std_logic;
        col_addr  : out std_logic_vector(5 downto 0);
        row_addr  : out std_logic_vector(5 downto 0);
        diag_addr : out std_logic_vector(5 downto 0);
    );
end interpolator;

architecture interpolator of interpolator is
    signal lineA  : std_logic_vector(151 downto 0);
    signal lineB  : std_logic_vector(151 downto 0);
    signal sel    : std_logic;

    signal col_s  : std_logic_vector(135 downto 0);
    signal row_s  : std_logic_vector(143 downto 0);
    signal diag_s : std_logic_vector(143 downto 0);
begin

    process(clock, reset, col_s, diag_s, row_s, din)
    begin
        if reset = '1' then
            current_state <= idle;

            col_wren  <= '0';
            row_wren  <= '0';
            diag_wren <= '0';

            col_addr  <= "000000";
            row_addr  <= "000000";
            diag_addr <= "000000";
            
            col   <= (others => '0');
            row   <= (others => '0');
            diag  <= (others => '0');
            lineA <= (others => '0');
            lineB <= (others => '0');
            
        elsif clock'event and clock = '1' then
            current_state <= next_state;

            col_wren  <= col_wren_s;
            row_wren  <= row_wren_s;
            diag_wren <= diag_wren_s;

            col_addr  <= col_addr_s;
            row_addr  <= row_addr_s;
            diag_addr <= diag_addr_s;

            col   <= col_s;
            row   <= row_s;
            diag  <= diag_s;
            lineA <= lineB;
            lineB <= din_i;
        end if;
    end process;

    process(current_state)
    begin
        case current_state is
            when idle =>
                sel_s <= '0';

                col_wren_s  <= '0';
                row_wren_s  <= '0';
                diag_wren_s <= '0';

                col_addr_s  <= "000000";
                row_addr_s  <= "000000";
                diag_addr_s <= "000000";

                if start = '1' then
                    next_state <= interpolating1;
                else
                    next_state <= idle;
                end if;

            when interpolating1 =>
                sel_s <= '0';

                col_wren_s  <= '0';
                row_wren_s  <= '0';
                diag_wren_s <= '0';

                col_addr_s  <= "000000";
                row_addr_s  <= "000000";
                diag_addr_s <= "000000";

                next_state <= interpolating2;

            when interpolating2 =>
                sel_s <= not sel;

                col_wren_s  <= '1';
                row_wren_s  <= '0';
                diag_wren_s <= '1';

                col_addr_s  <= std_logic_vector(unsigned(col_addr) + "000001");
                row_addr_s  <= "000000";
                diag_addr_s <= std_logic_vector(unsigned(diag_addr) + "000001");

                next_state <= interpolating3;

             when interpolating3 =>
                sel_s <= not sel;

                col_wren_s  <= '1';
                row_wren_s  <= '1';
                diag_wren_s <= '1';

                col_addr_s  <= std_logic_vector(unsigned(col_addr) + "000001");
                row_addr_s  <= std_logic_vector(unsigned(row_addr) + "000001");
                diag_addr_s <= std_logic_vector(unsigned(diag_addr) + "000001");
               
                if counter < 
    end process;

    col_interpolator_u : col_interpolator
    port map (lineA(143 downto 8), lineB(143 downto 8), col_s);

    row_interpolator_u : row_interpolator
    port map (lineA, row_s);

    diag_interpolator_u : diag_interpolator
    port map (sel, lineA, lineB, diag_s);
end interpolator;

