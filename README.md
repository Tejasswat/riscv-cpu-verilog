# RISC-V RV32I Single-Cycle CPU (Verilog)

This project is a single-cycle RISC-V (RV32I) CPU core implemented from scratch in Verilog. The goal is to gain a deep, practical understanding of how a real instruction set architecture maps to hardware datapath and control logic.

The design emphasizes correctness, clarity, and architectural understanding rather than performance optimizations or pipelining.

---

## Implemented Features

### Instruction Support (RV32I subset)

#### Arithmetic and Logical (Register and Immediate)
- ADD, SUB
- AND, OR, XOR
- SLL, SRL, SRA
- ADDI

#### Memory Access
- LW (Load Word)
- SW (Store Word)

#### Control Flow
- BEQ (Branch if Equal)
- BNE (Branch if Not Equal)
- BLT (Branch if Less Than, signed)
- BGE (Branch if Greater or Equal, signed)
- BLTU (Branch if Less Than, unsigned)
- BGEU (Branch if Greater or Equal, unsigned)
- JAL (Jump and Link)
- JALR (Jump and Link Register)

All branch and jump instructions correctly update the program counter and follow the RISC-V specification.

---

## CPU Architecture

- Single-cycle datapath
- Separate instruction memory and data memory
- 32 × 32-bit register file
- ALU supporting arithmetic, logical, and shift operations
- Program Counter (PC) with support for sequential execution, branches, and jumps
- Write-back selection between ALU results and memory data
- Immediate decoding implemented for:
  - I-type
  - S-type
  - B-type
  - J-type

---

## Design Overview

- Instruction decoding based on opcode, funct3, and funct7 fields
- Control logic implemented using combinational always blocks
- PC updated synchronously with branch and jump resolution
- Branch comparisons implemented for both signed and unsigned operands
- No pipelining; each instruction completes in a single cycle

---

## Verification

The CPU is verified using a self-written Verilog testbench and waveform-based simulation in Xilinx Vivado.

Verification includes:
- Correct instruction fetch and decode
- Proper ALU execution and register write-back
- Functional load and store operations
- Correct branch and jump behavior (PC control)
- Validation of control signals such as reg_write, mem_write, and mem_to_reg

Key signals are observed directly in the waveform to validate datapath and control flow behavior.

---

## Project Structure

