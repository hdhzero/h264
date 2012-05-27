library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.hpel_package.all;

entity hpel is
    port (
        clock_i : in std_logic;
        reset_i : in std_logic;
        start_i : in std_logic;
        ref_i   : in std_logic_vector(111 downto 0);
        pel_i   : in std_logic_vector(63 downto 0);
        done_o  : out std_logic
    );
end hpel;

architecture hpel of hpel is
    signal pel_wren_w  : std_logic;
    signal ref_wren_w  : std_logic;
    signal col_wren_w  : std_logic;
    signal row_wren_w  : std_logic;
    signal diag_wren_w : std_logic;
    signal pel_addr_w  : std_logic_vector(2 downto 0);
    signal ref_addr_w  : std_logic_vector(3 downto 0);
    signal col_addr_w  : std_logic_vector(3 downto 0);
    signal row_addr_w  : std_logic_vector(3 downto 0);
    signal diag_addr_w : std_logic_vector(3 downto 0);
    signal pel_din_w   : std_logic_vector(63 downto 0);
    signal ref_din_w   : std_logic_vector(79 downto 0);
    signal col_din_w   : std_logic_vector(79 downto 0);
    signal row_din_w   : std_logic_vector(71 downto 0);
    signal diag_din_w  : std_logic_vector(71 downto 0);
    signal pel_dout_w  : std_logic_vector(63 downto 0);
    signal ref_dout_w  : std_logic_vector(79 downto 0);
    signal col_dout_w  : std_logic_vector(79 downto 0);
    signal row_dout_w  : std_logic_vector(71 downto 0);
    signal diag_dout_w : std_logic_vector(71 downto 0);

begin

    -- mudar depois!
    pel_wren_w <= '0';
    ref_wren_w <= '0';
    col_wren_w <= '0';
    row_wren_w <= '0';
    diag_wren_w <= '0';
    pel_addr_w <= (others => '0');
    ref_addr_w <= (others => '0');
    col_addr_w <= (others => '0');
    row_addr_w <= (others => '0');
    diag_addr_w <= (others => '0');
    -- end 

    ref_din_w <= ref_i(95 downto 16);

    hp_macroblock_buffer_u : hp_macroblock_buffer
    port map (
        clock_i     => clock_i,
        pel_wren_i  => pel_wren_w,
        ref_wren_i  => ref_wren_w,
        col_wren_i  => col_wren_w,
        row_wren_i  => row_wren_w,
        diag_wren_i => diag_wren_w,
        pel_addr_i  => pel_addr_w,
        ref_addr_i  => ref_addr_w,
        col_addr_i  => col_addr_w,
        row_addr_i  => row_addr_w,
        diag_addr_i => diag_addr_w,
        pel_din_i   => pel_din_w,
        ref_din_i   => ref_din_w,
        col_din_i   => col_din_w,
        row_din_i   => row_din_w,
        diag_din_i  => diag_din_w,
        pel_dout_o  => pel_dout_w,
        ref_dout_o  => ref_dout_w,
        col_dout_o  => col_dout_w,
        row_dout_o  => row_dout_w,
        diag_dout_o => diag_dout_w
    );

    hp_interpolator_u : hp_interpolator
    port map (
        clock_i => clock_i,
        reset_i => reset_i,
        din_i   => ref_i,
        col_o   => col_din_w,
        row_o   => row_din_w,
        diag_o  => diag_din_w
    );
        
end hpel;


