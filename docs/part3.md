# Part 3

## Multidimensional Arrays
Given:

```apl
a←1 2 1 ⋄ b←2 3 4 1 ⋄ c←1 5 3 4 1 5
```

What is the output of the following?

1. `+/⍳99`
1. `⍴⍬`
1. `⍴⍬,⍬`
1. `⋄ ⍳3 ⋄⋄⍳5`
1. `⍴⍪⍪⍳2`
1. `3⍪⍪⍳2`
1. `⍴,⍪⍳8`
1. `⎕←⍴a,b`
1. `⍴,b∘.+c`
1. `⍴⎕`
1. `⍴⍪7`


## Selecting from Arrays
Given

```apl
 a←1 2 1 ⋄ b←2 3 4 1 ⋄ c←1 5 3 4 1 5
 A←'abcdefghij' ⋄ B←6⌊c∘.+c ⋄ C←b∘.×B
```

what are the results of the following expressions?

1. `⍴B`
1. `⍴C`
1. `⍴A[a]`
1. `⍴A[B]`
1. `⍴A[3]`
1. `⍴A[3 10]`
1. `⍴A[c,c]`
1. `⍴A[12⍴1]`
1. `⍴B[a;a]`
1. `⍴B[a;c]`
1. `⍴B[1;b]`
1. `⍴B[B;2]`
1. `⍴B[,2;b]`
1. `⍴B[B;B]`
1. `b[b]`
1. `⍴88[a]`
1. `2 2↑B`
1. `2 2↓B`
1. `2 2 3↑C`
1. `0 2 8↑C`
1. `0 2 8↑B`
1. `2/a`
1. `0 1 2/a`
1. `⍴b/b`
1. `⍴b/[1]C`
1. `⍴c/B`
1. `⍴c/C`
1. `⍴c⌿C`
1. `⍴a/B`
1. `⍴⎕←a⌷C`
1. `⍴C[a;a;a]`
1. `⍴a a a⌷C`
1. `⍴C[a;a;]`
1. `⍴C[a;;]`
1. `⍴C[;;]`
1. `⍴B[;]`
1. `⍴A[]`
1. `⍴12[]`
1. `2 8 ↑ B`
1. `0 9 ↑ B`
1. `3  1 ↑ 2 2↓B`
1. `3 ↑ 2 2↓B`
1. `B[;1] ←⍳9`