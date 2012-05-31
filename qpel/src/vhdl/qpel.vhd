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
begin

--    macroblock_buffer_u : macroblock_buffer
--    port map (
--        clock_i => clock_i,
--        pel_wren_i  => pel_wren_w,
--        col_wren_i  => col_wren_w,
--        row_wren_i  => row_wren_w,
--        diag_wren_i => diag_wren_w,
--        pel_addr_i  => pel_addr_w,
--        col_addr_i  => col_addr_w,
--        row_addr_i  => row_addr_w,
--        diag_addr_i => diag_addr_w,
--        pel_din_i   => pel_din_w,
--        col_din_i   => col_din_w,
--        row_din_i   => row_din_w,
--        diag_din_i  => diag_din_w,
--        pel_dout_o  => pel_dout_w,
--        col_dout_o  => col_dout_w,
--        row_dout_o  => row_dout_w,
--        diag_dout_o => diag_dout_w
--    );

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

