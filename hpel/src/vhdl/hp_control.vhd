library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.hpel_package.all;

entity hp_control is
    port (
        clock_i : in std_logic;
        reset_i : in std_logic;
        start_i : in std_logic;
        done_o  : out std_logic
    );
end hp_control;

architecture hp_control of hp_control is
begin
    done_o <= clock_i and reset_i and start_i;
end hp_control;
