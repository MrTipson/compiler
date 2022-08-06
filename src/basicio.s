exit:
	mov	r7,#1		@ syscall code
	svc	0
	bx	lr

getchar:
	push	{r1,r2,r7,lr}
	mov	r7,#3		@ read syscall code
	mov	r0,#0		@ fd 0
	ldr	r1,=cbuf	@ char buffer
	mov	r2,#1		@ count
	strb	r0,[r1]
	svc	0
	ldrb	r0,[r1]		@ load read character
	pop	{r1,r2,r7,lr}
	bx	lr

putchar:
	push	{r1,r2,r7,lr}
	ldr	r1,=cbuf	@ char buffer
	strb	r0,[r1]	@ store arg to buffer
	mov	r7,#4		@ write syscall code
	mov	r0,#1		@ fd 1
	mov	r2,#1		@ count
	svc	0
	pop	{r1,r2,r7,lr}
	bx	lr

throwchar:
	push	{r1,r2,r7,lr}
	ldr	r1,=cbuf	@ char buffer
	strb	r0,[r1]	@ store arg to buffer
	mov	r7,#4		@ write syscall code
	mov	r0,#2		@ fd 2
	mov	r2,#1		@ count
	svc	0
	pop	{r1,r2,r7,lr}
	bx	lr

