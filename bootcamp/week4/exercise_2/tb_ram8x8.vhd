library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_ram8x8 is
end tb_ram8x8;

architecture sim of tb_ram8x8 is

    signal clk      : std_logic := '0';
    signal rst      : std_logic := '1';
    signal we       : std_logic := '0';
    signal addr     : std_logic_vector(2 downto 0) := (others => '0');
    signal data_in  : std_logic_vector(7 downto 0) := (others => '0');
    signal data_out : std_logic_vector(7 downto 0);
    signal valid    : std_logic;

    constant CLK_PERIOD : time := 10 ns;

begin

    clk <= not clk after CLK_PERIOD / 2;

    uut : entity work.ram8x8
        port map (
            clk      => clk,
            rst      => rst,
            we       => we,
            addr     => addr,
            data_in  => data_in,
            data_out => data_out,
            valid    => valid
        );

    stimulus : process
    begin

        -- --------------------------------------------------------
        -- Phase 1: Synchronous reset
        -- --------------------------------------------------------
        rst <= '1';
        wait for 2 * CLK_PERIOD;
        wait until rising_edge(clk);
        assert data_out = x"00" and valid = '0'
            report "FAIL: data_out or valid non-zero after reset" severity error;
        rst <= '0';
        wait for CLK_PERIOD;

        -- --------------------------------------------------------
        -- Phase 2: Write distinct values to four addresses
        -- --------------------------------------------------------
        -- Each assignment takes effect one cycle later (registered input path)

        -- Write 0xAA → address 0
        wait until rising_edge(clk);
        we <= '1'; addr <= "000"; data_in <= x"AA";

        -- Write 0xBB → address 1
        wait until rising_edge(clk);
        addr <= "001"; data_in <= x"BB";

        -- Write 0xCC → address 2
        wait until rising_edge(clk);
        addr <= "010"; data_in <= x"CC";

        -- Write 0xDD → address 3
        wait until rising_edge(clk);
        addr <= "011"; data_in <= x"DD";

        -- Confirm valid stays '0' throughout write phase
        wait until rising_edge(clk);
        assert valid = '0'
            report "FAIL: valid should be '0' during write phase" severity error;

        -- --------------------------------------------------------
        -- Phase 3: Read back all four addresses; verify valid timing
        -- --------------------------------------------------------

        -- Read address 0 → expect 0xAA
        we <= '0'; addr <= "000";
        wait until rising_edge(clk);      -- data_out and valid now settled
        assert data_out = x"AA" and valid = '1'
            report "FAIL: read addr 0 (expected 0xAA, valid='1')" severity error;

        -- Read address 1 → expect 0xBB
        addr <= "001";
        wait until rising_edge(clk);
        assert data_out = x"BB" and valid = '1'
            report "FAIL: read addr 1 (expected 0xBB, valid='1')" severity error;

        -- Read address 2 → expect 0xCC
        addr <= "010";
        wait until rising_edge(clk);
        assert data_out = x"CC" and valid = '1'
            report "FAIL: read addr 2 (expected 0xCC, valid='1')" severity error;

        -- Read address 3 → expect 0xDD
        addr <= "011";
        wait until rising_edge(clk);
        assert data_out = x"DD" and valid = '1'
            report "FAIL: read addr 3 (expected 0xDD, valid='1')" severity error;

        -- --------------------------------------------------------
        -- Phase 4: Read-after-write — overwrite addr 0, verify update
        -- --------------------------------------------------------

        -- Overwrite address 0 with 0xFF
        wait until rising_edge(clk);
        we <= '1'; addr <= "000"; data_in <= x"FF";

        -- Confirm valid clears on the write cycle
        wait until rising_edge(clk);
        assert valid = '0'
            report "FAIL: valid should be '0' immediately after write" severity error;

        -- Read address 0 back — must see updated value 0xFF, not old 0xAA
        we <= '0'; addr <= "000";
        wait until rising_edge(clk);
        assert data_out = x"FF" and valid = '1'
            report "FAIL: read after overwrite addr 0 (expected 0xFF)" severity error;

        -- --------------------------------------------------------
        -- Phase 5: valid clears when a write interrupts a read sequence
        -- --------------------------------------------------------

        -- Issue a read of addr 1 (arms the valid output)
        addr <= "001";
        wait until rising_edge(clk);
        assert data_out = x"BB" and valid = '1'
            report "FAIL: re-read addr 1 before write interrupt" severity error;

        -- Immediately write — valid must drop to '0'
        wait until rising_edge(clk);
        we <= '1'; addr <= "001"; data_in <= x"22";
        wait until rising_edge(clk);
        assert valid = '0'
            report "FAIL: valid not cleared when write follows read" severity error;

        -- --------------------------------------------------------
        -- Phase 6: Consecutive reads — verify valid stays '1'
        -- --------------------------------------------------------

        -- Read addresses 2 and 3 back-to-back
        we <= '0'; addr <= "010";
        wait until rising_edge(clk);      -- addr 2 result: 0xCC
        assert data_out = x"CC" and valid = '1'
            report "FAIL: consecutive read addr 2" severity error;

        addr <= "011";
        wait until rising_edge(clk);      -- addr 3 result: 0xDD
        assert data_out = x"DD" and valid = '1'
            report "FAIL: consecutive read addr 3" severity error;

        -- --------------------------------------------------------
        wait for 5 * CLK_PERIOD;
        report "tb_ram8x8: all assertions passed." severity note;
        wait;

    end process stimulus;

end sim;
