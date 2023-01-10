# Namespaces and other objects
If you are familiar with **Object Oriented Programming** (**OOP**) concepts and have experience using them from another language, then Dyalog's classes and namespaces should hopefully feel quite straightforward to you.

*[OOP]: Object-oriented programming

There is a video [:simple-youtube: Namespaces in Dyalog APL](https://youtu.be/eBEwBSO5mBA) with a basic introduction to the concepts and usage of namespaces.

Two documents are also worth looking at, whether or not you are familiar with OOP:

- [Object Oriented Programming for APL Programmers](http://docs.dyalog.com/latest/Object%20Oriented%20Programming%20for%20APL%20Programmers.pdf)
- [A Quick Introduction to Object Oriented Programming for Impatient APL Programmers](http://docs.dyalog.com/latest/Object%20Oriented%20Programming%20for%20Impatient%20APL%20Programmers.pdf)

If nested arrays are arrays inside arrays; **namespaces** are a bit like a workspace within a workspace. They are **objects** which contain collections of names, and these names can be listed as before, but using the dot `.` syntax from <a target="_blank" href="https://cs.stackexchange.com/questions/89031/what-is-the-origin-of-dot-notation">object-oriented</a> programming.

```APL
      )ns ns         ⍝ Create an empty namespace called ns
      ns.var←1 2 3   ⍝ Create a variable in ns called var
      ns.fn←{⍺,⍵}    ⍝ Create a function in ns called fn
      ⎕nl-9  	     ⍝ List the names of objects in the current namespace
┌──┐
│ns│
└──┘
      ns.⎕nl-⍳9      ⍝ List all names in ns
┌──┬───┐
│fn│var│
└──┴───┘
      )cs ns         ⍝ Change into ns
      ⎕this.⎕nl-⍳9   ⍝ The current namespace is ⎕THIS
┌──┬───┐
│fn│var│
└──┴───┘
      #.⎕nl-⍳9       ⍝ The root namespace is #
┌──┐
│ns│
└──┘
```

### Mutable objects
Variables are **pass-by-value**. This means that if one name is used to assign another name, changes to the first name are not reflected in the second name.

```APL
      var1←1 2 3
      var2←var1     ⍝ The value of var1 is assigned to var2
      var1←var1+6   ⍝ The value of var2 is changed
      ⎕←var2        ⍝ var2 retains the previous value
1 2 3
```

Namespaces are objects and are **pass-by-reference**. All names which are assigned a reference (or **pointer**) can be used to refer to the original object.

```APL
      )ns ns1
#.ns1
      ns1.name←'Bob'
      ns2←ns1
      ns2.name←'Steve'
      ⎕←ns1.name
Steve
```

!!! Note "Discussion"
	1. Should there be a difference between `(⎕NS⍬)(⎕NS⍬)` and `(2⍴⎕NS⍬)`?
		1. With "by value" semantics?
		1. With "by reference" semantics?
	1. What properties should two namespaces have in order to compare equal? Which of the following scenarios would be faster?
		- Using "by value" semantics?
		- **By reference:** when they originate from the same call to `⎕NS`?
	1. Can you find a way to achieve "by value" semantics when using namespaces?

??? Example "Discussion notes"
	1. Should there be a difference between `(⎕NS⍬)(⎕NS⍬)` and `(2⍴⎕NS⍬)`?
		1. No difference in this case, there are just empty namespaces: `(2⍴⎕NS⍬)≡(⎕NS⍬)(⎕NS⍬)`
		1. Yes. In `(⎕NS⍬)(⎕NS⍬)` we create two entities. In `(2⍴⎕NS⍬)` we create only one.
	1. What properties should two namespaces have in order to compare equal? Which of the following scenarios would be faster?
		1. **By value**: when the two namespace have the exact same content. This is slow as it requires recursively inspecting each namespace for its contents and doing comparisons on every member.
		1. **By reference**: When the two namespaces originate from the same call to `⎕NS`. This is fast as it requires only the comparison of two pointers.
	1. **Clone** (or **make a deep copy of**) a namespace
		<pre><code class="language-APL">      ns1←⎕NS⍬
	      ns1.vec←1 2 3
	      ns3←⎕NS ns1
	      ns3.vec[2]←10   ⍝ Only the new copy is changed
	      ]disp ns1.vec ns3.vec
	┌→────┬──────┐
	│7 8 9│7 10 9│
	└~───→┴~────→┘</code></pre>

## Dyadic execute `⍎`
Namespaces can be used as a simple dictionary structure.

```APL
      value ← dictionary.name   ⍝ Get value
      dictionary.name ← value   ⍝ Set value
```

But how do we do this when the name can vary? Use variables to store the name.

```APL
      ns←⎕NS⍬
      name←'foo'

      ns⍎name,'←1 2 3'
      10×ns.foo
```
```
10 20 30
```

!!! Warning
	**Beware:** `⍎` is potentially dangerous:
	
	<pre><code class="language-APL">      ns←⎕NS⍬
	      name←'⎕OFF⋄'   ⍝ !!!
	      value←1 2 3
	      ns {⍺.{⍎⍺,'←⍵'}/⍵} name value</code></pre>
	
	In production, **validate your arguments**.

## Modifying namespaces
In some applications, it is useful to keep a namespace as an object that holds the state of something.

It is reasonable in this case to write a tradfn that uses a namespace reference as both its argument and result. While tradfns can have the side effect of modifying a namespace, we strongly recommend that functions take arguments and return results anyway.

```
      ∇ nsref ← rate Modify nsref
         nsref.var +← rate
      ∇ 
```

## Code organisation
Having modular code organisation is a very sensible idea. However, it is a recent invention relative to APL. In a newer application, it is not hard to imagine a `utils` namespace, a `maths` namespace, an `interface` namespace and so on. In older applications, such compartmentalisation is often achieved using a naming convention. For example:

```APL
      ⎕NL 3
displayINPUT
displaySHOW 
mathsAVG    
mathsDET    
mathsSTDEV  
utilLINES   
utilSPLIT  
```

This type of code organisation is known as a **flat workspace structure**.

## Names and references
In Dyalog there are both *named* and *unnamed* namespaces. Considering our use of the word "name" to refer to a token in the workspace, beginning with a letter, that refers to an array or function or operator, this is certainly a little confusing.

When creating or modifying a namespace, we can assign the namespace to a name which is a namespace reference.

```
      nsref ← ⎕NS⍬
      nsref.var ← 1 2 3
      ⎕←nsref
```

However, we can also use *dyadic* `⎕NS` to give the namespace a name. This name also becomes the namespace's default [display form](http://help.dyalog.com/latest/#Language/System Functions/df.htm). The default display form of an unnamed namespace is `[Namespace]`.

If we assign a reference at the same time, we now have a two ways to refer to the namespace. However, notice that the namespace's name (shown by the display form) stays the same throughout as we are referring to the same namespace object.

```
      nsref ← 'nsname'⎕NS⍬   ⍝ Assigning to the reference is optional
      ⎕←nsref ⋄ ⎕←nsname
      nsref2 ← nsname
      ⎕←nsref2
```

## Display form
The [**display form**](http://help.dyalog.com/latest/#Language/System Functions/df.htm) of an APL array is what is displayed when you execute an expression to display it:
```APL
      x ← 1 2 3
      x     ⍝ The display form of x (depending on ]box settings)
1 2 3
      ⎕←x   ⍝ The display form of x (depending on ]box settings)
1 2 3
```

Namespaces have a default display form.
The display form can be altered with ⎕DF:
```APL
      abc.⎕DF '#.abc' ⋄ abc
#.abc
      def.⎕DF 'Hello' ⋄ def
Hello
      (abc def).⎕DF ⎕NULL ⋄ abc def  ⍝ reset to default
 #.[Namespace]  #.def 
```

## Scripted namespaces
Store the source namespace as a single piece of text:
```APL
      )ed ⍟ns  ⍝ equivalent to '⍟'⎕ED'ns'
```
or
```APL
      ⎕FIX  ':Namespace ns'  'var←123'  ':EndNamespace'
      ns.var
123
      ⎕SRC ns
 :Namespace ns  var←123  :EndNamespace 
```

!!!Note
	Every time we ”fix”, the namespace is reset per the script. This means that `ns.var←456` would become `123` since the definition `var←123` is found in the script.

```APL

      ns.var←456
      ⎕SRC ns
 :Namespace ns  var←123  :EndNamespace 
      ns.var
456
      ⎕FIX ⎕SRC ns  ⍝ similar to editing and fixing
      ns.var
123

```

The table below compares some methods for a namespace in the workspace versus a namespace script with text source.

| Display Form | Script |
|---|---|
| Set:	`⍵.⎕DF` | Set: `⎕FIX source` |
| Get:	`⍕⍵` | Get: `⎕SRC ⍵` |
| Reset: `⍵.⎕DF ⎕NULL` | Reset: `⎕FIX ⎕SRC ⍵` |

### :Require
It is possible to have a script depend on other scripts. To do so, use the [**:require**](https://help.dyalog.com/latest/index.htm#Language/Object%20Oriented%20Programming/Including%20Script%20Files.htm) keyword.

## Problem set 9
1. Are namespaces created with `)NS` scripted or unscripted?
1. Use `⎕FIX` to create an unnamed, scripted namespace  
	
	What happens if you try to edit this script using the Dyalog editor?

1. Request handler
	1. Create a namespace called `req` containing
		- a variable `status` with the value `200`
		- a method `Method` which is the function `{4+2×⍵}`
	1. Within the `req` namespace, apply `Method` to `status` and store the result in `status`
1. Write a function `Into` that copies a workspace into a namespace
	<pre><code class="language-APL">      dfns←⎕NS⍬
      'dfns.dws' Into dfns
      dfns.disp dfns.morse 'SOS'
┌───┬───┬───┐
│...│---│...│
└───┴───┴───┘</code></pre>
	
	??? Hint
		See the [documentation for `⎕NS`](https://help.dyalog.com/latest/index.htm#Language/System%20Functions/ns.htm).

1. Write a function that swaps the values of two variables, the names of which are given as a 2-element nested vector of character vectors `⍺`.
	<pre><code class="language-APL">      ns←⎕NS⍬
      ns.(aa bb)←10 20
      ns your_function 'aa' 'bb'
      ns.(aa bb)
20 10</code></pre>

1. Write an expression that swaps the values of the variables named `x` in the namespaces `ns1` and `ns2` .
	<pre><code class="language-APL">      ns1←⎕NS⍬ ⋄ ns2←⎕NS⍬
      ns1.x←10 ⋄ ns2.x←20
      ns1.y←30 ⋄ ns2.y←40
      your_expression
      ns1.x ns1.y ns2.x ns2.y
20 30 10 40</code></pre>


1. Write a function ScalarRef that returns a scalar Boolean value indicating whether its argument is a scalar namespace.
	<pre><code class="language-APL">      ns←⎕NS⍬ ⋄ ns.a←10
      ]disp ScalarRef¨ ns.a 'abc' (ns ns) ns (⎕ns⍬) 42
0 0 0 1 1 0</code></pre>

	Use one or more of these scalar namespace properties:
	
	- Name Class (⎕NC) is 9 (ref; non-scalar arrays and non-nss are 2)
	- Data Representation (⎕DR) is 326 (pointer)
	- Depth (≡) is 0 (simple scalar)
	- Allows dot syntax (ns.name)

1. Write a function RefMask that returns an array of the same structure as its argument, but with bits indicating the namespace references.

	<pre><code class="language-APL">      ]disp RefMask (⊂⊂⊂⊂1 2 ns) 3 ns (2 2⍴'abc',⎕NS⍬)
┌─────────────┬─┬─┬───┐
│┌───────────┐│0│1│0 0│
││┌─────────┐││ │ │0 1│
│││┌───────┐│││ │ │   │
││││┌─────┐││││ │ │   │
│││││0 0 1│││││ │ │   │
││││└─────┘││││ │ │   │
│││└───────┘│││ │ │   │
││└─────────┘││ │ │   │
│└───────────┘│ │ │   │
└─────────────┴─┴─┴───┘</code></pre>

1. Write a function `Fetch` which takes namespace reference as left argument and a nested vector of character vector keys as right argument and returns the corresponding values from the namespace.

1. Write a function `IsRoot`
	<pre><code class="language-APL>      IsRoot ⎕SE.Dyalog.Utils
	0
      IsRoot #
	1
      IsRoot ⎕SE
	1</code></pre>

1. What is my root?
	Write a function FindRoot that takes a namespace as argument and returns its root.
	
	<pre><code class="language-APL>      FindRoot ⎕SE.Dyalog.Utils
⎕SE
      FindRoot #
\#
      FindRoot ⎕NS⍬
\#</code></pre>

1. What are our roots?
	Write a function FindRoots that takes an arbitrary array of namespaces and finds the root for each namespace.
	
	<pre><code class="language-APL>      FindRoots ⍪⎕SE.Dyalog.Utils(#,⎕NS⍬)⎕SE
┌──────┐
│⎕SE   │
├──────┤
│ #  # │
├──────┤
│⎕SE   │
└──────┘</code></pre>

1. Lineage
	Write a function `Line` that takes a single namespace and returns its lineage (as a vector of refs) from root to leaf.
	
	<pre><code class="language-APL>      Line ⎕SE.Dyalog.Utils
 ⎕SE  ⎕SE.Dyalog  ⎕SE.Dyalog.Utils 

      Line ⎕SE.cbbot.bandsb2.sb.io
 ⎕SE  ⎕SE.cbbot  ⎕SE.cbbot.bandsb2  ⎕SE.cbbot.bandsb2.sb  ⎕SE.cbbot.bandsb2.sb.io</code></pre>

1. Where are my children?
	Write a function that lists all the children of a given namespace.

	??? Hint
		Note: `⎕NL` is Name List, not Children List  
		Plan: You'll have to crawl through the entire workspace  
		Think: How could namespaces still be out of reach?
