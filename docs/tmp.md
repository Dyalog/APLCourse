# Tmp
Keeping useful things for later.




1.   
	The average daily temperatures, in degrees Celcius, for 7 days are stored in a variable `t_allweek`.
	
	```APL
	t_allweek ← 11.7 8.6 9.7 14.2 6.7 11.8 9.2
	```

	1. The mean average temperature for the week
	1. The mean average temperature rounded to 1 decimal place

1. Remove the vowels `'aeiou'` in the text `'alphabetti spaghetti'`
1. Find the indices of the vowels `'aeiou'` in the text `'alphabetti spaghetti'`
1. Count the number of vowels `'aeiou'` in the text `'alphabetti spaghetti'`
1. Write an expression to test if there are any vowels `'aeiou'` in the text `'alphabetti spaghetti'`

1. Early or late

## Useful bits
Try these exercises in creating and using Boolean vectors.

1. These are the heights of some students in 3 classes.
	```APL
		student ← 'Kane' 'Jonah' 'Jessica' 'Padma' 'Katie' 'Charlie' 'Amil' 'David' 'Zara' 'Filipa'
		class ← 'CBACCCBBAB'
		height ← 167 177 171 176 178 164 177 177 173 160
		↑student height class
	```

	???+Question "How do I get those boxes around my output?"
		We are using [nested arrays](), although we have not yet formally introduced them.

		Turn boxing on with the user command
		```APL
			]Box on
		Was OFF
		```

	???+Question "What is `↑`?"
		We created three lists: a simple character vector `class`; a simple numeric vector `height`; and a nested vector of character vectors `student`.

		Placing them side by side created a single

	1.	
		1. Find the height of the tallest student
		1. What is their name?
		1. What class are they in?  
	1.	  
		1. What is the average height of students in class `B`?
		1. Which class has the tallest average height?
		1. Which class has the narrowest range of heights?

1. Pass-fail
	Provided a list of scores

	```APL
	34 22 40 90 76 44 16 16 25 22 44 41
	```

	write an expression which evaluates to a list of characters of the same length, in which a vertical bar `'|'` corresponds to a score less than 40 while a plus `'+'` corresponds to a score of 40 or more.

	```APL
	      your_expression
	||++++||||++
	```

## The shape of data
Perhaps a subsection

- shape of square bracket index is sum of shapes of indices (watch out for scalars!)
- A reduction always results in rank 1 less (hence nested things return a nested scalar)
	- `∨/('some text'='a')('some text'='b')('some text'='c')`
	- `⊃{⍺,','⍵}/'join' 'these' 'words' 'with' 'commas'`

- selective and indexed assignment
	- Defang
	- upper case
		- even with non-alphabetic chars
	- 'apple' ReplaceHead 'Eat' → Eatle
		'apple' ReplaceHead 'rang' → 'rangle'
		'apple' ReplaceHead 'ENTERPRISE'
	- SpitOnFirst
	- ReplaceRow

1. Write an expression to convert `text` into upper case. Assume text consists of only lowercase alphabetic characters `a-z` and spaces.
	```APL
	      text ← 'convert to upper case'
		  your_expression
		  text
	CONVERT TO UPPER CASE
	```

`(⎕A,' ')[alph⍳text]`

> then later, turn these into multiline dfns

1. Now try a version which includes any characters. Convert only lowercase alphabetic characters `a-z` into uppercase, and leave all others alone.
	```APL
	      text←'What? Ignore these $#!?# characters!?'
	      your_expression
	      text
	WHAT? IGNORE THESE $#!?# CHARACTERS!?
	```

`((text∊alph)/text)←(⎕A,' ')[(text∊alph)/alph⍳text]`

1. Write a function `Clean` that changes all non-digits into stars.
	```APL
	      Clean 'Easy as 1, 2 and 3'
	********1**2*****3
	      Clean '1000'
	1000
	      Clean 'APL works!'
	**********
	```

`{d←~⍵∊⎕D ⋄ r←⍵ ⋄ (d/r)←'*' ⋄ r}`

1. Create a function `ReplaceHead` which returns its left argument vector `⍺`, but with the first `⍴⍵` elements replaced with the contents of `⍵`.
	```APL
	      'apple' ReplaceHead 'Eat'
	Eatle
	      'apple' ReplaceHead 'rang'
	range
	      'apple' ReplaceHead 'ENTERPRISE'
	ENTER
	```

`ReplaceHead ← {r←⍺ ⋄ s←(≢⍺)⌊≢⍵ ⋄ r[⍳s]←s↑⍵ ⋄ r}`

## Problem Set
1. Write a function to count the number of vowels in some text

	```APL
	      CountVowels 'This text is made of characters.'
	```
	```
	9
	```
	---
	```APL
	      CountVowels 'We have TWELVE vowels in this sentence.'
	```
	```
	12
	```

1. A recipe serving 4 people uses 3 eggs. Write the function `Eggs` which computes the number of eggs which need cracking to serve `⍵` people. Using a fraction of an egg requires that a whole egg be cracked.

	```APL
	      Eggs 4
	```
	```
	3
	```
	---
	```APL
	      Eggs 100
	```
	```
	75
	```
	---
	```APL
	      Eggs ⍳12
	```
	```
	1 2 3 3 4 5 6 6 7 8 9 9
	```

1. Write a function `To` which returns integers from `⍺` to `⍵` inclusive.

	```APL
	      3 To 3
	3
	      3 To 4
	3 4
	      1 To 7
	1 2 3 4 5 6 7
	      ¯3 To 5
	¯3 ¯2 ¯1 0 1 2 3 4 5
	```

	**BONUS** Make `To` work even if `⍺>⍵`:  
	```APL
	      3 To 5
	3 4 5
	      5 To 3
	5 4 3
	      5 To ¯2
	5 4 3 2 1 0 ¯1 ¯2
	```
1. The forumla to convert temperature from Celcius ($T_C$) to Farenheit ($T_F$) in traditional mathematical notation is as follows:

	$$T_F = {32 + {{9}\over{5}}\times {T_C}}$$  

	Write the function `CtoF` to convert temperatures from Celcius to Farenheit.  
	```APL
	      CtoF 11.3 23 0 16 ¯10 38
	52.34 73.4 32 60.8 14 100.4
	```

1. What Was In That Vector Again?
	The temperature 
	You should have a variable named `⎕AVU` in your workspace, from [problem set 1](../Problem set 1).

	1. How many even numbers are there in `⎕AVU`?
	2. What percentage of numbers in `⎕AVU` are odd numbers?
	3. What percentage of numbers in `⎕AVU` are strictly negative?
	4. What percentage of numbers in `⎕AVU` are strictly positive?
	5. What do you notice about the percentage of strictly positive and negative numbers?

1. Prime Time

	A prime number is divisible only by itself and `1`.

	Write a dfn which returns `1` if its argument is prime and `0` otherwise.

		          IsPrime 21
	    0
		          IsPrime 17
	    1


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

1. Making the Grade

    |   |   |   |   |   |   |
    |---|---|---|---|---|---|
    |**Score Range**|`0-64`|`65-69`|`70-79`|`80-89`|`90-100`|
    |**Letter Grade**|F|D|C|B|A|

    Write a function that, given an array of integer test scores in the inclusive range 0 to 100, returns a list of letter grades according to the table above.

	<pre><code class="language-APL">      Grade 0 10 75 78 85</code></pre>
	<pre><code class="language-APL">FFCCB</code></pre>

1. Bus stops in a town are labelled **A** to **E**. Define a function RouteMatrix which returns a Boolean matrix where `1`s indicate that buses go from one bus stop to the next.

	```APL
	      RouteMatrix 'BE' 'C' 'AE' 'BCE' 'A'
	0 0 1 0 1
	1 0 0 1 0
	0 1 0 1 0
	0 0 0 0 0
	1 0 1 1 0

	      'ABCDE'⍪RouteMatrix 'C' 'CDE' 'ABDE' 'E' 'B'
	A B C D E
	0 0 1 0 0
	0 0 1 0 1
	1 1 0 0 0
	0 1 1 0 0
	0 1 1 1 0
	```

1. Optimus Prime

	A prime number is divisible by only itself and `1`.

	Write a dfn which returns all of the prime numbers between `1` and `⍵`.

	```APL
	      Primes 10
	```
	```
	2 3 5 7
	```
	---
	```
	      Primes 30
	```
	```
	2 3 5 7 11 13 17 19 23 29
	```


Answers
1. RouteMatrix ← {'ABCDE'∘.∊⍵}

## Search, sort select?

- fruits example

## Broken keyboard problems
- ((⍳≢text)=text⍳text)/text
- {⍵/⍳≢⍵}
- {+/⍵=⍵}
- {⍵=⌊⍵}
- {{⍵=⌊⍵}⍺÷⍵}
- {(⍺∊⍵)/⍺}
- {⍵[(≢⍵)-⍳≢⍵]}
- {+⌿⍺∘.=⍵}
- {+⌿(⍳≢⍵)∘.≤⍵⍳⍺}
- {(0<⍵)-(0>⍵)}

## Arrays are made of arrays
- high rank arrays, major cells

- https://stackoverflow.com/questions/73578086/what-does-enclose-do-in-apl
- use of each
- Backwards (reverse the vector and its elements)
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

## The Shape of Data

1. Write a function `FindWord` which accepts a character matrix left argument `⍺` and a character vector right argument `⍵` and returns a Boolean vector where a `1` indicates a row in `⍺` which matches the word `⍵`.
	```APL
	      fruits FindWord 'Apples'
	1 0 0 0
	      fruits FindWord 'Oranges'
	0 0 1 0
	```

`FindWord←{⍺∧.=⍵↑⍨⊢⌿⍴⍺}`

`FindWord←{⍺∧.=((⍴⍺)[2])↑⍵}`


1. Anna, Ben and Charlie are having a competition. They want to see who can eat the most fruit in a week.

	```APL
	      fruits ← 4 7⍴'Apples MangoesOrangesBananas'
	      days ← 7 3⍴'SunMonTueWedThuFriSat'
	      names ← 3 7⍴'Anna   Ben    Charlie'
	      ⎕RL ← 42 1 ⋄ ate ← ?3 4 7⍴3
	```

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

### Summary Statistics


In an attempt to make things fair, the score for fruits eaten is weighted by the mass and nutritional values of each type of fruit.

```APL

```

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