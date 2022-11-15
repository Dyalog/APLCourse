# Selecting from Arrays

In an array-oriented language, perhaps it's no surprise that there are umpteen ways to select values from arrays. There are also many ways to [modify or assign values](./finding-and-replacing-values.md) within arrays.

The exact terminology can vary between array languages, and even APLers use these words interchangeably sometimes. However, on this page we will say that:

- **Scalars** (0-cells) are the things returned by indexing expressions
- **Elements** (or **items**) are the arrays inside of scalars. For a simple scalar *this is the same thing*! [Remember enclosing and diclosing scalars before?](./multidimensional-and-nested-arrays.md#arrays-are-made-of-scalars).

These notes summarise the different constructs available. There is also a [Dyalog webinar dedicated to selecting from arrays](https://dyalog.tv/Webinar/?v=AgYDvSF2FfU).

## Square bracket indexing
This is the type of indexing we have been using so far. For vectors, it is very intuitive:

```APL
      'LE CHAT'[6 4 1 2 3 5 6]
THE CAT
```

For higher rank arrays, we can return rectangular sub-arrays by separating the indices into each axis by semicolons:

```APL
      (2 3 4⍴⎕A)[1 2;1 3;1 4]   ⍝ The corner elements of the cuboid
AD
IL
  
MP
UX
```

1. What happens if you omit an axis? For example, `array[3;4 5;;]`?
1. What happens if you use too many or too few semicolons?

## Squad (A.K.A. "Functional") indexing
Square-bracket indexing requires you to know the exact rank of the array and have the correct number of semicolons in your indexing expression. You might also notice that it is a special or [anomalous syntax](https://aplwiki.com/wiki/APL_syntax#Syntactic_elements).

There is also an **index** function `⍺⌷⍵` which has two distinctions:

- It is a function with the same syntax as other functions
- It applies to any rank array by automatically filling in less-major cells (those cells defined by trailing axes)

```APL
      (1 2)(2 3)⌷(2 3 4⍴⎕A)
```
```
EFGH
IJKL

QRST
UVWX
```
---
```APL
      (2 3 4⍴⎕A)[1 2;2 3;]
```
```
EFGH
IJKL

QRST
UVWX
```

## Take and drop
We can chop off the edges of an array using **take** `⍺↑⍵` and **drop** `⍺↓⍵`.
```APL 
      ¯1 3 2↑2 3 4⍴⎕A
```
```
MN
QR
UV
```
---
```APL
      1 0 ¯2↓2 3 4⍴⎕A 
```
```
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

## Simple indexing
The selection of rectangular sub-arrays as demonstrated above using square brackets `[]` and squad `⌷` is also known as **simple indexing**.

## Choose indexing
Simple indexing with square brackets uses scalars or vectors separated by semicolons. Index using square brackets and a nested array of numeric vectors and we can select any collection of scalars:

```APL
      (2 3 4⍴⎕A)[(1 1 1)(2 1 4)(1 3 4)]
```
```
APL
```

An interesting relationship appears between indices into an array and indices into its ravel when `⎕IO←0`:

```APL
      ⎕IO←0
      (2 3 4⍴⎕A)[↓[0]2 3 4⊤0 15 11]
```
```
APL
```
---
```APL
      ⎕A⌷⍨⊂2 3 4⊥↑[0](0 0 0)(1 0 3)(0 2 3)
```
```
APL
```

## Reach indexing
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

## Select / From
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

## Problem set 7

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

	1. Compute the names of the people who ate the most fruit on Tuesday and Sunday combined.
	1. Compute the name of the person who ate the most mangoes and bananas combined.
	1. What is the name of the person who ate the most fruit overall?

	???Example "Answer"
		There are many different ways to find these answers. The following are just one set of solutions.

		<ol type="a">
		<li>

		Anna and Charlie both ate 10 fruits total on Tuesday and Sunday combined. Ben only ate 8 fruits.

		```APL
		      d←days⍳2 3⍴'Tue' 'Sun'
		      total ← +/+/ate[;;days⍳d]
		      (total=⌈/total)⌿names
		```
		```
		Anna   
		Charlie
		```

		</li>
		<li>

		Charlie ate the most mangoes and bananas across the whole week.

		```APL
		      f←fruits⍳2 7⍴'MangoesBananas'
		      total ← +/+/ate[;fruits⍳f;]
		      (total=⌈/total)⌿names
		```
		```
		Charlie
		```

		</li>
		<li>

		Anna ate the most fruit overall.

		```APL
		      total ← +/+/ate
		      (total=⌈/total)⌿names
		```
		```
		Anna
		```

		Any of these totals could have been expressed as a single sum. Either by ravelling submatrices for each person:

		```APL
		total ← +/(,⍤2)ate
		```

		Or by merging the last two axes:

		```APL
		total ← +/,[2 3]ate
		```

		A discussion comparing these expressions will be added later.

		</li>
		</ol>

1. Write a function `FindWord` which accepts a character matrix left argument `⍺` and a character vector right argument `⍵` and returns a Boolean vector where a `1` indicates a row in `⍺` which matches the word `⍵`.
	```APL
	      fruits←↑'apples' 'mangoes' 'oranges' 'bananas'
	      fruits FindWord 'apples'
	1 0 0 0
	      fruits FindWord 'oranges'
	0 0 1 0
	```

	!!!Question "What is `↑`?"
		We created a nested vector of different length character vectors using [strand notation](#arrays-are-made-of-arrays). The mix function `↑⍵` is used to turn this from a nested vector of vectors into a flat matrix made of simple character scalars. In order to make the matrix rectangular, shorter vectors are padded with spaces.

		```APL
		      ' '=↑'apples' 'mangoes' 'oranges' 'bananas'
		0 0 0 0 0 0 1
		0 0 0 0 0 0 0
		0 0 0 0 0 0 0
		0 0 0 0 0 0 0
		```

	???Example "Answer"

		There are many ways to solve this problem. A comparison of different approaches is worthy of a fuller discussion, which will be added later. For now we will simply show a few alternatives:

		```APL
		FindWord ← {∧/∨/⍺∘.=⍵↑⍨2⌷⍴⍺}
		FindWord ← {∨/(⍵↑⍨⊢/⍴⍺)⍷⍺}
		FindWord ← {(⍵↑⍨⊢/⍴⍺)(≡⍤1)⍺}
		FindWord ← {⍺∧.=⍵↑⍨2⌷⍴⍺}
		```

1.  From the nested 3D array
	
	```APL
	nest←2 3 4⍴(⍳17),(⊂2 3⍴'ab'(2 3⍴'dyalog'),'defg'),6↑⎕A
	```
	
	use a single selection to obtain:

	1. The character scalar `'y'`
	1. The numeric scalar `6`

	???Example "Answers"
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

1. What type of indexing is used in the expression `grid[⍸grille=' ']` ?

	???Example "Answer"
		Because `grille` is a matrix, the equality with the space character is also a matrix. The **where** function `⍸⍵` returns a nested vector of indices, which when used with square brackets forms a **choose indexing** expression.

1. What indexing array can be used to select a simple scalar from itself?

	???Example "Answer"
		For choose indexing, an enclosed empty numeric vector:

		```APL
		      'a'[⊂⍬]
		```
		```
		a
		```

		For squad indexing, an empty numeric vector:

		```APL
		      ⍬⌷'a'
		```
		```
		a
		```

		For reach indexing, either:

		```APL
		      ⍬⊃'a'
		```
		```
		a
		```
		---
		```APL
		      (⊂⍬)⊃'a'
		```
		```
		a
		```

1. Define `n←5 5⍴⍳25` in your workspace.
	
	Using selections, find at least four different ways to set the bottom-right 3 by 3 submatrix in `n` to `0`.
	For example, `(2 2↓n)←0`.

	??? Hint
		See which primitives may be used in a <a href='http://help.dyalog.com/latest/#Language/Primitive%20Functions/Assignment%20Selective.htm?Highlight=selective%20assignment'>selective assignment</a>

	???Example "Answers"
		Compute the indices:
		
		```APL
		n[2+⍳3;2+⍳3]←0
		```

		Use negative take:

		```APL
		(¯3 ¯3↑n)←0
		```

		Use two compressions:

		```APL
		b←2 3/0 1
		(b/b⌿n)←0
		```

		Positive take after reversals:

		```APL
		(3 3↑⌽⊖n)←0
		```

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
