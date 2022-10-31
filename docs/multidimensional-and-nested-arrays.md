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

Any code using this representation is going to have to be aware of the trailing space characters. This is an efficient representation of this data, and there are [some interesting techniques](#aplcart-flat-partitioned #TODO) for dealing with non-rectangular data using rectangular arrays. However, it is usually just more convenient to have a real nested structure to deal with.

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
