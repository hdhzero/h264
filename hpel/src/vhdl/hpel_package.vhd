library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package hpel_package is

    -- tipos relacionados com memoria
    type hp_pel_mem_i is record
        wren : std_logic;
        addr : std_logic_vector(2 downto 0);
        din  : std_logic_vector(63 downto 0);
    end record;

    type hp_pel_mem_o is record
        dout : std_logic_vector(63 downto 0);
    end record;

    type hp_ref_mem_i is record
        wren : std_logic;
        addr : std_logic_vector(3 downto 0);
        din  : std_logic_vector(79 downto 0);
    end record;

    type hp_ref_mem_o is record
        dout : std_logic_vector(79 downto 0);
    end record;

    type hp_col_mem_i is record
        wren : std_logic;
        addr : std_logic_vector(3 downto 0);
        din  : std_logic_vector(79 downto 0);
    end record;

    type hp_col_mem_o is record
        dout : std_logic_vector(79 downto 0);
    end record;

    type hp_row_mem_i is record
        wren : std_logic;
        addr : std_logic_vector(3 downto 0);
        din  : std_logic_vector(71 downto 0);
    end record;

    type hp_row_mem_o is record
        dout : std_logic_vector(71 downto 0);
    end record;

    type hp_diag_mem_i is record
        wren : std_logic;
        addr : std_logic_vector(3 downto 0);
        din  : std_logic_vector(71 downto 0);
    end record;

    type hp_diag_mem_o is record
        dout : std_logic_vector(71 downto 0);
    end record;


    component hp_memory is
    port (
        clock : in std_logic;
        wren  : in std_logic;
        addr  : in std_logic_vector;
        din   : in std_logic_vector;
        dout  : out std_logic_vector
    );
    end component hp_memory;




    ---------------
    -- hp_filter --
    ---------------

    type hp_filter_i is record
        a : std_logic_vector(7 downto 0);
        b : std_logic_vector(7 downto 0);
        c : std_logic_vector(7 downto 0);
        d : std_logic_vector(7 downto 0);
        e : std_logic_vector(7 downto 0);
        f : std_logic_vector(7 downto 0);
    end record;

    type hp_filter_o is record
        s : std_logic_vector(7 downto 0);
    end record;

    component hp_filter is
    port (
        din  : in hp_filter_i;
        dout : out hp_filter_o
    );
    end component hp_filter;



    -------------------------
    -- hp_col_interpolator --
    -------------------------

    type hp_col_interpolator_i is record
        lineA : std_logic_vector(111 downto 0);
        lineB : std_logic_vector(111 downto 0);
        lineC : std_logic_vector(111 downto 0);
        lineD : std_logic_vector(111 downto 0);
        lineE : std_logic_vector(111 downto 0);
        lineF : std_logic_vector(111 downto 0);
    end record;

    type hp_col_interpolator_o is record
        res : std_logic_vector(111 downto 0);
    end record;

    component hp_col_interpolator is
    port (
        din  : in hp_col_interpolator_i;
        dout : out hp_col_interpolator_o
    );
    end component hp_col_interpolator;




    ----------------------
    -- hp_row_interpolator
    ----------------------

    type hp_row_interpolator_i is record
        lineA : std_logic_vector(111 downto 0);
    end record;

    type hp_row_interpolator_o is record
        res : std_logic_vector(71 downto 0);
    end record;

    component hp_row_interpolator is
    port (
        din  : in hp_row_interpolator_i;
        dout : out hp_row_interpolator_o
    );
    end component hp_row_interpolator;


    type hp_diag_interpolator_i is record
        lineA : std_logic_vector(111 downto 0);
    end record;

    type hp_diag_interpolator_o is record
        res : std_logic_vector(71 downto 0);
    end record;
   
    component hp_diag_interpolator is
    port (
        din  : in hp_diag_interpolator_i;
        dout : out hp_diag_interpolator_o
    );
    end component hp_diag_interpolator;




    ---------------------
    -- hp_interpolator --
    ---------------------

    type hp_interpolator_i is record
        input : std_logic_vector(111 downto 0);
    end record;

    type hp_interpolator_o is record
        col   : std_logic_vector(79 downto 0);
        row   : std_logic_vector(71 downto 0);
        diag  : std_logic_vector(71 downto 0);
    end record;

    component hp_interpolator is
    port (
        clock : in std_logic;
        reset : in std_logic;
        din   : in hp_interpolator_i;
        dout  : out hp_interpolator_o
    );
    end component hp_interpolator;

    -----------------------
    -- hp_macroblock_buffer
    -----------------------

    type hp_macroblock_buffer_i is record
        pel  : hp_pel_mem_i;
        ref  : hp_ref_mem_i;
        row  : hp_row_mem_i;
        col  : hp_col_mem_i;
        diag : hp_diag_mem_i;
    end record;

    type hp_macroblock_buffer_o is record
        pel  : hp_pel_mem_o;
        ref  : hp_ref_mem_o;
        row  : hp_row_mem_o;
        col  : hp_col_mem_o;
        diag : hp_diag_mem_o;
    end record;

    component hp_macroblock_buffer is
    port (  
        clock : in std_logic;
        din   : in hp_macroblock_buffer_i;
        dout  : out hp_macroblock_buffer_o
    );
    end component hp_macroblock_buffer;




    ----------
    -- hpel --
    ----------

    type hpel_i is record
        start : std_logic;
    end record;

    type hpel_o is record
        done : std_logic;
    end record;

    component hpel is
    port (
        clock : in std_logic;
        reset : in std_logic;
        din   : in hpel_i;
        dout  : out hpel_o
    );
    end component hpel;

end hpel_package;
