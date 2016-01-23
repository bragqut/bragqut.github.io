---
layout: post
title: Test Post with a little R Code
---


<div class="message">
  So we can put an introductory message here introducing our code snippet e.g. what it's for if it requires a certain package.
</div>

### Dependencies
i.e. any `library( )` calls you need to make

### Code Snippet
```r
PL.f <- function(x = rnorm(50), y = rnorm(50)) {
  # Creates scatter plot of two vectors colouring points by element order 
  if (!(length(x) == length(y))) {
    stop('please supply numeric vectors of the same length to arguments x and y')
    }
  col.v = rainbow(length(x))
  plot(x, y, col = col.v)
}
```

Forcing the issue of indenting only with spaces seems to do the trick.
Though this isn't a pretty function layout, I was just messing around to try and see if I could get what I see in my IDE reflected exactly on the webpage.
Maybe we should recommend a style guide for code snippets e.g. [Google's R Style Guide](https://google.github.io/styleguide/Rguide.xml)

### Images

How should we do these - it's bad practise to have files that can't be merged in a Git repository I believe so we should host the images somewhere else?