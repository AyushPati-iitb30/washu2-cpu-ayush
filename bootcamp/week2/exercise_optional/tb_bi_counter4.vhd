library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_bi_counter4 is
end tb_bi_counter4;

architecture sim of tb_bi_counter4 is
    signal clk : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
    signal dir : STD_LOGIC := '0';
    signal en : STD_LOGIC := '0';
    signal count : STD_LOGIC_VECTOR (3 downto 0);
    constant clock_period : time := 10 ns;

begin
    clk <= not clk after clock_period / 2;

    uut : entity work.bi_counter4
        port map (
            clk => clk,
            reset => reset,
            dir => dir,
            en => en,
            count => count
        );
    
    stimulus : process
    begin
        reset <= '1';
        en <= '0';
        dir <= '0';
        wait for 25ns;

        reset <= '0';
        en <= '1';
        dir <= '1';
        wait for 100ns;

        dir <= '0';
        wait for 50ns;

        en <= '0';
        wait for 50ns;

        dir <= '1';
        en <= '1';
        wait for 20ns;

        dir <= '0';
        wait for 150ns;

        wait;
    end process;

end sim;


