library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity interpolator is
    port (
        clock : in std_logic;
        reset : in std_logic;
        start : in std_logic;
        din   : in  std_logic_vector(151 downto 0);
        col   : out std_logic_vector(135 downto 0);
        row   : out std_logic_vector(143 downto 0);
        diag  : out std_logic_vector(143 downto 0)
    );
end interpolator;

architecture interpolator of interpolator is
    component col_interpolator is
    port (
        a : in std_logic_vector(135 downto 0);
        b : in std_logic_vector(135 downto 0);
        s : out std_logic_vector(135 downto 0)
    );
    end component col_interpolator;

    component row_interpolator is
    port (
        a : in std_logic_vector(151 downto 0);
        s : out std_logic_vector(143 downto 0)
    );
    end component row_interpolator;

    component diag_interpolator is
    port (
        sel : in std_logic;
        a : in std_logic_vector(151 downto 0);
        b : in std_logic_vector(151 downto 0);
        s : out std_logic_vector(143 downto 0)
    );
    end component diag_interpolator;

    type state is (idle, interpolating);
    signal current_state : state;

    signal line0   : std_logic_vector(151 downto 0);
    signal line1   : std_logic_vector(151 downto 0);
    signal sel     : std_logic;
    signal counter : integer;
    signal col_s   : std_logic_vector(135 downto 0);
    signal row_s   : std_logic_vector(143 downto 0);
    signal diag_s  : std_logic_vector(143 downto 0);
begin

    process(clock, reset, col_s, row_s, diag_s)
    begin
        if reset = '1' then
            col  <= (others => '0');
            row  <= (others => '0');
            diag <= (others => '0');
        elsif clock'event and clock = '1' then
            col  <= col_s;
            row  <= row_s;
            diag <= diag_s;
        end if;
    end process;

    process(clock, reset, start, din)
    begin
        if reset = '1' then
            line0   <= (others => '0');
            line1   <= (others => '0');
            counter <= 0;
            current_state <= idle;
        elsif clock'event and clock = '1' then
            case current_state is
                when idle =>
                    if start = '1' then
                        counter <= 0;
                        line0   <= (others => '0');
                        line1   <= (others => '0');
                        current_state <= interpolating;
                    end if;
                when others =>
                    if counter < 17 then
                        counter <= counter + 1;
                        line0   <= din;
                        line1   <= line0;
                    else
                        current_state <= idle;
                    end if;
            end case;
        end if;
    end process;


    col_interpolator_u : col_interpolator
    port map (line0(143 downto 8), line1(143 downto 8), col);

    row_interpolator_u : row_interpolator
    port map (line0, row);

    diag_interpolator_u : diag_interpolator
    port map (sel, line0, line1, diag);
end interpolator;

