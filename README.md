
<!-- README.md is generated from README.Rmd. Please edit that file -->

# An API example in R

This repo shows a simple example of how to create an API using
[plumber](https://www.rplumber.io/) package.

<!-- badges: start -->

<!-- badges: end -->

## Getting started

First of all, it is necessary install plumber package and others
complementary packages, in this way:

``` r
  # package to create an API
  install.packages("plumber")
  
  # complementary packages
  install.packages(c("jsonlite", "dplyr", "tidyselect"))
```

After that, you can just execute the script via bash, just like that:

``` bash
  Rscript R/app.R
```

## Contribute

Just make a
[fork](https://docs.github.com/en/free-pro-team@latest/github/getting-started-with-github/fork-a-repo)
in this repo and send me a [Pull
Request](https://docs.github.com/en/free-pro-team@latest/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request).
