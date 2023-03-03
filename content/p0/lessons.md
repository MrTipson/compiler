---
title: "Lessons"
date: 2023-02-16
draft: false
weight: 40
---

It is very important that correct choices are made when considering tradeoffs between the initial workload of building the bootstrap compiler and the ease of use of the defined language.

While I believe that there were no terrible choices, there were plenty of things that could be improved, such as:
- code organization
> This one definately stems from my inexperience with the assembly language. There was nothing preventing me from organizing the code better and perhaps into multiple files. Also, there are some parts that were patched in later and the resulting code is not very clear.
- variable limitations
> I thought that variables a-z were gonna be fine, but it ended up being quite confusing. I don't think it would've been too difficult to setup some system of keeping track of used variables and appending them into the data segment.
- expression limitations
> At first glance, it doesn't seem too bad, but when it came to actually using them, they ended up being too verbose. Using postfix notation (and ignoring priority) would have provided more flexibility while keeping the same complexity (implementing postfix notation using the stack is trivial).
- multi file support
> I'm not too sure about this one, but I could have possibly made it so some directive would prevent the bootstrap compiler from generating an entry point, and set the labels in the data segment as extern. This would have helped keep down the size of the stage 1 compiler.
- if cascades
> This might have also been too much to ask, but allowing expressions inside if statements and allowing `else if` would have prevented some of the *pyramids of doom* that will come up.
---

Not everything was bad though, functions, loops, i/o and memory were all good enough, and bacame second nature after getting used to the syntax.