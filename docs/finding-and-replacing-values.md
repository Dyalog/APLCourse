# Finding and Replacing Values

## Searching and finding
It is common to make multiple equality comparisons. Doing this one at a time becomes tedious.

```APL
      text ← 'This is my sentence'
      (text='a')∨(text='e')∨(text='i')∨(text='o')∨(text='u')
```
```
0 0 1 0 0 1 0 0 0 0 0 0 1 0 0 1 0 0 1
```

The <dfn>membership</dfn> function returns a Boolean array (`1`s and `0`s) of the same shape as `⍺` where `1` indicates the location of any of the elements in `⍵`.

```APL
      text∊'aeiou'
```
```
0 0 1 0 0 1 0 0 0 0 0 0 1 0 0 1 0 0 1
```
---
```APL
      text ← 2 6⍴'I LIKE APL  '
      text∊'AEIOU'
```
```
1 0 0 1 0 1
0 1 0 0 0 0
```

<dfn>Find</dfn> `⍺⍷⍵` will give a `1` indicating the location of the first element of `⍺` when the entire array `⍺` is found as a subarray in `⍵`.

```APL
      y ← 2 10⍴'APPLESLESSMOTIONSLOW'
      'LESS'⍷y
```
```
0 0 0 0 0 0 1 0 0 0
0 0 0 0 0 0 0 0 0 0
```
---
```APL
      'LESION'⍷y
```
```
0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0
```
---
```APL
      (2 3⍴'LESION')⍷y
```
```
0 0 0 1 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0
```

<dfn>Index of</dfn> `⍺⍳⍵` will return the index in `⍺` where `⍵` is found as a major cell.

```APL
      text ← 2 3 4⍴'SOME APPLES'
      text∊'LESS'
```
```
1 0 0 1
0 0 0 0
1 1 1 1

0 0 1 0
0 0 0 1
1 1 1 0
```
---
```APL
      'LESS'⍷text
```
```
0 0 0 0
0 0 0 0
1 0 0 0

0 0 0 0
0 0 0 0
0 0 0 0
```
---
```APL
      (1⌷text)⍳'LESS'
```
```
3
```

For subarrays not found in `⍺`, index-of returns `1+≢⍺`.

```APL
      'keep'⍳'qwert'
5 5 2 5 5
```

## Sorting and grouping
To <dfn>sort</dfn>, index by the <dfn>grade</dfn>.

```APL
      Sort←{(⊂⍋⍵)⌷⍵}
      Sort 'the alphabet'
```
```
 aabeehhlptt
```

Grouping is an incredibly common operation when handling data. The python "dataframe" framework Pandas [has a groupby function](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.groupby.html) and anybody who has used SQL [is likely to be familiar with this idea](https://www.w3schools.com/sql/sql_groupby.asp).

The <dfn>key</dfn> operator applies its operand function to groups of [major cells](./cells-and-axes.md) corresponding to the unique major cells in `⍵`. For a vector, this is the unique list of elements.

In the monadic case, `⍵` is a list of indices.

```APL
      {⍺,⊂⍵}⌸'mississippi'
┌─┬────────┐
│m│1       │
├─┼────────┤
│i│2 5 8 11│
├─┼────────┤
│s│3 4 6 7 │
├─┼────────┤
│p│9 10    │
└─┴────────┘
```

In the dyadic case, it is a list of keys which are provided as `⍺`.

```APL
      ↑'ABBDDDCDBAA' 'mississippi'
ABBDDDCDBAA
mississippi

      'ABBDDDCDBAA'{⍺,⊂⍵}⌸'mississippi'
┌─┬────┐
│A│mpi │
├─┼────┤
│B│isp │
├─┼────┤
│D│sisi│
├─┼────┤
│C│s   │
└─┴────┘
```

<dfn>Interval index</dfn> is a function for classifying data by boundaries.

See if you can write the `Grade` function from [problem set 3, problem 6](./array-logic-data-driven-conditionals.md#problem-set-3) using **interval index** `⍺⍸⍵`.

???Example "Answer"
	
	```APL
	Grade ← {'FDCBA'[0 65 70 80 90⍸⍵]}
	```

## Set functions
Those familiar with set theory from traditional mathematics will recognise the following symbols. The APL functions are closely related to their set theory counterparts.

The <dfn>union</dfn> of two vectors contains elements from `⍺` catenated with elements in `⍵` not found in `⍺`.

```APL
      'WASH' ∪ 'SHOUT'
WASHOUT
```

The <dfn>intersection</dfn> contains elements only found in both.

```APL
      'WASH' ∩ 'SHOUT'
SH
```

The function <dfn>without</dfn> removes elements from `⍺` which are found in `⍵`.

The set difference is then neatly expressed as [a fork](./Ufns.md#the-three-function-styles) of the union without the intersection.

```APL
      'WASH' (∪~∩) 'SHOUT'
WAOUT
```

## Assigning to arrays

### Indexed Assignment
Assign values at specified indices.

```APL
t←4 4⍴'some sample text'
t[⍸t∊'aeiou']←'!'
```

### Selective Assignment
Most ways of [selecting from arrays](./selecting-from-arrays.md) can be used to change values in an array. Here is an example using **compress**:

```APL
      a ← 2 3⍴⎕A
      (1 0⌿a)←'⌺'
      a
```
```
⌺⌺⌺
DEF
```

### Modified Assignment
Experiment with the following expressions, paying particular attention to the `name f← array` construct.

```APL
salaries←18250 42500 56000 57250 48640
codes←'ACDDC'
salaries×←1.1
salaries[⍸codes='C']×←1.0

a←⎕A
(3↑a),←'abcd'
```

### The At operator
Monadic functions take a single right argument array as input. Dyadic functions take two argument arrays.

Monadic operators take a single left operand which can be a function or an array (as in `+/` where plus `+` is the function operand and reduce `/` is the operator). 

Dyadic operators take two operands which could be functions or arrays depending on the operator's definition. For example, the [rank operator](./cells-and-axes.md#the-rank-operator) `F⍤k` takes a function left operand `F` and array right operand vector `k` of up to 3 elements.

Selective and indexed assignment methods will change the values of variables. The "at" operator `@` merges two arrays at specified indices and returns a new array.

If a function right operand returns a boolean array when applied to `⍵` (e.g. `3=1 3 5`) then ones `1` in the boolean array determine where scalars of `⍺` are inserted.

```APL
      ('∆⍥'@{⍵∊'AEIOU'})2 3⍴'DYALOG'
```
```
DY∆
L⍥G
```
---
```APL
      (' '@2 3 4)'DYALOG'
```
```
D   OG
```
---
```APL
      (' '@(1 2)(1 3)(2 1))2 3⍴'DYALOG'
```
```
D  
 OG
```

Generally, the left operand to `@` is a function applied to scalars in `⍵` which are specified by a right operand that is either an array of scalar (simple or enclosed vector) indices or a boolean array returned by a right operand function. An array left operand is shorthand for a [constant function](https://aplwiki.com/wiki/Constant) that returns the array.

```APL
      Upper ← 1∘⎕C
      {Upper@{¯1⌽' '=⍵}' ',⍵}'my excellent heading'
 My Excellent Heading
```

### Strand Assignment
[**Distributed assignment**](http://help.dyalog.com/latest/#Language/Introduction/Namespaces/Distributed Assignment.htm) or **strand assignment** allows multiple names to be defined using a single assignment arrow `←`.

```APL
      (max min avg)←{(⌈⌿⍵)(⌊⌿⍵)((+⌿÷≢)⍵)}3 1 4 1 5
```

!!! Note
	Strand assignment does not require names to be parenthesised, but we strongly recommend it for clarity.

We can assign items in `nest` to the three variables `s←'A'` `v←1 2 3` and `m←3 3⍴⍳9` using a single assignment arrow.

```APL
      nest←('A'(1 2 3))(3 3⍴⍳9)
      ((s v) m)←nest
```

!!! Warning
	You might have some issues when using inline, modified or strand assignment in dfns. This is by design, but can be a source of confusion.
	```APL
	      { a←3 ⋄ f←+ ⋄ a f←3 ⋄ a }⍬
	3
	      a←3 ⋄ f←+ ⋄ a f←3 ⋄ a
	6
	```
	
	You can get around these problems by writing `∘⊢` to the immediate right of any function involved:
	```APL
	      { a←3 ⋄ f←+ ⋄ a f∘⊢←3 ⋄ a }⍬
	6
	```

	You might find it best to simply keep the modification explicit:
	```APL
	      { a←3 ⋄ f←+ ⋄ a←a+3 ⋄ a }⍬
	6
	```

## Problem set 6

1. Write a function test if there are any vowels `'aeiou'` in text vector `⍵`

	```APL
	      AnyVowels 'this text is made of characters'
	```
	```
	1
	```
	---
	```APL
	      AnyVowels 'bgxkz'
	```
	```
	0
	```

	???Example "Answer"
		We can use membership to see which elements of our argument belong to the set `'aeiou'`. Then we can then ask if there are any `1`s in the Boolean vector:
	
		```APL
		AnyVowels ← {∨/⍵∊'aeiou'}
		```

		An easy eay to check for any ones in a high rank Boolean array is to use membership:

		```APL
		AnyVowels ← {1∊⍵∊'aeiou'}
		```

1. Write a function to count the number of vowels in its character vector argument `⍵`

	```APL
	      CountVowels 'this text is made of characters'
	```
	```
	9
	```
	---
	```APL
	      CountVowels 'we have twelve vowels in this sentence'
	```
	```
	12
	```

	???Example "Answer"
		Counting the `1`s in the Boolean result of membership `⍺∊⍵` counts the vowels.

		```APL
		CountVowels ← {+/⍵∊'aeiou'}
		```

1. Write a function `FoundIn` which accepts a nested scalar or vector of character vectors and returns a `1` where each vector contains letters in the simple character vector `⍺`.

	```APL
	      'ei' FoundIn 'Katie' 'Bob' 'Stephen' 'Jessica' 'Andy'
	```
	```
	1 0 1 1 0
	```

	???Example "Answer"
		One solution is to bind `⍺` to the membership function (`∊∘⍺`) to form a monadic function "contains alpha" which can be applied on each vector in our nested argument.

		```APL
		FoundIn ← {∨/¨∊∘⍺¨⍵}
		```

1. Write a function `Clean` that changes all non-digits into stars.

	```APL
	      Clean 'Easy as 1, 2 and 3'
	```
	```
	********1**2*****3
	```
	---
	```APL
	      Clean '1000'
	```
	```
	1000
	```
	---
	```APL
	      Clean 'APL works!'
	```
	```
	**********
	```

	???Example "Answer"
		We cannot assign to `⍵` in a dfn, so we must create an intermediate variable name:
		
		```APL
		 Clean ← {
		    r←⍵ ⋄ d←~⍵∊⎕D
		    (d/r)←'*'
		    r
		 }
		```

		We can provide a function right operand to the **at** operator which checks for non-digits:

		```APL
		Clean ← '*'@(~∊∘⎕D)
		```

1. The following expression contains an error:  

	```APL
	      ('∆⍥'@1)2 3⍴'DYALOG'
	```
	```
	LENGTH ERROR
	      ('∆⍥'@1)2 3⍴'DYALOG'
	      ∧
	```

	Change the parenthesised function containing `@` so that it gives the following results:  

	1. 

		```
		∆∆∆
		LOG
		```

	1. 

		```
		∆∆∆
		⍥⍥⍥
		```

	???Example "Answers"

		<ol type="a">
		<li>

		```APL
		      ('∆'@1)2 3⍴'DYALOG'
		```
		```
		∆∆∆
		LOG
		```

		</li>
		<li>

		```APL
		      ((2 3⍴3/'∆⍥')@1 2)2 3⍴'DYALOG'
		```
		```
		∆∆∆
		⍥⍥⍥
		```

		</li>
		</ol>

1. Create a function `ReplaceHead` which returns its left argument vector `⍺`, but with the first `⍴⍵` elements replaced with the contents of `⍵`.

	```APL
	      'apple' ReplaceHead 'Eat'
	```
	```
	Eatle
	```
	---
	```APL
	      'apple' ReplaceHead 'rang'
	```
	```
	range
	```
	---
	```APL
	      'apple' ReplaceHead 'ENTERPRISE'
	```
	```
	ENTER
	```

	???Example "Answers"
		This solution uses indexed assignment:

		```APL
		ReplaceHead ← {r←⍺ ⋄ s←(≢⍺)⌊≢⍵ ⋄ r[⍳s]←s↑⍵ ⋄ r}
		```

		This solution uses the **over** operator `F⍥G` to express the minimum length of `⍺` and `⍵`. It then uses the **at** operator to do the substitution.

		```APL
		ReplaceHead ← {s←⍺⌊⍥≢⍵ ⋄ (s↑⍵)@(⍳s)⊢⍺}
		```

1. Bus stops in a town are labelled **A** to **E**. Define a function RouteMatrix which returns a Boolean matrix where `1`s indicate that buses go from one bus stop to the next.

	```APL
	      RouteMatrix 'BE' 'C' 'AE' 'BCE' 'A'
	```
	```
	0 0 1 0 1
	1 0 0 1 0
	0 1 0 1 0
	0 0 0 0 0
	1 0 1 1 0
	```
	---
	```APL
	      'ABCDE'⍪RouteMatrix 'C' 'CDE' 'ABDE' 'E' 'B'
	```
	```
	A B C D E
	0 0 1 0 0
	0 0 1 0 1
	1 1 0 0 0
	0 1 1 0 0
	0 1 1 1 0
	```

	???Example "Answer"
		```APL
		RouteMatrix ← {'ABCDE'∘.∊⍵}
		```
