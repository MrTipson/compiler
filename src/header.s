@ Define my Raspberry Pi
.cpu    cortex-a7
.fpu    neon-vfpv4
.syntax unified         @ modern syntax

@ Program code
.text
.align  2
.global _start
.global exit
.global break

.include "src/stdlib.s"
