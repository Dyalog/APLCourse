# Problem set 5: Shape Reshape
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

	The positions of 5 points in 3D space are given by the matrix `pos←5 3⍴0 1 3 4 2`.

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
		???+ Example "Answers"

1. Without executing them, determine the shape of the results of the following expressions:

	<pre><code class="language-APL">      1 3 5∘.!2 4 6 8
	      1 2 3 + 4 5 6
	      {(+⌿⍵)÷≢⍵}3 1 4 1 5
	      +⌿2 3⍴⍳6
	      ?⌿2 3⍴3/4 52
	      (⌈⌿⍤2)(2 3⍴⍳6)∘.×¯1+?3 4⍴0</code></pre>

	??? Hint
		Of course, you can always check your answers using the shape function <code class='language-APL'>⍴</code>
