library ieee;
use ieee.std_logic_1164.all;

package qpel_package is
    component memory is
    port (
        clock : in std_logic;
        wren  : in std_logic;
        addr  : in std_logic_vector;
        din   : in std_logic_vector;
        dout  : out std_logic_vector
    );
    end component memory;

    component filter is
    port (
        a : in std_logic_vector(7 downto 0);
        b : in std_logic_vector(7 downto 0);
        s : out std_logic_vector(7 downto 0)
    );
    end component filter;

    component row_interpolator is
    port (
        a : in std_logic_vector(151 downto 0);
        s : out std_logic_vector(143 downto 0)
    );
    end component row_interpolator;

    component col_interpolator is
    port (
        a : in std_logic_vector(135 downto 0);
        b : in std_logic_vector(135 downto 0);
        s : out std_logic_vector(135 downto 0)
    );
    end component col_interpolator;

    component diag_interpolator is
    port (
        sel : in std_logic;
        a : in std_logic_vector(151 downto 0);
        b : in std_logic_vector(151 downto 0);
        s : out std_logic_vector(143 downto 0)
    );
    end component diag_interpolator;

end qpel_package;
