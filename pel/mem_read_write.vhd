LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
--USE ieee.numeric_std.all;

ENTITY mem_read_write IS
	GENERIC(
		NUMWORDS_A : integer := 32;
		NUMWORDS_B : integer := 4;
		WIDTHAD_A: integer := 5;
		WIDTHAD_B: integer := 2;
		WIDTH_A : integer := 8;
		WIDTH_B : integer := 64
	);
	PORT
	(
		address_a		: IN STD_LOGIC_VECTOR (WIDTHAD_A-1 DOWNTO 0);
		address_b		: IN STD_LOGIC_VECTOR (WIDTHAD_B-1 DOWNTO 0);
		clock				: IN STD_LOGIC ;
		data_b			: IN STD_LOGIC_VECTOR (WIDTH_B-1 DOWNTO 0);
		wren_b			: IN STD_LOGIC  := '1';
		q_a				: OUT STD_LOGIC_VECTOR (WIDTH_A-1 DOWNTO 0);
		q_b				: OUT STD_LOGIC_VECTOR (WIDTH_B-1 DOWNTO 0)
	);
END mem_read_write;


ARCHITECTURE SYN OF mem_read_write IS

-- The following code must appear before the "begin" keyword in the architecture
-- body.
constant ADDR_WIDTH_A : integer := WIDTHAD_A;
constant DATA_WIDTH_A : integer := WIDTH_A; 

constant ADDR_WIDTH_B : integer := WIDTHAD_B;
constant DATA_WIDTH_B : integer := WIDTH_B; 

type MEM_TYPE is array (2**ADDR_WIDTH_B-1 downto 0) of std_logic_vector (DATA_WIDTH_B-1 downto 0);
signal memory: MEM_TYPE;
--signal parcial_mem_b: std_logic_vector(DATA_WIDTH_B-1 DOWNTO 0);
-- If using Dual Port, 2 Clocks, 2 Read/Write Ports use the following definition for <ram_name>

					
BEGIN
-- Ensure that the <ram_name> is correctly defined. Please refer to the RAM Type
-- Declaration template for more info.

	process (clock, wren_b)
	begin
		if (clock'event and clock = '1') then
				if (wren_b = '1') then
					memory(conv_integer(address_b)) <= data_b;
				end if;
				
				--parcial_mem_b <= memory(conv_integer(address_a(ADDR_WIDTH_A-1 DOWNTO ADDR_WIDTH_A-2)));
				--q_a <= parcial_mem_b( ((conv_integer(address_a(ADDR_WIDTH_A-3 DOWNTO 0))+1)*8)-1 DOWNTO conv_integer(address_a(ADDR_WIDTH_A-3 DOWNTO 0))*8 );
				--q_a <= memory();
				q_b <= memory(conv_integer(address_b));
		
			end if;
	end process;

END SYN;