---
title: "Type resolving + LValues"
date: 2023-02-18
draft: false
weight: 20
---

During type resolving, type constraints are checked, such as:
- operand types must be compatible with the operator
- expression in if/while must be a boolean
- argument types in calls must match
- non void functions must have return statement (and its type must match)

The type resolving code is quite long and contains many edge case checking, so we'll only take a look at a simple example:

{{< highlight python >}}
    u = x + 1 # expression operator
    :load(u,u)
    y = u => 0
    v = u =< 3
    y = y & v # postincrement, postdecrement, preincrement, predecrement
    :if(y){
        u = x + 2 # subexpression 1
        :load(x,u)
        :call(semantics_typeResolver_resolveExpression) # the address of the resolved type is in previous memory slot
        y = h == 0 # h carries the Lvalue flag
        :if(y){
            :throw("[increment/decrement] Expression must be an Lvalue. ")
            x = l
            :call(errorPrintLine)
        }
        h = 0 # reset Lvalue flag
        u = m - 1
        :load(x,u) # load address of resolved type
        x = x + 1
        :load(x,x) # load type type
        y = x =! 0 # int
        u = x =! 1 # char
        y = y & u
        u = x =! 5 # ptr
        y = y & u
        :if(y){
            :throw("[increment/decrement] Expression must be of type int, char or pointer. ")
            x = l
            :call(errorPrintLine)
        }
        # operator doesnt change the type, so nothing is added to memory
    }
{{< /highlight >}}