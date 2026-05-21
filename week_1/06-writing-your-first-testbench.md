# Week 1 · Module 6 — Writing Your First Testbench

In Module 5 you learned to *read* a testbench. Now you write one yourself,
slowly, building it up piece by piece. We go one small step at a time, so by
the end you have a complete working testbench and the skeleton to write more.

---

## The plan

You will write a testbench for the **`or_gate`** (a 2-input OR gate, part of
your starter library). We build it in five small steps, compiling along the
way.

Remember the three ingredients from Module 5: an empty entity, signals + DUT,
and a stimulus process.

---

## Step 1 — The empty shell

Start with just the skeleton. It does nothing yet, but it should compile.

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_or_gate is
end tb_or_gate;

architecture sim of tb_or_gate is
begin
end sim;
```

Compile it. Getting an empty testbench to compile confirms your project setup
is sane before you add complexity. (It won't simulate to anything useful yet —
that's expected.)

---

## Step 2 — Declare the connecting signals

The testbench needs internal wires to connect to the OR gate's ports
(`a`, `b`, `y`). Declare them **between `architecture ... is` and `begin`**:

```vhdl
architecture sim of tb_or_gate is

    signal a, b, y : std_logic;

begin
end sim;
```

Why here? Anything declared between `is` and `begin` is a local declaration —
internal wires, in this case. This is the same place you declared internal
signals in Module 4's instantiation example.

---

## Step 3 — Instantiate the DUT

Now place a copy of the design and wire it to your signals:

```vhdl
begin

    uut : entity work.or_gate
        port map (
            a => a,
            b => b,
            y => y
        );

end sim;
```

- `uut` — label for "Unit Under Test."
- `entity work.or_gate` — the `or_gate` compiled in this project.
- `port map (...)` — connect the gate's pins (left) to your testbench signals
  (right).

Compile again. If `or_gate` is in the project, this should be clean.

---

## Step 4 — Add the stimulus process

This is the part that actually *does* something — it drives the inputs through
every combination over time:

```vhdl
    stimulus : process
    begin
        a <= '0'; b <= '0';
        wait for 10 ns;

        a <= '0'; b <= '1';
        wait for 10 ns;

        a <= '1'; b <= '0';
        wait for 10 ns;

        a <= '1'; b <= '1';
        wait for 10 ns;

        wait;          -- stop forever; don't loop
    end process;
```

For an OR gate you expect `y = 1` in every case **except** `0,0`. You will
verify that in the waveform.

---

## Step 5 — The complete file

Putting it all together:

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_or_gate is
end tb_or_gate;

architecture sim of tb_or_gate is

    signal a, b, y : std_logic;

begin

    uut : entity work.or_gate
        port map (
            a => a,
            b => b,
            y => y
        );

    stimulus : process
    begin
        a <= '0'; b <= '0';
        wait for 10 ns;

        a <= '0'; b <= '1';
        wait for 10 ns;

        a <= '1'; b <= '0';
        wait for 10 ns;

        a <= '1'; b <= '1';
        wait for 10 ns;

        wait;
    end process;

end sim;
```

Compile, run RTL simulation, open the waveform, and check: is `y` low only at
the very first step (`0,0`) and high for the other three? If yes — you just
wrote and verified your first testbench. That is a real milestone.

## Your exercise

For Module 6, you both **design** a small new circuit *and* **write its
testbench** from scratch — putting together the structural-composition skill
from Module 4 with the testbench-writing skill you just learned.

Do **both** of the following:

### Exercise A — 3-input AND gate (`and3`)

Design a simple new entity:

```
entity name: and3
inputs:  a, b, c
output:  y          -- y = '1' only when all three of a, b, c are '1'
```

You can either:

- write it directly with one line `y <= a and b and c;`, or
- build it structurally by chaining two `and_gate` instances from the starter
  library (your choice — both are valid).

Then write `tb_and3.vhd` yourself: 3 inputs means **8 combinations**
(`000, 001, 010, ... 111`). Drive all of them, simulate, and verify in the
waveform that `y` is `'1'` only for the very last case (`a=b=c='1'`).

### Exercise B — 2:1 multiplexer with enable (`mux2_en`)

Design a slightly richer block:

```
entity name: mux2_en
inputs:  a, b, sel, en
output:  y
```

Behaviour:

- when `en = '0'`, the output `y` is forced to `'0'` (the mux is disabled),
- when `en = '1'`, `y` follows `a` if `sel = '0'`, and `y` follows `b` if
  `sel = '1'`.

A clean one-line architecture:

```vhdl
y <= '0'              when en  = '0' else
     a                when sel = '0' else
     b;
```

Then write `tb_mux2_en.vhd` yourself. Pick stimulus that proves all three
behaviours — disabled output, selecting `a`, and selecting `b`. Distinct
values on `a` and `b` (e.g. `a='0'`, `b='1'`) make the routing easy to see.

### What to check in the waveform

- For `and3`: `y` should stay `'0'` for the first seven combinations and
  pulse `'1'` only on `111`.
- For `mux2_en`: `y` should be `'0'` whenever `en='0'`, and otherwise follow
  whichever input `sel` chooses.

You can peek at the testbenches we already provided (`tb_or_gate.vhd`, etc.)
for the *structural pattern* — but the stimulus for these two exercises is
yours to design. That is the whole point.

That completes Week 1. You now understand hardware thinking, basic VHDL
syntax, the toolchain, how to build small circuits from blocks, and how to
write and run a testbench. Everything from Week 2 onward builds directly on
these foundations. Make sure all six modules genuinely click before moving on
— the ramp gets steeper, but it's climbable if this base is solid.
