# Week 2 — Starter Library

Two files are provided this week: a template you copy when writing your
own testbench, and one ready-made testbench you can use directly.

## Contents

```
starter_library/
├── tb_template_clocked.vhd     # template for writing your own testbenches
└── tb_counter8.vhd             # provided working testbench for Exercise 1
```

## tb_counter8.vhd

A complete, working testbench for the `counter8` exercise in Module 3.
Add it to your Quartus project alongside your own `counter8.vhd` design
and run RTL simulation. The stimulus is structured so the resulting
waveform clearly shows the three required regions (reset, counting,
hold).

So that the port map in this testbench matches your design, use these
exact entity and port names:

```
entity counter8
    port (
        clk    : in  std_logic;
        reset  : in  std_logic;
        enable : in  std_logic;
        count  : out std_logic_vector(7 downto 0)
    );
```

If your port names differ, the provided testbench will not compile.

## tb_template_clocked.vhd

A starting skeleton for the testbench you write in Module 4 for the
`mod_counter` design. Copy it to `tb_mod_counter.vhd` (or any other name
that matches your DUT), replace the placeholder signals and the DUT
instantiation, and write the stimulus appropriate to the design. The
clock generator at the top is the one piece of Week 2 boilerplate worth
not retyping each time.

## What is not provided

No starter designs. The two Module 3 exercises (`counter8` and
`mod_counter`) are written from scratch using the patterns in Modules 1
and 2. No testbench for `mod_counter` is provided — writing it is the
exercise in Module 4.
