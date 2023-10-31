#!/bin/bash
FILE_NAME="slicing.elf"
OPTIM=0

riscv-none-elf-objdump -d ${FILE_NAME} > record/op1_objdump_O${OPTIM}.txt
riscv-none-elf-readelf -h ${FILE_NAME} > record/op1_objreadelf_O${OPTIM}.txt
riscv-none-elf-size ${FILE_NAME} > record/op1_size_O${OPTIM}.txt
rv32emu/build/rv32emu ${FILE_NAME}
