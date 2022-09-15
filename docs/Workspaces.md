# Workspace basics
We sure have made a lot of functions so far and we've typed many expressions into our [REPL](https://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop). There seem to be a few variables in our workspace as well. We should save them somewhere for later.

*[REPL]: Read Evaluate Print Loop

## What's a workspace?
If you have been using Dyalog, the **session log** is the page with all of your input and output so far. You can scroll up the session log (with a mouse or using the <kbd>Page Up</kbd> key) and see everything you have done so far.

A **workspace** is a collection of names. We can obtain some lists of names using <a target="_blank" href="http://help.dyalog.com/latest/#Language/System%20Commands/Introduction.htm?Highlight=System%20commands">**system commands**</a>.

```APL
	  )fns    ⍝ Functions
	  )vars   ⍝ Variables (arrays)
```

These commands have the special `)COMMAND` syntax, and are only used when interacting with the session. They return no result and cannot be used programmatically; they cannot be used in a function.

## What's in a workspace?

- `]Map`
	
	See a diagram indicating the types of names in the current namespace.  
	Also use the Workspace Explorer: go to **Tools → Explorer** in the Microsoft Windows IDE or **View → Show Workspace Explorer** in RIDE.

- `]Locate`
	
	Search and replace strings (including function names, literal character vectors and comments) in functions, operators, namespaces and other objects. It does not search inside character array variables.  
	You can also use **Tools → Search** in the Windows IDE.

- `]Peek`
	
	Try an expression as if it was executed in a saved workspace without having to copy the contents of that workspace.

```APL
      ]peek dfns cal 2021 7
      ]peek -?
```

## How big is a workspace?
The data and code in the active workspace is limited to the maximum workspace size, or **MAXWS** (*maks-wuss*). The size of a **.dws workspace file** is usually much smaller than this.

We can get the current value:
```APL
⎕←2⎕NQ'.' 'GetEnvironment' 'MAXWS'
```

The **maximum workspace size** can be set to a different value using the MAXWS [configuration parameter](https://help.dyalog.com/latest/index.htm#UserGuide/Installation%20and%20Configuration/Configuration%20Parameters.htm). If you are using the Microsoft Windows IDE, you can go to **Options → Configure → Workspace** and set the maximum workspace size. In either case, the interpreter must be restarted for the change to take effect.

The MAXWS setting is an adjustable software limitation, although there is also a hardware limitation: the amount of [memory](https://kb.iu.edu/d/ahtx) in the computer.

Finally, you can see how much workspace is available with `⎕WA`.

## System commands
A [table of system commands](https://help.dyalog.com/latest/index.htm#Language/System%20Commands/Introduction.htm) is provided in the online documentation.

The *session* is sometimes used to refer to the interactive mode of operation (also known as *calculator mode* also known as *immediate execution mode*), in contrast to *under program control*, which is when something happens as the result of a line in a program/function. 

For example:

```APL
      myvar ← 2×⍳3   ⍝ Declare a variable in the session
      )erase myvar   ⍝ Use a system command to erase the variable
```

If we try to use a system command inside a function, it won't work.

```APL
                     ⍝ The ]DInput user command lets us write mult-line dfns in the session
      ]dinput        ⍝ Alternatively, press Shift+Enter with the cursor | on a name
      MultiFn←{      ⍝ A multi-line dfn
                     ⍝ These statements are executed "under program control"
        ⎕←5+5
        var ← 2+2    ⍝ This variable only exists when this function is running
        )erase var   ⍝ This won't work
      }
                     ⍝ Now try to execute:
      MultiFn ⍬
10
VALUE ERROR: Undefined name: erase
MultiFn[4] )erase var   ⍝ This won't work
            ∧
```

!!! Note
	Attempting to execute the above `MultiFn` function will cause the tracer to open by default. Simply press <kbd>Esc</kbd> to quit the suspended function and return to the session.

## System Functions
Some [**quad-names**](../Quad names) are [**system variables**](../Quad names/#system-variables), such as `⎕A`, `⎕D` and `⎕AV`. Others are [**system functions**](../Quad names/#system-functions), many of which are similar to system command counterparts.

|System Command|System Function|
|---|---|
|`)SAVE /path/to/WorkspaceFile`|`⎕SAVE'/path/to/WorkspaceFile'`|
|`)LOAD /path/to/WorkspaceFile`|`⎕LOAD'/path/to/WorkspaceFile'`|
|`)ERASE name`|`⎕EX'name'`|

!!! Note
	<code class='language-APL'>⎕SAVE</code> will overwrite any existing workspace file without asking first. Use <code class='language-APL'>)SAVE</code> when saving workspaces.

In contrast to the system commands, which can only be used in the interactive session, system functions can be used in a function (A.K.A. *under program control*).

[**System functions**](../Quad names/#system-functions) are in-built functions with names of the form `⎕FUNCTION` and *do* return a result. Some have shy results which can be used by subsequent functions, or printed to the session output with `⎕←` (*quad-gets*).

```APL
 multifn←{
    ⍝ These statements are executed "under program control"
    ⎕←5+5
    var ← 2+2    ⍝ This variable only exists when this function is running
    ⎕EX 'var'    ⍝ This will work, although it does not do anything useful in this dfn
}
```

The Name List `⎕NL` function lists names according to their [*name class*](http://help.dyalog.com/18.0/#Language/System Functions/nc.htm).

```APL
	  ⎕NL 2    ⍝ List variables as a text matrix
	  ⎕NL 3    ⍝ List functions
	  ⎕NL-⍳9   ⍝ List all names as a nested vector of character vectors
```

### ⎕CLEAR
Prank your friends with the best function ever:
```APL
 BestFunctionEver←{
     _←⎕SAVE'/tmp/','_'@(' '∘=)⍕⎕TS
     ⎕CLEAR
 }
```

### ⎕OFF
An event better function for pranks:
```APL
 BestFunctionEver←{
     _←⎕SAVE'/tmp/','_'@(' '∘=)⍕⎕TS
     ⎕OFF
 }
```

`⎕OFF` can also emit custom exit codes. Standard Dyalog exit codes are:

- 0: Successful exit from `⎕OFF`, `)OFF`, `)CONTINUE` or graphical exit from the GUI
- 1: APL failed to start (for example: lack of memory, bad translate table in Classic)
- 2: APL received a [SIGHUP or SIGTERM](https://www.gnu.org/software/libc/manual/html_node/Termination-Signals.html).
- 3: APL generated a syserror

## Saving and loading
The example below shows how to save and load a workspace.

```APL
      ]cd /tmp
      )save MyFirstWS
      )clear
      )load MyFirstWS
```

## Uses of workspaces

- **Distribution:** For large applications, it will be inconvenient or undesirable to ship large [collections of source files](../Code/#source-code-in-text-files) that are loaded at startup. Workspaces are often used as a mechanism for the distribution of packaged collections of code and data.
- **Crash Analysis:** When an application fails, it is often useful to save the workspace, complete with execution stack, code and data, for subsequent analysis and sometimes resumption of execution.
- **Pausing work:** In many ways, this is similar to crash analysis: sometimes you need to shut down your machine in the middle of things and resume later, but you don't want to be forced to start from scratch because you have created an interesting scenario with data in the workspace. Saving a workspace allows you to do this.

*[SCM]: Source Code Manager

## Activities

1. What is the rank of `⎕NL x` for any scalar or vector `x`?
1. What is the rank of `⎕NL -x` for any scalar or vector `x`?
1. Save Your Work
	1. Use `]cd` to change to a directory on your machine where you would like to save your work
	1. Use `)wsid WSName` to change the name of your active workspace
	1. Use `)save` to save your workspace

!!! Note
	<code class='language-APL'>⎕SAVE</code> will overwrite any existing workspace file without asking first. Use <code class='language-APL'>)SAVE</code> when saving workspaces.
