---
layout: post
title: Test Post with a little R Code
---

Introduction
============

This document outlines some of the more common uses of R for the visualisation and analysis of time series data at the International Laboratory for Air Quality and Health[^ilaqh]. There are already a great many tutorials online for learning the basics of R, e.g. how to use it as a calculator, how to make vectors, etc. so we're going to jump straight in to working with realistic data.

The code is provided so that you can copy and paste it into R and run it yourself. While all output is provided, it's only there to show you what you *should* be getting, and is not intended as a substitute for actually running the code. Data analysis isn't learned by passively watching someone else do it, so make sure you attempt to run the code.

As this is a work in progress, additional sections will be written progressively. This is not meant to be a replacement for a statistics textbook; good resources include Diggle and Chetwynd's "Statistics and Scientific Method", for a general overview of modern data analysis, MacGillivray, Utts and Heckard's "Mind on Statistics", for a first year statistics course reference, and Dobson and Barnett's "An Introduction to Generalized Linear Models", for a more thorough grounding in statistical theory and the toolkit of the modern scientist.

Any questions, suggestions or requests can be directed to Dr Samuel Clifford[1].

Preparation
===========

Installing R
------------

Download and install the latest version of R[^R] and RStudio[^RStudio] from the internet. The reason we're using RStudio rather than default R is that the default GUI for R dates to the 1990s and the script editor has almost no features.

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

[1] <samuel.clifford@qut.edu.au>
