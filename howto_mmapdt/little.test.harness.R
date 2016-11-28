# Author: Aaron McDaid   aaron.mcdaid@gmail.com
# Date:   July 20th 2016
# This code is for private, non-commmercial, experimentatal use only. If people are interested,
# I would like to make a future version of this project available under a suitable open source license.
# In this meantime, please contact me if you find this useful. Perhaps we can work together on a
# joint public release.



# I'm assuming that 'mmapdt.lib.R' is in the same directory.to.save.to as this script (which is being run under Rscript)
# The first step therefore is to find that directory and source 'mmapdt.lib.R'

library(data.table) # A really nice package, that extends data.frames. There is a really excellent intro
                    #   tutorial here: https://www.datacamp.com/courses/data-analysis-the-data-table-way

getScriptLocation <- function() {
    arg = commandArgs()
    arg[1] -> filearg#substr(arg,1,7) == "--file="][1] -> filearg
    substring(filearg,8) -> filearg
    filearg
}

paste0(dirname(getScriptLocation()) ,'/mmapdt.lib.R') -> mmap.dt.lib.R
source("mmapdt.lib.R")

# Now, all the functions are loaded. Ready to make some data


sample.data = data.table( text = c("a","b"), y=rep(1:2000,each=5,times=10), x=rnorm(100000), ordered.integer = rep(1:10, each=10000) )
print(sample.data)

directory.to.save.to = 'sample.data.saved.by.mmapdt'

catn('saving the original data ... (might be slow for big data)')
mmapdt.save(directory.to.save.to, sample.data)
catn('. saved the original data (Elsewhere I have code to append two of these directories together to create truly massive datasets.')

mmapdt.load(directory.to.save.to) -> x
catn("reloaded (really quickly!) into an object of class 'mmapdt'")

#catn("checking the saved data is identical (slow). Using '[]' to convert the 'mmapdt' object to a data.table - this is the slow thing. ")
#stopifnot(identical(x[], sample.data))
#catn('checked.')

# deep.check.mmapdt(x) # a 'self-check' for consistency
# catn('reload deep-checked')

catn("The 'print' method prints the first few and the first last rows (inspired by data.table).")
x
catn("Ignore the 'NAs' in the sixth row, I'm too lazy to format this nicely!")

catn("
     Now to demonstrate useful stuff.
     Loosely inspired by the interface of 'data.table', you can do three basic things with an 'mmapdt' object:
       (1):  x[,list(b,c)]   : Extract two columns (named 'b' and 'c') from the 'mmapdt' object, returning a new 'mmapdt' object.
       (2):  x[100:200,]     : Extract a series of *consecutive* rows (named 'b' and 'c') from the 'mmapdt' object, returning a new 'mmapdt' object.
       (3):  x[]             : Convert to data.table (effectively a 'real' data.frame). Only makes sense for small (sub-)datasets.
       (4):  x[offsets,]     : Extract a series of *non-consecutive* rows, converting to a data.table.
     (1) and (2) will always be fast (except, perhaps, if the number of columns is very large).
     (3) and (4) can be slow if many rows/columns. Hence best to first use (1) and (2) to zoom in on the columns/rows of interest.

")

catn('dimensions of our x object:')
dim(x)
catn("\nThat's too many rows, let's extract the subset where 'ordered.integer' == 5.
This relies on a special function called '.ord' that is in this library. x[.ord(ordered.integer,5)] :")
x[.ord( ordered.integer , 5)] -> x2
x2 # print it
catn("See how that has just 10,000 rows, not 100,000. And how quick it was")
catn()
catn("Now use .ord again on the column y. 'y' is ordered within x2 (but not in x), hence we can use .ord again")
#x2[, .(y)][]$y %|%table
x2[.ord(y, 7)] -> x3
dim(x3)
catn("Finally, as x3 is quite small (just 5 rows), it makes sense to convert to a data.table. x3[]")
x3[]
