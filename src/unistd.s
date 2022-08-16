.syntax unified         @ modern syntax

@ Program code
.text
.align  1

.global Fwrite
Fwrite:
	ldr	r0,[sp,#8]
	ldr	r1,[sp,#4]
	ldr	r2,[sp,#0]
	mov	r7,#4
	svc	0
	add	sp,sp,#12
	bx	lr

.global Fread
Fread:
	ldr	r0,[sp,#8]
	ldr	r1,[sp,#4]
	ldr	r2,[sp,#0]
	mov	r7,#3
	svc	0
	add	sp,sp,#12
	bx	lr
