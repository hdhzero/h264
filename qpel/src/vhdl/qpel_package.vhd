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
        clock : in std_logic;
        reset : in std_logic;
        start : in std_logic;
        din   : in  std_logic_vector(151 downto 0);
        col   : out std_logic_vector(135 downto 0);
        row   : out std_logic_vector(143 downto 0);
        diag  : out std_logic_vector(143 downto 0)
    );
    end component interpolator;

    ---------------------------------------------
    -- Functions
    ---------------------------------------------

    function str2std(s : string(8 downto 1)) return std_logic_vector;


end qpel_package;

package body qpel_package is
    function str2std(s : string(8 downto 1)) return std_logic_vector is
        variable vetor : std_logic_vector(7 downto 0);
    begin
        
end package body;
