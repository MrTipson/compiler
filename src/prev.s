.include "src/header.s"

_start:
	bl	main

main:
	ldr	r5,=heap	@ heap pointer
	mov	r6,#0		@ comment flag
	mov	r7,#0		@ label counter (if, while)
	bl	header		@ print out header
	b	_loop1_cond	@ while check cond
_loop1_start:
	cmp	r0,#9		@ tab character
	beq	_loop1_cond
	cmp	r0,#32		@ space character
	beq	_loop1_cond
	cmp	r0,#10		@ line feed
	moveq	r6,#0		@ turn comment mode off
	beq	_loop1_cond
	cmp	r6,#1		@ ? is comment mode on
	beq	_loop1_cond
	cmp	r0,#35		@ # (begin comment)
	moveq	r6,#1
	beq	_loop1_cond
	cmp	r0,#58		@ :
	bleq	special		@ one of special functions (getchar, putchar, if, while, exit)
	blne	assign		@ any of the assign statements
_loop1_cond:
	bl	getchar
	cmp	r0,#0		@ check if we read any characters
	bne	_loop1_start
_loop_1_end:
	bl	dataseg		@ data segment
	mov	r0,#0		@ set return value
	bl	exit		@ call exit function

special:
	push	{r0,r1,r2,r7,lr}
	bl	getchar
	mov	r1,r0		@ save first character of keyword
_loop2:
	bl	getchar
	cmp	r0,#40		@ '('
	bne	_loop2		@ skip all characters between first and (
_special_switch:
	cmp	r1,#103		@ g
	beq	_special_switch_g
	cmp	r1,#112		@ p
	beq	_special_switch_p
	cmp	r1,#99		@ c
	beq	_special_switch_c
	cmp	r1,#105		@ i
	beq	_special_switch_i
	cmp	r1,#119		@ w
	beq	_special_switch_w
	cmp	r1,#101		@ e
	beq	_special_switch_e
	cmp	r1,#108		@ l
	beq	_special_switch_l
	cmp	r1,#115		@ s
	beq	_special_switch_s
@ g(etchar)
_special_switch_g:
	mov	r7,#4		@ write syscall code
	mov	r0,#1		@ fd 1
	ldr	r1,=__getchar_str1 @ char buffer
	ldr	r2,=__getchar_len1 @ count
	svc	0
	bl	getchar		@ var
	bl	putchar
	mov	r7,#4		@ write syscall code
	mov	r0,#1		@ fd 1
	ldr	r1,=__getchar_str2 @ char buffer
	ldr	r2,=__getchar_len2 @ count
	svc	0
	b	_special_switch_end
@ p(utchar)
_special_switch_p:
	mov	r7,#4		@ write syscall code
	mov	r0,#1		@ fd 1
	ldr	r1,=__putchar_str1 @ char buffer
	ldr	r2,=__putchar_len1 @ count
	svc	0
	bl	getchar		@ var
	bl	putchar
	mov	r7,#4		@ write syscall code
	mov	r0,#1		@ fd 1
	ldr	r1,=__putchar_str2 @ char buffer
	ldr	r2,=__putchar_len2 @ count
	svc	0
	b	_special_switch_end
@ c(string)
_special_switch_c:
	bl	getchar
	cmp	r0,#34		@ "
	bne	_special_switch_c @ skip all chars until "
_special_switch_c_loop:
	bl	getchar
	cmp	r0,#34		@ "
	beq	_special_switch_c_loop_end
	str	r0,[r5],#4	@ store char on the heap and increment hp
	cmp	r0,#92		@ \
	bne	_special_switch_c_loop
	bl	getchar
	str	r0,[r5],#4	@ store escaped char and increment hp
	b	_special_switch_c_loop
_special_switch_c_loop_end:
	mov	r0,#0
	strb	r0,[r5],#4	@ null seperated strings
	mov	r7,#4		@ write syscall code
	mov	r0,#1		@ fd 1
	ldr	r1,=__cstring_str1 @ mov r7,#4  mov r0,#1  ldr r1,=s
	ldr	r2,=__cstring_len1 @ count
	svc	0
	ldr	r0,=stringcnt
	ldr	r0,[r0]
	bl	putint		@ write string id
	mov	r0,#1		@ fd 1
	ldr	r1,=__cstring_str2 @ char buffer
	ldr	r2,=__cstring_len2 @ count
	svc	0
	ldr	r0,=stringcnt
	ldr	r0,[r0]
	bl	putint		@ write string id
	mov	r0,#1		@ fd 1
	ldr	r1,=__cstring_str3 @ char buffer
	ldr	r2,=__cstring_len3 @ count
	svc	0
	ldr	r1,=stringcnt
	ldr	r2,[r1]		@ read string count
	add	r2,r2,#1	@ increment string counter
	str	r2,[r1]		@ write back string counter
	b	_special_switch_end
@ i(f)
_special_switch_i:
	b	_special_switch_end
@ w(hile)
_special_switch_w:
	b	_special_switch_end
@ e(xit)
_special_switch_e:
	mov	r7,#4		@ write syscall code
	mov	r0,#1		@ fd 1
	ldr	r1,=__exit_str1 @ char buffer
	ldr	r2,=__exit_len1 @ count
	svc	0
	bl	getchar		@ var
	bl	putchar
	mov	r7,#4		@ write syscall code
	mov	r0,#1		@ fd 1
	ldr	r1,=__exit_str2 @ char buffer
	ldr	r2,=__exit_len2 @ count
	svc	0
	b	_special_switch_end
@ l(oad)
_special_switch_l:
	b	_special_switch_end
@ s(tore)
_special_switch_s:
	b	_special_switch_end
_special_switch_end:
	bl	getchar
	cmp	r0,#0
	beq	_special_endskip
	cmp	r0,#10
	beq	_special_endskip
	b	_special_switch_end
_special_endskip:
	pop	{r0,r1,r2,r7,lr}
	bx	lr

assign:
	push	{lr}
	bl	putchar
	pop	{lr}
	bx	lr

header:
	push	{r0,r1,r2,r7,lr}
	mov	r7,#4		@ write syscall code
	mov	r0,#1		@ fd 1
	ldr	r1,=__header_str @ char buffer
	ldr	r2,=__header_len @ count
	svc	0
	pop	{r0,r1,r2,r7,lr}
	bx	lr

dataseg:
	push	{r0,r1,r2,r3,r4,r7,lr}
@ dataseg header
	mov	r7,#4		@ write syscall code
	mov	r0,#1		@ fd 1
	ldr	r1,=__dataseg_str @ char buffer
	ldr	r2,=__dataseg_len @ count
	svc	0
@ dataseg header end
@ variables
	mov	r3,#97		@ a
	ldr	r4,=cbuf
_dataseg_loop:
	strb	r3,[r4]
	bl	putchar
	mov	r0,#1		@ fd 1
	ldr	r1,=__variable_str @ char buffer
	ldr	r2,=__variable_len @ count
	svc	0
	add	r3,r3,#1
	cmp	r3,#122		@ z
	ble	_dataseg_loop
@ strings (r4 already contains cbuf addr)
	ldr	r2,=stringcnt
	mov	r3,#0		@ string index
	ldr	r2,[r2]		@ string counter
	ldr	r1,=heap	@ start of heap
_dataseg_string_loop:
	cmp	r3,r2
	bge	_dataseg_string_end
	mov	r0,#115		@ s
	strb	r0,[r4]
	bl	putchar
	mov	r0,r3
	bl	putint
	push	{r1,r2}
	mov	r0,#1		@ fd 1
	ldr	r1,=__cstrdata_str1 @ `: .ascii "`
	ldr	r2,=__cstrdata_len1 @ count
	svc	0
	pop	{r1,r2}
_dataseg_str_literal:
	ldr	r0,[r1],#4
	cmp	r0,#0		@ is char null
	beq	_dataseg_str_literal_end
	strb	r0,[r4]
	bl	putchar
	b	_dataseg_str_literal
_dataseg_str_literal_end:
@ close string literal
	push	{r1,r2}		@ save r2 (string count)
	mov	r0,#1		@ fd 1
	ldr	r1,=__cstrdata_str2 @ char buffer
	ldr	r2,=__cstrdata_len2 @ count
	svc	0
	mov	r0,r3
	bl	putint
	mov	r0,#1		@ fd 1
	ldr	r1,=__cstrdata_str3 @ char buffer
	ldr	r2,=__cstrdata_len3 @ count
	svc	0
	mov	r0,r3
	bl	putint
	ldr	r0,=cbuf
	mov	r1,#10		@ \n
	strb	r1,[r0]
	bl	putchar
	pop	{r1,r2}		@ retrieve r2 (string count)
	add	r3,r3,#1	@ increment string index
	b	_dataseg_string_loop
_dataseg_string_end:
@ heap label
	mov	r0,#1		@ fd 1
	ldr	r1,=__heap_str	@ char buffer
	ldr	r2,=__heap_len	@ count
	svc	0
	pop	{r0,r1,r2,r3,r4,r7,lr}
	bx	lr

 @ r0 has arg
putint:
	push	{r1,r2,r3,lr}
	mov	r2,#0
putint_div:
	mov	r1,#10		@ divisor
	bl	div
	cmp	r0,#0
	beq	putint_unroll
	add	r2,r2,#1	@ counter
	push	{r1}
	b	putint_div
putint_unroll:
	push	{r1}
	ldr	r3,=cbuf
putint_unroll_loop:
	pop	{r1}
	add	r1,r1,#48	@ offset remainder by ascii 0
	strb	r1,[r3]
	bl	putchar
	sub	r2,r2,#1
	cmp	r2,#0
	bge	putint_unroll_loop
	pop	{r1,r2,r3,lr}
	bx	lr

.data
cbuf: .byte 0,0
stringcnt: .word 0
__header_str: .ascii ".include \"src/header.s\"\n\n_start:\n\tbl\tmain\n\tbl\texit\n\nmain:\n"
__header_len = .-__header_str
__dataseg_str: .ascii "\n.data\ncbuf: .byte 0,0\n"
__dataseg_len = .-__dataseg_str
__getchar_str1: .ascii "\tbl\tgetchar\n\tldr\tr1,="
__getchar_len1 = .-__getchar_str1
__getchar_str2: .ascii "\n\tstrb\tr0,[r1]\n"
__getchar_len2 = .-__getchar_str2
__putchar_str1: .ascii "\tldr\tr0,="
__putchar_len1 = .-__putchar_str1
__putchar_str2: .ascii "\n\tldr\tr1,=cbuf\n\tldrb\tr0,[r0]\n\tstrb\tr0,[r1]\n\tbl\tputchar\n"
__putchar_len2 = .-__putchar_str2
__cstring_str1: .ascii "\tmov\tr7,#4\n\tmov\tr0,#1\n\tldr\tr1,=s"
__cstring_len1 = .-__cstring_str1
__cstring_str2: .ascii "\n\tldr\tr2,=slen"
__cstring_len2 = .-__cstring_str2
__cstring_str3: .ascii "\n\tsvc\t0\n"
__cstring_len3 = .-__cstring_str3
__cstrdata_str1: .ascii ": .ascii \""
__cstrdata_len1 = .-__cstrdata_str1
__cstrdata_str2: .ascii "\"\nslen"
__cstrdata_len2 = .-__cstrdata_str2
__cstrdata_str3: .ascii " = .-s"
__cstrdata_len3 = .-__cstrdata_str3
__exit_str1: .ascii "\tldr\tr0,="
__exit_len1 = .-__exit_str1
__exit_str2: .ascii "\n\tldrb\tr0,[r0]\n\tbl\texit\n"
__exit_len2 = .-__exit_str2
__variable_str: .ascii ": .word 0\n"
__variable_len = .-__variable_str
__heap_str: .ascii "heap: .word 0\n"
__heap_len = .-__heap_str
heap: .space 4000
