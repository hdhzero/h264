library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.hpel_package.all;

entity hp_control is
    port (
        clock_i : in std_logic;
        reset_i : in std_logic;
        start_i : in std_logic;

        pel_wren_o  : out std_logic;
        ref_wren_o  : out std_logic;
        col_wren_o  : out std_logic;
        row_wren_o  : out std_logic;
        diag_wren_o : out std_logic;
        pel_addr_o  : out std_logic_vector(2 downto 0);
        ref_addr_o  : out std_logic_vector(3 downto 0);
        col_addr_o  : out std_logic_vector(3 downto 0);
        row_addr_o  : out std_logic_vector(3 downto 0);
        diag_addr_o : out std_logic_vector(3 downto 0);

        done_o  : out std_logic
    );
end hp_control;

architecture hp_control of hp_control is
    type state is (idle, interpolating1);

    signal current_state : state;
    signal next_state    : state;

    signal done_s, done_reg : std_logic;

    signal pel_wren_s, pel_wren_reg   : std_logic;
    signal ref_wren_s, ref_wren_reg   : std_logic;
    signal col_wren_s, col_wren_reg   : std_logic;
    signal row_wren_s, row_wren_reg   : std_logic;
    signal diag_wren_s, diag_wren_reg : std_logic;

    signal pel_addr_s, pel_addr_reg   : std_logic_vector(2 downto 0);
    signal ref_addr_s, ref_addr_reg   : std_logic_vector(3 downto 0);
    signal col_addr_s, col_addr_reg   : std_logic_vector(3 downto 0);
    signal row_addr_s, row_addr_reg   : std_logic_vector(3 downto 0);
    signal diag_addr_s, diag_addr_reg : std_logic_vector(3 downto 0);

begin
    done_o <= done_reg;

    process (clock_i, reset_i)
    begin
        if reset_i = '1' then
            done_reg <= '0';

            pel_wren_reg  <= '0';
            ref_wren_reg  <= '0';
            col_wren_reg  <= '0';
            row_wren_reg  <= '0';
            diag_wren_reg <= '0';
                
            pel_addr_reg  <= "000";
            ref_addr_reg  <= "0000";
            col_addr_reg  <= "0000";
            row_addr_reg  <= "0000";
            diag_addr_reg <= "0000";
        elsif clock_i'event and clock_i = '1' then
            done_reg <= done_s;

            pel_wren_reg  <= pel_wren_s;
            ref_wren_reg  <= ref_wren_s;
            col_wren_reg  <= col_wren_s;
            row_wren_reg  <= row_wren_s;
            diag_wren_reg <= diag_wren_s;
                
            pel_addr_reg  <= pel_addr_s;
            ref_addr_reg  <= reg_addr_s;
            col_addr_reg  <= col_addr_s;
            row_addr_reg  <= row_addr_s;
            diag_addr_reg <= diag_addr_s;

        end if;           
    end process;

    process (current_state)
    begin
        case current_state is
            when idle =>
                done_s <= '0';

                pel_wren_s  <= '0';
                ref_wren_s  <= '0';
                col_wren_s  <= '0';
                row_wren_s  <= '0';
                diag_wren_s <= '0';
                
                pel_addr_s  <= "000";
                ref_addr_s  <= "0000";
                col_addr_s  <= "0000";
                row_addr_s  <= "0000";
                diag_addr_s <= "0000";
                
                if start = '1' then
                    next_state <= interpolating1;
                else
                    next_state <= idle;
                end if;

            when interpolating1 =>
                done_s <= '0';


        end case;
    end process;
end hp_control;






