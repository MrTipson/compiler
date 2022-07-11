@ https://thinkingeek.com/2013/08/11/arm-assembler-raspberry-pi-chapter-15/
@ TODO: add unsigned support
div:
  push {r2}
  /* r0 contains N */
  /* r1 contains D */
  mov r2, r1             /* r2 ← r0. We keep D in r2 */
  mov r1, r0             /* r1 ← r0. We keep N in r1 */

  mov r0, #0             /* r0 ← 0. Set Q = 0 initially */

  b .Lloop_check
  .Lloop:
      add r0, r0, #1      /* r0 ← r0 + 1. Q = Q + 1 */
      sub r1, r1, r2      /* r1 ← r1 - r2 */
  .Lloop_check:
      cmp r1, r2          /* compute r1 - r2 */
      bhs .Lloop            /* branch if r1 >= r2 (C=0 or Z=1) */

  /* r0 already contains Q */
  /* r1 already contains R */
  pop {r2}
  bx lr
