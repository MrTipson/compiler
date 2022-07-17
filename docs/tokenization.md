# Tokenization
Token | Type | ID | Optional
---- | ----------- | ------- | -
int | 0 | 0 | -
char | 0 | 1 | -
bool | 0 | 2 | -
void | 0 | 3 | -
if | 1 | 0 | -
else | 1 | 1 | -
while | 1 | 2 | -
*identifier* | 2 | start | length
constant(int) | 3 | 0 | value
constant(char) | 3 | 1 | value
constant(boolean) | 3 | 2 | value
constant(string) | 3 | 3 | start