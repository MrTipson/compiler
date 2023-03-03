---
title: "Code generation"
date: 2023-02-24
draft: false
weight: 50
---

We'll take a look at only some of the more interesting aspects of the implementation, such as:
- expressions/calls
- multi file support

The implemented code generation contains just the basics, with no optimizations and such.

---

### Expressions / Calls
Expression generation was designed in such a way, that register allocation was not necessary, which allows us to go directly from the memory phase into code generation. It can be described with a couple of rules:
- results of expressions (and calls) are left in **r0**
- if an operator needs to evaluate multiple expressions, it calculates the first one, stores the result on the stack, calculates the other one, and combines the results.
- function arguments are pushed to the stack as soon as they are calculated
- function return values are also left in **r0**

---

### Multi file support

The compiler/language does not implement the concept of *header files* (or equivalent), but the source code can still be in multiple files. Function declarations must still be present, and the appropriate implementation must be provided during the linking process.

In order to compile a file that 'exports' some functions, it must not contain a main method, so an entry point will not be generated.