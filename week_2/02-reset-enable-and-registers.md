# Week 2 · Module 2 — Reset, Enable & Useful Registers

The flip-flop from Module 1 captures `d` on every rising edge. That is the
minimum needed to introduce state, but it is rarely enough on its own. A
register that is actually useful in a larger design needs two additional
controls: a way to be **forced to a known value** at start-up — the
**reset** — and a way to be told **"do not capture this cycle"** — a
**load enable**. This module adds both, and shows the pattern that the
entire CPU's register set uses.

---

## 1. Why reset matters

Real flip-flops power up in an unpredictable state. Without a reset signal,
the very first values held by a counter, a state register, or a program
counter are effectively random. A circuit that begins from random state can
produce any output before it settles, which is unacceptable for anything
beyond a small lab demonstration.

A reset solves this by forcing every register to a defined value — usually
zero — under a controlled condition. Once reset is released, the circuit
proceeds normally from that known starting state. The WashU-2 specification
relies on this: when reset is asserted, the state machine moves to
`resetState`, the program counter clears to zero, the accumulator clears,
and so on.

## 2. Synchronous vs. asynchronous reset

Reset takes effect in one of two ways, depending on how the code is
structured.

An **asynchronous** reset acts the instant the reset signal is asserted,
without waiting for a clock edge:

```vhdl
process (clk, reset)
begin
    if reset = '1' then
        q <= '0';
    elsif rising_edge(clk) then
        q <= d;
    end if;
end process;
```

The reset condition appears before the edge check, so it always wins, and
`reset` is added to the sensitivity list so the process responds to it
immediately. A **synchronous** reset places the reset check inside the
clocked region, so it is sampled only at the next rising edge:

```vhdl
process (clk)
begin
    if rising_edge(clk) then
        if reset = '1' then
            q <= '0';
        else
            q <= d;
        end if;
    end if;
end process;
```

Either style is correct; the choice is a design decision. The WashU-2 CPU
uses synchronous-style logic; for the exercises this week, asynchronous
reset is slightly easier to reason about in simulation. The rule is
consistency: pick one style for a given register and stay with it.

## 3. The load enable

Many registers should only capture new data on the cycles their controlling
logic permits. The mechanism is to guard the assignment by an enable
condition:

```vhdl
process (clk, reset)
begin
    if reset = '1' then
        q <= (others => '0');
    elsif rising_edge(clk) then
        if load = '1' then
            q <= d;
        end if;
    end if;
end process;
```

The inner `if load = '1'` has no `else`. When `load` is low, no assignment
to `q` executes, and — by the rule from Module 1 — `q` simply holds. This
absence-of-assignment is the standard way to express *conditional capture*
in a clocked process. The same shape, scaled up, is how the CPU's control
unit decides which register loads on any given cycle.

## 4. A complete 8-bit register

Combining reset and enable in a wider register:

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg8 is
    port (
        clk   : in  std_logic;
        reset : in  std_logic;
        load  : in  std_logic;
        d     : in  std_logic_vector(7 downto 0);
        q     : out std_logic_vector(7 downto 0)
    );
end reg8;

architecture rtl of reg8 is
begin
    process (clk, reset)
    begin
        if reset = '1' then
            q <= (others => '0');
        elsif rising_edge(clk) then
            if load = '1' then
                q <= d;
            end if;
        end if;
    end process;
end rtl;
```

This is the core building block of every wider register in the project. The
CPU's `ACC`, `PC`, `iReg`, and `IAR` are 16-bit instances of the same
pattern, gated by signals produced by the state machine.

## 5. A counter with reset and enable

Adding the same two controls to a counter produces a circuit that starts
from a known value and only counts when permitted:

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter8 is
    port (
        clk     : in  std_logic;
        reset   : in  std_logic;
        enable  : in  std_logic;
        count   : out std_logic_vector(7 downto 0)
    );
end counter8;

architecture rtl of counter8 is
    signal count_int : std_logic_vector(7 downto 0);
begin
    process (clk, reset)
    begin
        if reset = '1' then
            count_int <= (others => '0');
        elsif rising_edge(clk) then
            if enable = '1' then
                count_int <= std_logic_vector(unsigned(count_int) + 1);
            end if;
        end if;
    end process;

    count <= count_int;
end rtl;
```

In simulation the waveform should clearly show three distinct regions: an
initial flat region where reset holds `count` at zero, a stepping region
where `enable` is high and the value increments on each rising edge, and a
flat region where `enable` is low and the value holds. Being able to
recognise these regions on sight is a skill worth building, because state
in a complex design always presents itself this way on a timeline.

## 6. A small variation

A counter that stops at its maximum value instead of wrapping is a one-line
modification:

```vhdl
elsif rising_edge(clk) then
    if enable = '1' and count_int /= x"FF" then
        count_int <= std_logic_vector(unsigned(count_int) + 1);
    end if;
end if;
```

The added condition `count_int /= x"FF"` causes the counter to hold at 255
rather than wrap to zero. This is included as a worked variation, not an
exercise; it is useful as a small demonstration of how guard conditions
combine.

## 7. Recommended outside resources

- **Nandland (YouTube)** — *"VHDL Register with Reset"* — direct match to
  the patterns above.
- **VHDLwhiz.com** — *"How to write a register in VHDL"* — clean modern
  reference covering both reset styles.

Next: **Module 3 — Exercises**.
