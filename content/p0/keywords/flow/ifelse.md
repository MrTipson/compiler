---
title: "If/Else"
date: 2023-02-15
draft: false
weight: 10
---

Conditional statements are implemented in the form of `:if(var){ ... }` and `:if(var){ ... } else { ... }`. Both variations start the same way, so if we take for example **:if(c) {**, it would be compiled into:

{{< highlight armasm >}}
    ldr r0,=c       @ load address of c
    ldr r0,[r0]     @ load value of c
    cmp r0,#0       @ check if c == 0
    beq Lneg0       @ if so, jump to the negative label
    @ if c != 0 (condition is true) no jump happens and the program continues execution below (positive branch)
    @ ...
{{< /highlight >}}
> In this example, the label id is assumed to be 0

At the same time, the compiler pushes the label id and state onto stack, indicating that it is currently inside an if block.

Its worth noting that this way of implementing (positive branch follows check, negative is jumped to) is not by chance. It is done to keep the same order as in the *p0* code (cond, positive branch, negative branch), allowing all following statements to be directly compiled as well.

---

The cases of `} else {` and `}` are covered in the [code block endings]({{< relref codeblocks.md >}}).