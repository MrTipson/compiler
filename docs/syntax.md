## Definition
prg -> decl {decl}

decl -> type ident;

decl -> type ident = expr;

decl -> type ident ([type ident {, type ident}]){[stmt {,stmt}]}

type -> void | char | int | bool

expr -> const

expr -> ident

expr -> expr 

expr -> expr ( & | | | == | != | && | || | < | > | <= | >= | * | / | % | + | - ) expr

## Memory structure
Type\Offset | 0 | 1 | 2 | 3
----------- | - | - | - | -
Declaration | 0 | type | expression (-1 if none) | -
Type | 1 | [0int, 1char, 2bool, 3void, 4arr, 5ptr] | basetype | -
Expression | 2 | 0const, 1ident, 2prefix, 3postfix, 4binop | expr1 | expr2