---
title: "Lexical analysis"
date: 2023-02-17
draft: false
weight: 10
---

Before the lexical analysis actually starts, the compiler first reads the input program from **stdin** into memory.

---

### Purpose

The purpose of lexical analysis is to break up the input program into tokens (groups of characters with attached meaning), for example:
- keywords (type names, if, while, ...)
- identifiers (variable, parameter names)
- constants
- symbols ( *(* , *)* , ... , operators)
- comments/whitespace (which are skipped)

Another purpose is to catch some early errors (malformed string/character constants, invalid escape sequences).

For a list of all possible tokens and how their memory entries look like, check out the [docs](https://github.com/MrTipson/compiler/blob/master/docs/tokenization.md).

---

### Implementation snippet

Lets look at an example (from the actual implementation) of how a token is parsed:

{{< highlight python >}}
:fun(tokenize_isKeyword_bool){
	x = t # 5th character should be non-identifier
	:call(tokenize_isKeyword_helper) # y contains result
	x = p == 98 # b
	y = y & x
	x = q == 111 # o
	y = y & x
	x = r == 111 # o
	y = y & x
	x = s == 108 # l
	y = y & x
	:if(y){ # match
		f = 0 # set match flag
		x = 0 # type 0
		:store(x,m)
		m = m + 1
		x = 2 # id 2 (bool)
		:store(x,m)
		m = m + 2 # skip optional field
		x = l # line number
		:store(x,m)
		m = m + 1 
		i = i - 1
		:if(d){
			:raw("BOOL ")
		}
	}
}
{{< /highlight >}}

We can notice that this is quite cumbersome due to:
- there is no simple way of comparing strings
- expressions take up unnecessary space
- writing into memory is very verbose
> And this had to be done for every. single. keyword.
---

### Example

We can observe the debug output of how the *hello world* program gets tokenized.

{{< highlight c >}}
// Hello world
int write(int fd, char* cbuf, int count);

void main(){
	write(1,"Hello world!\n",13);
}
{{< /highlight >}}


`INT IDENT(write) LPARENT INT IDENT(fd) COMMA CHAR MUL IDENT(cbuf) COMMA INT IDENT(count) RPARENT SEMICOLON VOID IDENT(main) LPARENT RPARENT LCURLY IDENT(write) LPARENT CINT(1) COMMA CSTRING("Hello world!\n") COMMA CINT(13) RPARENT SEMICOLON RCURLY`