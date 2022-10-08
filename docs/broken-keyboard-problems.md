# Broken keyboard problems
Let's review some of what we've looked at so far.

APL is a language which evolves over time. Some of the primitives available today exist because they represent patterns which are very common. Not only this, but unlike the zen of python, in APL there are usually several equally good ways of expressing the same idea. It might seem easier at first if you can simply ask "how do I do X?" and the response is always "you do Y", but as you develop competency in APL, the versatility in expression becomes an advantage.

Imagine that your keyboard is broken such that it is impossible to type a particular glyph. It is a useful exercise in array thinking and use of APL to try and recreate the behaviour without using the primitive itself.

For each of the following problems:

- Read the prompt and think of which primitive function behaves in the way described.
- Write a function which matches the description but does not use that primitive function.

1. This primitive function is used to find the indices of a Boolean array.
- {⍵/⍳≢⍵}

1. This primitive function returns the unique major cells of any array.
- ((⍳≢text)=text⍳text)/text

1. This primitive function counts the number of elements in a vector.
- {+/⍵=⍵}

1. This primitive function 
- {⍵=⌊⍵}
- {{⍵=⌊⍵}⍺÷⍵}
- {(⍺∊⍵)/⍺}

1. This primitive function reverses the order of the elements in a vector.
- {⍵[(≢⍵)-⍳≢⍵]}

1. Write a function which:
	- takes a numeric left argument vector `⍺`, sorted ascending
	- takes a numeric right argument vector `⍵`
	- returns an integer vector of the same length as `⍵`, indicating the intervals in `⍺` in which elements in `⍵` belong
	- **BONUS:** write a version which also works with characters arrays
	```APL
	      'ADG' Function 'ABCDEFG'
	1 1 1 2 2 2 3
	```
- {+⌿⍺∘.=⍵}

- {+⌿(⍳≢⍵)∘.≤⍵⍳⍺}
- {(0<⍵)-(0>⍵)}

		Other ways to get `¯1` if a number `d` is negative include `¯1+2×d≤0` and `d÷|d`