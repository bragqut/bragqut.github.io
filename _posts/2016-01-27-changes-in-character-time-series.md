---
layout: post
title: Changes in character time series
author: samclifford
tags:
 - r
 - dplyr
 - ggplot2
---

### Description

Sometimes in time series you have a set of states for which you may spend a certain amount of time before switching to another state or returning to a previous one (e.g. whether a student is indoors at school, outdoors at school, commuting, indoors at home, etc.).

A straight up factor to numeric conversion won't work, because we want to assume that returning to a previous value.

``` r
library(ggplot2)
library(dplyr)
```

First we're going to simulate some data that behaves the way we discussed above.

``` r
N <- 10

labels <- letters[sample(x = 1:3, size = N, replace = T)]

n.each <- rpois(n=N, lambda=40)

my.x <- data.frame(label=rep(labels, times=n.each),
                   x = 1:sum(n.each),
                   y = rnorm(n=sum(n.each)))

ggplot(data=my.x, aes(x=x, y=y)) + geom_line(aes(color=label)) + theme(legend.position="bottom")
```

![](detect_files/figure-markdown_github/unnamed-chunk-2-1.png)
 Obviously the grouping by the variable type here not only looks strange in `ggplot2` but we don't have an ID for unique instances of each label.

We will turn the input variable into a numeric vector and then look at where it changes. Loop over the endpoints and sequentially increase a counter index between the endpoints.

``` r
detect_text_changes <- function(x){
  x1 <- as.numeric(factor(x))
  
  diff1 <- diff(x1)
  
  changes <- c(0, which(diff1 != 0), length(x))
  
  values <- rep(NA, length(x))
  
  for (i in 2:length(changes)){
    values[(changes[i-1]+1):(changes[i])] <- i-1
  }
  
  return(values)
}

my.x <- mutate(my.x, label.new = detect_text_changes(label))

ggplot(data=my.x, aes(x=x, y=y)) + geom_line(aes(color=label, group=label.new)) + theme(legend.position="bottom")


ggplot(data=my.x, aes(x=x, y=y)) + geom_line(aes(color=label, group=label.new)) + facet_grid(. ~ label)
```

We can now summarise either by label without distinguising between unique instances or summarise by instance.

``` r
my.x %>% group_by(label) %>% summarise(mean = mean(y)) 

my.x %>% group_by(label.new, label) %>% summarise(mean = mean(y)) %>% arrange(label.new)
```
