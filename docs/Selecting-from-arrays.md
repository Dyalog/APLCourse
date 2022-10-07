# Selecting from Arrays

## Arrays are made of arrays
You might have already noticed some awkwardness when we tried to represent a list of names as a character matrix. The main problem being that names do not usually have uniform length!

```APL
      student ← 10 7⍴'Kane   Jonah  JessicaPadma  Katie  CharlieAmil   David  Zara   Filipa '
	  ' '=student
```
```
0 0 0 0 1 1 1
0 0 0 0 0 1 1
0 0 0 0 0 0 0
0 0 0 0 0 1 1
0 0 0 0 0 1 1
0 0 0 0 0 0 0
0 0 0 0 1 1 1
0 0 0 0 0 1 1
0 0 0 0 1 1 1
0 0 0 0 0 0 1
```

Any code using this representation is going to have to be aware of the trailing space characters. This is an efficient representation of this data, and there are [some interesting techniques](#aplcart-flat-partitioned) for dealing with non-rectangular data using rectangular arrays. However, it is usually just more convenient to have a real nested structure to deal with.

```APL
      2 3⍴(1 2)(3 4 5)('AB')(2 2⍴'CDEF')
```
```
┌───┬─────┬─────┐
│1 2│3 4 5│AB   │
├───┼─────┼─────┤
│CD │1 2  │3 4 5│
│EF │     │     │
└───┴─────┴─────┘
```

!!!Question "How do I get those boxes around my output?"
	Turn boxing on with the user command
	```APL
		]Box on
	Was OFF
	```
	Boxing affects the display of output in the APL session, but does not affect the structure or values of arrays in any way.

In general, arrays are made of arrays. More specifically, the individual elements of any array are <dfn>scalar</dfn> - but they may lie along zero or more [axes](./array-model.md#cells-and-axes).

How can we fit an arbitrary array as a single element in another array? We have to somehow package it up as one of these scalars.

The example above uses a special notation to implicitly wrap each sub-array in a scalar. We have actually been using it this whole time. <dfn>Stranding notation</dfn> is a convenient notation for writing vectors by having arrays separated by spaces or parentheses. Above we wrote APL expressions which evaluate to arrays, but we could have written the names of some pre-defined arrays.

```APL
      a ← 1 2
      b ← 3 4 5
	  c ← 'AB'
	  d ← 2 2⍴'CDEF'
      2 3 ⍴ a b c d
┌───┬─────┬─────┐
│1 2│3 4 5│AB   │
├───┼─────┼─────┤
│CD │1 2  │3 4 5│
│EF │     │     │
└───┴─────┴─────┘
```

We can reshape the result of an expression, without naming it, by using the <dfn>enclose</dfn> function `⊂⍵`.

```APL
      3⍴⊂'Hello'
┌─────┬─────┬─────┐
│Hello│Hello│Hello│
└─────┴─────┴─────┘
```

## Arrays have rank and depth
Nested arrays have depth, which is different to rank in APL. Rank is the number of dimensions an array has (scalar 0, vector 1, matrix 2 etc.) whereas depth is how many arrays are inside our arrays.

The <dfn>depth</dfn> function `≡⍵` returns the depth of an array. The absolute value of depth `|≡⍵` is the level of nesting, starting at 0 for simple scalars.

```APL
      ≡'a'  ⍝ Simple scalar has depth 0
0
      ≡x    ⍝ Simple matrix has depth 1
1
      ≢⍴x   ⍝ Simple matrix has rank 2
2
      ≡⊂x   ⍝ Enclosing increases the depth
2
      ≡⊂⊂x
3
      ≡⊂⊂⊂x
4
```

Negative depth indicates uneven nesting:

```APL
      ≡(1 2)(3 4)         ⍝ Evenly nested arrays have positive depth
2
      ≡(1 2)(3 4 (4 5))   ⍝ Unevenly nested arrays have negative depth
¯3
```

If you have a complex structure like this, you can use the <dfn>each</dfn> operator `F¨⍵` to keep drilling down until you feel you have a better understanding.

```APL
      nv ← (1 2)(3 4 (4 5))
	  nv
┌───┬─────────┐
│1 2│┌─┬─┬───┐│
│   ││3│4│4 5││
│   │└─┴─┴───┘│
└───┴─────────┘

      ⍴nv     ⍝ 2-element vector
2
      ≡nv     ⍝ Unevenly nested
¯3

      ⍴¨nv    ⍝ 2 vectors of lengths 2 and 3
┌─┬─┐
│2│3│
└─┴─┘
      ≡¨nv    ⍝ 1st element is simple, 2nd is unevenly nested
1 ¯2

      ⍴¨¨nv   ⍝ 2nd element appears to be made of 2 scalars followed by a vector
┌───┬─────┐
│┌┬┐│┌┬┬─┐│
││││││││2││
│└┴┘│└┴┴─┘│
└───┴─────┘
      ≡¨¨nv   ⍝ 2nd element is 2 simple scalars and a non-nested array
┌───┬─────┐
│0 0│0 0 1│
└───┴─────┘
```

So we can tell we have a 2 element nested vector. The 1st element is a simple 2-element vector. The 2nd element contains 2 simple scalars and a simple vector of length 2.

## Arrays are made of scalars
Arrays in APL are always made of scalars (rank-0 arrays) as their elements.

So the vector `1 2 3` is made of three scalar numbers, and `2 3⍴⎕A` is made of 6 scalar characters arranged in 2 rows with 3 columns.

A simple scalar is a single character, a single number or a single [namespace reference](./Namespaces.md). Enclosing simple scalars is a no-op (it does not do anything):

```APL
      3 ≡ ⊂⊂⊂⊂⊂⊂3
1
```

But enclosing an array allows us to include it as part of another array:

```APL
      x ← 2 3⍴⎕A   ⍝ x is a simple matrix
      3⍴x          ⍝ Reshape uses the elements within
ABC
      3⍴⊂x         ⍝ Enclosing turns the whole array into an element
┌───┬───┬───┐
│ABC│ABC│ABC│
│DEF│DEF│DEF│
└───┴───┴───┘
```

## The shape of a scalar
What is the shape of `46.2`? Here are some common incorrect answers.

`4`?

No, the shape of the character vector `'46.2'` is four, but that is not the same as the scalar number `46.2` - see [problem 2 from the previous section](./array-logic-data-driven-conditionals.md#problem-set).

`1`?

Not quite. The tally `≢⍵` gives `1`, but the shape function `⍴⍵` only returns `1` for a 1-element vector. `46.2` is not a vector, it is a scalar.

`0`?

This would be the shape of a 0-element vector.

To get to the answer, it helps to think about the rank as well. The rank is simply the number of dimensions.

```APL
      ⍴⍴¯1 0 1∘.×⍳5     ⍝ A matrix has two dimensions
```
```
2
```
---
```APL
      ⍴⍴'ABCDE'         ⍝ A vector has just one dimension
```
```
1
```
---
```APL
      ⍴⍴'A'             ⍝ How many dimensions does a scalar have? 
```
```
0
```

If the result of `⍴'A'` is an array with shape `0` - that means that the shape of a scalar is an empty vector. To be specific, it is an <dfn>empty numeric vector</dfn>. This empty numeric vector can also be represented by the symbol <dfn>zilde</dfn> (`⍬`), which is a zero (`0`) combined with a tilde (`~`). When executed, it displays as a blank line.

```APL
      ⍬

```

!!!Note "The tally is a scalar whereas the shape is a vector"
	You might have noticed that the tally `≢⍵` always returns one number, whereas the shape `⍴⍵` may return several. The tally of an array is a *scalar* representing the length of the first (leading) axis. For a matrix, this is the number of rows.

	The shape returns a vector which describes the length of each axis. Whether there are five axes or no axes, the result of `⍴⍵` is always a vector.

## Selecting from arrays
In an array-oriented language, perhaps it's no surprise that there are umpteen ways to select values from arrays. There are also many ways to [modify or assign values](../Assignment) within arrays.

The exact terminology can vary between array languages, but here we will refer to two types of fundamental array pieces:

- **Scalars** (0-cells) are the things returned by indexing expressions
- **Elements** (or **items**) are the arrays inside of scalars. For a simple scalar *this is the same thing*! [Remember enclosing and diclosing scalars before?](../Array model/#nested-arrays).

These notes summarise the different constructs available. There is also a [Dyalog webinar dedicated to selecting from arrays](https://dyalog.tv/Webinar/?v=AgYDvSF2FfU).

### Square bracket indexing
This is the type of indexing we have used exclusively up to now. For vectors, it is very intuitive:
```APL
      'LE CHAT'[6 4 1 2 3 5 6]
THE CAT
```

For higher rank arrays, we can return rectangular sub-arrays by separating the indices into each axis by a semicolon:
```APL
      (2 3 4⍴⎕A)[1 2;1 3;1 4]   ⍝ The corner elements of the cuboid
AD
IL
  
MP
UX
```

1. What happens if you omit an axis? For example, `array[3;4 5;;]`?
1. What happens if you use too many or too few semicolons?

### Squad (A.K.A. "Functional") indexing
Square-bracket indexing requires you to know the exact rank of the array and have the correct number of semicolons in your indexing expression. You might also notice that it is a special or [anomalous syntax](https://aplwiki.com/wiki/APL_syntax#Syntactic_elements).

There is also an **index** function `⍺⌷⍵` which has two distinctions:

- It is a function with the same syntax as other functions
- It applies to any rank array by automatically filling in less-major cells (those cells defined by trailing axes)

```APL
      (1 2)(2 3)⌷(2 3 4⍴⎕A)
      (2 3 4⍴⎕A)[1 2;2 3;]
```

### Take and drop
We can chop off the edges of an array using **take** `⍺↑⍵` and **drop** `⍺↓⍵`.
```APL 
      ¯1 3 2↑2 3 4⍴⎕A 
MN
QR
UV
      1 0 ¯2↓2 3 4⍴⎕A 
MN
QR
UV
```

!!! Note
	While similar subarrays can be retrieved using indexing, take or drop, note that *take* and *drop* **return** arrays of **the same rank** as their argument.
	<pre><code class="language-APL">      ≢⍴1 1↑2 3 4⍴⎕A 
	3
	      ≢⍴1 1⌷2 3 4⍴⎕A 
	1</code></pre>

### Simple indexing
The selection of rectangular sub-arrays as demonstrated above using square brackets `[]` and squad `⌷` is also known as **simple indexing**.

### Choose indexing
Square brackets have a magic trick up their sleeve. Simple indexing with square brackets uses scalars or vectors separated by semicolons. If you index using square brackets and a nested vector of numeric vectors, you can select any collection of scalars.

```APL
      (2 3 4⍴⎕A)[(1 1 1)(2 1 4)(1 3 4)]
```

An interesting relationship appears between indices into an array and indices into its ravel when `⎕IO←0`:

```APL
      ⎕IO←0
      (2 3 4⍴⎕A)[↓[0]2 3 4⊤0 15 11]
      ⎕A⌷⍨⊂2 3 4⊥↑[0](0 0 0)(1 0 3)(0 2 3)
```

### Reach indexing
Indexing into an array will retrieve some cell of an array. If it is a nested array, then selecting a scalar will return an enclosed array. Sometimes what you actually want is the item inside of that scalar.

While it is common and perfectly valid to simply use *first* `⊃⍵` to disclose the contents of a scalar, the *pick* function `⍺⊃⍵` can be used to retrieve the element directly:
```APL
      3⌷'here' 'are' 'some' 'words'   ⍝ With ]Boxing on
┌─────┐
│words│
└─────┘
      3⊃'here' 'are' 'some' 'words'
words
```

Reach indexing allows you to pull items from deep within a nested array:
```APL
      (2 1)(2 2) ⊃ 2 3⍴0 1 2 (2 3⍴'AB' 'CD' 'EF' 'GH' 'IJ' 'KL') 4 5
IJ
```

### Select / From
Some APLers find squad-index semantics awkward, and have proposed yet another mechanism, called **select** or [**from**](https://aplwiki.com/wiki/From). It can be defined as:
```APL
      I←(⊃⍤⊣⌷⊢)⍤0 99
```

Select provides the best of both simple indexing and choose indexing, allowing you to select arbitrary collections of cells.

!!! Warning
	Select is a very general and convenient function, but it is potentially much slower than using the in-built indexing constructs. We provide it here for completeness and your interest.

## So which type of indexing do I use?
Over time you will learn from experience what is the most appropriate thing to use in different situations. However, here is a rough guide:

|Selection type|Selection construct|
|---|---|
|Arbitrary scalars from a vector|Square bracket simple or [compress](./array-logic-data-driven-conditionals.md#replicatecompress)|
|Rectangular subarrays|Simple|
|Arbitrary scalars from an array of rank ≥2|Choose|
|Nested arrays|Reach|
|Arbitrary collections of cells|Select|

## Problem set

### Search, sort, slice and select
1. Anna, Ben and Charlie are having a competition. They want to see who can eat the most fruit in a week.

	```APL
	fruits ← 4 7⍴'Apples MangoesOrangesBananas'
	days ← 7 3⍴'SunMonTueWedThuFriSat'
	names ← 3 7⍴'Anna   Ben    Charlie'
	⎕RL ← 42 1 ⋄ ate ← ?3 4 7⍴3
	```

	???+Question "What is `⎕RL`?"
		The <dfn>roll</dfn> function `?⍵` generates random numbers for each simple scalar number in `⍵`.

		Setting the <dfn>Random Link</dfn> [system variable](./Quad%20names.md#system-variables) `⎕RL` lets us generate the same random numbers repeatedly.

	1. Compute the names of the people who ate the most fruits 
	1. Compute the name of the person who ate the most apples and oranges combined.
	1. What is the name of the person who ate the most fruit overall?


	`names[{⍵⍳⌈/⍵}+/+/ate[;fruits⍳2 7⍴'Apples Oranges';];]`

	```APL
	      f←fruits⍳2 7⍴'Apples Oranges'
	      t←+/+/ate[;f;]
	      n←t=⌈/t
	      n⌿names
	Anna
	```

1. Write a function `FindWord` which accepts a character matrix left argument `⍺` and a character vector right argument `⍵` and returns a Boolean vector where a `1` indicates a row in `⍺` which matches the word `⍵`.
	```APL
	      fruits←↑'apples' 'mangoes' 'oranges' 'bananas'
	      fruits FindWord 'apples'
	1 0 0 0
	      fruits FindWord 'oranges'
	0 0 1 0
	```

	???+Question "What is `↑`?"
		We created a nested vector of different length character vectors using [strand notation](#arrays-are-made-of-arrays). The mix function `↑⍵` is used to turn this from a nested vector of vectors into a flat matrix made of simple character scalars. In order to make the matrix rectangular, shorter vectors are padded with spaces.

		```APL
		      ' '=↑'apples' 'mangoes' 'oranges' 'bananas'
		0 0 0 0 0 0 1
		0 0 0 0 0 0 0
		0 0 0 0 0 0 0
		0 0 0 0 0 0 0
		```

	???+Example "Answer"
		An outer product or reshape can be used for the comparison, but we need to make sure our character vector has the right shape.
		```APL
		FindWord ← {∧/∨/⍺∘.=⍵↑⍨2⌷⍴⍺}
		```

		This outer product generates a 3-dimensional array. It is more efficient to reshape the vector to match the matrix:

		```APL
		FindWord ← {∧/⍺=(⍴⍺)⍴⍵↑⍨2⌷⍴⍺}
		```
		
		This idea of using a function between one row and several can be expressed using a concept we have not yet formally introduced: [the rank operator](./array-model.md#matching-dimensions).

		```APL
		FindWord ← {∧/⍺(=⍤1)⍵↑⍨(⍴⍺)[2]}
		```

		The comparison followed by a reduction is also expressed neatly using [the inner product operator](./Operators.md#the-inner-product).

		```APL
		FindWord ← {⍺∧.=⍵↑⍨2⌷⍴⍺}
		```

1.  From the nested 3D array
	
	```APL
	nest←2 3 4⍴(⍳17),(⊂2 3⍴'ab'(2 3⍴'dyalog'),'defg'),6↑⎕A
	```
	
	use a single selection to obtain:

	1. The character scalar `'y'`
	1. The numeric scalar `6`

	???+Example "Answers"
		It can be tricky to simplify these to a single use of pick `⍺⊃⍵`. Although understanding these selections can help with understanding complicated nested array structures, it is not very common to need to do this in real code.
		<ol type="a">
		<li>
		```APL
		      (2 2 2)(1 2)(1 2)⊃nest
		y
		```
		</li>
		<li>
		```APL
		      (⊂1 2 2)⊃nest
		6
		```
		</li>
		</ol>

1. Write the function `Backwards` which accepts a nested vector of character vectors as its argument and reverses both the order of elements and the contents of each vector within.
	```APL
	      Backwards 'reverse' 'these' 'words'
	┌─────┬─────┬───────┐
	│sdrow│eseht│esrever│
	└─────┴─────┴───────┘
	```

	???+Example "Answer"
		You can write the reverse and reverse-each in either order.
		```APL
		Backwards ← {⌽¨⌽⍵}
		Backwards ← {⌽⌽¨⍵}
		```

1. Write a dyadic `Join` function which takes a nested vector of character vectors `⍵` and returns a simple character vector consisting of the contents of each nested vector joined by a delimiting character `⍺`.

	```APL
	      Join 'join' 'these' 'words'
	join,these,words
	      Join 'and' 'also' 'these' 'words'
	and,also,these,words
	```

- A reduction always results in rank 1 less (hence nested things return a nested scalar)
	- `∨/('some text'='a')('some text'='b')('some text'='c')`
	- `⊃{⍺,','⍵}/'join' 'these' 'words' 'with' 'commas'`

1. Without using the shape function `⍴⍵`, what are the shapes of the results of the following expressions?
	1. `'APL IS COOL'`
	1. `¯1 0 1 ∘.× 1 2 3 4 5` 
	1. `1 2 3 4∘.+¯1 0 1∘.×1 10`
	1. `+/⍳4`

	???+Example "Answers"
		<ol>
		<li><ol>
		<li>This is a simple character vector with $11$ characters, including space characters, so its shape is `11`.
		```APL
		      ⍴'APL IS COOL'
		11
		```
		</li>	
		<li>This is a matrix. The result of multiplying all combinations of elements from a 3-element vector and a 5-element vector is a 3 by 5 matrix. It has 3 rows and 5 columns, so its shape is `3 5`.
		```APL
		      ¯1 0 1 ∘.× 1 2 3 4 5
		```
		```
		¯1 ¯2 ¯3 ¯4 ¯5
		0  0  0  0  0
		1  2  3  4  5
		```
		---
		```APL
		      ⍴¯1 0 1 ∘.× 1 2 3 4 5
		```
		```
		3 5
		```
		If you swap the arguments around, you get a $5$ by $3$ matrix.</li>
		```APL
		      1 2 3 4 5 ∘.× ¯1 0 1
		¯1 0 1
		¯2 0 2
		¯3 0 3
		¯4 0 4
		¯5 0 5
		```
		<li>This is a scalar. The reduce operator `F/` has the effect of *reducing* the rank of its argument array by 1.

		The shape of a scalar </li>
		</ol></li>
		</ol>

### Visit to the museum
Here are some data and questions about visits to a museum.  

The `section_names` are the names of each of the four sections in the museum.  

<pre><code class="language-APL">section_names ← 'Bugs' 'Art' 'Fossils' 'Sea Life'</code></pre>  

The variable `sections` is a nested list of text matrices. Each matrix lists the items or creatures which belong to each section.  

<pre><code class="language-APL">sections ← ↑¨('Grasshopper' 'Giant Cicada' 'Earth-boring Dung Beetle' 'Scarab Beetle' 'Miyama Stag' 'Giant Stag' 'Brown Cicada' 'Giraffe Stag' 'Horned Dynastid' 'Walking Stick' 'Walking Leaf') ('The Blue Boy by Thomas Gainsborough' ('Rooster and Hen with Hydrangeas by It',(⎕ucs 333),' Jakuch',(⎕ucs 363)) 'The Great Wave off Kanagawa by Hokusai' 'Mona Lisa by Leonardo da Vinci' 'Sunflowers by Vincent van Gogh' 'Still Life with Apples and Oranges by Paul Cézanne' 'Girl with a Pearl Earring by Johannes Vermeer' ('Shak',(⎕ucs 333),'ki dog',(⎕ucs 363),' by Unknown') 'David by Michelangelo di Lodovico Buonarroti Simoni' 'Rosetta Stone by Unknown') ('Amber' 'Ammonite' 'Diplodocus' 'Stegosaur' 'Tyrannosaurus Rex' 'Triceratops') ('Puffer Fish' 'Blue Marlin' 'Ocean Sunfish' 'Acorn Barnacle' 'Mantis Shrimp' 'Octopus' 'Pearl Oyster' 'Scallop' 'Sea Anemone' 'Sea Slug' 'Sea Star' 'Whelk' 'Horseshoe Crab')</code></pre>

The `visits` table represents 1000 visits to museum sections over a two week period. The four columns represent:  

- The section that was visited as an index into the `section_names`
- The day of the visit in [Dyalog Date Number](http://help.dyalog.com/latest/#Language/System%20Functions/dt.htm) format.
- The arrival time in minutes from midnight. For example, 15:30 is 930 minutes.
- The departure time in minutes from midnight.

<pre><code class="language-APL">⎕RL←42 ⋄ days←43589+?1000⍴28 ⋄ (arr lïv)←539+?2⍴⊂1000⍴510 ⋄ section←?1000⍴4
visits←(⊂⍋days)⌷section,days,(⊂∘⍋⌷⊢)⍤1⍉↑arr lïv</code></pre>

In the boolean matrix `display`, each row corresponds to a museum piece and each column corresponds to a day. A `1` indicates days when a particular museum piece was out on display. The order of rows corresponds to the order of pieces in the `sections` table.  

<pre><code>display ← 40 28⍴(9/0),1,(4/0),1,(9/0),1,(3/0),(5/1),0,(10/1),0,(5/1),0,(8/1),0,(8/1),0,(4/1),0 0 1 1 0 1 0 1 0 1 1 0 1 0,(5/1),(3/0),1 0 1 0 1 1,(4/0),1 0 1 1 0 0 1 1 0,(6/1),0 1 0 1 0 0 1 1 0 0 1 1 0 1 0 0 1 1 0,(3/1),(3/0),(4/1),0 1 1 0 1 0 0,(7/1),0 1 0 1 1 0 1 1 0 1 1 0,(3/1),0 1 1 0,(4/1),0,(3/1),0 1 0,(3/1),0 0 1 1,(5/0),1 1 0,(3/1),0 1 0 0 1 1,(3/0),(5/1),0,(9/1),0,(3/1),0 1,(3/0),(5/1),0,(3/1),0,(3/1),(3/0),1 1 0 0 1 0 1,(4/0),1 1 0 1 0 1 0 1 0,(9/1),0,(7/1),0,(3/1),0 0 1 1 0 1 1 0 0 1 0 0 1 0,(5/1),0 1,(3/0),1 1 0 1 0 0,(3/1),0,(4/1),0 0 1 1,(7/0),(3/1),(3/0),1 1,(3/0),1 1 0 1 0 1,(6/0),1 1,(4/0),1 0 1 1,(5/0),1 0 1 0 1,(6/0),(3/1),(9/0),1 1,(3/0),1 0 1 0 1 1,(13/0),1 1,(11/0),1 0 1 1,(4/0),1 0 0,(4/1),0,(12/1),0,(5/1),0 1 0 0 1 1 0,(5/1),0,(4/1),0,(4/1),0 0 1,(5/0),1 1,(3/0),(8/1),0 0 1,(3/0),1,(3/0),1,(3/0),1 0 0 1 0 1 0 1 0 1 0 1 1 0,(3/1),(4/0),(3/1),0,(3/1),0 1 1,(3/0),(4/1),0 1 1 0 1 1,(3/0),1 1 0 1 0 1 0 1,(6/0),1 1,(14/0),(8/1),(4/0),(8/1),0,(3/1),0,(4/1),(6/0),1 0 0 1 1,(3/0),1 1 0 0 1 0 1 0 0 1 0 1,(5/0),1 0 0 1 0 1 0 0 1 1,(3/0),1,(8/0),1 0 1 0,(6/1),0 0,(7/1),0 1 1 0,(3/1),0,(9/1),0,(12/1),0 1 1 0,(9/1),0,(3/1),0 0,(3/1),(3/0),(3/1),0,(3/1),(5/0),(7/1),0 1 0,(5/1),0,(3/1),0 0,(3/1),0 0 1 1 0,(4/1),0 1,(3/0),(3/1),(5/0),1 0 1 1 0 1 0,(3/1),0,(5/1),0,(3/1),0,(4/1),0 1,(4/0),1 0 1 0 0 1 1,(5/0),1,(3/0),1 0 0 1 0 1,(3/0),1 0 1 0 0 1,(4/0),1 0 0 1,(6/0),1,(14/0),1 0 0,(4/1),(3/0),(6/1),0 0 1 0,(3/1),0,(4/1),0,(3/1),0 1 0 1,(3/0),(5/1),(3/0),1 0 0 1 0,(3/1),0 1,(4/0),1 0 1 1,(11/0),1,(15/0),(3/1),(4/0),1,(15/0),(5/1),0 1 0,(8/1),0,(3/1),(4/0),(5/1),0 1,(9/0),1 0 1 1 0 0 1 0 0 1,(4/0),1 0,(4/1),0,(7/1),(3/0),1 0 0 1,(3/0),(3/1),0 1 1
</code></pre>

1. How many visitors arrived before 10AM?
1. What was the most popular section by visit duration?
1. Estimate the opening and closing times of each of the sections.
1. Which animal being on display corresponded with the highest increase in visit duration for its section?

### Word Problems

We are going to do some text processing on a dictionary of words. 

If you have access to the internet, the following expressions will download a text file dictionary (917kB in size) and store it as a nested vector of character vectors named `words`.

```APL
      ]Load HttpCommand
      words ← (⎕UCS 10) {(⍺≠⍵)⊆⍵} (HttpCommand.Get'https://tinyurl.com/y7asendy').Data
```

If you have the file on your computer (maybe you were given it on a USB drive, for example) then you can load it into your workspace from disk using the following expressions.

```APL
      (content encoding newline) ← ⎕NGET'/path/to/words.txt'
      words ← (⎕UCS newline) (≠⊆⊢) content
```

Now answer the following questions about `words`.

1. How many words have at least 3 `'e'`s in them?

1. How many words have exactly two consecutive `'e'`s in them? 
    The first three such words are `Aberdeen` `Abderdeen's` and `Aileen`.

1. What is the shortest word with two consecutive `'a'`s?

1. What words have three consecutive double letters? For example, `mississippi` does not but `misseetto` does. Misseetto is not a real word.

	A palindrome is the same when reversed. For example, **racecar** is a palindrome but **racecat** is not.

1. How many palindromes are there in `words`?

1. Which palindrome in `words` is the longest?

1. How many words are in alphabetical order?

### Rain facts
The 3D array `rain` gives the monthly rainfall in millimeters over 7 years in 5 countries.

```APL
      ⎕RL←42 ⋄ rain←?7 5 12⍴250
```

1. Which month in each year in each country had the highest rainfall?
1. In the data, the countries are in order 1 to 5. Sort the countries in descending order of average monthly rainfall
1. Sort the countries in ascending order of total yearly rainfall

1. Making scalars

	1. Turn the 1-element vector `v` into a scalar.
	1. Write an expression using `⍴` which returns an empty numeric vector.
	1. Write an expression using `⍳` which returns an empty numeric vector.

	???+Example "Answer"
		<ol type="a">
		<li>
		The shape of a scalar is an empty numeric vector. We can therefore use the empty numeric vector as the left argument to the reshape function:
		```APL
		⍬⍴v
		```
		</li>
		<li>
		The shape of any scalar is an empty numeric vector.
		```APL
		      ⍴0
		
		      ⍴35
		
		      ⍴'Q'
		
		```
		</li>
		<li>
		If we can generate a length `n` vector with `⍳n`, what happens when `n=0`?

		```APL
		      ⍳0
		
		```
		</li>
		</ol>