library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_mod_counter is
end tb_mod_counter;

architecture sim of tb_mod_counter is
    signal clk : std_logic := '0';
	 signal reset, enable, tick : std_logic;
	 signal count : std_logic_vector(3 downto 0);
    constant clk_period : time := 10 ns;

begin
    clk <= not clk after clk_period / 2;

    uut : entity work.mod_counter
        port map (
            clk => clk,
            reset => reset,
            enable => enable,
            count => count,
            tick => tick
        );
    
    stimulus : process
    begin
        reset <= '1';
        enable <= '0';
        wait for 25 ns;

        reset <= '0';
        enable <= '1';
        wait for 250 ns;
		  
		wait;
    end process;
end sim;