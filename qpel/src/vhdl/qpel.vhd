library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.qpel_package.all;

entity qpel is
    port (
        clock_i : in std_logic;
        reset_i : in std_logic;
        start_i : in std_logic;

        hp_mb_i : in std_logic_vector(151 downto 0);
        done_o  : out std_logic        
    );
end qpel;

architecture qpel of qpel is
    signal pel_wren_w  : std_logic;
    signal col_wren_w  : std_logic;
    signal row_wren_w  : std_logic;
    signal diag_wren_w : std_logic;
    signal pel_addr_w  : std_logic_vector(2 downto 0);
    signal col_addr_w  : std_logic_vector(4 downto 0);
    signal row_addr_w  : std_logic_vector(4 downto 0);
    signal diag_addr_w : std_logic_vector(4 downto 0);
    signal pel_din_w   : std_logic_vector(63 downto 0);
    signal col_din_w   : std_logic_vector(135 downto 0);
    signal row_din_w   : std_logic_vector(143 downto 0);
    signal diag_din_w  : std_logic_vector(143 downto 0);
    signal pel_dout_w  : std_logic_vector(63 downto 0);
    signal col_dout_w  : std_logic_vector(135 downto 0);
    signal row_dout_w  : std_logic_vector(143 downto 0);
    signal diag_dout_w : std_logic_vector(143 downto 0);

    signal diag_int_sel_w : std_logic;

begin

    macroblock_buffer_u : macroblock_buffer
    port map (
        clock_i => clock_i,
        pel_wren_i  => pel_wren_w,
        col_wren_i  => col_wren_w,
        row_wren_i  => row_wren_w,
        diag_wren_i => diag_wren_w,
        pel_addr_i  => pel_addr_w,
        col_addr_i  => col_addr_w,
        row_addr_i  => row_addr_w,
        diag_addr_i => diag_addr_w,
        pel_din_i   => pel_din_w,
        col_din_i   => col_din_w,
        row_din_i   => row_din_w,
        diag_din_i  => diag_din_w,
        pel_dout_o  => pel_dout_w,
        col_dout_o  => col_dout_w,
        row_dout_o  => row_dout_w,
        diag_dout_o => diag_dout_w
    );

    control_u : control
    port map (
        clock_i => clock_i,
        reset_i => reset_i,
        start_i => start_i,

        col_wren_o  => col_wren_w,
        row_wren_o  => row_wren_w,
        diag_wren_o => diag_wren_w,

        col_addr_o => col_addr_w,
        row_addr_o => row_addr_w,
        diag_addr_o => diag_addr_w,

        diag_int_sel_o => diag_int_sel_w,
        done_o => done_o
    );

    interpolator_u : interpolator
    port map (
        clock_i => clock_i,
        reset_i => reset_i,
        din_i   => hp_mb_i,
        sel_i   => diag_int_sel_w,
        col_o   => col_din_w,
        row_o   => row_din_w,
        diag_o  => diag_din_w
    );
end qpel;

