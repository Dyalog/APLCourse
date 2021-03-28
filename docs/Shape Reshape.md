# Shape Reshape

1. Expermient with the expressions in the following block to gain an understanding of the functions used. 
1. Write a brief definition in English for each expression.  
	For example: `{2×⍳⍵}   ⍝ Even integers from 2 to 2×⍵ inclusive`. 
1. Use the language bar to discover the names of unfamiliar functions.

```APL
      3 4⍴⍳12   ⍝ A 3 row, 4 column matrix of the integers from 1 to 12 inclusive      
      ⍴cards←'A23456789TJQK'∘.,'SCHD'
      ⍉cards
      (,cards)[?×/⍴cards]
      alph←2 3 4⍴⎕A
      ,alph      
```

## The shape of a scalar

Use the match function `⍺≡⍵` to determine which expressions below produce the empty character vector `''` ("*quote-quote*") and which produce the empty numeric vector `⍬` ("*zilde*").

          0⍴0
          0↑⎕A
          ⍳0
          0⍴''
          0⍴'def'
          0 0⍴'abc'
          2 0 3⍴⍳6
          alph[⍸alph='Z']
          ⌈⌿⍬⍬
          ⎕JSON'{}'
          ⎕JSON'[]'
          ⎕JSON'""'

!!! Warning "Version Warning"
	`⎕JSON` ("*quad jason*") is a function for converting APL arrays to and from JavaScript Object Notation. It is not available in version 12.1.

A *simple array* contains only single numbers and/or characters as elements. Single numbers or characters are called *scalars*. Arrays generally can contain any other array. These are called *nested arrays*. For example `cards` is a nested matrix of character vectors.

```APL
      ⍴¨1 2 3 4   ⍝ What is the shape of each number in ⍳4?
      ⍴¨'ABCDE'   ⍝ What is the shape of each letter in 5↑⎕A?
      ⍴¨cards     ⍝ What is the shape of each array in cards?
```