.include "src/header.s"
.global _special_switch_i
.global _dataseg_string_loop

.macro write string,length
	push	{r0,r1,r2}
	mov	r7,#4		@ write syscall
	mov	r0,#1		@ stdout
	ldr r1,=\string
	ldr r2,=\length
	svc	0
	pop	{r0,r1,r2}
.endm

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
	write __getchar_str1,__getchar_len1
	bl	getchar		@ var
	bl	putchar
	write __getchar_str2,__getchar_len2
	b	_special_switch_end
@ p(utchar)
_special_switch_p:
	write __putchar_str1,__putchar_len1
	bl	getchar		@ var
	bl	putchar
	write __putchar_str2,__putchar_len2
	b	_special_switch_end
@ u(throwchar)
_special_switch_u:
	write __putchar_str1,__putchar_len1
	bl	getchar		@ var
	bl	putchar
	write __uchar_str2,__uchar_len2
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
	write __rstring_str1,__rstring_len1
	ldr	r0,=stringcnt
	ldr	r0,[r0]
	bl	putint		@ write string id
	write __rstring_str2,__rstring_len2
	ldr	r0,=stringcnt
	ldr	r0,[r0]
	bl	putint		@ write string id
	write __rstring_str3,__rstring_len3
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
	write __tstring_str1,__tstring_len1
	ldr	r0,=stringcnt
	ldr	r0,[r0]
	bl	putint		@ write string id
	write __rstring_str2,__rstring_len2
	ldr	r0,=stringcnt
	ldr	r0,[r0]
	bl	putint		@ write string id
	write __rstring_str3,__rstring_len3
	ldr	r1,=stringcnt
	ldr	r2,[r1]		@ read string count
	add	r2,r2,#1	@ increment string counter
	str	r2,[r1]		@ write back string counter
	b	_special_switch_end
@ i(f)
_special_switch_i:
	write __load_var_str1,__load_var_len1
	bl	getchar
	bl	putchar
	write __load_var_str2,__load_var_len2
	write __if_str1,__if_len1
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
	write __while_str1,__while_len1
	mov	r0,r3		@ id
	bl	putint
	mov	r0,#58		@ :
	bl	putchar
	mov	r0,#10		@ \n
	bl	putchar
	write __load_var_str1,__load_var_len1
	bl	getchar
	bl	putchar
	write __load_var_str2,__load_var_len2
	write __while_str2,__while_len2
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
	write __exit_str1,__exit_len1
	bl	getchar		@ var
	bl	putchar
	write __exit_str2,__exit_len2
	b	_special_switch_end
@ c(all)
_special_switch_c:
	write __call_str,__call_len
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
	mov	r0,#70		@ F
	bl	putchar
	bl	getchar
_special_switch_f_loop:
	bl	putchar
	bl	getchar
	cmp	r0,#41		@ )
	bne	_special_switch_f_loop
	write __fun_str1,__fun_len1
	mov	r0,#4
	mov	r1,#-1
	push	{r0,r1}
	b	_special_switch_end
@ l(oad)
_special_switch_l:
	bl	skipspaces
	push	{r0}	@ :load 1st arg
	bl	skipspaces
	cmp	r0,#44		@ ,
	movne	r0,#44
	bne	exit		@ error 44 - missing ,
	bl	skipspaces
@ load index
	write __load_var_str1,__load_var_len1
	bl	putchar
	write __load_var_str2,__load_var_len2
@ end
@ load memory at index and store variable
	write __load_str1,__load_len1
	pop	{r0}
	bl	putchar
	write __load_str2,__load_len2 @ ldr r0,[r0, LSL #2]   str r0,[r1]
	b	_special_switch_end
@ s(tore)
_special_switch_s:
	bl	skipspaces
	push	{r0}
	bl	skipspaces
	cmp	r0,#44		@ ,
	movne	r0,#44
	bne	exit		@ error 44 - missing ,
	bl	skipspaces
@ load index
	write __load_var_str1,__load_var_len1	@ ldr r0,=
	bl	putchar
	write __load_var_str2,__load_var_len2
@ end
@ store variable to memory at index
	write __store_str1,__store_len1
	pop	{r0}
	bl	putchar
	write __store_str2,__store_len2
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
	write __if_str3,__if_len3
	mov	r0,r4		@ id
	bl	putint
	write __if_str4,__if_len4
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
	write __if_str5,__if_len5
	mov	r0,r4		@ id
	bl	putint
	mov	r0,#58		@ :
	bl	putchar
	mov	r0,#10		@ \n
	bl	putchar
	b	rcurly_end
rcurly_while:
	write __while_str3,__while_len3
	mov	r0,r4		@ id
	bl	putint
	write __while_str4,__while_len4
	mov	r0,r4		@ id
	bl	putint
	mov	r0,#58		@ :
	bl	putchar
	mov	r0,#10		@ \n
	bl	putchar
	b	rcurly_end
rcurly_fun:
	write __fun_str2,__fun_len2
	b	rcurly_end
rcurly_end:
	b	_loop1_cond

assign:
	push	{lr}
	push	{r0}		@ destination
	bl	skipspaces
	cmp	r0,61		@ =
	bne	exit		@ error 61 - missing =
	bl	expression_entry
	write __stmt_store_str1,__stmt_store_len1
	pop	{r0}
	bl	putchar
	write __stmt_store_str2,__stmt_store_len2
	pop	{lr}
	bx	lr

expression_entry:
	push	{lr}
expression:
	bl	skipspaces
expression_noskip:
	cmp r0,#10		@ \n
	beq expression_end
	cmp	r0,#48		@ 0
	blt expression_variable
	cmp	r0,#57		@ 9
	bgt	expression_variable
expression_const:
	write __stmt_const_str1,__stmt_const_len1
expression_const_loop:
	bl	putchar
	bl	getchar
	cmp	r0,#48		@ 0
	blt	expression_const_end
	cmp	r0,#57		@ 9
	bgt	expression_const_end
	b	expression_const_loop
expression_const_end:
	write __stmt_const_str2,__stmt_const_len2
	cmp	r0,#32		@ space
	beq	expression
	cmp	r0,#9		@ tab
	beq	expression
	b	expression_noskip
expression_variable:
	cmp	r0,#97		@ a
	blt expression_operator
	cmp r0,#122		@ z
	bgt expression_operator
	write __load_var_str1,__load_var_len1
	bl	putchar
	write __load_var_str2,__load_var_len2
	write __load_var_str3,__load_var_len3
	b	expression
expression_operator:
	cmp	r0,#43		@ +
	beq	expression_add
	cmp	r0,#45		@ -
	beq	expression_sub
	cmp	r0,#42		@ *
	beq	expression_mul
	cmp	r0,#47		@ /
	beq	expression_div
	cmp	r0,#37		@ %
	beq	expression_mod
	cmp	r0,#62		@ >
	beq	expression_gt
	cmp	r0,#60		@ <
	beq	expression_lt
	cmp	r0,#38		@ &
	beq	expression_and
	cmp	r0,#124		@ |
	beq	expression_or
	cmp	r0,#35		@ #
	beq	expression_comment
	cmp	r0,#61		@ =
	bne	expression_end
	bl	getchar
	cmp	r0,#61		@ ==
	beq	expression_eq
	cmp	r0,#60		@ =<
	beq	expression_leq
	cmp	r0,#62		@ =>
	beq	expression_geq
	cmp	r0,#33		@ =!
	beq	expression_neq
	mov	r0,#7
	bl	exit		@ error 7 - bad op
expression_end:
	pop	{lr}
	bx	lr

expression_comment:
	mov	r6,#1
	b	expression_end

expression_add:
	write __stmt_add_str,__stmt_add_len
	b	expression

expression_sub:
	write __stmt_sub_str,__stmt_sub_len
	b	expression

expression_mul:
	write __stmt_mul_str,__stmt_mul_len
	b	expression

expression_div:
	write __stmt_div_str,__stmt_div_len
	b	expression

expression_mod:
	write __stmt_mod_str,__stmt_mod_len
	b	expression

expression_gt:
	write __stmt_gt_str,__stmt_gt_len
	b	expression

expression_geq:
	write __stmt_geq_str,__stmt_geq_len
	b	expression

expression_lt:
	write __stmt_lt_str,__stmt_lt_len
	b	expression

expression_leq:
	write __stmt_leq_str,__stmt_leq_len
	b	expression

expression_eq:
	write __stmt_eq_str,__stmt_eq_len
	b	expression

expression_neq:
	write __stmt_neq_str,__stmt_neq_len
	b	expression

expression_and:
	write __stmt_and_str,__stmt_and_len
	b	expression

expression_or:
	write __stmt_or_str,__stmt_or_len
	b	expression

header:
	push	{r0,r1,r2,r7,lr}
	write __header_str,__header_len
	pop	{r0,r1,r2,r7,lr}
	bx	lr

dataseg:
	push	{r0,r1,r2,r3,r4,r7,lr}
@ dataseg header
	write __dataseg_str,__dataseg_len
@ dataseg header end
@ variables
	mov	r3,#97		@ a
_dataseg_loop:
	mov	r0,r3
	bl	putchar
	write __variable_str,__variable_len
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
	write __rstrdata_str1,__rstrdata_len1
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
	write __rstrdata_str2,__rstrdata_len2
	mov	r0,r3
	bl	putint
	write __rstrdata_str3,__rstrdata_len3
	mov	r0,r3
	bl	putint
	mov	r0,#10		@ \n
	bl	putchar
	pop	{r1,r2}		@ retrieve r2 (string count)
	add	r3,r3,#1	@ increment string index
	b	_dataseg_string_loop
_dataseg_string_end:
@ heap label
	write __mem_str,__mem_len
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
__header_str: .ascii ".include \"src/header.s\"\n\n_start:\n\tbl\tFmain\n\tmov\tr0,#0\n\tbl\texit\n\n"
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
__if_str4: .ascii "\n.pool\nLneg"
__if_len4 = .-__if_str4
__if_str5: .ascii "Lend"
__if_len5 = .-__if_str5
__load_var_str1: .ascii "\tldr\tr0,="
__load_var_len1 = .-__load_var_str1
__load_var_str2: .ascii "\n\tldr\tr0,[r0]\n"
__load_var_len2 = .-__load_var_str2
__load_var_str3: .ascii "\tpush\t{r0}\n"
__load_var_len3 = .-__load_var_str3
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
__stmt_const_str1: .ascii "\tmov\tr0,#"
__stmt_const_len1 = .-__stmt_const_str1
__stmt_const_str2: .ascii "\n\tpush\t{r0}\n"
__stmt_const_len2 = .-__stmt_const_str2
__stmt_add_str: .ascii "\tpop\t{r0,r1}\n\tadd\tr0,r1,r0\n\tpush\t{r0}\n"
__stmt_add_len = .-__stmt_add_str
__stmt_sub_str: .ascii "\tpop\t{r0,r1}\n\tsub\tr0,r1,r0\n\tpush\t{r0}\n"
__stmt_sub_len = .-__stmt_sub_str
__stmt_mul_str: .ascii "\tpop\t{r0,r1}\n\tmul\tr0,r1,r0\n\tpush\t{r0}\n"
__stmt_mul_len = .-__stmt_mul_str
__stmt_div_str: .ascii "\tpop\t{r0,r1}\n\tsdiv\tr0,r1,r0\n\tpush\t{r0}\n"
__stmt_div_len = .-__stmt_div_str
__stmt_mod_str: .ascii "\tpop\t{r0,r1}\n\tsdiv\tr2,r1,r0\n\tmul\tr0,r2,r0\n\tsub\tr0,r1,r0\n\tpush\t{r0}\n"
__stmt_mod_len = .-__stmt_mod_str
__stmt_gt_str: .ascii "\tpop\t{r0,r1}\n\tcmp\tr1,r0\n\tmovgt\tr0,#1\n\tmovle\tr0,#0\n\tpush\t{r0}\n"
__stmt_gt_len = .-__stmt_gt_str
__stmt_geq_str: .ascii "\tpop\t{r0,r1}\n\tcmp\tr1,r0\n\tmovge\tr0,#1\n\tmovlt\tr0,#0\n\tpush\t{r0}\n"
__stmt_geq_len = .-__stmt_geq_str
__stmt_lt_str: .ascii "\tpop\t{r0,r1}\n\tcmp\tr1,r0\n\tmovlt\tr0,#1\n\tmovge\tr0,#0\n\tpush\t{r0}\n"
__stmt_lt_len = .-__stmt_lt_str
__stmt_leq_str: .ascii "\tpop\t{r0,r1}\n\tcmp\tr1,r0\n\tmovle\tr0,#1\n\tmovgt\tr0,#0\n\tpush\t{r0}\n"
__stmt_leq_len = .-__stmt_leq_str
__stmt_eq_str: .ascii "\tpop\t{r0,r1}\n\tcmp\tr1,r0\n\tmoveq\tr0,#1\n\tmovne\tr0,#0\n\tpush\t{r0}\n"
__stmt_eq_len = .-__stmt_eq_str
__stmt_neq_str: .ascii "\tpop\t{r0,r1}\n\tcmp\tr1,r0\n\tmovne\tr0,#1\n\tmoveq\tr0,#0\n\tpush\t{r0}\n"
__stmt_neq_len = .-__stmt_neq_str
__stmt_and_str: .ascii "\tpop\t{r0,r1}\n\tand\tr0,r1,r0\n\tpush\t{r0}\n"
__stmt_and_len = .-__stmt_and_str
__stmt_or_str: .ascii "\tpop\t{r0,r1}\n\torr\tr0,r1,r0\n\tpush\t{r0}\n"
__stmt_or_len = .-__stmt_or_str
__stmt_store_str1: .ascii "\tpop\t{r0}\n\tldr\tr1,="
__stmt_store_len1 = .-__stmt_store_str1
__stmt_store_str2: .ascii "\n\tstr\tr0,[r1]\n"
__stmt_store_len2 = .-__stmt_store_str2
__call_str: .ascii "\tbl\tF"
__call_len = .-__call_str
__fun_str1: .ascii ":\n\tpush\t{lr}\n"
__fun_len1 = .-__fun_str1
__fun_str2: .ascii "\tpop\t{lr}\n\tbx\tlr\n.pool\n"
__fun_len2 = .-__fun_str2
__mem_str: .ascii "mem: .space 80000\n"
__mem_len = .-__mem_str
heap: .space 40000
