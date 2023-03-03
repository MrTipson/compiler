---
title: "Syntax analysis"
date: 2023-02-17
draft: false
weight: 20
---

### Purpose

The purpose of syntax analysis is to group up tokens into higher level constructs, such as:
- declaration
- type (chain)
- expression (tree)
- statements
- ...

Doing this allows us to strip away keywords and other extra tokens, resulting in only semantically important constructs.

For a list of all syntax constructs, how their memory entries look like and how expressions were handled, check out the [docs](https://github.com/MrTipson/compiler/blob/master/docs/syntax.md).

---

### Implementation snippet

Lets take a look at an example (from the actual implementation) of how tokens are grouped into a larger construct:

{{< highlight python "linenos=table" >}}
:fun(syntax_isDeclaration){
	:call(syntax_isType)
	y = f == 0 # match found
	:load(x,i)
	x = x == 2
	l = i # save identifier location
	y = y & x
	:if(y){ # type ident
		i = i + 4
		:load(x,i)
		y = x == 22 # ;
		:if(y){ # type ident;
			i = i + 4
			x = 0
			:store(x,m)
			x = m - 5 # type was written in last cell
			m = m + 1
			:store(x,m)
			m = m + 1
			x = -1
			:store(x,m)
			m = m + 1
			:store(l,m)
			m = m + 1
			x = -1
			:store(x,m)
			m = m + 1
			f = 0 # set match flag
			:if(d){
				:raw("DECL ")
			}
		} else {
			y = x == 1 # any assignment
			z = i + 1
			:load(x,z) # load id
			x = x == 0 # =
			y = y & x
			:if(y){ # type ident = 
				i = i + 4
				n = m - 5 # save type location
				f = 1
				:call(syntax_isExpression)
				y = f == 0 # match found
				:load(x,i)
				x = x == 22 # ;
				y = y & x
				:if(y){ # type ident = expr ;
					i = i + 4
					x = 0
					:store(x,m)
					m = m + 1
					:store(n,m) # type location was saved in n
					m = m + 1
					x = m - 7 # last cell (5) and the 2 we just added
					:store(x,m)
					m = m + 1
					:store(l,m)
					m = m + 1
					x = -1
					:store(x,m)
					m = m + 1
					:if(d){
						:raw("INIT ")
					}
				} else {
					f = 1 # no match
				}
			} else {
				f = 1 # no match
			}
		}
	} else {
		f = 1 # no match
	}
}
{{< /highlight >}}

The example I chose is not the simplest, but its also far from the most complicated one. It handles variable declarations, which can be either `type name;` or `type name = expression;`. Lets break it down:
- on line `2-3`, `syntax_isType` is invoked and checked for success. If a type was found, it will have been written in the previous memory entry (each entry = 5 cells). It also updates the token index **i**, which points at the next token to be processed.
- next (lines `5-7`), it checks if the next token is an identifier (variable name).
- lines `9-11` move the token index, and check whether its just a declaration. If so, lines `13-31` move the token index and store the necessary cells in memory.
- if not, lines `33-38` confirm its an initialization, and continue to parse the initializer expression (`40-43`).
- if the syntax of the initialization is correct (`44-47`), the initialization is written into memory (`48-65`). In this case, the it writes:
    - 0 (*declaration*)
    - type location
    - -1 or expression location
    - identifier location 

---

### Example

Again we can take a look at the *hello world* example.

{{< highlight c >}}
// Hello world
int write(int fd, char* cbuf, int count);

void main(){
	write(1,"Hello world!\n",13);
}
{{< /highlight >}}

```
PAR PAR PAR FUNDECL const const const call const const const call EXP FUN 

Expressions:
    EXP[ CALL(write)[ 1, 80, 13,  ] ] 
Types:
    FUN [ int ] PAR [ int ] PAR [ ptr(char) ] PAR [ int ] FUN [ void ]
```

Lets take a look at the first line, which contains debug logs during parsing:
- `PAR PAR PAR FUNDECL` is correctly identified as a function declaration
- but then `const const const call` repeats twice, even though there is only one function call in the program. This is because the compiler first tries to match an assignment (`expr = expr` or one of the other assignment operators), fails, and tries again later with an expression statement (`expr;`), which is successful.
- at the end `FUN` is output, because it was a normal function definition.

The post parsing printout is more consise, but might not always be present, if the compiler exits with some error beforehand.