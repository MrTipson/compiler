---
title: "Input/Output"
date: 2023-02-15
draft: false
weight: 10
---

The keywords in this category do not require any extraordinary treatment - for the most part, it is merely loading an address (either of a variable or the string literal in the data segment), and using that (along with some constants) to invoke a syscall.

Letter | Syntax | Functionality
--|--------|--------------
g | :getchar(*var*) | Read a character from **stdin** into *var*
p | :putchar(*var*) | Print a character from *var* to **stdout**
u | :uchar(*var*)   | Print a character from *var* to **stderr**
r | :raw(*string literal*) | Print a string to **stdout**
t | :throw(*string literal*) | Print a string to **stderr**
e | :exit(*var*) | Stop execution with status code from *var*

For example, **:raw("Hello world")** would get compiled into:
{{< highlight armasm >}}
    mov r7,#4       @ Syscall (write)
    mov r0,#1       @ File descriptor (stdout)
    ldr r1,=s0      @ String address
    ldr r2,=slen0   @ String length
    svc 0           @ Invoke syscall

@ somewhere down the line
.data
s0: .ascii "Hello world"
slen0 = .-s0
{{< /highlight >}}
> Note: the highlighting in the last row is wrong, but the code is correct