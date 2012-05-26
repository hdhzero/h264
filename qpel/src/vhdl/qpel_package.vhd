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
        din_i   : in std_logic_vector(151 downto 0);
        sel_i   : in std_logic;
        col_o   : out std_logic_vector(135 downto 0);
        row_o   : out std_logic_vector(143 downto 0);
        diag_o  : out std_logic_vector(143 downto 0)
    );
    end component interpolator;


    component control is
    port (
        clock_i : in std_logic;
        reset_i : in std_logic;
        start_i : in std_logic;

        pel_wren_o  : out std_logic;
        col_wren_o  : out std_logic;
        row_wren_o  : out std_logic;
        diag_wren_o : out std_logic;

        pel_addr_o  : out std_logic_vector(2 downto 0);
        col_addr_o  : out std_logic_vector(4 downto 0);
        row_addr_o  : out std_logic_vector(4 downto 0);
        diag_addr_o : out std_logic_vector(4 downto 0);

        diag_int_sel_o : out std_logic;
        done_o : out std_logic
    );
    end component control;

    component macroblock_buffer is
    port (  
        clock_i     : in std_logic;
        pel_wren_i  : in std_logic;
        col_wren_i  : in std_logic;
        row_wren_i  : in std_logic;
        diag_wren_i : in std_logic;
        pel_addr_i  : in std_logic_vector(2 downto 0);
        col_addr_i  : in std_logic_vector(4 downto 0);
        row_addr_i  : in std_logic_vector(4 downto 0);
        diag_addr_i : in std_logic_vector(4 downto 0);
        pel_din_i   : in std_logic_vector(63 downto 0);
        col_din_i   : in std_logic_vector(135 downto 0);
        row_din_i   : in std_logic_vector(143 downto 0);
        diag_din_i  : in std_logic_vector(143 downto 0);
        pel_dout_o  : out std_logic_vector(63 downto 0);
        col_dout_o  : out std_logic_vector(135 downto 0);
        row_dout_o  : out std_logic_vector(143 downto 0);
        diag_dout_o : out std_logic_vector(143 downto 0)
    );
    end component macroblock_buffer;


    component qpel is
    port (
        clock_i : in std_logic;
        reset_i : in std_logic;
        start_i : in std_logic;

        hp_mb_i : in std_logic_vector(151 downto 0);
        done_o  : out std_logic        
    );
    end component qpel;


end qpel_package;

