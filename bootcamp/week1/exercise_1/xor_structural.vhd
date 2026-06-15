library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity xor_structural is
	port (
		a , b : in std_logic;
		y : out std_logic
	);
end xor_structural;

architecture rtl of xor_structural is
	signal not1_out , not2_out , and1_out , and2_out : std_logic;
begin
	n1 : entity work.inverter
		port map ( a => b, y => not1_out );
		
	n2 : entity work.inverter
		port map ( a => a, y => not2_out );
		
	a1 : entity work.and_gate
		port map ( a => a, b => not1_out, y => and1_out );
		
	a2 : entity work.and_gate
		port map ( a => not2_out, b => b, y => and2_out );
		
	o1 : entity work.or_gate
		port map ( a => and1_out, b => and2_out, y => y );
end rtl;
	
	