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
        s : std_logic_vector(7 downto 0);
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
        o : std_logic_vector(63 downto 0);
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
        a : std_logic_vector(151 downto 0);
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
        din  : in qp_col_interpolator_i;
        dout : out qp_col_interpolator_o
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


    ---------------------
    -- qp_interpolator --
    ---------------------

    type qp_interpolator_i is record
        i   : std_logic_vector(151 downto 0);
        sel : std_logic;

    end record;

    type qp_interpolator_o is record
        col  : std_logic_vector(135 downto 0);
        row  : std_logic_vector(143 downto 0);
        diag : std_logic_vector(143 downto 0);
    end record;

    component qp_interpolator is
    port (
        clock : in std_logic;
        reset : in std_logic;
        din   : in qp_interpolator_i;
        dout  : out qp_interpolator_o
    );
    end component qp_interpolator;


    ----------------
    -- qp_control --
    ----------------

    type qp_pel_mem_ctrl_i is record
        wren : std_logic;
        addr : std_logic_vector(2 downto 0);
    end record;

    type qp_pel_mem_data_i is record
        din : std_logic_vector(63 downto 0);
    end record;

    type qp_col_mem_ctrl_i is record
        wren : std_logic;
        addr : std_logic_vector(4 downto 0);
    end record;

    type qp_row_mem_ctrl_i is record
        wren : std_logic;
        addr : std_logic_vector(4 downto 0);
    end record;

    type qp_diag_mem_ctrl_i is record
        wren : std_logic;
        addr : std_logic_vector(4 downto 0);
    end record;

    type qp_control_i is record
        start : std_logic;        
    end record;

    type qp_control_o is record
        pel  : qp_pel_mem_ctrl_i;
        row  : qp_row_mem_ctrl_i;
        col  : qp_col_mem_ctrl_i;
        diag : qp_diag_mem_ctrl_i;
        sel  : std_logic;
        done : std_logic;
    end record;

    component qp_control is
    port (
        clock : in std_logic;
        reset : in std_logic;
        din   : in qp_control_i;
        dout  : out qp_control_o
    );
    end component qp_control;

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


    ----------
    -- qpel --
    ----------

    type qpel_i is record
        start : std_logic;
        hp_mb_i : std_logic_vector(151 downto 0);
    end record;

    type qpel_o is record
        done : std_logic;
    end record;

    component qpel is
    port (
        clock : in std_logic;
        reset : in std_logic;
        din   : in qpel_i;
        dout  : out qpel_o
    );
    end component qpel;
end qpel_package;

