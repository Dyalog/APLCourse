# Shape Reshape

1. Expermient with the expressions in the following block to gain an understanding of the functions used. 
1. Write a brief definition in English for each expression.  
	For example: `{2×⍳⍵}   ⍝ Even integers from 2 to 2×⍵ inclusive`. 
1. Use the language bar to discover the names of unfamiliar functions.

```APL
      3 4⍴⍳12   ⍝ A 3 row, 4 column matrix of the integers from 1 to 12 inclusive      
      ⍴cards←'A23456789TJQK'∘.,'♠♥♦♣'
      ⍉cards
      (,cards)[?52]
      alph←2 3 4⍴⎕A
      ,alph      
```

## The shape of a scalar

Use the match function `≡` to determine which expressions below produce the empty character vector `''` ("*quote-quote*") and which produce the empty numeric vector `⍬` ("*zilde*").

<pre><code class="language-APL">      0⍴0</code></pre>
<pre><code class="language-APL">      0↑⎕A</code></pre>
<pre><code class="language-APL">      ⍳0</code></pre>
<pre><code class="language-APL">      0⍴''</code></pre>
<pre><code class="language-APL">      0⍴'def'</code></pre>
<pre><code class="language-APL">      0 0⍴'abc'</code></pre>
<pre><code class="language-APL">      2 0 3⍴⍳6</code></pre>
<pre><code class="language-APL">      rain[⍸rain>250]</code></pre>
<pre><code class="language-APL">      alph[⍸alph='Z']</code></pre>
<pre><code class="language-APL">      ⌈⌿⍬⍬</code></pre>
<pre><code class="language-APL">      ⎕JSON'{}'</code></pre>
<pre><code class="language-APL">      ⎕JSON'[]'</code></pre>
<pre><code class="language-APL">      ⎕JSON'""'</code></pre>

A *simple array* contains only single numbers and/or characters as elements. Single numbers or characters are called *scalars*. Arrays generally can contain any other array. These are called *nested arrays*. For example `cards` is a nested matrix of character vectors.

```APL
      ⍴¨1 2 3 4   ⍝ What is the shape of each number in ⍳4?
      ⍴¨'ABCDE'   ⍝ What is the shape of each letter in 5↑⎕A?
      ⍴¨cards     ⍝ What is the shape of each array in cards?
```