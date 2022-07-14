## Initial language (.s)
GNU assembler language.

## .p0
Variables a-z (.data segment) of size 1 word.

### Statements:
 - *var* = const
 - *var* = *var* + *var*
 - *var* = *var* - *var*
 - *var* = *var* * *var*
 - *var* = *var* / *var*
 - *var* = *var* % *var*
 - *var* = *var* > *var*
 - *var* = *var* => *var*
 - *var* = *var* < *var*
 - *var* = *var* =< *var*
 - *var* = *var* == *var*
 - *var* = *var* =! *var*
 - *var* = *var* & *var*
 - *var* = *var* | *var*

Support was added for constants in all of the binary expressions.

### I/O:
 - :getchar(*var*)
 - :putchar(*var*)
 - :raw(*constant string*)

*var* is destination/source, always read stdin and write stdout.
cstring is utility function that prints out a string constant.

### Execution flow:
 - :if(*var*){} else{}
 - :while(*var*){}

### Exit
 - :exit(*var*)

### Memory
1st arg variable, 2nd arg index in memory (as if it was an array of words).
 - :load(*var*,*var*)
 - :store(*var*,*var*)

### Functions:
Definition
 - :fun(*name*){}

Call
 - :call(*name*)