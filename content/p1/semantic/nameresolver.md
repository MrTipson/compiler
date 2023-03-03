---
title: "Name resolving"
date: 2023-02-18
draft: false
weight: 10
---

During name resolving, declarations (and their depth/scope) are collected and written temporarily into memory. When a scope is closed, the contained declarations are removed (similar to a stack). This includes:
- function declarations
- type declarations (structs)
- variable / parameter declarations

Name resolving is done in 2 passes; the first one only handles global declaration, while the second one goes through the entire program.

When a named type / expression is encountered, the memory entries are checked for a matching identifier. If successful, the address of the declaration is added to the memory entry for the expression (at offset 3) or named type (at offset 2).

---

First, we can take a look at an example of how new declaration entry is added:

{{< highlight python >}}
:fun(semantics_nameResolver_handleDeclaration){
	y = x == 0 # declaration
	:if(y){
		x = i + 3 # offset 3 = identifier
		:load(x,x)
		p = x # copy to p, x is an argument and might get changed
		:call(semantics_nameResolver_getDeclaration)
        # returned: declaration address in y, scope depth in q
		y = y =! -1 # if we found an existing declaration
		q = q == t # if the declaration was on current scope
		y = y & q # both -> redeclaration == error
		:if(y){
			:throw("Name ")
			x = p
			:call(errorIdent)
			:throw(" already declared. ")
			x = p + 3
			:load(x,x)
			:call(errorPrintLine)
		}
		:store(i,m) # store address
		m = m + 1
		:store(t,m) # store scope depth
		m = m + 1
	} else {
        # ... other declarations
	}
}
{{< /highlight >}}

---

We can also check out how names are resolved (in this case, named expression):
{{< highlight python >}}
:fun(semantics_nameResolver_resolveNames){
	y = x == 2 # expression
	u = i + 1
	:load(u,u)
	u = u == 22 # named expression
	y = y & u
	:if(y){
		x = i + 2 # identifier
		:load(x,x)
		p = x # copy to p, x is an argument and might get changed
		:call(semantics_nameResolver_getDeclaration)
		y = r == -1 # if no declaration was found
		:if(y){
			:throw("Undeclared name ")
			x = p
			:call(errorIdent)
			:throw(". ")
			x = p + 3
			:load(x,x)
			:call(errorPrintLine)
		}
		x = i + 3 # declaration is in place of expr2
		:store(r,x)
	} else {
		# ... other uses
	}
}
{{< /highlight >}}

---

For good measure, lets check out the `getDeclaration` method as well.

{{< highlight python >}}
:fun(semantics_nameResolver_getDeclaration){
	j = m - 2 # m points at the first empty memory location, so j points at the last declaration added (each declaration = 2 slots)
	r = -1 # initialize
	q = -1 # initialize
	y = j => g # loop condition (we decrease j down to g, where name resolver entries start)
	z = x # save search identifier
	:while(y){
		:load(u,j) # load declaration address
		:load(v,u) # load declaration type
		y = v == 0 # variable
		:if(y){
			v = u + 3 # offset of identifier
			:load(y,v) # load identifier address
			x = z
			:call(identEquals) # function compares identifiers in x and y
			:if(y){
				r = u # declaration address
				q = j + 1 # declaration scope depth
				:load(q,q)
			}
		} else {
			y = v == 3 # function
			v = v == 4 # parameter
			y = y | v
			:if(y){
				v = u + 2 # offset of identifier
				:load(y,v) # load identifier address
				x = z
				:call(identEquals) # function compares identifiers in x and y
				:if(y){
					r = u # declaration address
					q = j + 1 # declaration scope depth
					:load(q,q)
				}
			}
		}
		j = j - 2 # decrement loop index
		y = j => g # loop condition (boundary)
		u = r == -1 # loop 2nd condition (if we found result already)
		y = y & u # combine conditions
	}
	y = r # set return value
}
{{< /highlight >}}