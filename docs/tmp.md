# Tmp
Keeping useful things for later.

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

## 