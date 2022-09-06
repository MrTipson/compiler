CPU = cortex-a7
FPU = neon-vfpv4
# Makefile
all: p1 unistd stdlib stdio

p0: bin/p0
p1:	bin/p1
unistd: bin/unistd.o
stdlib: bin/stdlib.o
stdio: bin/stdio.o

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

.phony: clean
clean:
	rm -vf $(filter-out .gitignore, $(wildcard bin/*))

% : test/%.p1 bin/p1 bin/unistd.o bin/stdio.o bin/stdlib.o
	bin/p1 < $< > bin/$@.s
	as -mcpu=$(CPU) -mfpu=$(FPU) -o bin/$@.o bin/$@.s
	ld -o bin/$@ bin/$@.o bin/unistd.o bin/stdio.o bin/stdlib.o

sort: test/insertionsort.s test/insertionsort.p0 test/insertionsort.p1 all
	bin/p1 < test/insertionsort.p1 > bin/insertionsort_p1.s
	as -mcpu=$(CPU) -mfpu=$(FPU) -o bin/insertionsort_p1.o bin/insertionsort_p1.s
	ld -o bin/insertionsort_p1 bin/insertionsort_p1.o bin/stdio.o bin/stdlib.o bin/unistd.o

	bin/p0 < test/insertionsort.p0 > bin/insertionsort_p0.s
	as -mcpu=$(CPU) -mfpu=$(FPU) -o bin/insertionsort_p0.o bin/insertionsort_p0.s
	ld -o bin/insertionsort_p0 bin/insertionsort_p0.o

	as -mcpu=$(CPU) -mfpu=$(FPU) -o bin/insertionsort_asm.o test/insertionsort.s
	ld -o bin/insertionsort_asm bin/insertionsort_asm.o