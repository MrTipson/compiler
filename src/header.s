@ Define my Raspberry Pi
.syntax unified         @ modern syntax

@ Program code
.text
.align  2
.global _start
.global exit
.global break

.include "src/stdlib.s"
