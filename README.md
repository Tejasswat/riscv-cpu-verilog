# RISC-V CPU Core (RV32I)

A simple RV32I-compatible single-cycle CPU core implemented in Verilog as a learning project in computer architecture and digital design.

This project focuses on understanding instruction decoding, control logic, ALU design, and control-flow handling in a RISC-V processor.

---

## Implemented Features

### Instruction Processing
- Instruction Fetch
- Instruction Decode (opcode, funct3, funct7, immediates)
- Register File (32 × 32-bit registers)

### ALU Operations
- Arithmetic: ADD, SUB, ADDI
- Logical: AND, OR, XOR
- Shift operations: SLL, SRL, SRA

### Control Flow
- Branch instructions:
  - BEQ (Branch if Equal)
  - BNE (Branch if Not Equal)
- Program Counter redesigned to support control-flow (`pc_next` based)

### Write-back
- Register write-back for ALU instructions
- Correct suppression of writes for branch instructions

---

## Verification
- Functional verification using custom testbenches
- Waveform-based debugging and validation in Xilinx Vivado
- Verified correct execution of arithmetic operations and branch control flow

---

## Tools Used
- Verilog HDL
- Xilinx Vivado (simulation and waveform analysis)

---

## Project Status
🚧 **Work in Progress**

Planned extensions:
- Additional branch instructions (BLT, BGE)
- Load/Store instructions (LW, SW)
- Jump instructions (JAL, JALR)
- Refactoring into a pipelined architecture

---

## Motivation
This project is part of a hands-on effort to build a strong foundation in CPU microarchitecture and RTL design by implementing a RISC-V core from scratch.
