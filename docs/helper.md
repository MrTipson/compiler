## Description of helper language (.p0)
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
 - :uchar(*var*) - putchar for stderr
 - :raw(*constant string*)
 - :throw(*constant string*) - raw for stderr

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

### Parsing
: is at the beginning of all special functions, after which only the first character is checked (:call and :c behave the same).

### Syntax weirdness
Don't add extra spaces/characters inside keyword calls. Don't write an empty if block and an else in the same line. Closing brace and else must also be in the same line. If in doubt, check how its done in [prev.p0](../src/prev.p0). The syntax is not very robust, and that was kind of the point.