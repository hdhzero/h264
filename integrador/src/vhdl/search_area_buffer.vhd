library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

type search_area_buffer_i is record
    start_write_buffer : std_logic;
    start_init_line    : std_logic;
end record;

type search_area_buffer_o is record
    ref_mb : std_logic_vector(63 downto 0);
end record;
    
entity search_area_buffer is
    port (
        clock : in std_logic;
        reset : in std_logic;
        din   : in search_area_buffer_i;
        dout  : out search_area_buffer_o
    );
end search_area_buffer;

architecture search_area_buffer of search_area_buffer is
    type ram is array (0 to 31) of std_logic_vector(63 downto 0);
    type state is (idle);

    signal current_state : state;
    signal next_state    : state;

    signal bank0 : ram;
    signal bank1 : ram;
    signal bank2 : ram;
    signal bank3 : ram;
    signal bank4 : ram;
    signal bank5 : ram;

    type bank_mem_ctrl is record
        wren : std_logic;
        addr : std_logic_vector(4 downto 0);
    end record;

    signal bank0_ctrl : bank_mem_ctrl;
    signal bank1_ctrl : bank_mem_ctrl;
    signal bank2_ctrl : bank_mem_ctrl;
    signal bank3_ctrl : bank_mem_ctrl;
    signal bank4_ctrl : bank_mem_ctrl;
    signal bank5_ctrl : bank_mem_ctrl;
    
begin
    process (clock, din)
    begin
        if clock'event and clock = '1' then
        end if;
    end process;

    process (current_state)
    begin
    end process;
    
end search_area_buffer;
