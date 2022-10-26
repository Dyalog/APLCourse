# Multidimensional and nested arrays

## Arrays are made of arrays
You might have already noticed some awkwardness when we tried to represent a list of names as a character matrix. The main problem being that names do not usually have uniform length!

```APL
      student ← 10 7⍴'Kane   Jonah  JessicaPadma  Katie  CharlieAmil   David  Zara   Filipa '
	  ' '=student
```
```
0 0 0 0 1 1 1
0 0 0 0 0 1 1
0 0 0 0 0 0 0
0 0 0 0 0 1 1
0 0 0 0 0 1 1
0 0 0 0 0 0 0
0 0 0 0 1 1 1
0 0 0 0 0 1 1
0 0 0 0 1 1 1
0 0 0 0 0 0 1
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

In general, arrays are made of arrays. More specifically, the individual elements of any array are <dfn>scalar</dfn> - but they may lie along zero or more [axes](./array-model.md#cells-and-axes).

How can we fit an arbitrary array as a single element in another array? We have to somehow package it up as one of these scalars.

The example above uses a special notation to implicitly wrap each sub-array in a scalar. We have actually been using it this whole time. <dfn>Stranding notation</dfn> is a convenient notation for writing vectors by having arrays separated by spaces or parentheses. Above we wrote APL expressions which evaluate to arrays, but we could have written the names of some pre-defined arrays.

```APL
      a ← 1 2
      b ← 3 4 5
	  c ← 'AB'
	  d ← 2 2⍴'CDEF'
      2 3 ⍴ a b c d
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
When you have a collection of data represented as an array, you usually want to select some subset of the data. There are several selection methods available, and the next section is dedicated to them. For now, we present just a couple to help solidify the notion of an APL array and get you used to thinking using the correct terminology.

```APL
      a ← 2 3 4⍴⎕A
      a
ABCD
EFGH
IJKL

MNOP
QRST
UVWX
      a[1 2;2 3;3 4]
GH
KL

ST
WX
      a[;2 3;3 4]
GH
KL

ST
WX
```

```APL
      n ← 2 3⍴1 (2 3) 'abc' (2 2⍴(1 2)3 4 5) 'ghi' 'k'
      n
┌───────┬───┬───┐
│1      │2 3│abc│
├───────┼───┼───┤
│┌───┬─┐│ghi│k  │
││1 2│3││   │   │
│├───┼─┤│   │   │
││4  │5││   │   │
│└───┴─┘│   │   │
└───────┴───┴───┘
      n[2;2]
┌───┐
│ghi│
└───┘
      ⊃n[2;2]
ghi
```

Clearly, selecting subarrays in this way can become tedious, laborious and even onerous. The main code smell in APL is typically *too much code*, so of course there are other methods to select from arrays in various ways depending on your use case. These are covered in the next section on [selecting from arrays](#TODO). However, between these two techniques you will be able to obtain any subset of any array, even if it takes a few steps to get what you want.

## The rank operator
Many times you may select a subset of the data and apply further processing to it, sometimes you want to divide the data into a collection of subsets and apply the same processing to each. In fact, this idea is built in to the "array-at-a-time" processing of some primitive functions and operators, but is generalised for all functions using the rank operator.

Let us take a 3D array representing the cost of 3 products over 2 weeks bought on all 7 days of each week.

```APL
      cost ← ?3 2 7⍴9
```

Sum between the *planes* to get the total cost over all 3 products each day of each week:

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

We can tell the function `+⌿` to only *see* rank-2 subarrays. The first axis of each rank-2 subarray is that along which the columns lie. This way, we can get the total spent on each week day over the two weeks:

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
	Many operators accept one or more function <dfn>operands</dfn> and apply them to their arguments in some particular way. The enclose function can be used to get a view of the arguments *as the operand function sees them*.

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

	The result is like doing `+⌿⍵` to each of these matrices.

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

In the case where we apply to sub-arrays of the same rank in both `⍺` and `⍵`, we can 

```APL
      1 0 ¯1(×⍤1 1) 5 3⍴⍳15
 1 0  ¯3
 4 0  ¯6
 7 0  ¯9
10 0 ¯12
13 0 ¯15
      1 0 ¯1(×⍤1) 5 3⍴⍳15
 1 0  ¯3
 4 0  ¯6
 7 0  ¯9
10 0 ¯12
13 0 ¯15
```

Of course, if you want to apply a function in this way, you must ensure there are the same number of scalars in `⍺` as rows in `⍵`:

```APL
      1 0 ¯1(×⍤0 1) 5 3⍴⍳15
```
```
LENGTH ERROR: It must be that either the left and right frames match or one of them has length 0
      1 0 ¯1(×⍤0 1)5 3⍴⍳15
            ∧
```

or 

!!!Note Conforming arrays have either same shape or one is a unit
	With functions like `+ × ÷`, arrays must either have the same shape, or one of them be a scalar. The result of the function application has the same shape as the largest of the input arrays. The rank operator generalises this to the concept of <dfn>frames</dfn>. A frame is a rank-k cell of some array.

## Problem set