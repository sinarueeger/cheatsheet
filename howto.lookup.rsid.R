#####################################################################################
## Author: Sina Rueeger [sina *.* rueger *a*t* unil *.* ch]
## Project: 
##        
## Time-stamp: <[lookup.vcf.R] by SR Fri 30/09/2016 15:22 (CEST)>
##
## Description:
## 
##
## History:
## 
#####################################################################################
rs11807062


## for fastVCF
## -----------------
library(fastVCF)
datafile.location='/data/sgg/aaron/shared/fastVCF/1KG'

    
## get reference panel
## -----------------    
hit.chr <- unique(1)

data.1kg <- tryCatch({
    get.1kg.full(CHR = unique(hit.chr), SNPS=snp, datafile.location = datafile.location)
}, error=function(err) {
        cat("err:", conditionMessage(err), "\n")})


sm <- data.1kg$sm
G <- data.1kg$G
