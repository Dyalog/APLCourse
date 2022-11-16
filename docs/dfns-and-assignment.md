# Dfns and Assignment

## Dfns
A <dfn>dfn</dfn> (pronounced "*dee-fun*" with a very short "u" sound) is a way of writing functions in APL. It starts and ends with curly braces `{}`, has a right argument `⍵` (omega) and an optional left argument `⍺` (alpha).

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

## Syntactic name class
You may come across the following error:

```APL
      count ← {+/⍵}
      count ← {+/⍵} 1 0 0 1 0 1 0
```
```
SYNTAX ERROR: Invalid modified assignment, or an attempt was made to change nameclass on assignment
      count←{+/⍵}1 0 0 1 0 1 0
      ∧
```

Things in APL have both a word and a number which identifies what type of thing it is. This is called its [**name class**](http://help.dyalog.com/latest/#Language/System%20Functions/nc.htm). So far we have met **variables** (nameclass 2) and **functions** (nameclass 3). There are more than these, but they will be introduced in relevant chapters.

In Dyalog APL, if a name already has a function assigned, that same name cannot then be assigned an array value. Nor vice versa. If this happens, erase the name and try again.

```APL
      )ERASE count
      count←{+/⍵}1 0 0 1 0 1 0
      count
3
```

!!!Question "What is this `)ERASE` thing?"
	We have just used a <dfn>system command</dfn>. They are available while using the Dyalog interpreter or TryAPL interactively. However, they cannot be used inside functions and they are not standard APL syntax. In the section on [system functions and system commands](./Workspaces.md#system-commands) we will learn about things like showing a list of the currently defined names and how to erase names programmatically (there is a <dfn>system function</dfn> `⎕EX`). In the meantime, we will introduce system functions and commands as needed.

## Multiline functions and the editor
You can do quite a lot in a single line of APL. However, it is not long before you want to keep sequences of multiple statements available for re-use. Of course we can write functions which consist of multiple statements.

The <dfn>statement separator</dfn>, `⋄` (diamond), allows us to write multiple APL statements in a single line. Some people think that it is more readable to spread multiple statements across multiple lines of a function. However, it is worth being aware that APL diamonds `⋄` are equivalent to newline characters in terms of execution. The following two definitions of the `Mean` function are equivalent.

```APL
 Mean ← {
	sum ← +/⍵
	count ← ≢⍵
	sum ÷ count
 }

 Mean ← { sum ← +/⍵ ⋄ count ← ≢⍵ ⋄ sum÷count }
```

Separate statements are executed from left to right and top to bottom.

**To edit multiline functions** in the IDE for Microsoft Windows and the RIDE, invoke the editor with the system command `)ED`. You can find a step-by-step example of creating a multiline function in the Dyalog editor in [chapter 5 of Mastering Dyalog APL](https://mastering.dyalog.com/User-Defined-Functions.html?highlight=editor#a-working-example).

**On TryAPL**, the current execution block can be continued on to a new line using <kbd>Alt+Enter</kbd>. The continuation line begins with a tab character. To execute the block, simply press <kbd>Enter</kbd> after your final line is typed. Here is an example defining a multiline dfn:

1. Type `Sum ← {` and press <kbd>Alt+Enter</kbd>
2. Type `⍺+⍵` and press <kbd>Alt+Enter</kbd>
3. Type `}` and press just <kbd>Enter</kbd>
4. The function `Sum` is now defined in your workspace. Try the expression `3 Sum 4`.

## Problem set 2
The following problems can be solved with single-line dfns.

1. Eggs

	A recipe serving 4 people uses 3 eggs. Write the function `Eggs` which computes the number of eggs which need cracking to serve `⍵` people. Using a fraction of an egg requires that a whole egg be cracked.

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

	???Example "Answer"
		```APL
		Eggs ← {⌈⍵×3÷4}
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

	**BONUS:** What if `⍺>⍵`?  
	```APL
	      3 To 5
	3 4 5
	      5 To 3
	5 4 3
	      5 To ¯2
	5 4 3 2 1 0 ¯1 ¯2
	```

	???Example "Answer"
		In the simple case, make sure to generate enough numbers and use `⍺` as an offset:  
		```APL
		To ← {⍺+¯1+⍳1+⍵-⍺}
		```
		In general we take into account whether the difference is positive or negative:  
		```APL
		To ← {⍺+(×d)×¯1+⍳1+|d←⍵-⍺}
		```

1. The forumla to convert temperature from Celcius ($T_C$) to Farenheit ($T_F$) in traditional mathematical notation is as follows:

	$$T_F = {32 + {{9}\over{5}}\times {T_C}}$$  

	Write the function `CtoF` to convert temperatures from Celcius to Farenheit.  
	```APL
	      CtoF 11.3 23 0 16 ¯10 38
	52.34 73.4 32 60.8 14 100.4
	```

	???Example "Answer"
		```APL
		CtoF ← {32+⍵×9÷5}
		```

1. Prime Time

	A prime number is divisible only by itself and `1`.

	Write a dfn which returns `1` if its argument is prime and `0` otherwise.

		          IsPrime 21
	    0
		          IsPrime 17
	    1

	???Example "Answer"
		There are several ways to code this, but the basic method is to count the number of divisors.
		```APL
		IsPrime ← {2=+/d=⌊d←⍵÷⍳⍵}
		IsPrime ← {2=+/0=(⍳⍵)|⍵}
		```