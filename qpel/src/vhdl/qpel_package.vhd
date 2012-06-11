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

    type pel_ram_i is record
        wren : std_logic;
        addr : std_logic_vector(2 downto 0);
        din  : std_logic_vector(63 downto 0);
    end record;

    type row_ram_i is record
        wren : std_logic;
        addr : std_logic_vector(4 downto 0);
        din  : std_logic_vector(143 downto 0);
    end record;

    type diag_ram_i is record
        wren : std_logic;
        addr : std_logic_vector(4 downto 0);
        din  : std_logic_vector(143 downto 0);
    end record;

    type col_ram_i is record
        wren : std_logic;
        addr : std_logic_vector(4 downto 0);
        din  : std_logic_vector(135 downto 0);
    end record;

    type qp_macroblock_buffer_i is record
        pel  : pel_ram_i;
        col  : col_ram_i;
        row  : row_ram_i;
        diag : diag_ram_i;
    end record;

    type qp_macroblock_buffer_o is record
        pel  : std_logic_vector(63 downto 0);
        col  : std_logic_vector(135 downto 0);
        row  : std_logic_vector(143 downto 0);
        diag : std_logic_vector(143 downto 0);
    end record;
 
    component qp_macroblock_buffer is
    port (  
        clock : in std_logic;
        din   : in qp_macroblock_buffer_i;
        dout  : out qp_macroblock_buffer_o
    );
    end component qp_macroblock_buffer;


    ----------------
    -- qp_compare --
    ----------------
    type match_t is record
        vec_x : std_logic_vector(1 downto 0);
        vec_y : std_logic_vector(1 downto 0);
        sad   : std_logic_vector(15 downto 0);
    end record;

    type qp_compare_i is record
        clear : std_logic;
        hp    : match_t;
        row   : match_t;
        col   : match_t;
        diag  : match_t;
    end record;

    type qp_compare_o is record
        result : match_t;
    end record;

    component qp_compare is
    port (
        clock : in std_logic;
        reset : in std_logic;
        din   : in qp_compare_i;
        dout  : out qp_compare_o
    );
    end component qp_compare;

    -----------------
    -- qp_sad_tree --
    -----------------

    type mb_line_t is record
        a : std_logic_vector(7 downto 0);
        b : std_logic_vector(7 downto 0);
        c : std_logic_vector(7 downto 0);
        d : std_logic_vector(7 downto 0);
        e : std_logic_vector(7 downto 0);
        f : std_logic_vector(7 downto 0);
        g : std_logic_vector(7 downto 0);
        h : std_logic_vector(7 downto 0);
    end record;
        
    type qp_sad_tree_i is record
        clear : std_logic;
        lineA : mb_line_t;
        lineB : mb_line_t;
    end record;

    type qp_sad_tree_o is record
        res : std_logic_vector(15 downto 0);
    end record;

    component qp_sad_tree is
    port (
        clock : in std_logic;
        reset : in std_logic;
        din   : in qp_sad_tree_i;
        dout  : out qp_sad_tree_o
    );
    end component qp_sad_tree;



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

