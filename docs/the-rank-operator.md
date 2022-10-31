# The Rank Operator
Many times you may select a subset of the data and apply further processing to it, sometimes you want to divide the data into a collection of subsets and apply the same processing to each. In fact, this idea is built in to the "array-at-a-time" processing of some primitive functions and operators, but is generalised for all functions using the rank operator.

Let us take a 3D array representing the cost of 3 products over 2 weeks bought on all 7 days of each week.

```APL
      cost ← ?3 2 7⍴9
```

Sum between the *layers* (rank 2, matrices) of this array to get the total cost over all 3 products each day of each week:

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
	With functions like `+ × ÷`, arrays must either have the same shape, or one of them be a scalar. The result of the function application has the same shape as the largest of the input arrays. The rank operator generalises this to the concept of <dfn>frames</dfn>. A frame is a rank-k cell of some array. For frames to "match" means that there are the same number of rank **j** subarrays of `⍺` as there are rank **k** subarrays of `⍵` when a function `⍺ F ⍵` is applied as `⍺ (F⍤j k) ⍵`.