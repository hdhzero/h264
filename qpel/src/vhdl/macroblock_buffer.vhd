library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity macroblock_buffer is
    port (
        clock     : in std_logic;
        pel_wren  : in std_logic;
        col_wren  : in std_logic;
        row_wren  : in std_logic;
        diag_wren : in std_logic;
        pel_addr  : in std_logic_vector(2 downto 0);
        col_addr  : in std_logic_vector(4 downto 0);
        row_addr  : in std_logic_vector(4 downto 0);
        diag_addr : in std_logic_vector(4 downto 0);
        pel_din   : in std_logic_vector(63 downto 0);
        col_din   : in std_logic_vector(135 downto 0);
        row_din   : in std_logic_vector(143 downto 0);
        diag_din  : in std_logic_vector(143 downto 0);
        pel_dout  : out std_logic_vector(63 downto 0);
        col_dout  : out std_logic_vector(135 downto 0);
        row_dout  : out std_logic_vector(143 downto 0);
        diag_dout : out std_logic_vector(143 downto 0)
    );
end macroblock_buffer;

architecture macroblock_buffer of macroblock_buffer is
begin
    col_buffer : memory
    port map (clock, col_wren, col_addr, col_din, col_dout);

    row_buffer : memory
    port map (clock, row_wren, row_addr, row_din, row_dout);

    diag_buffer : memory
    port map (clock, diag_wren, diag_addr, diag_din, diag_dout);

    pel_buffer : memory
    port map (clock, pel_wren, pel_addr, pel_din, pel_dout);
end macroblock_buffer;
