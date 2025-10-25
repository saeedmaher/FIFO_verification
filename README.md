# 🧠 Synchronous FIFO Verification Project

## 📘 Overview
This repository contains the **design and verification** of a **Synchronous FIFO (First-In-First-Out)** implemented in **SystemVerilog**.  
The project includes the FIFO RTL design, verification environment, functional coverage, assertions, and simulation setup files.  
It follows an **object-oriented testbench methodology** with a focus on achieving **100% code, functional, and assertion coverage**.

---

## ⚙️ Design Parameters

| Parameter | Description | Default |
|------------|--------------|----------|
| `FIFO_WIDTH` | Data width for input/output and memory words | 16 |
| `FIFO_DEPTH` | Number of memory entries in the FIFO | 8 |

---

## 🔌 FIFO Port Description

| Port | Direction | Description |
|------|------------|-------------|
| `data_in` | Input | Write data bus |
| `wr_en` | Input | Write enable (active when FIFO not full) |
| `rd_en` | Input | Read enable (active when FIFO not empty) |
| `clk` | Input | Clock signal |
| `rst_n` | Input | Active-low asynchronous reset |
| `data_out` | Output | Read data bus |
| `full` | Output | Indicates FIFO is full |
| `almostfull` | Output | High when one more write will fill the FIFO |
| `empty` | Output | Indicates FIFO is empty |
| `almostempty` | Output | High when one more read will empty the FIFO |
| `overflow` | Output | Write attempted when FIFO is full |
| `underflow` | Output | Read attempted when FIFO is empty |
| `wr_ack` | Output | Acknowledge of a successful write operation |

---

## 🧩 Verification Environment

### 🔹 Top Module
- Generates the **clock** and **reset**.
- Passes the interface handle to **DUT**, **testbench**, and **monitor**.
- Ends simulation when `test_finished` signal is asserted.

### 🔹 Monitor
- Creates and manages objects of:
  - `FIFO_transaction`
  - `FIFO_scoreboard`
  - `FIFO_coverage`
- Samples the interface signals every clock cycle.
- Calls coverage and checking methods.
- Stops simulation and reports summary statistics at the end.

---

## 🧱 Class Architecture

### 1. **`FIFO_transaction`**
- Holds FIFO inputs and outputs as class members.
- Includes configurable randomization distributions:
  - `RD_EN_ON_DIST` (default: 30)
  - `WR_EN_ON_DIST` (default: 70)
- Defines constraints for:
  - Rare reset assertions
  - Read/Write enable signal distributions

### 2. **`FIFO_coverage`**
- Imports `FIFO_transaction` package.
- Defines a **covergroup** to perform cross coverage between:
  - `wr_en`, `rd_en`, and each control output (`full`, `empty`, `almostfull`, `almostempty`, etc.)
- Ensures all FIFO operational states are exercised.
- Contains a `sample_data()` method for sampling coverage.

### 3. **`FIFO_scoreboard`**
- Imports `FIFO_transaction` package.
- Implements a **reference model** for FIFO functionality.
- Compares DUT outputs against expected reference results.
- Increments `correct_count` and `error_count` accordingly.
- Displays mismatch messages for debugging.

---

## 🧾 Assertions

Assertions are embedded in the FIFO RTL file and guarded using conditional compilation:


