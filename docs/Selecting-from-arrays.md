# Selecting from Arrays

In an array-oriented language, perhaps it's no surprise that there are umpteen ways to select values from arrays. There are also many ways to [modify or assign values](#TODO) within arrays.

The exact terminology can vary between array languages, but here we will refer to two types of fundamental array pieces:

- **Scalars** (0-cells) are the things returned by indexing expressions
- **Elements** (or **items**) are the arrays inside of scalars. For a simple scalar *this is the same thing*! [Remember enclosing and diclosing scalars before?](#TODO).

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
      ⎕A⌷⍨⊂2 3 4⊥↑[0](0 0 0)(1 0 3)(0 2 3)
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
		
		We can compare one row with several using [the rank operator](./cells-and-axes.md#the-rank-operator).

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

1. What type of indexing is used in the expression `grid[⍸grille=' ']` ?

1. What indexing array can be used to select a simple scalar from itself?

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
		The shape of a scalar is an empty numeric vector. We can therefore use an empty numeric vector as the left argument to the reshape function:
		```APL
		⍬⍴v
		```
		</li>
		<li>
		The shape of any scalar is an empty numeric vector.
		```APL
		      ⍴0
		```
		```
		 
		```
		---
		```APL
		      ⍴35
		```
		```
		 
		```
		---
		```APL
		      ⍴'Q'
		```
		```
		 
		```
		---
		```APL
		      ⍬≡⍴42
		```
		```
		1
		```
		</li>
		<li>
		If we can generate a length `n` vector with `⍳n`, what happens when `n=0`?

		```APL
		      ⍳0
		```
		```
		 
		```
		</li>
		</ol>
