# Dfns and assignment

<div align="center">
<iframe width="560" height="315" src="https://www.youtube.com/embed/A8xNTh8_F9g" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

## Dfns
A dfn (pronounced "*dee-fun*" with a very short "u" sound) is a way of writing functions in APL. It starts and ends with curly braces `{}`, has a right argument `⍵` (omega) and an optional left argument `⍺`.

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

From here, when functions are first introduced, `f⍵` ("eff omega") denotes a monadic function `f` and `⍺f⍵` denotes a dyadic function.

## Assignment
Names are assigned with the left arrow `⍺←⍵`\*. We say "name gets [function or array]".

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

!!! note
	\* Assignment is not exacly implemented like other functions are in Dyalog, but it basically behaves like a dyadic function which returns the value assigned.

> \*\* Get Adam to review

We can use a name in the same line in which it is defined. In production code it is best to avoid this unless an expression is very short.

Read the following as "squared numbers divided by the sum of squares":
```APL
      squared÷+/squared←¯1 0 1 2*2
```
```
0.1666666667 0 0.1666666667 0.6666666667`
```
