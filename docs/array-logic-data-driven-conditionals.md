# Array Logic and Data-driven Conditionals

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
      'P' ≠ 'Q'           ⍝ Not equal to
```
```
1
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

## The shape of data
One of the distinguishing features of APL is the multidimensional array. Single elements, lists and tables are quite familiar constructs.

Tables are very useful for representing data which is related in some way. For example, let's say that the price of oranges changes daily. We can represent a week of prices as a 7-element numeric list.

```APL
0.35 0.3 0.33 0.32 0.39 0.33 0.36
```

How about the amount spent on 3 items? We could store this in 3 separate lists, but it is convenient to keep it in a table with 3 rows and 7 columns:

```APL
      cost ← 3 7⍴4.36 4.22 4.05 4.14 4.18 4.19 4.02 2.79 2.58 2.68 2.77 2.88 2.79 2.52 3.07 3 3.13 3 3.24 3.06 3.29
	  cost
```
```
4.36 4.22 4.05 4.14 4.18 4.19 4.02
2.79 2.58 2.68 2.77 2.88 2.79 2.52
3.07 3    3.13 3    3.24 3.06 3.29
```

So what is this table that we have created? In other languages, there are lists, and there are lists of lists. In APL, a list of lists is not the same thing as a table (also known as a matrix). APL arrays contain two essential pieces of information: their shape and their list of elements.

The <dfn>shape</dfn> function `⍴⍵` returns the shape of its argument.

```APL
      ⍴4 12 31
3
```

The following table lists the ranks (number of dimensions), some common names, and a geometric analogy for the three simplest types of multidimensional arrays.

|Rank|Name|Geometric analogy|diagram|
|---|---|---|---|
|$0$|scalar|point|![point geometry diagram](./img/point.svg)|
|$1$|vector or list|line|![line geometry diagram](./img/line.svg)|
|$2$|matrix or table|rectangle|![rectangle geometry diagram](./img/rectangle.svg)|

Arrays with $3$ or more dimensions are sometimes called <dfn>cube</dfn> or <dfn>cuboid</dfn>, but they are generally referred to as <dfn>N-dimensional arrays</dfn>, <dfn>rank-N arrays</dfn> or <dfn>high rank arrays</dfn>.

The total spent on each item is a row-wise sum:
```APL
      +/cost    ⍝ The total cost over the week
```
```
29.16 19.01 21.79
```
---
```APL
      ⍴+/cost   ⍝ For 3 items
```
```
3
```

The total for each day across all items is a column-wise sum:

```APL
      +⌿cost    ⍝ The total cost of 3 items
```
```
10.22 9.8 9.86 9.91 10.3 10.04 9.83
```
---
```APL
      ⍴+⌿cost   ⍝ Over 7 days
```
```
7
```

## The outer product
The "outer product" `∘.F` operator applies its function operand `F` between all combinations of elements of its left and right argument arrays. 

```APL
      F ← {⍺+⍵}
      1 2 3 ∘.F 10 20 30
11 21 31
12 22 32
13 23 33
```

For example, the catenate function `⍺,⍵` (comma) will join two lists together. We can use the outer product to join combinations of words from two lists. 

```APL
      1 4 9 , 6 5 4
1 4 9 6 5 4
      'joined up' , 'text vectors'
joined uptext vectors

      'chicken' 'pork' 'vegetable' ∘., ' chow mein' ' with cashew nuts'
┌───────────────────┬──────────────────────────┐
│chicken chow mein  │chicken with cashew nuts  │
├───────────────────┼──────────────────────────┤
│pork chow mein     │pork with cashew nuts     │
├───────────────────┼──────────────────────────┤
│vegetable chow mein│vegetable with cashew nuts│
└───────────────────┴──────────────────────────┘
```

!!!Question "What are those boxes around the output?"
	We have just created a <dfn>nested array</dfn>. These are arrays in which each element contains another array more complex than a single number or character. The next section on [selecting from arrays](./selecting-from-arrays.md) introduces them in more detail.

	If you do not see lines around the output of the last expression above in your interpreter session, turn boxing on:
	```APL
	      ]box on
	Was OFF
	      ⍳3 3
	┌───┬───┬───┐
	│1 1│1 2│1 3│
	├───┼───┼───┤
	│2 1│2 2│2 3│
	├───┼───┼───┤
	│3 1│3 2│3 3│
	└───┴───┴───┘
	```

## Replicate/Compress
The <dfn>replicate</dfn> function `⍺/⍵` (yes, some symbols have <a target="_blank" href="https://aplwiki.com/wiki/Function-operator_overloading">multiple meanings</a>) repeats elements of an array along rows.

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

When used with a Boolean array, the function is called <dfn>compress</dfn>.

```APL
      0 1 0/2 3⍴'DYALOG'
```
```
Y
O
```

Just like the forward-slash `F/` as the *reduction operator* acts along rows and forward-slash-bar `F⌿` reduces down columns*, the replicate `⍺/⍵` and <dfn>replicate-first</dfn> `⍺⌿⍵` functions work along different axes of high rank arrays.

*we will see a fuller description when we discuss 3D and higher rank arrays.

## Indexing
In many other programming languages, "[selection](https://www.bbc.co.uk/bitesize/guides/zh66pbk/revision/3)" is used to describe control structures such as ["if then else"](https://en.wikipedia.org/wiki/Conditional_(computer_programming)#If%E2%80%93then(%E2%80%93else)) or ["switch case"](https://en.wikipedia.org/wiki/Conditional_(computer_programming)#Case_and_switch_statements). In APL, we can get a similar effect by literally "selecting" elements from arrays. 

!!!Info
	Indexing starts from 1 by default. You can change the index origin by setting `⎕IO←0`, but this course assumes `⎕IO←1`.

```APL
      'APPLE'[1 3 4]
```
```
APL
```
---
```APL
      ⍸ 1 0 0 1 0 1
```
```
1 4 6
```
---
```APL
      IsDivisibleBy ← {0=⍵|⍺}
      3 6 8 5 2 IsDivisibleBy 2
```
```
0 1 1 0 1
```
---
```APL
      3 6 8 5 2 {⍺[⍸⍺ IsDivisibleBy ⍵]} 2
```
```
6 8 2
```

## Problem set

1. Define the numeric vector `nums`
	
	```APL
	nums ← 3 5 8 2 1
	```

	1. Using `nums`, define `mat`

	```APL
	      mat
	```
	```
	3 5 8
	2 1 3
	```

	1. Using `mat`, define `wide`

	```APL
	      wide
	```
	```
	3 5 8 3 5 8
	2 1 3 2 1 3
	```

	1. Using `mat`, define `stack`

	```APL
	      stack
	```
	```
	3 5 8
	3 5 8
	2 1 3
	2 1 3
	```

	???Example "Answers"
		<ol type="a">
		<li>
		```APL
		mat ← 2 3⍴nums
		```
		</li>
		<li>
		```APL
		wide ← mat,mat
		```
		</li>
		<li>
		```APL
		stack ← 2⌿mat
		```
		</li>
		</ol>

1. Why does 101='101' evaluate to a 3-element list?

	???+Example "Answer"
		`101` is a literal single number, whereas `'101'` is a literal 3-element character vector. Due to singleton extension, `101='101'` compares the single number `101` to each of the 3 characters in the 3-element character vector `'101'`. The character vector `'101'` is equivalent to `'1' '0' '1'` but the number `101` is not the same as the 3-element numeric vector `1 0 1`.

1. Pass-fail  

	Write a function `PassFail` which takes an array of scores and returns an array of the same shape in which `F` corresponds to a score less than 40 and `P` corresponds to a score of 40 or more.

	```APL
	      PassFail 35 40 45
	```
	```
	FPP
	```
	---
	```APL
	      PassFail 2 5⍴89 77 15 49 72 54 25 18 57 53
	```
	```
	PPFPP
	PFFPP
	```

	???Example "Answer"
		```APL
		PassFail ← {'FP'[1+40≤⍵]}
		```

1. Back to School
	1. Write a function to produce the multiplication table from `1` to `⍵`. 

		<pre><code class="language-APL">      MulTable 7</code></pre>
		<pre><code class="language-APL">1  2  3  4  5  6  7
		2  4  6  8 10 12 14
		3  6  9 12 15 18 21
		4  8 12 16 20 24 28
		5 10 15 20 25 30 35
		6 12 18 24 30 36 42
		7 14 21 28 35 42 49</code></pre>

	1. Write a function to produce the addition table from `0` to `⍵`.

		<pre><code class="language-APL">      AddTable 6</code></pre>
		<pre><code class="language-APL">0 1 2 3  4  5  6
		1 2 3 4  5  6  7
		2 3 4 5  6  7  8
		3 4 5 6  7  8  9
		4 5 6 7  8  9 10
		5 6 7 8  9 10 11
		6 7 8 9 10 11 12</code></pre>

1. Making the Grade

    |   |   |   |   |   |   |
    |---|---|---|---|---|---|
    |**Score Range**|`0-64`|`65-69`|`70-79`|`80-89`|`90-100`|
    |**Letter Grade**|F|D|C|B|A|

    Write a function that, given an array of integer test scores in the inclusive range 0 to 100, returns a list of letter grades according to the table above.

	<pre><code class="language-APL">      Grade 0 10 75 78 85</code></pre>
	<pre><code class="language-APL">FFCCB</code></pre>


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
		      CountVowels 'This text is made of characters.'
		```
		```
		9
		```
		---
		```APL
		      CountVowels 'We have TWELVE vowels in this sentence.'
		```
		```
		12
		```

	1. Write a function to remove the vowels from its argument

		```APL
		      RemoveVowels 'this text is made of characters'
		ths txt s md f chrctrs
		```

	???+Example "Answers"
		{∨/,'aeiou'∘.=⍵}
		{∨/∨/'aeiou'∘.=⍵}
		{+/,'aeiou'∘.=⍵}
		{⍵⌿⍨~∨⌿'aeiou'∘.=⍵}

1. AddRows
1. NormRows

1. These are the heights of some students in 3 classes. Students have numeric identifiers `id`.
	```APL
		student ← 10 7⍴'Kane   Jonah  JessicaPadma  Katie  CharlieAmil   David  Zara   Filipa '
		class ← 'CBACCCBBAB'
		height ← 167 177 171 176 178 164 177 177 173 160
		↑student height class
	```

	1. Use APL to:
		1. Find the height of the tallest student
		1. Find the name of the tallest student
		1. Find the class to which the tallest student belongs  
	1.	  
		1. Find the average height of students in class `B`
		1. Find the class which class has the tallest average height
		1. Find the class with the narrowest range of heights

1. Without using the shape function `⍴⍵`, what are the shapes of the results of the following expressions?
	1. `'APL IS COOL'`
	1. `¯1 0 1 ∘.× 1 2 3 4 5` 
	1. `1 2 3 4∘.+¯1 0 1∘.×1 10`
	1. `+/⍳4`

	???+Example "Answers"
		<ol>
		<li><ol>
		<li>This is a simple character vector with $11$ characters, including space characters, so its shape is `11`.
		```APL
		      ⍴'APL IS COOL'
		11
		```
		</li>	
		<li>This is a matrix. The result of multiplying all combinations of elements from a 3-element vector and a 5-element vector is a 3 by 5 matrix. It has 3 rows and 5 columns, so its shape is `3 5`.
		```APL
		      ¯1 0 1 ∘.× 1 2 3 4 5
		```
		```
		¯1 ¯2 ¯3 ¯4 ¯5
		0  0  0  0  0
		1  2  3  4  5
		```
		---
		```APL
		      ⍴¯1 0 1 ∘.× 1 2 3 4 5
		```
		```
		3 5
		```
		If you swap the arguments around, you get a $5$ by $3$ matrix.</li>
		```APL
		      1 2 3 4 5 ∘.× ¯1 0 1
		¯1 0 1
		¯2 0 2
		¯3 0 3
		¯4 0 4
		¯5 0 5
		```
		<li>This is a scalar. The reduce operator `F/` has the effect of *reducing* the rank of its argument array by 1.

		The shape of a scalar </li>
		</ol></li>
		</ol>

1. Optimus Prime

	A prime number is divisible by only itself and `1`.

	Write a dfn which returns all of the prime numbers between `1` and `⍵`.

	```APL
	      Primes 10
	```
	```
	2 3 5 7
	```
	---
	```
	      Primes 30
	```
	```
	2 3 5 7 11 13 17 19 23 29
	```
