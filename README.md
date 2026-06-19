# Modular x86 Assembly Calculator

A modular 32-bit x86 Assembly application that provides a secure interactive menu for the user. It allows the user to choose between three mathematical operations: calculating the factorial of a number, finding the average of two numbers, or computing the sum from 1 to N. The program features custom-built algorithms for converting strings to numbers and vice versa, without relying on external C libraries. It is built using standard `cdecl` calling conventions, demonstrating safe register handling and manual stack frame management.

## How to Run

1. Assemble the files:
   ```bash
   nasm -f elf32 main.asm -o main.o
   nasm -f elf32 factorial.asm -o factorial.o
   nasm -f elf32 average.asm -o average.o
