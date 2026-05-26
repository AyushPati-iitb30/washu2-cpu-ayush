# Week 2 · Module 4 — Testbenches for Clocked Designs

The Week 1 testbench pattern — drive an input, wait, drive the next input,
end with `wait;` — is insufficient for sequential designs, because every
clocked process needs a clock to advance. This module adds the one new
element required: a **clock generator** inside the testbench. With it in
place, the rest of the testbench follows the same structure introduced in
Week 1.

The work for this module is to write a testbench for the `mod_counter`
design from Module 3 (Exercise 2). Reading the four sections below first will save
time when writing it.

---

## 1. The clock generator

A single concurrent assignment is enough to produce an endless clock:

```vhdl
signal clk : std_logic := '0';
constant CLK_PERIOD : time := 10 ns;
...
clk <= not clk after CLK_PERIOD / 2;
```

The assignment flips `clk` after half a period, and because each flip is
itself a new event on `clk`, it triggers the same statement again,
scheduling the next flip half a period later. The result is a perfect
square wave with a 10 ns period (100 MHz), continuing for the entire
simulation. The statement is concurrent, so it lives in the architecture
body, not inside a process.

A 10 ns period is a convenient default for this project: short enough to
keep simulations fast, long enough that small amounts of stimulus jitter
remain negligible.

The `after` keyword is a simulation-only construct with no synthesizable
counterpart. This is acceptable because a testbench is never synthesized.

---

## 2. Structure of a clocked testbench

A testbench for a clocked design has five components:

1. An empty entity, as in Week 1.
2. Signals connecting to every port of the design under test, including
   `clk`.
3. The clock generator, in the concurrent area.
4. The DUT instantiation, with `clk` wired in.
5. A stimulus process that drives the non-clock inputs (`reset`, `enable`,
   data, etc.) over time.

The stimulus process and the clock generator run in parallel: the clock
keeps ticking regardless of what the stimulus is doing, and the stimulus
operates on its own timeline of `wait for` and `wait until` statements.

---

## 3. A worked example

A complete testbench for a basic D flip-flop:

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_dff is
end tb_dff;

architecture sim of tb_dff is
    signal clk, d, q   : std_logic := '0';
    constant CLK_PERIOD : time := 10 ns;
begin
    clk <= not clk after CLK_PERIOD / 2;

    uut : entity work.dff
        port map (
            clk => clk,
            d   => d,
            q   => q
        );

    stimulus : process
    begin
        d <= '0';
        wait for 25 ns;

        d <= '1';
        wait for 20 ns;

        d <= '0';
        wait for 20 ns;

        d <= '1';
        wait for 20 ns;

        wait;
    end process;

end sim;
```

The simulation shows `clk` ticking steadily, `d` changing whenever the
stimulus sets it, and `q` updating *only at rising edges*, capturing the
value `d` held at that instant. A `q` that changes between edges indicates
a problem with the design rather than the testbench — exactly the kind of
discrepancy waveform inspection catches.

---

## 4. Useful stimulus patterns

A small set of patterns covers most clocked testbenches.

**Initial reset.** Hold `reset` high for at least one full cycle at the
start so every register comes up in a defined state:

```vhdl
reset <= '1';
wait for 25 ns;
reset <= '0';
```

**Pulse a control signal for exactly one cycle.** Useful for loading a
register on a single edge:

```vhdl
load <= '1';
wait for CLK_PERIOD;
load <= '0';
```

**Synchronise stimulus to the clock.** When precise edge alignment matters,
`wait until rising_edge(clk)` gives exact control and avoids the small
timing races that `wait for` can produce:

```vhdl
wait until rising_edge(clk);
enable <= '1';
wait until rising_edge(clk);
enable <= '0';
```

This is the preferred form whenever the design's behaviour depends on the
exact edge at which an input changes.

**End the simulation.** A bare `wait;` at the end of the stimulus process
prevents it from looping and producing an endless waveform.

---

## 5. Exercise — `tb_mod_counter`

Write a testbench for the `mod_counter` design from Module 3 (Exercise 2). The
starter file `starter_library/tb_template_clocked.vhd` contains the clock
generator and stimulus skeleton; copy it to `tb_mod_counter.vhd` and adapt
it.

The testbench must satisfy three observable requirements:

1. **Reset behaviour.** Hold `reset` high at the start of the simulation;
   confirm that `count` is `0` and `tick` is `'0'` throughout the reset
   interval.
2. **Counting.** Release `reset` with `enable` high and run long enough to
   observe *at least two complete wrap cycles*. Confirm that `count`
   sequences `0, 1, …, N-1, 0, 1, …` in step with the clock.
3. **Strobe alignment.** Verify that `tick` pulses high for *exactly one*
   clock cycle per wrap, and that the cycle on which it goes high matches
   the choice you made when designing `mod_counter` (see Module 3, Exercise 2 —
   combinational vs. registered comparison). The two valid designs differ
   by one cycle in where `tick` appears; your testbench is correct if it
   matches your design's documented choice.

For a richer test, also exercise the `enable` input: lower it for a few
cycles in the middle of a counting run and confirm `count` holds steady
during that interval while `tick` remains low.

The deliverable for Week 2 includes a waveform screenshot from this
testbench showing at least two wrap cycles, with `count`, `enable`, and
`tick` all visible.

---

## 6. Recommended outside resources

- **Nandland (YouTube)** — *"VHDL Testbench Clock"* — a short
  demonstration of the same `clk <= not clk after ...` idiom.
- **VHDLwhiz.com** — *"How to create a clock in a VHDL testbench"* — clear
  written reference covering the pattern and common variants.

---

That completes Week 2. The four ideas introduced this week — clocked
processes, reset and enable, vector arithmetic, and clock-driven testbenches
— compose into every register in the project, including those in the CPU.
Week 3 adds the layer above: finite state machines, which decide when each
of those registers loads.
