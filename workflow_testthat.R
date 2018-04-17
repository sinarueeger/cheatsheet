#####################################################################################
## Author: Sina Rueeger [sina *.* rueger *a*t* unil *.* ch]
## Project: 
##        
## Time-stamp: <[example_testthat.R] by SR Mon 06/06/2016 08:53 (CEST)>
##
## Description:
## 
##
## History:
## 
#####################################################################################

library(testthat)
source("/data/sgg/sina/projects/functions_dgm.R")

test_that("Distinct roots", {

    x <- f.fac2num(factor(iris$Species))

    expect_that( x, is_a("numeric") )
    expect_that( length(x), equals(length(iris$Species)))
    expect_that( min(x, na.rm = TRUE) > (-1), is_true())
})


## from: 
## http://www.johndcook.com/blog/2013/06/12/example-of-unit-testing-r-code-with-testthat/

test_that("Polynomial must be quadratic", {

    # Test for ANY error                     
    expect_that( real.roots(0, 2, 3), throws_error() )

    # Test specifically for an error string containing "zero"
    expect_that( real.roots(0, 2, 3), throws_error("zero") )

    # Test specifically for an error string containing "zero" or "Zero" using regular expression
    expect_that( real.roots(0, 2, 3), throws_error("[zZ]ero") )
})

