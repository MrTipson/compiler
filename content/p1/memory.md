---
title: "Memory"
date: 2023-02-24
draft: false
weight: 40
---

### Purpose
This phase handles:
- collecting global variables
- assigning ids to strings
- determining sizes of types
- calculating offsets for function parameters
- calculating offsets for struct components
- calculating offsets for local variables
- calculating size of activation record (parameters + local variables + return address + frame pointer)

---

### Activation record
```
|previous f.| <- FP
|parameter 0|
|    ...    |
|parameter n|
|local var.0|
|    ...    |
|local var.n|
|   old fp  |
|return addr| <- SP
```
> local variables can be of any size (1-4 bytes) and will not take up uniform space in the activation record

---

### Type sizes
- **char**, **bool** and **void** take up *1 byte*
- **int** and **ptr** take up *4 bytes*
- **arrays** take up *(length \* base type size) bytes*
- **structs** are as big as the sum of their components

Void taking up 1 byte is intentional, in order to allow incrementing **void\*** (adding/subtracting ints from pointers moves the pointer by the size of its basetype, which would be 1 byte in this case).
