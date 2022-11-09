# Broken keyboard problems
APL is a language which evolves over time. Some of the primitives available today exist because they represent patterns which are very common. Not only this, but in APL there are usually several equally good ways of expressing the same idea. As you develop competency in APL, this versatility in expression becomes an advantage.

Imagine that your keyboard is broken such that it is impossible to type a particular glyph. It is a useful exercise in array thinking and use of APL to try and recreate the behaviour without using the primitive itself.

For each of the following problems:

- Read the prompt and think about which primitive function behaves in the way described.
- Write a function which matches the description but does not use that primitive function.

---

1. This primitive function is used to find the indices of a Boolean array.

	???+Hint "What primitive function is this?"
		We want to model the **where** function `⍸⍵` without using the **iota-underbar** glyph `⍸`.

	???+Example "Answers"
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

	???+Hint "What primitive function is this?"
		We want to model the **shape** `⍴⍵` or **tally** function `≢⍵` without using the **rho** `⍴` or **not-identical-to** `≢` glyphs. We might need to use different approaches depending on the type and structure of our argument.

	???+Example "Answers"
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

	???+Hint "What primitive function is this?"
		We want to model the reverse function `⌽⍵` without using the circle-stile `⌽` glyph.
	
	???+Example "Answer"
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


1. Write a function which:
	- takes a numeric left argument vector `⍺`, sorted ascending
	- takes a numeric right argument vector `⍵`
	- returns an integer vector of the same length as `⍵`, indicating the intervals in `⍺` in which elements in `⍵` belong
	- **BONUS:** write a version which also works with characters arrays

	```APL
	      'ADG' Function 'ABCDEFG'
	1 1 1 2 2 2 3
	```

	???+Hint "What primitive function is this?"
	???+Example "Answer"

	{+⌿⍺∘.=⍵}

	{+⌿(⍳≢⍵)∘.≤⍵⍳⍺}
	{(0<⍵)-(0>⍵)}

		Other ways to get `¯1` if a number `d` is negative include `¯1+2×d≤0` and `d÷|d`