# Makefile
all: p0

p0: bin/p0

bin/p0: bin/p0.o
	ld -o $@ $+

bin/p0.o : src/prev.p0
	as -o $@ $<

clean:
	rm -vf $(filter-out .gitignore, $(wildcard bin/*))
