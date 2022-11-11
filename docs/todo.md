# TODO
- more description in [array logic problem 1](./array-logic-data-driven-conditionals.md#problem-set)
- move finding and replacing problems interval index broken keyboard problems
- link to section: http://localhost:8000/array-logic-data-driven-conditionals/#the-outer-product
- outer product link: http://localhost:8000/basic-syntax-and-arithmetic/#singleton-extension
- #TODO links
- windows `2f/`
- key
- negative index generator link to problem: http://localhost:8000/basic-syntax-and-arithmetic/#what-do-these-errors-mean
- http://localhost:8000/array-logic-data-driven-conditionals/#problem-set link to membership version in the solutions
- [in problem set N](./array-logic-data-driven-conditionals.md#problem-set (finding replacing)
- proper treatment of scalar functions
- put back info about the language bar and finding out what unfamiliar primitives do
- Mean {+⌿⍵÷≢⍵} vs {(+⌿⍵)÷≢⍵}
- find-replace-vals AnyVowels use Any idiom `∨/`
- The idiom for joining a nested list into a simple list is `⊃,/`
- outer product
	- identity matrix
	- countful membership
- shape, reshape
	- look-and-say
- take, drop
- replicate/compress

Perhaps many more of the functions should be introduced well before the rank operator.

## NOTES
For chaining the rank operator, think of doing multiple pairings – from the outside inwards. So we have a vector of scalars `ABC`, and a matrix of rows of scalars (2 3⍴⍳6). The result wants to pair scalars from ⍺ with scalars from ⍵. However, we cannot do this simply F⍤0 because of our rank mismatch. What we can do is use rank once to pair up equivalent shapes, and then use rank 0. Therefore we have to pair rows (vectors, rank 1) first (outside) and then within each of those pairings, pair up our scalars (rank 0) inside.

      'ABC' ({⍺⍵}⍤0) 2 3⍴⍳6
RANK ERROR
      'ABC'({⍺ ⍵}⍤0)2 3⍴⍳6
           ∧
      'ABC'({⍺ ⍵}⍤1)2 3⍴⍳6
┌───┬─────┐
│ABC│1 2 3│
├───┼─────┤
│ABC│4 5 6│
└───┴─────┘
      'ABC'({⍺ ⍵}⍤0⍤1)2 3⍴⍳6
A 1
B 2
C 3

A 4
B 5
C 6
      'ABC'(,⍤0⍤1)2 3⍴⍳6
A 1
B 2
C 3

A 4
B 5
C 6

Chaining multiple uses of rank goes from right-to-left, outer most pairing to innermost. That is, in (,⍤0⍤1), we pair rows (1) outside and scalars (0) within our row pairings.

Bind essentially fills one of the “slots” of a dyadic function with an array value. 2⍴3 4 5 gives 3 4. The ⍵ is reshaped by the ⍺. If we fill the ⍵ slot, then we get a monadic function where the only argument must take the place of the ⍺ slot.

⍴∘3 4 5  ⍝ A monadic function which reshapes 3 4 5 according to ⍵
      (⍴∘3 4 5)2
3 4
      (⍴∘3 4 5)5
3 4 5 3 4
      (⍴∘3 4 5)¨2 5
┌───┬─────────┐
│3 4│3 4 5 3 4│
└───┴─────────┘
Reshape (3 4 5) using each of 2 and 5

---

1. A company owns 5 stores which each sell the same 3 items.

The quantity sold of each product in each store over a 7-day week are given in the array `qty`:

```APL
⎕RL←42 ⋄ qty←¯1+?5 3 7⍴10
```

The prices of the three products are £4.99, £24.99 and £99.99.

```APL
price ← .99 + 4 24 99
```

The total costs each day to run each store are given in the matrix `cost`:

```APL
⎕RL←42 ⋄ costs ← 94+?5 7⍴11
```

Each store has its own weekly profit target:

```APL
target ← 3000 1250 800 6000 3200
```

- what is the price of each item?
£4.99 £24.99 £99.99

- which day had the most?
- which stores made at least their target profit?

target←400

--------

1. The game naughts and cross, also known as tic-tac-toe, is played on a 3 by 3 grid. Two players take turns placing their tokens on the grid until one player has made a complete line either horizontally, vertically or diagonally which consists of just that player's tokens.

We can represent a game using a character matrix. 

1. 

Now, instead of several 2-dimensional games, we will use a 3-dimensional array to represent a single 3-dimensional game.

--------

1. These are the heights of some students in 3 classes. Students have numeric identifiers `id`.
	```APL
	student ← 10 7⍴'Kane   Jonah  JessicaPadma  Katie  CharlieAmil   David  Zara   Filipa '
	class ← 'CBACCCBBAB'
	height ← 167 177 171 176 178 164 177 177 173 160
	```

	Use APL to:

	1. Find the name of the tallest student
	1. Find the class which class has the tallest average height
	1. Find the class with the narrowest range of heights