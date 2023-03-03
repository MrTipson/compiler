---
title: "Input program"
date: 2023-03-01
draft: false
weight: 10
---

Lets first examine the memory at the beginning and till the offset saved in the variable **b**. This should contain just the copy of the input program:
{{< highlight bash >}}
(gdb) print (int)b
# 116

# examine 116 words (w) (=4 bytes) and print them out as characters (c)
(gdb) x/116cw (int*)&mem

0x415fe:	118 'v'	111 'o'	105 'i'	100 'd'
0x4160e:	32 ' '	112 'p'	114 'r'	105 'i'
0x4161e:	110 'n'	116 't'	102 'f'	40 '('
0x4162e:	99 'c'	104 'h'	97 'a'	114 'r'
0x4163e:	42 '*'	32 ' '	102 'f'	109 'm'
0x4164e:	116 't'	44 ','	32 ' '	105 'i'
0x4165e:	110 'n'	116 't'	32 ' '	97 'a'
0x4166e:	114 'r'	103 'g'	49 '1'	44 ','
0x4167e:	32 ' '	105 'i'	110 'n'	116 't'
0x4168e:	32 ' '	97 'a'	114 'r'	103 'g'
0x4169e:	50 '2'	41 ')'	59 ';'	10 '\n'
0x416ae:	10 '\n'	118 'v'	111 'o'	105 'i'
0x416be:	100 'd'	32 ' '	109 'm'	97 'a'
0x416ce:	105 'i'	110 'n'	40 '('	41 ')'
0x416de:	32 ' '	123 '{'	10 '\n'	9 '\t'
0x416ee:	105 'i'	110 'n'	116 't'	32 ' '
0x416fe:	120 'x'	32 ' '	61 '='	32 ' '
0x4170e:	53 '5'	32 ' '	43 '+'	32 ' '
0x4171e:	49 '1'	48 '0'	32 ' '	42 '*'
0x4172e:	32 ' '	50 '2'	59 ';'	10 '\n'
0x4173e:	9 '\t'	112 'p'	114 'r'	105 'i'
0x4174e:	110 'n'	116 't'	102 'f'	40 '('
0x4175e:	34 '"'	82 'R'	101 'e'	115 's'
0x4176e:	117 'u'	108 'l'	116 't'	32 ' '
0x4177e:	105 'i'	115 's'	58 ':'	32 ' '
0x4178e:	37 '%'	100 'd'	92 '\\'	110 'n'
0x4179e:	34 '"'	44 ','	32 ' '	120 'x'
0x417ae:	44 ','	32 ' '	48 '0'	41 ')'
0x417be:	59 ';'	10 '\n'	125 '}'	10 '\n'
{{< /highlight >}}