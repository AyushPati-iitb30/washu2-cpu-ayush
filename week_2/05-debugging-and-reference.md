# Week 2 · Module 5 — Debugging & Sequential Design Reference

The largest difficulty in Week 2 is usually not writing the VHDL itself, but
understanding *when* signals update and how to debug waveforms correctly.
This reference collects the minimum additional patterns needed to work
comfortably with clocked designs.

---

# 1. The Standard Clocked Process

Most sequential circuits in this course follow the same structure:

```vhdl
process(clk)
begin
    if rising_edge(clk) then
        -- sequential logic
    end if;
end process;
```

Important points:

- The process wakes up whenever `clk` changes.
- Logic inside executes only on the rising edge.
- Signal values appear to change once per clock cycle.

This is fundamentally different from combinational logic, where outputs change
immediately when inputs change.

---

# 2. Reset and Enable Pattern

A practical register usually includes:
- reset
- enable
- stored state

The common structure is:

```vhdl
process(clk)
begin
    if rising_edge(clk) then
        if reset = '1' then
            count <= "0000";
        elsif en = '1' then
            count <= count + 1;
        end if;
    end if;
end process;
```

Interpretation:
- `reset` forces a known value.
- `en` decides whether state updates this cycle.
- Without enable, the previous value is preserved.

---

# 3. Reading Counter Waveforms

For a 3-bit counter:

```text
000
001
010
011
100
101
110
111
000
```

The value changes only at clock edges.

When debugging:
1. Check whether the clock is toggling.
2. Check whether reset is still active.
3. Check whether enable is asserted.
4. Then inspect the counter output.

Most bugs become obvious from the waveform.

---

# 4. Example — 4-bit Up Counter

```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter4 is
    port(
        clk   : in std_logic;
        reset : in std_logic;
        en    : in std_logic;
        q     : out std_logic_vector(3 downto 0)
    );
end counter4;

architecture behavior of counter4 is
    signal count : unsigned(3 downto 0) := "0000";
begin

process(clk)
begin
    if rising_edge(clk) then
        if reset = '1' then
            count <= "0000";
        elsif en = '1' then
            count <= count + 1;
        end if;
    end if;
end process;

q <= std_logic_vector(count);

end behavior;
```

---

# 5. Clock Generation in Testbenches

Sequential circuits require a clock generator.

```vhdl
clk_process : process
begin
    while true loop
        clk <= '0';
        wait for 5 ns;

        clk <= '1';
        wait for 5 ns;
    end loop;
end process;
```

This produces a 10 ns clock period.

Without a clock, sequential logic never advances.

---

# 6. Applying Stimulus

Inputs should change over time.

```vhdl
stimulus : process
begin
    reset <= '1';
    en <= '0';
    wait for 20 ns;

    reset <= '0';
    en <= '1';
    wait for 100 ns;

    en <= '0';

    wait;
end process;
```

Typical flow:
- assert reset
- release reset
- enable counting
- observe waveform

---

# 7. Common Mistakes

## Using `=` instead of `<=`

Wrong:

```vhdl
count = count + 1;
```

Correct:

```vhdl
count <= count + 1;
```

---

## Forgetting `rising_edge(clk)`

Without it, logic behaves incorrectly and may simulate unpredictably.

---

## Keeping reset permanently high

If reset never becomes `'0'`, registers never update.

---

## Running simulation for too little time

A short simulation may not contain enough clock cycles to observe behavior.

---

## Forgetting arithmetic libraries

For arithmetic on vectors:

```vhdl
use ieee.numeric_std.all;
```

---

# 8. Suggested Debugging Workflow

1. Compile the design.
2. Fix syntax errors first.
3. Simulate with a clock.
4. Inspect waveforms.
5. Verify reset behavior.
6. Verify state updates at rising edges.
7. Then debug functional behavior.

Trying to debug only from source code is usually slower than inspecting the
waveform directly.

---

# 9. Key Idea of Sequential Logic

Combinational logic depends only on current inputs.

Sequential logic depends on:
- current inputs
- previous state
- clock timing

That additional stored state is what allows counters, registers, memories,
and CPUs to exist.
