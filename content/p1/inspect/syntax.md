---
title: "Parsed syntax"
date: 2023-03-01
draft: false
weight: 30
---

For inspecting the syntax memory entries, a gdb macro was written for convenience (to format the output of syntax analysis into 5 columns and also print memory offsets instead of addresses). You can find this macro in [xmem](https://github.com/MrTipson/compiler/blob/master/xmem).

Similar to the tokens, you can find more info about the structure of syntax entries in the [docs](https://github.com/MrTipson/compiler/blob/master/docs/syntax.md).

{{< highlight bash >}}
# first, we load the macro
(gdb) source xmem

# then execute it
(gdb) xmem

272:    1    3    0    0    0         # type(3=void)
277:    3  272  120    2  317         # function(272=type,120=ident,2=startdecl)
282:    1    1    0    0    0         # type(1=char)
287:    1    5  282    0    0         # type(5=ptr,282=basetype)
292:    4  287  136    0   -1         # parameter(287=type,136=identifier)
297:    1    0    0    0    0         # type(0=int)
302:    4  297  148    0   -1         # parameter(297=type,148=identifier)
307:    1    0    0    0    0         # type(0=int)
312:    4  307  160    0   -1         # parameter(type=307,160=identifier)
317:    3    0    0    1    0         # function(1=end)
322:    1    3    0    0    0         # type(3=void)
327:    3  322  176    0  412         # function(322=type,176=identifier,0=start)
332:    1    0    0    0    0         # type(0=int)
337:    2   23  204    0    0         # expression(23=const,204=value)
342:    2   23  212    0    0         # expression(23=const,212=value)
347:    2   23  220    0    0         # expression (23=const,220=value)
352:    2    7  342  347    0         # expression(7=*,342=expr1,347=expr2)
357:    2   10  337  352    0         # expression(10=+,337=expr1,352=expr2)
362:    0  332  357  196   -1         # declcaration(332=type,357=expression,196=identifier)
367:   10    0  228    0    0         # call(0=start,228=identifier)
372:    2   23  236    0    0         # expression(23=const,236=value)
377:   11  372    0    0    0         # argument(372=expression)
382:    2   22  244    0    0         # expression(22=identifier,244=identifier)
387:   11  382    0    0    0         # argument(382=expression)         
392:    2   23  252    0    0         # expression(23=const,252=value)
397:   11  392    0    0    0         # argument(392=expression)    
402:   10    1    0  367    0         # call(1=end,367=start)
407:    6  402    0    0    0         # expression statement (402=expression)
412:    3    0    0    1    0         # function(1=end)
{{< /highlight >}}