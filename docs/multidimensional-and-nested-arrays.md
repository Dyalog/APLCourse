# Multidimensional and Nested Arrays

## Arrays are made of arrays
You might have already noticed some awkwardness when we tried to represent a list of names as a character matrix. The main problem being that names do not usually have uniform length!

```APL
      student ← 4 7⍴'Kane   Jonah  JessicaPadma  '
      student = ' '
```
```
0 0 0 0 1 1 1
0 0 0 0 0 1 1
0 0 0 0 0 0 0
0 0 0 0 0 1 1
```

Any code using this representation is going to have to be aware of the trailing space characters. This can be an efficient representation of this data, but it can sometimes be more convenient to have a real nested structure to deal with.

```APL
      2 3⍴(1 2)(3 4 5)('AB')(2 2⍴'CDEF')
```
```
┌───┬─────┬─────┐
│1 2│3 4 5│AB   │
├───┼─────┼─────┤
│CD │1 2  │3 4 5│
│EF │     │     │
└───┴─────┴─────┘
```

!!!Question "How do I get those boxes around my output?"
	Turn boxing on with the user command
	```APL
		]Box on
	Was OFF
	```
	Boxing affects the display of output in the APL session, but does not affect the structure or values of arrays in any way.

In general, arrays are made of arrays. More specifically, the individual elements of any array are <dfn>scalar</dfn> - but they may lie along zero or more [axes](#TODO).

How can we fit an arbitrary array as a single element in another array? We have to somehow package it up as one of these scalars.

The example above uses a special notation to implicitly wrap each sub-array in a scalar. We have actually used it many times already. <dfn>Stranding notation</dfn> is a convenient notation for writing vectors by having arrays separated by spaces or parentheses. Above we wrote parenthesised APL expressions which evaluate to arrays, but we could have written the names of some pre-defined arrays instead.

```APL
      a ← 1 2
      b ← 3 4 5
	  c ← 'AB'
	  d ← 2 2⍴'CDEF'
      2 3 ⍴ a b c d
```
```
┌───┬─────┬─────┐
│1 2│3 4 5│AB   │
├───┼─────┼─────┤
│CD │1 2  │3 4 5│
│EF │     │     │
└───┴─────┴─────┘
```

We can reshape the result of an expression, without naming it, by using the <dfn>enclose</dfn> function `⊂⍵`.

```APL
      3⍴⊂'Hello'
```
```
┌─────┬─────┬─────┐
│Hello│Hello│Hello│
└─────┴─────┴─────┘
```

## Arrays have rank and depth
Nested arrays have depth, which is different to rank in APL. Rank is the number of dimensions an array has (scalar 0, vector 1, matrix 2 etc.) whereas depth is how many arrays are inside our arrays.

The <dfn>depth</dfn> function `≡⍵` returns the depth of an array. The absolute value of depth `|≡⍵` is the level of nesting, starting at 0 for simple scalars.

```APL
      ≡'a'  ⍝ Simple scalar has depth 0
0
      ≡x    ⍝ Simple matrix has depth 1
1
      ≢⍴x   ⍝ Simple matrix has rank 2
2
      ≡⊂x   ⍝ Enclosing increases the depth
2
      ≡⊂⊂x
3
      ≡⊂⊂⊂x
4
```

Negative depth indicates uneven nesting:

```APL
      ≡(1 2)(3 4)         ⍝ Evenly nested arrays have positive depth
2
      ≡(1 2)(3 4 (4 5))   ⍝ Unevenly nested arrays have negative depth
¯3
```

If you have a complex structure like this, you can use the <dfn>each</dfn> operator `F¨⍵` to keep drilling down until you feel you have a better understanding.

```APL
      nv ← (1 2)(3 4 (4 5))
	  nv
┌───┬─────────┐
│1 2│┌─┬─┬───┐│
│   ││3│4│4 5││
│   │└─┴─┴───┘│
└───┴─────────┘

      ⍴nv     ⍝ 2-element vector
2
      ≡nv     ⍝ Unevenly nested
¯3

      ⍴¨nv    ⍝ 2 vectors of lengths 2 and 3
┌─┬─┐
│2│3│
└─┴─┘
      ≡¨nv    ⍝ 1st element is simple, 2nd is unevenly nested
1 ¯2

      ⍴¨¨nv   ⍝ 2nd element appears to be made of 2 scalars followed by a vector
┌───┬─────┐
│┌┬┐│┌┬┬─┐│
││││││││2││
│└┴┘│└┴┴─┘│
└───┴─────┘
      ≡¨¨nv   ⍝ 2nd element is 2 simple scalars and a non-nested array
┌───┬─────┐
│0 0│0 0 1│
└───┴─────┘
```

So we can tell we have a 2 element nested vector. The 1st element is a simple 2-element vector. The 2nd element contains 2 simple scalars and a simple vector of length 2.

!!!Tip
	The `]Repr` (represent) [user command](./Code.md#user-commands) can provide an APL expression which evaluates to almost any given array:

	```APL
	      mysterious_value ← 2 4∘.⍴⊂5 6 7
	      ]repr mysterious_value
	```
	```
	(5 6) (5 6 7 5)
	```


## Arrays are made of scalars
Arrays in APL are always made of scalars (rank-0 arrays) as their elements.

So the vector `1 2 3` is made of three scalar numbers, and `2 3⍴⎕A` is made of 6 scalar characters arranged in 2 rows with 3 columns.

A simple scalar is a single character, a single number or a single [namespace reference](./Namespaces.md). Enclosing simple scalars is a no-op (it does not do anything):

```APL
      3 ≡ ⊂⊂⊂⊂⊂⊂3
1
```

But enclosing an array allows us to include it as part of another array:

```APL
      x ← 2 3⍴⎕A   ⍝ x is a simple matrix
      3⍴x          ⍝ Reshape uses the elements within
ABC
      3⍴⊂x         ⍝ Enclosing turns the whole array into an element
┌───┬───┬───┐
│ABC│ABC│ABC│
│DEF│DEF│DEF│
└───┴───┴───┘
```

## The shape of a scalar
What is the shape of `46.2`? Here are some common incorrect answers.

`4`?

No, the shape of the character vector `'46.2'` is four, but that is not the same as the scalar number `46.2` - see [problem 2 from the previous section](./array-logic-data-driven-conditionals.md#problem-set).

`1`?

Not quite. The tally `≢⍵` gives `1`, but the shape function `⍴⍵` only returns `1` for a 1-element vector. `46.2` is not a vector, it is a scalar.

`0`?

This would be the shape of a 0-element vector.

To get to the answer, it helps to think about the rank as well. The rank is simply the number of dimensions.

```APL
      ⍴⍴¯1 0 1∘.×⍳5     ⍝ A matrix has two dimensions
```
```
2
```
---
```APL
      ⍴⍴'ABCDE'         ⍝ A vector has just one dimension
```
```
1
```
---
```APL
      ⍴⍴'A'             ⍝ How many dimensions does a scalar have? 
```
```
0
```

If the result of `⍴'A'` is an array with shape `0` - that means that the shape of a scalar is an empty vector. To be specific, it is an <dfn>empty numeric vector</dfn>. This empty numeric vector can also be represented by the symbol <dfn>zilde</dfn> (`⍬`), which is a zero (`0`) combined with a tilde (`~`). When executed, it displays as a blank line.

```APL
      ⍬
```
``` 
 

```
---
```APL
      ]display ⍬
```
```
┌⊖┐
│0│
└~┘
```

!!!Note "The tally is a scalar whereas the shape is a vector"
	You might have noticed that the tally `≢⍵` always returns one number, whereas the shape `⍴⍵` may return several. The tally of an array is a *scalar* representing the length of the first (leading) axis. For a matrix, this is the number of rows.

	The shape returns a vector which describes the length of each axis. Whether there are five axes or no axes, the result of `⍴⍵` is always a vector.

## Simple array selection
When you have a collection of data represented as an array, you often want to use only some subset of the data. There are a few selection methods in APL, and [the next section](./selecting-from-arrays.md) is dedicated to them. Here we show two constructs which can be used to select any sub-array from any array.

```APL
      a ← 2 3 4⍴⎕A
      a
```
```
ABCD
EFGH
IJKL

MNOP
QRST
UVWX
```

When we have an array of rank > 1, selections along each axis are separated by semicolons:

```APL
      a[1 2;2 3;3 4]
```
```
GH
KL

ST
WX
```

Omitting a specification selects from that entire axis:

```APL
      a[;2 3;3 4]
```
```
GH
KL

ST
WX
```

Indexing expressions always return a collection of scalars. If we want to obtain the array nested inside of a scalar, we can use the <dfn>first</dfn> function `⊃⍵` to *disclose* the contents of that scalar.

```APL
      n ← 2 3⍴1 (2 3) 'abc' (2 2⍴(1 2)3 4 5) 'ghi' 'k'
      n
```
```
┌───────┬───┬───┐
│1      │2 3│abc│
├───────┼───┼───┤
│┌───┬─┐│ghi│k  │
││1 2│3││   │   │
│├───┼─┤│   │   │
││4  │5││   │   │
│└───┴─┘│   │   │
└───────┴───┴───┘
```

With `]Box on`, we can see that our selection of the element in the 2<sup>nd</sup> row and 2<sup>nd</sup> column is a nested array of some kind.

```APL
      n[2;2]
```
```
┌───┐
│ghi│
└───┘
```

After disclosing, we are left with a simple character vector.

```APL
      ⊃n[2;2]
```
```
ghi
```

Clearly, selecting subarrays in this way can become tedious, laborious and even onerous. The main code smell in APL is typically *too much code*, so of course there are other methods to select from arrays in various ways depending on your use case. These are covered in the next section on [selecting from arrays](#TODO). However, between these two techniques you will be able to obtain any subset of any array, even if it takes a few steps to get what you want.

## Problem set
What indexing array must be used to select from a simple scalar?

1. Write the function `Backwards` which accepts a nested vector of character vectors as its argument and reverses both the order of elements and the contents of each vector within.
	```APL
	      Backwards 'reverse' 'these' 'words'
	┌─────┬─────┬───────┐
	│sdrow│eseht│esrever│
	└─────┴─────┴───────┘
	```

	???Example "Answer"
		You can write reverse and reverse-each in either order.
		```APL
		Backwards ← {⌽¨⌽⍵}
		Backwards ← {⌽⌽¨⍵}
		```

1. Write a monadic function `Join` which joins a nested vector of character vectors `⍵` into a single, non-nested character vector in which elements from `⍵` are separated by the character scalar `,` (comma).

	```APL
	      Join 'join' 'these' 'words'
	```
	```
	join,these,words
	```

	**BONUS** Can you write `Join` as a *dyadic* function which accepts a separator scalar as `⍺`?

	```APL
	      ' ' Join 'join' 'these' 'words'
	```
	```
	join these words
	```
	---
	```APL
	      '|' Join 'join' 'these' 'words'
	```
	```
	join|these|words
	```

	???Example "Answer"
		We can define a dyadic function which catenates two character vectors with a comma:

		```APL
		{⍺,',',⍵}
		```

		We can then apply this using the reduction operator on a list of character vectors:

		```APL
		      {⍺,',',⍵}/'join' 'these' 'words'
		```
		```
		┌────────────────┐
		│join,these,words│
		└────────────────┘
		```

		Because the rank of the result of a reduction is always one less than the rank of the argument, a vector argument (rank 1) must cause a scalar (rank 0) result. That is why our result is a nested scalar which contains a character vector. To get our desired simple character vector, we disclose this result.

		```APL
		      ⊃{⍺,',',⍵}/'join' 'these' 'words'
		```
		```
		join,these,words		
		```

		You might think to wrap this expression to make a dfn, and that is also valid, but you do not need to:

		```APL
		      Join ← {⊃{⍺,',',⍵}/⍵}
		      Join ← ⊃{⍺,',',⍵}/
		      Join 'join' 'these' 'words'
		```
		```
		join,these,words
		```

		Writing functions in this way is called [tacit definition](./Ufns.md#the-three-function-styles). It usually looks better without raw dfn definitions inside in this author's opinion.

		```APL
		Join ← ⊃(⊣,',',⊢)/
		```

		You might have found it difficult to define the dyadic version because dfns can only accept two arguments. The trick is to use assignment to make a temporary name for our joining character.	

		```APL
		      Join ← {s←⍺ ⋄ ⊃{⍺,s,⍵}/⍵}
		      '|' Join 'join' 'these' 'words'
		```
		```
		join|these|words
		```

		We can even make an ambivalent function by assigning to `⍺`. In the monadic case, we will join with a comma.

		```APL
		      Join ← {⍺←',' ⋄ s←⍺ ⋄ ⊃{⍺,s,⍵}/⍵}
		      Join 'join' 'these' 'words'
		```
		```
		join,these,words
		```
		---
		```APL
		      '|' Join 'join' 'these' 'words'
		```
		```
		join|these|words
		```

1. Create a variable `nest` which has the following properties

	```APL
	      ⍴nest
	```
	```
	2 3
	```
	---
	```APL
	      ≡nest
	```
	```
	¯2
	```
	---
	```APL
	      ⍴¨nest
	```
	```
	┌─┬┬─┐
	│ ││2│
	├─┼┼─┤
	│3││6│
	└─┴┴─┘
	```
	---
	```APL
	      ]display ∊nest
	```
	```
	┌→───────────────────┐
	│I 3 am 1 5 8 amatrix│
	└+───────────────────┘
	```
	---
	```APL
	      ⍴∊nest
	```
	```
	14
	```

	???+Example "Answer"
		We have a 2 row, 3 column matrix. It is unevenly nested with a maximum depth of 2. In ravel order there are: two scalars; a 2-element vector; a 3-element vector; a scalar; and a 6-element vector.

		We can lay out the simple scalar elements of the array in a simple vector using the <dfn>enlist</dfn> function.
		
		We can then see that there are 14 scalar elements in total. This makes sense given the description above.
		
		```
		14 = +/1 1 2 3 1 6`
		```

		Therefore, our ravel of elements is `'I' 3 'am' (1 5 8) 'a' 'matrix'`. The definition of `nest` is:

		```APL
		nest ← 2 3⍴'I' 3 'am' (1 5 8) 'a' 'matrix'
		```

1. Without using the shape function `⍴⍵`, what are the shapes of the results of the following expressions?
	1. `'APL IS COOL'`
	1. `¯1 0 1 ∘.× 1 2 3 4 5` 
	1. `1 2 3 4∘.+¯1 0 1∘.×1 10`
	1. `+/⍳4`

	???+Example "Answers"
		<ol>
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

		If you swap the arguments around, you get a $5$ by $3$ matrix.

		```APL
		      1 2 3 4 5 ∘.× ¯1 0 1
		```
		```
		¯1 0 1
		¯2 0 2
		¯3 0 3
		¯4 0 4
		¯5 0 5
		```

		</li>

		<li>This is a 3D array of shape `4 3 2`. The shape of the result of applying a function using the outer product operator is the concatenation of the shapes of the arguments.
		
		The first (rightmost) outer product takes a $3$-element vector and a $2$-element vector and returns a $3$ by $2$ matrix. This becomes the right argument to the next outer product which takes a $4$-element vector on its left to result in a $4$-plane, $3$-column, $2$-row multidimensional array.</li>

		<li>This is a scalar. The reduce operator `F/` has the effect of *reducing* the rank of its argument array by 1. Since we have a vector (rank 1) input, we must have a scalar (rank 0) output.</li>

		</ol>