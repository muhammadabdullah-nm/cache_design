# Cache Design
 
A parameterizable **CPU cache controller** written in **SystemVerilog**. It sits between a processor and main memory, serving repeated accesses from fast on-chip storage and falling back to memory on a miss.
 
## Features
 
- Parameterizable cache size, block (line) size, and associativity
- Tag, valid, and (if used) dirty bit storage per cache line
- Hit/miss detection with a finite state machine (FSM) controlling the miss handling
- Configurable write policy (write-through or write-back)
- Replacement policy for set-associative configurations (for example LRU)
- Simulation testbench in the `tb` folder

## Author
 
**Muhammad Abdullah**: [GitHub](https://github.com/muhammadabdullah-nm)
