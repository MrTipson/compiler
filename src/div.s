@ https://thinkingeek.com/2013/08/11/arm-assembler-raspberry-pi-chapter-15/
@ TODO: add unsigned support
div:
    clz  r3, r0                /* r3 ← CLZ(r0) Count leading zeroes of N */
    clz  r2, r1                /* r2 ← CLZ(r1) Count leading zeroes of D */
    sub  r3, r2, r3            /* r3 ← r2 - r3. 
                                 This is the difference of zeroes
                                 between D and N. 
                                 Note that N >= D implies CLZ(N) <= CLZ(D)*/
    add r3, r3, #1             /* Loop below needs an extra iteration count */

    mov r2, #0                 /* r2 ← 0 */
    b .Lloop_check4
    .Lloop4:
      cmp r0, r1, lsl r3       /* Compute r0 - (r1 << r3) and update cpsr */
      adc r2, r2, r2           /* r2 ← r2 + r2 + C.
                                  Note that if r0 >= (r1 << r3) then C=1, C=0 otherwise */
      subcs r0, r0, r1, lsl r3 /* r0 ← r0 - (r1 << r3) if C = 1 (this is, only if r0 >= (r1 << r3) ) */
    .Lloop_check4:
      subs r3, r3, #1          /* r3 ← r3 - 1 */
      bpl .Lloop4              /* if r3 >= 0 (N=0) then branch to .Lloop1 */

    mov r0, r2
    bx lr
