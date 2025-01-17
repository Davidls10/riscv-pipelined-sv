# riscv-pipelined-sv

This project aims to implement on HDL a functional version of a pipelined microarchitecture for
the RV32I version of the RISC-V ISA.

The processor has five stages: Fetch, Decode, Execute, Memory, and Writeback.

The principal units are: Instruction Memory (holds the instructions of the running program),  Register File (32 registers of 32 bits, x0 
hardwired to zero), ALU (support for sum, subtraction, and bitwise, or bitwise), Extend Unit (extend words to 32 bits, based on the logic 
of the current instruction), Memory (represents a RAM), and Hazard Unit (this unit handles the hazards of this microarchitecture, forwarding 
results to subsequent instructions on the pipeline, stalling for the lw instruction, and flushing registers when a branch is taken).

The instruction's opcodes in the "instruction_memory.sv" file must be changed manually to modify the testing assembly program. The default program
forces the hazards of the microarchitecture to be handled by the Hazard Unit.

The implemented and tested instructions are: lw, sw, or, and, beq, addi.

The top-level module is the "processor.sv" file, where the other units are instantiated. The testbench is a simple clocking of the top-level
module. There are some "$display" tasks on the top-level module for debugging.

Tested on Vivado 2024.2 and the Verilog version on Icarus Verilog.

The implementation is based on Sarah Harris and David Harris's "Digital Design and Computer Architecture RISC-V Edition".
