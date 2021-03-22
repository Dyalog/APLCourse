# First Steps
<div align="center">
<iframe width="560" height="315" src="https://www.youtube.com/embed/b9T3PdYW5v0" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

It is easy to add lists of numbers together
```APL
      1 2 3 + 4 5 6
```
```
5 7 9
```

Negative numbers are written with a high minus `¯` to differentiate between negation `¯3 = -3` and literal negative numbers
```APL
      1 2 3 - 1 0 ¯1
```
```
0 2 4
```

## Singleton extension
Dyadic functions (functions with two input arguments, one on the left and one on the right) can map between a single value and an array of values.
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

## The reduction operator
Adding a list of numbers *could* become very tedious...
```APL
      1+2+3+4+5+6+7+8+9+10+11+12+13+14+15
```
```
120
```

The reduce operator `F/` inserts the function `F` to its left between parts of the right argument array.
```APL
      +/1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
```
```
120
```

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

## Order of execution
Infix (dyadic) functions have a **short** *left* scope and **long** *right* scope. 
```APL
      10×⍳2+5
```
```
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
15 25
```
