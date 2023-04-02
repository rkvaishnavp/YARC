# YARC - Yet Another RISC-V Core

My very first RISC-V core

## Version-1

This version has both memory and core inside the same module.\
It has word addressable memory.\
This core does not support Syscall and Fence Instructions.

## Version-2

This version is same as Version-1 but has byte addressable memory.\
This core does not support Syscall and Fence Instructions.

## Version-3

In This Version 5-Stages have been implementated without Data and Control Hazard Units.
This version should be run using nop(No Operation).
Below is Block Diagram of Version-3

![alt text](https://github.com/itsmerkvp/riscv-core/blob/main/Pipelined/old_core/draw.io/riscv_5_stage.jpg?raw=true)

## **yet to be Done**
### Version-4

Updated Version 3 with Data and Control Hazard Units. (There will be no need for a nop here)

#### Upcoming Versions

Core will be updated to support AXI4-Lite and **may be** updated to Von-Neumann Architecture(Data and Instruction Memory in One Module)
