# Part 4

## Nested Arrays and Array Transformations
1. Write a monadic function to retrieve the last element of a vector
    ```apl
          Last 'hello'
    o
          Last ⍳7
    7
          Last (1 2 3)(4 5)(8)(42 43)   ⍝ Disclosed result
    42 43
    ```

1. Given

    ```apl
    vec ← (1 2 3) (1 (2 3)) (1 2 3)
    ```

    1. What is the shape, rank and depth of `vec`?
    1. Use a single multiplication (`×`) to get the following results:
        1. 
            ```
            ┌─────┬───────┬─────┐
            │2 4 6│┌─┬───┐│2 4 6│
            │     ││2│4 6││     │
            │     │└─┴───┘│     │
            └─────┴───────┴─────┘
            ```
        1. 
            ```
            ┌─────┬───────┬─────┐
            │2 4 6│┌─┬───┐│2 4 6│
            │     ││1│2 3││     │
            │     │└─┴───┘│     │
            └─────┴───────┴─────┘
            ```
        1. 
            ```
            ┌─────┬───────┬─────┐
            │2 4 6│┌─┬───┐│1 2 3│
            │     ││1│4 6││     │
            │     │└─┴───┘│     │
            └─────┴───────┴─────┘
            ```

1. Write a monadic function `Join` which joins a nested vector of character vectors `⍵` into a single, non-nested character vector in which elements from `⍵` are separated by the character scalar `,` (comma).

	```APL
	      Join 'join' 'these' 'words'
	join,these,words
	```

	**BONUS** Can you write `Join` as a *dyadic* function which accepts a separator scalar as `⍺`?

	```APL
	      ' ' Join 'join' 'these' 'words'
	join these words

	      '|' Join 'join' 'these' 'words'
	join|these|words
	```


1.  Given a right argument of a list of words (or possibly a single word), return a character matrix that is as wide as the longest word and one row per word, where each word is centered within the row. If there are an odd number of spaces to center within, leave the extra space on the right.

    💡 Hint: The mix [`↑Y`](http://help.dyalog.com/latest/Content/Language/Primitive%20Functions/Mix.htm) and rotate [`X⌽Y`](http://help.dyalog.com/latest/Content/Language/Primitive%20Functions/Rotate.htm) functions will probably be useful here.

    ```APL
          Center 'APL' 'Problem' 'Solving'
      APL  
    Problem
    Solving
          Center 'APL' 'Problem' 'Solving' 'Specialist'
       APL    
     Problem  
     Solving  
    Specialist
          ⍴Center 0⍴⊂''
    0 0
    ```

## Finding and Replacing Values
1. Write a function test if there are any vowels `'aeiou'` in text vector `⍵`

	```APL
	      AnyVowels 'this text is made of characters'
	1

	      AnyVowels 'bgxkz'
	0
	```

1. Write a function to count the number of vowels in its character vector argument `⍵`

	```APL
	      CountVowels 'this text is made of characters'
	9

	      CountVowels 'we have twelve vowels in this sentence'
	12
	```

1. Write a function `Clean` that changes all non-digits into stars.

	```APL
	      Clean 'Easy as 1, 2 and 3'
	********1**2*****3

	      Clean '1000'
	1000

	      Clean 'APL works!'
	**********
	```

1. Create a function `ReplaceHead` which returns its left argument vector `⍺`, but with the first `⍴⍵` elements replaced with the contents of `⍵`.

	```APL
	      'apple' ReplaceHead 'Eat'
	Eatle

	      'apple' ReplaceHead 'rang'
	range

	      'apple' ReplaceHead 'ENTERPRISE'
	ENTER
	```

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

1. These are the heights of some students in 3 classes.
	```APL
	student ← 10 7⍴'Kane   Jonah  JessicaPadma  Katie  CharlieAmil   David  Zara   Filipa '
	class ← 'CBACCCBBAB'
	height ← 167 177 171 176 178 164 177 177 173 160
	```

	Use APL to:

	1. Find the height of the tallest student
	1. Find the name of the tallest student
	1. Find the class to which the tallest student belongs  
	1. Find the average height of students in class `B`

1. Anna, Ben and Charlie are having a competition. They want to see who can eat the most fruit in a week.

	```APL
	fruits ← 4 7⍴'Apples MangoesOrangesBananas'
	days ← 7 3⍴'SunMonTueWedThuFriSat'
	names ← 3 7⍴'Anna   Ben    Charlie'
	⎕RL ← 42 1 ⋄ ate ← ?3 4 7⍴3
	```

	???+Question "What is `⎕RL`?"
		The <dfn>roll</dfn> function `?⍵` generates random numbers for each simple scalar number in `⍵`.

		Setting the <dfn>Random Link</dfn> system variable `⎕RL` lets us generate the same random numbers repeatedly.

	1. Compute the names of the people who ate the most fruit on Tuesday and Sunday combined.
	1. Compute the name of the person who ate the most mangoes and bananas combined.
	1. What is the name of the person who ate the most fruit overall?
