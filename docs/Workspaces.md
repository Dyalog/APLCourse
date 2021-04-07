# Workspace basics
We sure have made a lot of functions so far and we've typed many expressions into our [REPL](https://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop). There seem to be a few variables in our workspace as well. We should save them somewhere for later.

*[REPL]: Read Evaluate Print Loop

### What's a workspace?
If you have been using Dyalog, the *session log* is the page with all of your input and output so far. You can scroll up the session log (with a mouse or using the `Page Up` key) and see everything you have done so far).

A workspace is a collection of names. We can obtain some lists of names using <a target="_blank" href="http://help.dyalog.com/latest/#Language/System%20Commands/Introduction.htm?Highlight=System%20commands">**system commands**</a>.

- Functions

```APL
	  )fns    ⍝ Functions
	  )vars   ⍝ Variables (arrays)	  
```

These commands have the special `)COMMAND` syntax, and are only used when interacting with the session. They return no result and cannot be used programmatically; they cannot be used in a function.

### System functions
The *session* is sometimes used to refer to the interactive mode of operation (AKA *calculator mode* AKA *immediate execution mode*), in contrast to *under program control*, which is when something happens as the result of a line in a program/function. 

For example:

```APL
      myvar ← 2×⍳3   ⍝ Declare a variable in the session
      )erase myvar   ⍝ Use a system command to erase the variable
```

If we try to use a system command inside a function, it won't work.

```APL
      ]dinput        ⍝ The ]DInput user command lets us write mult-line dfns in the session
                     ⍝ Alternatively, press Shift+Enter with the cursor | on a name
      multifn←{
        ⍝ These statements are executed "under program control"
        ⎕←5+5
        var ← 2+2    ⍝ This variable only exists when this function is running
        )erase var   ⍝ This won't work
      }
```

**System functions** are functions of the form `⎕FUNCTION` and *do* return a result. Some have shy results which can be used by subsequent functions, or printed to the session output with `⎕←`.

```APL
 multifn←{
    ⍝ These statements are executed "under program control"
    ⎕←5+5
    var ← 2+2    ⍝ This variable only exists when this function is running
    ⎕EX var      ⍝ This will work
}
```

The Name List `⎕NL` function lists names.

```APL
	  ⎕NL 2    ⍝ List variables as a text matrix
	  ⎕NL 3    ⍝ List functions
	  ⎕NL-⍳9   ⍝ List all names as a nested vector of character vectors
```

### Namespaces
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
Variables are pass-by-value. This means that if one name is used to assign another name, changes to the first name are not reflected in the second name.

```APL
      var1←1 2 3
      var2←var1     ⍝ The value of var1 is assigned to var2
      var1←var1+6   ⍝ The value of var2 is changed
      ⎕←var2          ⍝ var2 retains the previous value
1 2 3
```

Namespaces are objects and are pass-by-reference. All names which are assigned a reference can be used to refer to the original object.

```APL
      )ns ns1
#.ns1
      ns1.name←'Bob'
      ns2←ns1
      ns2.name←'Steve'
      ⎕←ns1.name
Steve
```

### Saving and loading
There is one more type of system-thing to mention, although you have seen the `]box` one before. Commands which begin with a right-square-bracket `]` are called <a target="_blank" href="">User Commands</a>. These are also only used while interacting with the session, but you can customise them and create your own.

Dyalog webinar: <a target="_blank" href="https://dyalog.tv/Webinar/?v=LWJzRGrOC3k">Creating and Managing your own User Commands</a>

The example below shows how to save and load a workspace.

```APL
	  ]cd /tmp
	  )save MyFirstWS
	  )clear
	  )load MyFirstWS
```

!!! Note
	While we recommend using [\]Link](github.com/dyalog/link) to develop and maintain a new APL application due to the benefits of using modern SCM systems, workspaces continue to be a supported mechanism not only for some users to maintain their code base but also for:
	
	* **Distribution:** For large applications, it will be inconvenient or undesirable to ship large collections of source files that are loaded at startup. The use of workspaces as a mechanism for the distribution of packaged collections of code and data is expected to continue.
	* **Crash Analysis:** When an application fails, it is often useful to save the workspace, complete with execution stack, code and data, for subsequent analysis and sometimes resumption of execution. Dyalog will continue to support this, although we may gradually impose some restrictions, for example requiring the same version and variant of the interpreter in order to resume execution of a saved workspace.
	* **Pausing work:** In many ways, this is similar to crash analysis: sometimes you need to shut down your machine in the middle of things and resume later, but you don't want to be forced to start from scratch because you have created an interesting scenario with data in the workspace. Saving a workspace allows you to do this.

	With the exception of the scenarios mentioned above, Link is intended to make it unnecessary to save workspaces. All source code changes that you make while editing or tracing your code should immediately end up in text files and be managed using an SCM. The normal workflow is to start each APL session by loading the code into the workspace from source directories. You might want to save a "stub" workspace that contains a very small amount of code that loads everything else from text source, but from version 18.0 of Dyalog APL you can now [easily set that up using text files as well](/GettingStarted/Setup.md), rendering workspaces obsolete as part of your normal development workflow.

*[SCM]: Source Code Manager

## Tasks

1. In terms of array rank, what type of array is a namespace?
1. What is the rank of `⎕NL x` for any scalar or vector `x`?
1. What is the rank of `⎕NL -x` for any scalar or vector `x`?
1. Save Your Work
	1. Use `]cd` to change to a directory on your machine where you would like to save your work
	1. Use `)wsid WSName` to change the name of your active workspace
	1. Use `)save` to save your workspace
	1. Use `)clear` to clear your workspace
	1. Create a new namespace called 'Day1'
	1. Use `Day1.⎕CY'WSName'` to copy the contents of your saved workspace into the `Day1` namespace
	1. Now `)save` again

!!! Note
	<code class='language-APL'>⎕SAVE</code> will overwrite any existing workspace file without asking first. Use <code class='language-APL'>)SAVE</code> when saving workspaces.
