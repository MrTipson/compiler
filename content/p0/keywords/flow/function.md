---
title: "Function"
date: 2023-02-16
draft: false
weight: 30
---

Functions are also quite simple (since the language does not allow arguments). For example, **:fun(main){** would compile into:

{{< highlight armasm >}}
Fmain:          @ functions are prefixed with F
    push {lr}   @ save return address onto stack
{{< /highlight >}}

The compiler also pushes -1 (there is no label id) and state onto the stack.

---

### Function calls
Since there are no arguments to take care of, function calls are just translated to their assembly equivalent.
{{< highlight armasm >}}
    bl  Fmain   @ call main function
{{< /highlight >}}