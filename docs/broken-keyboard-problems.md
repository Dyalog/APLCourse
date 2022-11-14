# Broken Keyboard Problems
APL is a language which evolves over time. Some of the primitives available today exist because they represent patterns which are very common. Not only this, but in APL there are usually several equally good ways of expressing the same idea. As you develop competency in APL, this versatility in expression becomes an advantage.

Imagine that your keyboard is broken such that it is impossible to type a particular glyph. It is a useful exercise in array thinking and use of APL to try and recreate the behaviour without using the primitive itself.

For each of the following problems:

- Read the prompt and think about which primitive function behaves in the way described.
- Write a function which matches the description but does not use that primitive function.

---

1. This primitive function is used to find the indices of a Boolean array.

	???Hint "What primitive function is this?"
		We want to model the **where** function `⍸⍵` without using the **iota-underbar** glyph `⍸`.

	???Example "Answers"
		For Boolean vectors:

		```APL
		{⍵/⍳≢⍵}
		{⍵/⍳⍴⍵}
		```

		For Boolean arrays in general:
		
		```APL
		{(,⍵)/,⍳⍴⍵}
		{⍵/⍥,⍳⍴⍵}
		```

1. This primitive function counts the number of elements in a vector.

	???Hint "What primitive function is this?"
		We want to model the **shape** `⍴⍵` or **tally** function `≢⍵` without using the **rho** `⍴` or **not-identical-to** `≢` glyphs. We might need to use different approaches depending on the type and structure of our argument.

	???Example "Answers"
		For simple numeric vectors, we can use any mathemtical function which always returns `1` and add up the ones.

		```APL
		{+/⍵÷⍵}
		{+/⍵*0}
		{+/1+0×⍵}
		{+/×1+|⍵}
		```

		For any simple vector, we can ask equality with the argument itself:

		```APL
		{+/⍵=⍵}
		```

		For any vector, we can use each `⍺ F¨ ⍵` to map the match function `⍺≡⍵` between each element of `⍵` and itself.

		```APL
		{+/⍵≡¨⍵}
		```

1. This primitive function reverses the order of the elements in a vector.

	???Hint "What primitive function is this?"
		We want to model the reverse function `⌽⍵` without using the circle-stile `⌽` glyph.
	
	???Example "Answer"
		```APL
		{⍵[(≢⍵)-⍳≢⍵]}
		{⍵[(⍴⍵)-⍳⍴⍵]}
		```

		To model the reverse-first function `⊖⍵`, we should use **squad** `⍺⌷⍵` - the indexing function - to select major cells from our argument regardless of rank.

		```APL
		{(⊂1+(≢⍵)-⍳≢⍵)⌷⍵}
		```

		This solution still does not handle scalars. There may be several ways to account for this, but it easy to work around it with a guard:

		```APL
		{0=≢⍴⍵: ⍵ ⋄ (⊂1+(≢⍵)-⍳≢⍵)⌷⍵}
		```

1. Write a function to convert a character vector into upper case without using `⎕C`. Assume text consists of only lowercase alphabetic characters `a-z` and spaces.

	```APL
		  ToUpper 'sale on now'
	SALE ON NOW
	```

	???Example "Answer"
		```APL
		alph ← 'abcdefghijklmnopqrstuvwxyz'
		ToUpper ← {(⎕A,' ')[⍺⍳⍵]}
		```

		To learn about case folding and mapping using the case conversion system function `⎕C`, watch the webinar [Language Features of Dyalog version 18.0 in Depth - Part 1](https://dyalog.tv/Webinar/?v=Hln3zryunsw).

1. Write a function to convert only lowercase alphabetic characters `a-z` into uppercase, and leave all others alone.

	```APL
	      text←'What? Ignore these $#!?# characters!?'
	      ToUpper text
	```
	```
	WHAT? IGNORE THESE $#!?# CHARACTERS!?
	```

	???Example "Answer"
		There are other valid approaches, but here is one solution using selective assignment:

		```APL
		((text∊alph)/text) ← (⎕A,' ')[(text∊alph)/alph⍳text]
		```

1. This function returns unique major cells of `⍵`.

	???+Hint "What primitive function is this?"
		We want to model the **unique** function `∪⍵` without using the **downshoe** `∪` glyph.

	???+Example "Answers"
		Index-of returns the index of the first occurance of an element. For `⍵⍳⍵`, this becomes a list of integer ID numbers which correspond to major cells as they appear.

		```APL
		{((⍳≢⍵)=⍵⍳⍵)⌿⍵}
		```

		This is a good opportunity to mention the **swap** `⍺ F⍨ ⍵` and **selfie** `F⍨⍵` operators.

		```APL
		{⍵⌿⍨(⍳≢⍵)=⍳⍨⍵}
		```

1. This primitive removes scalars in `⍵` from the vector `⍺`.

	???+Hint "What primitive function is this?"
		We want to Write the **without** function `⍺~⍵` without using the **tilde** `~` glyph.

	???+Example "Answer"
		```APL
		{(1-⍺∊⍵)/⍺}
		```

1. This primitive function returns elements in the vector `⍺` which are also found in the vector `⍵`.

	???+Hint "What primitive function is this?"
		We want to write the **intersection** function `⍺∩⍵` without using the **upshoe** `∩` glyph.

	???+Example "Answer"
		```APL
		{(⍺∊⍵)/⍺}
		```

1. Write a function which:
	- takes a numeric left argument vector `⍺`, sorted ascending
	- takes a numeric right argument vector `⍵`
	- returns an integer vector of the same length as `⍵`, indicating the intervals in `⍺` in which elements in `⍵` belong

	```APL
	      1 3 7 Function 0 2 3 5 8
	0 1 2 2 3
	```

	- **BONUS:** write a version which also works with characters arrays

		```APL
		      'ADG' Function 'ABCDEFG'
		1 1 1 2 2 2 3
		```

	???+Hint "What primitive function is this?"
		Write a model of the **interval index** function `⍺⍸⍵` without using the **iota-underbar** `⍸` glyph.

	???+Example "Answer"
		For numeric arguments:
		
		```APL
		{+⌿⍺∘.≤⍵}
		{+/⍵∘.≥⍺}
		```

		For all arguments:

		```APL
		{+⌿(⍳≢⍵)∘.≤⍵⍳⍺}
		```

1. This primitive function returns `¯1` for negative numbers, `0` for `0` and `1` for positive numbers in its numeric argument array.

	???+Hint "What primitive function is this?"
		Write the **sign** or **signum** function `×⍵` without using the **multiplication** `×` glyph.
	
	???Example "Answer"

		```APL
		{(0<⍵)-(0>⍵)}
		```
