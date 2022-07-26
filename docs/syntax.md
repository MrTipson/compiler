## Definition
prg -> decl {decl}

decl -> type ident;

decl -> type ident = expr;

decl -> type ident ([param {, param}]){[stmt {,stmt}]}

param -> type ident

type -> void | char | int | bool

# Expression grammar
a | b
--|--
E -> FE' | E'-> \|\| FE' \| ε
F -> GF' | F' ->  && GF' \| ε
G -> XG' | G' -> \| XG' \| ε
X -> HX' | X' -> ^ HX' \| ε
H -> IH' | H' -> & IH' \| ε
I -> JI' | I' -> == JI' \| != JI' \| ε
J -> KJ' | J' -> < KJ' \| > KJ' \| <= KJ' \| >= KJ' \| ε
K -> LK' | K' -> + LK' \| - LK' \| ε
L -> ML' | L' -> * ML' \| / ML' \| % ML' \| ε
M -> ++M \| --M \| +M \| -M \| !M \| &M \| *M \| (type)M \| N
N -> ON' | N' -> ++N' \| --N' \| [E]N' \| .identN' \| ε
O -> ident \| const \| (E)

## Expression types
Operator | Id
-------- | --
Postf ++ | 0
Postf -- | 1
Postf arr| 24
Post comp| 25
Pref  ++ | 2
Pref  -- | 3
Pref  +  | 4
Pref  -  | 5
Pref  !  | 6
Pref  ~  | 27
Pref  &  | 28
Pref  *  | 29
Pref cast| 30
Binop *  | 7
Binop /  | 8
Binop %  | 9
Binop +  | 10
Binop -  | 11
Binop <  | 12
Binop >  | 13
Binop <= | 14
Binop >= | 15
Binop == | 16
Binop != | 17
Binop &  | 18
Binop \| | 19
Binop && | 20
Binop \|\| | 21
Binop ^  | 26
ident    | 22
const    | 23

## Memory structure
Type\Offset | 0 | 1 | 2 | 3
----------- | - | - | - | -
Declaration | 0 | type | expression (-1 if none) | -
Type | 1 | 0int, 1char, 2bool, 3void, 4arr, 5ptr, 6name | basetype | const token
Expression | 2 | id | expr1 | expr2
Function | 3 | type | ident | 0start, 1end, 2startdecl
Parameter | 4 | type | ident | -
Return | 5 | expr (-1 if none) | - | -
Expression statement | 6 | expr | - | -
Assignment | 7 | 0=, 1+=, 2-=, 3/=,4*= | expr1 | expr2
If/Else | 8 | 0if, 1else, 2end | expr(if) | -
While | 9 | 0start, 1end | expr(start only) | -
Call | 10 | 0start, 1end | ident(start only) | -
Argument | 11 | expr | - | -

> Note: Cast expression: type is expr2