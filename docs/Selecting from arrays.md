# Selecting from Arrays
In an array-oriented language, maybe it's no surprise that there are umpteen ways to select values from arrays.

## Indexed Assignment
Assign values at specified indices.

```APL
      t←4 4⍴'some sample text'
      t[⍸t∊'aeiou']←'!'
```

### Selective Assignment
Define `n←5 5⍴⍳25` in your workspace.

1. Find at least four different ways to set the bottom-right 3 by 3 submatrix in `n` to `0`.
    For example, `(2 2↓n)←0`.

    {% include hint.html id="selectassign" content="See which primitives may be used in a <a href='http://help.dyalog.com/18.0/#Language/Primitive%20Functions/Assignment%20Selective.htm?Highlight=selective%20assignment'>selective assignment</a>" %}

### Modified Assignment
Experiment with the following expressions, paying particular attention to the `name f← array` construct.

```APL
      salaries←18250 42500 56000 57250 48640
      codes←'ACDDC'
      salaries×←1.1
      salaries[⍸codes='C']×←1.05

      a←⎕A
      (3↑a),←'abcd'
```

### At
Monadic functions take a single right argument array as input. Dyadic functions take two argument arrays.

Monadic operators take a single left operand which can be a function or an array (as in `+/` where plus `+` is the function operand and reduce `/` is the operator). 

Dyadic operators take two operands which could be functions or arrays depending on the operator's definition.

Selective and indexed assignment methods will change the values of variables. The "at" operator `@` merges two arrays at specified indices and returns a new array.

If a function right operand returns a boolean array when applied to `⍵` (e.g. `3=1 3 5`) then ones `1` in the boolean array determine where scalars of `⍺` are inserted.

```APL
      ('∆⍥'@{⍵∊'AEIOU'})2 3⍴'DYALOG'
      ('∆⍥'@1)2 3⍴'DYALOG'
      (' '@2 3 4)'DYALOG'
      (' '@(1 2)(1 3)(2 1))2 3⍴'DYALOG'
```

Generally, the left operand to `@` is a function applied to scalars in `⍵` specified by a right operand array of indices; or a boolean array returned by a right operand function. 

```APL
      {1↓(1∘⎕C@{¯1⌽' '=⍵})' ',⍵}'my excellent heading'
```

### Strand Assignment
[*Distributed assignment*]() or *strand assignment* allows multiple names to be defined using a single assignment arrow `←`.

```APL
      (max min avg)←{(⌈⌿⍵)(⌊⌿⍵)((+⌿÷≢)⍵)}3 1 4 1 5
```

{% include note.html content="Strand assignment does not require names to be parenthesised, but we strongly recommend it for clarity." %}

We can assign items in `nest` to the three variables `s←'A'` `v←1 2 3` and `m←3 3⍴⍳9` using a single assignment arrow.


```APL
      nest←('A'(1 2 3))(3 3⍴⍳9)
      ((s v) m)←nest
```
