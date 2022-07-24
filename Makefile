# Makefile
all: p0

p0: bin/p0
p1:	bin/p1

bin/p0: bin/p0.o
	ld -o $@ $+

bin/p0.o: src/prev.s src/header.s src/stdlib.s
	as -o $@ $<

bin/p1.s: bin/p0 src/prev.p0
	bin/p0 < src/prev.p0 > bin/p1.s

bin/p1: bin/p1.s
	as -o bin/p1.o bin/p1.s
	ld -o bin/p1 bin/p1.o

.phony: clean
clean:
	rm -vf $(filter-out .gitignore, $(wildcard bin/*))
