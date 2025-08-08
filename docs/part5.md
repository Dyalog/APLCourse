# Part 5
Each and Key

## Each
1. Write the function `Backwards` which accepts a nested vector of character vectors as its argument and reverses both the order of elements and the contents of each vector within.
	```APL
	      Backwards 'reverse' 'these' 'words'
	┌─────┬─────┬───────┐
	│sdrow│eseht│esrever│
	└─────┴─────┴───────┘
	```

1. Write the function `SizeSort` which sorts its nested vector argument according to the length of each subvector
    ```APL
          SizeSort 'how' 'will' 'we' 'sort' 'these' 'words?'
    ┌──┬───┬────┬────┬─────┬──────┐
    │we│how│will│sort│these│words?│
    └──┴───┴────┴────┴─────┴──────┘
          SizeSort (1 2)(3 1 4 1 5)5(5 4 3)5
    ┌─┬─┬───┬─────┬─────────┐
    │5│5│1 2│5 4 3│3 1 4 1 5│
    └─┴─┴───┴─────┴─────────┘
    ```

1. Create the variable `nest` which has the following properties:
    ```APL
          ⍴nest
    2 3
          ≡nest
    ¯2
          ⍴¨nest
    ┌─┬┬─┐
    │ ││2│
    ├─┼┼─┤
    │3││6│
    └─┴┴─┘
          ]display ∊nest
    ┌→───────────────────┐
    │I 3 am 1 5 8 amatrix│
    └+───────────────────┘
          ⍴∊nest
    14
    ```

## Visit to the museum
Here are some data and questions about visits to a museum.  

The `section_names` are the names of each of the four sections in the museum.  

<pre><code class="language-APL">section_names ← 'Bugs' 'Art' 'Fossils' 'Sea Life'</code></pre>  

The `visits` table represents 1000 visits to museum sections over a four week period. The four columns represent:  

- The section that was visited as an index into the `section_names`
- The day of the visit in [Dyalog Date Number](http://help.dyalog.com/latest/#Language/System%20Functions/dt.htm) format.
- The arrival time in minutes from midnight. For example, 15:30 is 930 minutes.
- The departure time in minutes from midnight.

<pre><code class="language-APL">⎕RL←42 ⋄ days←43589+?1000⍴28 ⋄ (arr lïv)←539+?2⍴⊂1000⍴510 ⋄ section←?1000⍴4
visits←(⊂⍋days)⌷section,days,(⊂∘⍋⌷⊢)⍤1⍉↑arr lïv</code></pre>

1. How many visitors arrived before 10AM?
1. How many visitors arrived between 11AM and 3PM?
1. What was the most popular section by visit duration?
