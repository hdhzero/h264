library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.qpel_package.all;

entity memory is
    port (
        clock : in std_logic;
        wren  : in std_logic;
        addr  : in std_logic_vector;
        din   : in std_logic_vector;
        dout  : out std_logic_vector
    );
end memory;

architecture memory of memory is
    type ram is array (0 to 2 ** addr'length - 1) of std_logic_vector(din'range);
    signal mem : ram;
begin
    process(clock, wren, din, addr)
    begin
        if clock'event and clock = '1' then
            if wren = '1' then
                mem(to_integer(unsigned(addr))) <= din;
            end if;

            dout <= mem(to_integer(unsigned(addr)));
        end if;
    end process;
end memory;
