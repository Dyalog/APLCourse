# Finding and replacing values

## Searching and finding
It is common to make multiple equality comparisons. Doing this one at a time becomes tedious.

```APL
      text ← 'This is my sentence'
      (text='a')∨(text='e')∨(text='i')∨(text='o')∨(text='u')
```
```
0 0 1 0 0 1 0 0 0 0 0 0 1 0 0 1 0 0 1
```

The <dfn>membership</dfn> function returns a Boolean array (`1`s and `0`s) of the same shape as `⍺` where a `1` indicates the location of any one of the elements in `⍵`.

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
      'IONLESS'⍷y
0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0
      'NOW'⍷y
0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 1 0 0
      (2 3⍴'APPLES')⍷y
1 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0
```

<dfn>Index of</dfn> `⍺⍳⍵` will return the index in `⍺` where `⍵` is found as a major cell.

```APL
      text ← 2 3 4⍴'SOME APPLES'
      text∊'LESS'
1 0 0 1
0 0 0 0
1 1 1 1

0 0 1 0
0 0 0 1
1 1 1 0
      'LESS'⍷text
0 0 0 0
0 0 0 0
1 0 0 0

0 0 0 0
0 0 0 0
0 0 0 0
      (1⌷text)⍳'LESS'
3
```

For subarrays not found in `⍺`, index-of returns `1+≢⍺`.

```APL
      'keep'⍳'qwert'
5 5 2 5 5
```

## Sorting and grouping
To sort, index by the <dfn>grade</dfn>.

```APL
      Sort←{(⊂⍋⍵)⌷⍵}
      Sort 'the alphabet'
```

Grouping is an incredibly common operation when handling data. The python "dataframe" framework Pandas [has a groupby function](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.groupby.html) and anybody who has used SQL [is likely to be familiar with this idea](https://www.w3schools.com/sql/sql_groupby.asp).

The <df>key</dfn> operator applies its operand function to groups of [major cells](./array-model.md#cells-and-axes) corresponding to the unique major cells in `⍵`. For a vector, this is the unique list of elements.

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

At this point it is worth reminding yourself about APL constructs which perform similar functionality to key and interval index.

1. You already wrote Interval Index [in problem set N](./array-logic-data-driven-conditionals.md#problem-set) using the outer product `∘.F`. See if you can rewrite that `Grade` function using **interval index** `⍺⍸⍵`.

	???Example "Answer"
		```APL
		Grade ← {'FDCBA'[0 65 70 80 90⍸⍵]}
		```

1. Write the interval index function `⍺⍸⍵` for two vectors without using the `⍸` glyph

	???Example "Answer"
		```APL
		IntervalIndex ← {+⌿⍺∘.≤⍵}
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
Define `n←5 5⍴⍳25` in your workspace.

1. Using selections, find at least four different ways to set the bottom-right 3 by 3 submatrix in `n` to `0`.
	For example, `(2 2↓n)←0`.

	??? Hint
		See which primitives may be used in a <a href='http://help.dyalog.com/latest/#Language/Primitive%20Functions/Assignment%20Selective.htm?Highlight=selective%20assignment'>selective assignment</a>

	???+Example "Answers"
		Compute the indices:
		
		```APL
		n[2+⍳3;2+⍳3]←0
		```

		Use negative take:

		```APL
		(¯3 ¯3↑n)←0
		```

		Use two compressions:

		```APL
		b←2 3/0 1
		(b/b⌿n)←0
		```

		


### Modified Assignment
Experiment with the following expressions, paying particular attention to the `name f← array` construct.

```APL
      salaries←18250 42500 56000 57250 48640
      codes←'ACDDC'
      salaries×←1.1
      salaries[⍸codes='C']×←1.05

      a←⎕A
      (3↑a),←'abcd'
```

### The At operator

Monadic functions take a single right argument array as input. Dyadic functions take two argument arrays.

Monadic operators take a single left operand which can be a function or an array (as in `+/` where plus `+` is the function operand and reduce `/` is the operator). 

Dyadic operators take two operands which could be functions or arrays depending on the operator's definition. For example, the [rank operator](./array-model.md#matching-dimensions) `F⍤k` takes a function left operand `F` and array right operand `k` of up to 3 elements.

Selective and indexed assignment methods will change the values of variables. The "at" operator `@` merges two arrays at specified indices and returns a new array.

If a function right operand returns a boolean array when applied to `⍵` (e.g. `3=1 3 5`) then ones `1` in the boolean array determine where scalars of `⍺` are inserted.

```APL
      ('∆⍥'@{⍵∊'AEIOU'})2 3⍴'DYALOG'
      (' '@2 3 4)'DYALOG'
      (' '@(1 2)(1 3)(2 1))2 3⍴'DYALOG'
```

1. The following expression contains an error:  
	`      ('∆⍥'@1)2 3⍴'DYALOG'`  
	Change the parenthesised function containing `@` in **two** ways so that it gives the following results:  
	1. 
		<pre><code>∆∆∆
		LOG</code></pre>  
	1. 
		<pre><code>∆∆∆
		⍥⍥⍥</code></pre>

Generally, the left operand to `@` is a function applied to scalars in `⍵` which are specified by a right operand that is either an array of scalar (simple or enclosed vector) indices or a boolean array returned by a right operand function. An array left operand is shorthand for a [constant function](https://aplwiki.com/wiki/Constant) that returns the array.

```APL
      {1↓(1∘(819⌶)@{¯1⌽' '=⍵})' ',⍵}'my excellent heading'
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

## Problem set
### Word Problems

We are going to do some text processing on a dictionary of words. 

If you have access to the internet, the following expressions will download a text file dictionary (917kB in size) and store it as a nested vector of character vectors named `words`.

```APL
      ]Load HttpCommand
      words ← (⎕UCS 10) {(⍺≠⍵)⊆⍵} (HttpCommand.Get'https://tinyurl.com/y7asendy').Data
```

If you have the file on your computer (maybe you were given it on a USB drive, for example) then you can load it into your workspace from disk using the following expressions.

```APL
      (content encoding newline) ← ⎕NGET'/path/to/words.txt'
      words ← (⎕UCS newline) (≠⊆⊢) content
```

Now answer the following questions about `words`.

1. How many words have at least 3 `'e'`s in them?

1. How many words have exactly two consecutive `'e'`s in them? 
    The first three such words are `Aberdeen` `Abderdeen's` and `Aileen`.

1. What is the shortest word with two consecutive `'a'`s?

1. What words have three consecutive double letters? For example, `mississippi` does not but `misseetto` does. Misseetto is not a real word.

	A palindrome is the same when reversed. For example, **racecar** is a palindrome but **racecat** is not.

1. How many palindromes are there in `words`?

1. Which palindrome in `words` is the longest?

1. How many words are in alphabetical order?

---

1. Analysing text

	1. Write a function test if there are any vowels `'aeiou'` in text vector `⍵`

		```APL
		      AnyVowels 'this text is made of characters'
		1
		      AnyVowels 'bgxkz'
		0
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

	???Example "Answers"
		<ol type="a">
		<li>
		We can use membership to see which elements of our argument belong to the set `'aeiou'`. Then we can use membership to check whether `1` exists in the resulting Boolean array.
		
		```APL
		AnyVowels ← {1∊⍵∊'aeiou'}
		```

		</li>
		<li>

		Counting the `1`s in the Boolean result of the first membership function counts the vowels.

		```APL
		CountVowels ← {+/⍵∊'aeiou'}
		```

		</li>
		</ol>

1. Write a function `Clean` that changes all non-digits into stars.
	```APL
	      Clean 'Easy as 1, 2 and 3'
	********1**2*****3
	      Clean '1000'
	1000
	      Clean 'APL works!'
	**********
	```

	???+Example "Answer"
		```APL
		 Clean ← {
		    r←⍵ ⋄ d←~⍵∊⎕D
		    (d/r)←'*'
		    r
		 }
		```

1. Write a function to convert a character vector into upper case. Assume text consists of only lowercase alphabetic characters `a-z` and spaces.
	```APL
		  ToUpper 'sale on now'
	SALE ON NOW
	```

	???+Example "Answer"
		```APL
		alph ← 'abcdefghijklmnopqrstuvwxyz'
		ToUpper ← {(⎕A,' ')[⍺⍳⍵]}
		```

		This is a useful technique to know, but there is a [system function]() `⎕C` for case folding and mapping. The case conversion system function `⎕C` is covered in the webinar [Language Features of Dyalog version 18.0 in Depth - Part 1](https://dyalog.tv/Webinar/?v=Hln3zryunsw).

1. Now try a version which includes any characters. Convert only lowercase alphabetic characters `a-z` into uppercase, and leave all others alone.
	```APL
	      text←'What? Ignore these $#!?# characters!?'
	      your_expression
	      text
	WHAT? IGNORE THESE $#!?# CHARACTERS!?
	```

`((text∊alph)/text)←(⎕A,' ')[(text∊alph)/alph⍳text]`

1. Create a function `ReplaceHead` which returns its left argument vector `⍺`, but with the first `⍴⍵` elements replaced with the contents of `⍵`.
	```APL
	      'apple' ReplaceHead 'Eat'
	Eatle
	      'apple' ReplaceHead 'rang'
	range
	      'apple' ReplaceHead 'ENTERPRISE'
	ENTER
	```

`ReplaceHead ← {r←⍺ ⋄ s←(≢⍺)⌊≢⍵ ⋄ r[⍳s]←s↑⍵ ⋄ r}`

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


	- SplitOnFirst
	- ReplaceRow

1. Broken keyboard unique

	Write the **unique** function `∪⍵` without using the **downshoe** `∪` glyph.

	???+Example "Answers"
		Index-of returns the index of the first occurance of an element. For `⍵⍳⍵`, this becomes a list of integer ID numbers which correspond to major cells as they appear.
	((⍳≢text)=text⍳text)/text