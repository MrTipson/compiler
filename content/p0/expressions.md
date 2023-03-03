---
title: "Expressions"
date: 2023-02-16
draft: false
weight: 30
---

Expressions in the language are constrained to be as basic as possible, meaning that only simple binops were allowed, without nesting.

Expressions all have to be in the form of assignments:
- *y* = *x*
- *y* = *x1* **op** *x2*

where *y* must be a variable and *x* can be either a variable or a constant. **op** can be one of **+**, **-**, **\***, **/**, **%**, **>**, **=>**, **<**, **=<**, **==**, **=!**, **&** or **|**.

The only notable thing about the operators is the fact that **=<**, **=>** and **=!** start with **=** to simplify some parsing logic.

Operators are compiled such that *r0* is the destination register, and operands are in *r0* and *r1*. The compiler just has to populate the registers with variable values beforehand (and store the destination register into the appropriate variable afterwards).