## Definition
prg -> decl {decl}

decl -> type ident;

decl -> type ident = expr;

decl -> type ident ([param {, param}]){[stmt {,stmt}]}

param -> type ident
type -> void | char | int | bool

expr -> const | ident | (expr)

expr -> expr ( & | | | == | != | && | || | < | > | <= | >= | * | / | % | + | - ) expr

# Expression grammar
a | b
--|--
E -> FE' | E'-> \|\| FE' \| ε
F -> GF' | F' ->  && GF' \| ε
G -> HG' | G' -> \| HG' \| ε
H -> IH' | H' -> & IH' \| ε
I -> JI' | I' -> == JI' \| != JI' \| ε
J -> KJ' | J' -> < KJ' \| > KJ' \| <= KJ' \| >= KJ' \| ε
K -> LK' | K' -> + LK' \| - LK' \| ε
L -> ML' | L' -> * ML' \| / ML' \| % ML' \| ε
M -> ++M \| --M \| +M \| -M \| !M \| N
O -> O++ \| O-- \| P
P -> ident \| const \| (E)

## Memory structure
Type\Offset | 0 | 1 | 2 | 3
----------- | - | - | - | -
Declaration | 0 | type | expression (-1 if none) | -
Type | 1 | [0int, 1char, 2bool, 3void, 4arr, 5ptr] | basetype | -
Expression | 2 | 0const, 1ident, 2prefix, 3postfix, 4binop | expr1 | expr2
Function | 3 | type | ident | 0start, 1end
Parameter | 4 | type | ident | -
Return | 5 | expr (-1 if none) | - | -
Expression statement | 6 | expr | - | -
Assignment | 7 | 0=, 1+=, 2-=, 3/=,4*= | expr1 | expr2
If/Else | 8 | 0if, 1else, 2end | expr(if) | -
While | 9 | 0start, 1end | expr | -