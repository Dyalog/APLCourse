# User defined functions
## The Three Function Styles

So far, we have been reading and writing [dfns](https://aplwiki.com/wiki/Dfn). 

```APL
         3 {⍺+⍵} 5              ⍝ Left argument ⍺, right argument ⍵
           {⍵>0:⍵,∇ ⍵-1 ⋄ ⍵}5   ⍝ Guard is : (colon). The function itself is ∇ (del)
      Fn ← {⍺⍵}                 ⍝ We can give functions names
```

It is also possible to name functions without explicitly referring to their arguments. This is called [tacit](https://aplwiki.com/wiki/Tacit_programming) or *point-free* programming.

```APL
      Plus ← +
      IndicesTo ← ⍳
      _Reduce ← /      
      Sum ← Plus _Reduce
      Sum IndicesTo 10
```

There is a syntax for composing functions called [*trains*](). We won't look at them in detail now, but they allow some rather neat and memorable ways to write short functions.

```APL
      Mean ← +⌿ ÷ ≢         ⍝ The sum divided by the count
      Mean 3 1 4 1
      3 (+,-) 5             ⍝ Plus and minus
      ','(≠⊆⊢)'some,text'   ⍝ Split on commas
```

{% include note.html content='Small unnamed dfns and tacit functions expand your vocabulary. One of my favourites is the "split by delimiter" train <code class="language-APL">(≠⊆⊢)</code>. It looks like a beat-up face <a href="https://en.wikipedia.org/wiki/Emoticon#Japanese_style_(kaomoji)">kaomoji</a>. A similar phrase which can take multiple delimiters can be found on <a href="https://aplcart.info/?q=split%20text#">aplcart.info</a>.' %}


## Traditional functions

Dyalog is a modern APL implementation. Since the first APL implementations there has been a way of defining functions with a header line and named arguments and results. Since the introduction of dfns, functions of the original style are called *traditional functions* or [*tradfns*](https://aplwiki.com/wiki/Defined_function).

```APL
      Mean ← +⌿÷≢         ⍝ A 3-train (fork) for the arithmetic mean
      Mean ← {(+⌿⍵)÷≢⍵}   ⍝ A dfn for the arithmetic mean
      ∇ m ← Mean a        ⍝ A tradfn for the arithmetic mean
        m ← (+⌿a) ÷ ≢a
      ∇
```

{% include note.html content="Copy and paste everything between (and including) the two <code class='language-APL'>∇</code> <em>del</em> symbols into the session, and press <code class='language-APL'>Enter</code>, to define a tradfn in your workspace. <br><br>Using <code class='language-APL'>Shift+Enter</code> with the cursor on a name will bring up an editor window for that named thing." %}

A tradfn header reflects the calling syntax of the function. 

```APL
     ∇ {result}←{optional}TradFn argument;local1;local2
[1]    :If 0=⎕NC'optional'                             
[2]        optional←'no left argument'                 
[3]    :EndIf                                          
[4]    local1←'⍺: ',optional                           
[5]    local2←'⍵: ',argument                           
[6]    global←⍪'TradFn last called with'local1 local2  
[7]    result←⍪local1 local2                           
     ∇      
```

1. Try calling `TradFn` with one and two arguments. How can the result be made to display to the session? 
1. Inspect the variable `global` after calling `TradFn` with different arguments.
1. Step through the function using `Ctrl+Enter`. Inpect `⎕NC'optional'` when `TradFn` is called with one argument and when it is called with two arguments.

Here is the smallest tradfn:
```APL
      ∇ T
      ∇
```

`T` is a function which takes no arguments, returns no results and has no effects.

Results in `{}` curly braces do not print to the session by default, but can be passed to arguments. To ease debugging and write functions with predictable behaviour, it is generally best not to use shy results.

Optional left arguments are a little awkward in tradfns. The dfn equivalent is a little nicer looking: `{⍺←'default' ⋄ ⍺,⍵}`.

## Which style to use?

While usage of different function styles varies throughout many applications, I suggest these non-prescriptive guidelines, from [Adám's APL Style Guide](https://abrudz.github.io/style/), for production code. When maintaining others' code, it is best to try to continue in the already established style.

#### Dfns
For medium sized functions and utilities. Nested dfns are fine, but never use multi-line dfns inline.

```APL
 MultiDfn←{        ⍝ A Dfn with nested in-line multi-line dfns
     (3{           ⍝ These are confusing to read and trace through
         ⍺+2×⍵
     }⍺){
         x←⍺-4+⍵
         x-2×⍺
     }3+⍵
 }
```

 Instead, give them names and then apply them. Named dfns should be multi-line so that they can be traced through, unless truly trivial.

```APL
 MultiDfn2←{    ⍝ The previous function rewritten more clearly
     y←3+2×⍺
     x←y-1+⍵
     x-2×y  
 }       
```

Do not use a dfn instead of naming a variable. For example, instead of 

```APL
      r←{⍵/⍨10≤⍵}a,b
```

write

```APL
      candidates←a,b
      r←candidates/⍨10≤candidates
```

#### Tacit functions
Best as short, [pure functions](https://en.wikipedia.org/wiki/Pure_function), performing some specific task such as data transformation. Trains and functions derived from functions and operators (e.g. `+/`) can be used inline if they are not too complex.

#### Tradfns
Best used as program control and for dealing with system interactions. The use of control structures can make procedural tasks easier to debug. For example, if an error occurs during a loop or iteration.

```APL
      ¯5{i←⍺+⍳⍵ ⋄ i÷i-2}10   ⍝ A single line function cannot be traced through
```

{% include note.html content="💡 Use <code class='language-APL'>Ctrl+Enter</code> to step through a multiline function. You can then use <code class='language-APL'>Shift+Enter</code> to edit the function during execution and <code class='language-APL'>Esc</code> to save your changes to the function and continue execution." %}

```APL
    ∇  r←a MultiLineError o;i
[1]    :For i :In a+⍳o       
[2]        r←i+3             
[3]        r÷r-2             
[4]    :EndFor               
    ∇    
```

### Which style again?
1. Which of the following function styles can have multiple lines?
    1. TradFns
    1. Dfns
    1. Tacit functions
1. Which of the following function styles can be anonymous (unnamed)?
    1. Tradfns
    1. Dfns
    1. Tacit
1. Think about which function style would be most appropriate in the following situations.    
    1. Launching an application
    1. Applying a mathematical formula to an array of values
    1. A utility function to sort an array 
    1. Reading and writing files
    1. Expressing the sum of two functions (f+g)(x)
    1. Downloading data from the internet
    1. GUI programming
    1. Checking if a function is a [no-op](https://en.wikipedia.org/wiki/NOP_(code) for a particular array
    1. Defining a [piecewise](https://www.mathsisfun.com/sets/functions-piecewise.html) mathematical function

### Choo choo

1. Translating functions
    1. Convert the following dfns into trains
        1. `{⌈/≢¨⍵}`
        1. `{1+⍺-⍵}`
        1. `{∨/⍺∊⍵}`
        1. `{(⌽⍵)≡⍵}`
    1. Convert the following trains into dfns
        1. `(⌈/-⌊/)`
        1. `(+⌿÷1⌈≢)`
        1. `(⊢-|)`
        1. `(1∧⊢,÷)`

### Marking Tests
Way back in section 1.4 you wrote a dfn to convert test scores into letter values.

You were led to produce some function or expression similar to the following:

```APL      
      Grade←{'FDCBA'[+/⍵∘.>80 70 60 50 0]}
      Grade 95 65 92 77
```

This is an array-oriented solution to this problem. However, if a human was manually grading test scores, they might take one scored paper at a time and decide on which letter grade to write by reading each score.

Procedural [psuedocode](https://en.wikipedia.org/wiki/Pseudocode):

```pseudocode
scores = 93,85,45,10,70,16,93,63,41,7,95,45,76
For each score in scores:
  If score is greater than 80:
    Write "A"
  Else If score is greater than 70:
    Write "B"
  Else If score is greater than 60:
    Write "C"
  Else If score is greater than 50:
    Write "D"
  Else
    Write "F"
```

Control Structures in Dyalog are keywords beginning with a `:` colon.

```APL
      :If :OrIf :AndIf :ElseIf :Else :EndIf
      :For :In :EndFor
      :While :EndWhile
      :Repeat :Until      
```

Exit from a loop before it is finished using the `:Return` keyword.

### Tasks

1. Translate the pseudocode above into a **tradfn** called `Grade2` using control stuctures.

1. Rewrite the `Grade` function again as either a dfn or a tradfn called `Grade3` which uses the interval index function (dyadic `⍸`).

1. Use the `]runtime` user command to compare the computation time for each of the three grading functions.

    ```APL
          ]runtime -c "Grade 10×⍳10" "Grade2 10×⍳10" "Grade3 10×⍳10"
    ```