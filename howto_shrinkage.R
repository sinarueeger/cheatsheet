#####################################################################################
## Author: Sina Rueeger [sina *.* rueger *a*t* unil *.* ch]
## Project: 
##        
## Time-stamp: <[howto_shrinkage.R] by SR Sat 08/02/2014 14:44 (CET)>
##
## Description:
## 
##
## History:
## 
#####################################################################################


library(lars) ## only needed for dataset

data(diabetes)
#dat <- data.frame(cbind(y = diabetes$y, diabetes$x))#, diabetes$x2)
dat <- data.frame(cbind(diabetes$x))
head(dat)
class(dat)
n <- nrow(dat)

## --- introduce NAs --------------------------
set.seed(4)
is.na(dat[,3]) <- sample(1:n, 100) 
is.na(dat[,5]) <- sample(1:n, 20)  
is.na(dat[,10]) <- sample(1:n, 400)  
is.na(dat[,8]) <- sample(1:n, 200)  

## --- classic --------------------------------

C <- cor(dat, use = "pairwise.complete")
C.inv <- solve(C)
C.inv[1:3, 1:3]


## --- shrinkage --------------------------------
x <- apply(dat, 2, scale)


i <- 1
j <- 2

var.r <- function(i, j)
{
    w.kij <- x[,i] * x[,j]
    w.mean <- mean(w.kij)
    s <- sum((w.kij - w.mean)^2)
    out <- n/(n-1)^3 * s
    return(out)
}

var.r(1,2)

p <- ncol(x)
var.rij <- matrix(NA, ncol = p, nrow = p)
for (i in 1:(p-1))
{
    for (j in (i+1):p)
    {
        var.rij[i, j] <- var.r(i, j)
        var.rij[j, i] <- var.rij[i, j]
    }
}


## --- calculation ------------------------------

r.ij <- cor(x, use = "pairwise.complete")
sum.lower <- sum( sum(r.ij^2)) - sum(diag(r.ij))
sum.upper <- sum(sum(var.rij, na.rm = TRUE))
lambda <- sum.upper / sum.lower

r.new <- r.ij * min(1, max(c(0, (1-lambda))))
diag(r.new) <- 1

r.new.inv <- solve(r.new)
r.new.inv[1:3, 1:3]
C.inv[1:3, 1:3]
