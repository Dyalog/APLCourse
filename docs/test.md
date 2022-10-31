# Test
This is a page to test and demonstrate page elements. Some notes refer to the formatting of the markdown source.

## Code input
???+ Note "Okay"
	```APL
	      1 2 3
	```
	```
	1 2 3
	```
	---
	```
	      4 5 6
	```
	```
	4 5 6
	```
	---
	```
	⍝ no output needs empty block after
	```
	```
	```

1. Some stuff
1. Code blocks in a list require a blank line above and below

	```APL
	      1 2 3
	```
	```
	1 2 3
	```
	---
	```APL
	      4 5 6
	```
	```
	4 5 6
	```

1. And another thing

Output with low characters followed by input.

```APL
      '⍝ Low Ɽ'
```
```
⍝ Low Ɽ
```
---
```APL
      'HHH'
```
```
HHH
```
---
```APL
      1 2 3 + 4 5 6
```
```
5 7 9
```
---
```APL
      'nested' 'vectors'
```
```
┌──────┬───────┐
│nested│vectors│
└──────┴───────┘
```
---
```APL
      3 3⍴⍳9
```
```
1 2 3
4 5 6
7 8 9
```

Text between code blocks must be surrounded by a blank line above and below.

```APL
      2 3⍴,¨'APL'   ⍝ Low Ɽ
```
```
┌─┬─┬─┐
│A│P│L│
├─┼─┼─┤
│A│P│L│
└─┴─┴─┘
```
