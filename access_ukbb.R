#####################################################################################
## Author: Sina Rueeger [sina *.* rueger *a*t* unil *.* ch]
## Project: 
##        
## Time-stamp: <[access_ukbb.R] by SR Fri 26/02/2016 13:29 (CET)>
##
## Description:
## 
##
## History:
## 
#####################################################################################

#path <- "/home/zkutalik/data/UKBB/plink/"
## >> original data

## bfiles of chr 22 here

data.dir <- "/data/sgg/sina/public.data/data.ukbb.tmp/"
library(snpStats)
gwas.fn <- lapply(c(bed='bed',bim='bim',fam='fam'), function(suffix) paste0(data.dir, "c22.", suffix))
geno <- read.plink(gwas.fn$bed, gwas.fn$bim, gwas.fn$fam, na.strings = ("-9"),
                   select.snps = 1:10)

#Subjects are selected by their numeric order in the PLINK files, while SNPs are selected either by order or by name.
#http://finzi.psych.upenn.edu/library/snpStats/html/read.plink.html


## data.table >> takes too long
## ================================
#library(data.table)
#map <- fread(paste0(path,  "c22.map"))
#ped <- fread(paste0(path,  "c22.ped"))


# library(GenABEL)
# convert.snp.ped(ped="pedin.18",mapfile="map.18",out="genos.raw")
