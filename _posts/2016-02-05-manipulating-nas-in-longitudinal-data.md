---
layout: post
title: Manipulating NAs in longitudinal data
author: samclifford
tags:
 - r
 - dplyr
 - tidyr
---

This snippet was motivated by a hack that Marcela Cespedes presented to BRAG on 4 February 2016. Sometimes a longitudinal data set, e.g. patient information, doesn't have all subjects observed at all time points. Here's a way of generating an index of patient IDs corresponding to non-missing response values which may be useful for analysis with JAGS.

We'll make use of `tidyr` and `dplyr` to manipulate some simulated data.

<!---excerpt-break-->

``` r
library(tidyr)
library(dplyr)

# simulate some data
n.r <- 30 # how many subjects
n.c <- 4 # how many sequential observations

N <- n.r*n.c

X <- matrix(rnorm(N), nrow = n.r, ncol=n.c)

head(X)
```

    ##             [,1]        [,2]       [,3]        [,4]
    ## [1,] -0.11111305  0.06214172 -0.1669861  0.61818158
    ## [2,] -0.17479358  1.39212638 -1.0141225 -0.07955313
    ## [3,] -0.08041327 -0.02065511  0.1647441 -0.70910392
    ## [4,] -1.06330211  0.39322485 -0.7833457 -0.86897735
    ## [5,]  0.42257947 -0.51270806  2.6705473 -0.03004519
    ## [6,] -0.30504952  0.06193476 -0.7525571 -0.18959407

``` r
# knock out some values as being missing
X[sample(1:N, size = N/4)] <- NA

head(X)
```

    ##             [,1]        [,2]       [,3]        [,4]
    ## [1,]          NA  0.06214172 -0.1669861          NA
    ## [2,] -0.17479358          NA -1.0141225 -0.07955313
    ## [3,] -0.08041327 -0.02065511  0.1647441 -0.70910392
    ## [4,] -1.06330211  0.39322485 -0.7833457          NA
    ## [5,]  0.42257947 -0.51270806  2.6705473 -0.03004519
    ## [6,] -0.30504952  0.06193476 -0.7525571 -0.18959407

Now that we've simulated some missing data, we'll reshape the data from wide to long format, making a new ID column to ensure that we are able to keep track of whose observations these are. We also convert the time information from strings with "X" in them to numbers, sort the remaining data frame by `ID` rather than `time` and filter out all the rows with missing `value` values.

``` r
non_missing_data <- data.frame(X, ID=1:n.r) %>% 
  gather("time", "value", -ID) %>% 
  mutate(time = extract_numeric(time)) %>% 
  arrange(ID) %>% 
  filter(!is.na(value)) 
```

If we now wanted a vector of indices that tells us about the IDs for the non-NA values, we could select the ID column

``` r
select(non_missing_data, ID) %>% head(10)
```

    ##    ID
    ## 1   1
    ## 2   1
    ## 3   2
    ## 4   2
    ## 5   2
    ## 6   3
    ## 7   3
    ## 8   3
    ## 9   3
    ## 10  4

If instead we wanted an object of length `n.r` which tells us how many observations correspond to each patient, rather than *which* observation corresponds to each patient,

``` r
group_by(non_missing_data, ID) %>% 
  summarise(n = n()) %>% 
  select(n) 
```

    ## Source: local data frame [30 x 1]
    ## 
    ##        n
    ##    (int)
    ## 1      2
    ## 2      3
    ## 3      4
    ## 4      3
    ## 5      4
    ## 6      4
    ## 7      1
    ## 8      3
    ## 9      4
    ## 10     3
    ## ..   ...

The first solution is probably conceptually the simplest way to store the data for inclusion in a JAGS model, whereas the second index vector will be shorter and potentially simpler to inspect visually when the number of observations per subject is large.
