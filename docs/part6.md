# Part 6
Error handling and debugging

## An Honest Mistake

```apl
r←Anagram b;Norm
r←(Norm a)≡(Norm b)
```

Then define the following dfn.

```apl
Norm←{⍵[⍋⍵]~' '}
```

The `Anagram` function has two bugs that prevent it from working correctly. Fix the bugs so that the following expressions work.

```
      'ELEVEN PLUS TWO' Anagram 'TWELVE PLUS ONE'
1
      'ELEVEN PLUS TWO' Anagram 'TEN PLUS THREE'
0
```

## Can We Fix It?
This scripted namespace defines a toy app to read a UTF-8 text file and convert its data to hexadecimal representation.

```APL
:Namespace app

    file←'/tmp/file.txt'

    ∇ Main
      Hex file
    ∇

    ∇ hex←Hex file;bytes;⎕TRAP
      bytes←'UTF-8'∘⎕UCS¨⊃⎕NGET file 1
      hex←↑{,⍉3↑(⎕D,⎕A)[16 16⊤⍵]}¨bytes
    ∇

:EndNamespace
```

The author of the function modifies it to exhibit certain error handling behaviours. Unfortunately, their code has bugs. Investigate the following scenarios and try to solve the issues.

1.  
	
	The author has set up error trapping. They are aware of a potential `FILE NAME ERROR`, but have also set up a global trap in case any unexpected errors occur.
	
    ```apl
	:Namespace app
	
	    file←'/tmp/file.txt'
	
	    ∇ Main;⎕TRAP
	      ⎕TRAP←0 'E' 'Report ⋄ →0'
	      Hex file
	    ∇
	
	    ∇ hex←Hex file;bytes
	      ⎕TRAP←22 'C' '→ERROR'
	      bytes←'UTF-8'∘⎕UCS¨⊃⎕NGET file 1
	      hex←↑{,⍉3↑(⎕D,⎕A)[16 16⊤⍵]}¨bytes
	      →0
	      
	     ERROR:
	      Report
	    ∇
	
	    ∇ Report
	      error←↑⎕DM
	      ⎕←'An error occurred. See app.error for more information.'
	    ∇
	
	:EndNamespace
    ```
	
	Unfortunately, the function suspends with an unexpected `VALUE ERROR`.
	
    ```
	VALUE ERROR: Undefined name: ERROR
	      →ERROR
	       ∧
    ```
	
	After modifying the code, the function should print to the session:
	
    ```
	      app.Main
	An error occurred. See app.error for more information.
    ```
	
	The variable `app.error` should be populated:
	
    ```
	      ⎕←app.error
	FILE NAME ERROR                        
	Hex[2] bytes←'UTF-8'∘⎕UCS¨⊃⎕NGET file 1
	                           ∧           
    ```
	

1.  
	
	Now that the file name error is handled, they want to test the application using a file. Paste the following into a text editor and save it somewhere. Update `app.file` to point to the correct location.
	
    ```
	sample text
    ```
	
	Running `app.Main` reveals either 1 or 2 more bugs:
	
	- Running the function now results in an `INDEX ERROR`.
	- The global trap did not catch the `INDEX ERROR`.
	
	Fix the remaining bugs. The application should successfully convert the file now:
	
    ```
	      app.Main
	73 61 6D 70 6C 65 20 74 65 78 74 
    ```
	

1.  Finally, the author decides it would be more useful if `app.error` contained more information about the error, and also that the `Report` function should display this directly in the session as well.
	
    ```apl
	:Namespace app
	
	    file←'/tmp/file.txt'
	
	    ∇ Main;⎕TRAP
	      ⎕TRAP←0 'E' 'Report {⍵(⍎⍵)}¨⎕NL¯2 ⋄ →0'
	      Hex file
	    ∇
	
	    ∇ hex←Hex file;bytes
	      ⎕TRAP←22 'C' '→ERROR'
	      bytes←'UTF-8'∘⎕UCS¨⊃⎕NGET file 1
	      hex←↑{,⍉3↑(⎕D,⎕A)[16 16⊤⍵]}¨bytes
	      →0
	      
	     ERROR:
	      Report⊂'file' file
	    ∇
	
	    ∇ Report names_values
	      error←⊂↑⎕DM
	      error,←⊂↑names_values
	      ⎕←'An error occurred. Error information in app.error:'
	      ⎕←error
	    ∇
	
	:EndNamespace
    ```

    1. Add the new reporting functionality to your fixed version of the app.
    
    1. **BONUS:** Rewrite the app to use `:Trap` instead of `⎕TRAP`
