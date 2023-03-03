---
title: "Memory assignment"
date: 2023-03-01
draft: false
weight: 50
---

{{< highlight bash >}}
272:    1    3    0    0    0 
277:    3  272  120    2  317       # declaration of function printf
282:    1    1    0    0    0 
287:    1    5  282    0    0 
292:    4  287  136    0    4       # parameter 1 (offset=4)
297:    1    0    0    0    0 
302:    4  297  148    0    8       # parameter 2 (offset=8)
307:    1    0    0    0    0 
312:    4  307  160    0   12       # parameter 3 (offset=12)
317:    3    0   20    1   12       # end of function (size=20)
322:    1    3    0    0    0 
327:    3  322  176    0  412       # definition of function main
332:    1    0    0    0    0 
337:    2   23  204    0  417 
342:    2   23  212    0  423 
347:    2   23  220    0  429 
352:    2    7  342  347  429 
357:    2   10  337  352  417 
362:    0  332  357  196    4       # variable x (offset=4)
...
412:    3    0   12    1    0       # end of function (size=12)
{{< /highlight >}}

There are a couple of observations we can make. The main one is that the offsets do not start at 0. Since the stack grows 'downwards' (i.e. from higher to lower memory addresses), starting writing at offset 0 would overwrite *size* bytes of the previous function.