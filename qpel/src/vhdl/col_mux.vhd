library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity col_mux is
    port (
        sel  : in std_logic_vector(2 downto 0);
        din  : in std_logic_vector(135 downto 0);
        dout : out std_logic_vector(63 downto 0)
    );
end col_mux;

architecture col_mux of col_mux is
begin
    process(sel, din)
    begin
        case sel is
            when "001" =>
                dout(7 downto 0)   <= din(7 downto 0);
                dout(15 downto 8)  <= din(23 downto 16);
                dout(23 downto 16) <= din(39 downto 32);
                dout(31 downto 24) <= din(55 downto 48);
                dout(39 downto 32) <= din(71 downto 64);
                dout(47 downto 40) <= din(87 downto 80);
                dout(55 downto 48) <= din(103 downto 96);
                dout(63 downto 56) <= din(119 downto 112);
            when "010" =>
                dout(7 downto 0)   <= din(15 downto 8);
                dout(15 downto 8)  <= din(31 downto 24);
                dout(23 downto 16) <= din(47 downto 40);
                dout(31 downto 24) <= din(63 downto 56);
                dout(39 downto 32) <= din(79 downto 72);
                dout(47 downto 40) <= din(95 downto 88);
                dout(55 downto 48) <= din(111 downto 104);
                dout(63 downto 56) <= din(127 downto 120);
            when "100" =>
                dout(7 downto 0)   <= din(23 downto 16);
                dout(15 downto 8)  <= din(39 downto 32);
                dout(23 downto 16) <= din(55 downto 48);
                dout(31 downto 24) <= din(71 downto 64);
                dout(39 downto 32) <= din(87 downto 80);
                dout(47 downto 40) <= din(103 downto 96);
                dout(55 downto 48) <= din(119 downto 112);
                dout(63 downto 56) <= din(135 downto 128);
            when others =>
                dout(7 downto 0)   <= din(23 downto 16);
                dout(15 downto 8)  <= din(39 downto 32);
                dout(23 downto 16) <= din(55 downto 48);
                dout(31 downto 24) <= din(71 downto 64);
                dout(39 downto 32) <= din(87 downto 80);
                dout(47 downto 40) <= din(103 downto 96);
                dout(55 downto 48) <= din(119 downto 112);
                dout(63 downto 56) <= din(135 downto 128);
        end case;
    end process;
end col_mux;
