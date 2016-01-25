---
layout: post
title: Small intro
---


### Description
Creates a rainbow coloured scatterplot with existing R functions that do the same (i.e. an entirely pointless example function).

### Code Snippet
Your code snippet itself:
```r
PL.f <- function(x = rnorm(200), y = rnorm(200)) {
  # Creates scatter plot of two vectors colouring points by element order 
  if (!(length(x) == length(y))) {
    stop('please supply numeric vectors of the same length to arguments x and y')
    }
  col.v = rainbow(length(x))
  plot(x, y, col = col.v)
}
```

If you indent with spaces alone what you see is what you should get on the webpage.
Maybe we should recommend a style guide for code snippets e.g. [Google's R Style Guide](https://google.github.io/styleguide/Rguide.xml)

### Images

How should we do these - it's bad practise to have files that can't be merged in a Git repository I believe so we should host the images somewhere else?
tierneyn suggests: 
The images problem could be sovled by adding a folder called “assets”, and then we link to that folder using liquid syntax:
something like `{{site.url}}/assets/imagename.jpg`

