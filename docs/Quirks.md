# Out in the wild

Much of what is presented in this course is what is called *modern APL* in that it contains extensions to the [original mathematical notation](https://aplwiki.com/wiki/Timeline_of_influential_array_languages). The term "modern APL" generally means APL implementations with some form of general nested arrays.  

Dyalog maintains long-term backwards compatibility, meaning that code which ran on Dyalog version 1 can be run on the latest version with little or no modification. Therefore it is good to be aware of all of the language constructs, even if some of them have fallen out of fashion in newly-written code.

## Branch
Despite long and widespread use in many programming languages, `:If :Else`-style control structures are a relatively recent introduction to some APLs. Early on, the only way to control the flow of execution in APL was to using the branching arrow `→`.

```APL
      →ln             ⍝ Go to integer line number ln
      →0              ⍝ Return from function
      →⍬              ⍝ Go to next line
      →condition/ln   ⍝ If condition is true (1), go to line ln, otherwise go to next line

    ∇  r←BFac n   ⍝ Branching Factorial
[1]   ⍝ {⍵=1:⍵ ⋄ ⍵×∇ ⍵-1}              
[2]    →(n=1)/4                        
[3]    r←n×BFac n-1 ⋄ →0               
[4]    r←n                             
    ∇   
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

## The Axis Operator
Before the rank operator was invented<sup>[1](#hopl4)</sup>, certain functions had comparable behaviour in conjunction with *the axis operator*. However, the axis operator is not a true operator; it is not general, does not fit the standard function-operator syntax and does not work with user-defined functions.

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

As an exercise, try to reformulate the expressions above using only combinations of the operand functions enclose `⊂`, ravel `,` or catenate-first `⍪`; the rank operator `⍤`; and dyadic transpose `⍉`.

Some answers are in the hint box below:
<details markdown="1">
  <summary>Hint:</summary>

```APL
      A←2 3 4⍴⎕A
      ⍉,⍤2⊢2 3 1⍉A   ⍝ Transpose and ravel matrices
      ,⍤2⊢A          ⍝ Ravel matrices
      
      (2 3⍴⍳6)⍪2 3⍴⎕A       ⍝ Catenate first axis
      (2 3⍴⍳6)(⍪⍤1)2 3⍴⎕A   ⍝ Catenate vectors      

      (2 3⍴⍳6)(2 3 1⍉,⍤0⍤1)2 3⍴⎕A   ⍝ Laminate scalars within each pair of rows and transpose the result
      (2 3⍴⍳6)(,⍤0⍤1)2 3⍴⎕A         ⍝ Laminate scalars within each pair of rows

      ⊂⍤2⊢3 1 2⍉A   ⍝ Enclose matrices after transpose
```

</details>

Knowledge of the axis operator is required for anyone maintaining code which uses it, and it should be used to retain style unless all uses are to be replaced systematically with the rank operator. In any case, some people feel it provides pleasant [syntactic sugar](https://www.quora.com/What-is-syntactic-sugar-in-programming-languages) over the equivalent expressions which use rank and transpose.

---

1. <a id="hopl4" href="https://dl.acm.org/doi/pdf/10.1145/3386319#%5B%7B%22num%22%3A1037%2C%22gen%22%3A0%7D%2C%7B%22name%22%3A%22Fit%22%7D%5D">Hui, R.K. and Kromberg, M.J., 2020. APL Since 1978. Proceedings of the ACM on Programming Languages. **Section 3.1**</a>