# Operators

## About
Dyalog APL is not a functional programming language, but those familiar with functional languages will recognise APL's operators as [higher-order functions](https://en.wikipedia.org/wiki/Higher-order_function). Operators in Dyalog can be:

- monadic (take a single left operand as in `F/`)
- dyadic (take a left and a right operand as in `F⍤k`)

but they cannot be ambivalent. However, the functions derived from operators can be monadic, dyadic or ambivalent in terms of arguments. 

Ambivalent dfns usually have a default left argument (`⍺←default`) and ambivalent tradfns test if their left argument exists (`0=⎕NC'left_arg'`).

## Primitive
We have already used a few primitive operators, but there is [a complete summary of primitive operators](http://help.dyalog.com/latest/#Language/Primitive%20Operators/Operators%20Summarised.htm) in the online documentation.

### Quick guide
For some commonly used operators

|Operator|Calling syntax|Used for|
|---|---|---|
|Reduce|`F/` `F⌿`|Accumulation|
|N-wise reduce|`nF/` `nF⌿`|Windowed-reduction
|Scan|`F⍀`|Accumulation with intermediate results|
|Each|`F¨`|Looping / element-wise application over non-simple scalars|
|Rank|`F⍤k`|Looping / pair-wise application over cells|
|Power|`F⍣n` `F⍣G`|Iteration|
|Key|`F⌸`|Grouping|

### The Inner Product
Many people who have studied mathematics are familiar with one kind of inner product: matrix multiplication.

```APL
      (3 3⍴3 6 5 2)+.×3 3⍴1 0 ¯1
```

For two vectors:

```APL
      1 3 6((+/×)≡+.×)1 0 ¯1
```

The generalisation to any two functions leads to some neat encodings:

```APL
      'abbcde'+.='cbccfe'     ⍝ How many equal?
      1 3 4 5 2+.>0 3 3 6 3   ⍝ How many greater than?
```

As a particularly interesting example, the **transitive closure** of a [**connectivity matrix**](https://transportgeography.org/contents/methods/graph-theory-definition-properties/connectivity-matrix/) shows which nodes can reach which other nodes in a graph.

```APL
      cm←5 5⍴1 0 0 1 0 0 0 0 0
      (∨.∧⍨∨⊢)⍣≡cm
```

## Traditional
Just like [their function counterparts](./user-defined-functions.md#traditional-functions), traditional operators or [**tradops**](https://aplwiki.com/wiki/Defined_function_(traditional)#Operators) have a definition syntax which reflects their calling syntax:

```APL
      ⎕VR'TradOp'
     ∇ {result}←{left}(LF TradOp RF)right                   
[1]   ⍝ Dyadic operator which returns an ambivalent function
[2]    :If 0=⎕NC'left'                                      
[3]        result←LF RF right                               
[4]    :Else                                                
[5]        result←LF left RF right                          
[6]    :EndIf                                               
     ∇  
```
```
      
```
---
```APL
      3 (÷ TradOp +) 5     ⍝ Shy results 
      ⎕←3 (÷ TradOp +) 5   ⍝ The result
```
```
0.125
```

## Dop
**Dops** can be named or anonymous. They are just like dfns, except `⍺⍺` refers to its left operand and, if dyadic, `⍵⍵` refers to its right operand. For recursion, double-del `∇∇` is used to refer to the operator itself (and therefore must be used with operands to become a function when called), whereas a single del `∇` is used to refer to the derived function.

## Quirks of primitive operators

### Reduce and replicate
Reduce and replicate are both represented by *forward-slash* `/` (and *forward-slash-bar* `⌿` for their first-axis equivalents). Operators bind tightly (see [the binding table in the online documentation](https://help.dyalog.com/latest/index.htm#Language/Introduction/Binding%20Strength.htm)) to function operands, so a forward-slash in a [function train](https://aplwiki.com/wiki/Tacit_programming#Trains) will be interpreted as reduce. To force it to be the function replicate, use **atop** and **right-tack**.

```APL
(2∘|⊢⍤/⊢)⍳10
```

Of course this is subjective, but sometimes even simple functions look nicer as dfns:

```
{⍵⌿⍨2|⍵}⍳10
```

### Primitive dyadic operators
For no particular reason other than a technical limitation, dyadic primitive operators cannot be assigned to names. This is not a very useful thing to do in any case, but if you try this and find it does not work, just know that it is not supposed to work. 

If you must do this, the workaround is to wrap the operator in a simple dop. For example, `_Rank_←{⍺←⊢ ⋄ ⍺ (⍺⍺⍤⍵⍵) ⍵}`.

## Problem set 11

### Filter
The `_Filter` operator returns only scalars of `⍵` which satisfy a predicate `⍺⍺`. That is, `⍵` is part of the result where `1=⍺⍺ ⍵`. Write the `_Filter` operator as a *dop*.

```APL
      2∘|_Filter ⍳20              ⍝ Odd numbers
1 3 5 7 9 11 13 15 17 19
      {(⊢=⌊)0.5*⍨⍵}_Filter ⍳100   ⍝ Square numbers
1 4 9 16 25 36 49 64 81 100
```

### Apply

The `_Apply_` operator will return its argument array `⍵`, but with its right operand function `⍵⍵` applied to elements for which `1=⍺⍺ ⍵`. 

```APL
      3+_Apply_ 2∘|⊢⍳10
1 5 3 4 5 6 7 8 9 10
```

1. 
	1. Which primitive operator behaves like this?
	1. What can that primitive operator do which is missing from the description of `_Apply_`?
1. Implement a simple version of `_Apply_` without using that primitive operator.

### Numerical integration
This problem is from Phase 2 of the 2019 [APL Problem Solving Competition](https://www.dyalog.com/student-competition.htm).

The definite integral of a real valued function can be interpreted as the area under its graph over some interval (unless the function is negative or the endpoints are flipped but let's not get into that).

<center>
	<figure>
		<img src="../img/numerical-integration.svg" alt="The same integral (left) approximated using the trapezoid rule (middle) and Simpson's rule (right). Red is overestimate and purple is underestimate."/>
		<figcaption>
			The same integral (left) approximated using the trapezoid rule (middle) and Simpson's rule (right). Red is overestimate and purple is underestimate.
		</figcaption>
	</figure>
</center>

Contrary to what introductory courses in calculus might lead you to believe, symbolic integration is not in general feasible. The function you want to integrate might not have an antiderivative in closed form (expressed in terms of “standard” mathematical functions; and even if it does, it might be too hard to find), or the function itself might not be given in closed form, but rather as the result of some measurement, simulation, or something similar. In such cases, numerical methods must be employed. There are several such methods, three of which we will implement in this problem set as APL user-defined operators.

#### Trapezoid Rule
In the trapezoid rule, the integral of a function $f$ over an interval $[a,b]$ is estimated by dividing $[a,b]$ into $n$ sub-intervals of size $\Delta x=(b-a)/n$, and approximating $f$ by a straight line within each (see the figure above). This means that $f$ only needs to be evaluated in the $n+1$ points ${x_i}=a+i\Delta x$. Putting it all together we get:

${T_n}={{\Delta x}\over{2}}(f(x_0)+2f(x_1)+2f(x_2)+\cdots+2f(x_{n-1})+f(x_n))$

Write an APL operator, `_Trapezoid`, that:

- takes a left operand which is a scalar function.
- takes a positive integer left argument which is the number of subintervals.
- takes a 2-element numeric vector right argument which represents an interval $[a,b]$ where $a<b$.
- returns $T_n$ for the given function and interval.

**Example:**

```APL
      1 ⍟_Trapezoid 1,*1
0.8591409142

      (⍳4) ⍟_Trapezoid ¨ ⊂1,*1
0.8591409142 0.9623362015 0.9829803154 0.9903650088
```

#### Simpson's Rule
Using Simpson's rule the interval is similarly divided but, instead of approximating $f$ by a straight line, the sub-intervals are paired up and $f$ is approximated by a parabola (see the figure above). In general, this reduces the error but leads to the slightly more involved formula:

$S_n = {{\Delta x}\over{3}} (f(x_0)+4f(x_1)+2f(x_2)+4f(x_3)+2f(x_4)+\cdots+4f(x_{n-1})+f(x_n))$

Write an operator, `_Simpson`, that:

- takes a left operand which is a scalar function
- takes an even, positive, integer left argument which is the number of sub-intervals.
- takes a 2-element vector right argument which represents an interval $[a,b]$ where $a<b$.
- returns $S_n$ for the given function and interval.

**Example:**

```APL
      2 ⍟_Simpson 1,*1
0.9967346307

      (2×⍳4) ⍟_Simpson¨ ⊂1,*1
0.9967346307 0.9997079446 0.999936071 0.9999788955
```

#### Romberg's Method
This problem is significantly more difficult than the previous two. If you are not confident to try it straight away, feel free to skip it and come back later.

Romberg's method generalizes the Trapezoid and Simpson's rules. As it turns out, given that $f$ has enough continuous derivatives, by using Taylor's formula, the error of the Trapezoid rule can be expressed in terms of these. Then, using a technique known as Richardson extrapolation one can combine approximations using different numbers of subintervals to cancel out term after term of the error. Glossing over a ton of (really cool!) detail we can define the Romberg method using the following recurrence:

${R^0_n}=T_{2^n}$

${R^m_n}={1\over{4^m-1}}(4^m R^{m-1}_n - R^{m-1}_{n-1})$

Write an operator, `_Romberg`, that:

- takes a left operand which is a scalar function
- takes an integer left argument greater than or equal to $0$ representing $n$.
- takes a 2-element vector right argument which represents an interval $[a,b]$ where $a<b$.
- returns $R^n_n$ for the given function and interval.

Try to find a solution that performs no unnecessary computation. That is, $f$ should be computed at most once in each point, and $R^m_n$ should be computed at most once for each $m$ and $n$.

**Example:**

```APL
      ( ̄1+⍳4)⍟Romberg ̈⊂1,*1 ⍝ Recognize the first two values?
0.8591409142 0.9967346307 0.9999061655 0.9999984001
```

### When in Rome...
This problem is from the 2012 [APL Problem Solving Competition](https://www.dyalog.com/student-competition.htm).

Roman numerals, as used today, are based on seven symbols:

|Symbol|Value|
|---|---|
|**<span style="font-family:Times;">I</span>**|$1$|
|**<span style="font-family:Times;">V</span>**|$5$|
|**<span style="font-family:Times;">X</span>**|$10$|
|**<span style="font-family:Times;">L</span>**|$50$|
|**<span style="font-family:Times;">C</span>**|$100$|
|**<span style="font-family:Times;">D</span>**|$500$|
|**<span style="font-family:Times;">M</span>**|$1000$|

Numbers are formed by combining symbols together and adding the values. For example, **<span style="font-family:Times;">MMVI</span>** is $1000 + 1000 + 5 + 1 = 2006$. Generally, symbols are placed in order of value, starting with the largest values. When smaller values precede larger values, the smaller values are subtracted from the larger values, and the result is added to the total. For example **<span style="font-family:Times;">MCMXLIV</span>** is $1000 + (1000 − 100) + (50 − 10) + (5 − 1) = 1944$. There has never been a universally accepted set of rules for Roman numerals. Because of this lack of standardization, there may be multiple ways of representing the same number in Roman numerals. Despite the lack of standardization, an additional set of rules has been frequently applied for the last few hundred years.

- The symbols **<span style="font-family:Times;">I</span>**, **<span style="font-family:Times;">X</span>**, **<span style="font-family:Times;">C</span>** and **<span style="font-family:Times;">M</span>** can be repeated three times in succession, but no more, unless the third and fourth are separated by a smaller value, as in **XXXIX**. **<span style="font-family:Times;">D</span>**, **<span style="font-family:Times;">L</span>** and **<span style="font-family:Times;">V</span>** can never be repeated.
- **<span style="font-family:Times;">I</span>** can be subtracted from **<span style="font-family:Times;">V</span>** and **<span style="font-family:Times;">X</span>** only. **<span style="font-family:Times;">X</span>** can be subtracted from **<span style="font-family:Times;">L</span>** and **<span style="font-family:Times;">C</span>** only. **<span style="font-family:Times;">C</span>** can be subtracted from **<span style="font-family:Times;">D</span>** and **<span style="font-family:Times;">M</span>** only. **<span style="font-family:Times;">V</span>**, **<span style="font-family:Times;">L</span>** and **<span style="font-family:Times;">D</span>** can never be subtracted.
- Only one small-value symbol may be subtracted from any large-value symbol.
- A number written in Arabic numerals can be broken into digits. For example, 1903 is composed of $1$, $9$, $0$, and $3$. To write the Roman numeral, each of the non-zero digits should be treated separately. In the above example, 1000=**<span style="font-family:Times;">CM</span>** and $3$ is **<span style="font-family:Times;">III</span>**. Therefore, $1903$ is **<span style="font-family:Times;">MCMIII</span>**.

Using this additional set of rules, there is only one possible Roman numeral for any given number. In addition, for this problem, we will add the following rules:

- $0$ (zero) should be represented by an empty character vector
- Negative numbers should be preceded by an APL high minus (`¯`)
- Non-integers should be rounded up (0.5 and above rounds up)
- Larger numbers simply have a number of leading M's. For example, $5005$ is represented as **<span style="font-family:Times;">MMMMMV</span>**

**The `_Roman` Operator**

Write a monadic operator `_Roman` that takes a function left operand and derived a function which is able to do computation on Roman numerals.

```APL
      'III'+_Roman'II'
V

      ⍳_Roman'X'
┌─┬──┬───┬──┬─┬──┬───┬────┬──┬─┐
│I│II│III│IV│V│VI│VII│VIII│IX│X│
└─┴──┴───┴──┴─┴──┴───┴────┴──┴─┘

      +/_Roman⍳_Roman'X'
LV
```

Don't worry about "mixed" types. We don't expect this to work:
```APL
      'II' 'III'⍴_Roman⍳6
```

But the following should:
```APL
      'II' 'III'⍴_Roman⍳_Roman'VI'
┌──┬──┬───┐
│I │II│III│
├──┼──┼───┤
│IV│V │VI │
└──┴──┴───┘
```

Use `]Display` to get the full description of the structure. Single Roman symbols are simple character scalars, whereas compound numbers are enclosed character vectors.

```APL
      ]Display 2 3⍴_Roman⍳_Roman'VI'
┌→────────────────┐
↓      ┌→─┐ ┌→──┐ │
│ I    │II│ │III│ │
│ -    └──┘ └───┘ │
│ ┌→─┐      ┌→─┐  │
│ │IV│ V    │VI│  │
│ └──┘ -    └──┘  │
└∊────────────────┘
```

### Under Over
The **over** operator `⍺⍺⍥⍵⍵` was introduced in Dyalog in version 18.0. It can be thought of as applying the left operand function `⍺⍺` to arguments which have been pre-processed using the right operand function `⍵⍵`.

**Example:**

```APL
      1 3 2 +⍥× 5 0 ¯5                    ⍝ Sum of signs
      'some text'≡⍥⎕C'SOME TEXT'   ⍝ Case-insensitive match
```

The **under** (or *dual*) operator `⍺⍺⍢⍵⍵` has not been implemented in Dyalog. However, it can be partially modelled. It is the same as over `⍥`, except that the inverse of `⍵⍵` is applied to the result.

Write the operator `_U_` to model the behaviour of under.

**Example:**
```APL
      3 +_U_⍟ 5          ⍝ Multiplication is addition under logarithm
15
      3 ×_U_* 5          ⍝ Plus is times under power
8
      'C'+_U_(⎕A∘⍳)'D'   ⍝ 7=3+4
G
```

??? Hint
	Use the *power operator* `F⍣n` to derive an inverse function.

### Key without `⌸`
The **key** operator groups major cells of `⍵` according to keys `⍺`, where `⍺≡⍥≢⍵`. When called monadically, the derived function using key will use `⍵` itself as the keys. Write the operator `_Key` which works like `⌸` but does not use the `⌸` glyph.

**Example:**

```APL
      {⍺,≢⍵}_Key 'mississippi'
```
```
m 1
i 4
s 4
p 2
```
---
```APL
      {⍺(≢⍵)}_Key 5 2⍴1 0 0
```
```
┌───┬─┐
│1 0│2│
├───┼─┤
│0 1│2│
├───┼─┤
│0 0│1│
└───┴─┘
```
---
```APL
      'aabcc'{⊂⍵}_Key 5 2⍴1 0 0
```
```
┌───┬───┬───┐
│1 0│0 0│1 0│
│0 1│   │0 1│
└───┴───┴───┘
```
