# Selecting from lists
<div align="center">
<iframe width="560" height="315" src="https://www.youtube.com/embed/Gb7KFDlJV1Q" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

## Indexing
In many other programming languages, "selection" is used to describe control structures such as ["if then else"](https://en.wikipedia.org/wiki/Conditional_(computer_programming)#If%E2%80%93then(%E2%80%93else)) or ["switch case"](https://en.wikipedia.org/wiki/Conditional_(computer_programming)#Case_and_switch_statements). In APL, we can get a similar effect by literally "selecting" elements from arrays. 

```APL
      'APPLE'[1 3 4]                         ⍝ Select elements 1, 3 and 4
```
```
APL
```
---
```APL
      ⍸ 1 0 0 1 0 1                          ⍝ Where are the 1s?
```
```
1 4 6
```
---
```APL
      (⍳5) IsDivisibleBy 2                   ⍝ 1 Where ⍺ is even
```
```
0 1 0 1 0
```
---
```APL
      {⍵[⍸⍵ IsDivisibleBy 123]}⎕AVU          ⍝ Numbers in ⎕AVU divisible by 123
```
```
0 123 8364 246
```

## Replicate/Compress
Finding the indices of a boolean array using the "where" function `⍸⍵` is an unnecessary extra step since we know that indices will never be repeated in this case.

The **replicate** function `⍺/⍵` (yes, some symbols have <a target="_blank" href="https://aplwiki.com/wiki/Function-operator_overloading">multiple meanings</a>) repeats elements of an array along rows.

```APL
      1 2 3/'ABC'
```
```
ABBCCC
```
---
```APL
      1 2 3/2 3⍴'DYALOG'
```
```
DYYAAA
LOOGGG
```
---
```APL
      1 ¯2 3/2 3⍴'DYALOG'
```
```
D  AAA
L  GGG
```

When used with a boolean array, the function is called **compress**.

```APL
      0 1 0/2 3⍴'DYALOG'
```
```
Y
O
```

## Shape/Reshape

In the previous section you wrote the `Tally` function. There are two related [*primitive* functions](https://aplwiki.com/wiki/Primitive_function) `≢⍵` and `⍴⍵`. The examples above show the creation of arrays using reshape `⍺⍴⍵`.

Take a moment to experiment with the shape `⍴`, tally `≢` and reshape `⍴` functions to get a feel for how they behave. What is the shape of the shape of an array? What is the shape of the tally?

!!! note
	You might find that some arguments to reshape produce intolerably long output. Use the command `]rows -fold=3` to truncate the output.
