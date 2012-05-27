library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.hpel_package.all;

entity hp_memory is
    port (
        clock_i : in std_logic;
        wren_i  : in std_logic;
        addr_i  : in std_logic_vector;
        din_i   : in std_logic_vector;
        dout_o  : out std_logic_vector
    );
end hp_memory;

architecture hp_memory of hp_memory is
    type ram is array (0 to 2 ** addr_i'length - 1) of std_logic_vector(din_i'range);
    signal mem : ram;
begin
    process(clock_i, wren_i, din_i, addr_i)
    begin
        if clock_i'event and clock_i = '1' then
            if wren_i = '1' then
                mem(to_integer(unsigned(addr_i))) <= din_i;
            end if;

            dout_o <= mem(to_integer(unsigned(addr_i)));
        end if;
    end process;
end hp_memory;
