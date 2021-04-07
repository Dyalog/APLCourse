# Loops and recursion
Looping is an incredibly basic and fundamental programming construct which you will notice we have barely used at all so far.

### An introduction to an introduction to an introduction to an introduction to an int...

Try the following dfns with various numeric arguments and consider the following:

1. Which symbol refers to the function itself? 
1. Which symbol separates expressions? 
1. Which part represents a conditional? This is where one part of code executes only if a preceding statement is true.
1. What is the default left argument? What happens if you call this function dyadically?

```APL
      {⍺←1 1 ⋄ ⍵=2:⍺ ⋄ (⍺,(+/¯2↑⍺))∇⍵-1}
```

Give the function [an appropriate name](https://en.wikipedia.org/wiki/Fibonacci_number).

When a function calls itself like this it is called *recursion*. APL tends to rely less on explicit iteration and recursion than most popular programming languages, but it is good to be able to do it when you need to.

If a function gets stuck in an infinite loop, use `Action → Interrupt` in the menu. You can also use the key combination `Ctrl+Break` to interrupt a running function.

1. Write the shortest dfn which causes infinite recursion.

1. Write the shortest dfn which causes infinite recursion unless its argument is `0`.

1. The factorial function multiplies integers up to `⍵`. Write the factorial function as a **recursive** dfn called `Factorial`. Use the primitive `!N` factorial function to check your solution. 

1. Write an expression for the factorial function as a reduction (an expression which includes `f/` for some function `f`).

### A Sort of Detour
Dyalog's *grade-up* `⍋` and *grade-down* `⍒` functions are able to [sort any array](https://aplwiki.com/wiki/Total_array_ordering). However, it is interesting and useful to look at other approaches to sorting.

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
      ⍋4 2 2⍴∊1 2 3 4,¨?4⍴(⊂3⍴10)
      ⍒4 2 2⍴∊'ABCD',¨{⎕A[⍵]}¨?4⍴(⊂3⍴10)
```