# Out in the wild

Much of what is presented in this course is what is called *modern APL* in that it contains extensions to the [original mathematical notation](https://aplwiki.com/wiki/Timeline_of_influential_array_languages). The term "modern APL" generally means APL implementations with some form of general nested arrays.  

Dyalog maintains long-term backwards compatibility, meaning that code which ran on Dyalog version 1 can be run on the latest version with little or no modification. Therefore it is good to be aware of all of the language constructs, even if some of them have fallen out of fashion in newly-written code.

## Branch
Despite long and widespread use in many programming languages, `:If :Else`-style control structures are a relatively recent introduction to some APLs. Early on, the only way to control the flow of execution in APL was to using the branching arrow `→`.

```APL
   →ln             ⍝ Go to integer line number ln or label ln:
   →0              ⍝ Exit current function and resume calling line
   →⎕LC            ⍝ Resume suspended execution
   →               ⍝ Clear one stack suspension
   →condition/ln   ⍝ If condition is true (1), go to line ln, otherwise go to next line
```
```
```
---
```APL
    ∇  r←BFac n   ⍝ Branching Factorial
[1]   ⍝ {⍵=1:⍵ ⋄ ⍵×∇ ⍵-1}              
[2]    →(n=1)/4                        
[3]    r←n×BFac n-1 ⋄ →0               
[4]    r←n                             
    ∇   
```
```
```

Keeping track of line numbers in this way would be a hassle for large programs. The introduction of *labels* makes understanding code easier.

```APL
    ∇  r←BFacL n   ⍝ Branching Factorial
[1]                ⍝ with Label         
[2]   ⍝ {⍵=1:⍵ ⋄ ⍵×∇ ⍵-1}               
[3]    →(n=1)/end                       
[4]    r←n×BFac n-1 ⋄ →0                
[5]   end:r←n                           
    ∇    
```

The use of `:GoTo` might be more suggestive to those unfamiliar with `→`.

```APL
    ∇  r←BFacG n   ⍝ Branching Factorial
[1]                ⍝ with GoTo          
[2]   ⍝ {⍵=1:⍵ ⋄ ⍵×∇ ⍵-1}               
[3]    :If n=1                          
[4]        :GoTo end                    
[5]    :EndIf                           
[6]    r←n×BFac n-1                     
[7]    :Return                          
[8]   end:r←n                           
    ∇   
```

You might prefer to use conditional keywords to keep blocks of statements together in a predictable way.

```APL
    ∇  r←BFacI n   ⍝ Branching Factorial
[1]                ⍝ with If            
[2]   ⍝ {⍵=1:⍵ ⋄ ⍵×∇ ⍵-1}               
[3]    :If n=1                          
[4]        r←n                          
[5]    :Else                            
[6]        r←n×BFac n-1                 
[7]    :EndIf                           
    ∇  
```

## The axis operator
Before the rank operator was invented<sup>[1](#hopl4)</sup>, certain functions had comparable behaviour when used in conjunction with *the axis operator*. However, the axis operator is not a true operator: it is not general, does not fit the standard function-operator syntax and does not work with user-defined functions.

However, there are some useful applications of the axis operator which are handy to know. Some can be replicated with combinations of both `⍤` rank and `⍉` transpose, for example.

```APL
      A←2 3 4⍴⎕A
      ,[1 2]A   ⍝ Merge first two axes      
      ,[2 3]A   ⍝ Merge last two axes      

      (2 3⍴⍳6),[1]2 3⍴⎕A   ⍝ Catenate first axis
      (2 3⍴⍳6),2 3⍴⎕A      ⍝ Catenate last axis

      (2 3⍴⍳6),[0.5]2 3⍴⎕A   ⍝ Laminate before 1st axis
      (2 3⍴⍳6),[2.5]2 3⍴⎕A   ⍝ Laminate after 2nd axis

      ⊂[1 3]A   ⍝ Enclose matrices along the first and third axes
```

As an exercise, try to reformulate the expressions above using only combinations of the operand functions enclose (`⊂⍵`), ravel (`,⍵`) or catenate-first (`⍪⍵`); the rank operator (`F⍤k`); and dyadic transpose (`⍺⍉⍵`).

??? Example "Answers"
	      A←2 3 4⍴⎕A
	      ⍉,⍤2⊢2 3 1⍉A   ⍝ Transpose and ravel matrices
	      ,⍤2⊢A          ⍝ Ravel matrices
	      
	      (2 3⍴⍳6)⍪2 3⍴⎕A       ⍝ Catenate first axis
	      (2 3⍴⍳6)(⍪⍤1)2 3⍴⎕A   ⍝ Catenate vectors      
	
	      (2 3⍴⍳6)(2 3 1⍉,⍤0⍤1)2 3⍴⎕A   ⍝ Laminate scalars within each pair of rows and transpose the result
	      (2 3⍴⍳6)(,⍤0⍤1)2 3⍴⎕A         ⍝ Laminate scalars within each pair of rows
	
	      ⊂⍤2⊢3 1 2⍉A   ⍝ Enclose matrices after transpose

Knowledge of the axis operator is required for anyone maintaining code which uses it, and it should be used to retain style unless all uses are to be replaced systematically with the rank operator. In any case, some people feel it provides pleasant [syntactic sugar](https://www.quora.com/What-is-syntactic-sugar-in-programming-languages) over the equivalent expressions which use rank and transpose.

## Portable defaults
All [system functions and variables](../Quad names/) have default values. However, to guarantee that your code will run correctly when copied into other users' code bases, it is a good idea to set some of these values at the top level of the namespaces or functions which constitute the entry points of your application.

It is common to see `(⎕ML ⎕IO)←1` or similar at the top of production functions and scripted namespaces.

### Migration level
The system variable `⎕ML` ("*quad-em-ell*") specifies a "migration level" in order to allow code bases from other APL systems to work unmodified in Dyalog. In particular, some primitive symbols (like `⊃` and `↑`) have different definitions depending on the migration level.

By default, this is set to 1. 

### Index origin
Due to its origin as a notational tool for teaching, arrays are indexed starting from 1 by default. However, some users are accustomed or find it convenient for indexing to start from 0 instead. In this way, it can be considered an "offset from the beginning of the array" rather than an [ordinal](https://en.wikipedia.org/wiki/Ordinal_numeral) index.

Dyalog provides a way to choose whether arrays are indexed starting from zero or one:

```APL
      'ABCD'[1]
A
      ⎕IO←0      ⍝ Quad eye-oh gets zero
      'ABCD'[1]
B
```

APLers all agree that it would be better if there was only one option for `⎕IO`, but none of them can agree on what it should be.

The author is sure that saying "the zero-th element" is incorrect. The *first* element may be labelled 0, but it is still the first element.

## Caution with namespace references
It is a good idea to organise code bases into namespaces which each serve a particular purpose. In this case, you will likely want to somehow access names in one namespace from calling functions in a different namespace. There are ways to do this, but they should all be used with caution. 

`⎕CS` is a system function to change the current namespace.

You can set the local search path for names using `⎕PATH`. For example, if you have a collection of utilities in `#.utils`, you do not need to keep referring to those functions by their full paths `#.utils.Foo` `#.utils.Goo` if you set `⎕PATH←'#.utils'`.

`:With` was really designed when working with GUI objects:

```APL
  ∇ make caption
[1]    :With 'MyForm' ⎕WC 'Form'
[2]        Caption←caption
[3]        Coord←'Pixel'
[4]        Size←400 800 ⋄ Posn←20 30
[5]        onClose←'HandleClose'
...
```

However, some users think that `⎕PATH`, `:With` and `⎕CS` simply make applications more difficult to debug when something goes wrong. In large functions, debugging can become difficult if namespaces and search paths are altered far from where an error occurs. This is especially problematic in tradfns with dynamic scope, if you forget to localise `⎕PATH` within a function.

One recommendation is to assign a reference to a long namespace path at the top of a function or namespace:

```APL
      str←#.utils.strings
      str.(nl split) char_vec_with_embedded_newlines
```

## Auxiliary processors
**Auxiliary Processors** AKA [**APs**](https://help.dyalog.com/17.1/index.htm#UserGuide/Installation and Configuration/Auxiliary Processors.htm) are a legacy mechanism akin to [using compiled shared native libraries with ⎕NA](../Interfaces/#name-association). We do not recommended using them in new projects, but they remain for the support of existing systems.

They were generally used when equivalent functionality written in APL was not performant, or not possible at the time. For example, in the past, set functions such as *Index-Of* `⍺⍳⍵` and *Membership* `⍺∊⍵` were slow. For some time, APs had the general advantage that the interpreter would not crash due to an error in an AP, but these days their performance is relatively poor due to having to copy data in and out of the active workspace. The performance of primitive functions is much better now than in the past and APs are a deprecated feature.

For some applications, you might want to see the documentation archive for [**information about the XUtils AP**](http://docs.dyalog.com/15.0/Code%20Libraries%20Reference%20Guide.pdf#%5B%7B%22num%22%3A43%2C%22gen%22%3A0%7D%2C%7B%22name%22%3A%22XYZ%22%7D%2C87%2C707%2C0%5D).

## Underscored alphabet
[**See the online documentation for the underscored alphabet**](https://help.dyalog.com/17.1/#Language/System%20Functions/Underscored%20Alphabetic%20Characters.htm)

Before Unicode... before personal computers... before [software fonts](https://en.wikipedia.org/wiki/Computer_font)... before [electronic hardware fonts](https://en.wikipedia.org/wiki/Mullard_SAA5050)... was... the typewriter! Due to its age, the history of APL is enough to appreciate many of the modern features that we take for granted in computing.

The first APL ([Iverson Notation](https://aplwiki.com/wiki/Iverson_notation)) was written by hand. Some of the earliest APLs on computers were on mainframe computers and accessed via teletype terminals such as the [IBM Selectric typewriter](https://en.wikipedia.org/wiki/IBM_Selectric_typewriter). These typewriters had type balls (colloquially referred to as "golf balls") which could be swapped out to enable different fonts - including an APL font.

It is quite interesting to see such a system in action, for example in this [demonstration of APL from 1975](https://youtu.be/_DTpQ4Kk2wA), you can hear the typewriter aggressively rattling off keystrokes as the result of computation is relayed back to the terminal. 

While all of this is now historical curiosity, one hangover might be relevant if you are working on older code bases. Older APL systems did not have lower case letters. Instead, there was the alphabet (`⎕A`), and an underscored alphabet (`⎕Ⓐ` - although in some fonts this is rendered as a circled-A Ⓐ). In recent versions of Dyalog, some accented characters have been co-opted for compatibility with older applications.

## Refactoring
It is usually best to continue code in the style in which you find it. This can include continuing to use many of the constructs which are here presented as "historical quirks". However, if an important part of the code base has become very difficult to reason about and debug, it might be worth your time to refactor it using more modern constructs and practices. This is referred to as "paying down technical debt", as the debt is accrued when the original author wrote code which makes it difficult, and therefore takes more time and money, to maintain. After paying the technical debt, it is hoped that future maintenance is far less resource intensive - so it is always a tradeoff between spending time now to make code nicer for the future, or spending time later wondering how the thing even works.

---

1. <a id="hopl4" href="https://dl.acm.org/doi/pdf/10.1145/3386319#%5B%7B%22num%22%3A1037%2C%22gen%22%3A0%7D%2C%7B%22name%22%3A%22Fit%22%7D%5D">Hui, R.K. and Kromberg, M.J., 2020. APL Since 1978. Proceedings of the ACM on Programming Languages. **Section 3.1**</a>