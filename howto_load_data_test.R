
#####################################################################################
## Author: Sina Rueeger [sina *.* rueger *a*t* unil *.* ch]
## Project: 
##        
## Time-stamp: <[load_data_test.R] by SR Sat 26/12/2015 14:01 (CET)>
##
## Description:
## 
## exome
## History:
## 
#####################################################################################
library(microbenchmark)

## readr
## ================================
library(readr)
## read_csv
## read_tsv
## read_table

#install.packages("readxls")
## read_excel

path.raw <- "/data/sgg/sina/public.data/meta.summaries/meta.giant/"

## --------------
#system.time(tmp <- read.table(paste0(path.raw,
#                           "GIANT_HEIGHT_Wood_et_al_2014_publicrelease_HapMapCeuFre#q.txt"),
#                         header = TRUE))
##  user  system elapsed 
## 47.350   0.233  47.568

microbenchmark(tmp <- read_table(paste0(path.raw,
                           "GIANT_HEIGHT_Wood_et_al_2014_publicrelease_HapMapCeuFreq.txt"),
                         col_names = TRUE), times = 5)

##      min       lq    mean   median       uq      max neval
## 5.824673 6.093751 6.31858 6.432333 6.571697 6.670448     5

## data.table
## ================================
library(data.table)
microbenchmark(tmp2 <- fread(paste0(path.raw,
                                    "GIANT_HEIGHT_Wood_et_al_2014_publicrelease_HapMapCeuFreq.txt")),times
               = 5)

##      min       lq    mean   median       uq      max neval
## 3.764824 3.879175 4.81077 3.905818 3.977701 8.526334     5
