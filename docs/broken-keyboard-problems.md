# Broken keyboard problems
Let's review some of what we've looked at so far.

APL is a language which evolves over time. Some of the primitives available today exist because they represent patterns which are very common. Not only this, but unlike the zen of python, in APL there are usually several equally good ways of expressing the same idea. It might seem easier at first if you can simply ask "how do I do X?" and the response is always "you do Y", but as you develop competency in APL, the versatility in expression becomes an advantage.

It is a useful exercise in array thinking and use of APL to try and recreate the behaviour without using the primitive itself. This is also an excellent way to create regression tests to make sure that primitives behave as expected.

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

		Other ways to get `¯1` if a number `d` is negative include `¯1+2×d≤0` and `d÷|d`