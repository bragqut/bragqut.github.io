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

n.r <- 30 # how many subjects
n.c <- 4 # how many sequential observations

N <- n.r*n.c

X <- matrix(rnorm(N), nrow = n.r, ncol=n.c)

head(X)
```

    ##             [,1]       [,2]       [,3]       [,4]
    ## [1,] -0.53875996 -3.0091503 -0.4308401  0.5664380
    ## [2,] -0.48297471 -0.7620471  0.5479946  0.9791881
    ## [3,]  0.74274548 -0.1197123  0.4201759  0.2228831
    ## [4,] -0.70594150 -0.6380808 -0.7879914 -1.4294160
    ## [5,] -1.07686357  0.3279826 -0.9131584 -1.7212478
    ## [6,] -0.03247079  0.1207207  0.6485075 -0.3668982

	
Now we simulate missingness at random
``` r
X[sample(1:N, size = N/4)] <- NA

head(X)
```

    ##             [,1]       [,2]       [,3]       [,4]
    ## [1,] -0.53875996 -3.0091503         NA  0.5664380
    ## [2,] -0.48297471 -0.7620471         NA  0.9791881
    ## [3,]  0.74274548 -0.1197123  0.4201759  0.2228831
    ## [4,] -0.70594150 -0.6380808 -0.7879914         NA
    ## [5,] -1.07686357  0.3279826         NA -1.7212478
    ## [6,] -0.03247079  0.1207207  0.6485075 -0.3668982

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
    ## 3   1
    ## 4   2
    ## 5   2
    ## 6   2
    ## 7   3
    ## 8   3
    ## 9   3
    ## 10  3

If instead we wanted an object of length `n.r` which tells us how many observations correspond to each patient, rather than *which* observation corresponds to each patient,

``` r
patient_counts <- group_by(non_missing_data, ID) %>% 
  summarise(n = n()) 

patient_counts %>%  select(n) 
```

    ## Source: local data frame [30 x 1]
    ## 
    ##        n
    ##    (int)
    ## 1      3
    ## 2      3
    ## 3      4
    ## 4      3
    ## 5      3
    ## 6      4
    ## 7      2
    ## 8      3
    ## 9      4
    ## 10     4
    ## ..   ...

We can then convert this into a data frame with start and endpoints

``` r
patient_counts %>%
  mutate(end = cumsum(n),
         start = 1 + c(0, end[2:length(ID) - 1])) %>%
  select(ID:n, start, end)
```

    ## Source: local data frame [30 x 4]
    ## 
    ##       ID     n start   end
    ##    (int) (int) (dbl) (int)
    ## 1      1     3     1     3
    ## 2      2     3     4     6
    ## 3      3     4     7    10
    ## 4      4     3    11    13
    ## 5      5     3    14    16
    ## 6      6     4    17    20
    ## 7      7     2    21    22
    ## 8      8     3    23    25
    ## 9      9     4    26    29
    ## 10    10     4    30    33
    ## ..   ...   ...   ...   ...

The first solution is probably conceptually the simplest way to store the data for inclusion in a JAGS model, whereas the second index vector will be shorter and potentially simpler to inspect visually when the number of observations per subject is large. The third solution builds on this and gives a column, `start`, which can be used as left endpoints of index ranges, and the same for the `end` column as the right endpoints.