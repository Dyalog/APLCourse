# Problem set 5: Shape Reshape
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

	??? Example "Answers"
		<ol type="a">
			<li><pre><code class="language-APL">IsEmpty←{0∊⍴⍵}</code></pre></li>
			<li>The functions **shape** `⍴⍵` and **ravel** `,⍵` return these two vectors, which are called the *shape* and the *ravel of elements*.</li>
			<li>Traditionally, the rank is defined as the *shape of the shape* `⍴⍴⍵`. However, in modern APL it is preferable to use the tally of the shape `≢⍴⍵`.</li>
		</ol>

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

	??? Example "Answers"
		<ol type="a">
			<li>This solutions assumes a vector left argument:  
				<pre><code class="language-APL">AddRows ← {⍵+(⍴⍵)⍴⍺}</code></pre>
			</li>
			<li>Using only things which have been introduced so far:
				<pre><code class="language-APL">NormRows ← {⍵÷(⍴⍵)⍴(⍴⍵)[2]/0.5\*⍨+/⍵*2}</code></pre>
			</li>
		</ol>
	
	??? Example "Bonus Answers"
		A commutative version of `AddRows` can be made by sorting using the ranks, and is expressed most clearly as two expressions separated by the **statement separator** `⋄`
		<pre><code class="language-APL">AddRows ← {(v m)←⍺ ⍵[(≢⍴)¨⍺ ⍵] ⋄ m+(⍴m)⍴v}   ⍝ v is the vector, m is the matrix</code></pre>
		It can be coded in a single expression as a *reduction*, but then the result must be **disclosed** using **pick** `⊃`, which we will cover later in the course. If you want to know why, look at the shape of the result with and without the pick `⊃`
		<pre><code class="language-APL">AddRows ← {⊃{⍵+(⍴⍵)⍴⍺}/⍺ ⍵[(≢⍴)¨⍺ ⍵]}</code></pre>
		In the next section, we will see a better way to write functions that work on arrays of differing rank.

1. Without executing them, determine the shape of the results of the following expressions:

	<pre><code class="language-APL">      1 3 5∘.!2 4 6 8
	      1 2 3 + 4 5 6
	      {(+⌿⍵)÷≢⍵}3 1 4 1 5
	      +⌿2 3⍴⍳6
	      ?⌿2 3⍴3/4 52
	      ⌈/(2 3⍴⍳6)∘.×¯1+?5 4⍴0</code></pre>

	??? Hint
		Of course, you can always check your answers using the shape function <code class='language-APL'>⍴</code>
	??? Example "Answers"
		<pre><code>  3 4 ≡ ⍴1 3 5∘.!2 4 6 8
		    3 = ⍴1 2 3 + 4 5 6
		    ⍬ ≡ ⍴{(+⌿⍵)÷≢⍵}3 1 4 1 5   ⍝ The empty numeric vector
		    3 = ⍴+⌿2 3⍴⍳6
		    3 = ⍴?⌿2 3⍴3/4 52
		2 3 5 ≡ ⍴⌈/(2 3⍴⍳6)∘.×¯1+?5 4⍴0</code></pre>