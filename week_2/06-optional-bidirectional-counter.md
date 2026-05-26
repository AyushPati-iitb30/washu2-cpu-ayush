# Optional Exercise — Bidirectional 4-bit Counter

This exercise is optional and intended for students who complete the main exercises early.

Goal:
Create a counter that can count both upward and downward depending on a control signal.

---

# Problem Statement

Design a 4-bit counter with the following behavior:

- If `dir = '1'`, counter increments.
- If `dir = '0'`, counter decrements.
- Counter updates on every rising edge of the clock.
- Reset should clear the counter to `0000`.

---

# Inputs and Outputs

## Inputs

```vhdl
clk
reset
en
dir
```

## Output

```vhdl
q(3 downto 0)
```

---

# Expected Behavior

## Counting Up (`dir = '1'`)

```text
0000
0001
0010
0011
...
```

## Counting Down (`dir = '0'`)

```text
1111
1110
1101
1100
...
```

---

# Hints

## 1. Use `unsigned`

```vhdl
signal count : unsigned(3 downto 0);
```

---

## 2. Increment / Decrement Logic

```vhdl
if rising_edge(clk) then

    if reset = '1' then
        count <= "0000";

    elsif en = '1' then

        if dir = '1' then
            count <= count + 1;
        else
            count <= count - 1;
        end if;

    end if;

end if;
```

---

# Testbench Suggestions

Try testing:
- reset behavior
- counting up
- counting down
- switching direction during simulation
- enable ON/OFF behavior

---

# Extension Ideas

If completed successfully, try:
- adding load input
- programmable start value
- modulo counter behavior
- overflow detection

---

# Learning Goal

This exercise strengthens:
- clocked sequential logic
- arithmetic on vectors
- conditional updates
- waveform debugging
- testbench writing

This is very similar to the type of logic used inside timers and processor registers.
