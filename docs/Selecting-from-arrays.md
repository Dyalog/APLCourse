# Search, Sort and Select

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
|Arbitrary scalars from a vector|Square bracket simple or [compress](Selecting from lists/#replicatecompress)|
|Rectangular subarrays|Simple|
|Arbitrary scalars from an array of rank ≥2|Choose|
|Nested arrays|Reach|
|Arbitrary collections of cells|Select|

## Searching and finding
**Membership** `⍺∊⍵` will return a boolean array indicating the elements in `⍺` which are present in `⍵`.

**Find** `⍺⍷⍵` will give a `1` indicating the location of the first element of `⍺` when the entire array `⍺` is found as a subarray in `⍵`.

**Index of** `⍺⍳⍵` will return the index in `⍵` where `⍺` is found as a major cell.

```APL
      text ← 2 3 4⍴'SOME APPLES'
      text∊'LESS'
      'LESS'⍷text
      (1⌷text)⍳'LESS'
```

## Total Array Ordering
To sort, index by the **grade**:

```APL
      Sort←{(⊂⍋⍵)⌷⍵}
      Sort 'the alphabet'
```

Grouping is an incredibly common operation when handling data. The python "dataframe" framework Pandas [has a groupby function](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.groupby.html) and anybody who has used SQL [is likely to be familiar with this idea](https://www.w3schools.com/sql/sql_groupby.asp).

The **key** operator was introduced in Dyalog version 14.0. Begin to familiarise yourself by experimenting with the following examples:
```APL
      'mississippi'{≢⍵}⌸'mississippi'
      {≢⍵}⌸'mississippi'
      'interpreter'{⍺⍵}⌸'mississippi'
```

**Interval index** is a function for classifying data by boundaries.

At this point it is worth familiarising yourself with older APL constructs which perform similar functionality to key, and are likely to exist in code bases written before Dyalog version 14.0. 

1. You already wrote Interval Index [in problem set 4](/Outer product/#problem-set-4) using the outer product `∘.F`. See if you can rewrite that `Grade` function using **interval index** `⍺⍸⍵`.

1. Try to write the interval index function `⍺⍸⍵` without using the `⍸` glyph

Iverson's [dictionary of APL](https://www.jsoftware.com/papers/APLDictionary1.htm) defines monadic equals `=⍵` as "nub in":

```APL
      NubIn ← (∪≡⍤99 ¯1⍤¯1 99⊢)
      NubIn 'abbcab'
1 0 0 0 1 0
0 1 1 0 0 1
0 0 0 1 0 0
      NubIn 3 3⍴6↑⎕A
1 0 1
0 1 0
```

## Problem set 7

### Search, sort, slice and select
1. Write two indexing expressions which apply to a scalar and return that scalar

1. Write a function `IRep` which is equivalent to `⍺/⍵` but uses indexing instead of replicate.

1. `NVec ← '' '34' 'donut' ⍬` is a four-element nested vector. Use a single pick `⍺⊃⍵` to obtain the sub-item `'o'`.

1.  From the nested 3D array `Nest←2 3 4⍴(⍳17),(⊂2 3⍴'ab'(2 3⍴'dyalog'),'defg'),⎕A[⍳6]` , use a single selection to obtain:
	1. The character scalar `'y'`
	1. The numeric scalar `6`

1. Two sorting expressions are `{(⊂⍋⍵)⌷⍵}` and `{⍵[⍋⍵]}`?  
	
	When might you use one over the other?

1. When does `{(⍸∨/⍺⍷⍵) ≡ ⍸∧/⍵∊⍺}`?

1. The membership function `⍺∊⍵` checks whether elements of `⍺` appear in `⍵`. Write a function `E` which checks whether major cells of `⍺` appear as major cells of `⍵`.
	<pre><code>      text E ↑' APP' 'LESS' 
0 1 1
0 0 0</code></pre>

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