# Introductory examples

## Histogram
```APL
throws ← ?100⍴6
counts ← +/(∪counts)∘.=counts
hist ← `' ∘'[1+counts∘.>⍳⌈/counts]`
```

## Simple statistics
```APL
students←⎕A
scores←4 9 4 6 8 8 7 4 5 10 9 8 6 10 9 4 8 4 8 4 7 10 7 4 10 6
classes←'ACABAAABCCABCBBBACBCCACABA'

(score=⌈/score)/student
classes{(+⌿⍵)÷≢⍵}⌸scores
```

## Grille cypher
```APL
⎕←(grid grille)←5 5∘⍴¨'VRYIALCLQIFKNEVPLARKMPLFF' '⌺⌺⌺ ⌺ ⌺⌺⌺ ⌺ ⌺ ⌺⌺⌺ ⌺⌺⌺  ⌺⌺'
(' '=grille)/⍥,grid
grid[⍸grille=' ']
```

- matrices
- compress
- where `{⍵/⍳⍴⍵}`
- indexing

## Before during after
```APL
      from_til ← 14 16
      times ← 14 19 11 15 15 18 12
      'before' 'during' 'after'[1++⌿from_til∘.≤times]
┌──────┬─────┬──────┬──────┬──────┬─────┬──────┐
│during│after│before│during│during│after│before│
└──────┴─────┴──────┴──────┴──────┴─────┴──────┘
      'before' 'during' 'after'[1+from_til⍸times]
┌──────┬─────┬──────┬──────┬──────┬─────┬──────┐
│during│after│before│during│during│after│before│
└──────┴─────┴──────┴──────┴──────┴─────┴──────┘
```

- indexing
- outer product
- interval index/binning
- related: histograms

## Fruits
Anna, Ben and Charlie are having a competition. They want to see who can eat the most fruit in a week.

```APL
      fruits ← 4 7⍴'Apples MangoesOrangesBananas'
      days ← 7 3⍴'SunMonTueWedThuFriSat'
      names ← 3 7⍴'Anna   Ben    Charlie'
      ⎕RL ← 42 1 ⋄ ate ← ?3 4 7⍴3
```

- high rank arrays
- selection
- summaries along different axes/ranks

## Take 4 words
```APL
      {⍵⌿⍨4>+\' '=⍵}'this is a sentence with seven words'
this is a sentence
      {⊃(⊣,' ',⊢)/4↑' '(≠⊆⊢)⍵}'this is a sentence with seven words'
this is a sentence
```

## Look and say
```APL
      {∊(≢,⊃)¨⍵⊂⍨1,2≠/⍵},1 3 3 3 3 
1 1 4 3
      {⊃(//)↓⍉⍵⍴⍨2,⍨2÷⍨≢⍵}1 1 4 3
1 3 3 3 3
      {∊(//)⍵⍴⍨2,⍨2÷⍨≢⍵}1 1 4 3
1 3 3 3 3
```