#####################################################################################
## Author: Sina Rueeger [sina *.* rueger *a*t* unil *.* ch]
## Project: 
##        
## Time-stamp: <[test.R] by SR Mon 06/11/2017 11:34 (CET)>
##
## Description:
## 
##
## History:
## 
#####################################################################################

n <- 500e3
p <- 3e3
mat1 <- matrix(sample(0:2, p*n, replace = TRUE), nrow = p)
mat2 <- mat1#matrix(sample(0:2, p*n, replace = TRUE), nrow = p)

tmp1 <- system.time(mat.out1 <- rbind(mat1, mat2))

library(data.table)
dfList <- list(mat1, mat2)
tmp2 <- system.time(mat.out2 <- rbindlist(lapply(dfList, as.data.table)))

tmp3 <- system.time(mat.out3 <- dplyr::rbind_list(mat1, mat2))
