CPU = cortex-a7
FPU = neon-vfpv4
# Makefile
all: p0

p0: bin/p0
p1:	bin/p1

bin/p0: bin/p0.o
	ld -o $@ $+

bin/p0.o: src/prev.s src/header.s src/basicio.s
	as -mcpu=$(CPU) -mfpu=$(FPU) -o $@ $<

bin/p1.s: bin/p0 src/prev.p0
	bin/p0 < src/prev.p0 > bin/p1.s

bin/p1: bin/p1.s
	as -mcpu=$(CPU) -mfpu=$(FPU) -o bin/p1.o bin/p1.s
	ld -o bin/p1 bin/p1.o

bin/unistd.o: src/unistd.s
	as -mcpu=$(CPU) -mfpu=$(FPU) -o bin/unistd.o src/unistd.s

bin/stdlib.o: src/stdlib.s
	as -mcpu=$(CPU) -mfpu=$(FPU) -o bin/stdlib.o src/stdlib.s

bin/stdio.o: src/stdio.p1
	bin/p1 < src/stdio.p1 > bin/stdio.s
	as -mcpu=$(CPU) -mfpu=$(FPU) -o bin/stdio.o bin/stdio.s

test bin/$(FILE) bin/$(FILE).o:  bin/p1 bin/unistd.o bin/stdio.o bin/stdlib.o
	bin/p1 < test/$(FILE).p1 > bin/$(FILE).s
	as -mcpu=$(CPU) -mfpu=$(FPU) -o bin/$(FILE).o bin/$(FILE).s
	ld -o bin/$(FILE) bin/$(FILE).o bin/unistd.o bin/stdio.o bin/stdlib.o

.phony: clean
clean:
	rm -vf $(filter-out .gitignore, $(wildcard bin/*))
