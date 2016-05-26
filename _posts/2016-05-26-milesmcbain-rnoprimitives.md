---
layout: post
title: R Has No Primitives
author: milesmcbain
tags:
 - r
---

Some weeks ago Hadley tweeted [this
graphic](https://twitter.com/hadleywickham/status/732288980549390336)
about objects and names in R. Someone asked him to give a situation
where this was important and he said:

> I haven't been able to figure that out. But you'll make terrible
> predictions about performance unless you know

<!---excerpt-break-->

I thought I knew what this meant. I truly did. But it wasn't until I saw
the conversation around [this
tweet](https://twitter.com/nj_tierney/status/735087930251710464) from
@[nj\_tierney](https://twitter.com/nj_tierney) that I can honestly say
the penny finally dropped. And boy did it drop. I'll say this real slow
and clear like for old school coders like me:

**R has no primitive types.**

No seriously. Everything is an object. Integers, floats, and EVEN
boolean values which can be represented by a single bit in memory are
objects. check this out:

    library(pryr)
    abool <- T
    object_size(abool)

    ## 48 B

48 bytes for information that can be represented by a single bit! O.O In
truth this isn't so bad because most langauges pad their bools. But the
point is `abool` is not a bool. It's a SEXP... How cute.

SEXPs are header thingies that describe objects. Further to our
discussion today, they have a `named` attribute that records how many
names an object has been assigned. Hence Hadley's graphic. If you look
at the [beastiary of SEXPs in the R
language](https://cran.r-project.org/doc/manuals/r-release/R-ints.html#SEXPTYPEs)
you will also see there are no non-vector data type objects.

![](http://i.giphy.com/OK27wINdQS5YQ.gif)

I know right?

It gets better. This framework allows R to do some neat tricks with the
assignment operator. I'll quote section 1.1.2 of the R manual at you,
because I think it explains it quite nicely:

    The named field is set and accessed by the SET_NAMED and NAMED macros, and take values 0, 1 and 2. R has a 'call by value' illusion, so an assignment like

    b <- a
    appears to make a copy of a and refer to it as b. However, if neither a nor b are subsequently altered there is no need to copy. What really happens is that a new symbol b is bound to the same value as a and the named field on the value object is set (in this case to 2). When an object is about to be altered, the named field is consulted. A value of 2 means that the object must be duplicated before being changed. (Note that this does not say that it is necessary to duplicate, only that it should be duplicated whether necessary or not.) A value of 0 means that it is known that no other SEXP shares data with this object, and so it may safely be altered. A value of 1 is used for situations like

    dim(a) <- c(7, 2)
    where in principle two copies of a exist for the duration of the computation as (in principle)

    a <- `dim<-`(a, c(7, 2))

**TLDR:** R delays copies due to assignment until it absolutely has to,
and can optimise out 'in principle' copies. There is no call by value.
It was all... an 'illusion'.

![](http://i.giphy.com/qJxFuXXWpkdEI.gif)

A History Lesson
================

Why am I making a big deal out of this? Well for me this was very
surprising. I learned to code in C++, where there was disctinction
between primitive types and objects. Primitive types don't waste any
memory on headers, they are literally just the raw data represented in
memory, and the compiler does the job of to tracking their type. For
example an `int` takes up 4 or 8 bytes of memory (depending on 32, or 64
bit) and it uses all of that memory to represent the numerical value of
that integer.

Let's compare that old world:

    library(Rcpp)
    Rcpp::cppFunction(
    'void primitiveDemo(){
      NumericVector output(2);  
      
      int a = 2;
      int b = a;
      int asize = sizeof(a);
      int bsize = sizeof(b);
      
      Rcpp::Rcout << "address of a: " << &a << ", address of b: " << &b;
      Rcpp::Rcout << ", size of a: " << asize << ", size of b: " << bsize;
      
      return;
    }'
    )

    primitiveDemo()

    ## address of a: 0x7ffc45730ae8, address of b: 0x7ffc45730aec, size of a: 4, size of b: 4

With the new:

    a <- 2
    b <- a
    paste0("address of a: ", address(a), ", address of b: ", address(b))

    ## [1] "address of a: 0x340abf8, address of b: 0x340abf8"

    paste0("size of a: ", object_size(a), ", size of b: ", object_size(b))

    ## [1] "size of a: 48, size of b: 48"

So R is currently using a total of 48 bytes for storage because it did
not actually make a copy. C++ makes the copy and uses a total of 8 bytes

Take Away
=========

If you're tyring to optimise R while thinking like a c++ coder, you may
well be doing more harm than good. I myself have fallen foul of this in
an attempt to modify data frames in place with my `pushr` package. It
ended up just being syntactic sugar, with no observable performance
boost.
