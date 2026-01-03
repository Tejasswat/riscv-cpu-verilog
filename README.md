# RISC-V RV32I Single-Cycle CPU (Verilog)

A single-cycle RISC-V (RV32I) CPU core implemented from scratch in **Verilog**, designed to understand how a real instruction set architecture maps to actual hardware (datapath + control).

This project focuses on **clarity, correctness, and architectural understanding**, not performance or pipelining.

---

## 🔧 Features Implemented

### ✅ Instruction Support (RV32I subset)

#### Arithmetic & Logical
- ADD
- SUB
- AND
- OR
- XOR
- SLL, SRL, SRA
- ADDI

#### Memory Access
- LW (Load Word)
- SW (Store Word)

#### Control Flow
- BEQ (Branch if Equal)
- BNE (Branch if Not Equal)
- JAL (Jump and Link)
- JALR (Jump and Link Register)

---

### ✅ CPU Architecture

- **Single-cycle datapath**
- Separate **instruction memory** and **data memory**
- Register file with 32 × 32-bit registers
- ALU supporting arithmetic, logical, and shift operations
- Proper **PC control** (`pc + 4`, branches, jumps)
- Write-back mux (`ALU result` vs `memory data`)
- Immediate decoding for:
  - I-type
  - S-type
  - B-type
  - J-type

---

## 🧠 Design Highlights

- Instruction decoding using `opcode`, `funct3`, and `funct7`
- Clean separation of:
  - Fetch
  - Decode
  - Execute
  - Memory
  - Write-back
- Control logic implemented using combinational `always @(*)` blocks
- PC updated synchronously with support for branches and jumps
- Verified through waveform-based simulation

---

## 🧪 Verification

The CPU is verified using a custom **Verilog testbench** and simulation in **Xilinx Vivado**.

Waveforms demonstrate:
- Correct instruction fetch and decode
- Proper ALU operations
- Correct register write-back
- Functional load/store behavior
- Correct branch and jump control (`BEQ`, `JAL`, `JALR`)

Key signals observed:
- `pc_out`, `pc_next`
- `instr_out`
- `rd1`, `rd2`, `alu_out`
- `reg_write`, `mem_to_reg`, `mem_write`
- Architectural registers (`x1`, `x2`, `x3`, …)

---

## 📁 Project Structure

