Collect all global labels (global variables, strings) and write them to memory. Calculate offsets for parameters (function, struct) and local variables (function).

## Strings
Overwrite line no. (tokenization +3) with string id. Strings will be null terminated.

## Variables, Parameters (structs and functions)
Offset is saved in last slot of syntax tokens (syntax +3). Variables (function parameters included) have negative offset, struct parameters have positive. Struct size (when calculated) gets written into offset +3.

## Activation record
```|			|
|previous f.|
|-----------| <- FP
|parameter 0|
|    ...    |
|parameter n|
|local var.0|
|    ...    |
|local var.n|
|   old fp  |
|return addr|
|-----------|
|  next f.	| <- SP
```
Function size gets written into offset +2 of function end block.