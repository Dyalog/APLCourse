# Array logic and data-driven conditionals

## Logic and conditions
APL has logical and comparison functions as in-built primitives. Much like the arithmetic, these are symbols like those used in conventional notation.

<div class="center language-APL" markdown="span">
<div class="displayBox" markdown="span">
<a class="glyph" title="Less than">`<`</a>
<a class="glyph" title="Less than or equal to">`≤`</a>
<a class="glyph" title="Equals">`=`</a>
<a class="glyph" title="Not equals">`≠`</a>
<a class="glyph" title="Greater than or equal to">`≥`</a>
<a class="glyph" title="Greater than">`>`</a>
<a class="glyph" title="Logical AND">`∧`</a>
<a class="glyph" title="Logical OR">`∨`</a>
<a class="glyph" title="Logical NAND">`⍲`</a>
<a class="glyph" title="Logical NOR">`⍱`</a>
<a class="glyph" title="Logical NOT">`~`</a>
</div>
</div>

Some of these are more general mathematical functions which happen to reduce to logical functions when used with Booeleans:

```APL
      3 ∧ 4               ⍝ Lowest common multiple
```
```
12
```
---
```APL
      0 1 0 1 ∧ 0 0 1 1   ⍝ Logical AND
```
```
0 0 0 1
```
---
```APL
      12 ∨ 16             ⍝ Greatest common divisor
```
```
4
```
---
```APL
      0 1 0 1 ∨ 0 0 1 1   ⍝ Logical OR
```
```
0 1 1 1
```
---
```APL
      'X' ≠ 'X'           ⍝ Not equal to
```
```
0
```
---
```APL
      0 1 0 1 ≠ 0 0 1 1   ⍝ Logical XOR 
```
```
0 1 1 0
```

!!!Info
	The [16 possible logic functions for two binary variables](https://en.wikipedia.org/wiki/Truth_table#Binary_operations) can all be expressed succinctly in APL, as shown in the [notebook](https://nbviewer.org/github/Dyalog/dyalog-jupyter-notebooks/blob/master/Boolean%20Scans%20and%20Reductions.ipynb) and [webinar](https://dyalog.tv/Webinar/?v=erv_1LxEByk) on Boolean scans and reductions.

## Membership?

It is common to make multiple equality comparisons.

```APL

```

## Replicate/Compress
The **replicate** function `⍺/⍵` (yes, some symbols have <a target="_blank" href="https://aplwiki.com/wiki/Function-operator_overloading">multiple meanings</a>) repeats elements of an array along rows.

```APL
      1 2 3/'ABC'
```
```
ABBCCC
```
---
```APL
      1 2 3/2 3⍴'DYALOG'
```
```
DYYAAA
LOOGGG
```
---
```APL
      1 ¯2 3/2 3⍴'DYALOG'
```
```
D  AAA
L  GGG
```

When used with a Boolean array, the function is called **compress**.

```APL
      0 1 0/2 3⍴'DYALOG'
```
```
Y
O
```

## Indexing
In many other programming languages, "[selection](https://www.bbc.co.uk/bitesize/guides/zh66pbk/revision/3)" is used to describe control structures such as ["if then else"](https://en.wikipedia.org/wiki/Conditional_(computer_programming)#If%E2%80%93then(%E2%80%93else)) or ["switch case"](https://en.wikipedia.org/wiki/Conditional_(computer_programming)#Case_and_switch_statements). In APL, we can get a similar effect by literally "selecting" elements from arrays. 

!!!Info
	Indexing starts from 1 by default. You can change the index origin by setting `⎕IO←0`, but this course assumes `⎕IO←1`.

```APL
      'APPLE'[1 3 4]                         ⍝ Select elements 1, 3 and 4
```
```
APL
```
---
```APL
      ⍸ 1 0 0 1 0 1                          ⍝ Where are the 1s?
```
```
1 4 6
```
---
```APL
      (⍳5) IsDivisibleBy 2                   ⍝ 1 Where ⍺ is even
```
```
0 1 0 1 0
```
---
```APL
      {⍵[⍸⍵ IsDivisibleBy 123]}⎕AVU          ⍝ Numbers in ⎕AVU divisible by 123
```
```
0 123 8364 246
```

## The shape of data
Multi-dimensional arrays are a useful way of handling . APL leverages arrays for both. Doing selections and summations with APL is like some beautiful answer to the question "what if Excel were a programming language (and that language no VBA)?".

## Problem set



1.   
	The average daily temperatures, in degrees Celcius, for 7 days are stored in a variable `t_allweek`.
	
	```APL
	t_allweek ← 11.7 8.6 9.7 14.2 6.7 11.8 9.2
	```

	1. The mean average temperature for the week
	1. The mean average temperature rounded to 1 decimal place

1. Remove the vowels `'aeiou'` in the text `'alphabetti spaghetti'`
1. Find the indices of the vowels `'aeiou'` in the text `'alphabetti spaghetti'`
1. Count the number of vowels `'aeiou'` in the text `'alphabetti spaghetti'`
1. Write an expression to test if there are any vowels `'aeiou'` in the text `'alphabetti spaghetti'`

1. Early or late

## Useful bits
Try these exercises in creating and using Boolean vectors.

1. These are the heights of some students in 3 classes.
	```APL
		student ← 'Kane' 'Jonah' 'Jessica' 'Padma' 'Katie' 'Charlie' 'Amil' 'David' 'Zara' 'Filipa'
		class ← 'CBACCCBBAB'
		height ← 167 177 171 176 178 164 177 177 173 160
		↑student height class
	```

	???+Question "How do I get those boxes around my output?"
		We are using [nested arrays](), although we have not yet formally introduced them.

		Turn boxing on with the user command
		```APL
			]Box on
		Was OFF
		```

	???+Question "What is `↑`?"
		We created three lists: a simple character vector `class`; a simple numeric vector `height`; and a nested vector of character vectors `student`.

		Placing them side by side created a single

	1.	
		1. Find the height of the tallest student
		1. What is their name?
		1. What class are they in?  
	1.	  
		1. What is the average height of students in class `B`?
		1. Which class has the tallest average height?
		1. Which class has the narrowest range of heights?

1. Pass-fail
	Provided a list of scores

	```APL
	34 22 40 90 76 44 16 16 25 22 44 41
	```

	write an expression which evaluates to a list of characters of the same length, in which a vertical bar `'|'` corresponds to a score less than 40 while a plus `'+'` corresponds to a score of 40 or more.

	```APL
	      your_expression
	||++++||||++
	```