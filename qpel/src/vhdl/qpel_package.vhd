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

    ---------------
    -- qp_filter --
    ---------------

    type qp_filter_i is record
        a : std_logic_vector(7 downto 0);
        b : std_logic_vector(7 downto 0);
    end record;

    type qp_filter_o is record
        s : std_logic_vector;
    end record;

    component qp_filter is
    port (
        din  : in qp_filter_i;
        dout : out qp_filter_o
    );
    end component qp_filter;

    ----------------
    -- qp_col_mux --
    ----------------

    type qp_col_mux_i is record
        sel : std_logic_vector(2 downto 0);
        i   : std_logic_vector(135 downto 0);
    end record;

    type qp_col_mux_o is record
        o : out std_logic_vector(63 downto 0);
    end record;

    component qp_col_mux is
    port (
        din  : in qp_col_mux_i;
        dout : out qp_col_mux_o
    );
    end component;    


    -------------------------
    -- qp_row_interpolator --
    -------------------------

    type qp_row_interpolator_i is record
        a : std_logic_vector(151 downto 0)
    end record;

    type qp_row_interpolator_o is record
        s : std_logic_vector(143 downto 0);
    end record;

    component qp_row_interpolator is
    port (
        din  : in qp_row_interpolator_i;
        dout : out qp_row_interpolator_o
    );
    end component qp_row_interpolator;

    -------------------------
    -- qp_col_interpolator --
    -------------------------

    type qp_col_interpolator_i is record
        a : std_logic_vector(135 downto 0);
        b : std_logic_vector(135 downto 0);
    end record;

    type qp_col_interpolator_o is record
        s : std_logic_vector(135 downto 0);
    end record;

    component qp_col_interpolator is
    port (
        din  : qp_col_interpolator_i;
        dout : qp_col_interpolator_o
    );
    end component qp_col_interpolator;


    --------------------------
    -- qp_diag_interpolator --
    --------------------------

    type qp_diag_interpolator_i is record
        sel : std_logic;
        a   : std_logic_vector(151 downto 0);
        b   : std_logic_vector(151 downto 0);
    end record;

    type qp_diag_interpolator_o is record
        s : std_logic_vector(143 downto 0);
    end record;

    component qp_diag_interpolator is
    port (
        din  : in qp_diag_interpolator_i;
        dout : out qp_diag_interpolator_o
    );
    end component qp_diag_interpolator;


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

