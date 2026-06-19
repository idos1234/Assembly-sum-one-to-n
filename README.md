# Sum 1 to N - x86 Assembly Project

A modular 32-bit x86 Assembly application that calculates the sum of all numbers from 1 to a user-defined number N. The program safely takes user input, converts it from a string to an integer, performs the iterative addition loop, and prints the final result back to the screen. It is built using standard `cdecl` calling conventions, demonstrating safe register handling and manual stack frame management.

## How to Run

1. Assemble the files:
   ```bash
   nasm -f elf32 main.asm -o main.o
