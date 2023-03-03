---
title: "Inspecting compiler behaviour"
date: 2023-02-28
draft: false
weight: 60
---

In this section, we'll take a look at how we can take examine the compiler during runtime to better understand how it works. To do this, I'll be using the following example program:

{{< highlight c >}}
void printf(char* fmt, int arg1, int arg2);

void main() {
	int x = 5 + 10 * 2;
	printf("Result is: %d\n", x, 0);
}
{{< /highlight >}}

First, lets check that the compiler is working:
{{< highlight bash >}}
make test
# Result: 25
{{< /highlight >}}

To inspect the compiler memory, we'll use **gdb**. We can insert a breakpoint at any point in **prev.p0** by calling the break function (`:call(break)`). I'll be adding a breakpoint after each described phase, and also just before the compiler exits. In gdb, we can then pipe in the our example, and setup the breakpoints:

{{< highlight bash >}}
gdb bin/p1

# b is short for breakpoint
(gdb) b Fbreak

(gdb) run < test/test.p1
# there may be other breakpoints in the program, so using c (continue) will skip until the next breakpoint
{{< /highlight >}}

A quick reminder of the memory array and how it was used in the *p1* compiler:
- the memory array starts at the label *mem*
- all memory accesses are done using offsets
- each memory cell is 4 bytes wide (integers)
- the compiler reads the input file into memory from offset **0** to offset **b**
- tokenization phase is from **b** to **e**
- syntax phase is from **e** to **g**
- semantic phase is from **g** to **h** (although the memory is only used temporarily for name resolving, global declarations will remain)
- memory phase is from **h** to **j** (global variables and string literals)