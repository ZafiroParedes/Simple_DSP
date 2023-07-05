_In progress..._
# Simple Digital Signal Processor
Spring 2023

This is an implementation of a digital signal processor in VHDL that includes an Arithmetic Logic Unit, Barrel Shifter, Multiply and Accumulator Unit, and Program Sequencer computational units.

## Top Level
The top-level diagram of the DSP is shown below. Each section represents a component in the VHDL top level of the program. The DSP is composed of a processing unit, controller, and program memory.

![DSP Diagrams](https://github.com/ZafiroParedes/Simple_DSP/assets/91034132/4d5d2d25-3ceb-4ad1-99bf-4de16ef2a8a1)

### Processing Unit
The processing unit has all the computational units, also seen below. The necessary buses used for exchanging information are:

PMA: Program Memory Address bus, the bus that contains the address of the current instruction in the program

PMD: Program Memory Data bus, the bus that contains the actual current instruction in the program

DMA: Data Memory Address bus, the bus that contains the address of where the desired data is located

DMD: Data Memory Data bus, the actual data from a memory address

![DSP Diagrams2](https://github.com/ZafiroParedes/Simple_DSP/assets/91034132/4c183693-8f62-4135-a703-d633e70cc4dc)


#### ALU

![ALU Diagram](https://github.com/ZafiroParedes/Simple_DSP/assets/91034132/7639382b-02aa-4cb0-babc-d0b12bc45d8e)


#### Barrell Shifter

#### MAC

![MAC Diagram](https://github.com/ZafiroParedes/Simple_DSP/assets/91034132/21cb152d-68ae-4b5e-938f-2a1f3e7a627e)


#### Program Sequencer

The address busses are only necessary for the program sequencer since the sequencer is used to keep the program running sequentially or manage interrupts, , and loops. 

### Controller

### Program Memory

## Results

### Debugging

### Functioning Simulation
