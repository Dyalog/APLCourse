# CONTRIBUTING
This course is written as markdown files which are rendered using MkDocs. If you would like to directly contributed, please [use the Fork and Pull Request workflow](https://gist.github.com/Chaser324/ce0505fbed06b947d962).

## Copy input
Code blocks are mostly styled to look like the Dyalog session, with six-space prompt input and flush-left output. We use custom css so that consecutive code blocks are visually merged, but only the input has a copy button.

> Unfortunately, we haven't found a way to make this work in code blocks nested inside lists.

To have an input (six-space prompt) which can be copied without the output, write them as separate code blocks:  
```APL
      +/⍳10
```
```
55
```

The `APL` qualifier means that blocks render with the class `language-APL` which can be used for syntax highlighting.

To have multiple input-output blocks visually merged to the same input block, separate them with a horizontal rule:  
```APL
      ]box on -trains=tree
```
```
Was OFF -trains=box
```
---
```APL
      +⌿÷≢
```
```
  ┌─┼─┐
  ⌿ ÷ ≢
┌─┘    
```