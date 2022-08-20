## Bootstrapped compiler using only assembly
This repository contains everything necessary to bootstrap a compiler for a C-like language on an arm32 system running GNU/Linux.

### Getting started
```
git clone https://github.com/MrTipson/compiler.git
cd compiler
make p1
```

### Running a program
Compiling .p1 programs inside [test/](https://github.com/MrTipson/compiler/tree/master/test) can be done using `make test` and the program name without the extension. Any built files end up in bin/ using the original name and the resulting file extensions.
```sh
make test FILE=helloworld
bin/helloworld
```
Compiling and running arbitrary programs can be done using pipes. Both the p0, and the p1 compiler read from stdin and output to stdout. For p0 compiler errors, check the exit code, while p1 writes to stderr before exiting.
```sh
# make sure p0 or p1 is built ('make p0' or 'make p1')
bin/p1 < myprogram.p1 > myprogram.s
as -o myprogram.o myprogram.s
ld -o myprogram myprogram.o
# if you'd like to link syscalls (bin/unistd.o), malloc (bin/stdlib.o) or stdio (bin/stdio.o),
# add them to the ld arguments (and don't forget to build them - 'make stdlib stdio unistd').
# 'make test' links all of them automatically.
```

### Overview
The [initial compiler](src/prev.s) is written using assembly. It defines the language p0, with which a [new compiler](src/prev.p0) is bootstrapped. The definitions for [p0](docs/helper.md) and [p1](docs/target.md) are also available in the [docs](docs/).

### Troubleshooting
Everything here was coded on a Raspberry pi 2B. If you have a different model, make sure to change the CPU and FPU variables in the makefile. Identifiers for some of the other Raspberry models have been posted on [stackoverflow](https://stackoverflow.com/a/64689072), but i've copied the table here for ease of access. A more comprehensive list of ARM-based systems is available in this [github gist](https://gist.github.com/fm4dd/c663217935dc17f0fc73c9c81b0aa845).
| Raspberry Pi        | .cpu             | .fpu             |
|---------------------|------------------|------------------|
| Zero, 1 A+, 1 B+    | arm1176jzf-s     | vfp              |
| 2 B                 | cortex-a7        | neon-vfpv4       |
| 3 B                 | cortex-a53       | neon-fp-armv8    |
| 4 B                 | cortex-a72       | neon-fp-armv8    |
