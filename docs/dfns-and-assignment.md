# Dfns and assignment

## Dfns
A dfn (pronounced "*dee-fun*" with a very short "u" sound) is a way of writing functions in APL. It starts and ends with curly braces `{}`, has a right argument `⍵` (omega) and an optional left argument `⍺` (alpha).

```APL
      3{⍺}5      ⍝ ⍺ is the (optional) left argument
3
      {⍵}'apl'   ⍝ ⍵ is the right argument
apl
      {⍺}5       ⍝ Calling a dyadic function monadically results in an error
VALUE ERROR
      {⍺}5
      ∧
      3{⍵}       ⍝ Calling a function without a right argument results in an error
SYNTAX ERROR: Missing right argument
      3{⍵}
       ∧
```

## Function valence
Most functions are either *monadic* or *dyadic*. Monadic functions take a single argument to their right and dyadic functions take two arguments, one to the right and one to the left. For example, *plus* is a dyadic function e.g. `3+4 5 6` and *iota* is a monadic function e.g. `⍳3`.

From here, when functions are first introduced, `F⍵` ("eff omega") denotes a monadic function `f` and `⍺F⍵` ("alpha eff omega") denotes a dyadic function.

## Assignment
Names are assigned with the left arrow `name ← expression`. We say "name gets [function or array]".

```APL
      one←1
      three←3
      equals←=
      plus←+
      four←4
      four equals one plus three   ⍝ 1 means true, 0 means false
```
```
1
```

We can use a name in the same line in which it is defined. In production code it is best to avoid this unless an expression is very short.

Read the following as "squared numbers divided by the sum of squares":
```APL
      squared÷+/squared←¯1 0 1 2*2
```
```
0.1666666667 0 0.1666666667 0.6666666667`
```

## Problem Set 2
1. Write a function to count the number of vowels in some text
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
1. A recipe serving 4 people uses 3 eggs. Write the function `Eggs` which computes the number of eggs which need cracking to serve `⍵` people. Using a fraction of an egg requires that a whole egg be cracked.
	```APL
	      Eggs 4
	```
	```
	3
	```
	---
	```APL
	      Eggs 100
	```
	```
	75
	```
	---
	```APL
	      Eggs ⍳12
	```
	```
	1 2 3 3 4 5 6 6 7 8 9 9
	```
1. Write a function `To` which returns integers from `⍺` to `⍵` inclusive.
	```APL
	      3 To 3
	3
	      3 To 4
	3 4
	      1 To 7
	1 2 3 4 5 6 7
	      ¯3 To 5
	¯3 ¯2 ¯1 0 1 2 3 4 5
	```
	**BONUS** Make `To` work even if `⍺>⍵`:  
	```APL
	      3 To 5
	3 4 5
	      5 To 3
	5 4 3
	      5 To ¯2
	5 4 3 2 1 0 ¯1 ¯2
	```
1. The forumla to convert temperature from Celcius to Farenheit in traditional mathematical notation is as follows:
	$$T_F = 32 + (9\over5)\times T_C$$  
	Write the function `CtoF` to convert temperatures from Celcius to Farenheit.  
	```APL
	      CtoF 11.3 23 0 16 ¯10 38
	52.34 73.4 32 60.8 14 100.4
	```

1. Utility Functions
	1. Without using the *tally* `≢⍵` or *shape* `⍴⍵` functions, create a function named `Tally` which returns the number of elements in a vector.

		          Tally 1 2 4 523 1 2 454  
		    7

	2. Create a function named `Mean` which returns the mean average of a numeric vector.

		          Mean 1 2 4 523 1 2 454
		    141

	3. Using `⌊⍵` ("floor" i.e. round down), create a function `IsDivisibleBy` which returns `1` if `⍺` is divisible by `⍵` and `0` otherwise.

		          15 IsDivisibleBy 5
		    1
		          15 IsDivisibleBy 6
		    0
		          12 IsDivisibleBy ⍳12
		    1 1 1 1 0 1 0 0 0 0 0 1

2. What Remains
	1. `⍺ Mod ⍵` is a **dyadic** function which returns the remainder after its right argument **`⍵`** number is divided by the left argument **`⍺`**.

		          16÷5
		    3.2
		          5 Mod 16   ⍝ 3 5s and 1 left over
		    1
		          0.2×5      ⍝ 0.2 5s left over
		    1
		          12 Mod 30
		    6
		          13 Mod 56
		    4
		          5 Mod 30   ⍝ 5 goes into 25 exactly 6 times      
		    0

		Write the `Mod` function as a dfn without using the *magnitude*/*residue* (`|`) glyph.

	2. Write a function `Split ⍵` which takes a fractional number and returns two numbers: its integer and fractional parts.

		          Split 0
		    0 0
		          Split ¯7
		    ¯7 0
		          Split 4.32
		    4 0.32

3. What Was In That Vector Again?

	You should have a variable named `⎕AVU` in your workspace, from [problem set 1](../Problem set 1).

	1. How many even numbers are there in `⎕AVU`?
	2. What percentage of numbers in `⎕AVU` are odd numbers?
	3. What percentage of numbers in `⎕AVU` are strictly negative?
	4. What percentage of numbers in `⎕AVU` are strictly positive?
	5. What do you notice about the percentage of strictly positive and negative numbers?

4. Prime Time

	A prime number is divisible only by itself and `1`.

	Write a dfn which returns `1` if its argument is prime and `0` otherwise.

		          IsPrime 21
	    0
		          IsPrime 17
	    1
