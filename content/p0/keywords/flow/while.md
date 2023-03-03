---
title: "While"
date: 2023-02-16
draft: false
weight: 20
---

Since while does not differentiate much from if, the description shall be quite brief.

**:while(c) {**, would be compiled into:

{{< highlight armasm >}}
Lloop0:
    ldr r0,=c       @ load address of c
    ldr r0,[r0]     @ load value of c
    cmp r0,#0       @ check if c == 0
    beq Lloop_end0  @ if loop condition is false, jump to end
{{< /highlight >}}

In this case, we can notice the inclusion of the `Lloop` label, allowing the code to jump back at the end of the code block. Also, the loop condition is checked before any statements, as the variable is encountered before the loop body.

As before, the compiler also pushes label id and state, to indicate that its currently inside a while block.