library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.hpel_package.all;

entity hp_control is
    port (
        clock : in std_logic;
        reset : in std_logic;
        din   : in hp_control_i;
        dout  : out hp_control_o
    );
end hp_control;

architecture hp_control of hp_control is
begin
end hp_control;






