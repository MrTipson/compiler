ifndef NOCOLOR
GREEN = '\033[32m'
RED = '\033[31m'
CLEAR = '\033[0m'
else
GREEN = ''
RED = ''
CLEAR = ''
endif

all-tests = $(notdir $(basename $(wildcard test/src/*)))
blacklist = inout server files

.SILENT: $(addprefix bin/test/,  $(all-tests))
.phony: test
test: testdir | $(addprefix test/, $(filter-out $(blacklist), $(all-tests)))
	@echo "All tests passed"

.phony: test/%
test/%: FILE = $(notdir $@)
test/%: test/src/%.p1 bin/test/%
	@echo "" | bin/test/$(FILE) | cmp -s test/out/$(FILE).out - \
		&& printf "%15s %b%s%b\n" $(FILE) $(GREEN) "PASS" $(CLEAR)\
		|| printf "%15s %b%s%b\n" $(FILE) $(RED) "FAIL" $(CLEAR)

testdir:
	mkdir -p bin/test

.PRECIOUS: bin/test/%
% : test/src/%.p1 bin/test/%
	bin/test/$@

bin/test/% : test/src/%.p1 all
	bin/p1 < $< > $@.s
	as -mcpu=$(CPU) -mfpu=$(FPU) -o $@.o $@.s
	ld -o $@ $@.o bin/unistd.o bin/stdio.o bin/stdlib.o

sort: test/insertionsort.s test/insertionsort.p0 test/insertionsort.p1 all
	bin/p1 < test/insertionsort.p1 > bin/insertionsort_p1.s
	as -mcpu=$(CPU) -mfpu=$(FPU) -o bin/insertionsort_p1.o bin/insertionsort_p1.s
	ld -o bin/insertionsort_p1 bin/insertionsort_p1.o bin/stdio.o bin/stdlib.o bin/unistd.o

	bin/p0 < test/insertionsort.p0 > bin/insertionsort_p0.s
	as -mcpu=$(CPU) -mfpu=$(FPU) -o bin/insertionsort_p0.o bin/insertionsort_p0.s
	ld -o bin/insertionsort_p0 bin/insertionsort_p0.o

	as -mcpu=$(CPU) -mfpu=$(FPU) -o bin/insertionsort_asm.o test/insertionsort.s
	ld -o bin/insertionsort_asm bin/insertionsort_asm.o