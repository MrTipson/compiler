---
title: "Flow control"
date: 2023-02-15
draft: false
weight: 30
---

These 'keywords' were handled similarly to other actual keywords, but would traditionally be handled as separate constructs (in the case of if, while and functions) or as part of expressions (call). 


Letter | Syntax | Functionality
--|--------|--------------
i | :if(*var*){ ... } else { ... } | Conditional execution basaed on *var*
w | :while(*var*){ ... } | Loop execution based on *var*
f | :fun(name){ ... }   | Function
c | :call(name) | Function call

Another thing they (*not including call*) have in common is that they all do something when their respective code block is closed (i.e., 'their' } is reached). In order to resolve which construct it belonged to, the stack was used to store the state and label number. This meant that nesting of **if**, **else** and **while** blocks was possible without much further hassle (okay, **functions** probably as well, but I never tried it).

## Oh right, labels
Not much to say, except for the fact that they were prefixed with L, and suffixed by a label id.

---

Next, we'll take a look at the implementations for each of these keywords, although they are all quite similar.
