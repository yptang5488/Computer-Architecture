.PHONY: clean

include toolchain.mk

ASFLAGS = -march=rv32i -mabi=ilp32
LDFLAGS = --oformat=elf32-littleriscv
CFLAGS = -Wall -O0
OBJS = slicing.o

%.o: %.s
	riscv-none-elf-gcc $(ASFLAGS) -c -o $@ $<

%.o: %.c
	riscv-none-elf-gcc $(ASFLAGS) $(CFLAGS) -c -o $@ $<

all: slicing.o.elf

slicing.elf: $(OBJS)
	riscv-none-elf-gcc -o $@ $^

clean:
	$(RM) $(OBJS) slicing.elf