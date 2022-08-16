## Description of target language (.p1)
### Tokens
Constants:
 - boolean (**true**, **false**)
 - integer (values 0..2^31-1 without leading zeroes)
 - character (one ascii 32..126) enclosed in ''. ' literal must be escaped.
 - string (any ascii 32..126) enclosed in "". " literal must be escaped.
 - pointer (**null**)

Keywords:\
**int**, **char**, **bool**, **void**, **if**, **else**, **while**, **return**, **struct**, **sizeof**

Identifiers:\
[A-Za-z0-9_]+ that doesnt start with a digit, is not keyword

Comment:
 - anything that starts with **//**, lasts till end of line
 - anything that starts with **/\***, lasts till ***/**

### Syntax
prg -> *{* vardecl | typedecl | fundecl *}*

vardecl -> type identifier *[* **=** const *]* **;**\
typedecl -> **struct** identifier **{** *{* param **;** *}* **}**\
fundecl -> type identifier **(** *[* param *{* **,** param *}* *]* **)** **;**\
fundecl -> type identifier **(** *[* param *{* **,** param *}* *]* **)** **{** *{* stmt *}* **}**

param -> type identifier

type -> void | char | int | bool\
type -> identifier\
type -> type **[** const **]**\
type -> type **\***

stmt -> expr **;**\
stmt -> expr *(* **=** | **+=** | **-=** | **/=** | **\*=** *)* expr **;**\
stmt -> **if** **(** expr **)** *(* stmt | **{** *{* stmt *}* **}** *)* *[* **else** *(* stmt | **{** *{* stmt *}* **}** *)* *]*\
stmt -> **while** **(** expr **)** *(* stmt | **{** *{* stmt *}* **}** *)*
> the complications above (in the if and while clauses) are because there doesnt exist a production 'stmt -> **{** *{* stmt *}* **}**

expr -> const\
expr -> identifier\
expr -> identifier **(** *[* expr *{* **,** expr *}* *]* **)**\
expr -> **(** type **)** expr\
expr -> **(** expr **)**\
expr -> expr *(* **&** | **|** | **&&** | **||** | **==** | **!=** | **<** | **>** | **<=** | **>=** | **\*** | **/** | **%** | **+** | **-** | **^** *)* expr\
expr -> *(* **!** | **+** | **-** | **&** | **\*** | **++** | **--** | **~** *)* expr\
expr -> expr *(* **[** expr **]** | **++** | **--** | **.** identifier | **->** identifier *)*\
expr -> **sizeof** **(** type **)**

### Implementation notes
Various notes regarding the implementation and memory layout during compilation can be found in [tokenization](tokenization.md), [syntax](syntax.md), [semantics](semantics.md) and [memory](memory.md).
