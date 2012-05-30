library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.qpel_package.all;

entity col_mux is
    port (
        din  : in qp_col_mux_i;
        dout : out qp_col_mux_o
    );
end col_mux;

architecture col_mux of col_mux is
begin
    process(din.sel, din.i)
    begin
        case din.sel is
            when "001" =>
                dout.o(7 downto 0)   <= din.i(7 downto 0);
                dout.o(15 downto 8)  <= din.i(23 downto 16);
                dout.o(23 downto 16) <= din.i(39 downto 32);
                dout.o(31 downto 24) <= din.i(55 downto 48);
                dout.o(39 downto 32) <= din.i(71 downto 64);
                dout.o(47 downto 40) <= din.i(87 downto 80);
                dout.o(55 downto 48) <= din.i(103 downto 96);
                dout.o(63 downto 56) <= din.i(119 downto 112);
            when "010" =>
                dout.o(7 downto 0)   <= din.i(15 downto 8);
                dout.o(15 downto 8)  <= din.i(31 downto 24);
                dout.o(23 downto 16) <= din.i(47 downto 40);
                dout.o(31 downto 24) <= din.i(63 downto 56);
                dout.o(39 downto 32) <= din.i(79 downto 72);
                dout.o(47 downto 40) <= din.i(95 downto 88);
                dout.o(55 downto 48) <= din.i(111 downto 104);
                dout.o(63 downto 56) <= din.i(127 downto 120);
            when "100" =>
                dout.o(7 downto 0)   <= din.i(23 downto 16);
                dout.o(15 downto 8)  <= din.i(39 downto 32);
                dout.o(23 downto 16) <= din.i(55 downto 48);
                dout.o(31 downto 24) <= din.i(71 downto 64);
                dout.o(39 downto 32) <= din.i(87 downto 80);
                dout.o(47 downto 40) <= din.i(103 downto 96);
                dout.o(55 downto 48) <= din.i(119 downto 112);
                dout.o(63 downto 56) <= din.i(135 downto 128);
            when others =>
                dout.o(7 downto 0)   <= din.i(23 downto 16);
                dout.o(15 downto 8)  <= din.i(39 downto 32);
                dout.o(23 downto 16) <= din.i(55 downto 48);
                dout.o(31 downto 24) <= din.i(71 downto 64);
                dout.o(39 downto 32) <= din.i(87 downto 80);
                dout.o(47 downto 40) <= din.i(103 downto 96);
                dout.o(55 downto 48) <= din.i(119 downto 112);
                dout.o(63 downto 56) <= din.i(135 downto 128);
        end case;
    end process;
end col_mux;
