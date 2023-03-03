---
title: "The plan"
date: 2023-02-14
draft: false
weight: 30
---

The goal of this project was to create a compiler for a C-like language, from scratch. But of course, I never intended to write the entire thing in assembly.

My plan was to create a simple language (called *p0*) and use it to create a compiler for my C-like language (called *p1*). In compiler development, this process is called **bootstrapping**.

> In computer science, bootstrapping is the technique for producing a self-compiling compiler — that is, a compiler (or assembler) written in the source programming language that it intends to compile. An initial core version of the compiler (the bootstrap compiler) is generated in a different language (which could be assembly language); successive expanded versions of the compiler are developed using this minimal subset of the language. The problem of compiling a self-compiling compiler has been called the chicken-or-egg problem in compiler design, and bootstrapping is a solution to this problem. 
>
> *Definition from [the free dictionary](https://encyclopedia.thefreedictionary.com/Bootstrapping+(compilers))*.

So the compilers that will be written are:
- *p0* -> *assembly*, written in assembly
- *p1* -> *assembly*, written in *p0*

Going by the definition, we would have to implement:
- *p1* -> *assembly*, written in *p1*

as well, but as the language *p1* was not intended as the last iteration, it wasnt included in the scope of this journey. Also, in my case, *p0* was not a subset of *p1*.