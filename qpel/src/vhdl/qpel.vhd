library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.qpel_package.all;

entity qpel is
    port (
        clock : in std_logic;
        reset : in std_logic;
        din   : in qpel_i;
        dout  : out qpel_o
    );
end qpel;

architecture qpel of qpel is
    signal qp_control_din  : qp_control_i;
    signal qp_control_dout : qp_control_o;

    signal qp_interpolator_din  : qp_interpolator_i;
    signal qp_interpolator_dout : qp_interpolator_o;

    signal qp_macroblock_buffer_din  : qp_macroblock_buffer_i;
    signal qp_macroblock_buffer_dout : qp_macroblock_buffer_o;
begin

    qp_macroblock_buffer_din.pel.wren <= qp_control_dout.pel.wren;
    qp_macroblock_buffer_din.pel.addr <= qp_control_dout.pel.addr;
    qp_macroblock_buffer_din.pel.din  <= (others => '0');
    
    qp_macroblock_buffer_din.col.wren <= qp_control_dout.col.wren;
    qp_macroblock_buffer_din.col.addr <= qp_control_dout.col.addr;
    qp_macroblock_buffer_din.col.din  <= qp_interpolator_dout.col;

    qp_macroblock_buffer_din.row.wren <= qp_control_dout.row.wren;
    qp_macroblock_buffer_din.row.addr <= qp_control_dout.row.addr;
    qp_macroblock_buffer_din.row.din  <= qp_interpolator_dout.row;
 
    qp_macroblock_buffer_din.diag.wren <= qp_control_dout.diag.wren;
    qp_macroblock_buffer_din.diag.addr <= qp_control_dout.diag.addr;
    qp_macroblock_buffer_din.diag.din  <= qp_interpolator_dout.diag;

    qp_macroblock_buffer_u : qp_macroblock_buffer
    port map (
        clock => clock,
        din   => qp_macroblock_buffer_din,
        dout  => qp_macroblock_buffer_dout
    );

    

    qp_interpolator_din.i <= din.hp_mb_i;
    qp_control_din.start <= din.start;
    qp_interpolator_din.sel <= qp_control_dout.sel;

    qp_control_u : qp_control
    port map (
        clock => clock,
        reset => reset,
        din   => qp_control_din,
        dout  => qp_control_dout
    );

    qp_interpolator_u : qp_interpolator
    port map (
        clock => clock,
        reset => reset,
        din   => qp_interpolator_din,
        dout  => qp_interpolator_dout
    );
end qpel;

