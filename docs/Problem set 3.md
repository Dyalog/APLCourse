# Problem Set 3: Selecting from Lists

1. Simple Simon Says Select These Elements
	1. Write a function to get even numbers from a numeric list.

		          Even ⍳10
		    2 4 6 8 10
		          Even 1 17 19 22 32 15  
		    22 32

	1. Write a function to get numbers which are divisible by `5` from a numeric list. 

		          Div5 ⍳50
		    5 10 15 20 25 30 35 40 45 50
		          Div5 12 13 15 20 19 55 16
		    15 20 55    

	1. Write a function to get numbers which are divisible by `⍺` from a numeric list. 

		          3 Div ⍳30
		    3 6 9 12 15 18 21 24 27 30
		          7 Div 11 17 21 42 18 7 0 70
		    21 42 7 0 70          

??? Example "Answers"
	Here are just some example solutions.
	<ol type="a">
		<li><pre><code>Even←{⍵/⍨0=2|⍵}
	Even←{⍵[⍸0=2|⍵]}</code></pre></li>
		<li><pre><code>Div5←{⍵/⍨0=5|⍵}</code></pre></li>
		<li><pre><code>Div←{⍵/⍨0=⍺|⍵}</code></pre></li>
	</ol>

1. Without without  
	Write a dfn which doesn't use `⍺~⍵` to remove spaces from a text vector. 

	          NoSpace'here is some text'
	    hereissometext
	          NoSpace'there   are   more   spaces   here'
	    therearemorespaceshere

??? Example "Answer"
	<pre><code>NoSpace←{⍵/⍨⍵≠' '}</code></pre>

1. Where without Where  
    Write a dfn which doesn't use `⍸` to find the indices of `1`s in a boolean vector.

	          Where 0 1 0 1 0 0 1 
	    2 4 7

??? Example "Answer"
	<pre><code>Where←{⍵/⍳≢⍵}</code></pre>

1. sdrawkcab s'taht woN

    Write a dfn without using `⌽` which reverses its right argument. 

	          Reverse 'Some characters'
	    sretcarahc emoS
	          Reverse ⍳10
	    10 9 8 7 6 5 4 3 2 1

??? Example "Answer"
	<pre><code>Reverse←{⍵[1+(≢⍵)-⍳≢⍵]}</code></pre>
