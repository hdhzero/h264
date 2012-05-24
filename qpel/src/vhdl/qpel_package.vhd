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

    component interpolator is
    port (
        clock_i : in std_logic;
        reset_i : in std_logic;
        start_i : in std_logic;
        din_i   : in  std_logic_vector(151 downto 0);
        done_o  : out std_logic;
        col_o   : out std_logic_vector(135 downto 0);
        row_o   : out std_logic_vector(143 downto 0);
        diag_o  : out std_logic_vector(143 downto 0);
        col_wren_o  : out std_logic;
        row_wren_o  : out std_logic;
        diag_wren_o : out std_logic;
        col_addr_o  : out std_logic_vector(5 downto 0);
        row_addr_o  : out std_logic_vector(5 downto 0);
        diag_addr_o : out std_logic_vector(5 downto 0)
    );
    end component interpolator;
end qpel_package;

