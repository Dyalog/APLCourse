## FindWord
The [FindWord problem](./selecting-from-arrays.md#problem-set-7)

		An outer product or reshape can be used for the comparison, but we need to make sure our character vector has the right shape.
		```APL
		FindWord ← {∧/∨/⍺∘.=⍵↑⍨2⌷⍴⍺}
		```

		This outer product generates a 3-dimensional array. It is more efficient to reshape the vector to match the matrix:

		```APL
		FindWord ← {∧/⍺=(⍴⍺)⍴⍵↑⍨2⌷⍴⍺}
		```
		
		We can compare one row with several using [the rank operator](./cells-and-axes.md#the-rank-operator).

		```APL
		FindWord ← {∧/⍺(=⍤1)⍵↑⍨(⍴⍺)[2]}
		```

		The comparison followed by a reduction is also expressed neatly using [the inner product operator](./Operators.md#the-inner-product).

		```APL
		FindWord ← {⍺∧.=⍵↑⍨2⌷⍴⍺}
		```
