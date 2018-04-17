#####################################################################################
## Author: Sina Rueeger [sina *.* rueger *a*t* unil *.* ch]
## Project: 
##        
## Time-stamp: <[annotation_snps.R] by SR Mon 14/03/2016 13:38 (CET)>
##
## Description:
## 
##
## History:
## 
#####################################################################################



## 1) R package NCBI2R. It has been removed from CRAN due to a small error, but can still be installed. 
install.packages("devtools")
devtools::install_version("NCBI2R",version="1.4.7")

library(NCBI2R)
snps <- c("rs1137101")
GetSNPInfo(snps)

## 2) R package rsnps (but only 1KG pilot phase data is available)
library(rsnps)
NCBI_snp_query("rs420358")

## 3) with the last option you can access hg19 UCSC database.

source("http://bioconductor.org/biocLite.R")
biocLite("FDb.UCSC.snp137common.hg19")

snp137 <- features(FDb.UCSC.snp137common.hg19)
snp137["rs420358"]
