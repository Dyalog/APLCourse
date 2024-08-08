# Cells and Axes

## Fundamentals of high rank arrays
From the APL Wiki: 
<blockquote>
      A <a target="_blank" href="https://aplwiki.com/wiki/Cell">cell</a> is a subarray which is formed by selecting a single index along some number of leading axes and the whole of each trailing axis. Cells are classified by their rank, which may be between 0 (scalars) and the array's rank (in which case the cell must be the entire array). Cells with rank k are called k-cells of an array. A major cell is a cell whose rank is one less than the entire array, or a 0-cell of a scalar. 
</blockquote>
If the text above feels confusing, don't worry. Maybe after this chapter, or even after the next section on selecting from arrays, you can read it again and say to yourself "oh yeah, that makes sense". For now just know that that arrays are arranged like rectangles in many dimensions. The three simplest cases should feel a bit familiar to you.

```APL
      0            ⍝ A scalar
0
      'APL'        ⍝ A vector
APL
      0 1 2∘.*⍳5   ⍝ A matrix
0 0 0  0  0
1 1 1  1  1
2 4 8 16 32
```

Now let us look at an array with 3 dimensions. We will call it a **cuboid**:

```APL
      ⍴cuboid←2 3∘.+3 4 5∘.×4 5 6 7
2 3 4 ← trailing (last) axis
↑
leading (first) axis
```

In the array `cuboid` defined above, there are `2` **major cells**, which are those of rank `¯1+≢⍴cuboid`.

Here is another 3D array containing letters of the alphabet:

```APL
      2 3 4⍴⎕A
ABCD
EFGH
IJKL
    
MNOP
QRST
UVWX
      ≢2 3 4⍴⎕A      ⍝ Tally counts the major cells
2
```

The display may look like 2 separate matrices, but the array `2 3 4⍴⎕A` is a single, 3 dimensional array.

The dimensions of an array are also known as **axes**. The most major cells, the rank `k-1` cells for an array of rank `k`, lie along the *first* axis. The least major cells are columns which lie along the *last* axis.

<center>
	<figure>
		<img src="../img/3DAxes.png" alt="Axes of a 3D array"/>
		<figcaption>
			Axes of a 3D array
		</figcaption>
	</figure>
</center>

In Dyalog, arrays can have up to 15 dimensions.

For more details on the APL array model in Dyalog and other array languages, see [the APL Wiki article on the array model](https://aplwiki.com/wiki/Array_model).

Now that we have the words to describe the structure of an array in terms of its sub-arrays, let us look at how to apply functions to those sub-arrays.

## The rank operator
A lot of the time you might want to take a subset of the data and do stuff to it. Sometimes you want to think of the data as a collection of similar parts and apply the same processing to each part. In fact, this idea is built in to the "array-at-a-time" nature of some primitive functions and operators, but the rank operator lets us do this for all functions.

Let us take a 3D array representing the cost of 3 products each day over 2 weeks.

```APL
cost ← ?3 2 7⍴9
```

The total cost over all 3 products each day of each week is the *sum* between the *layers* (rank 2, matrices):

```APL
      +⌿cost
```
```
12 21 13 14 17 20 17
12 25 18 10  9 26 14
```
---
```APL
      ⍴+⌿cost       ⍝ 2 weeks, 7 days per week
```
```
2 7
```

To get the total spent on each week day over the two weeks, we can tell the function `+⌿` to only *see* the tables for each product — the rank-2 subarrays. The first axes of each rank-2 subarray are the columns of each product table:

```APL
      (+⌿⍤2)cost
```
```
 4 18 12  7 9 13  6
17 14  9  7 9 17 13
 3 14 10 10 8 16 12
```
---
```APL
      ⍴(+⌿⍤2)cost   ⍝ 3 products, 7 days per week
```
```
3 7
```

The total spent on each product each week is the row-wise sum.

```APL
      (+⌿⍤1)cost
```
```
28 41
51 35
35 38
```

This is the same as `+/`:

```APL
      +/cost
```
```
28 41
51 35
35 38
```
---
```APL
      ⍴(+⌿⍤1)cost   ⍝ 3 products, 2 weeks
```
```
3 2
```

!!!Note "A helpful tip for operators"
	Many operators accept one or more function <dfn>operands</dfn> and apply them to their arguments in some particular way. The enclose function `⊂⍵` can be used to get a view of the arguments *as the operand function sees them*.

	Apply our function to rank-2 subarrays of the `cost` array.

	```APL
	      (⊂⍤2)cost
	```
	```
	┌─────────────┬─────────────┬─────────────┐
	│2 9 4 1 5 5 2│9 6 8 5 7 8 8│1 6 1 8 5 7 7│
	│2 9 8 6 4 8 4│8 8 1 2 2 9 5│2 8 9 2 3 9 5│
	└─────────────┴─────────────┴─────────────┘
	```

	The result of `(+⌿⍤2)⍵` is like doing `+⌿⍵` to each of these matrices.

	```APL
	      (+⌿⍤2)cost
	```
	```
	 4 18 12  7 9 13  6
	17 14  9  7 9 17 13
	 3 14 10 10 8 16 12
	```

In the dyadic case, the rank operator is a powerful way to pair up subarrays of `⍺` with a conforming collection of subarrays from `⍵`.

Let us say that we want to add each of the numbers $1$ to $5$ to corresponding rows in a matrix. We cannot simply add a vector to a matrix because these arrays have different ranks.

```APL
      1 2 3 4 5 + 5 3⍴0 10 100
```
```
RANK ERROR: Mismatched left and right argument ranks
      1 2 3 4 5+5 3⍴0 10 100
               ∧
```

The <dfn>rank operator</dfn> (`F⍤k`) allows us to pair up *scalars* (rank 0) from `⍺` and *vectors* (rank 1) from `⍵` and apply our function `+` between these.

```APL
      1 2 3 4 5 (+⍤0 1) 5 3⍴0 10 100
```
```
1 11 101
2 12 102
3 13 103
4 14 104
5 15 105
```

In the same way that some functions can apply between a single value and an array of values, we can apply between an array of rank $n$ and an array of rank $n$ subarrays. For example, a single vector (rank 1) and a matrix (rank 2) as a collection of vectors.

```APL
      1 0 ¯1 (×⍤1 1) 5 3⍴⍳15
```
```
 1 0  ¯3
 4 0  ¯6
 7 0  ¯9
10 0 ¯12
13 0 ¯15
```

!!!Note "Another helpful tip for operators"
	If we derive a *dyadic* function using an operator, the dfn `{⍺⍵}` can be used to get a view of the arguments *as the operand function sees them*.

	```APL
	      1 0 ¯1 ({⍺⍵}⍤1 1) 5 3⍴⍳15
	```
	```
	┌──────┬────────┐
	│1 0 ¯1│1 2 3   │
	├──────┼────────┤
	│1 0 ¯1│4 5 6   │
	├──────┼────────┤
	│1 0 ¯1│7 8 9   │
	├──────┼────────┤
	│1 0 ¯1│10 11 12│
	├──────┼────────┤
	│1 0 ¯1│13 14 15│
	└──────┴────────┘
	```

In the case where we apply to sub-arrays of the same rank in both `⍺` and `⍵`, we only need specify that rank once:

```APL
      1 0 ¯1 (×⍤1) 5 3⍴⍳15
```
```
 1 0  ¯3
 4 0  ¯6
 7 0  ¯9
10 0 ¯12
13 0 ¯15
```

When applying a function `F⍤j k`, we must ensure that there are the same number of rank-`j` subarrays in `⍺` as rank-`k` subarrays in `⍵` - or that one of them has just 1.

```APL
      1 0 ¯1 (×⍤0 1) 5 3⍴⍳15
```
```
LENGTH ERROR: It must be that either the left and right frames match or one of them has length 0
      1 0 ¯1(×⍤0 1)5 3⍴⍳15
            ∧
```

!!!Note Conforming arrays have either same shape or one is a unit
	With functions like `+ × ÷`, arrays must either have the same shape, or one of them be a scalar.  The result of the function application has the same shape as the largest of the input arrays.  The rank operator generalises this to the concept of <dfn>frames</dfn>.  For a particular cell rank, the leading axes form the frame and the trailing k axes form the cell shape.  For frames to "match" means that there is the same shape of rank **j** subarrays in `⍺` as there is for rank **k** subarrays in `⍵` when a function `⍺ F ⍵` is applied as `⍺ (F⍤j k) ⍵`.

## Transpose
To <dfn>transpose</dfn> array is to rearrange its axes. Or rather, to rearrange along which axes its data lies.

Transposing a matrix is to flip along its leading diagonal (top-left to bottom-right):

```APL
      3 3⍴⍳9
```
```
1 2 3
4 5 6
7 8 9
```
---
```APL
      ⍉3 3⍴⍳9
```
```
1 4 7
2 5 8
3 6 9
```

In the monadic case, we reverse the order of the axes:

```APL
      2 3 4⍴⎕A
```
```
ABCD
EFGH
IJKL

MNOP
QRST
UVWX
```
---
```APL
      ⍉2 3 4⍴⎕A
```
```
AM
EQ
IU

BN
FR
JV

CO
GS
KW

DP
HT
LX
```

Inspecting the shape before and after transposing shows the reversal of axis lengths.

```APL
      ⍴2 3 4⍴⎕A
```
```
2 3 4
```
---
```APL
      ⍴⍉2 3 4⍴⎕A   ⍝ 4 3 2 ≡ ⌽2 3 4
```
```
4 3 2
```

In the dyadic case, the left argument says where each corresponding axis in `⍴⍵` should end up in the result.

For example:

- move the 1st axis to become the 2nd
- move the 2nd axis to become the 1st
- leave the 3rd axis as the 3rd

```APL
      2 1 3⍉2 3 4⍴⎕A
```
```
ABCD
MNOP

EFGH
QRST

IJKL
UVWX
```
---
```APL
      ⍴2 1 3⍉2 3 4⍴⎕A
```
```
3 2 4
```

## The bracket axis operator
Here are two pairs of *first-* and *last-axis* primitives.

```APL
      n←2 3⍴1 2 3 1 0 ¯1
      n
1 2  3
1 0 ¯1
      +/n                ⍝ Sum along the last axis
6 0
      +⌿n                ⍝ Sum along the first axis
2 2 2
      '-'⍪2 3⍴'DYALOG'   ⍝ Catenate first
---
DYA
LOG
      '|',2 3⍴'DYALOG'   ⍝ Catenate last
|DYA
|LOG
```

Some functions and operators can be used along specified axes using the **bracket-axis operator** `[]` (more <a target="_blank" href="https://aplwiki.com/wiki/Function-operator_overloading">duplicitous</a> symbols).

Compare the behaviour of the monadic function `⊂` *enclose* when applied with the rank operator `⍤` versus when it is applied using bracket-axis (also called the *function axis operator* or *axis specification*).

```APL
      (⊂⍤1)2 2 5⍴'RIGHTHELLOTHERE'
```
```
┌─────┬─────┐
│RIGHT│HELLO│
├─────┼─────┤
│THERE│RIGHT│
└─────┴─────┘
```
---
```APL
      (⊂⍤2)2 2 5⍴'RIGHTHELLOTHERE'
```
```
┌─────┬─────┐
│RIGHT│THERE│
│HELLO│RIGHT│
└─────┴─────┘
```
---
```APL
      (⊂⍤3)2 2 5⍴'RIGHTHELLOTHERE'
```
```
┌─────┐
│RIGHT│
│HELLO│
│     │
│THERE│
│RIGHT│
└─────┘
```
---
```APL
      ⊂[1]2 2 5⍴'RIGHTHELLOTHERE'
```
```
┌──┬──┬──┬──┬──┐
│RT│IH│GE│HR│TE│
├──┼──┼──┼──┼──┤
│HR│EI│LG│LH│OT│
└──┴──┴──┴──┴──┘
```
---
```APL
      ⊂[2]2 2 5⍴'RIGHTHELLOTHERE'
```
```
┌──┬──┬──┬──┬──┐
│RH│IE│GL│HL│TO│
├──┼──┼──┼──┼──┤
│TR│HI│EG│RH│ET│
└──┴──┴──┴──┴──┘
```
---
```APL
      ⊂[3]2 2 5⍴'RIGHTHELLOTHERE'
```
```
┌─────┬─────┐
│RIGHT│HELLO│
├─────┼─────┤
│THERE│RIGHT│
└─────┴─────┘
```
---
```APL
      ⊂[1 2]2 2 5⍴'RIGHTHELLOTHERE'
```
```
┌──┬──┬──┬──┬──┐
│RH│IE│GL│HL│TO│
│TR│HI│EG│RH│ET│
└──┴──┴──┴──┴──┘
```
---
```APL
      ⊂[2 3]2 2 5⍴'RIGHTHELLOTHERE'
```
```
┌─────┬─────┐
│RIGHT│THERE│
│HELLO│RIGHT│
└─────┴─────┘
```
---
```APL
      ⊂[1 2 3]2 2 5⍴'RIGHTHELLOTHERE'
```
```
┌─────┐
│RIGHT│
│HELLO│
│     │
│THERE│
│RIGHT│
└─────┘
```

Only the following primitive constructs can be used with the axis operator:

|Monadic Functions|Function Names|
|---|---|
|`↑⍵` and `↓⍵`|Mix and Split|
|`⌽⍵` or `⊖⍵`|Reverse|
|`,⍵`|Ravel with axis|
|`⊂⍵`|Enclose with axis|
|`F/⍵` or `F⌿⍵`|Reductions|
|`F\⍵` or `F⍀⍵`|Scans|

|Dyadic Functions|Function Names|
|---|---|
|`+ × ⌈ ∧ ≤` etc...|All *scalar dyadic functions*|
|`⍺↑⍵` and `⍺↓⍵`|Take and Drop|
|`⍺/⍵` or `⍺⌿⍵`|Replicate/compress|
|`⍺\⍵` or `⍺⍀⍵`|Expand|
|`⍺,⍵` or `⍺⍪⍵`|Catenate|
|`⍺⊂⍵`|Partitioned-enclose|
|`⍺⊆⍵`|Partition|
|`⍺F/⍵` or `⍺F⌿⍵`|Windowed-reduction|

## Rank vs Axis
The bracket-axis operator has always been in Dyalog APL. The rank operator was introduced in version 14.0. They both offer similar functionality, however:

- some uses of bracket-axis are shorter than their equivalent expression using rank and transpose, and vice versa
- sometimes it makes sense to think in terms of axes using bracket-axis, other times in terms of cells using the rank operator
- bracket-axis can only be used with a few particular primitives, whereas the rank operator can be used with any function including those defined by the user
- bracket-axis works slightly differently depending on the function to which it is applied, whereas the rank operator has consistent behaviour for all functions
- bracket-axis is special syntax unlike most other operators

In some ways, bracket-axis can be thought of as [syntactic sugar](https://www.quora.com/What-is-syntactic-sugar-in-programming-languages) for the behaviour of the rank operator in conjunction with dyadic transpose.

For a more in-depth look at the relationship between function rank and function axis, watch the Dyalog webinars on [Selecting from Arrays](https://dyalog.tv/Webinar/?v=AgYDvSF2FfU) and [The Rank Operator and Dyadic Transpose](https://dyalog.tv/Webinar/?v=zBqdeDJPPRc).

The [section about older features](./Quirks.md) has some more examples of bracket axis.

## Problem set 5
1. Write a function `FlipBlock` which reverses the order of rows in each sub-matrix of its argument array.

	```APL
	      FlipBlock 2 2 3⍴0 0 0 1 1 1
	1 1 1
	0 0 0

	1 1 1
	0 0 0
	```

	If there is only 1 row in each sub-matrix, reversing does nothing:
	```APL
	      FlipBlock 1 5⍴'abcde'
	```
	```
	abcde
	```

	If there is only one dimension, the array will be reversed:

	```APL
	      FlipBlock 'abcde'
	```
	```
	edcba
	```

	???Example "Answer"

		```APL
		FlipBlock ← {(⊖⍤2)⍵}
		```

		We can also use the **right/identity** function `⊢⍵` to separate the array *operand* of the rank **operator** from the array *argument* of the derived **function** reverse-first-rank-two `⊖⍤2`. Otherwise, stranding would bind `2 ⍵` into a vector, causing unexpected behaviour.

		This author prefers to isolate operands using parentheses most of the time.

		```APL
		FlipBlock ← {⊖⍤2⊢⍵}
		```

		Alternatively, we can write this as a [tacit function](./user-defined-functions.md#the-three-function-styles). This form is also known as a <dfn>derived</dfn> function because a new function is derived from functions and operators.

		Parentheses are not required, but this author thinks they make derived functions more distinced from array values when viewed together in source code.

		```APL
		FlipBlock ←  ⊖⍤2
		FlipBlock ← (⊖⍤2)
		```

		These four spellings of `FlipBlock` are all equivalent. Whichever you choose to write is a matter of taste.

1. Write a function `MatchWord` which takes a character vector left argument `⍺` and a character array `⍵` with the same number of columns as `⍺` and returns a Boolean array of rank `¯1+≢⍺` in which a `1` indicates rows in `⍵` that match `⍺`.

	```APL
	      'has' MatchWord 5 3⍴'hasnotnot'
	```
	```
	1 0 0 1 0
	```
	---
	```APL
	      'simon' MatchWord 3 2 5⍴'maybesimonspoke'
	```
	```
	0 1
	0 0
	1 0
	```

	???Example "Answer"

		Are all characters in a row equal?

		```APL
		MatchWord ← {∧/⍺(=⍤1)⍵}
		```

		Or using the **match** function `⍺≡⍵`:

		```APL
		MatchWord ← {⍺(≡⍤1)⍵}
		```

		As a tacit definition:

		```APL
		MatchWord ← (≡⍤1)
		```

1. Extend the `Grille` function from the problem set about [array logic](./array-logic-data-driven-conditionals.md#problem-set-3) to reveal multiple messages in a 3-dimensional array.

	```APL
	grille  ← 4 4⍴'⌺ ⌺⌺ ⌺ ⌺⌺ ⌺  ⌺⌺⌺'
	grilles ← 3 4 4⍴'⌺⌺ ⌺⌺⌺⌺ ⌺⌺⌺⌺⌺ ⌺⌺⌺⌺⌺ ⌺⌺⌺⌺ ⌺⌺⌺⌺⌺ ⌺⌺⌺⌺⌺⌺ ⌺ ⌺⌺ ⌺⌺⌺⌺⌺'
	grids   ← 3 4 4⍴'AREQEEVASEQALTOFBSMBESCTIRMETOGPGHIAAACPSKLERVRG'
	```
	
	The single `grille` reveals 3 messages.
	
	```APL
	      grille Grille grids
	```
	```
	REVEAL
	SECRET
	HACKER
	```
	
	The array `grilles` reveals 3 different messages when applied to the same grid.
	
	```APL
	      grilles Grille grids
	```
	```
	EAT
	BIG
	APL
	```

	???Example "Answer"

		In the individual case, using rank-2 `F⍤2` pairs the single grille with each grid in `grids`:

		```APL
		      grille ({⍺⍵}⍤2) grid
		```
		```
		┌────┬────┐
		│⌺ ⌺⌺│AREQ│
		│ ⌺ ⌺│EEVA│
		│⌺ ⌺ │SEQA│
		│ ⌺⌺⌺│LTOF│
		├────┼────┤
		│⌺ ⌺⌺│BSMB│
		│ ⌺ ⌺│ESCT│
		│⌺ ⌺ │IRME│
		│ ⌺⌺⌺│TOGP│
		├────┼────┤
		│⌺ ⌺⌺│GHIA│
		│ ⌺ ⌺│AACP│
		│⌺ ⌺ │SKLE│
		│ ⌺⌺⌺│RVRG│
		└────┴────┘
		```

		We can also use a different grille for each grid, provided that we have one grille per grid:

		```APL
		      grilles ({⍺⍵}⍤2) grid
		```
		```
		┌────┬────┐
		│⌺⌺ ⌺│AREQ│
		│⌺⌺⌺ │EEVA│
		│⌺⌺⌺⌺│SEQA│
		│⌺ ⌺⌺│LTOF│
		├────┼────┤
		│⌺⌺⌺ │BSMB│
		│⌺⌺⌺⌺│ESCT│
		│ ⌺⌺⌺│IRME│
		│⌺⌺ ⌺│TOGP│
		├────┼────┤
		│⌺⌺⌺⌺│GHIA│
		│⌺ ⌺ │AACP│
		│⌺⌺ ⌺│SKLE│
		│⌺⌺⌺⌺│RVRG│
		└────┴────┘
		```

		Using the definitions of `Grille` given previously:

		```APL
		Grille ← {⍵[⍸⍺=' ']}⍤2
		Grille ← {(,⍺=' ')/,⍵}⍤2
		```

1.  

	The 3D array `rain` gives the monthly rainfall in millimeters over 7 years in 5 countries.  

	```APL
	rain←?7 5 12⍴250
	```

	There are 12 columns in each row; the rows represent the months. The sum along the rows...
	
	```APL
	      (+⌿⍤1)rain
	```
	```
	1476 1764 1733 1320 1678
	1698 1943  798 2226 1813
	2050 1821 1209 1763 1625
	2006 1218 1615 1516 1536
	1372 1584 1946 1604 1623
	1831 1705 1998 1312 1224
	1499 1369 1437 1597 1279
	```
	---
	```APL
	      ⍴(+⌿⍤1)rain
	```
	```
	7 5
	```

	...gives the total rainfall in each year in each country over 12 months. Put another way, it is the total annual rainfall each year in each country.
	
	1. For each expression below, write a brief description of the resulting statistic.

		```APL
		⌈⌿rain
		(+⌿⍤2)rain
		(⌈⌿⍤1)rain
		(⌈⌿⍤3)rain
		⌊/rain
		```
		```
		```

		??? Hint
			Look at the shapes of the arguments and the results, <code class='language-apl'>⍴rain</code> and <code class='language-apl'>⍴+⌿rain</code> etc.

	1. Assign scalar numeric values (single numbers) to the variables `years` `countries` `months` such that the `rain` data can be summarised as follows:

		```APL
		      ⍴(+⌿⍤years)rain       ⍝ Sum over years
		```
		```
		5 12
		```
		---
		```APL
		      ⍴(+⌿⍤countries)rain   ⍝ Sum over countries
		```
		```
		7 12
		```
		---
		```APL
		      ⍴(+⌿⍤months)rain      ⍝ Sum over months
		```
		```
		7 5
		```
	 
	???Example "Answers"
		<ol type="a">
		<li>

		- `⌈⌿rain` is the maximum rainfall each month in each country over all 7 years.
		- `(+⌿⍤2)rain` is the total rainfall each year in each month across all 5 countries.
		- `(⌈⌿⍤1)rain` is the maximum monthly rainfall for any month in each year in each country.
		- `(⌈⌿⍤3)rain` is the same as `⌈⌿rain` because `rain` is a rank-3 array.
		- `⌊/rain` is the minimum rainfall in any month in each year in each country.

		</li>
		<li>
		
		```APL
		(years countries months) ← 3 2 1
		```
		
		</li>
		</ol>

1. 
	Which of the following functions are affected by the rank operator `⍤` and why are the other functions not affected?

	```APL
	⌽    ⍝ Reverse
	⊖    ⍝ Reverse first
	+/   ⍝ Plus reduce
	+⌿   ⍝ Plus reduce-first
	```

	???Example "Answer"
		**Reverse** `⌽⍵` and **reduce** `F/⍵` work along the last axis of an array. The rank operator makes a function act on subarrays defined in terms of trailing axes of an array. These trailing axes always contains the last axis, so there is no change in behaviour for last-axis reverse `⌽⍵` and reduce `F/⍵`. For example, `F⍤2` forces `F` to work on matrices, and matrices have rows.

		As their names suggest, reverse-first and reduce-first act along the first axis of an array. For a cuboid, this is *between the planes* or *across sub-matrices*. For a matrix, this is *between the rows* or *along the columns*. A vector only has one axis, so both forms act in the same way.

1. Match the following rank operands with their descriptions. Each use of rank (**a** to **e**) pairs with two of the 10 description boxes below.

	<pre><code class="language-APL">   a    b    c    d     e
	┌────┬────┬───┬─────┬──────┐
	│⍤1 3│⍤2 1│⍤¯1│⍤0 99│⍤99 ¯1│
	└────┴────┴───┴─────┴──────┘
	`-----------------------------------------`
	┌─┐ ┌────────────────┐ ┌────────────┐
	│⍵│ │major cells of ⍺│ │vectors of ⍺│
	└─┘ └────────────────┘ └────────────┘
	┌────────────────┐ ┌─┐ ┌──────────────┐
	│major cells of ⍵│ │⍺│ │3D arrays of ⍵│
	└────────────────┘ └─┘ └──────────────┘
	┌────────────────┐ ┌────────────┐
	│major cells of ⍵│ │scalars of ⍺│
	└────────────────┘ └────────────┘
	┌────────────────┐ ┌────────────────┐
	│matrices of ⍺   │ │vectors of ⍵    │
	└────────────────┘ └────────────────┘</code></pre>

	???Example "Answer"

		```
		a:     vectors of ⍺ (⍤1 3)   3D arrays of ⍵
		b:    matrices of ⍺ (⍤2 1)   vectors of ⍵
		c: major cells of ⍺ (⍤¯1)    major cells of ⍵
		d:     scalars of ⍺ (⍤0 99)  ⍵
		e:                ⍺ (⍤99 ¯1) major cells of ⍵
		```

1. For each name below, suggest the rank for arrays with that name.

	<pre><code class="language-APL">┌────────┬────────────────────┐
	│Scalar  │                    │
	├────────┼────────────────────┤
	│Vector  │rank-1              │
	├────────┼────────────────────┤
	│Matrix  │                    │
	├────────┼────────────────────┤
	│Table   │                    │
	├────────┼────────────────────┤
	│List    │                    │
	├────────┼────────────────────┤
	│Cube    │                    │
	├────────┼────────────────────┤
	│4D array│                    │
	├────────┼────────────────────┤
	│2D array│                    │
	└────────┴────────────────────┘</code></pre>

	???Example "Answer"

		```
		┌────────┬────────────────────┐
		│Scalar  │rank-0              │
		├────────┼────────────────────┤
		│Vector  │rank-1              │
		├────────┼────────────────────┤
		│Matrix  │rank-2              │
		├────────┼────────────────────┤
		│Table   │rank-2              │
		├────────┼────────────────────┤
		│List    │rank-1              │
		├────────┼────────────────────┤
		│Cube    │rank-3              │
		├────────┼────────────────────┤
		│4D array│rank-4              │
		├────────┼────────────────────┤
		│2D array│rank-2              │
		└────────┴────────────────────┘
		```

1. Find the values of `j` and `k` in each of the two expressions below.

	```APL
	m ← 7 2⍴1 1 2 4 3 7 4 3 5 3 6 2 2 3
	```

	1.  
	
		<pre><code class="language-APL">      0 10(×⍤j k)m</code></pre>
		<pre><code>0 10
		0 40
		0 70
		0 30
		0 30
		0 20
		0 30</code></pre>

	1.  
	
		<pre><code class="language-APL">      (2×⍳7)(+⍤j k)m</code></pre>
		<pre><code> 3  3
		 6  8
		 9 13
		12 11
		15 13
		18 14
		16 17</code></pre>

	???Example "Answers"

		<ol type="a">
		<li>

		```APL
		(j k) ← 1
		```

		</li>
		<li>

		```APL
		(j k) ← 0 1
		```

		</li>
		</ol>

1. Rank Matching  
	Write a function `R1` which uses catenate `,` with the rank operator `⍤` to merge a vector and matrix into a single 3D array.

	<pre><code class="language-APL">      'ABC' R1 2 3⍴⍳6</code></pre>
		<pre><code>A 1
	B 2
	C 3
	&nbsp;
	A 4
	B 5
	C 6</code></pre>

	??? Hint
		You can apply rank multiple times for a single function e.g. `F⍤j⍤k`.

	???Example "Answer"

		```APL
		R1 ← ,⍤0⍤1
		```

		When chaining multiple uses of the rank operator, think of doing multiple pairings — from the outside inwards. We have a vector of scalars `ABC`, and a matrix of rows of scalars `2 3⍴⍳6`. The result wants to pair scalars from `⍺` with scalars from `⍵`. However, we cannot do this simply `F⍤0` because of our rank mismatch. What we can do is use rank once to pair up equivalent shapes, and then use rank 0. Therefore we have to pair rows (vectors, rank 1) first (outside) and then within each of those pairings, pair up our scalars (rank 0) inside.

		```APL
		      'ABC' ({⍺⍵}⍤0) 2 3⍴⍳6
		```
		```
		RANK ERROR
		      'ABC'({⍺ ⍵}⍤0)2 3⍴⍳6
		           ∧
		```
		---
		```APL
		      'ABC'({⍺ ⍵}⍤1)2 3⍴⍳6
		```
		```
		┌───┬─────┐
		│ABC│1 2 3│
		├───┼─────┤
		│ABC│4 5 6│
		└───┴─────┘
		```
		---
		```APL
		      'ABC'({⍺ ⍵}⍤0⍤1)2 3⍴⍳6
		```
		```
		A 1
		B 2
		C 3

		A 4
		B 5
		C 6
		```

		It just so happens that stranding two scalars `{⍺⍵}` is the same as concatenating them `{⍺,⍵}`. For more complex arrays these will not be the same.

		```APL
		      'ABC'(,⍤0⍤1)2 3⍴⍳6
		```
		```
		A 1
		B 2
		C 3

		A 4
		B 5
		C 6
		```

		Chaining multiple uses of rank goes from right-to-left, outer most pairing to innermost. That is, in `(,⍤0⍤1)`, we pair rows (`1`) outside and scalars (`0`) within our row pairings.

1. **Split k-cells**  
	The *split* function `↓⍵` splits an array of rank ≥2 by rows, returning an array of shape `¯1↓⍴⍵`. Use *enclose* `⊂⍵` with the rank operator `⍤` to create a function `Split` which always splits an array into a nested vector of the major cells of `⍵`.

	<pre><code class="language-APL">      Split 3 2 2 3⍴⍳9
	┌─────┬─────┬─────┐
	│1 2 3│4 5 6│7 8 9│
	│4 5 6│7 8 9│1 2 3│
	│     │     │     │
	│7 8 9│1 2 3│4 5 6│
	│1 2 3│4 5 6│7 8 9│
	└─────┴─────┴─────┘</code></pre>

	???Example "Answer"

		```APL
		Split ← ⊂⍤¯1
		```

## Reduce on an empty vector?
For your interest, here are some reductions of note. Try to ask yourself why they give the results they do. Could they have been given different definitions?

```APL
      +/⍬
      ×/⍬
      ⌊/⍬
      ,/'APPLE' 'DOG' 'BISCUIT'
```

As mentioned previously, more detailed treatments of the rank operator can be found in the [Dyalog webinars on function rank](https://www.youtube.com/playlist?list=PLA9gQgjzcpKFW0-KldlJW6FSwHGQ1WMAJ).
