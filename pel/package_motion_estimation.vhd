------------------------------------------------------------------------------
-- PROJETO: Estimação de Movimento
-- PACOTE : motion_estimation_8x8_package
------------------------------------------------------------------------------
-- DESCRIÇÃO: Definição de constantes e tipos de dados as serem usados na 
-- arquitetura
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.all;

------------------------
------------------------
PACKAGE motion_estimation_8x8_package IS
------------------------
------------------------

CONSTANT BLOCK_DIMENSION: INTEGER := 8;
CONSTANT PIXEL_SIZE: INTEGER := 8;

CONSTANT NUM_COLS : INTEGER := BLOCK_DIMENSION;  	-- Numero de colunas dos banco de registradores
CONSTANT NUM_ROWS  : INTEGER := BLOCK_DIMENSION; 	-- Numero de linhas dos bancos de registradores
CONSTANT DATA_WIDTH  : INTEGER := PIXEL_SIZE; 		-- Numero de bits de cada registrador do banco 
CONSTANT ENTRIES: INTEGER:= NUM_COLS * NUM_ROWS;	-- Quantidade de entradas de "DATA_WIDTH" bits do módulo de SAD

-- 
TYPE REG_COLS IS ARRAY (NUM_COLS-1 DOWNTO 0) OF STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
TYPE REG_ROWS IS ARRAY (NUM_ROWS-1 DOWNTO 0) OF REG_COLS;

TYPE WE_REG_COLS IS ARRAY (NUM_COLS-1 DOWNTO 0) OF STD_LOGIC;
TYPE WE_REG_ROWS IS ARRAY (NUM_ROWS-1 DOWNTO 0) OF WE_REG_COLS;

CONSTANT SEL_REGS_DOWN: std_logic_vector(1 DOWNTO 0) := "00";		-- Identificacao das entradas de selecao do banco de registradores de referencia
CONSTANT SEL_REGS_UP: std_logic_vector(1 DOWNTO 0) := "01";	-- Identificacao das entradas de selecao do banco de registradores de referencia
CONSTANT SEL_REGS_RIGHT: std_logic_vector(1 DOWNTO 0) := "10";  -- Identificacao das entradas de selecao do banco de registradores de referencia
CONSTANT SEL_REGS_LEFT: std_logic_vector(1 DOWNTO 0) := "11";	-- Identificacao das entradas de selecao do banco de registradores de referencia

CONSTANT SEL_MUX_MP_PORT_B: std_logic_vector(1 DOWNTO 0) := "00";		-- Identificacao das entradas de selecao do banco de registradores de referencia
CONSTANT SEL_MUX_MP_LEFT: std_logic_vector(1 DOWNTO 0) := "01";	-- Identificacao das entradas de selecao do banco de registradores de referencia
CONSTANT SEL_MUX_MP_RIGHT: std_logic_vector(1 DOWNTO 0) := "10";	-- Identificacao das entradas de selecao do banco de registradores de referencia
CONSTANT SEL_MUX_MP_BUFFER: std_logic_vector(1 DOWNTO 0) := "11";  -- Identificacao das entradas de selecao do banco de registradores de referencia

TYPE SAD_ENTRIES IS ARRAY (ENTRIES-1 DOWNTO 0) OF std_logic_vector(DATA_WIDTH-1 DOWNTO 0);

CONSTANT LEVELS: integer := 7;                                                                                                                                                                                                                                                                                                                                                                                                                                                                         

CONSTANT NUM_MEMORIES: integer := 32;		-- Quantidade de módulos de memória a serem utilizadas
CONSTANT MEM_ADDR_MEMORY: natural := 5;		-- Quantidade de bits necessarios para enderecar as memórias

CONSTANT MEM_PORT_A_WIDTH : natural := 8;	-- Quantidade de bits da porta de escrita da memória
CONSTANT MEM_PORT_B_WIDTH : natural := 64;	-- Quantidade de bits da porta de escrita da memória
CONSTANT MEM_PORT_A_WIDTHAD : natural := 5;	-- Quantidade de bits da porta de escrita da memória
CONSTANT MEM_PORT_B_WIDTHAD : natural := 2;	-- Quantidade de bits da porta de escrita da memória

TYPE MEM_PORT_A_DATAS IS ARRAY (NUM_MEMORIES-1 DOWNTO 0) OF STD_LOGIC_VECTOR(MEM_PORT_A_WIDTH-1 DOWNTO 0);
TYPE MEM_PORT_B_DATAS IS ARRAY (NUM_MEMORIES-1 DOWNTO 0) OF STD_LOGIC_VECTOR(MEM_PORT_B_WIDTH-1 DOWNTO 0);
TYPE MEM_PORT_A_ADDRS IS ARRAY (NUM_MEMORIES-1 DOWNTO 0) OF STD_LOGIC_VECTOR(MEM_PORT_A_WIDTHAD-1 DOWNTO 0); 
TYPE MEM_PORT_B_ADDRS IS ARRAY (NUM_MEMORIES-1 DOWNTO 0) OF STD_LOGIC_VECTOR(MEM_PORT_B_WIDTHAD-1 DOWNTO 0); 

CONSTANT NUM_STAGES: natural := 4;
TYPE SR_LENGTH is array ((NUM_STAGES-1) downto 0) of std_logic_vector(1 DOWNTO 0);

CONSTANT ENTRIES_PER_MUX : natural := 8;	-- quantidade de entradas por mux
CONSTANT NUM_MUXES_MP: natural := 8;			-- quantidade de muxes por MP

TYPE IN_MUX IS ARRAY (ENTRIES_PER_MUX-1 DOWNTO 0) OF std_logic_vector(DATA_WIDTH-1 DOWNTO 0);
TYPE IN_MUXES IS ARRAY (NUM_MUXES_MP-1 DOWNTO 0) OF IN_MUX;

CONSTANT LENGTH_MOTION_VECTOR: integer := 5;
CONSTANT WIDTH_SELMUX_MEMORIES: natural := 5;
TYPE MUX_MATRIX IS ARRAY (NUM_MEMORIES - 1 downto 0) of std_logic_vector(DATA_WIDTH - 1 downto 0);
TYPE VECTOR_MUX IS ARRAY (NUM_ROWS-1 DOWNTO 0) OF std_logic_vector(WIDTH_SELMUX_MEMORIES-1 DOWNTO 0);
CONSTANT SEARCH_AREA_W: integer := 32;
CONSTANT SEARCH_AREA_H: integer := 32;
CONSTANT NUM_MATCHES: integer := (SEARCH_AREA_W - BLOCK_DIMENSION + 1) * BLOCK_DIMENSION;

CONSTANT FRAME_W: integer := 720;
CONSTANT FRAME_H: integer := 576;

CONSTANT BLOCKS_PER_LINE: integer := (FRAME_W / BLOCK_DIMENSION);

END motion_estimation_8x8_package;
