#####################################################################################
## Author: Sina Rueeger [sina *.* rueger *a*t* unil *.* ch]
## Project: 
##        
## Time-stamp: <[howto_modelselection.R] by SR Mon 03/02/2014 23:08 (CET)>
##
## Description:
## 
##
## History:
## 
#####################################################################################


## data
## -------
library(lars) ## only needed for dataset

dat <- data.frame(cbind(y = diabetes$y, diabetes$x))#, diabetes$x2)
head(dat)
class(dat)

## lm
## --------

mod <- lm(y ~ ., data = dat)
summary(mod)

## basic approach:
## modelselection using AIC criteria
## ----------------------------------
mod.smaller <- step(mod)
summary(mod.smaller)

## in the MASS library is another AIC function called stepAIC, which does the same as step.
## usually you need to use the parameters "k" (for BIC) and "direction". E.g. if you want to do
## "forward" selection you do the following:

mod0 <- lm(y ~ 1, data = dat) ## only intercept is fitted
mod.smaller <- step(mod0, scope = list(lower = ~1, upper = formula(paste("~", paste(
                                                   names(dat)[-1],collapse = "+")))), direction = "forward")
summary(mod.smaller)

## or you can do "both", where you choose for mod0 something in the middle.

## there are other modelselection methods, like cp mallows (you find that in library(leaps), but it
## only works for linear regression, not e.g. logistic regression).

## if you want to use another criteria for model selection - e.g. p-value - you can use the
## functions "drop1" and "add1". check out the examples in the help.
## however, there is also a pre-written function by harrell: library(rms).

mod <- ols(formula(paste("y~", paste(names(dat)[-1],collapse = "+"))), data = dat)
mod

model.smaller <- fastbw(mod, rule = "p")
