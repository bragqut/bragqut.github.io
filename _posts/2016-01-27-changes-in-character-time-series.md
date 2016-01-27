---
layout: post
title: Changes in character time series
author: Sam Clifford
---

### Description
Sometimes in time series you have a set of states for which you may spend a certain amount of time before switching to another state or returning to a previous one (e.g. whether a student is indoors at school, outdoors at school, commuting, indoors at home, etc.).

A straight up factor to numeric conversion won't work, because we want to assume that returning to a previous value.

### Code Snippet
Your code snippet itself:

``` r
detect_text_changes <- function(x){
  x1 <- as.numeric(factor(x)) # coerce to numbers
  
  diff1 <- diff(x1)
  
  changes <- c(0, which(diff1 != 0),length(x))
  
  values <- rep(NA, length(x))
  
  for (i in 2:length(changes)){
    values[(changes[i-1]+1):(changes[i])] <- i-1
  }
  
  return(values)
}

my.x <- rep(c("a", "b", "c", "b"), times=c(10,5,12,20))

detect_text_changes(my.x)

```