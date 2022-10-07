# Selecting from Arrays
- take and drop
- nested arrays
- each
- arrays are made of scalars (enclose info)
- the rank operator
- cells and axes
- rank and depth

## Arrays are made of arrays
You might have already noticed some awkwardness when we tried to represent a list of names as a character matrix. The main problem being that names do not usually have uniform length!

This problem is known in the array language community as "dealing with ragged arrays". There are [many useful techniques](#aplcart-flat-partitioned) for dealing with non-rectangular data using rectangular arrays. However, it is usually just more convenient to have a real nested structure to deal with.

Enter: general nested arrays.

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

In general, arrays are made of arrays. More specifically, the individual elements of any array are scalars - but they may lie along zero or more [axes](./array-model.md#cells-and-axes).

How can we fit an arbitrary array as a single element in another array? We have to somehow package it up as one of these scalars.

The example above uses <dfn>stranding notation</dfn> to implicitly wrap each sub-array in a scalar. This is a convenient notation for writing vectors by writing arrays separated by spaces or parentheses. Above we wrote APL expressions which evaluate to arrays, but we could have written the names of some pre-defined arrays.

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

We can reshape the result of an expression, without naming it, by using the <dfn>enclose</dfn> functoin `⊂⍵`.

```APL
      3⍴⊂'Hello'
┌─────┬─────┬─────┐
│Hello│Hello│Hello│
└─────┴─────┴─────┘
```

## How can we determine the structure of arrays without guessing based on visual output?
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
      I←((⊃⊣)⌷⊢)_Rank_ 0 99
```

Select provides the best of both simple indexing and choose indexing, allowing you to select arbitrary collections of cells.

!!! Warning
	Select is a very general and convenient function, but it is potentially much slower than using the in-built indexing constructs. We provide it here for completeness and your interest.

## So which type of indexing do I use?
Over time you will learn from experience what is the most appropriate thing to use in different situations. However, here is a rough guide:

|Selection type|Selection construct|
|---|---|
|Arbitrary scalars from a vector|Square bracket simple or [compress](Selecting from lists/#replicatecompress)|
|Rectangular subarrays|Simple|
|Arbitrary scalars from an array of rank ≥2|Choose|
|Nested arrays|Reach|
|Arbitrary collections of cells|Select|

## Problem set

1. Write a function `FindWord` which accepts a character matrix left argument `⍺` and a character vector right argument `⍵` and returns a Boolean vector where a `1` indicates a row in `⍺` which matches the word `⍵`.
	```APL
	      fruits FindWord 'Apples'
	1 0 0 0
	      fruits FindWord 'Oranges'
	0 0 1 0
	```

`FindWord←{∧/∨/⍺∘.=⍵↑⍨(⍴⍺)[2]}`

`FindWords←{∧/⍺=(⍴⍺)⍴⍵↑⍨(⍴⍺)[2]}`

`FindWord←{⍺∧.=((⍴⍺)[2])↑⍵}`

### Search, sort, slice and select

1.  From the nested 3D array `Nest←2 3 4⍴(⍳17),(⊂2 3⍴'ab'(2 3⍴'dyalog'),'defg'),⎕A[⍳6]` , use a single selection to obtain:
	1. The character scalar `'y'`
	1. The numeric scalar `6`

- Backwards (reverse the vector and its elements)

- selective and indexed assignment

- Create a variable `nest` which has the following properties
	⍴nest
	2 3
	≡nest
	̄2
	⍴ ̈nest
	┌─┬┬─┐
	│ ││2│
	├─┼┼─┤
	│3││6│
	└─┴┴─┘
	]display ∊nest
	┌→───────────────────┐
	│I 3 am 1 5 8 amatrix│
	└+───────────────────┘
	⍴∊nest
	14

- Find all palindromes
- Count vowels in each word

- A reduction always results in rank 1 less (hence nested things return a nested scalar)
	- `∨/('some text'='a')('some text'='b')('some text'='c')`
	- `⊃{⍺,','⍵}/'join' 'these' 'words' 'with' 'commas'`

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