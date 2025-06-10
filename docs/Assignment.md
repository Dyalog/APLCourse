# Assigning to arrays

## Indexed Assignment
Assign values at specified indices.

```APL
      t←4 4⍴'some sample text'
      t[⍸t∊'aeiou']←'!'
```

## Selective Assignment
Define `n←5 5⍴⍳25` in your workspace.

1. Using selections, find at least four different ways to set the bottom-right 3 by 3 submatrix in `n` to `0`.
	For example, `(2 2↓n)←0`.

	??? Hint
		See which primitives may be used in a <a href='http://help.dyalog.com/latest/#Language/Primitive%20Functions/Assignment%20Selective.htm?Highlight=selective%20assignment'>selective assignment</a>

## Modified Assignment
Experiment with the following expressions, paying particular attention to the `name f← array` construct.

```APL
      salaries←18250 42500 56000 57250 48640
      codes←'ACDDC'
      salaries×←1.1
      salaries[⍸codes='C']×←1.05

      a←⎕A
      (3↑a),←'abc'
      (¯4↑a),←'xyz'  ⍝ this one will error — think about why!
```

## At

Monadic functions take a single right argument array as input. Dyadic functions take two argument arrays.

Monadic operators take a single left operand which can be a function or an array (as in `+/` where plus `+` is the function operand and reduce `/` is the operator). 

Dyadic operators take two operands which could be functions or arrays depending on the operator's definition. For example, the rank operator `F⍤k` takes a function left operand `F` and array right operand `k` of up to 3 elements.

Selective and indexed assignment methods will change the values of variables. The "at" operator `@` merges two arrays at specified indices and returns a new array.

If a function right operand returns a boolean array when applied to `⍵` (e.g. `3=1 3 5`) then ones `1` in the boolean array determine where scalars of `⍺` are inserted.

```APL
      ('∆⍥'@{⍵∊'AEIOU'})2 3⍴'DYALOG'
      (' '@2 3 4)'DYALOG'
      (' '@(1 2)(1 3)(2 1))2 3⍴'DYALOG'
```

1. The following expression contains an error:  
	`      ('∆⍥'@1)2 3⍴'DYALOG'`  
	Change the parenthesised function containing `@` in **two** ways so that it gives the following results:  
	1. 
		<pre><code>∆∆∆
		LOG</code></pre>  
	1. 
		<pre><code>∆∆∆
		⍥⍥⍥</code></pre>

Generally, the left operand to `@` is a function applied to scalars in `⍵` which are specified by a right operand that is either an array of scalar (simple or enclosed vector) indices or a boolean array returned by a right operand function. An array left operand is shorthand for a [constant function](https://aplwiki.com/wiki/Constant) that returns the array.

```APL
      {1↓1∘⎕C@(¯1⌽' '∘=)' ',⍵}'my excellent heading'
```

## Strand Assignment
[**Distributed assignment**](http://help.dyalog.com/latest/#Language/Introduction/Namespaces/Distributed Assignment.htm) or **strand assignment** allows multiple names to be defined using a single assignment arrow `←`.

```APL
      (max min avg)←{(⌈⌿⍵)(⌊⌿⍵)((+⌿÷≢)⍵)}3 1 4 1 5
```

!!! Note
	Strand assignment does not require names to be parenthesised, but we strongly recommend it for clarity.

We can assign items in `nest` to the three variables `s←'A'` `v←1 2 3` and `m←3 3⍴⍳9` using a single assignment arrow.

```APL
      nest←('A'(1 2 3))(3 3⍴⍳9)
      ((s v) m)←nest
```

!!! Warning
	You might have some issues when using inline, modified or strand assignment in dfns. This is by design, but can be a source of confusion.
	<pre><code class="language-APL">      {a←3 ⋄ f←+ ⋄ a f←3 ⋄ a}⍬
	3
	      a←3 ⋄ f←+ ⋄ a f←3 ⋄ a
	6</code></pre>  
	
	You can get around these problems by writing `∘⊢` (or in 12.1: `∘{⍵}` ) to the immediate right of any function involved:
	<pre><code class="language-APL">      {a←3 ⋄ f←+ ⋄ a f∘{⍵}←3 ⋄ a}⍬
	6</code></pre>

