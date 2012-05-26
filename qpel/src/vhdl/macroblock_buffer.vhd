library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.qpel_package.all;

entity macroblock_buffer is
    port (  
        clock_i     : in std_logic;
        pel_wren_i  : in std_logic;
        col_wren_i  : in std_logic;
        row_wren_i  : in std_logic;
        diag_wren_i : in std_logic;
        pel_addr_i  : in std_logic_vector(2 downto 0);
        col_addr_i  : in std_logic_vector(4 downto 0);
        row_addr_i  : in std_logic_vector(4 downto 0);
        diag_addr_i : in std_logic_vector(4 downto 0);
        pel_din_i   : in std_logic_vector(63 downto 0);
        col_din_i   : in std_logic_vector(135 downto 0);
        row_din_i   : in std_logic_vector(143 downto 0);
        diag_din_i  : in std_logic_vector(143 downto 0);
        pel_dout_o  : out std_logic_vector(63 downto 0);
        col_dout_o  : out std_logic_vector(135 downto 0);
        row_dout_o  : out std_logic_vector(143 downto 0);
        diag_dout_o : out std_logic_vector(143 downto 0)
    );
end macroblock_buffer;

architecture macroblock_buffer of macroblock_buffer is
begin
    col_buffer : memory
    port map (clock_i, col_wren_i, col_addr_i, col_din_i, col_dout_o);

    row_buffer : memory
    port map (clock_i, row_wren_i, row_addr_i, row_din_i, row_dout_o);

    diag_buffer : memory
    port map (clock_i, diag_wren_i, diag_addr_i, diag_din_i, diag_dout_o);

    pel_buffer : memory
    port map (clock_i, pel_wren_i, pel_addr_i, pel_din_i, pel_dout_o);
end macroblock_buffer;
