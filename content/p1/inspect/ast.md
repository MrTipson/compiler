---
title: "Abstract syntax trees?"
date: 2023-03-03
draft: false
weight: 35
---

At the end of the syntax phase, its worth going through how subsequent phases will process the parsed syntax elements. Traditionally, the program would be represented by an abstract syntax tree, and that stil holds to some degree in our case (with some changes to accomodate for the mostly linear memory layout).

**Types**, **declarations**, **expressions**, **expression statements**, **parameters** and **arguments** are represented by tree-like structures (hierarchy of substructures using pointers to connect them). In memory, these trees are saved in post-order notation (both subtrees first, then the root). 

**Functions**, **if/else**, **while**, **call** and **structs** can contain an arbitrary amount of subexpressions/statements, which is why they are saved as start/end pairs. Subsequent phases can use these to maintain and update their current state.