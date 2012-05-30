library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.qpel_package.all;

entity qp_filter is
    port (
        din  : in qp_filter_i;
        dout : out qp_filter_o
    );
end qp_filter;

architecture qp_filter of _qpfilter is
    signal sum : unsigned(8 downto 0);
begin
    sum    <= unsigned('0' & din.a) + unsigned('0' & din.b) + "1";
    dout.s <= std_logic_vector(sum(8 downto 1));
end qp_filter;
