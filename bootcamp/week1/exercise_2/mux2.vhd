library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2 is
	port (a, b, sel : in std_logic;
			y : out std_logic
		);
end mux2;

architecture rtl of mux2 is 
	signal n1_out, a1_out, a2_out : std_logic;
begin
	n1 : entity work.inverter
		port map (a => sel, y => n1_out);
	a1 : entity work.and_gate
		port map (a => a, b => n1_out, y => a1_out);
	a2 : entity work.and_gate
		port map (a => sel, b => b, y => a2_out);
	o1 : entity work.or_gate
		port map (a => a1_out, b => a2_out, y => y);
end rtl;
	