.syntax unified         @ modern syntax

@ Program code
.text
.align  1

.global Fexit
Fexit:
	ldr	r0,[sp],#4
	mov	r7,#1
	svc	0
	bx	lr

.global Ffork
Ffork:
	mov	r7,#2
	svc	0
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

.global Fwrite
Fwrite:
	ldr	r0,[sp,#8]
	ldr	r1,[sp,#4]
	ldr	r2,[sp,#0]
	mov	r7,#4
	svc	0
	add	sp,sp,#12
	bx	lr

.global Fopen
Fopen:
	ldr	r0,[sp,#8]
	ldr	r1,[sp,#4]
	ldr	r2,[sp,#0]
	mov	r7,#5
	svc	0
	add	sp,sp,#12
	bx	lr

.global Fclose
Fclose:
	ldr	r0,[sp],#4
	mov	r7,#6
	svc	0
	bx	lr

.global Fwaitid
Fwaitid:
	ldr	r0,[sp,#12]
	ldr	r1,[sp,#8]
	ldr	r2,[sp,#4]
	ldr	r3,[sp,#0]
	mov	r7,#280
	svc	0
	add	sp,sp,#16
	bx	lr

.global Fsocket
Fsocket:
	ldr	r0,[sp,#8]
	ldr	r1,[sp,#4]
	ldr	r2,[sp,#0]
	mov	r7,#281
	svc	0
	add	sp,sp,#12
	bx	lr

.global Fbind
Fbind:
	ldr	r0,[sp,#8]
	ldr	r1,[sp,#4]
	ldr	r2,[sp,#0]
	mov	r7,#282
	svc	0
	add	sp,sp,#12
	bx	lr

.global Flisten
Flisten:
	ldr	r0,[sp,#4]
	ldr	r1,[sp,#0]
	mov	r7,#284
	svc	0
	add	sp,sp,#8
	bx	lr

.global Faccept
Faccept:
	ldr	r0,[sp,#8]
	ldr	r1,[sp,#4]
	ldr	r2,[sp,#0]
	mov	r7,#285
	svc	0
	add	sp,sp,#12
	bx	lr

.global Fsend
Fsend:
	ldr	r0,[sp,#12]
	ldr	r1,[sp,#8]
	ldr	r2,[sp,#4]
	ldr	r3,[sp,#0]
	mov	r7,#289
	svc	0
	add	sp,sp,#16
	bx	lr

.global Frecv
Frecv:
	ldr	r0,[sp,#12]
	ldr	r1,[sp,#8]
	ldr	r2,[sp,#4]
	ldr	r3,[sp,#0]
	mov	r7,#291
	svc	0
	add	sp,sp,#16
	bx	lr
