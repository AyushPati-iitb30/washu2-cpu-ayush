library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity and3_gate is
	port ( 
		a : in std_logic;
		b : in std_logic;
		c : in std_logic;
		y : out std_logic
	);
end and3_gate;

architecture rtl of and3_gate is
begin
	y <= a and b and c;
end rtl;