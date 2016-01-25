Introduction
============

The code here is provided so that you can copy and paste it into R and run it yourself. While all output is provided, it's only there to show you what you *should* be getting, and is not intended as a substitute for actually running the code. Data analysis isn't learned by passively watching someone else do it, so make sure you attempt to run the code.

As this is a work in progress, additional sections will be written progressively. Good textbook resources include Diggle and Chetwynd's "Statistics and Scientific Method", for a general overview of modern data analysis, MacGillivray, Utts and Heckard's "Mind on Statistics", for a first year statistics course reference, and Dobson and Barnett's "An Introduction to Generalized Linear Models", for a more thorough grounding in statistical theory and the toolkit of the modern scientist.

Any questions, suggestions or requests can be directed to Dr Samuel Clifford[1].

Preparation
===========

Installing R
------------

Download and install the latest version of R[2] and RStudio[3] from the internet. The reason we're using RStudio rather than default R is that the default GUI for R dates to the 1990s and the script editor has almost no features.

Installing and loading packages within R
----------------------------------------

Once RStudio is installed and open, we will need to install some extra packages that extend the functionality of R.

``` r
install.packages(c("tidyr", "ggplot2", "GGally", "scales", "openair", "lubridate",  "broom", "readr"))
```

``` r
library(tidyr)
library(ggplot2)
library(GGally)
library(scales)
library(openair)
library(lubridate)
library(broom)
library(readr)
```

The above code blocks will install and load the following libraries (and their dependencies):

-   `tidyr`, which provides some extra functionality for dealing with data
-   `ggplot2`, a powerful plotting library that uses a grammar of graphics
-   `GGally`, a library that makes use of the functions in `ggplot2` to provide extra visualisation tools
-   `scales`, a library which allows us to change options for `ggplot2`'s axes
-   `openair`, a collection of useful tools for analysing air quality data
-   `lubridate`, functions to make manipulating time/date information much easier
-   `broom`, a library for turning diagnostic information into data frames
-   `readr`, a library that makes reading and writing data files much easier

If you see any error messages about missing packages, you'll likely need to install them before proceeding with the remainder of the tutorial.

Loading the data
================

The `openair` library contains a dataset called `mydata`, which we will use to demonstrate the use of R. This data was collected from 1 January 1998 to 23 June 2005 at the Marylebone (London) air quality monitoring station.

We'll use the `data` command to tell R to load the dataset.

``` r
data(mydata)
```

While we can look at data as text, it is incredibly boring to do so. Let's use the `ggplot2` library to visualise our data. We had a look at the `date` and `pm10` variables above, so let's plot them

``` r
ggplot(data=mydata, aes(x=date, y=pm10)) + geom_line()
```

<img src="small_files/figure-markdown_github/unnamed-chunk-4-1.png" alt="Time series of PM10 data"  />
<p class="caption">
Time series of PM10 data
</p>

[1] <samuel.clifford@qut.edu.au>

[2] <https://cran.r-project.org/>

[3] <https://www.rstudio.com/products/rstudio/download/>
