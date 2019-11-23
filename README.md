Go: Easy set up for R courses from ITS <a href='https://itsleeds.github.io/'><img src='logo.png' align="right" height=220/></a>
================

This Repo contains code that helps set up your computer and R session
for ITS Courses or to use ITS developed R packages.

## What is Go?

When using R you often need to have installed the correct version, have
the correct packages and dependencies, and access to the correct data
and API keys. This can be difficult to convey to beginners or require
intimidating long lists of prerequisites. So we have condensed the whole
process down into a single one-line command that is easy to use.

For example, to set up your computer for the PCT Advanced Training
Course simply:

  - Open R Studio
  - Type or Copy the following command into the console

<!-- end list -->

``` r
   source("https://git.io/fj9eC")
```

  - Press Enter

This simple command will check your computer, install all the necessary
packages and tell you if your computer is ready to be used for the
course.

## More Information

Some extra help with ITS R courses:

  - [Installing R and R
    Studio](https://github.com/ITSLeeds/go/blob/master/docs/install.md)
    A short guide to installing R and R Studio.
  - [Introduction to R]()
  - [Geocomputation with R](https://geocompr.robinlovelace.net/) A free
    book on how to do GIS in R.

## How does it work?

Go relies on two functions `source` which simply says run this code, and
`setup_function` which does all the hard work. In the example above a
URL shortner has been used to shorten
`https://raw.githubusercontent.com/ITSLeeds/go/master/pct.R` into
`https://git.io/fj9eC`. This script then runs the `setup_function` which
will install and update any packages requested as well as doing some
basic system checks.

Go is a work in progress and we will add checks over time to make it
more useful and to catch new types of set up problems as we encounter
them. Please leave your feedback
[here](https://github.com/ITSLeeds/go/issues).

## Is it safe?

You might be worried about running some unknown code from the internet
on your computer. All the code in Go is open souce and in this repo. If
you want to be extra safe simply download the `setup_function` from
[here](https://github.com/ITSLeeds/go/blob/master/code/setup_function.R)
and run though it yourself.
