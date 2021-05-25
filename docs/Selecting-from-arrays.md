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
Square-bracket indexing requires you to know the exact rank of the array and have the correct number of semicolons in your indexing expression. You might also notice that it is a special or [anomolous syntax](https://aplwiki.com/wiki/APL_syntax#Syntactic_elements).

There is also an **index** function `⍺⌷⍵` which has two distinctions:

- It is a function with the same syntax as other functions
- It applies to any rank array by automatically filling in less-major cells

```APL
      (1 2)(2 3)⌷(2 3 4⍴⎕A)
      (2 3 4⍴⎕A)[1 2;2 3;]
```

!!! Note
	The cells of an array are scalars, and indexing always returns the cells. 

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

### Select (A.K.A. "Sane") indexing
Some APLers are unhappy with the squad-index semantics, and have proposed yet another mechanism, called sane indexing or **select**. It can be defined as:
```APL
      I←(⊃⍤⊣⌷⊢)⍤0 99   ⍝ Sane indexing
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
|Arbitrary cells|Select|

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

!!! Warning "Version Warning"
	The symbol `⌸` is not available in Classic Edition, and the Key operator is instead represented by `⎕U2338`.  
	The symbol `⍸` is not available in Classic Edition, and the Interval Index function is instead represented by `⎕U2378`.

At this point it is worth familiarising yourself with older APL constructs which perform similar functionality to key, and are likely to exist in code bases written before Dyalog version 14.0. You already wrote Interval Index [in problem set 4](/Outer product/#problem-set-4) using the outer product `∘.F`. See if you can rewrite that `Grade` function using Interval Index `⍺⍸⍵`.

Iverson's [dictionary of APL](https://www.jsoftware.com/papers/APLDictionary1.htm) defines monadic equals `=⍵` as "nub in", which gives
```APL
(∪a)≡⍤99 ¯1⍤¯1 99⊢a
(∪∘.≡⍥↓⊢)a
```

## Problem set n

### Search, sort, slice and select
1. Give two indexing expressions which apply to a scalar and return that scalar

1. Write a function `IRep` which is equivalent to `{⍺/⍵}` but uses indexing.

1. A nested 3D array, obtain X using a single selection.

1. How can you index into a scalar?

???+ Example "Answers"
	`⍬⌷42`  
	`42[⊂⍬]`  
	`⍬⊃42`  
	`IRep ← {⍵[⍺⍴⊂⍬]}`

1. Here is a table of data about visits to a museum
	<pre><code class="language-APL">      visits ← </code></pre>
	1. Return a vector of lengths grouped by blah

1. What is the advantage of `{(⊂⍋⍵)⌷⍵}` over `{⍵[⍋⍵]}`?

1. When does `{(⍺{⍸∨/⍺⍷⍵}⍵) ≢ ⍸∧/⍵∊⍺}`?

1. High-rank membership

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

!!! Warning "Version Warning"
	`HttpCommand` and `⎕NGET` are not available in Dyalog version 12.1. Instead, ???

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

???+ Example "Answers"
	<ol type="a">
		<li>$3585$</li>
		<li>$2149$</li>
		<li>baa</li>
		<li>bookkeeper  bookkeeper's  bookkeepers  bookkeeping  bookkeeping's</li>
		<li>$109$</li>
		<li>deified</li>
	</ol>

### Rain facts
