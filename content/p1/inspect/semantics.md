---
title: "Semantic analysis"
date: 2023-03-01
draft: false
weight: 40
---

Since now we have a better understanding of how the memory entries are laid out, we can look more closely how type and name resolution is handled.

### Type resolution
The main task of type resolution is to check and enforce the type constraints of operators, assignments and function calls.

Since all subexpressions appear before the expression that uses them, we can resolve types by moving linearly through the memory from syntax phase and update the expression entries as we go.

Inspecting the memory again after the semantic phase will show us the resolved types:

{{< highlight bash >}}
(gdb) xmem
# only part of the response is shown
...
332:    1    0    0    0    0       # type(0=int)
337:    2   23  204    0  417       # expression(const,204=value,417=type)
342:    2   23  212    0  423       # expression(const,212=value,423=type)
347:    2   23  220    0  429       # expression(const,220=value,429=type)
352:    2    7  342  347  429       # expression(*binop,342=expr1,347=expr2,429=type)
357:    2   10  337  352  417       # expression(+binop,337=expr1,352=expr2,417=type)
362:    0  332  357  196   -1       # declaration(332=type,357=initializer,196=identifier)
...
{{< /highlight >}}

We can see that the 5th column of expressions now contains information about their type. If we examine the memory at those locations (expression types have the same format as syntax types), we can see the following:

{{< highlight bash >}}
(gdb) x/5dw ((int*)&mem + 417)
0x41c8e:	1	0	0	0
0x41c9e:	362
(gdb) x/5dw ((int*)&mem + 423)
0x41ca6:	1	0	0	1
0x41cb6:	0
(gdb) x/5dw ((int*)&mem + 429)
0x41cbe:	1	0	0	0
0x41cce:	0
{{< /highlight >}}

At first, this might seem confusing, since the entries can contain uninitialised fields, but the important part is that they are type entries(1) of type int (0).

### Name resolution

During name resolution, the following entries are updated:
- identifier expressions (variable use)
- named types (structs)
- function calls

A pointer to the corresponding declaration is added (or replaces their *identifier* field), or an error is raised if no such declaration was found.

{{< highlight bash >}}
272:    1    3    0    0    0       # type(void)
277:    3  272  120    2  317       # function(type=272,identifier=120,start,type=317)
... 
362:    0  332  357  196   -1       # declaration(type=332,initializer=357,identifier=196) 
367:   10    0  277    0    0       # call(start,function=277)
372:    2   23  236    0  441       # expression(const,value=236,type=441)
377:   11  372    0    0    0       # argument(expression=372)
382:    2   22  244  362  332       # expression(variable,identifier=244,declaration=362,type=332)
387:   11  382    0    0    0       # argument(expression=382)
392:    2   23  252    0  448       # expression(const,value=252,type=448)
397:   11  392    0    0    0       # argument(expression=392)
402:   10    1    0  367  272       # call(end,start=367,type=272)
...
{{< /highlight >}}

On the example above, we can see that the call entry at offset **367** points to the function declaration at **277** (printf), and that the expression at **382** points at the variable declaration at **362**.