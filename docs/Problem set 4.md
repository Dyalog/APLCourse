# Problem Set 4: Array-Oriented Solutions with Matrices

1. Back to School
	1. Write a function to produce the multiplication table from `1` to `⍵`. 

		<pre><code class="language-APL">      MulTable 7</code></pre>
		<pre><code class="language-APL">1  2  3  4  5  6  7
		2  4  6  8 10 12 14
		3  6  9 12 15 18 21
		4  8 12 16 20 24 28
		5 10 15 20 25 30 35
		6 12 18 24 30 36 42
		7 14 21 28 35 42 49</code></pre>

	1. Write a function to produce the addition table from `0` to `⍵`.

		<pre><code class="language-APL">      AddTable 6</code></pre>
		<pre><code class="language-APL">0 1 2 3  4  5  6
		1 2 3 4  5  6  7
		2 3 4 5  6  7  8
		3 4 5 6  7  8  9
		4 5 6 7  8  9 10
		5 6 7 8  9 10 11
		6 7 8 9 10 11 12</code></pre>

	??? Example "Answers"
		<ol type="a">
			<li><pre><code class="language-APL">MulTable ← {(⍳⍵)∘.×⍳⍵}</code></pre>
			which can be simplified using the *selfie* operator `⍨`
			<pre><code class="language-APL">MulTable ← {∘.×⍨⍳⍵}</code></pre></li>
			<li><pre><code class="language-APL">AddTable ← {∘.+⍨¯1+⍳⍵}</code></pre></li>
		</ol>

1. Making the Grade

    |   |   |   |   |   |   |
    |---|---|---|---|---|---|
    |**Score Range**|`0-64`|`65-69`|`70-79`|`80-89`|`90-100`|
    |**Letter Grade**|F|D|C|B|A|

    Write a function that, given an array of integer test scores in the inclusive range 0 to 100, returns a list of letter grades according to the table above.

	<pre><code class="language-APL">      Grade 0 10 75 78 85</code></pre>
	<pre><code class="language-APL">FFCCB</code></pre>

	??? Example "Answer"
		<pre><code class="language-APL">Grade ← {'FDCBA'[+⌿0 65 70 80 90∘.≤⍵]}</code></pre>

1. Optimus Prime

	A prime number is divisible by only itself and `1`.

	Write a dfn which returns all of the prime numbers between `1` and `⍵`.

	<pre><code class="language-APL">      Primes 10</code></pre>
	<pre><code class="language-APL">2 3 5 7</code></pre>
	<hr>
	<pre><code class="language-APL">      Primes 30</code></pre>
	<pre><code class="language-APL">2 3 5 7 11 13 17 19 23 29</code></pre>

	??? Example "Answer"
		<pre><code class="language-APL">Primes ← {⍸2=+⌿0=∘.|⍨⍳⍵}</code></pre>
		
		An alternative coding uses the multiplication table:
		
		<pre><code class="language-APL">Primes ← {i~∘.×⍨i←1↓⍳⍵}</code></pre>
