# Naming convention
Since primitive APL constructs are, or begin with, non-letter glyphs, the user is free to name things as they like. However, some people find it clearer to stick to a naming style based on the type of each construct.

In this course, we adhere to the following naming convention:

- **Variables** in lower-snake case

	    var ← 1 2 3
	    multi_var ← 'multiple words in snake case'

- **Functions** in upper-camel case (a.k.a Pascal case)

	          Dfn ← {⍺⍵}
	    ∇ result ← left TradFn right;local
	      local ← left right
	      result ← left local right
	    ∇

- **Monadic operators** in upper-camel case with a leading underscore

	          _Mop ← {⍺ ⍺⍺ ⍵}
	          +_Mop arg

- **Dyadic operators** in upper-camel case with leading and trailing underscores

	          _Dop_ ← {⍺ ⍺⍺ ⍺ ⍵⍵ ⍵}
	          left +_Dop_× right