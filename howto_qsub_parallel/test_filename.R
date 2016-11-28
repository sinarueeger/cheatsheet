#####################################################################################
## Author: Sina Rueeger [sina *.* rueger *a*t* unil *.* ch]
## Project: 
##        
## Time-stamp: <[test_filename.R] by SR Fri 17/06/2016 12:15 (CEST)>
##
## Description:
## 
##
## History:
## 
#####################################################################################

library(parallel)

mclapply(1:4, function(i)
         {
             cat(i, "\n")  
             pdf(paste0("test3_",i,".pdf"))
             plot(iris[,1], iris[, 1+i], main = i)
             dev.off()
         })
