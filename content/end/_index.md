---
title: "Running"
date: 2023-03-03
draft: false
weight: 50
---

### Prerequisites
The compilers use GNU's assembler (*as*) and linker (*ld*) to transform generated assembly instructions into executables. For ease of use, the *Makefile* may also be used.

Testing was done on a *Raspberry pi 2B*, but you may change the target CPU (or FPU) in the Makefile. Both (*bootstrap* and *p1*) compilers generate ARM32 instructions.

### Running the bootstrap compiler
Input/output is done using *stdin*/*stdout*, for which you can use pipes. For example:
{{< highlight bash >}}
bin/p0 < src/prev.p0 > bin/p1.s
as -mcpu=$(CPU) -mfpu=$(FPU) -o bin/p1.o bin/p1.s
ld -o bin/p1 bin/p1.o
{{< /highlight >}}

### Running the p1 compiler
While the *p1* compiler can be used the same way as the *bootstrap* compiler, using it with the *Makefile* is easier.

For files in the **test** directory, you can use `make <name>` to compile and run the file automatically. For example:
{{< highlight bash >}}
make helloworld     # for file test/helloworld.p1
{{< /highlight >}}

The file generated is located in the **bin** directory, keeping the same name (for example, `bin/helloworld`).

> To just compile a file (without running it), you can use `make bin/<name>`.