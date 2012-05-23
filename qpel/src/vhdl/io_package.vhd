library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

package io_package is
    function str2vec(inp: string) return std_logic_vector; 
    function vec2str(inp: std_logic_vector) return string;
end io_package;

package body io_package is
    function str2vec(inp: string) return std_logic_vector is
        variable temp : std_logic_vector(inp'range) := (others => 'X');
    begin
        for i in inp'range loop
            if (inp(i) = '1') then
                temp(i) := '1';
            elsif (inp(i) = '0') then
                temp(i) := '0';
            end if;
        end loop;
        return temp;
    end function str2vec;

    function vec2str(inp: std_logic_vector) return string is
        variable temp: string(inp'left+1 downto 1) := (others => 'X');
    begin
        for i in inp'reverse_range loop
            if (inp(i) = '1') then
                temp(i+1) := '1';
            elsif (inp(i) = '0') then
                temp(i+1) := '0';
            end if;
        end loop;
        return temp;
    end function vec2str;
end package body;

