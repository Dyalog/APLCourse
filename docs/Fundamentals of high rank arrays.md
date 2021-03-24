# Fundamentals of high rank arrays

## Matching dimensions

1. Experiment with the following examples. Try to describe each one in your own words.
1. Describe how the rank operator `F⍤r` applies a function `F` in terms of `⍺` and `⍵`. Do not be discouraged by longer expressions and unfamiliar symbols. To help understanding, break down the expression and try pieces of it at a time. 

```APL
      names←↑'Angela' 'Pete' 'Leslie'   ⍝ A matrix of names padded with spaces
      scores←3 6 8
      'Pete  '(=⍤1 1)names
      scores[names⍳'Pete  ']
      (∧/names(=⍤1 1)'Pete  ')⌿scores
      names(∨/⍷⍤1)(⊃⌽⍴names)↑'Pete'
      mass←1 3 5 8 4
      pos←5 3⍴0 1 3 4 2
      {(+⌿⍵)÷≢⍵}mass(×⍤0 2)pos
      ×⍤0 2⍨⍳10      
```

??? Hint
	When applying dyadic functions using the rank operator, use the helper function <code class="language-APL">,⍥⊂</code> <em>ravel over enclose</em> (or <code class="language-APL">{⍺⍵}</code> for versions before Dyalog version 18.0) to see how arguments are paired up. For example:
	<pre><code class="language-APL">      names(,⍥⊂⍤1 1)'Pete  '
	      ⍉pos,⍥⊂⍤2 0⊢mass</code></pre>
	If you still feel stuck, continue reading below and return to these expressions later.

## First- and last-axis primitives

Which of the following functions are affected by the rank operator `⍤` and why are the other functions not affected?

```APL
      ⌽    ⍝ Reverse
      ⊖    ⍝ Reverse first
      +/   ⍝ Plus reduce
      +⌿   ⍝ Plus reduce-first
```

## Cells and axes
From the APL Wiki: 
<blockquote>
      A <a target="_blank" href="https://aplwiki.com/wiki/Cell">cell</a> is a subarray which is formed by selecting a single index along some number of leading axes and the whole of each trailing axis. Cells are classified by their rank, which may be between 0 (scalars) and the array's rank (in which case the cell must be the entire array). Cells with rank k are called k-cells of an array. A major cell is a cell whose rank is one less than the entire array, or a 0-cell of a scalar. 
</blockquote>
If the text above feels confusing, don't worry. Possibly after this chapter, and almost certainly after [the next section on selecting from arrays](selecting from arrays.md), you will be able to read it again and say to yourself "oh yeah, that makes sense". What you need to know for now is that arrays are arranged like rectangles in many dimensions. The three simplest cases should feel somewhat familiar to you.

```APL
      0            ⍝ A scalar
0
      'APL'        ⍝ A vector
APL
      0 1 2∘.*⍳5   ⍝ A matrix
0 0 0  0  0
1 1 1  1  1
2 4 8 16 32
```

Now let us look at an array with 3 dimensions. We will call it a `cuboid`:

```APL
      ⍴cuboid←2 3∘.+3 4 5∘.×4 5 6 7
2 3 4 ← trailing (last) axis
↑
leading (first) axis
```

In the array `cuboid` defined above, there are `2` **major cells**, which are those of rank `¯1+≢⍴cuboid`.

```APL
      2 3 4⍴⎕A
ABCD
EFGH
IJKL
    
MNOP
QRST
UVWX
      ≢2 3 4⍴⎕A      ⍝ Tally counts the major cells
2
```

The dimensions of an array are also known as **axes**. The most major cells, the rank `k-1` cells for an array of rank `k`, lie along the *first* axis. The least major cells are columns which lie along the *last* axis.

For more details on the APL array model in Dyalog and other array languages, see [the APL Wiki article on the array model](https://aplwiki.com/wiki/Array_model).

Now that you know how to describe the structure of an array in terms of its sub-arrays, let us look at how to apply functions to sub-arrays.

## Rank vs. Axis
We have seen two pairs of *first-* and *last-axis* primitives.

```APL
      n←2 3⍴1 2 3 1 0 ¯1
      n
1 2  3
1 0 ¯1
      +/n                ⍝ Sum along the last axis
6 0
      +⌿n                ⍝ Sum along the first axis
2 2 2
      '-'⍪2 3⍴'DYALOG'   ⍝ Catenate first
---
DYA
LOG
      '|',2 3⍴'DYALOG'   ⍝ Catenate last
|DYA
|LOG
```

Some functions and operators can be used along specified axes using the **function axis operator** `[]` (more <a target="_blank" href="https://aplwiki.com/wiki/Function-operator_overloading">duplicitous</a> symbols).

Compare the behaviour of the monadic function `⊂` *enclose* when applied with the rank operator `⍤` versus when it is applied using **bracket axis** (another name for the *function axis operator* `[]`).

```APL
      ⊂⍤1⊢3 2 4⍴⎕A
┌────┬────┐
│ABCD│EFGH│
├────┼────┤
│IJKL│MNOP│
├────┼────┤
│QRST│UVWX│
└────┴────┘
      ⊂⍤2⊢3 2 4⍴⎕A
┌────┬────┬────┐
│ABCD│IJKL│QRST│
│EFGH│MNOP│UVWX│
└────┴────┴────┘
      ⊂⍤3⊢3 2 4⍴⎕A
┌────┐
│ABCD│
│EFGH│
│    │
│IJKL│
│MNOP│
│    │
│QRST│
│UVWX│
└────┘
```

```APL
      ⊂[1]⊢3 2 4⍴⎕A
┌───┬───┬───┬───┐
│AIQ│BJR│CKS│DLT│
├───┼───┼───┼───┤
│EMU│FNV│GOW│HPX│
└───┴───┴───┴───┘
      ⊂[2]⊢3 2 4⍴⎕A
┌──┬──┬──┬──┐
│AE│BF│CG│DH│
├──┼──┼──┼──┤
│IM│JN│KO│LP│
├──┼──┼──┼──┤
│QU│RV│SW│TX│
└──┴──┴──┴──┘
      ⊂[3]⊢3 2 4⍴⎕A
┌────┬────┐
│ABCD│EFGH│
├────┼────┤
│IJKL│MNOP│
├────┼────┤
│QRST│UVWX│
└────┴────┘
```

For a more in-depth look at the relationship between function rank and function axis, watch the Dyalog webinars on [Selecting from Arrays](https://dyalog.tv/Webinar/?v=AgYDvSF2FfU) and [The Rank Operator and Dyadic Transpose](https://dyalog.tv/Webinar/?v=zBqdeDJPPRc).

A list of functions with bracket-axis definitions can be found on [the APL Wiki page for function axis](https://aplwiki.com/wiki/Function_axis).

