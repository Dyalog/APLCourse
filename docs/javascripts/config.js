window.MathJax = {
  tex: {
    inlineMath: [["\\(", "\\)"]],
    displayMath: [["\\[", "\\]"]],
    processEscapes: true,
    processEnvironments: true
  },
  options: {
    ignoreHtmlClass: ".*|",
    processHtmlClass: "arithmatex"
  },
  output: {
    fontPath: '/javascripts/@mathjax/%%FONT%%-font'
  }
};
document$.subscribe(() => {
  MathJax.typesetPromise()
})
