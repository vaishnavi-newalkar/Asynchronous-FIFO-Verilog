# Asynchronous FIFO Design in Verilog

This project implements an **Asynchronous FIFO (First-In-First-Out) memory buffer** using **Verilog HDL**.
The FIFO allows **data transfer between two different clock domains**, making it useful in systems where read and write operations operate at different clock frequencies.

The design uses **Gray code pointer synchronization** to safely transfer pointer values across clock domains and avoid metastability issues.

---

## 📌 Key Features

* Supports **independent read and write clocks**
* **Configurable data width and FIFO depth**
* Uses **Gray code pointers** for safe clock domain crossing
* Implements **full and empty flag detection**
* Two-stage synchronizers for reliable pointer transfer

---

## 🧠 Design Overview

The FIFO uses a **dual clock architecture**:

* **Write Clock (`wr_clk`)** → Used for writing data into FIFO
* **Read Clock (`rd_clk`)** → Used for reading data from FIFO

Data written into the FIFO is stored in memory and read out in the **same order** (FIFO principle).

---

## ⚙️ Parameters

| Parameter  | Description                  |
| ---------- | ---------------------------- |
| DATA_WIDTH | Width of data stored in FIFO |
| ADDR_WIDTH | Number of address bits       |
| DEPTH      | FIFO size = 2^ADDR_WIDTH     |

Example:

```
DATA_WIDTH = 8
ADDR_WIDTH = 4
DEPTH = 16
```

---

## 📥 Inputs

| Signal   | Description  |
| -------- | ------------ |
| `wr_clk` | Write clock  |
| `rd_clk` | Read clock   |
| `rst`    | Reset signal |
| `wr_en`  | Write enable |
| `rd_en`  | Read enable  |
| `din`    | Input data   |

---

## 📤 Outputs

| Signal  | Description          |
| ------- | -------------------- |
| `dout`  | Output data          |
| `full`  | FIFO full indicator  |
| `empty` | FIFO empty indicator |

---

## 🔄 Working Principle

### Write Operation

When:

```
wr_en = 1 and full = 0
```

* Data is written into memory
* Write pointer increments
* Pointer converted to **Gray code**

---

### Read Operation

When:

```
rd_en = 1 and empty = 0
```

* Data is read from FIFO memory
* Read pointer increments
* Pointer converted to **Gray code**

---

### Clock Domain Crossing

To safely transfer pointers between clock domains:

* **Two flip-flop synchronizers** are used
* Gray code ensures **only one bit changes at a time**
* This reduces metastability risks

---

## 📂 Project Structure

```
Asynchronous-FIFO-Verilog
│
├── async_fifo.v      # FIFO design
├── fifo_tb.v         # Testbench for simulation
└── README.md
```

---

## 🧪 Simulation

The design can be simulated using:

* ModelSim
* Vivado Simulator
* Icarus Verilog
* GTKWave

### Example using Icarus Verilog

Compile:

```
iverilog async_fifo.v fifo_tb.v
```

Run simulation:

```
vvp a.out
```

---

## 🛠 Skills Demonstrated

* Verilog HDL
* Asynchronous FIFO Architecture
* Clock Domain Crossing (CDC)
* Gray Code Pointer Synchronization
* Digital System Design
* Hardware Simulation

---

## 🚀 Possible Improvements

Future extensions of this design could include:

* Almost full / almost empty flags
* Parameterized FIFO depth
* Formal verification
* FPGA synthesis and hardware testing
* AXI Stream FIFO interface


---
