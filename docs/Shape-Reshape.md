# Shape Reshape

## Array basics
1. Experiment with the expressions in the following block to gain an understanding of the functions used. 
1. Write a brief definition in English for each expression.  
	For example: `{2×⍳⍵}   ⍝ Even integers from 2 to 2×⍵ inclusive`. 
1. Use the language bar to discover the names of unfamiliar functions.

```APL
      3 4⍴⍳12   ⍝ A 3 row, 4 column matrix of the integers from 1 to 12 inclusive      
      ⍴cards←'A23456789TJQK'∘.,'SCHD'
      ⍉cards
      (,cards)[?×/⍴cards]
      alph←2 3 4⍴⎕A
      ,alph      
```

## The shape of a scalar

Use the match function `⍺≡⍵` to determine which expressions below produce the empty character vector `''` ("*quote-quote*") and which produce the empty numeric vector `⍬` ("*zilde*").

          0⍴0
          0↑⎕A
          ⍳0
          0⍴''
          0⍴'def'
          0 0⍴'abc'
          2 0 3⍴⍳6
          alph[⍸alph='Z']
          ⌈⌿⍬⍬
          ⎕JSON'{}'
          ⎕JSON'[]'
          ⎕JSON'""'

A *simple array* contains only single numbers and/or characters as elements. Single numbers or characters are called *scalars*. Arrays generally can contain any other array. These are called *nested arrays*. For example `cards` is a nested matrix of character vectors.

```APL
      ⍴¨1 2 3 4   ⍝ What is the shape of each number in ⍳4?
      ⍴¨'ABCDE'   ⍝ What is the shape of each letter in 5↑⎕A?
      ⍴¨cards     ⍝ What is the shape of each array in cards?
```

## Problem set 5
1. 
	1. Write a function `IsEmpty` to determine if an array has an empty axis.
		<pre><code class="language-APL">      IsEmpty 2 0 3⍴⍳4</code></pre>
		<pre><code>1</code></pre>
		<hr>
		<pre><code class="language-APL">      IsEmpty 2 2 3⍴⍳4</code></pre>
		<pre><code>0</code></pre>
		<hr>
		<pre><code class="language-APL">      IsEmpty 0</code></pre>
		<pre><code>0</code></pre>
		<hr>
		<pre><code class="language-APL">      IsEmpty 0⍴0</code></pre>
		<pre><code>1</code></pre>

	1. Any simple array can be described using two vectors. Which two [primitive functions](https://aplwiki.com/wiki/Primitive_function) (that is, functions represented by symbols) return these vectors when given a simple array argument?

	1. The *rank* of an array is the number of *axes* or *dimensions* an array has. If the shape of an array `⍵` is given by the vector result of the shape function `⍴⍵`, give an expression for the rank of an array.

1. Some Points in Space 

	The positions of 5 points in 3D space are given by the matrix `pos`:
	
	<pre><code class="language-APL">pos←5 3⍴0 1 3 4 2</code></pre>

	1. Write a function `AddRows` to add a vector to a matrix.

		<pre><code class="language-APL">      1 ¯3 4 AddRows pos</code></pre>
		<pre><code>1 ¯2 7
		5 ¯1 4
		2  0 8
		3 ¯3 5
		4  1 6</code></pre>

	1. Write a function `NormRows` to normalise each vector in `pos` so that the sum of squares of each vector is `1`.

		<pre><code class="language-APL">      +/pos\*2</code></pre>
		<pre><code>10 20 26 5 29</code></pre>
		<hr>
		<pre><code class="language-APL">      +/(NormRows pos)\*2</code></pre>
		<pre><code>1 1 1 1 1</code></pre>
		<hr>
		<pre><code class="language-APL">      ÷/2-/pos</code></pre>
		<pre><code>0.5 1 2 ¯2 ¯0.5</code></pre>
		<hr>
		<pre><code class="language-APL">      ÷/2-/NormRows pos   ⍝ Relative proportions stay the same</code></pre>
		<pre><code>0.5 1 2 ¯2 ¯0.5</code></pre>

		??? Hint
			The replicate <code class='language-apl'>/</code> and reshape <code class='language-apl'>⍴</code> functions might be useful.

	!!! Hint "Bonus"
		Write commutative versions of `AddRows` which will still work when the vector and matrix arguments are swapped.

1. Without executing them, determine the shape of the results of the following expressions:

	<pre><code class="language-APL">      1 3 5∘.!2 4 6 8
	      1 2 3 + 4 5 6
	      {(+⌿⍵)÷≢⍵}3 1 4 1 5
	      +⌿2 3⍴⍳6
	      ?⌿2 3⍴3/4 52
	      ⌈/(2 3⍴⍳6)∘.×¯1+?5 4⍴0</code></pre>

	??? Hint
		Of course, you can always check your answers using the shape function <code class='language-APL'>⍴</code>
