# Errors

## What's in a Name?

Study the following expression. It contains an error guard `::` and the primitive functions *format* `⍕` and *execute* `⍎`. 

```APL      
      )ns Names                                       ⍝ Create a namespace called Names      
      Names.vn←({2 6::0 ⋄ ⍎(⎕UCS ⍵),'←',⍕⍵}¨⍳1E4)~0   ⍝ Valid Naming Character Codes      
```

1. Which two errors are trapped by the error guard? 

1. [`⎕AV`](https://aplwiki.com/wiki/Atomic_vector) is the list of characters which was used before [Unicode]() was introduced.
   How many valid naming characters are in `⎕AV`?

1. When are digits `⎕D` not allowed in names?

1. Why is `9109 9054` printed to the session when the expression is run?

1. Another way to find valid naming characters is to filter `⎕AV` using `⎕NC`.

      `Names.avn←⎕AV/⍨0≤⎕NC⍪⎕AV   ⍝ ⎕AVU Valid Naming Characters`  
      How do `Names.vn` and `Names.avn` differ?

### Error Messages and Error Codes

You will have executed expressions which have resulted in some error messages by now. In fact I am certain of it because some of the previous example expressions have been deliberately written containing errors.

`LENGTH ERROR` `VALUE ERROR` `DOMAIN ERROR` `SYNTAX ERROR`

1. Find the error codes of the four error messages given above.

<details>
  <summary>Hint:</summary>
  <pre class="language-APL">
      1 2+2 3⍴⍳9   ⍝ Write some expression to generate the error
      ⎕←⎕EN        ⍝ Inspect the Error Number of the last error
      ⎕←⎕EM 4      ⍝ Inspect the Error Message for that number    
  </pre>
</details>

### Gotta :Trap 'em all
The keyword `:Trap ErrorNums` allows a function to specify behaviour if an error with a number in the scalar or vector `ErrorNums` occurs. It can be used in conjunction with `:Case N` to execute some code if the error number is `N` and `:Else` for the other errors. All errors are trapped with `:Trap 0`.

For example:

```APL
 :Trap 3 4
    ⍝ Code to execute here
 :Case 3
     ⎕←'Index Error'
 :Else
     ⎕←'Rank Error'
 :EndTrap
```

### Pass it on
The system function `⎕SIGNAL` can be used to generate errors. Errors may be signalled without a guilty expression, or custom error codes and messages may be signalled.

```APL
      ⎕SIGNAL⊂('EN' 666)('Message' 'The Devil''s Error')('Vendor' 'Satan')
```

`⎕DMX` is a namespace containing information about the last occuring error. Recent versions of Dyalog can display its contents in a human-readable JSON format 

```APL
      (⎕JSON⍠'Compact' 0)⎕DMX   
```

### Task: Help I'm Trapped
Here we will write a simple calculator program to divide two vector arguments. 

Your program (a tradfn called `Divide`) should test its input and signal an appropriate error for invalid arguments. 

Example output:

```APL
      1 2 3 Divide ,5
0.2 0.4 0.6
      3 Divide ,4
RANK ERROR: Must have both vector arguments
      3 Divide,4
        ∧
      1 2 Divide 1 2 3 
LENGTH ERROR: Mismatched left and right argument shapes
      1 2 Divide 1 2 3
          ∧
      1 2 Divide 1 0
DOMAIN ERROR: Divide by zero
      1 2 Divide 1 0
          ∧      
```

{% include note.html content="It is best not to rely on error trapping for behaviour, in part because future extensions to the language may introduce valid behaviours in those cases."%}

You might prefer that user-facing functions trap and re-signal errors, whereas utilities intended for use in the session might be left to suspend on error.