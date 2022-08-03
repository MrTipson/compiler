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

bin/unistd.o: src/unistd.s
	as -o bin/unistd.o src/unistd.s

bin/stdio.o: src/stdio.p1
	bin/p1 < src/stdio.p1 > bin/stdio.s
	as -o bin/stdio.o bin/stdio.s

bin/$(FILE).s: test/$(FILE).p1 bin/p1
	bin/p1 < test/$(FILE).p1 > bin/$(FILE).s

test bin/$(FILE) bin/$(FILE).o:  bin/p1 bin/unistd.o bin/$(FILE).s bin/stdio.o
	as -o bin/$(FILE).o bin/$(FILE).s
	ld -o bin/$(FILE) bin/$(FILE).o bin/unistd.o bin/stdio.o

.phony: clean
clean:
	rm -vf $(filter-out .gitignore, $(wildcard bin/*))
