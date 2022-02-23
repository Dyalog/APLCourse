# User defined functions
This is a fairly brief introduction, and there are exercises at the end of this section to help solidify your understanding, but there is also [a more extensive treatment of user-defined functions in the book Mastering Dyalog APL](https://mastering.dyalog.com/User-Defined-Functions.html).

## The Three Function Styles

So far, we have been reading and writing [dfns](https://aplwiki.com/wiki/Dfn). 

```APL
    3 {⍺+⍵} 5              ⍝ Left argument ⍺, right argument ⍵
      {⍵>0:⍵,∇ ⍵-1 ⋄ ⍵}5   ⍝ Guard is : (colon). The function itself is ∇ (del)
 Fn ← {⍺⍵}                 ⍝ We can give functions names
```

It is also possible to name functions which do not explicitly refer to their arguments. This is called [tacit](https://aplwiki.com/wiki/Tacit_programming) or *point-free* programming.

```APL
      Plus ← +
      IndicesTo ← ⍳
      _Reduce ← /      
      Sum ← Plus _Reduce
      Sum IndicesTo 10
```

There is a syntax for composing functions called [*trains*](https://aplwiki.com/wiki/Tacit_programming#Trains). 

A two-train is an **atop**:

```APL
      3(|-)5
2
      |3-5
2
```

A three-train is a **fork**:

```APL
      3(-×+)5
¯16
      (3-5)×(3+5)
¯16
```

Any further functions simply alternate between *atop* (even number of functions) and *fork* (odd number of functions).

```APL
      3(|-×+)5    ⍝ Absolute value of the product of sum and difference
16
      3(⌈|-×+)5   ⍝ Max residue with the product of sum and difference
4
```

They allow some rather neat and memorable ways to write short functions.

!!! Warning "Version Warning"
	Trains were introduced in Dyalog version 14.0

```APL
      Mean ← +⌿ ÷ ≢         ⍝ The sum divided by the count
      Mean 3 1 4 1
      3 (+,-) 5             ⍝ Plus and minus
      ','(≠⊆⊢)'some,text'   ⍝ Split on commas
```

!!! Note
	Small unnamed dfns and tacit functions expand your vocabulary. One of my favourites is the "split by delimiter" train <code class="language-APL">(≠⊆⊢)</code>. It looks like a beat-up face <a href="https://en.wikipedia.org/wiki/Emoticon#Japanese_style_(kaomoji)">kaomoji</a>. A similar phrase which can take multiple delimiters can be found on <a href="https://aplcart.info/?q=split%20text#">aplcart.info</a>.

!!! Warning "Version Warning"
	The symbol `⊆` (Left Shoe Underbar) is not available in Classic Edition, and Partition is instead represented by `⎕U2286`.  
	To use the partition function in version 12.1 (represented by `⍺⊆⍵` in Unicode Edition since version 16.0), you can set the [migration level](https://help.dyalog.com/latest/index.htm#Language/System%20Functions/ml.htm) locally inside a dfn: `Partition←{⎕ML←3 ⋄ ⍺⊂⍵}`

## Traditional functions
Dyalog is a modern APL implementation. Since early APL implementations there has been a way of defining functions with a header line and named arguments and results. Since the introduction of dfns, functions of the original style are called *traditional functions* or [*tradfns*](https://aplwiki.com/wiki/Defined_function).

```APL
      Mean ← +⌿÷≢         ⍝ A 3-train (fork) for the arithmetic mean
```
---
```APL
      Mean ← {(+⌿⍵)÷≢⍵}   ⍝ A dfn for the arithmetic mean
```
---
```APL
      ∇ m ← Mean a        ⍝ A tradfn for the arithmetic mean
        m ← (+⌿a) ÷ ≢a
      ∇
```

!!! Note
	Copy and paste everything between (and including) the two <code class='language-APL'>∇</code> <em>del</em> symbols into the session, and press <code class='language-APL'>Enter</code>, to define a tradfn in your workspace. <br><br>Using <code class='language-APL'>Shift+Enter</code> with the cursor on a name will bring up an editor window for that named thing.

A tradfn header reflects the calling syntax of the function. 

```APL
     ∇ {result}←{optional}Tradfn argument;local1                             
[1]    ;local2   ⍝ Locals can be declared across multiple lines in the header
[2]    :If 0=⎕NC'optional'                                                   
[3]        optional←'no left argument'                                       
[4]    :EndIf                                                                
[5]    local1←'⍺: ',optional                                                 
[6]    local2←'⍵: ',argument                                                 
[7]    global←⍪'TradFn last called with'local1 local2                        
[8]    result←⍪local1 local2                                                 
     ∇     
```

!!! Note
	The <code class='language-APL'>∇</code> del representation of the <code class='language-APL'>TradFn</code> function above is the <b>vector representation</b> result of <code class='language-APL'>⎕VR'TradFn'</code> which can be directly input into the session.

1. Try calling `TradFn` with one and two arguments. How can the result be made to display to the session? 
1. Inspect the variable `global` after calling `TradFn` with different arguments.
1. Step through the function using `Ctrl+Enter`. Inspect `⎕NC'optional'` when `TradFn` is called with one argument and when it is called with two arguments.

Here is the smallest tradfn:
```APL
      ∇ T
      ∇
```

`T` is a function which takes no arguments, returns no results and has no effects.

Results in `{}` curly braces are called **shy results** and do not print to the session by default, but can be passed to arguments. To ease debugging and write functions with predictable behaviour, it is generally best not to use shy results.

Optional left arguments are a little awkward in tradfns. The dfn equivalent is a little nicer looking: `{⍺←'default' ⋄ ⍺,⍵}`.

## Name scope, locals and globals
The scope of a name describes the circumstances under which it is visible to code. 

For most intents and purposes, you just need to know about the difference between how **local** and **global** names are defined in the syntax, and how **name shadowing** works.

By default, names assigned in tradfns are global. This is mostly for historical reasons. Names declared in the header - the arguments, results, and names preceded by semicolons - are localised.

By default, names in a dfn are local to that dfn. This is the preferred default in most modern programming languages.

If we define a name in the current namespace, that name is visible only within that namespace unless referred to by its full namespace path (e.g. `#.nsref.var`).

```APL
      'ns1'⎕ns⍬ ⋄ ns1.var←1 2 3
      'ns2'⎕ns⍬ ⋄ ⎕cs ns2
      ⎕←var
      ⎕←#.ns1.var
```

Let us now define a dfn and a tradfn:

```APL
     ∇ Dfn←{             
[1]        var←'lexical'⍵
[2]    }                 
     ∇                   

     ∇ Tradfn arg      
[1]    var←'dynamic'arg
     ∇  
```

!!! Note
	While the `∇` *del* representation of dfns can be used to define dfns in the session, dfns in scripted namespaces must be defined without `∇` dels.

If we call each of these functions, `Tradfn` will modify `var` in the workspace, but `Dfn` will not:

```APL
      Dfn var
      var
```
```
1 2 3
```
---
```APL
      Tradfn var
      var
```
```
┌───────┬─────┐
│dynamic│1 2 3│
└───────┴─────┘
```

Experiment with these altered definitions:

```APL
     ∇ Dfn←{              
[1]        var∘←'lexical'⍵
[2]    }                  
     ∇                    
```
---
```
     ∇ Tradfn arg;var  
[1]    var←'dynamic'arg
     ∇   
```

In Tradfns, references to local names within a function are said to "*shadow*" the same names from outer scopes. Notice how the following definition of `Tradfn` fails.

```APL
     ∇ Tradfn arg;var  
[1]    var,←'dynamic'arg
     ∇   
```
---

A similar dfn succeeds because, in dfns, modification will search namespaces in the local scope and then any parent scopes.

```APL
     ∇ Dfn←{              
[1]        var,←'lexical'⍵
[2]    }                  
     ∇                    
```

For completeness, here we will also mention `⎕SHADOW`. It is used when names are dynamically created using `⍎`, `⎕FX` or `⎕FIX` but need to be localised. However, it is best to use the function syntax to establish name scope in general. Further information can be found [in the specialists section on shadowed names](https://www.dyalog.com/uploads/documents/MasteringDyalogAPL.pdf#page=252) in Mastering Dyalog APL.

The technical distinction between dfns and tradfns is that tradfns have **dynamic scope** whereas dfns have **lexical scope**.

For further explanation of how this affects the use of dfns, see [section 5.5.3 of Mastering Dyalog APL](https://mastering.dyalog.com/User-Defined-Functions.html#lexical-scoping).

For another excellent introduction to lexical scoping, I can recommend the [page on lexical scoping in the BQN documentation](https://mlochbaum.github.io/BQN/doc/lexical.html#closures) (BQN is another language inspired by APL). 

### Avoid globals
When possible, avoid using global variables.
Pass parameters to functions as arguments unless this becomes very awkward.
The use of global variables should be limited to state settings that affect the entire application, or tables containing databases that are shared globally.
If you need global constants, it is a good idea to create them in a function in order to be able to use source code management / change tracking software.

A function which uses globals is difficult, if not impossible, to run in parallel. If two copies of the function run in parallel and they update the global data, some kind of locking is required. Locking often defeats the potential benefits of parallel execution.

Names should be localized unless they really really, really, really need to be global.

An example of when to use globals is a switch which affects the entire application:

```APL
    ∇  err←Log msg                                  
[1]    :If verbose                                  
[2]        ⎕←msg   ⍝ Display information to the user
[3]    :EndIf                                       
[4]    PrintFile msg                                
    ∇   
```

## Nested functions
It is possible to define functions inside some other functions.

- Tacit functions can only include other user-defined functions by name
	<pre><code class="language-APL">      Sort ← {(⊂⍋⍵)⌷⍵}
	  CSI ← Sort⍥⎕C   ⍝ Case-insensitive sort</code></pre>
		
	!!! Warning "Version Warning"
		`⎕C` (*quad C*) and `⍥` (*over*) are only available from Dyalog version 18.0 onwards. Upper- and lower-casing can be easily implemented in raw APL, or achieved using `819⌶` (*eight nineteen I-beam*). Over can be defined as a dop: `_O_←{0=⎕NC'⍺':⍺⍺ ⍵⍵ ⍵ ⋄ (⍵⍵ ⍺) ⍺⍺ ⍵⍵ ⍵}`.

- Dfns can contain tacit definitions and dfn definitions, as well as any named user-defined functions
	<pre><code class="language-APL"> SortedMeans ← {
    Sort ← {(⊂⍋⍵)⌷⍵}
    Mean ← +⌿÷1⌈≢
    Sort Mean¨⍵
}</code></pre>
- Tradfns can contain tacit definitions, dfn definitions and any named user-defined functions
	<pre><code class="language-APL">     ∇ result←SortedMeans vectors;Mean;Sort
[1]    Sort←{(⊂⍋⍵)⌷⍵}
[2]    Mean←+⌿÷1⌈≢
[3]    result←Sort Mean¨vectors
     ∇  </code></pre>

## Which style to use?

While usage of different function styles varies throughout many applications, you might take inspiration from [Adám's APL Style Guide](https://abrudz.github.io/style/), when writing brand new production code. When maintaining others' code, it is best to try to continue in the already established style.

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

!!! Note
	Use <code class='language-APL'>Ctrl+Enter</code> to step through a multiline function. You can then use <code class='language-APL'>Shift+Enter</code> to edit the function during execution and <code class='language-APL'>Esc</code> to save your changes to the function and continue execution.

```APL
    ∇  r←a MultiLineError o;i
[1]    :For i :In a+⍳o       
[2]        r←i+3             
[3]        r÷r-2             
[4]    :EndFor               
    ∇    
```

## Problem set 10

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
    1. Checking if a function is a [no-op](https://en.wikipedia.org/wiki/NOP_(code)) for a particular array
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
Way back in [problem set 4](/Outer-product/#problem-set-4) you wrote a dfn to convert test scores into letter values.

You were led to produce some function or expression similar to the following:

```APL      
      Grade←{'FDCBA'[+/⍵∘.>80 70 60 50 0]}
      Grade 95 65 92 77
```

This is an array-oriented solution to this problem. However, if a human was manually grading test scores, they might take one scored paper at a time and decide on which letter grade to write by reading each score.

Procedural [pseudocode](https://en.wikipedia.org/wiki/Pseudocode):

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
      :Repeat :Until :Return
```

1. Translate the pseudocode above into a **tradfn** called `Grade2` using control stuctures.

1. Rewrite the `Grade` function again as either a dfn or a tradfn called `Grade3` which uses `⍺⍸⍵` interval index.

1. Use the `]runtime` user command to compare the computation time for each of the three grading functions.
	<pre><code class="language-APL">]runtime -c "Grade 10×⍳10" "Grade2 10×⍳10" "Grade3 10×⍳10"</code></pre>
	
	!!! Warning "Version Warning"
		The `]runtime` user command is not available in Dyalog version 12.1. However, it is just a cover for the `cmpx` function from `dfns`:
		<pre><code class="language-APL">'cmpx'⎕CY'dfns'
		cmpx 'Grade 10×⍳10' 'Grade2 10×⍳10' 'Grade3 10×⍳10'</code></pre>
