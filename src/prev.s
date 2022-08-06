.include "src/header.s"
.global _special_switch_i
.global _dataseg_string_loop
_start:
	bl	main

main:
	ldr	r5,=heap	@ heap pointer
	mov	r6,#0		@ comment flag
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
	cmp	r0,#125		@ }
	beq	rcurly
	cmp	r0,#58		@ :
	beq	special		@ one of special functions (getchar, putchar, if, while, exit)
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
	cmp	r1,#114		@ r
	beq	_special_switch_r
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
	cmp	r1,#99		@ c
	beq	_special_switch_c
	cmp	r1,#102		@ f
	beq	_special_switch_f
	cmp	r1,#116		@ t
	beq	_special_switch_t
	cmp	r1,#117		@ u
	beq	_special_switch_u
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
@ u(throwchar)
_special_switch_u:
	mov	r7,#4		@ write syscall code
	mov	r0,#1		@ fd 1
	ldr	r1,=__putchar_str1 @ char buffer
	ldr	r2,=__putchar_len1 @ count
	svc	0
	bl	getchar		@ var
	bl	putchar
	mov	r7,#4		@ write syscall code
	mov	r0,#1		@ fd 1
	ldr	r1,=__uchar_str2 @ char buffer
	ldr	r2,=__uchar_len2 @ count
	svc	0
	b	_special_switch_end
@ raw(string)
_special_switch_r:
	bl	getchar
	cmp	r0,#34		@ "
	bne	_special_switch_r @ skip all chars until "
_special_switch_r_loop:
	bl	getchar
	cmp	r0,#34		@ "
	beq	_special_switch_r_loop_end
	str	r0,[r5],#4	@ store char on the heap and increment hp
	cmp	r0,#92		@ \
	bne	_special_switch_r_loop
	bl	getchar
	str	r0,[r5],#4	@ store escaped char and increment hp
	b	_special_switch_r_loop
_special_switch_r_loop_end:
	mov	r0,#0
	strb	r0,[r5],#4	@ null seperated strings
	mov	r7,#4		@ write syscall code
	mov	r0,#1		@ fd 1
	ldr	r1,=__rstring_str1 @ mov r7,#4  mov r0,#1  ldr r1,=s
	ldr	r2,=__rstring_len1 @ count
	svc	0
	ldr	r0,=stringcnt
	ldr	r0,[r0]
	bl	putint		@ write string id
	mov	r0,#1		@ fd 1
	ldr	r1,=__rstring_str2 @ char buffer
	ldr	r2,=__rstring_len2 @ count
	svc	0
	ldr	r0,=stringcnt
	ldr	r0,[r0]
	bl	putint		@ write string id
	mov	r0,#1		@ fd 1
	ldr	r1,=__rstring_str3 @ char buffer
	ldr	r2,=__rstring_len3 @ count
	svc	0
	ldr	r1,=stringcnt
	ldr	r2,[r1]		@ read string count
	add	r2,r2,#1	@ increment string counter
	str	r2,[r1]		@ write back string counter
	b	_special_switch_end
@ throw(string)
_special_switch_t:
	bl	getchar
	cmp	r0,#34		@ "
	bne	_special_switch_t @ skip all chars until "
_special_switch_t_loop:
	bl	getchar
	cmp	r0,#34		@ "
	beq	_special_switch_t_loop_end
	str	r0,[r5],#4	@ store char on the heap and increment hp
	cmp	r0,#92		@ \
	bne	_special_switch_t_loop
	bl	getchar
	str	r0,[r5],#4	@ store escaped char and increment hp
	b	_special_switch_t_loop
_special_switch_t_loop_end:
	mov	r0,#0
	strb	r0,[r5],#4	@ null seperated strings
	mov	r7,#4		@ write syscall code
	mov	r0,#1		@ fd 1
	ldr	r1,=__tstring_str1 @ mov r7,#4  mov r0,#1  ldr r1,=s
	ldr	r2,=__tstring_len1 @ count
	svc	0
	ldr	r0,=stringcnt
	ldr	r0,[r0]
	bl	putint		@ write string id
	mov	r0,#1		@ fd 1
	ldr	r1,=__rstring_str2 @ char buffer
	ldr	r2,=__rstring_len2 @ count
	svc	0
	ldr	r0,=stringcnt
	ldr	r0,[r0]
	bl	putint		@ write string id
	mov	r0,#1		@ fd 1
	ldr	r1,=__rstring_str3 @ char buffer
	ldr	r2,=__rstring_len3 @ count
	svc	0
	ldr	r1,=stringcnt
	ldr	r2,[r1]		@ read string count
	add	r2,r2,#1	@ increment string counter
	str	r2,[r1]		@ write back string counter
	b	_special_switch_end
@ i(f)
_special_switch_i:
	mov	r7,#4		@ write syscall code
	mov	r0,#1		@ fd 1
	ldr	r1,=__load_var_str1	@ ldr r0,=
	ldr	r2,=__load_var_len1
	svc	0
	bl	getchar
	bl	putchar
	mov	r0,#1		@ fd 1
	ldr	r1,=__load_var_str2	@ ldr r0,[r0]
	ldr	r2,=__load_var_len2
	svc	0
	mov	r0,#1
	ldr	r1,=__if_str1		@ cmp r0,#0   beq Lneg
	ldr	r2,=__if_len1
	svc	0
	ldr	r2,=labelcnt
	ldr	r1,[r2]
	mov	r0,r1
	bl	putint
	mov	r0,10		@ \n
	bl	putchar
	mov	r0,#1
	push	{r0,r1}
	add	r1,r1,#1
	str	r1,[r2]
_special_switch_i_skip:
	bl	getchar
	cmp	r0,#123
	bne	_special_switch_i_skip
	b	_special_switch_end
@ w(hile)
_special_switch_w:
	ldr	r4,=labelcnt
	ldr	r3,[r4]
	mov	r7,#4		@ write syscall code
	mov	r0,#1		@ fd 1
	ldr	r1,=__while_str1	@ Lloop
	ldr	r2,=__while_len1
	svc	0
	mov	r0,r3		@ id
	bl	putint
	mov	r0,#58		@ :
	bl	putchar
	mov	r0,#10		@ \n
	bl	putchar
	mov	r0,#1		@ fd 1
	ldr	r1,=__load_var_str1	@ ldr r0,=
	ldr	r2,=__load_var_len1
	svc	0
	bl	getchar
	bl	putchar
	mov	r0,#1		@ fd 1
	ldr	r1,=__load_var_str2	@ ldr r0,[r0]
	ldr	r2,=__load_var_len2
	svc	0
	mov	r0,#1		@ fd 1
	ldr	r1,=__while_str2	@ cmp r0,#0  beq Lloop_end
	ldr	r2,=__while_len2
	svc	0
	mov	r0,r3		@ id
	bl	putint
	mov	r0,#10		@ \n
	bl	putchar
	mov	r0,#3
	push	{r0,r3}
	add	r3,r3,#1
	str	r3,[r4]
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
@ c(all)
_special_switch_c:
	mov	r7,#4		@ write syscall code
	mov	r0,#1		@ fd 1
	ldr	r1,=__call_str @ char buffer
	ldr	r2,=__call_len @ count
	svc	0
	bl	getchar
_special_switch_c_loop:
	bl	putchar
	bl	getchar
	cmp	r0,#41		@ )
	bne	_special_switch_c_loop
	mov	r0,#10		@ \n
	bl	putchar
	b	_special_switch_end
@ f(un)
_special_switch_f:
	bl	getchar
_special_switch_f_loop:
	bl	putchar
	bl	getchar
	cmp	r0,#41		@ )
	bne	_special_switch_f_loop
	mov	r7,#4		@ write syscall code
	mov	r0,#1		@ fd 1
	ldr	r1,=__fun_str1 @ char buffer
	ldr	r2,=__fun_len1 @ count
	svc	0
	mov	r0,#4
	mov	r1,#-1
	push	{r0,r1}
	b	_special_switch_end
@ l(oad)
_special_switch_l:
	bl	skipspaces
	mov	r3,r0		@ :load 1st arg
	bl	skipspaces
	cmp	r0,#44		@ ,
	movne	r0,#44
	bne	exit		@ error 44 - missing ,
	bl	skipspaces
	mov	r4,r0		@ :load 2nd arg
@ load index
	mov	r7,#4		@ write syscall
	mov	r0,#1		@ fd 1
	ldr	r1,=__load_var_str1	@ ldr r0,=
	ldr	r2,=__load_var_len1
	svc	0
	mov	r0,r4		@ index
	bl	putchar
	mov	r0,#1		@ fd 1
	ldr	r1,=__load_var_str2	@ ldr r0,[r0]
	ldr	r2,=__load_var_len2
	svc	0
@ end
@ load memory at index and store variable
	mov	r0,#1		@ fd 1
	ldr	r1,=__load_str1	@ ldr r1,=
	ldr	r2,=__load_len1
	svc	0
	mov	r0,r3		@ dst
	bl	putchar
	mov	r0,#1		@ fd 1
	ldr	r1,=__load_str2	@ ldr r0,[r0, LSL #2]   str r0,[r1]
	ldr	r2,=__load_len2
	svc	0
	b	_special_switch_end
@ s(tore)
_special_switch_s:
	bl	skipspaces
	mov	r3,r0		@ :load 1st arg
	bl	skipspaces
	cmp	r0,#44		@ ,
	movne	r0,#44
	bne	exit		@ error 44 - missing ,
	bl	skipspaces
	mov	r4,r0		@ :load 2nd arg
@ load index
	mov	r7,#4		@ write syscall
	mov	r0,#1		@ fd 1
	ldr	r1,=__load_var_str1	@ ldr r0,=
	ldr	r2,=__load_var_len1
	svc	0
	mov	r0,r4		@ index
	bl	putchar
	mov	r0,#1		@ fd 1
	ldr	r1,=__load_var_str2	@ ldr r0,[r0]
	ldr	r2,=__load_var_len2
	svc	0
@ end
@ store variable to memory at index
	mov	r0,#1		@ fd 1
	ldr	r1,=__store_str1@ ldr r1,=
	ldr	r2,=__store_len1
	svc	0
	mov	r0,r3		@ dst
	bl	putchar
	mov	r0,#1		@ fd 1
	ldr	r1,=__store_str2@ ldr r0,[r0, LSL #2]   str r0,[r1]
	ldr	r2,=__store_len2
	svc	0
	b	_special_switch_end
_special_switch_end:
	bl	getchar
	cmp	r0,#0
	beq	_special_endskip
	cmp	r0,#10
	beq	_special_endskip
	b	_special_switch_end
_special_endskip:
	b	_loop1_cond

rcurly:		@ not a function
	pop	{r3,r4}		@ get current state (if 1/else 2/while 3/fun 4) and label number
	cmp	r3,#1		@ if
	beq	rcurly_if
	cmp	r3,#2		@ else
	beq	rcurly_else
	cmp	r3,#3		@ while
	beq	rcurly_while
	cmp	r3,#4		@ fun
	beq	rcurly_fun
	mov	r0,#11		@ error 11 - misplaced }
	bl	exit
rcurly_if:
	mov	r7,#4		@ write syscall code
	mov	r0,#1		@ fd 1
	ldr	r1,=__if_str3 @ char buffer
	ldr	r2,=__if_len3 @ count
	svc	0
	mov	r0,r4		@ id
	bl	putint
	mov	r7,#4		@ write syscall code
	mov	r0,#1		@ fd 1
	ldr	r1,=__if_str4 @ char buffer
	ldr	r2,=__if_len4 @ count
	svc	0
	mov	r0,r4		@ id
	bl	putint
	mov	r0,#58		@ :
	bl	putchar
	mov	r0,#10		@ \n
	bl	putchar
	bl	skipspaces
	cmp	r0,#101		@ e
	bne	rcurly_else
rcurly_if_skip:
	bl	getchar
	cmp	r0,#123		@ {
	bne	rcurly_if_skip
	mov	r3,#2		@ set else mode
	push	{r3,r4}
	b	rcurly_end
rcurly_else:
	mov	r7,#4		@ write syscall code
	mov	r0,#1		@ fd 1
	ldr	r1,=__if_str5 @ Lend
	ldr	r2,=__if_len5 @ count
	svc	0
	mov	r0,r4		@ id
	bl	putint
	mov	r0,#58		@ :
	bl	putchar
	mov	r0,#10		@ \n
	bl	putchar
	b	rcurly_end
rcurly_while:
	mov	r7,#4		@ write syscall code
	mov	r0,#1		@ fd 1
	ldr	r1,=__while_str3 @ b Lloop
	ldr	r2,=__while_len3 @ count
	svc	0
	mov	r0,r4		@ id
	bl	putint
	mov	r0,#1		@ fd 1
	ldr	r1,=__while_str4 @ Lloop_end
	ldr	r2,=__while_len4 @ count
	svc	0
	mov	r0,r4		@ id
	bl	putint
	mov	r0,#58		@ :
	bl	putchar
	mov	r0,#10		@ \n
	bl	putchar
	b	rcurly_end
rcurly_fun:
	mov	r7,#4		@ write syscall code
	mov	r0,#1		@ fd 1
	ldr	r1,=__fun_str2 @ b Lloop
	ldr	r2,=__fun_len2 @ count
	svc	0
	b	rcurly_end
rcurly_end:
	b	_loop1_cond

assign:
	push	{lr}
	push	{r0}		@ destination
	bl	skipspaces
	cmp	r0,61		@ =
	bne	exit		@ error 61 - missing =
	bl	skipspaces
	mov	r3,r0		@ operand 1
	cmp	r0,#45		@ -
	beq	assign_const
	cmp	r0,#48		@ 0
	movlt	r0,#4		@ error 4 - invalid char in assign stmt
	bllt	exit
	cmp	r0,#57		@ 9
	bgt	assign_binop_pre
assign_const:
	bl	assign_const1
	cmp	r0,#10		@ \n
	beq	assign_write_mem
	b	assign_binop
@ const 1st operand
assign_const1:
	push	{r1,r2,r3,r7,lr}
	mov	r3,r0
	mov	r7,#4		@ write syscall code
	mov	r0,#1		@ fd 1
	ldr	r1,=__stmt_const1_str @ char buffer
	ldr	r2,=__stmt_const1_len @ count
	svc	0
	mov	r0,r3
assign_const1_loop:
	bl	putchar
	bl	getchar
	cmp	r0,#48		@ 0
	blt	assign_const1_end
	cmp	r0,#57		@ 9
	bgt	assign_const1_end
	b	assign_const1_loop
assign_const1_end:
	mov	r3,r0
	mov	r0,#10		@ \n
	bl	putchar
	mov	r0,r3
	cmp	r0,#35		@ #
	moveq	r6,#1
	pop	{r1,r2,r3,r7,lr}
	bx	lr
@ const 2nd operand
assign_const2:
	push	{r1,r2,r3,r7,lr}
	mov	r3,r0
	mov	r7,#4		@ write syscall code
	mov	r0,#1		@ fd 1
	ldr	r1,=__stmt_const2_str @ char buffer
	ldr	r2,=__stmt_const2_len @ count
	svc	0
	mov	r0,r3
assign_const2_loop:
	bl	putchar
	bl	getchar
	cmp	r0,#48		@ 0
	blt	assign_const2_end
	cmp	r0,#57		@ 9
	bgt	assign_const2_end
	b	assign_const2_loop
assign_const2_end:
	mov	r3,r0
	mov	r0,#10		@ \n
	bl	putchar
	mov	r0,r3
	cmp	r0,#35		@ #
	moveq	r6,#1
	pop	{r1,r2,r3,r7,lr}
	bx	lr

assign_binop_pre:
	bl	loadvar_r0
assign_binop:
	bl	skipspaces	@ operation
	cmp	r0,#43		@ +
	beq	assign_add
	cmp	r0,#45		@ -
	beq	assign_sub
	cmp	r0,#42		@ *
	beq	assign_mul
	cmp	r0,#47		@ /
	beq	assign_div
	cmp	r0,#37		@ %
	beq	assign_mod
	cmp	r0,#62		@ >
	beq	assign_gt
	cmp	r0,#60		@ <
	beq	assign_lt
	cmp	r0,#38		@ &
	beq	assign_and
	cmp	r0,#124		@ |
	beq	assign_or
	cmp	r0,#35		@ #
	beq	assign_comment
	cmp	r0,#61		@ =
	bne	assign_write_mem
	bl	getchar
	cmp	r0,#61		@ ==
	beq	assign_eq
	cmp	r0,#60		@ =<
	beq	assign_leq
	cmp	r0,#62		@ =>
	beq	assign_geq
	cmp	r0,#33		@ =!
	beq	assign_neq
assign_badop:
	mov	r0,#7
	bl	exit		@ error 7 - bad op
assign_binop_end:
	bl	skipspaces
	cmp	r0,#95
	blgt	loadvar_r1
	blle	assign_const2
	mov	r7,#4
	pop	{r1,r2}
	mov	r0,#1		@ fd 1
	svc	0
assign_write_mem:
	mov	r0,#1		@ fd 1
	ldr	r1,=__stmt_store_str1
	ldr	r2,=__stmt_store_len1
	svc	0
	pop	{r0}
	bl	putchar
	mov	r0,#1		@ fd 1
	ldr	r1,=__stmt_store_str2
	ldr	r2,=__stmt_store_len2
	svc	0
	pop	{lr}
	bx	lr

loadvar_r0:
	push	{r1,r2,r3,lr}
	mov	r3,r0
	mov	r0,#1		@ fd 1
	ldr	r1,=__load_var_str1
	ldr	r2,=__load_var_len1
	svc	0
	mov	r0,r3
	bl	putchar
	mov	r0,#1		@ fd 1
	ldr	r1,=__load_var_str2
	ldr	r2,=__load_var_len2
	svc	0
	pop	{r1,r2,r3,lr}
	bx	lr

loadvar_r1:
	push	{r1,r2,r3,lr}
	mov	r3,r0
	mov	r0,#1		@ fd 1
	ldr	r1,=__load_var_str1_r1
	ldr	r2,=__load_var_len1_r1
	svc	0
	mov	r0,r3
	bl	putchar
	mov	r0,#1		@ fd 1
	ldr	r1,=__load_var_str2_r1
	ldr	r2,=__load_var_len2_r1
	svc	0
	pop	{r1,r2,r3,lr}
	bx	lr

assign_comment:
	mov	r6,#1
	b	assign_write_mem

assign_add:
	ldr	r1,=__stmt_add_str
	ldr	r2,=__stmt_add_len
	push	{r1,r2}
	b	assign_binop_end

assign_sub:
	ldr	r1,=__stmt_sub_str
	ldr	r2,=__stmt_sub_len
	push	{r1,r2}
	b	assign_binop_end

assign_mul:
	ldr	r1,=__stmt_mul_str
	ldr	r2,=__stmt_mul_len
	push	{r1,r2}
	b	assign_binop_end

assign_div:
	ldr	r1,=__stmt_div_str
	ldr	r2,=__stmt_div_len
	push	{r1,r2}
	b	assign_binop_end

assign_mod:
	ldr	r1,=__stmt_mod_str
	ldr	r2,=__stmt_mod_len
	push	{r1,r2}
	b	assign_binop_end

assign_gt:
	ldr	r1,=__stmt_gt_str
	ldr	r2,=__stmt_gt_len
	push	{r1,r2}
	b	assign_binop_end

assign_geq:
	ldr	r1,=__stmt_geq_str
	ldr	r2,=__stmt_geq_len
	push	{r1,r2}
	b	assign_binop_end

assign_lt:
	ldr	r1,=__stmt_lt_str
	ldr	r2,=__stmt_lt_len
	push	{r1,r2}
	b	assign_binop_end

assign_leq:
	ldr	r1,=__stmt_leq_str
	ldr	r2,=__stmt_leq_len
	push	{r1,r2}
	b	assign_binop_end

assign_eq:
	ldr	r1,=__stmt_eq_str
	ldr	r2,=__stmt_eq_len
	push	{r1,r2}
	b	assign_binop_end

assign_neq:
	ldr	r1,=__stmt_neq_str
	ldr	r2,=__stmt_neq_len
	push	{r1,r2}
	b	assign_binop_end

assign_and:
	ldr	r1,=__stmt_and_str
	ldr	r2,=__stmt_and_len
	push	{r1,r2}
	b	assign_binop_end

assign_or:
	ldr	r1,=__stmt_or_str
	ldr	r2,=__stmt_or_len
	push	{r1,r2}
	b	assign_binop_end

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
_dataseg_loop:
	mov	r0,r3
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
	bl	putchar
	mov	r0,r3
	bl	putint
	push	{r1,r2}
	mov	r0,#1		@ fd 1
	ldr	r1,=__rstrdata_str1 @ `: .ascii "`
	ldr	r2,=__rstrdata_len1 @ count
	svc	0
	pop	{r1,r2}
_dataseg_str_literal:
	ldr	r0,[r1],#4
	cmp	r0,#0		@ is char null
	beq	_dataseg_str_literal_end
	bl	putchar
	b	_dataseg_str_literal
_dataseg_str_literal_end:
@ close string literal
	push	{r1,r2}		@ save r2 (string count)
	mov	r0,#1		@ fd 1
	ldr	r1,=__rstrdata_str2 @ char buffer
	ldr	r2,=__rstrdata_len2 @ count
	svc	0
	mov	r0,r3
	bl	putint
	mov	r0,#1		@ fd 1
	ldr	r1,=__rstrdata_str3 @ char buffer
	ldr	r2,=__rstrdata_len3 @ count
	svc	0
	mov	r0,r3
	bl	putint
	mov	r0,#10		@ \n
	bl	putchar
	pop	{r1,r2}		@ retrieve r2 (string count)
	add	r3,r3,#1	@ increment string index
	b	_dataseg_string_loop
_dataseg_string_end:
@ heap label
	mov	r0,#1		@ fd 1
	ldr	r1,=__mem_str	@ char buffer
	ldr	r2,=__mem_len	@ count
	svc	0
	pop	{r0,r1,r2,r3,r4,r7,lr}
	bx	lr

 @ r0 has arg
putint:
	push	{r1,r2,r3,lr}
	mov	r2,#0
putint_div:
	mov	r1,#10		@ divisor
	sdiv	r3,r0,r1
	mul	r1,r1,r3
	sub	r1,r0,r1
	mov	r0,r3
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
	mov	r0,r1
	bl	putchar
	sub	r2,r2,#1
	cmp	r2,#0
	bge	putint_unroll_loop
	pop	{r1,r2,r3,lr}
	bx	lr

skipspaces:	@ returns read character in r0
	push	{lr}
skipspaces_l:
	bl	getchar
	cmp	r0,#32		@ space
	beq	skipspaces_l
	cmp	r0,#9		@ tab
	beq	skipspaces_l
	pop	{lr}
	bx	lr

.data
cbuf: .byte 0,0
stringcnt: .word 0
labelcnt: .word 0
__header_str: .ascii ".include \"src/header.s\"\n\n_start:\n\tbl\tmain\n\tmov\tr0,#0\n\tbl\texit\n\n"
__header_len = .-__header_str
__dataseg_str: .ascii "\n.data\ncbuf: .byte 0,0\n"
__dataseg_len = .-__dataseg_str
__getchar_str1: .ascii "\tbl\tgetchar\n\tldr\tr1,="
__getchar_len1 = .-__getchar_str1
__getchar_str2: .ascii "\n\tstr\tr0,[r1]\n"
__getchar_len2 = .-__getchar_str2
__putchar_str1: .ascii "\tldr\tr0,="
__putchar_len1 = .-__putchar_str1
__putchar_str2: .ascii "\n\tldr\tr0,[r0]\n\tbl\tputchar\n"
__putchar_len2 = .-__putchar_str2
__uchar_str2: .ascii "\n\tldr\tr0,[r0]\n\tbl\tthrowchar\n"
__uchar_len2 = .-__uchar_str2
__rstring_str1: .ascii "\tmov\tr7,#4\n\tmov\tr0,#1\n\tldr\tr1,=s"
__rstring_len1 = .-__rstring_str1
__tstring_str1: .ascii "\tmov\tr7,#4\n\tmov\tr0,#2\n\tldr\tr1,=s"
__tstring_len1 = .-__tstring_str1
__rstring_str2: .ascii "\n\tldr\tr2,=slen"
__rstring_len2 = .-__rstring_str2
__rstring_str3: .ascii "\n\tsvc\t0\n"
__rstring_len3 = .-__rstring_str3
__rstrdata_str1: .ascii ": .ascii \""
__rstrdata_len1 = .-__rstrdata_str1
__rstrdata_str2: .ascii "\"\nslen"
__rstrdata_len2 = .-__rstrdata_str2
__rstrdata_str3: .ascii " = .-s"
__rstrdata_len3 = .-__rstrdata_str3
__exit_str1: .ascii "\tldr\tr0,="
__exit_len1 = .-__exit_str1
__exit_str2: .ascii "\n\tldrb\tr0,[r0]\n\tbl\texit\n"
__exit_len2 = .-__exit_str2
__variable_str: .ascii ": .word 0\n"
__variable_len = .-__variable_str
__if_str1: .ascii "\tcmp\tr0,#0\n\tbeq\tLneg"
__if_len1 = .-__if_str1
__if_str3: .ascii "\tb\tLend"
__if_len3 = .-__if_str3
__if_str4: .ascii "\nLneg"
__if_len4 = .-__if_str4
__if_str5: .ascii "Lend"
__if_len5 = .-__if_str5
__load_var_str1: .ascii "\tldr\tr0,="
__load_var_len1 = .-__load_var_str1
__load_var_str2: .ascii "\n\tldr\tr0,[r0]\n"
__load_var_len2 = .-__load_var_str2
__load_var_str1_r1: .ascii "\tldr\tr1,="
__load_var_len1_r1 = .-__load_var_str1_r1
__load_var_str2_r1: .ascii "\n\tldr\tr1,[r1]\n"
__load_var_len2_r1 = .-__load_var_str2_r1
__while_str1: .ascii "Lloop"
__while_len1 = .-__while_str1
__while_str2: .ascii "\tcmp\tr0,#0\n\tbeq\tLloop_end"
__while_len2 = .-__while_str2
__while_str3: .ascii "\tb\tLloop"
__while_len3 = .-__while_str3
__while_str4: .ascii "\nLloop_end"
__while_len4 = .-__while_str4
__load_str1: .ascii "\tldr\tr1,="
__load_len1 = .-__load_str1
__load_str2: .ascii "\n\tldr\tr2,=mem\n\tldr\tr0,[r2, r0, LSL #2]\n\tstr\tr0,[r1]\n"
__load_len2 = .-__load_str2
__store_str1: .ascii "\tldr\tr1,="
__store_len1 = .-__store_str1
__store_str2: .ascii "\n\tldr\tr1,[r1]\n\tldr\tr2,=mem\n\tstr\tr1,[r2,r0, LSL #2]\n"
__store_len2 = .-__store_str2
__stmt_const1_str: .ascii "\tmov\tr0,#"
__stmt_const1_len = .-__stmt_const1_str
__stmt_const2_str: .ascii "\tmov\tr1,#"
__stmt_const2_len = .-__stmt_const2_str
__stmt_add_str: .ascii "\tadd\tr0,r0,r1\n"
__stmt_add_len = .-__stmt_add_str
__stmt_sub_str: .ascii "\tsub\tr0,r0,r1\n"
__stmt_sub_len = .-__stmt_sub_str
__stmt_mul_str: .ascii "\tmul\tr0,r0,r1\n"
__stmt_mul_len = .-__stmt_mul_str
__stmt_div_str: .ascii "\tsdiv\tr0,r0,r1\n"
__stmt_div_len = .-__stmt_div_str
__stmt_mod_str: .ascii "\tsdiv\tr2,r0,r1\n\tmul\tr1,r1,r2\n\tsub\tr0,r0,r1\n"
__stmt_mod_len = .-__stmt_mod_str
__stmt_gt_str: .ascii "\tcmp\tr0,r1\n\tmovgt\tr0,#1\n\tmovle\tr0,#0\n"
__stmt_gt_len = .-__stmt_gt_str
__stmt_geq_str: .ascii "\tcmp\tr0,r1\n\tmovge\tr0,#1\n\tmovlt\tr0,#0\n"
__stmt_geq_len = .-__stmt_geq_str
__stmt_lt_str: .ascii "\tcmp\tr0,r1\n\tmovlt\tr0,#1\n\tmovge\tr0,#0\n"
__stmt_lt_len = .-__stmt_lt_str
__stmt_leq_str: .ascii "\tcmp\tr0,r1\n\tmovle\tr0,#1\n\tmovgt\tr0,#0\n"
__stmt_leq_len = .-__stmt_leq_str
__stmt_eq_str: .ascii "\tcmp\tr0,r1\n\tmoveq\tr0,#1\n\tmovne\tr0,#0\n"
__stmt_eq_len = .-__stmt_eq_str
__stmt_neq_str: .ascii "\tcmp\tr0,r1\n\tmovne\tr0,#1\n\tmoveq\tr0,#0\n"
__stmt_neq_len = .-__stmt_neq_str
__stmt_and_str: .ascii "\tand\tr0,r0,r1\n"
__stmt_and_len = .-__stmt_and_str
__stmt_or_str: .ascii "\torr\tr0,r0,r1\n"
__stmt_or_len = .-__stmt_or_str
__stmt_store_str1: .ascii "\tldr\tr1,="
__stmt_store_len1 = .-__stmt_store_str1
__stmt_store_str2: .ascii "\n\tstr\tr0,[r1]\n"
__stmt_store_len2 = .-__stmt_store_str2
__call_str: .ascii "\tbl\t"
__call_len = .-__call_str
__fun_str1: .ascii ":\n\tpush\t{lr}\n"
__fun_len1 = .-__fun_str1
__fun_str2: .ascii "\tpop\t{lr}\n\tbx\tlr\n.pool\n"
__fun_len2 = .-__fun_str2
__mem_str: .ascii "mem: .space 80000\n"
__mem_len = .-__mem_str
heap: .space 40000
