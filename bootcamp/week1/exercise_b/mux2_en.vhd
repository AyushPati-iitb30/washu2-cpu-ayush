library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2_en is
	port ( 
		a : in std_logic;
		b : in std_logic;
		sel : in std_logic;
		en : in std_logic;
		y : out std_logic
	);
end mux2_en;

architecture rtl of mux2_en is 
begin
	y <= ((a and sel) or (b and not sel)) and en;
end rtl;
	 