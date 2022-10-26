# TODO
- the rank operator properly
	- split "selecting from arrays"
	1. multidimensional and nested arrays AKA multidimensional arrays of arrays
	2. selecting from arrays

- link to section: http://localhost:8000/array-logic-data-driven-conditionals/#the-outer-product
- outer product link: http://localhost:8000/basic-syntax-and-arithmetic/#singleton-extension
- #TODO links
- rank vs axis probably
- negative index generator link to problem: http://localhost:8000/basic-syntax-and-arithmetic/#what-do-these-errors-mean
- http://localhost:8000/array-logic-data-driven-conditionals/#problem-set link to membership version in the solutions
- [in problem set N](./array-logic-data-driven-conditionals.md#problem-set (finding replacing)
- proper treatment of scalar functions
- Mean {+⌿⍵÷≢⍵} vs {(+⌿⍵)÷≢⍵}

## NOTES

Indeed that *was* the idea, but in the new edition there will be proper introductions of these concepts and worked solutions.

Those problems are trying to lead the user to thinking about the dimensions as representing things, but without explained solutions they’re just confusing in my opinion.

You can write a first-axis mean function and apply the whole thing using rank:
({(+⌿⍵)÷≢⍵}⍤3)

Or , as you have done, apply sub-functions with rank – which is better for performance, but more annoying if you want to change things:
{(+⌿⍤3)÷(≢⍤3)⍵}

If you know that your input is always rank 3, then you don’t need to use ⍤3. But if you might apply to a rank 4 array in the future (to batch process a collection of these rain data), then you might want to use ⍤3.
{(+⌿⍵)÷≢⍵}

Frankly that type of discussion ↑ is too detailed for an intro course anyway, and might be included as an appendix or separate tutorial thing. The rank operator is considered by some seasoned APLers to be an advanced topic, but I think it is an powerful tool for understanding multidimensional arrays properly, so I am adamant to include it in any new APL tutorial content. In practice, most arrays are rank 2 at most (like Excel tables), and rank 3 arrays are used more like collections of matrices than they are used as real rank-3 mathematical tensors (e.g. in machine learning).

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
