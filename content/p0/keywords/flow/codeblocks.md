---
title: "Code block endings"
date: 2023-02-16
draft: false
weight: 40
---

It is time to take care of code block endings. When the compiler reaches the end of a code block ( **}** ), it must first determine which state its in, which is done by retrieving a label id and state pair from stack.

## If
If the code block belonged to an if statement, the compiler generates the footer for the positive branch:
{{< highlight armasm >}}
    b   Lend0   @ skip negative branch
Lneg0:          @ label for negative branch
{{< /highlight >}}

After that, it determines if there is an else block present. If so, the state is changed to 'else', and pushed back to the stack along with the same label id.

If not, the compiler also generates the end label:
{{< highlight armasm >}}
Lend0:          @ label for end
{{< /highlight >}}

> Label id in these examples is assumed to be 0

## Else
Since else is also a valid state (generated at the end of an if codeblock), it is also handled separately. It generates the same end label as above, but only after the statements for the negative branch have been compiled.

## While
When the end of a while body is encountered, the following code is generated:
{{< highlight armasm >}}
    b   Lloop0      @ loop condition check
Lloop_end0:         @ loop end
{{< /highlight >}}

## Function
When the function ends, the following code is generated:
{{< highlight armasm >}}
    pop {lr}        @ retrieve return address
    bx  lr          @ return from function
.pool               @ generate literal pool
{{< /highlight >}}

The `.pool` directive instructs the GNU assembler to place a literal pool at the specified location. This is needed in arm assembly, because arm32 loads some constants from memory (if a constant is too big to fit as immediate operand - mostly a limitation for the 32bit systems). This ensures that literal pools are *close enough* for most uses, except for very large functions (where you can still get an error).