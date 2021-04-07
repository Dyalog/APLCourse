# Nested arrays
Arrays in Dyalog APL are always collections of scalars, regardless of rank. However, we can create arbitrarily complex scalars by a process known as enclosing. This means putting something in a “box”. It looks like so:

```APL
      v ← 1 2 3
      ⊂v         ⍝ Enclose the vector 1 2 3
┌─────┐
│1 2 3│
└─────┘
      v≡⊂v       ⍝ Does the vector v match the enclosed v? Of course not!
0
```

Verify that enclosing creates a scalar by checking the rank of `⊂v`

## Enclose Enlist
The `]box` user command is a way to display arrays with extra markings which indicate the structure:

```APL
      ]box on -style=max

```

!!! Warning "Version Warning"
	The `]box` user command is not available in version 12.1. Use `]disp` or `]display` instead.

### Session Toolbelt
Dyalog provides a native [IDE]() for Microsoft Windows, and the [Remote IDE]() for macOS and Linux. As well as the text-editor-like APL session, these provide some additional tools and shortcuts to make working with Dyalog easier. [Click here](https://www.dyalog.com/getting-started/tips.htm) to learn about some of these.

### Depth
We introduced [stranding](https://aplwiki.com/wiki/Strand_notation) to show how it formed vectors before the application of dyadic functions, for example:

```APL
      2 + 2 2 + 2   
      2 + 2 (2 + 2)
      (2 + 2) 2 + 2
```

Stranding is a useful way to form arrays. Generally, arrays separated by spaces form vectors. Experiment with the examples below, and notice the difference between stranding `a b` and *catenation* `a,b`.

```APL
      2 3⍴'DY' 'AL' 'OG'
      'a' 'b' 'c'
      'a' 'bc'
      'a','b','c'
      'a','bc'
      mixed←3 3⍴1 2 3 'a' 'b' 'c'   ⍝ Simple mixed-type array
      mixed2←3 3⍴1 2 3 'abc'        ⍝ Nested mixed-type array
```

Note that the [prototypical element](https://aplwiki.com/wiki/Prototype) of a numeric array is the number zero `0` and of a character array is a space `' '` character (`⎕UCS 32`).

```APL
      bnm←2 3⍴⍬                     ⍝ Blank numeric matrix
      bcm←3 2⍴''                    ⍝ Blank character matrix
      (⎕UCS 32)=bcm
```

Below are some more examples to demonstrate the difference between catenation, *first-axis catenation* `⍪` and stranding.

```APL
      3 1⍴mixed bnm bcm
      ⍪mixed bnm bcm
      ↑mixed bnm bcm
      mixed,bcm
      mixed⍪bcm
      mixed⍪bnm
      3 3⍴mixed,bcm
      3 3⍴mixed bnm,bcm
```

A simple scalar is a rank-0 array which contains itself as its value.

```APL
      'a'≡⊃'a'       ⍝ The disclose of a simple scalar is itself
      42≡⊂42         ⍝ As is the enclose
      'abc'≡⊃'abc'   ⍝ Disclose on a simple array picks the first element
      'abc'≡⊂'abc'   ⍝ Enclosing an array results in a nested scalar
```

1. When does `(a b)≡a,b`?

1. When does `(↑a b)≡a⍪b`?

### Primitive Loops

Experiment with the following expressions to determine what the each `¨` and bind `∘` operators do in this context.

```APL
      's',¨'ong' 'ink' 'and'
      'lph',¨'ong' 'ink' 'and'
      (1 2)(2 2)(3 1)⍴¨3 4 5
      2 2∘⍴¨3 4 5
      (⍴∘3 4 5)¨2 2
```

### Options
Sometimes we would like a function to accept one or more option or parameter arguments.

For example
```
      'bob'{⍺∘≡¨⍵}'bob' 'dave' 'jim' 
1 0 0
      'bob'{⍺∘≡¨⍵}'bob'  
0 0 0
```

Why does the second expression above return three values? This is remedied using the *enclose-if-simple* function (monadic `⊆`).

```APL
      {'bob'∘≡¨⊆⍵}'bob'  
1
```

We can define stranding as the `Strand` function.

```APL
      Strand←{(⊂⍺),⊆⍵}               ⍝ A Stranding function 
      'bob'Strand'dave'Strand'jim'
┌───┬────┬───┐
│bob│dave│jim│
└───┴────┴───┘
```

Or as the function `Strand2←{⍺⍵}`.

### Word Problems

We are going to do some text processing on a dictionary of words. 

If you have access to the internet, the following expressions will download a text file dictionary (917kB in size) and store it as a nested vector of character vectors named `words`.

```APL
      ]Load HttpCommand
      words ← (⎕UCS 10) {(⍺≠⍵)⊆⍵} (HttpCommand.Get'https://tinyurl.com/y7asendy').Data
```

If you have the file on your computer (maybe you were given it on a USB drive, for example) then you can load it into your workspace from disk using the following expressions.

```APL
      (content encoding newline) ← ⎕NGET'/path/to/words.txt'
      words ← (⎕UCS newline) (≠⊆⊢) content
```

Now answer the following questions about `words`.

1. How many words have at least 3 `'e'`s in them?

1. How many words have exactly two consecutive `'e'`s in them? 
    The first three such words are `Aberdeen` `Abderdeen's` and `Aileen`.

1. What is the shortest word with two consecutive `'a'`s?

1. What words have three consecutive double letters? For example, `mississippi` does not but `misseetto` does. Misseetto is not a real word.

A palindrome is the same when reversed. For example, **racecar** is a palindrome but **racecat** is not.

{:start="5"}
1. How many palindromes are there in `words`?

1. Which palindrome in `words` is the longest?

#### Rank Practice

1. **Model Each**  
    Write models of the following functions using rank `⍤` instead of each `¨`. That is, write `IotaEach`, `SumEach` and `ReshapeEach` as dfns which use the rank operator and do not use the each operator.
    ```APL
          IotaEach 1 2 3              ⍝ ⍳¨1 2 3
    ┌─┬───┬─────┐
    │1│1 2│1 2 3│
    └─┴───┴─────┘
          SumEach 2 3⍴ IotaEach ⍳6    ⍝ +/¨2 3⍴⍳¨⍳6
     1  3  6
    10 15 21

          2 2 ReshapeEach (1 2) 3 4   ⍝ 2 2∘⍴¨(1 2) 3 4
    ┌───┬───┬───┐
    │1 2│3 3│4 4│
    │1 2│3 3│4 4│
    └───┴───┴───┘
    ```

{% include hint.html id="modeleach" content="Each <code class='language-APL'>¨</code> will implicitly disclose its arguments. You might need to use enclose <code class='language-APL'>⊂</code> and disclose <code class='language-APL'>⊃</code> to achieve the desired effect." %}

{:start="2"}
1. **Split k-cells**  
    The *split* function (monadic `↓`) splits an array of rank ≥2 by rows, returning an array of shape `¯1↓⍴⍵`. Use *enclose* `⊂` with the rank operator `⍤` to create a function `Split` which always splits an array into a nested vector of the major cells of `⍵`.

    ```APL
          Split 3 2 2 3⍴⍳9
      ┌─────┬─────┬─────┐
      │1 2 3│4 5 6│7 8 9│
      │4 5 6│7 8 9│1 2 3│
      │     │     │     │
      │7 8 9│1 2 3│4 5 6│
      │1 2 3│4 5 6│7 8 9│
      └─────┴─────┴─────┘
    ```