# Importing, Exporting and Distributing Code
We have already learned [the basics of saving and loading workspaces](/Workspaces). Here we address some more specific things like how to use other people's code, how to let other people use your code, and how to distribute your application to end users.

## Installed Libraries
Dyalog installations come with a suite of libraries with pre-written code utilities and examples.

Find which ones are available to you now with `)lib`. 

There is also a [**code libraries reference guide**](http://docs.dyalog.com/17.1/Code%20Libraries%20Reference%20Guide.pdf) in the documentation.

You can copy code into the workspace in several ways:

- Copy the entire library into the current namespace (use pcopy to ensure that existing names are not overwritten):
	
	`)pcopy dfns`

- Copy selected functions into the current namespace:
	<pre><code class="language-APL">)copy dfns cal date days
cal 2↑⎕ts</code></pre>

- Copy the entire library into a specific namespace:
	<pre><code class="language-APL">'dfns'⎕ns⍬
dfns.⎕cy'dfns'</code></pre>

- Copy the selected functions into a specific namespace:
	<pre><code class="language-APL">'dfns'⎕ns⍬
'cal' 'date' 'days'dfns.⎕cy'dfns'</code></pre>

Alongside [APLcart](https://aplcart.info), the [dfns library](https://dfns.dyalog.com) (not to be confused with the dfns construct) contains a large number of useful functions for use cases ranging from number theory, graphs and tree data structures to games and graphics.

## User Commands
Some of these, such as the `]box` one, have been mentioned already. Commands which begin with a right-square-bracket `]` are called <a target="_blank" href="https://docs.dyalog.com/latest/User%20Commands%20User%20Guide.pdf">User Commands</a>. These are only used while interacting with the session, but you can customise them and create your own.

Dyalog webinar: <a target="_blank" href="https://dyalog.tv/Webinar/?v=LWJzRGrOC3k">Creating and Managing your own User Commands</a>

Custom user commands are scripted classes or namespaces containing specific member functions `List`, `Run` and `Help`. They should be saved as plain text **.dyalog**, **.apln** or **.aplc** files and placed in the folder **[HOME]/MyUCMDs** where \[HOME\] is either */home/user* on Unix-like systems or *C:\Users\user\Documents* on Microsoft Windows.

Some particularly useful in-built user commands for getting information about your workspace are mentioned in the section on [workspaces](../Workspaces).

## Creating and sharing your own utilities
The user command system is designed for utilities to help during application development and debugging. It is not intended as a system for programmatic utilities. Due to its terse nature, APL vendors have not really established a full-fledged, public package management system like Python's pip or Node/JavaScript's npm. Usually, the source code is distributed either in code files, workspaces or in text files and copied wholesale into other code bases.

However, you might find or develop utility functions which you use frequently and that you copy into code bases frequently. In this case, you might like to make such utilities easy to access. One option is to define the function as a member of a custom namespace within the session namespace `⎕SE`.

Here is an example of using this technique so that you don't have to write such a long function reference to use `repObj`.

```APL
      'X'⎕SE.⎕NS⍬
      ⎕SE.X.rep←⎕SE.Dyalog.Utils.repObj
```

Once your custom name (function, variable etc.) has been defined within ⎕SE, save the session file. In the Microsoft Windows IDE, go to **Session → Save** to overwrite the default session file. In general, the expression for saving the session file is 

```APL
{2⎕NQ⎕SE'FileWrite'⊣⎕SE⎕WS'File'⍵}
```

which can also be [found on APLcart](https://aplcart.info/?q=save%20session%20configuration#).

Of course, you might instead define `rep` in the root namespace when starting an exploratory coding session, for convenience.

!!! Warning
	Remember that others running your code base might not have comparable environments to that in which which you developed the code. Best practice is to ensure that all necessary code and data is contained locally within your application. 
	
	Your organisation might also have rules relating to the types and locations of custom items that prevent you from using such techniques.

## Code in component files
The **object representation** `⎕OR` of an APL function or operator can be used to store code in component files. These can then be fixed (defined) with `⎕FX` upon loading.

## Source code in text files
Until recently, while it was possible to print source code as text for use in articles and tutorials, generally code was distributed in binary workspaces. The exact format and file extension varies between [APL implementations](https://aplwiki.com/wiki/List_of_language_developers), but for Dyalog these are **.dws** files.

Nowadays, Unicode has enabled the widespread ability to represent characters other than just ASCII. Source code management systems, such as Git and SVN, have encouraged the use of Unicode text files as source code representation.

Dyalog provides mechanisms for importing text source into the active workspace, and vice versa, including the ability to associate text files with names in the workspace such that changing one will affect the other.

### SALT
The **S**imple **A**PL **L**ibrary **T**oolkit allows you to store APL source code as text files with the extension **.dyalog**

```APL
      Foo←{3×⍵}
      ]save Foo /tmp/Foo
\tmp\Foo.dyalog

      ]load /tmp/Foo
Foo
```

If the full file path is not specified, SALT will look in a configurable collection of folders on the file system for Dyalog source files. The source folders can be viewed and configured in **Options → Configure → SALT**.

Read [Chapter R of Mastering Dyalog APL](https://www.dyalog.com/uploads/documents/MasteringDyalogAPL.pdf#%5B%7B%22num%22%3A1305%2C%22gen%22%3A0%7D%2C%7B%22name%22%3A%22XYZ%22%7D%2C175%2C640%2C0%5D) and the
[SALT User Guide](https://docs.dyalog.com/latest/SALT%20User%20Guide.pdf).

### ⎕FX
The `⎕FX` system function can be used to define functions or operators from various forms of source code.

### ⎕FIX
The `⎕FIX` system function can be used to define various APL items (functions, operators, namespaces etc.) from scripts.

If `2⎕FIX` is used and changes are made to the APL name using the Dyalog editor, the system will give you the option to save those changes to the text source file at the same time. 

If changes are made to the text file outside of Dyalog, using a standard text editor, then opening that name for editing within Dyalog will give the option to update the code in the active workspace using the modified external source.

Using [HttpCommand](../Data/#downloading-data-from-the-internet) together with `⎕FIX` is a way to import code from the internet.

### Link
For newer applications, we encourage you to try using the [Link](https://github.com/dyalog/link) system which supercedes [SALT](#salt) and associates namespaces in the active workspace with folders in the file system. Using Link, you do not have to remember to `)SAVE` your workspace, changes in the workspace are automatically reflected on the file system.

## ⎕CMD ⎕SH
These two functions are used to run command prompt commands (Microsoft Windows) and shell commands (Linux/macOS). For example, try `⎕CMD'whoami'`.

!!! Warning
	You should take caution when using `⎕SH`, as a non-zero exit code from the command line can cause a `DOMAIN ERROR` and the system error code to be lost.
	<pre><code class="language-APL">      ⎕←r←⎕SH'exit 3'
	DOMAIN ERROR: Command interpreter returned failure code 3
	      ⎕←r←⎕SH'exit 3'
	          ∧
	      r
	VALUE ERROR: Undefined name: r
	      r
	      ∧</code></pre>
	See the [documentation for ⎕SH](http://help.dyalog.com/latest/#UNIX_IUG/Calling UNIX commands.htm) for more information.

While these are quick-and-easy functions to use for those familar with the command lines on particular operating systems, on some systems they can be slower than the more integrated alternatives. For example, reading a file using `⎕SH` can be significantly slower than using `⎕N...` system functions on some machines.

Checking if a file exists:
```
      ⍎⊃⎕SH'if test -f /tmp/text; then echo 1; else echo 0; fi'
1
      ⎕NEXISTS'/tmp/text'
1
```

Reading a text file:

```
      ⍴↑':'(≠⊆⊢)¨⎕sh'cat /etc/passwd'
44 7
      ⍴↑':'(≠⊆⊢)¨(⎕ucs 10 13)((~∊⍨)⊆⊢)⊃⎕nget'/etc/passwd'
44 7
      ⍴⎕CSV⍠'Separator' ':'⊢'/etc/passwd'
44 7
```

Listing the contents of a directory:
```
      ⍴↑⎕sh'ls -l /tmp'
14 127
      ⍴↑⊃0⎕NINFO⍠1⊢'/tmp/*'
19 85
```

Searching within a file:

```
      ↑':'(≠⊆⊢)¨⎕SH'awk -F'';'' ''$1 ~ /games/ { print $0 }'' /etc/passwd'
┌─────┬─┬─┬──┬─────┬──────────┬─────────────────┐
│games│x│5│60│games│/usr/games│/usr/sbin/nologin│
└─────┴─┴─┴──┴─────┴──────────┴─────────────────┘

      {⍵⌷⍨⊂⍸'games'∘≡¨⍵[;1]}⎕CSV⍠'Separator' ':'⊢'/etc/passwd'
┌─────┬─┬─┬──┬─────┬──────────┬─────────────────┐
│games│x│5│60│games│/usr/games│/usr/sbin/nologin│
└─────┴─┴─┴──┴─────┴──────────┴─────────────────┘
```