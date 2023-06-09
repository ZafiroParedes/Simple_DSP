# Simple Digital Signal Processor
_Spring 2023_

This is an implementation of a digital signal processor in VHDL that includes an Arithmetic Logic Unit, Barrel Shifter, Multiply and Accumulator Unit, and Program Sequencer computational units.

_Note: All programs with complex signals that have multiple inputs and/or outputs have all the inputs and outputs in the name to keep track of where the signal came from and where they are heading_

## Top Level
The top-level diagram of the DSP is shown below. Each section represents a component in the VHDL top level of the program. The DSP comprises a processing unit, controller, and program memory.

![DSP Diagrams](https://github.com/ZafiroParedes/Simple_DSP/assets/91034132/4d5d2d25-3ceb-4ad1-99bf-4de16ef2a8a1)

### Processing Unit
The processing unit has all the computational units, also seen below. The necessary buses used for exchanging information are:

- PMA: Program Memory Address bus, the bus that contains the address of the current instruction in the program
- PMD: Program Memory Data bus, the bus that contains the actual current instruction in the program
- DMA: Data Memory Address bus, the bus that contains the address of where the desired data is located
- DMD: Data Memory Data bus, the actual data from a memory address

![DSP Diagrams2](https://github.com/ZafiroParedes/Simple_DSP/assets/91034132/4c183693-8f62-4135-a703-d633e70cc4dc)

All units are controlled with control signals that load registers with new data and select multiplexer and tri-state buffer outputs.

#### ALU
The arithmetic Logic Computational Unit was programmed utilizing the diagram below. Additional registers (in green) and multiplexers (in blue) are used to process logical computations along with the individual ALU unit that chooses computations with operational codes. Since there is only one data and address bus, registers save values that can be recalled to complete a computation, and tri-state buffers (triangles in black) are used to choose which value is sent to the buses. 

![ALU Diagram](https://github.com/ZafiroParedes/Simple_DSP/assets/91034132/7639382b-02aa-4cb0-babc-d0b12bc45d8e)

#### Barrell Shifter
The barrell shifter contributes to computations by shifting a binary number a specific amount of times in a specific direction in one clock cycle which reduces the complexity of several computations. 

![BS Diagram](https://github.com/ZafiroParedes/Simple_DSP/assets/91034132/b6d38164-ca7e-4a32-b7f1-bf256c0a4f1f)

#### MAC
Similar to the ALU, the Multiply and Accumulate Computational Unit has multiple registers and multiplexers to save values and complete operations. However, the MAC is limited to only multiple, add, and subtract operations. 

![MAC Diagram](https://github.com/ZafiroParedes/Simple_DSP/assets/91034132/38a727e2-841f-4284-a0de-28c27ab3a6f4)

#### Program Sequencer
The address buses are only necessary for the program sequencer since the sequencer is used to keep the program running sequentially or manage interrupts, jumps, and loops. In this implementation, the program sequencer was tested to run sequentially and run with a conditional loop. Signals that processed interrupts or jumps were replaced with a number that could be identified and are not meant to be used.

![PS Diagram](https://github.com/ZafiroParedes/Simple_DSP/assets/91034132/fb34efc6-9801-46c4-ba90-19909b381c7f)


### Controller
The controller unit was given to help complete the DSP in time. However, due to differences in unit development, activating signals had to be verified and changed to fit how the computational units functioned. Since the controller sends control signals to control aspects such as registers, multiplexers, tri-state buffers, etc. For example, a multiplexer's first input could be default to be selected as a '1' but our multiplexers were created to be set as '0' so the control signals for the multiplexer need to be modified for the complete DSP to function as needed.

### Program Memory
The program memory was created for the purpose of simulating an actual DSP with a set of instructions to test and see if the DSP would be able to complete computations successfully. An array of bit vectors was created to store lines of binary instructions in a vector that can be called with an 'address,' the address location in the vector. The set of instructions is created to run sequentially, although a commented set of instructions remains to test if the program can run a loop with the vector format.

The program instructions in the program memory is shown below. The index () represents the instruction memory address and the instruction itself is the data.
```
memory(1) := “010000000000000000100000”;  -- 0. AX0 = 2 
memory(2) := “010000000000000000110101”;  -- 1. AY1 = 3 
memory(3) := “010000000000000001000010”;  -- 2. MX0 = 4; 400042 
memory(4) := “010000000000000000100111”;  -- 3. MY1 = 2; 400027 
memory(5) := “010010110110101000111000”;  -- 4. SI = B6A3 4B6A38 
memory(6) := “001010100110100010100000”;  -- 4. AR = AX0 +AY1; 2A68A0 
memory(7) := “001010000010100010110000”;  -- 5. MR0 = MX0 * MY1 2828B0 
memory(8) := “000011110000000011111011”;  -- 6. SR = Lshift (-5) 0f00fb 
memory(9) := “000000101000000000000000”;  -- Idle 
```

## Results
The DSP was tested and verified through ModelSim. Below is a functioning simulation of computations being processed through all computational units with minimal signal manipulation, each one leaving the results in the R bus.

### Functioning Simulation
Below are the results of the program instructions, where instruction 6 used the ALU, 7 used the MAC, and 8 used the barrel shifter.

![Results in sig](https://github.com/ZafiroParedes/Simple_DSP/assets/91034132/4ad6962c-788f-44cd-8ad5-c28af956508c)

The image above shows how each component had an implemented output signal to check that the component itself computed the calculation correctly. However, since each instruction only has one clock cycle, the result does not reach the R bus. Forcing the instruction to wait an extra two cycles allows the R bus to recieve the result from the unit. Notably, it can be seen that the result reaches the bus after a cycle and a half as seen in the image below.

![Results in R](https://github.com/ZafiroParedes/Simple_DSP/assets/91034132/d55a8069-ba9b-44b7-9245-505f763851a3)
