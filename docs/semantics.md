### Memory layout
Type\Offset | 0 | 1
----------- | - | -
Any declaration | address | layer

## Name resolving
The *ident* field of all call and ident expressions is replaced with
the address of its declaration. Same with named types.

## Addr resolving
Addresses:
Variables, parameters, pointer dereference, array access, component access.

Lvalue requirements:
assignment(left), increment/decrement, pointer &.