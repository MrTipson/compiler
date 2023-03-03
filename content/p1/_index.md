---
title: "p1 language compiler"
date: 2023-02-17
draft: false
weight: 30
---

The goal with the *p1* language was to create a simple statically typed language, which would contain the core constructs we have been accustomed to in programming:
- local, global variables
- function parameters and return values
- types and type checking
- custom data types (structs)
- complex expressions with priority
- multi file 'support'
- (syscalls)

Of course, it is the compiler's job to implement these, which will be done in multiple passes:
- lexical analysis (tokenization)
- syntax analysis
- semantic analysis (type checking)
- memory
- code generation