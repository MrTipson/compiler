---
title: "Recognized tokens"
date: 2023-03-01
draft: false
weight: 20
---

Next, we can examine the recognised tokens, which are located between **b** and **e**. Comments will be added to indicate wheat each row indicates, but for more info, check out [the docs](https://github.com/MrTipson/compiler/blob/master/docs/tokenization.md).

{{< highlight bash >}}
(gdb) print ((int)e - (int)b)
# 156

(gdb) x/156dw ((int*)&mem + (int)b)
0x417d6:	0	3	0	1       # 'void' (type=0,id=3) on line 1
0x417e6:	2	5	6	1       # identifier (type=2,start=5,length=6) on line 1
0x417f6:	14	0	0	1       # '(' (type=14) on line 1
0x41806:	0	1	0	1       # 'char' (type=0,id=1) on line 1
0x41816:	36	0	0	1       # '*' (type=36) on line 1
0x41826:	2	18	3	1       # identifier (type=2,start=18,length=3) on line 1
0x41836:	21	0	0	1       # ',' (type=21) on line 1
0x41846:	0	0	0	1       # 'int' (type=0,id=0) on line 1
0x41856:	2	27	4	1       # identifier (type=2,start=27,length=4) on line 1
0x41866:	21	0	0	1       # ',' (type=21) on line 1
0x41876:	0	0	0	1       # 'int' (type=0,id=0) on line 1
0x41886:	2	37	4	1       # identifier (type=2,start=37,length=4) on line 1
0x41896:	15	0	0	1       # ')' (type=15) on line 1
0x418a6:	22	0	0	1       # ';' (type=22) on line 1
0x418b6:	0	3	0	3       # 'void' (type=0,id=3) on line 3
0x418c6:	2	50	4	3       # identifier (type=2,start=50,length=4) on line 3
0x418d6:	14	0	0	3       # '(' (type=14) on line 3
0x418e6:	15	0	0	3       # ')' (type=15) on line 3
0x418f6:	16	0	0	3       # '{' (type=16) on line 3
0x41906:	0	0	0	4       # 'int' (type=0,id=0) on line 4
0x41916:	2	64	1	4       # identifier (type=2,start=64,length=1) on line 4
0x41926:	1	0	0	4       # '=' (type=1,id=0) on line 4
0x41936:	3	0	5	4       # constant(int) (type=3,id=0,value=5) on line 4
0x41946:	39	0	0	4       # '+' (type=39) on line 4
0x41956:	3	0	10	4       # constant(int) (type=3,id=0,value=10) on line 4
0x41966:	36	0	0	4       # '*' (type=36) on line 4
0x41976:	3	0	2	4       # constant(int) (type=3,id=0,value=2)
0x41986:	22	0	0	4       # ';' (type=22) on line 4
0x41996:	2	81	6	5       # identifier (type=2,start=81,length=6) on line 5
0x419a6:	14	0	0	5       # '(' (type=14) on line 5
0x419b6:	3	3	88	5       # constant(string) (type=3,id=3,start=88) with string_id=0
0x419c6:	21	0	0	5       # ',' (type=21) on line 5
0x419d6:	2	107	1	5       # identifier (type=2,start=107,length=1) on line 5
0x419e6:	21	0	0	5       # ',' (type=21) on line 5
0x419f6:	3	0	0	5       # constant(int) (type=3,id=0,value=0) on line 5
0x41a06:	15	0	0	5       # ')' (type=15) on line 5
0x41a16:	22	0	0	5       # ';' (type=22) on line 5
0x41a26:	17	0	0	6       # '}' (type=17) on line 6
0x41a36:	-1	-1	-1	-1      # lexical phase appends a safety ending token
{{< /highlight >}}

String constants and identifiers contain pointers to where the name appears in the input program. Identifiers also contain the length, while string constants (literals) have implicit length (till the ending ").
{{< highlight bash >}}
(gdb) x/6cw ((int*)&mem + 5)
# 0x41612:	112 'p'	114 'r'	105 'i'	110 'n'
# 0x41622:	116 't'	102 'f'
{{< /highlight >}}