# Data Input/Output
Although we have [`⎕IO`](http://help.dyalog.com/latest/#Language/System Functions/io.htm), "IO" in APL can still refer to input/output.

## Hello, World!
If you have seen any kind of computer programming before, you are probably aware of a famous program called ["Hello, World!"](https://en.wikipedia.org/wiki/%22Hello,_World!%22_program).

Here it is in APL:
```APL
      ⎕←'Hello, World!'
```

If you have learned programming before, maybe it is strange to have gotten so far in an introductory tutorial without meeting the language's "print" function. 

!!! Note
	By default, non-assignment expressions output results to the session log. We strongly recommend using <code class='language-APL'>⎕←</code> when you deliberately intend for an expression to print to the session log. You are then able to search for print statements for easier debugging.

### Back 2 School 4 Maths

The function `Test` will ask the user `n` single-digit arithmetic questions, and return the number of correct answers.

```APL
     ∇ points←Test n;answer;solution          
[1]    points←0                               
[2]    :While n>0                             
[3]        solution←⍎⎕←⍕(?10),('+-×÷'[?4]),?10
[4]        answer←⎕                           
[5]        points+←answer≡solution            
[6]        n-←1                               
[7]    :EndWhile                              
[8]    ⎕←'You scored',points,'points'         
     ∇  
      
      Test 3
```

Examine the `Test` function and try it out. Which line asks for user input?

!!! Note
	The <code class='language-APL'>∇</code> del representation of the <code class='language-APL'>Test</code> function above is the <b>vector representation</b> result of <code class='language-APL'>⎕VR'Test'</code> which can be directly input into the session. Copy the `Test` function above, paste it into the session and press <kbd>Enter</kbd> to define the `Test` function in your workspace.

You will see that it is quite possible to cheat the `Test` function by entering the same expression that it asks. To be even more sly, simply move the text cursor with the up arrow to the printed problem statement and press `Enter`.

To ameliorate this, we can **verify and fix input** with `⎕VFI`. Also note the use of *quote-quad* `⍞`. 

```APL      
     ∇ points←Test2 n;answer;input;solution;valid
[1]    points←0                                  
[2]    :While n>0                                
[3]        solution←⍎⎕←⍕(?10),('+-×÷'[?4]),?10   
[4]        input←⍞                               
[5]        (valid answer)←⎕VFI input             
[6]        answer←valid/answer                   
[7]        points+←answer≡,solution              
[8]        n-←1                                  
[9]    :EndWhile                                 
[10]   ⎕←'You scored',points,'points'            
     ∇  
      
      Test2 3
```

In this case, "fix" means to define as an APL value in the workspace, as if it had been typed into the session.

Verify and Fix Input `⎕VFI` is used when you need to process numeric data from an external source, but it has arrived in a text format. This is very common when working with data from the internet or from files.

You might be tempted to use the **Execute** function `⍎⍵` but this is very dangerous because it will execute any text as APL code.

??? "More about `⎕VFI`"
	`(valid numbers) ← ⎕VFI text`

	The Boolean vector `valid` indicates the locations of elements in `numbers` which were converted from `text`.

	By default, any valid number representation - including engineering exponential notation `XeY` and complex numbers of the form `xJy` - surrounded by spaces is considered valid input. You may provide a list of separator characters as left argument.
	```APL
		⎕VFI'7 4.3 1e3 3j4 5,300 ok'
	┌───────────┬──────────────────┐
	│1 1 1 1 0 0│7 4.3 1000 3J4 0 0│
	└───────────┴──────────────────┘
		' ,'⎕VFI'7 4.3 1e3 3j4 5,300 ok'
	┌─────────────┬──────────────────────┐
	│1 1 1 1 1 1 0│7 4.3 1000 3J4 5 300 0│
	└─────────────┴──────────────────────┘
	```

### Convenient text input
Single quotes `'` in APL character arrays must be escaped by doubling. It can be sometimes easier to paste input by assigning `⍞`:
```APL
      text←⍞
My great string 'which has some quoted text' 
```
---
```APL
      ]Repr text
```
```
'My great string ''which has some quoted text'' '
```

!!! Note
	The user command `]Repr` can generate APL expressions which produce most arrays. In some sense, it is like an inverse to **execute** `⍎`. There is also a utility function `⎕SE.Dyalog.Utils.repObj` which can be used in code, but we do not recommend using it in applications; use the primitives to test the properties of arrays, as explained in [the sections on error handling](../Errors/#who-needs-to-know).

### Convenient text output
Once upon a time, APL was considered an incredible, revolutionary tool for scientists, artists and business people alike to be able to get work done using computers. In a time before spreadsheet software was so ubiquitous, APL terminals offered a way to quickly and easily process data, produce reports and format them for printing.

Take a look at the [Chapter F of Mastering Dyalog APL](https://www.dyalog.com/uploads/documents/MasteringDyalogAPL.pdf#page=295) for how to use the formatting functionality of `⍕` and `⎕FMT`.

1.  
	
	It is easy (but inefficient) to round numbers to a specific precision with **dyadic format** `⍕`:
	
	<pre><code class="language-APL">      ⎕←rand←?5⍴0
	0.2225024074 0.3282243862 0.314984696 0.9533625773 0.757200184
	      ⍎2⍕rand
	0.22 0.33 0.31 0.95 0.76</code></pre>
	
	1. Write a function equivalent to `{⍎⍺⍕⍵}` without using `⍎` or `⍕`.
	1. Why does `{⍎⍺⍕⍵}` fail for large values of `⍺`?

1.  
	
	The following expression formats the current date as **YY/MM/DD**. 
	<pre><code class="language-APL">'I2,2(&lt;/&gt;,ZI2)'⎕FMT 1 3⍴100|3↑⎕TS</code></pre>
	Change the expression to produce **YYYY-MM-DD**.

1.  
	
	In Dyalog version 18.0, `1200⌶` (*twelve hundred eye beam*) can convert date times into human readable formats according to some specification. For example:
	
	<pre><code class="language-APL">      'Dddd Mmmm Doo YYYY'(1200⌶)1⎕dt⊂3↑⎕ts
	┌──────────────────────────┐
	│Wednesday August 12th 2020│
	└──────────────────────────┘</code></pre>
	
	Write a function `DTFMT` to generate a similar output using a 3-element vector like `3↑⎕TS`. That is,
	
	- Full day name
	- Full month name
	- Ordinal day number (1st, 2nd 3rd, 4th etc.)
	- Full year number
	
	<pre><code class="language-APL">      DTFMT 2020 8 12
	┌──────────────────────────┐
	│Wednesday August 12th 2020│
	└──────────────────────────┘</code></pre>

## Native Files
The term "Native Files" refers to any type of file on a hard disk. These can be text or media files, or even executable files. Usually we are interested in various kinds of text files.

### ⎕CSV
Comma separated values are a very common and convenient . While we encourage you to [read the documentation](https://help.dyalog.com/latest/#Language/System Functions/csv.htm) for a full description, here is an overview of features of `⎕CSV`:

- Read data from and write data to files directly  
	```APL
	data ← ⎕CSV '/path/to/file.csv'
	```
- Separate the header (first row) from the rest of the data  
	```APL
	(data header) ← ⎕CSV '/path/to/file.csv' ⍬ ⍬ 1
	```
- Treat specific columns of input as numeric or text, depending on the options provided.  
	The `4` here indicates to convert numeric values if possible, else keep the value as text.
	```APL
    numeric_if_possible ← ⎕CSV '/path/to/file.csv' ⍬ 4
	```
- Use a separator other than commas, using the "Separator" variant option, for example using tabs (`⎕UCS 9`) for Tab Separated Values (.tsv).  
	```APL
	tsv ← ⎕CSV⍠'Separator' (⎕UCS 9)⊢'/path/to/file.csv'
	```
- Read data chunks at a time so as to not fill the workspace, using the "Records" variant option.  
	```APL
	      path ← '/path/to/file.csv'    ⍝ The file path as simple character vector
	      ReadCSV10←⎕CSV⍠'Records' 10   ⍝ A function to read CSV 10 records at a time
	      tn←path ⎕NTIE 0               ⍝ Tie the file - this locks it from use by other applications
	      first10 ← ReadCSV10 tn        ⍝ Read the first 10 records (rows)
	      second10 ← ReadCSV10 tn       ⍝ Read the next 10
	      ≢¨first10 second10
	10 10
	      first10 second10
	┌──────────┬──────────┐
	│┌──┬─────┐│┌──┬─────┐│
	││1 │JQZUK│││11│DECJM││
	│├──┼─────┤│├──┼─────┤│
	││2 │ANPYW│││12│PXPGL││
	│├──┼─────┤│├──┼─────┤│
	││3 │WYVSR│││13│SYSCN││
	│├──┼─────┤│├──┼─────┤│
	││4 │ZOGOX│││14│EKDPS││
	│├──┼─────┤│├──┼─────┤│
	││5 │CXKRS│││15│XCOHA││
	│├──┼─────┤│├──┼─────┤│
	││6 │BFTYO│││16│RDAHR││
	│├──┼─────┤│├──┼─────┤│
	││7 │VFLAS│││17│KPUTW││
	│├──┼─────┤│├──┼─────┤│
	││8 │BAFYD│││18│TPDOD││
	│├──┼─────┤│├──┼─────┤│
	││9 │XPEBP│││19│BGIVA││
	│├──┼─────┤│├──┼─────┤│
	││10│UVBFG│││20│IITSO││
	│└──┴─────┘│└──┴─────┘│
	└──────────┴──────────┘
	      ⎕NUNTIE tn                    ⍝ Don't forget to untie the file after use!
	```

*[CSV]: Comma Separated Values

### ⎕JSON
JSON is not only a convenient way to represent nested data structures, but also a convenient data representation for the modern web since it is natively handled by JavaScript. `⎕JSON` converts between APL arrays, including namespaces and text vector representations of JSON.

```APL
      'ns'⎕NS⍬
      ns.var←1 2 3
      ns.char←'abc'
      ⎕JSON ns
{"char":"abc","var":[1,2,3]}
```

A JSON object in Dyalog uses dot-syntax to access members. Some JSON object keys are invalid APL names, so Dyalog works around this using special characters:
```APL
      (⎕JSON'{"$name": "steve", "3var": "what"}').⎕nl-⍳9
┌─────┬─────────┐
│⍙3var│⍙⍙36⍙name│
└─────┴─────────┘
```

Be aware of incompatible namespaces, although most of the time you will be converting data rather than namespaces.

```APL
      'ns'⎕NS⍬
      ns.fn←{⍵}
      ⎕JSON ns
DOMAIN ERROR: JSON export: item "fn" of the right argument cannot be 
converted (⎕IO=1)
      ⎕JSON ns
      ∧
```

Recall [the expression for an empty JSON object](../Shape Reshape/#the-shape-of-a-scalar).

Using `⎕JSON`, we can also [display error information in a human-readable format](../Errors/#pass-it-on).

*[JSON]: JavaScript Object Notation

### ⎕XML
XML is a format that has fallen out of favour in recent years, but is still useful to be able to import and export it easily when you need to.

*[XML]: Extensible Markup Language

### Text Files
Generally the `⎕N...` family of system functions are for reading and writing *native files* as described in the documentation. `⎕NGET` and `⎕NPUT` are useful for reading and writing text files without having to tie and untie them.

```APL
      (⊂words)⎕NPUT'data/words.txt'                      ⍝ Write words to a unicode text file
      (content encoding newline)←⎕NGET'data/words.txt'   ⍝ Read words from a unicode text file
      words←(⎕UCS newline)((~∊⍨)⊆⊢)content               ⍝ Split words on each new line 
```

### ⎕N...
This is a quick summary. For more details see [the Native Files cheat sheet](https://docs.dyalog.com/latest/CheatSheet%20-%20Native%20Files.pdf) and [system functions and variables A-Z](https://help.dyalog.com/latest/index.htm#Language/System%20Functions/Summary%20Tables/System%20Functions%20and%20Variables%20ColWise.htm) in the online documentation.

In the chapter on selecting from arrays there was [an example of reading a text file](../Selecting-from-arrays/#word-problems) using `⎕NGET`. Before Dyalog version 15.0, reading text files required a couple of extra steps. Some `⎕N...` native file functions are general and can be used to read and write any type of file. As a simple example, here we tie the file **words.txt**, read the data and store it in a variable, and finally untie the file.

!!! Note
	For multi-user systems, take care to set appropriate file access permissions when using `⎕NCREATE`, `⎕NTIE` and `⎕NLOCK`.

```APL
      tn←'assets/words.txt'⎕NTIE 0
      ⎕←10↑words←(⎕UCS 10)(≠⊆⊢)⎕NREAD tn 82(⎕NSIZE tn)0
┌─┬───┬────┬────┬─────┬────┬──────┬────┬──────┬────┐
│A│A's│AA's│AB's│ABM's│AC's│ACTH's│AI's│AIDS's│AM's│
└─┴───┴────┴────┴─────┴────┴──────┴────┴──────┴────┘
      ⎕NUNTIE⎕NNUMS
```

### ⎕MAP
The memory mapping function `⎕MAP` associates a file on disk with an APL array in the workspace. This is useful if you are working with data that cannot fit inside the available workspace memory. One approach might be to read the data in chunks and process one chunk at a time (for example, see the "Records" variant option for `⎕CSV`). Another approach is to use `⎕MAP`.

## Component files
If it is only APL systems that need to store data, the most convenient and efficient way to store that data is in APL **component files**.

Here we will briefly look at the basic usage of component files. A full treatment of component files is provided in [Chapter N of Mastering Dyalog APL](https://www.dyalog.com/uploads/documents/MasteringDyalogAPL.pdf#page=557) and more information can be found in the [component file documentation](http://help.dyalog.com/latest/#Language/APL Component Files/Component Files.htm).

System functions that deal with component files begin `⎕F...`.

### Tie and untie
In Dyalog, component files have the extension **.dcf** (Dyalog Component File) and must be **tied** and **untied**.

A component file may be exclusively tied (`⎕FTIE`) or have a shared tie (`⎕FSTIE`). With an exclusive tie, no other process may access the file.

```APL
      tn←'cfile'⎕FCREATE 0   ⍝ The file is exclusively tied
      ⎕FUNTIE tn             ⍝ The file is untied, it can now be used by other applications and processes
```

The next time we want to use this file, we can use `⎕FTIE` instead of `⎕FCREATE`. The right argument to these functions specifies a tie number (which can be different each time the file is tied), but with a right argument of `0` the next available tie number is used (component file tie numbers start at 1).

```APL
      tn←'cfile'⎕FTIE 0   ⍝ The file on disk is cfile.dcf, but this extension is assumed if not specified 
```

The structure of a component file is analogous to a nested vector of arrays. We add new values by appending them to the end of a file.

```APL
      (3 3⍴⍳9)⎕FAPPEND tn
      (↑'Dave' 'Sam' 'Ellie' 'Saif')⎕FAPPEND tn
      nested←2 2⍴'this' 0 'that' (1 2 3)
      nested ⎕FAPPEND tn
```

Each array stored in a component file (a *component*) is referred to by its index in the file (its *component number*), starting from 1 (not affected by `⎕IO`).

```APL
      ⎕FREAD¨tn,¨1 2 3
┌─────┬─────┬────────────┐
│1 2 3│Dave │┌────┬─────┐│
│4 5 6│Sam  ││this│0    ││
│7 8 9│Ellie│├────┼─────┤│
│     │Saif ││that│1 2 3││
│     │     │└────┴─────┘│
└─────┴─────┴────────────┘
```

A component can be replaced by any other array.
```APL
      'Hello'⎕FREPLACE tn 2
      ⎕FREAD tn 2
Hello
```

Use `⎕FSIZE` to find the range of components and file size:
```
      ⎕FSIZE tn
1 4 1744 1.8446744073709552E19
```

The elements of `⎕FSIZE` are:

- `[1]` The number of the first component
- `[2]` 1 + the number of the last component (that is, where a new component will be if `⎕FAPPEND` is used)
- `[3]` The current size of the file in bytes
- `[4]` The file size limit in bytes

Components can be removed from the beginning or end of a component file, with the `⎕FDROP` function analogous to `⍺↓⍵`.

```APL
      ⎕FDROP tn  1
      ⎕FDROP tn ¯1
      ⎕FREAD¨tn,¨1 2 3
FILE INDEX ERROR: cfile.dcf: No such component
      ⎕FREAD¨tn,¨1 2 3
      ∧
      ⎕FREAD tn 2   ⍝ Only component number 2 remains
Dave 
Sam  
Ellie
Saif 
```

After use, don't forget to untie all tied component files using `⎕FUNTIE ⎕FNUMS`.

### Multi-user access
If you are working on a system through which multiple users need to access the same component files, it is important to become familiar with multi-user access techniques and potential pitfalls. In particular, you will need to use `⎕FSTIE`, `⎕FHOLD`, `⎕FSTACK` and probably `⎕AN`.

- [Chapter N of Mastering Dyalog APL](https://www.dyalog.com/uploads/documents/MasteringDyalogAPL.pdf#page=557)
- [Online documentation: Controlling multi-user access](https://help.dyalog.com/latest/index.htm#Language/APL%20Component%20Files/Programming%20Techniques.htm)

Multi-user access can mean manual access by actual human users, or automated access by separate computers or processes.

## Downloading data from the internet
The **HttpCommand** class is built on top of the [**Conga**](https://docs.dyalog.com/latest/Conga%20User%20Guide.pdf) framework for TCP/IP communications. At the most basic level, it can be used to perform HTTP requests to retrieve data from servers. 

```APL
      ]Get HttpCommand
#.HttpCommand
      ⍴(#.HttpCommand.Get 'https://google.com').Data
14107
```

Using `HttpCommand` with [`⎕FIX`](../Code/#fix) is a way to download APL code from the internet.

For more information, see [the online documentation for HttpCommand](https://dyalog.github.io/HttpCommand). Alternatively, there is documentation within the comments of the code for the HttpCommand class; simply use `)ed HttpCommand` or press <kbd>Shift+Enter</kbd> with the text cursor on the name in the session.

## Problem set 13

### Indian Summer

[IndiaRainfall.csv](./assets/IndiaRainfall.csv) is a file of [comma separated values](https://simple.wikipedia.org/wiki/Comma-separated_values). It is adapted from [IndiaRainfallSource.csv](./assets/IndiaRainfallSource.csv) to remove incomplete records.

The [India Meteorological Department(IMD)](http://www.imd.gov.in/) has shared this dataset under [Govt. Open Data License - India](https://data.gov.in/government-open-data-license-india). It can be downloaded from the links above or from [the Kaggle data science website](https://www.kaggle.com/rajanand/rainfall-in-india).

The data contains the total measured monthly rain fall in millimeters for `30` regions in India from the years `1915` to `2015` inclusive.

1. Load the data into the workspace

    By default, `⎕CSV` will load all fields as text data:

    <pre><code class="language-APL">      ⎕←3↑1 2↓⎕CSV'assets/IndiaRainfall.csv'</code></pre>

    With the following parameters, `⎕CSV` will try to interpret all fields as numeric, and fall back to text if that fails. It will also import the first line as a separate array:

    <pre><code class="language-APL">      (raindata header)←⎕CSV'assets/IndiaRainfall.csv' ⍬ 4 1
	      ⎕←3↑0 2↓raindata</code></pre>

	!!! Hint "Bonus"
		Try reading **IndiaRainfallSource.csv** and removing the missing records for yourself. When data sets contain a very small amount of missing data, sometimes it is appropriate to estimate those values in a process called [imputation](https://en.wikipedia.org/wiki/Imputation_%28statistics%29). Most of the time, it is best to just remove the sections containing missing records.

1. What was the total rainfall in Punjab in 1995?
1. Which month in which region had the highest rainfall?
1. Use a least squares linear fit to estimate the total rainfall in all 30 regions in 2018
1. Use a least squares linear fit to estimate the total rainfall in Punjab in 2018

	??? Hint
		No one would expect you to derive an expression for the least squares linear fit with little APL experience. If you have done it, kudos to you. The expression `Mv(⊢⌹1,∘⍪⊣)Nv` from [APLcart](https://aplcart.info/?q=linear%20regression#) will compute coefficients of a least squares linear fit given a vector of X values `Mv` and a vector of Y values `Nv`.

1. Inspect the data in **IndiaRainfallSource.csv** to see how close the true values were to your estimates. Were they within your standard error?

	??? Hint
		If the error `e` is a vector of the differences between Y values predicted by the linear fit and the actual Y values
		
		$$e_i=Y_i^{\text{predicted}}-Y_i^{\text{actual}}$$
		
		then an estimate for the variance is given by
		
		$$s^2=\sum_{i=1}^n{{e_i^2}\over{n-2}}$$
		
		where the standard deviation (standard error) is $s$.

### MarkDown Sort
Write a program which reads in a markdown file, rearranges the sections by the alphabetical order of their headers, and writes the sorted file to a new file. For extra credit, include a method by which the user can decide whether to overwrite the existing file or provide the name or path to a new file. For example files, feel free to use any of [the source files for these course materials](https://github.com/Dyalog/APLCourse/tree/master/docs).

---

**Fun facts**  
If you are not very familiar with the workings of modern software, you might be surprised to see how accessible file types are. Many text editors might try to open a wide range of files by interpreting their data as text. In the audio editing program [Audacity](https://www.audacityteam.org/), native files can be inspected and manipulated as [audio waveforms](https://en.wikipedia.org/wiki/Waveform). These are a couple of techniques used in an art style called [databending](https://en.wikipedia.org/wiki/Databending).
