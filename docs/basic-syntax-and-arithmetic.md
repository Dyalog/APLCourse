# Basic syntax

## Functions and arguments
APL has two-argument, infix functions. These are called <dfn>dyadic</dfn> functions.

```APL
      3 × 5
```
```
15
```
---
```APL
      3 - 5
```
```
¯2
```

Some functions map between elements of their left and right argument arrays. It is easy to add lists of numbers together:
```APL
      1 2 3 + 4 5 6
```
```
5 7 9
```

Negative numbers are written with a <dfn>high minus</dfn> `¯` to differentiate between negation (`-3`) and literal negative numbers (`¯3`).
```APL
      1 2 3 - 1 0 ¯1
```
```
0 2 4
```

There are also one-argument, prefix functions. These are called <dfn>monadic</dfn> functions.
```APL
      - 5 ¯3 0 ¯4 2
```
```
¯5 3 0 4 ¯2
```
---
```APL
      ⌽ 1 2 3 4 5
```
```
5 4 3 2 1
```

Some symbols represent both a monadic and a dyadic function, but these are often closely related. As we will see later, even user-defined functions can be monadic, dyadic or even both (<dfn>ambivalent</dfn>).

**:bulb: Try this**: Use these functions monadically and dyadically:

<div class="center language-APL" markdown="span">
<div class="displayBox" markdown="span">
<a class="glyph" title="Plus">`+`</a>
<a class="glyph" title="Minus/Negate">`-`</a>
<a class="glyph" title="Times/Sign">`×`</a>
<a class="glyph" title="Divide/Inverse">`÷`</a>
<a class="glyph" title="Residue/Magnitude">`|`</a>
<a class="glyph" title="Power">`*`</a>
<a class="glyph" title="Logarithm">`⍟`</a>
<a class="glyph" title="Max/Ceiling">`⌈`</a>
<a class="glyph" title="Min/Floor">`⌊`</a>
</div>
</div>

## Singleton extension
Dyadic functions can map between a single value and an array of values.
```APL
      3 × 1 10 100
```
```
3 30 300
```
---
```APL
      3 = 1 2 3 4 5
```
```
0 0 1 0 0
```

**:bulb: Try this**: Replace the functions in the previous two expressions with:
<a class="glyph" title="Max">`⌈`</a>
		<a class="glyph" title="Min">`⌊`</a>
		<a class="glyph" title="Less than">`<`</a>

While experimenting, you may cause a `LENGTH ERROR`:

```APL
      1 2+3 4 5
```
```
LENGTH ERROR: Mismatched left and right argument shapes
      1 2+3 4 5
         ∧
```

Functions such as `+ × ⌈` apply between elements of two arrays of the same shape, or between one element and many if one of the arguments is a single value. However, if the arrays are of two different shapes, it is not clear how the function should be applied. Of course, you may want to [apply a function between all combinations of elements of the left and right argument](./Outer-product.md), but that will be addressed soon enough.

## Order of execution
Expressions are executed from right to left.

```APL
      10×⍳2+5
```
```
10 20 30 40 50 60 70
```

??? Info "Show me step-by-step"
	To start, there is a literal number 5:
	```APL
	            5
	5
	```
	
	Next, there is a plus `+` with a number 2 to its immediate left, so it is evaluated as two plus five:
	```APL
	          2+5
	7
	```
	
	Then the symbol <dfn>iota</dfn> `⍳`. To its left is another function, times `×`, not a value. So the function is called <em>monadically</em>. The monadic form of `⍳` is the <dfn>index generator</dfn>, which generates an integer array of length defined by its right argument.
	```
	         ⍳2+5
	1 2 3 4 5 6 7
	```
	
	Lastly, another dyadic function, we multiply our list by ten:
	```
	      10×⍳2+5
	10 20 30 40 50 60 70
	```

The expresssion above is "ten *times* the indices from 1 to *two plus five*, or in short: "ten times iota two plus five". We can make it clearer using (superfluous) **parentheses** `()`.
```APL
      10×(⍳(2+5))
```
```
10 20 30 40 50 60 70
```

Of course, we can change the order of execution using different parentheses.

```APL
      (10×⍳2)+5
```
```
16 17
```

??? Info "Show me step-by-step"
	Beginning from the right, there is a literal number 5:
	```APL
	      (10+⍳2)+5
	              5
	```
	
	Then there is a plus symbol `+`. Before we can decide if it is being called monadically or dyadically, we must look to the left.
	
	```APL
	            )+5
	```
	
	A right parenthesis. We must evaluate the contents of the parentheses to see if it is a function or a value.
	
	```APL
	      (10+⍳2)
	```
	
	This expression evaluates to the list `11 12`. Since it is a value, it is used as the left argument to our plus function.
	
	```APL
	      (10+⍳2)+5
	      (11 12)+5
	16 17
	```

Infix (dyadic) functions have a **short** *left* scope and **long** *right* scope. This means that they take the result of everything to their right hand side as their right argument. 

If there is one, the left argument is the value to the <em>immediate</em> left.

However, juxtaposed values form lists <em>before</em> any functions are applied. This is called <dfn>stranding</dfn> and lets us write very natural expressions, such as:

```APL
      1 2 3 + 4 5 6
5 7 9
```

but this can lead to some surprises if we are not aware:

```APL
      2 + 2 2 + 2
```
```
6 6
```

??? Info "Show me step-by-step"
	First, there is a literal number 2
	```APL
	                2
	2
	```
	
	Then there is a symbol `+`. What, if any, is the value to its immediate left?
	```APL
	          2 2 + 2
	```
	
	It is a 2-element vector `2 2`. The plus function maps between these elements and the single number on the right:
	```APL
	          2 2 + 2
	4 4
	```
	
	Finally there is another addition. The overall evaluation looks like the following:
	```APL
	      2 + 2 2 + 2
	      2 + 4 4
	      6 6
	```

## Comments
Anything after a lamp symbol `⍝` is ignored.

```APL
      ⍝ nothing happens on this line
      2 × 3 ⍝ 4 5
```
```
6
```
---
```APL
	  'A'   ⍝ lamp is not an "A"
```
```
A
```

## The reduction operator
Adding a list of numbers *could* become very tedious...
```APL
      1+2+3+4+5+6+7+8+9+10+11+12+13+14+15
```
```
120
```

The **reduce** [operator](./Operators.md) `F/` inserts the function `F` to its left between parts of the right argument array.
```APL
      +/1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
```
```
120
```

It is called *reduce* because it reduces the number of dimensions of its argument. In the example above, we have a **vector** (1 dimensional, list) argument and return a **scalar** (0 dimensional, single value) result.

## The index generator
The index generator `⍳⍵` generates integers up to the integer right argument `⍵`
```APL
      ⍳10
```
```
1 2 3 4 5 6 7 8 9 10
```

So we can do an arithmetic sum as follows

|  |  |
|--|--|
|**Traditional Mathematical Notation (TMN)** | **APL** |
| $\sum_{n=1}^N n$ | `+/⍳N`

## What do these errors mean?
While experimenting, you are very likely to come across these:

```APL
      ⍳¯4
```
```
DOMAIN ERROR
      ⍳¯4
      ∧
```

The `DOMAIN ERROR` means that APL cannot compute what you are asking for. In this case, it cannot generate indices up to a negative number. Negative numbers are <em>outside the domain</em> of the index generator function. How might you [generate integers from 1 to negative four]()?

```APL
      1+
SYNTAX ERROR: Missing right argument
      1+
       ∧
```

A `SYNTAX ERROR` means that the expression which you tried to execute does not make sense. In the case above, it is because functions always either take a single argument to their right or two arguments, one to the right and one to the left. Functions never take a single argument to their left.

```APL
      a
VALUE ERROR: Undefined name: a
      a
      ∧
```

A `VALUE ERROR` means that there is nothing associated with the name provided. We have not seen any named functions or variables yet; nothing has been assigned to the name `a`, so trying to use it in an expression is meaningless.

## Problem Set 1
1.   
	The average daily temperatures, in degrees Celcius, for 7 days are stored in a variable `t_allweek`.
	
	```APL
	t_allweek ← 11.7 8.6 9.7 14.2 6.7 11.8 9.2
	```
	
	Use APL to compute the follwing:
	
	1. The highest daily temperature
	1. The lowest daily temperature
	1. The range of (difference between the largest and the smallest) temperatures
	1. Each temperature rounded to the nearest whole number

	??? Example "Answers"
		<ol type="a">
		<li>
		```APL
		      ⌈/t_allweek
		14.2
		```
		</li>
		<li>
		```APL
		      ⌊/t_allweek
		6.7
		```
		</li>
		<li>
		```APL
		      (⌈/t_allweek)-⌊/t_allweek
		7.5
		```
		
		> You may have found the correct answer using the following expression:
		```APL
		      ⌈/t_allweek-⌊/t_allweek
		7.5
		```
		
		> but this is less efficient because it does more subtractions than it needs to. Recall the right-to-left evaluation:
		```APL
		      ⌈/      t_allweek                 - ⌊/ t_allweek
		      ⌈/      t_allweek                 - 6.7
		      ⌈/ 11.7 8.6 9.7 14.2 6.7 11.8 9.2 - 6.7
		      ⌈/ 5 1.9 3 7.5 0 5.1 2.5
		      7.5
		```
		
		> if we use parentheses `()` to force APL to compute the maximum of the list before doing subtraction, we only do a single subtraction instead of 7:
		```APL
		      ( ⌈/t_allweek ) - ⌊/ t_allweek
		      ( ⌈/t_allweek ) - 6.7
		      (     14.2    ) - 6.7
		      7.5
		```
		
		</li>
		<li>
		To round to the nearest whole number, either add 0.5 and round down:
		```APL
		      ⌊0.5+t_allweek
		12 9 10 14 7 12 9
		```
		
		or subtract 0.5 and round up:
		```APL
		      ⌈t_allweek-0.5
		12 9 10 14 7 12 9
		```
		</li>
		</ol>

1. A Mathematical Notation

	Use APL to evaluate the following

	1. $\prod_{n=1}^{12} n$ (multiply together the first twelve integers)

	1. $\sum_{n=1}^{17}n^2$ (add together the first seventeen squared integers)

	1. $\sum_{n=1}^{100}2n$ (add together the first one hundred positive even integers)

	1. $\sum_{n=1}^{100}2n-1$ (add together the first one hundred odd integers)

	1. In TMN, the following equation equals `0`, why does the following return `70`?
		```APL
		      84 - 12 - 1 - 13 - 28 - 9 - 6 - 15  
		```
		```
		70
		```

*[TMN]: Traditional Mathematical Notation

	??? Example "Answers"
		<ol type="a">
		<li>
		```APL
		      ×/⍳12
        479001600
		```
		</li>
		<li>
		```APL
		      +/(⍳17)*2
        1785
		```
		Without parentheses we get the sum of the first 289 integers, instead of the first 17 integers squared.

		|TMN|APL|
		|---|---|
		|$\sum_n^{17^2} n$|`+/⍳17*2`
		|$\sum_n^{17} n^2$|`+/(⍳17)*2`|

		</li>
		<li>
		```APL
		      +/2×⍳100
        10100
		```
		</li>
		<li>
		We can either subtract 1 from the even numbers:
		```APL
		      +/(2×⍳100)-1
		10000
		```

		or we can add negative 1:
		```APL
		      +/¯1+2×⍳100
        10000
		```
		The high minus denotes a literal negative, whereas the hyphen indicates subtraction.
		</li>
		<li>
		Remember the right-to-left rule: functions take everything to their right, and the first thing to their left. We can add unnecessary parentheses to show how APL evaluates our expression.
		```APL
		      (84 - (12 - (1 - (13 - (28 - (9 - (6 - 15)))))))
	    70
		```
		</li>
		</ol>

1. Pyramid Schemes
	1. Sugar cubes are stacked in an arrangement as shown by **Figure 1**.

		<img src="../img/SquaredCubes.png" width="200px" alt="Stacked sugar cubes"/>
			<figcaption><strong>Figure 1.</strong> Stacked sugar cubes</figcaption>

		This stack has `4` **layers** and a total of `30` cubes. How many cubes are there in a similar stack with `467` **layers**?

	1. Now consider the stack in **Figure 2**.

		<img src="../img/OddSquaredCubes.png" width="280px" alt="Differently stacked sugar cubes"/>
			<figcaption><strong>Figure 2.</strong> Differently stacked sugar cubes</figcaption>

		The arrangement in **Figure 2** has `4` **layers** and `84` cubes. How many cubes are there in a similar stack with `812` **layers**?

	1. Now look at **Figure 3**.

		<img src="../img/CubedCubes.png" width="280px" alt="This is just a waste of sugar cubes by now..."/>
			<figcaption><strong>Figure 3. </strong>This is just a waste of sugar cubes by now...</figcaption>

		The stack in **Figure 3** has `3` **"layers"** and `36` cubes in total. How many cubes are there in a similar stack with `68` **"layers"**?

	???Example "Answers"
		<ol type="a">
		<li>
		Each $n$th layer has $n^2$ cubes. There are $34,058,310$ cubes in a stack with $467$ layers.
		```APL
			+/(⍳4)*2
		```
		```
		30
		```
		---
		```APL
			+/(⍳467)*2
		```
		```
		34058310
		```
		</li>
		<li>
		Each $n$th layer has $(2n-1)^2$ cubes. There are $713,849,500$ cubes in a stack with $812$ layers.
		```APL
			+/(¯1+2×⍳4)*2
		```
		```
		84
		```
		---
		```APL
			+/(¯1+2×⍳812)*2
		```
		```
		713849500
		```
		</li>
		<li>
		Each $n$th layer has $n^3$ cubes. There are $5,503,716$ cubes in a stack with $68$ layers.
		```APL
			+/(⍳3)*3
		```
		```
		36
		```
		---
		```APL
			+/(⍳68)*3
		```
		```
		5503716
		```
		</li>
		</ol>

1. Rewrite the following expressions so that they do not use parentheses.
	1. `(÷a)×b`
	1. `(÷a)÷b`
	1. `(a+b)-5`
	1. `(a+b)+5`

	???Example "Answers"
		<ol type="a">
		<li>Multiplication is commutative, so we can write `b×÷a`</li>
		<li>${{{1}\over{a}}\div{b}} = {{1}\over{a\times{b}}}$ so we can write `÷a×b`</li>
		<li>Use a literal negative five:`¯5+a+b`</li>
		<li>No parentheses needed: `a+b+5`</li>
		</ol>
