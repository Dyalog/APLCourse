# Broken keyboard problems
APL is a language which evolves over time. Some of the primitives available today exist because they represent patterns which are very common. Not only this, but in APL there are usually several equally good ways of expressing the same idea. As you develop competency in APL, this versatility in expression becomes an advantage.

Imagine that your keyboard is broken such that it is impossible to type a particular glyph. It is a useful exercise in array thinking and use of APL to try and recreate the behaviour without using the primitive itself.

For each of the following problems:

- Read the prompt and think of which primitive function behaves in the way described.
- Write a function which matches the description but does not use that primitive function.

---

1. This primitive function is used to find the indices of a Boolean array.

	???+Example "Answers"
		We want to model the **where** functoin `⍸⍵` without using the **iota-underbar** glyph `⍸`.

		For Boolean vectors:

		```APL
		{⍵/⍳≢⍵}
		{⍵/⍳⍴⍵}
		```

		For Boolean arrays in general:
		
		```APL
		{(,⍵)/,⍳⍴⍵}
		{⍵⌿⍥,⍳⍴⍵}
		```

1. This primitive function returns the unique major cells of any array.

	???+Example "Answers"
		Index-of returns the index of the first occurance of an element. For `⍵⍳⍵`, this becomes a list of integer ID numbers which correspond to major cells as they appear.
	((⍳≢text)=text⍳text)/text

1. This primitive function counts the number of elements in a vector.
	{+/⍵=⍵}

1. This primitive function 
	{⍵=⌊⍵}
	{{⍵=⌊⍵}⍺÷⍵}
	{(⍺∊⍵)/⍺}

1. This primitive function reverses the order of the elements in a vector.

	???+Example "Answer"
		We want to model the reverse function `⌽⍵` without using the circle-stile `⌽` glyph.

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
	{+⌿⍺∘.=⍵}

	{+⌿(⍳≢⍵)∘.≤⍵⍳⍺}
	{(0<⍵)-(0>⍵)}

		Other ways to get `¯1` if a number `d` is negative include `¯1+2×d≤0` and `d÷|d`