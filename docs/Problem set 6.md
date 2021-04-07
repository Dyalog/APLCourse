# Problem set 6: Fundamentals of high rank arrays

1. Summary Statistics

	The 3D array `rain` gives the monthly rainfall in millimeters over 7 years in 5 countries.  
	<pre><code class="language-APL">      rain←?7 5 12⍴250</code></pre>
	
	Below each expression below, write a brief statement of what it does. If necessary, consult the hint which follows the group of expressions. 

	<pre><code class="language-APL">      (+⌿⍤1)rain   ⍝ Total rainfall for each of 7 years in 5 countries
	      +⌿rain
	      (+⌿⍤2)rain
	      (+⌿⍤3)rain
	      ⌈⌿rain
	      (⌈⌿⍤2)rain
	      rain[⍸rain>250]</code></pre>

	??? Hint
		Look at the shapes of the arguments and the results, <code class='language-apl'>⍴rain</code> and <code class='language-apl'>⍴+⌿rain</code> etc.

	1. Write an expression to find the average monthly rainfall for each of the 7 years in each of the 5 countries.

	1. Write an expression to find the average annual rainfall over the 7 years for each of the 5 countries.

	1. Assign scalar numeric values (single numbers) to the variables `years` `countries` `months` such that the `rain` data can be summarised as follows:
		<pre><code class="language-APL">      ⍴(+⌿⍤years)rain       ⍝ Sum over years</code></pre>
		<pre><code>5 12</code></pre>
		<hr>
		<pre><code class="language-APL">      ⍴(+⌿⍤countries)rain   ⍝ Sum over countries</code></pre>
		<pre><code>7 12</code></pre>
		<hr>
		<pre><code class="language-APL">      ⍴(+⌿⍤months)rain      ⍝ Sum over months</code></pre>
		<pre><code>7 5</code></pre>
		<hr>

1. Common Names for Arrays of Rank-n

	1. Match the following rank operands with their descriptions. Each use of rank (**a** to **e**) pairs with two of the 10 description boxes below.

		<pre><code class="language-APL">   a    b    c    d     e
		┌────┬────┬───┬─────┬──────┐
		│⍤1 3│⍤2 1│⍤¯1│⍤0 99│⍤99 ¯1│
		└────┴────┴───┴─────┴──────┘
		`-----------------------------------------`
		┌─┐ ┌────────────────┐ ┌────────────┐
		│⍵│ │major cells of ⍺│ │vectors of ⍺│
		└─┘ └────────────────┘ └────────────┘
		┌────────────────┐ ┌─┐ ┌──────────────┐
		│major cells of ⍵│ │⍺│ │3D arrays of ⍵│
		└────────────────┘ └─┘ └──────────────┘
		┌────────────────┐ ┌────────────┐
		│major cells of ⍵│ │scalars of ⍺│
		└────────────────┘ └────────────┘
		┌────────────────┐ ┌────────────────┐
		│matrices of ⍺   │ │vectors of ⍵    │
		└────────────────┘ └────────────────┘</code></pre>

	1. For each name below, suggest the rank for arrays with that name.

		<pre><code class="language-APL">┌────────┬────────────────────┐
		│Scalar  │                    │
		├────────┼────────────────────┤
		│Vector  │rank-1 array        │
		├────────┼────────────────────┤
		│Matrix  │                    │
		├────────┼────────────────────┤
		│Table   │                    │
		├────────┼────────────────────┤
		│List    │                    │
		├────────┼────────────────────┤
		│Cube    │                    │
		├────────┼────────────────────┤
		│4D array│                    │
		├────────┼────────────────────┤
		│2D array│                    │
		└────────┴────────────────────┘</code></pre>

1. Some Points in Space Revisited

	These problems are identical to those about Some Points in Space in [problem set 5](./Problem set 5.md). This time, create a function which works on vectors and use the rank operator to solve these problems.

	The positions of 7 points in 2D space are given by the matrix `pos2←7 2⍴0 1 3 4 2 7 3`.

	<pre><code class="language-APL">      pos2←7 2⍴0 1 3 4 2 7 3</code></pre>

	1. Write a function `NormVec` to normalise a vector so that its sum of squares is `1`.

		<pre><code class="language-APL">      +/pos2\*2</code></pre>
		<pre><code>1 25 53 9 10 20 58</code></pre>
		<hr>
		<pre><code class="language-APL">      +/((NormVec⍤1)pos2)\*2</code></pre>
		<pre><code>1 1 1 1 1 1 1</code></pre>
		<hr>
		<pre><code class="language-APL">      ÷/2-/pos2</code></pre>
		<pre><code>¯1 ¯1 ¯5 3 ¯2 2 4</code></pre>
		<hr>
		<pre><code class="language-APL">      ÷/2-/(NormVec⍤1)pos   ⍝ Relative proportions stay the same</code></pre>
		<pre><code>¯1 ¯1 ¯5 3 ¯2 2 4</code></pre>
		<hr>

1. Find the values of `j` and `k` in each of the two expressions below.
	1.  
	
		<pre><code class="language-APL">      0 10(×⍤j k)pos2</code></pre>
		<pre><code>0 10
		0 40
		0 70
		0  0
		0 30
		0 20
		0 30</code></pre>

	1.  
	
		<pre><code class="language-APL">      (2×⍳7)(+⍤j k)pos2</code></pre>
		<pre><code> 2  3
		 7  8
		 8 13
		11  8
		11 13
		16 14
		21 17</code></pre>

1. Rank Matching  
	Write a function `R1` which uses catenate `,` with the rank operator `⍤` to merge a vector and matrix into a single 3D array.

	<pre><code class="language-APL">      'ABC' R1 2 3⍴⍳6</code></pre>
		<pre><code>1 A
	2 B
	3 C
	&nbsp;
	4 A
	5 B
	6 C</code></pre>

	??? Hint
		You can apply rank multiple times e.g. `f⍤j⍤k`.

## Reduce on an empty vector?
For your interest, here are some reductions of note. Try to ask yourself why they give the results they do. Could they have been given different definitions?

```APL
      +/⍬
      ×/⍬
      ⌊/⍬
      ,/'APPLE' 'DOG' 'BISCUIT'
```