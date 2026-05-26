# Week 2 · Module 3 — Exercises

Two design exercises, in order of increasing complexity. The first is the
deliverable; the second extends the same patterns with a small but
non-trivial design decision. Both are circuits to *design* — testbenches
for the first are provided in `starter_library/`, and writing the testbench
for the second is the subject of Module 4.

For clocked designs, predicting the waveform on paper before simulating
sharpens intuition quickly. Decide what each register should hold on the
third or fourth rising edge, then compare with the simulation. The places
where prediction and simulation disagree are where understanding gets
built.

---

## Exercise 1 — 8-bit counter with reset and enable (`counter8`)

The **Week 2 deliverable.**

Specification:

```
entity counter8
    inputs:  clk, reset, enable      (std_logic)
    output:  count : std_logic_vector(7 downto 0)
```

Behaviour:

- Asserted `reset` forces `count` to zero.
- When `reset` is low and `enable` is high, `count` increments by one on
  each rising edge, wrapping naturally from 255 to 0.
- When `reset` is low and `enable` is low, `count` holds.

The reference pattern is in Module 2, §5. Use the
`std_logic_vector(unsigned(...) + 1)` chain from Module 1, §5.

A working testbench, `tb_counter8.vhd`, is provided in `starter_library/`.
Add it to your Quartus project alongside your design and run the
simulation. The waveform must clearly show three identifiable regions —
reset, counting, and hold — over the course of one run; capture a
screenshot of this waveform as part of the deliverable.

---

## Exercise 2 — Modulo-`N` counter (`mod_counter`)

An extension that introduces a comparison alongside the increment and adds
a single-cycle strobe output. The corresponding testbench is **not**
provided — writing it is the exercise in Module 4.

Specification:

```
entity mod_counter
    generic: N : integer := 10                       -- modulus
    inputs:  clk, reset, enable           (std_logic)
    outputs: count : std_logic_vector(3 downto 0)
             tick  : std_logic                       -- one-cycle pulse at wrap
```

Behaviour:

- `count` advances from `0` through `N-1` on enabled rising edges, then
  returns to `0` on the following enabled edge.
- `tick` is high for exactly one clock cycle aligned with the wrap point.
- Reset returns `count` to zero and `tick` to low.

This is the first exercise where you choose between two structurally
different designs:

1. Drive `tick` from a combinational comparison —
   `tick <= '1' when count_int = N-1 else '0';` — so the pulse is high
   during the cycle *before* `count` wraps.
2. Drive `tick` from a registered comparison inside the clocked process,
   so the pulse is high during the cycle *of* the wrap.

Both are correct; the resulting waveforms differ by one cycle, and the
testbench you write in Module 4 must match whichever you chose. Note your
choice in a brief comment in the source.

> The `generic` clause is VHDL's mechanism for a compile-time parameter,
> used here so the same entity can be instantiated as a mod-10, mod-7, or
> mod-128 counter without modification. Inside the architecture, `N` is
> referenced like any constant. Leave the default at `N := 10` for now.

---

## What to submit at the end of the week

- `counter8` — design source, plus the provided testbench in your project,
  plus a waveform screenshot showing the reset, counting, and hold regions.
- `mod_counter` — design source, the testbench you wrote in Module 4, and
  a waveform showing at least two wrap cycles with `tick` correctly
  aligned.

Next: **Module 4 — Testbenches for Clocked Designs**.
