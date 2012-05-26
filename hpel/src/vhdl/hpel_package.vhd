library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package hpel_package is
    component hp_memory is
    port (
        clock_i : in std_logic;
        wren_i  : in std_logic;
        addr_i  : in std_logic_vector;
        din_i   : in std_logic_vector;
        dout_o  : out std_logic_vector
    );
    end component hp_memory;

    component hp_filter is
    port (
        a : in std_logic_vector(7 downto 0);
        b : in std_logic_vector(7 downto 0);
        c : in std_logic_vector(7 downto 0);
        d : in std_logic_vector(7 downto 0);
        e : in std_logic_vector(7 downto 0);
        f : in std_logic_vector(7 downto 0);
        s : out std_logic_vector(7 downto 0)
    );
    end component hp_filter;

    component hp_col_interpolator is
    port (
        lineA_i : in std_logic_vector(111 downto 0);
        lineB_i : in std_logic_vector(111 downto 0);
        lineC_i : in std_logic_vector(111 downto 0);
        lineD_i : in std_logic_vector(111 downto 0);
        lineE_i : in std_logic_vector(111 downto 0);
        lineF_i : in std_logic_vector(111 downto 0);
        dout_o  : out std_logic_vector(111 downto 0)
    );
    end component hp_col_interpolator;

    component hp_row_interpolator is
    port (
        lineA_i : in std_logic_vector(111 downto 0);
        dout_o  : out std_logic_vector(71 downto 0)
    );
    end component hp_row_interpolator;
    
    component hp_diag_interpolator is
    port (
        lineA_i : in std_logic_vector(111 downto 0);
        dout_o  : out std_logic_vector(71 downto 0)
    );
    end component hp_diag_interpolator;

    component hp_interpolator is
    port (
        clock_i : in std_logic;
        reset_i : in std_logic;
        din_i   : in std_logic_vector(111 downto 0);
        col_o   : out std_logic_vector(79 downto 0);
        row_o   : out std_logic_vector(71 downto 0);
        diag_o  : out std_logic_vector(71 downto 0)
    );
    end component hp_interpolator;

end hpel_package;
