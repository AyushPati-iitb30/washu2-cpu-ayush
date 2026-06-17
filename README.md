# WashU-2 CPU — VHDL Implementation

**Author:** Ayush Pati  
**Roll Number:** 25B3901  
**Email:** 25b3901@iitb.ac.in  
**Institution:** IIT Bombay — Electrical Engineering, Second Year  
**GitHub:** [github.com/AyushPati-iitb30](https://github.com/AyushPati-iitb30)  
**Program:** SOC 2026 — WashU-2 CPU Mentorship  
**Language:** VHDL (IEEE 1076), simulated with Intel Quartus Prime + ModelSim  

---

## About This Project

An 8-week mentorship project building a complete **16-bit accumulator-based CPU** from scratch in VHDL, based on the WashU-2 architecture originally designed by Prof. Jon Turner (Washington University in St. Louis).

The project is structured as a VHDL bootcamp (Weeks 1–5) followed by architecture study (Week 6) and full CPU implementation (Weeks 7–8). Every line of VHDL is written by hand.

### CPU Specifications

| Property | Value |
|---|---|
| Data width | 16 bits |
| Architecture | Accumulator-based |
| Pipeline | None (multi-cycle) |
| Control | 17-state FSM |
| Cycles / instruction | 4–7 |
| Instruction size | 16 bits (4-bit opcode + 12-bit operand) |
| Instruction set | 14 instructions |

---

## How to Simulate

All simulation is done through **Intel Quartus Prime Lite + ModelSim-Intel FPGA Edition**.

1. Open Quartus and create a new project in the exercise folder.
2. Add the design file (`<design>.vhd`) and testbench (`tb_<design>.vhd`) to the project.
3. In **Assignments → Settings → Simulation**, set the tool to ModelSim-Intel FPGA (VHDL) and set the testbench as the top-level simulation entity.
4. Run **Processing → Start Compilation**, then **Tools → Run Simulation Tool → RTL Simulation**.
5. In ModelSim, add signals to the Wave window and zoom to fit.

---

## Repository Structure

```
washu2-cpu-ayush/
│
├── README.md
├── .gitignore
│
├── bootcamp/                        # Weeks 1–5: VHDL learning exercises
│   ├── week1/
│   │   ├── exercise_a/              # Warm-up: 3-input AND gate (and3_gate)
│   │   ├── exercise_b/              # Warm-up: 2:1 mux with enable (mux2_en)
│   │   ├── exercise_1/              # XOR from structural gates (xor_structural)
│   │   ├── exercise_2/              # 2:1 multiplexer (mux2)
│   │   ├── exercise_3/              # Half adder (half_adder) — optional
│   │   └── week1_report.pdf         # RTL netlists + waveforms + bug notes
│   ├── week2/                       # Sequential logic: counters
│   ├── week3/                       # Finite state machines
│   ├── week4/                       # ALU + RAM (mid-submission)
│   └── week5/                       # Mini-datapath
│
├── architecture-study/              # Week 6: pen-and-paper deliverables
│   ├── instruction_trace.pdf        # 5-instruction cycle-by-cycle walkthrough
│   └── fsm_state_diagram.pdf        # Hand-drawn 17-state diagram
│
├── cpu/                             # Weeks 7–8: full CPU implementation
│   ├── cpu_design.vhd               # Complete WashU-2 CPU
│   ├── cpu_tb.vhd                   # Testbench + test program
│   └── quartus/                     # Quartus project files
│
└── docs/
    └── final_report.pdf             # Week 8 final report
```

---

## Progress

### Week 1 — Digital Logic + VHDL First Steps

| Exercise | Design | Testbench | Status |
|---|---|---|---|
| A — 3-input AND gate | `and3_gate.vhd` | `tb_and3_gate.vhd` | ✅ Done |
| B — 2:1 mux with enable | `mux2_en.vhd` | `tb_mux2_en.vhd` | ✅ Done |
| 1 — XOR from gates (structural) | `xor_structural.vhd` | `tb_xor_structural.vhd` | ✅ Done |
| 2 — 2:1 multiplexer | `mux2.vhd` | `tb_mux2.vhd` | ✅ Done |

### Week 2 — Sequential Logic

| Exercise | Design | Testbench | Status |
|---|---|---|---|
| 1 — 8-bit counter | `counter8.vhd` | `tb_counter8.vhd` | ✅ Done |
| 2 — Modulo counter | `mod_counter.vhd` | `tb_mod_counter.vhd` | ✅ Done |
| Optional — 4-bit bidirectional counter | `bi_counter4.vhd` | `tb_bi_counter4.vhd` | ✅ Done |

### Week 3 — Finite State Machines *(upcoming)*
### Week 4 — ALU + Memory *(upcoming — mid-submission)*
### Week 5 — Mini-Datapath *(upcoming)*
### Weeks 6–8 — Architecture Study + CPU *(upcoming)*

---

## Submission Deadlines

| Submission | Deadline | Contents |
|---|---|---|
| Mid-submission | End of Week 4 | `bootcamp/week1/` – `bootcamp/week4/` with reports |
| End submission | End of Week 8 | Full fork: weeks 1–5, architecture-study, cpu, docs |

---

## Resources

- [Free Range VHDL](http://freerangefactory.org/) — primary VHDL reference
- [Nandland VHDL Tutorials](https://nandland.com/)
- [Ben Eater — Build an 8-bit computer](https://eater.net/8bit)
- [Prof. Jon Turner — WashU CPU course](https://www.arl.wustl.edu/~jon.turner/cse/260/)
