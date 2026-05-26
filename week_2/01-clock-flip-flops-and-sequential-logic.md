# Week 2 · Module 1 — The Clock, Flip-Flops & Sequential Logic

Last week's circuits had no notion of time. Their outputs depended only on
their current inputs and changed the instant the inputs changed. That style —
*combinational logic* — cannot count, cannot remember a value, and cannot
march in step with anything else. Anything more interesting than a gate needs
the missing ingredient introduced here: **state**, captured at a precise
moment defined by a **clock**.

This module covers four things you need before you can build a register or a
counter: the clock signal, the D flip-flop, the canonical clocked-process
pattern in VHDL, and the two language details that make arithmetic on bit
vectors actually work.

---

## 1. The clock

A **clock** is a signal that alternates `0, 1, 0, 1, ...` at a fixed rate.
The instants when the clock transitions matter; the time between transitions
does not. Synchronous digital design adopts the convention that all stateful
elements update **at the same instant** — typically on the **rising edge**
(the `0 → 1` transition) — and remain unchanged between edges.

In VHDL the rising edge is expressed by the function `rising_edge(clk)`. Any
assignment guarded by

```vhdl
if rising_edge(clk) then
    -- ...
end if;
```

executes only at that instant. Between edges, the guard is false and nothing
inside fires. This is precisely how memory enters the language: a signal
assigned only inside this guard retains its value until the next edge tells
it to capture a new one.

---

## 2. The D flip-flop

The **D flip-flop** is the smallest stateful element in digital hardware. It
has one data input `d`, one clock input, and one output `q`, governed by a
single rule: at each rising edge, copy `d` to `q`; at all other times, hold
`q` unchanged.

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity dff is
    port (
        clk : in  std_logic;
        d   : in  std_logic;
        q   : out std_logic
    );
end dff;

architecture rtl of dff is
begin
    process (clk)
    begin
        if rising_edge(clk) then
            q <= d;
        end if;
    end process;
end rtl;
```

Three observations about the architecture body:

1. The **sensitivity list** `(clk)` lists the signals whose changes wake the
   process for re-evaluation. For a basic synchronous flip-flop only `clk`
   belongs here; data signals never do.
2. `if rising_edge(clk) then ... end if;` is the unambiguous signature of a
   flip-flop. The synthesizer recognises it as such and produces real
   register hardware.
3. **There is no `else` clause.** When the guard is false, no assignment to
   `q` is executed, and in hardware terms an unassigned signal inside a
   clocked process simply *holds its previous value*. This is the mechanism
   that gives the flip-flop its memory.

The third point generalises: in every clocked process you will write, the
absence of an assignment under a particular condition is the way you express
"hold." You do not write `q <= q;` to hold a value; you simply do nothing.

---

## 3. Sequential vs. combinational, side by side

The same architecture body can contain both styles, and you will mix them
constantly. The distinction is structural:

| Style | VHDL shape | Hardware produced |
|---|---|---|
| Combinational | concurrent statement, e.g. `y <= a and b;` | gates, no memory |
| Sequential | `process (clk) ... if rising_edge(clk) then ... end if; ... end process;` | flip-flops/registers |

A typical design uses combinational logic to compute next-cycle values and
clocked processes to capture them. The WashU-2 CPU is built on this pattern
at scale: a combinational ALU and address-arithmetic feeding clocked
registers (`ACC`, `PC`, `iReg`, and so on).

---

## 4. Signal semantics inside a clocked process

A subtle but important property of signal assignment (`<=`) is that the
update is **scheduled, not immediate**. Within a single execution of the
process, every right-hand side reads the signal's *current* value; the new
values become visible only after the process step completes. This matters
whenever several signals are assigned together:

```vhdl
if rising_edge(clk) then
    a <= b;
    b <= a;
end if;
```

Both right-hand sides see the original values, so `a` and `b` swap cleanly.
This behaves exactly like real hardware registers, which all capture their
new values on the same edge.

The same property shows up in the CPU's instruction-fetch phase, where three
registers update on one edge:

```vhdl
state <= decode(iReg);
this  <= pc;
pc    <= std_logic_vector(unsigned(pc) + 1);
```

`this` receives the old `pc`; `pc` becomes the old `pc + 1`; `state`
transitions based on the current `iReg`. All three assignments take effect
together at the next clock edge.

Variables (`:=`) follow the opposite rule — they update immediately and are
local to a process — but you will rarely need them in this project. **Default
to signals.** Reach for a variable only when you specifically want a
short-lived intermediate that updates sequentially inside a single process
step.

---

## 5. Arithmetic on bit vectors

A counter needs to add `1` to a `std_logic_vector` signal. Doing so directly
is a type error:

```vhdl
count <= count + 1;        -- not legal: + is not defined on std_logic_vector
```

The reason is deliberate: `std_logic_vector` is a bag of bits with no
declared numeric meaning. The `numeric_std` library — which you already
import — provides the missing interpretations:

- `unsigned` — bits interpreted as a non-negative binary number,
- `signed`  — bits interpreted as two's complement.

Arithmetic is defined on these. The pattern is to cast in, compute, and cast
back:

```vhdl
count <= std_logic_vector( unsigned(count) + 1 );
```

`unsigned(count)` is a type cast (no hardware cost); `+ 1` is now legal;
`std_logic_vector(...)` restores the original type so the assignment
type-checks. The same three-step shape covers subtraction, addition of two
vectors, and (with `signed`) sign-aware arithmetic.

One related operation appears the moment a vector is used as an array index,
for example to read a memory location:

```vhdl
mem( to_integer(unsigned(addr)) ) <= data;
```

Array indices must be plain `integer`, so the vector is first cast to
`unsigned` and then to `integer`. Both chains — `std_logic_vector(unsigned(...) + 1)`
for arithmetic and `to_integer(unsigned(...))` for indexing — recur
throughout the project.

> Forgetting `use IEEE.NUMERIC_STD.ALL;` produces the characteristic error
> *"no feasible entries for operator +"*. If you ever see it, that one
> missing line is almost certainly the cause.

---

## 6. A complete clocked counter

The four ideas above are enough to assemble a working counter:

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter8 is
    port (
        clk   : in  std_logic;
        count : out std_logic_vector(7 downto 0)
    );
end counter8;

architecture rtl of counter8 is
    signal count_int : std_logic_vector(7 downto 0) := (others => '0');
begin
    process (clk)
    begin
        if rising_edge(clk) then
            count_int <= std_logic_vector( unsigned(count_int) + 1 );
        end if;
    end process;

    count <= count_int;
end rtl;
```

Two small points of style worth noting:

- An `out` port cannot be read inside the architecture, so the counter's
  state is held in an internal signal `count_int` and the port is driven
  from it.
- `(others => '0')` is the width-agnostic literal for "all zeros." Prefer it
  to typing out a string of bits — it does not need updating if you change
  the vector's width.

This counter wraps from `255` back to `0` automatically (8-bit unsigned
arithmetic), runs forever, and offers no way to pause or restart. Module 2
adds the two controls that turn it into something usable: a reset and an
enable.

---

## 7. Recommended outside resources

- **Nandland (YouTube)** — *"What is a Flip Flop"* / *"D Flip Flop"* — short
  introductions matching the canonical pattern in this module.
- **GeeksforGeeks** — *"D Flip Flop"* and *"VHDL numeric_std"* — concise
  written references with timing diagrams and worked examples.

Next: **Module 2 — Reset, Enable & Useful Registers**.
