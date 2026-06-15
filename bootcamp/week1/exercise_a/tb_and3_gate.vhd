library IEEE;
use IEEE.std_logic_1164.ALL;

entity tb_and3_gate is
end tb_and3_gate;

architecture sim of tb_and3_gate is
	signal a, b, c, y : std_logic;
begin
	
	uut : entity work.and3_gate
		port map (a => a, b => b, c => c, y => y);
	
	stimulus : process
	begin 
		a <= '0'; b <= '0'; c <= '0';
		wait for 10 ns;
		
		a <= '0'; b <= '1'; c <= '0';
		wait for 10 ns;
		
		a <= '1'; b <= '0'; c <= '0';
		wait for 10 ns;
		
		a <= '1'; b <= '1'; c <= '0';
		wait for 10 ns;
		
		a <= '0'; b <= '0'; c <= '1';
		wait for 10 ns;
		
		a <= '0'; b <= '1'; c <= '1';
		wait for 10 ns;
		
		a <= '1'; b <= '0'; c <= '1';
		wait for 10 ns;
		
		a <= '1'; b <= '1'; c <= '1';
		wait for 10 ns;
		
		wait;
	end process;
end sim;
		