#####################################################################################
## Author: Sina Rueeger [sina *.* rueger *a*t* unil *.* ch]
## Project: 
##        
## Time-stamp: <[test_filename.R] by SR Fri 17/06/2016 12:01 (CEST)>
##
## Description:
## 
##
## History:
## 
#####################################################################################

rm(list = ls())
args <- commandArgs(trailingOnly = TRUE)
i <- as.numeric(as.character(args[1]))


pdf(paste0("test2_",i,".pdf"))
plot(iris[,1], iris[,1+i], main = i)
dev.off()
