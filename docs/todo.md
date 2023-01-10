# TODO
- bracket axis versions of rank problems?

- horizontal scroll on narrow partial code blocks
- more description in [array logic problem 1](./array-logic-data-driven-conditionals.md#problem-set)
- move finding and replacing problems interval index broken keyboard problems
- link to section: http://localhost:8000/array-logic-data-driven-conditionals/#the-outer-product
- outer product link: http://localhost:8000/basic-syntax-and-arithmetic/#singleton-extension
- #TODO links
- windows `2f/`
- key
- negative index generator link to problem: http://localhost:8000/basic-syntax-and-arithmetic/#what-do-these-errors-mean
- http://localhost:8000/array-logic-data-driven-conditionals/#problem-set link to membership version in the solutions
- [in problem set N](./array-logic-data-driven-conditionals.md#problem-set) (finding replacing)
- proper treatment of scalar functions
- put back info about the language bar and finding out what unfamiliar primitives do
- Mean `{+⌿⍵÷≢⍵}` vs `{(+⌿⍵)÷≢⍵}`
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

## Making scalars
1. Turn the 1-element vector `v` into a scalar.
1. Write an expression using `⍴` which returns an empty numeric vector.
1. Write an expression using `⍳` which returns an empty numeric vector.


	???+Example "Answer"
		<ol type="a">
		<li>
		The shape of a scalar is an empty numeric vector. We can therefore use an empty numeric vector as the left argument to the reshape function:
		```APL
		⍬⍴v
		```
		</li>
		<li>
		The shape of any scalar is an empty numeric vector.
		```APL
		      ⍴0
		```
		```
		 
		```
		---
		```APL
		      ⍴35
		```
		```
		 
		```
		---
		```APL
		      ⍴'Q'
		```
		```
		 
		```
		---
		```APL
		      ⍬≡⍴42
		```
		```
		1
		```
		</li>
		<li>
		If we can generate a length `n` vector with `⍳n`, what happens when `n=0`?

		```APL
		      ⍳0
		```
		```
		 
		```
		</li>
		</ol>
