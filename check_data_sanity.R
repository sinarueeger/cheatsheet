#####################################################################################
## Author: Sina Rueeger [sina *.* rueger *a*t* unil *.* ch]
## Project: 
##        
## Time-stamp: <[check_data_sanity.R] by SR Wed 23/10/2013 09:12 (CEST)>
##
## Description:  check data sanity
##               in various formats: phenotype data, map, ped files
## 
##
## History:
## 
#####################################################################################

library(RUnit)

check_sanity_data <- function(data, type = c("notDefined", "ped", "map"))
{
    if(type == "notDefined")
        subcheck_sanity_notDefined(data)

    if(type == "ped")
        subcheck_sanity_ped(data)

    if(type == "map")
        subcheck_sanity_map(data)

}

subcheck_sanity_notDefined <- function(data)
{
    ## are there only NAs, numbers and letters? (no . or empty squares)
    check.all <- which(iris %in% c("", ".", " "))
    if(length(check.all) > 0)
        warning("weird missings")
    
    ## has every column only numbers or characters
    col.class <- check.class(data)

        ## numerical data will be numeric
    ## but !numerical data can be a mixture of all
    col.char <- !(col.class %in% c("numeric", "integer"))
    if (any(col.char))
       col.char.bin <- check.char(data[,col.char])

    if (any(!col.char.bin))
        warning("mixed numeric and char in one column")

    
}


subcheck_sanity_map <- function(data)
{
    ## ncol
    if(ncol(data) != 4)
        warning("less than 4 columns")

    ## 4th column
    if(!(class(data[,4]) %in% c("numeric", "integer")))
        warning(paste("position column class is", class(data[,4])))

    ## 1st column, 1:22, X, Y, XY, 23
    ## tbd
}


subcheck_sanity_ped <- function(data)
{
    ## first 6 columns mixture of characters, numbers, -9 and 0s
    ## ????

    ## col 7+: A, C, G, T, 0 (no --!!!)
    nam <- names(table(as.matrix(data[,-c(1:6)], nrow = 1)))
    nam <- gsub("A", "", nam)
    nam <- gsub("C", "", nam)
    nam <- gsub("G", "", nam)
    nam <- gsub("T", "", nam)
    nam <- gsub("0", "", nam)
    nam <- paste(nam, collapse = "")
    if(nchar(nam) > 0)
        warning("ped file genotype values other than A, C, G, T, 0")
}


check.class <- function(data)
    sapply(data, class)


check.char <- function(data)
{
    sapply(data.frame(data), function(vec)
       {
           out <- any(as.character(as.numeric(as.character(vec))) == vec) ## if true, then at least one
           ## element was numeric c("A", "2", "B")
           
           # x <- c("A", "2", "B") ## TRUE
           # x <- c("A", "C", "B") ## NA
           # any(as.character(as.numeric(x)) == x)
           is.na(out)
       })
}


map <- read.table("../data/extra.map", header = FALSE)
ped <-  read.table("../data/extra.ped", sep = " ", header = FALSE)


check_sanity_data(map, type = "map")
check_sanity_data(ped, type = "ped")
