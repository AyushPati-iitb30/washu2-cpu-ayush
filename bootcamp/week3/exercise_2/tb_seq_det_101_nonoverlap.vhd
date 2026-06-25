library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_seq_det_101_nonoverlap is
end tb_seq_det_101_nonoverlap;

architecture sim of tb_seq_det_101_nonoverlap is
    signal clk      : std_logic := '0';
    signal reset    : std_logic := '1';
    signal data     : std_logic := '0';
    signal detected : std_logic;

    constant clk_period : time := 10 ns;

begin
    clk <= not clk after clk_period / 2;

    uut: entity work.seq_det_101_nonoverlap
        port map (
            clk      => clk,
            reset    => reset,
            data     => data,
            detected => detected
        );

    stimulus: process
    begin
        -- Apply reset
        reset <= '1';
        wait for clk_period * 2;
        reset <= '0';
		  wait until rising_edge(clk);

        -- Apply test sequence: 1 0 0 1 0 1 1 0 1 0 1..... 25 clocks
        data <= '1'; wait until rising_edge(clk);
        data <= '0'; wait until rising_edge(clk);
        data <= '0'; wait until rising_edge(clk);
        data <= '1'; wait until rising_edge(clk);
        data <= '0'; wait until rising_edge(clk);
        data <= '1'; wait until rising_edge(clk);
        data <= '1'; wait until rising_edge(clk);
        data <= '0'; wait until rising_edge(clk);
        data <= '1'; wait until rising_edge(clk);
        data <= '0'; wait until rising_edge(clk);
        data <= '1'; wait until rising_edge(clk);
        data <= '0'; wait until rising_edge(clk);
        data <= '1'; wait until rising_edge(clk);
        data <= '0'; wait until rising_edge(clk);
        data <= '1'; wait until rising_edge(clk);
        data <= '0'; wait until rising_edge(clk);
        data <= '1'; wait until rising_edge(clk);
        data <= '0'; wait until rising_edge(clk);
        data <= '1'; wait until rising_edge(clk);
        data <= '0'; wait until rising_edge(clk);
        data <= '1'; wait until rising_edge(clk);
        data <= '0'; wait until rising_edge(clk);
        data <= '1'; wait until rising_edge(clk);
        data <= '0'; wait until rising_edge(clk);
        data <= '1'; wait until rising_edge(clk);
        data <= '0'; wait until rising_edge(clk);
        data <= '1'; wait until rising_edge(clk);
        data <= '0'; wait until rising_edge(clk);
        data <= '1'; wait until rising_edge(clk);
        data <= '0'; wait until rising_edge(clk);
        data <= '1'; wait until rising_edge(clk);

        -- Finish simulation
        wait for clk_period * 5;
        wait;
    end process;
end sim;
