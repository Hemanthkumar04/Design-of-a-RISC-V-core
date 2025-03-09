# Design-of-a-RISC-V-core
# Overview

This project implements a simple RISC-V processor in Verilog. The design includes an Arithmetic Logic Unit (ALU), Register File, Control Unit, Instruction Memory, Data Memory, and a Program Counter (PC). The project also includes a testbench to simulate and verify the functionality of the processor.

# Features

Supports basic RISC-V instructions

ALU operations: ADD, SUB, MUL, DIV, AND, OR, XOR, NOT, NAND, NOR, XNOR, shift operations

Register file with 32 registers

Instruction fetch, decode, execute pipeline

Memory read/write operations

Control unit to manage execution flow

Testbench for simulation

# File Structure

ALU.v - Arithmetic Logic Unit

RegisterFile.v - Register file implementation

ControlUnit.v - Control signal generator

InstructionMemory.v - Stores RISC-V instructions

DataMemory.v - Stores data for execution

PC.v - Program Counter

instruction_decode.v - Extracts opcode, registers, and immediate values

RISC_V_Processor.v - Top-level module integrating all components

RISC_V_Processor_tb.v - Testbench for simulation

# Execution in Xilinx Vivado

## Steps to Simulate in Vivado:

Open Xilinx Vivado and create a new project.

Select RTL Project and add all Verilog source files (.v files).

Set the top module to RISC_V_Processor.v.

Add RISC_V_Processor_tb.v as a simulation source.

Click on Run Simulation > Run Behavioral Simulation.

Observe the output signals using the waveform viewer.

Modify testbench parameters if needed and rerun the simulation.

## Steps to Synthesize and Implement:

Click Synthesis > Run Synthesis.

Click Implementation > Run Implementation.

Click Generate Bitstream to create the FPGA configuration file.

(Optional) Use the Hardware Manager to program an FPGA board if available.
