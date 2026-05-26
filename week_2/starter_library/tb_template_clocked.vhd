-- tb_template_clocked.vhd
--
-- Week 2 STARTER TEMPLATE for testbenches of clocked designs.
--
-- Use this as a starting point when you write your own testbenches this
-- week. Copy it, rename it (e.g. tb_dff.vhd), fill in the marked TODO
-- sections, and adapt the signal list and stimulus to your specific design.
--
-- The clock generator section is the one new thing for Week 2. Once you
-- have it in place, the rest of the testbench follows the same shape as
-- the Week 1 testbenches.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- If your DUT does arithmetic on std_logic_vector signals, also uncomment:
-- use IEEE.NUMERIC_STD.ALL;

entity tb_template_clocked is
    -- A testbench has NO ports.
end tb_template_clocked;

architecture sim of tb_template_clocked is

    -- ============================================================
    -- 1. SIGNAL DECLARATIONS
    -- ------------------------------------------------------------
    -- Declare one signal for every port on your DUT. The clock
    -- signal starts at '0' so the very first 'not clk' produces a
    -- clean rising edge.
    -- ============================================================
    signal clk   : std_logic := '0';

    -- TODO: replace these with the actual ports of your DUT.
    -- Examples:
    -- signal reset, load, enable : std_logic := '0';
    -- signal d, q : std_logic_vector(7 downto 0);

    -- Clock period: 10 ns = 100 MHz. Plenty fast for simulation.
    constant CLK_PERIOD : time := 10 ns;

begin

    -- ============================================================
    -- 2. CLOCK GENERATOR
    -- ------------------------------------------------------------
    -- This single concurrent line produces an endless clock by
    -- flipping clk every half period. It lives in the concurrent
    -- area (outside any process).
    -- ============================================================
    clk <= not clk after CLK_PERIOD / 2;

    -- ============================================================
    -- 3. DUT INSTANTIATION
    -- ------------------------------------------------------------
    -- Replace 'your_design_name' and the port_map entries with the
    -- entity and ports of the design you are testing.
    -- ============================================================
    -- uut : entity work.your_design_name
    --     port map (
    --         clk => clk,
    --         -- ... other ports here ...
    --     );

    -- ============================================================
    -- 4. STIMULUS PROCESS
    -- ------------------------------------------------------------
    -- This process drives all the NON-clock inputs over time.
    -- The clock keeps ticking on its own in parallel.
    -- ============================================================
    stimulus : process
    begin
        -- (a) Initial reset phase: hold reset for a couple of cycles
        --     so the DUT comes up in a defined state.
        -- TODO: assert reset and any other initial input values here.
        -- reset <= '1';
        wait for 25 ns;

        -- (b) Release reset and let the DUT start running.
        -- reset <= '0';
        wait for 10 ns;

        -- (c) Drive the rest of your stimulus here. A few examples
        --     of useful patterns:
        --
        -- Hold values steady across several clock edges:
        --     d <= x"3A";
        --     wait for 30 ns;
        --
        -- Pulse a control signal high for one cycle:
        --     load <= '1';
        --     wait for CLK_PERIOD;
        --     load <= '0';
        --
        -- Wait exactly until the next rising edge (precise control):
        --     wait until rising_edge(clk);

        -- TODO: your stimulus here.

        -- Let things settle so you can see the final waveform.
        wait for 50 ns;

        -- (d) End the simulation cleanly.
        wait;
    end process;

end sim;
