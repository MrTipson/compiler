---
title: "Memory"
date: 2023-02-15
draft: false
weight: 20
---

Its worth to talk about how memory is handled in this very primitive language.

First of all, available variables are predetermined (from **a**..**z**), and they are all stored in the data segment. When used, their address is loaded using labels.

For example **d = 1** (setting a variable) is compiled into:
{{< highlight armasm >}}
    mov	r0,#1       @ set reg0 to 1
	ldr	r1,=d       @ load address of d in reg1
	str	r0,[r1]     @ store reg0 at address reg1
{{< /highlight >}}

Perhaps a bit more interesting is the way the language enables more general memory access. The program's available memory is represented by a linear array of constant size (which is set by the compiler). Access to it is provided using the following keywords:

Letter | Syntax | Functionality
--|--------|--------------
l | :load(*var1*,*var2*) | Load value from memory array at index *var2* into variable *var1*
s | :store(*var1*,*var2*) | Store value to memory array at index *var2* from variable *var1*

For example, **:load(a,b)** would be compiled as:
{{< highlight armasm >}}
    ldr	r0,=b       @ load address of b in reg0
	ldr	r0,[r0]     @ load value of b
	ldr r1,=a       @ load address of a in reg1
    ldr r2,=mem     @ load start of memory array
    @ load value at address mem+4*b
    @ (r2 + (r0 << 2))
    ldr r0,[r2, r0, LSL #2]
    str r0,[r1]     @ store value to variable a
{{< /highlight >}}

Both variables and array elements are 4 bytes wide.