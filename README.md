# Design, Simulation and Synthesis of Sequential Logic and Implementation on the Zedboard

This project implements a **universal 4-bit counter** in VHDL, along with a **frequency divider** and Zedboard integration. The design is simulated, verified with a testbench, synthesized, and finally implemented on the Zedboard using switches as inputs and LEDs as outputs.

The focus is on understanding how different **sequential logic coding styles** affect **synthesis**, while still matching the same behavioral specification in simulation.

---

## 1. Project overview

The main component is a **clocked, loadable, resettable, bidirectional 4-bit counter** with an overflow/underflow indication. The design includes:

- A **universal counter** (`universal_counter.vhd`)
- A **clock divider** (`clock_divider.vhd`) to slow down the 100 MHz Zedboard clock
- A **top-level module** (`top_level.vhd`) that maps switches and LEDs to the counter signals
- A **self-checking testbench** (`counter_tb.vhd`) for simulation and verification

---

## 2. Universal counter specification

The counter operates according to the following behavior:

- **Enable (`enable`)**  
  - Counting starts when `enable = '1'`  
  - Counting pauses when `enable = '0'` (the `count` and `over` outputs hold their values)

- **Asynchronous reset (`arst_n` or `arst`)**  
  - When `arst_n = '0'` (active-low) or `arst = '1'` (active-high):
    - `count` is reset to `D'0` (i.e., `"0000"`)
    - `over` is reset to `B'0` (i.e., `'0'`)

- **Direction (`dir`)**  
  - `dir = '0'` → **up-counting** (increment)
  - `dir = '1'` → **down-counting** (decrement)

- **Overflow / Underflow and `over` flag**  
  - On upwards counting (`dir = '0'`):  
    - If `count = 15` and the next step increments:
      - In the next clock cycle: `count` becomes `D'0`, `over` becomes `B'1`
      - In the following clock cycle: `over` is automatically cleared to `B'0`
  - On downwards counting (`dir = '1'`):  
    - If `count = 0` and the next step decrements:
      - In the next clock cycle: `count` becomes `D'15`, `over` becomes `B'1`
      - In the following clock cycle: `over` is cleared to `B'0`

- **Load (`load`) and data (`data`)**  
  - When `load = '1'` and `enable = '1'`:
    - The 4-bit vector `data` is loaded into `count` on the next clock edge.
  - `data` is a 4-bit input: `data(3 downto 0)`

The behavior can be summarized as:

- `count` and `over` change **synchronously** with the clock, except when **reset is active**, where they react **asynchronously**.
- Inputs (`reset`, `enable`, `dir`, `load`, `data`) may change asynchronously, but outputs only update on clock edges (apart from reset).

---

## 3. Counter architecture details

The `counter` module is implemented:

- Inside a **single clocked process** (one-process sequential style)
- Using **variables** internally to hold and update the counter value and overflow flag
- With an **asynchronous reset** branch and synchronous logic for enable/load/count/overflow

Key aspects:

- Asynchronous reset branch checks either:
  - `arst_n = '0'` (active-low), or  
  - `arst = '1'` (active-high), depending on the chosen implementation
- Synchronous part:
  - Handles `enable`, `load`, `dir`, overflow/underflow detection, and `over` flag clearing
- The design is written to be **synthesizable** and suitable for FPGA implementation.

---

## 4. Testbench and simulation (Part 1)

A dedicated testbench (`counter_tb.vhd`) is used to:

- Drive the counter with **exhaustive or targeted input scenarios**
- Verify:
  - Reset behavior
  - Enable/disable behavior
  - Up and down counting (`dir`)
  - Load operation (`load` + `data`)
  - Overflow and underflow conditions, including `over` timing

### Testbench characteristics

- Generates a clock signal for the counter
- Applies asynchronous changes on:
  - `reset`
  - `enable`
  - `dir`
  - `load`
  - `data`
- Uses `assert` statements and/or waveform inspection to verify correctness
- Lists the signals in the waveform viewer in the same order as required in the assignment (matching the reference screenshot)

This ensures all **functionalities** of the counter are exercised and verified in simulation.

---

## 5. Zedboard implementation (Part 2)

The design is then implemented on the **Zedboard**, using:

- **Switches** as inputs:
  - Reset (e.g., `SW0` / `SW1`)
  - Enable
  - Load
  - Direction (`dir`)
  - Data: `data(3 downto 0)`
- **LEDs** as outputs:
  - `count(3 downto 0)` → mapped to 4 LEDs
  - `over` → mapped to 1 LED

### Clock and frequency divider

The Zedboard provides a **100 MHz system clock**, which is too fast to visually observe the counter changes directly.  
Therefore, a **clock divider (frequency divider)** is used:

- `clock_divider.vhd` divides 100 MHz down to a much slower frequency (e.g., a few Hz)
- The divided clock drives the `counter` so you can see the LED changes by eye

Important design rule:

- The **frequency divider is separated from the counter**:
  - The counter module is purely functional and used for both:
    - Fast simulation in testbench
    - Slow visual operation on hardware
  - The testbench for the clock divider uses a much smaller threshold (for example, from 100 MHz to 5 MHz), so simulation completes quickly.

---

## 6. File structure (suggested)

A clean structure for this project might be:

- `project_2.srcs/sources_1/new/`
  - `universal_counter.vhd` – main counter implementation
  - `clock_divider.vhd` – clock/frequency divider
  - `top_level.vhd` – connects Zedboard I/O to counter and clock divider

- `project_2.srcs/sim_1/new/`
  - `counter_tb.vhd` – testbench for the universal counter
  - (optional) `clock_divider_tb.vhd` – testbench for the clock divider

- `constraints/`
  - `top.xdc` – pin constraints for Zedboard (switches, LEDs, clock)

- `README.md`  
  This documentation.

*(Vivado-generated folders like `.runs/`, `.sim/`, `.cache/`, `.hw/`, `.ip_user_files/`, `.xpr`, `.jou`, `.log`, etc. are typically excluded from version control.)*

---

## 7. Summary

This project demonstrates:

- **Design** of a robust, feature-rich sequential component (universal counter)
- Use of **single-process sequential coding style** with variables and asynchronous reset
- **Exhaustive simulation and verification** of reset, enable, load, direction, and overflow/underflow behavior
- Practical **FPGA implementation on the Zedboard**, including a **clock divider** to make the design observable on real hardware

It provides a complete workflow:  
**Specification → VHDL design → Simulation → Synthesis → FPGA implementation.**
