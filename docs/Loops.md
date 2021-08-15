# Loops and recursion
Looping is an incredibly basic and fundamental programming construct which you will notice we have barely used at all so far. Or at least, we haven't used many explicit loops.

!!! Note "Terminology"
	The type of looping over items in a collection as provided by *for* and *while* loops is sometimes referred to as **scalar looping**. Other types of looping in APL might, for example, process each row of a matrix in turn but process whole rows at a time. In contrast, [each `¨`](/Nested/#each-a-primitive-for-explicit-loops) is a mechanism for looping over every item of an array (the [scalars](/Array model/#cells-and-axes)); its operand function can see arrays nested within the scalars.

## An introduction to an introduction to an introduction to an introduction to an int...

```APL
      {⍺←1 1 ⋄ ⍵=2:⍺ ⋄ (⍺,(+/¯2↑⍺))∇⍵-1}
```

Try the dfn above with various numeric arguments and consider the following questions:

1. Which symbol refers to the function itself? 
1. Which symbol separates expressions? 
1. Which part represents a conditional? This is where one part of code executes only if a preceding statement is true.
1. What is the default left argument? What happens if you call this function dyadically?

Give the function [an appropriate name](https://en.wikipedia.org/wiki/Fibonacci_number).

When a function calls itself like this it is called *recursion*. APL tends to rely less on explicit iteration and recursion than most popular programming languages, but it is good to be able to do it when you need to.

If a function gets stuck in an infinite loop, use `Action → Interrupt` in the menu. You can also use the key combination `Ctrl+Break` to interrupt a running function.

1. Write the shortest dfn which causes infinite recursion.

1. Write the shortest dfn which causes infinite recursion unless its argument is `0`.

1. The factorial function multiplies integers up to `⍵`. Write the factorial function as a **recursive** dfn called `Factorial`. Use the primitive `!⍵` factorial function to check your solution. 

1. Write an expression for the factorial function as a reduction (an expression which includes `f/` for some function `f`).

## A sort of detour
Dyalog's *grade-up* `⍋` and *grade-down* `⍒` functions are able to [sort any array](https://aplwiki.com/wiki/Total_array_ordering). However, it is interesting and useful to look at other approaches to sorting.

!!! Warning "Version Warning"
	Total array ordering was introduced to Dyalog in version 17.0.

Here is a function 'NSort' for sorting numeric lists.

```APL
      NSort←{0=⍴⍵:⍬ ⋄ (U/⍵),∇(~U←⍵=⌊/⍵)/⍵}
```

Try `NSort` with some numeric arguments. Here it is presented piece-by-piece. For each comment prompt `⍝`, write a brief description of what that part of the function does. The first one has been done for you.

```APL
      NSort←{
             0=⍴⍵:⍬                         ⍝ Reached end of list, return empty numeric vector
                    ⋄                       ⍝ 
                      (U/⍵),                ⍝ 
                            ∇               ⍝
                             (~U←⍵=⌊/⍵)     ⍝
                                       /⍵   ⍝
                                         }
```

Below is a function `TSort` for sorting character matrices.

```APL
      TSort←{⍺[((⍴⍵)[2])S ⍺⍳⍵]}
      S←{⍺=0:⍵ ⋄ (⍺-1)S ⍵[⍋⍵[;⍺];]}
```

Examine `TSort` and replace `⍺` below with an appropriate left argument to sort the character matrix `WORDS`.

```APL
      WORDS←↑'DOLPHIN' 'BRACKEN' 'SAUCER' 'MAGNET' 'FLOP'
      ⍺ TSort WORDS
BRACKEN
DOLPHIN
FLOP   
MAGNET 
SAUCER 
```

What do the following expressions tell you about the `⍋` grade-up and `⍒` grade-down functions on high-rank arrays?

```APL
      ⍋4 2 2⍴'ABDCAADCBCDECDEF'
2 1 3 4
      ⍒4 2 2⍴'ABDCAADCBCDECDEF'
4 3 1 2
```

## You have the power
One common type of iteration is to apply the same function again to the result of the previous application. In traditional mathematics, this is expressed with superscript notation:

$f(x) = 1 + x$ Increment  
$p(x,y) = f^y(x)$ Add  
$m(x,y) = p^y(x,0)$ Multiply

We can express this with the **power** operator:

```APL
      Inc←{1+⍵}
      Plus←{(Inc⍣⍺)⍵}
      Times←{⍺(Plus⍣⍵)0}
      Power←{⍺(Times⍣⍵)1}
```

## Primitive iterations are still loops
You might have noticed this already, but it is important to know that the rank operator `F⍤j k l` is conceptually a loop. It just happens to be that certain operations are parallelisable, and some of those are parallelised within the Dyalog interpreter.

We will give some details later in [the section on performance](../Interpreter-internals/#performance).

## Reduction is a loop
Primitive reductions are often optimised. For example, **plus-reduction** `+/` is able to take advantage of [vector instructions](https://dyalog.tv/Dyalog19/?v=TqmpSP8Knvg) on certain machines and **and-reduction** `∧/` can quit early if a zero is found in the array.

We can observe differences by writing a custom function and comparing runtimes:
```
      ]runtime +/?1e7⍴0

* Benchmarking "+/?1e7⍴0"
             (ms) 
 CPU (avg):    94 
 Elapsed:      99 
 
 
 
      ]runtime {⍺+⍵}/?1e7⍴0

* Benchmarking "{⍺+⍵}/?1e7⍴0"
             (ms) 
 CPU (avg):  3688 
 Elapsed:    3723 
```

## Moving windows
**Windowed-reduction** `⍺ F/ ⍵` is an extension to reduction which applies an *F-reduction* `F/` for a function `F` on a sliding window of size `⍺`.

It is useful to use catenate to display the windowed selection of the array to which the reduction will be applied:
```APL
      3,/⍳10
```
```
┌─────┬─────┬─────┬─────┬─────┬─────┬─────┬──────┐
│1 2 3│2 3 4│3 4 5│4 5 6│5 6 7│6 7 8│7 8 9│8 9 10│
└─────┴─────┴─────┴─────┴─────┴─────┴─────┴──────┘
```
---
```APL
      3+/⍳10
```
```
6 9 12 15 18 21 24 27
```

You can think of this as a special case of [stencil code](https://en.wikipedia.org/wiki/Iterative_Stencil_Loops), for which the [primitive operator](https://aplwiki.com/wiki/Primitive_operator) **stencil** `⌺` was added in version 16.0.

```APL
      1↓¯1↓{+/⍵}⌺3⊢⍳10
```
```
6 9 12 15 18 21 24 27
```

!!! Warning "Version Warning"
	In Dyalog Classic, the glyph for stencil `⌺` is not available and is instead represented by `⎕U233A`. You might want to wrap it in a named [dop](../Operators#dop).
	<pre><code class="language-APL">      \_S\_←{⍺←⊢ ⋄ ⍺ (⍺⍺⎕U233A⍵⍵) ⍵}
	      1↓¯1↓{+/⍵}\_S\_ 3⊢⍳10
	6 9 12 15 18 21 24 27</code></pre>

## Don't forget scan!
**Scan** `F\⍵` is another construct which is simple in a way that misleads you into thinking it is only used for very specific things. It is exactly a reduction `F/` on successive prefixes of `⍵`. The final value is `F/⍵`.

```APL
      +/⍳10
55
      +\⍳10
1 3 6 10 15 21 28 36 45 55
      
      ⌈\2 0 3 ¯1 4 2 6
2 2 3 3 4 4 6
```

However, scan can be used in many scenarios that you might not expect. Scans are often used in high performance expressions of **partitioned-application** functions which nowadays can be implemented with partitioning primitives (`⍺⊂⍵` and `⍺⊆⍵`), nested arrays and the each operator `F¨`. 

For example, one [YouTube video comparing APL and Haskell](https://youtu.be/QtvvQ7MdwKY) demonstrates one of the big differences in the APL approach in contrast to other types of programming. 

```APL
      4 {1↓∊' '∘,¨⍺↑' '(≠⊆⊢)⍵} 'take the first four words'
```
```
take the first four
```

---

```APL
      4 {⍵⌿⍨⍺>+\' '=⍵} 'take the first four words'
```
```
take the first four
```

Despite both having types of function composition, Haskell and other functional programming languages tend to focus on the composition of those functions as the fundamental process to finding and refining solutions. In APL, we are usually most interested in the fundamental data transformation that is occuring, and using APL's inherently parallel, array-at-a-time primitives to achieve that transformation in a way that can tend towards simple and fast code.

Between integer and boolean arguments alone there are more interesting constructs than can be covered well here. You can find more on this topic by going to the following links:  

- Watch the Dyalog webinar about [Boolean Scans and Reductions](https://www.youtube.com/watch?v=erv_1LxEByk&list=PLA9gQgjzcpKGwmgzlayqzS_z1ThDwFzl4&index=3)
- Experiment with the examples in an [interactive notebook on TryAPL](https://tryapl.org/?notebook=https%3A%2F%2Fgithub.com%2FDyalog%2Fdyalog-jupyter-notebooks%2Fblob%2Fmaster%2FBoolean+Scans+and+Reductions.ipynb)
- You can [view the static notebook online](https://nbviewer.jupyter.org/github/Dyalog/dyalog-jupyter-notebooks/blob/master/Boolean%20Scans%20and%20Reductions.ipynb)


## For and While
The traditional control structures such as *for loops*, *while loops* and *if statements* weren't introduced in Dyalog [until version 8.0 in 1996](https://aplwiki.com/wiki/Dyalog_APL#Versions). Usually, they are only used for program control on the outer levels, or if an algorithm explicitly requires that type of [scalar looping](#).

The syntax is mentioned in the [section on user-defined functions](../Ufns/#marking-tests).

!!! Hint "Peformance note"
	When constructing loops, think about whether unnecessary computation is being performed.
	
	For example,
	
	<pre><code class="language-APL">:While LikelyToBeFales
	:AndIf ExpensiveTest</code></pre>
	
	is probably better than
	
	<pre><code class="language-APL">:While LikelyToBeFales∧ExpensiveTest</code></pre>
	
	You will also often see:
	
	<pre><code class="language-APL">:While PreCondition
	:AndIf OnlyComputableIfPreCondition</code></pre>

## Problem set 8

### Bell Numbers
A [Bell number](https://en.wikipedia.org/wiki/Bell_number) counts the possible partitions of a set. The n<sup>th</sup> Bell number $B_n$ counts the ways you can partition a set of $n$ elements.

Here we will investigate 3 ways of computing Bell numbers.

1. Brute force
	
	Write a function `BellBrute` which counts all of the unique partitions of length `⍵` by creating partitions as nested arrays.
	
	??? Hint
		Binary representations of decimal numbers can be used as partition vectors.

1. Triangle scheme
	
	Implement the [triangle scheme](https://en.wikipedia.org/wiki/Bell_number#Triangle_scheme_for_calculations) for calculations.

1. Recurrance relation of binomial coefficients
	The Bell numbers satisfy a recurrence relation involving binomial coefficients:
	
	$B_{n+1} = \sum_{k=0}^{n}\binom{n}{k}B_k$
	
	Implement `BellRecur` using this formula.

### Four is Magic
[Rosetta Code](http://rosettacode.org/wiki/Four_is_magic) has the full problem description.

Start with a number. Spell that number out in words, count the number of letters and say it all aloud. For example, start with 6, print `'Six is three'` and continue with the number 3. Once you reach 4, print `four is magic`. 

```
      FourMagic 11
Eleven is six, six is three, three is five, five is four, four is magic.
```

### Hash counting string
This problem is from [week 102 of the Perl Weekly Challenge](https://theweeklychallenge.org/blog/perl-weekly-challenge-102/).

Write a monadic function `HashCount` which takes a scalar integer argument and returns a simple character vector where:

- the string consists only of digits 0-9 and octothorpes AKA hashes, ‘#’
- there are no two consecutive hashes: ‘##’ does not appear in your string
- the last character is a hash
- the number immediately preceding each hash (if it exists) is the position of that hash in the string, with the position being counted up from 1

```
      HashCount 1
#
      HashCount 2
2#
      HashCount 3
#3#
      HashCount 10
#3#5#7#10#
      HashCount 14
2#4#6#8#11#14#
```

### Backspace
Write a function `Backspace` which takes a simple numeric vector argument and treats `0`s like backspaces, removing successive numbers to their left unless none remain.

```
      Backspace 1 2 0
1
      Backspace 1 5 5 0 2 0 0 8
1 8
```

For an extra challenge, modify your function so that it can also accept a character vector where `\b` is treated as a single token and signifies a backspace character.