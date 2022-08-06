.global Fmalloc
Fmalloc:
	ldr r4,=brk
	ldr r5,[r4]
	cmp r5,#-1
	bne malloc
	mov r0,#0
	mov	r7,#45 @ brk
	svc	0
	str	r0,[r4]
malloc:
	ldr	r5,[r4]
	ldr	r0,[sp]
	add	r0,r0,r5
	str r0,[r4]
	mov	r7,#45
	svc	0
	add	sp,sp,#4
	mov	r0,r5
	bx	lr

.data
brk: .word -1
