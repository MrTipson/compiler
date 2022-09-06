.syntax unified

.text
.align  2
.global _start

.include "src/basicio.s"

_start:
	bl		readint		@ result in r0
	ldr		r1,=length
	str		r0,[r1]
	mov		r2,#0		@ loop counter
	mov		r3,r0		@ loop end
	ldr		r4,=array	@ load array address
readarr_cond:
	cmp		r2,r3
	bge		readarr_end @ counter >= end -> jump to loop end
	bl		readint		@ result in r0
	str		r0,[r4, r2, LSL #2]	@ store result in array with offset counter * 4
	add		r2,r2,#1
	b		readarr_cond
readarr_end:
	ldr		r1,=beforestr		@ "Before: "
	ldr		r2,=beforestr_len
	bl		write
	bl		printarr
	bl		insertionsort
	ldr		r1,=afterstr		@ "\nAfter: "
	ldr		r2,=afterstr_len
	bl		write
	bl		printarr
	mov		r0,#0
	bl		exit

@ r4 already contains array address
.global insertionsort
insertionsort:
	push	{r0,r1,r2,r3}
	mov		r0,#0
	ldr		r3,=length
	ldr		r3,[r3]
	sub		r3,r3,#1
sort_cond:
	cmp		r0,r3
	bge		sort_end
	@ load neighboring elements
	add		r1,r0,#1
	ldr		r2,[r4, r1, LSL #2]			@ next element
	ldr		r1,[r4, r0, LSL #2]			@ element at counter
	cmp		r1,r2
	bgt		swap
@ no swap
	add		r0,r0,1
	b		swap_end
swap:
	str		r2,[r4, r0, LSL #2]		@ neighboring elements
	add		r2,r0,#1
	str		r1,[r4, r2, LSL #2]		@ store swapped
	mov		r1,#0
	cmp		r0,r1
	subgt	r0,r0,#1		@ decrement array if i > 0
swap_end:
	b		sort_cond
sort_end:
	pop		{r0,r1,r2,r3}
	bx		lr

readint:
	push	{r1,r2,r3,lr}
	mov		r1,1		@ sign
	mov		r3,0		@ number
skipdelims:
	bl		getchar
	cmp		r0,#10		@ \n
	beq		skipdelims
	cmp		r0,#32		@ ' '
	beq		skipdelims
	cmp		r0,#44		@ ,
	beq		skipdelims
@ end of skipping delims
	cmp		r0,#45		@ -
	bne		readint_cond
	sub		r1,r1,#2	@ 1 - 2 = -1
	bl		getchar
readint_cond:
	cmp		r0,#48		@ 0
	blt		readint_end
	cmp		r0,#57		@ 9
	bgt		readint_end
	mov		r2,#10
	mul		r3,r3,r2
	add		r3,r3,r0
	sub		r3,r3,#48	@ '0'
	bl		getchar
	b		readint_cond
readint_end:
	mul		r0,r3,r1
	pop		{r1,r2,r3,lr}
	bx		lr

putint:
	push	{r1,r2,r3,lr}
	cmp		r0,#0
	bgt		endminus
	mov		r2,#-1
	mul		r0,r0,r2
	mov		r2,r0
	mov		r0,#45
	bl		putchar
	mov		r0,r2
endminus:
	mov		r2,#0
putint_div:
	mov		r1,#10		@ divisor
	sdiv	r3,r0,r1
	mul		r1,r1,r3
	sub		r1,r0,r1
	mov		r0,r3
	cmp		r0,#0
	beq		putint_unroll
	add		r2,r2,#1	@ counter
	push	{r1}
	b		putint_div
putint_unroll:
	push	{r1}
	ldr		r3,=cbuf
putint_unroll_loop:
	pop		{r1}
	add		r1,r1,#48	@ offset remainder by ascii 0
	mov		r0,r1
	bl		putchar
	sub		r2,r2,#1
	cmp		r2,#0
	bge		putint_unroll_loop
	pop		{r1,r2,r3,lr}
	bx		lr

@ r4 already contains array address
printarr:
	push	{r0,r1,r2,r5,r6,lr}
	mov		r5,#0
	ldr		r6,=length
	ldr		r6,[r6]
printarr_cond:
	cmp 	r5,r6
	bge		printarr_end
	ldr		r0,[r4, r5, LSL #2]
	bl		putint
	add		r5,r5,1
	ldr		r1,=colonstr
	ldr		r2,=colonstr_len
	bl		write
	b		printarr_cond
printarr_end:
	pop		{r0,r1,r2,r5,r6,lr}
	bx		lr

write:
	mov	r7,#4		@ write syscall
	mov	r0,#1		@ stdout
	@ r1, r2 should have args
	svc	0			@ syscall handler
	bx	lr

.data
cbuf: .byte 0,0
beforestr: .ascii "Before: "
beforestr_len = .-beforestr
afterstr: .ascii "\nAfter: "
afterstr_len = .-afterstr
colonstr: .ascii ", "
colonstr_len = .-colonstr
array: .space 400
length: .word 0
