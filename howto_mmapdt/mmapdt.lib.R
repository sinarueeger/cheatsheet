# Author: Aaron McDaid   aaron.mcdaid@gmail.com
# Date:   July 20th 2016
# This code is for private, non-commmercial, experimentatal use only. If people are interested,
# I would like to make a future version of this project available under a suitable open source license.
# In this meantime, please contact me if you find this useful. Perhaps we can work together on a
# joint public release.

library(bigmemory)
library(data.table)
library(gtools) # for binsearch

options(bigmemory.typecast.warning=FALSE)

#First, a few convenient little tools

commas <- function(str) strsplit(str,",")[[1]]
catn <- function(...) { cat(...); cat('\n') }
"%|%" <- function(x,y){ do.call(y,list(substitute(x)),envir=parent.frame()) } # like a pipe. Allows to write 'f(x)'  as  'x %|% f'
"%..%" <- function(d,form){ # the same as %|%, except '..' will be defined to equal the value.  Allows   ' complex.function.returning.dataframe() %..%  ..[..$x == "abs1234",]
	p = function(..){}
	body(p,envir=parent.frame()) <- substitute(form)
    do.call(p,list(substitute(d)), envir=parent.frame())
}
PP <- function(x,...) { # PP( f() ) will print "f() = 3" (or whatever the value of f() is)
	cat(deparse(substitute(x)))
	cat(' = ')
	if(length(list(...))>0) {
		cat(deparse(x), " , ");
		PP(...)
	}
	else {
		catn(deparse(x));
	}
}
my.seq.int <- function(from, to, by = 1) {
    if(to < from) {
        stopifnot(to+by == from)
        rep.int(0L,0)
    } else {
        seq.int(from,to,by)
    }
}

# Above are the general purpose useful things I like in every R project. From
# here on are the actual functions for this library

mmapdt.load.one.column <- function(directory, col.name) {
    dget( paste0(directory,'/',col.name,'.desc') ) -> bm.desc
    stopifnot(col.name == bm.desc@description$filename)
    attach.big.matrix(path=directory, bm.desc, readonly=T) -> bm
    stopifnot(ncol(bm)==1)
    #pwc <- function(x){ print(class(x)); print(x); }
    #pwc(bm       )
    #pwc(bm[,1]   )
    #pwc(sub.big.matrix(bm,firstRow=1,lastRow=2, backingpath=directory))
    if("char" == bm.desc@description$type) {
        dget( paste0(directory,'/',col.name,'.cindex.desc') ) -> bm.cindex.desc
        attach.big.matrix(path=directory, bm.cindex.desc, readonly=T)     -> bm.cindex
        list(bm=bm
            ,bm.cindex=bm.cindex
             ) -> l
        class(l) <- 'mmapdt.one.column'
        l
    } else {
        # not a 'char', just return a list with one item
        list(bm=bm) -> l
        class(l) <- 'mmapdt.one.column'
        l
    }
}

mmapdt.load <- function(directory, col.names=NULL) {
    if(is.null(col.names)) {
        dget (paste0(directory,'/','mmapdt.colnames') ) -> col.names
    }
    lapply( col.names, function(col.name) {
        mmapdt.load.one.column(directory,col.name)
    }) -> l
    class(l) <- 'mmapdt'
    attributes(l)$directory = directory
    names(l) = col.names
    l
}

mmapdt.one.column.nrow <- function(one.column) {
    stopifnot(!is.null(one.column))
    stopifnot('mmapdt.one.column' == class(one.column))
    if("char" == typeof(one.column$bm)) {
        ncol(one.column$bm.cindex)
    } else {
        nrow(one.column$bm)
    }
}
dim.mmapdt <- function(x) { # this also supplies ncol and nrow
    c( mmapdt.one.column.nrow(x[[1]]) , length(x) )
}

str.mmapdt <- function(x) {
    stopifnot("mmapdt"==class(x))
    stopifnot("mmapdt.one.column"==sapply(x, class))
    data.table(name = names(x)) [
                               , commas("n,typeof") := list( mmapdt.one.column.nrow(x[[name]]), typeof(x[[name]]$bm) )
                               , by=name ] -> names.and.lengths
    stopifnot(1==length(unique(names.and.lengths$n)))
    catn('mmapdt with',names.and.lengths$n[1],'rows and these columns:')
    names.and.lengths$n <- NULL
    print(names.and.lengths)

    invisible(NULL)
}
print.mmapdt <- function(x) {
    #cat('mmap..')
    N = nrow(x)
    if(N<=11) {
        DT=x[]
        print(DT)
    } else {
        rbind(x[1:6][], x[(-4:0)+N][]) -> dt
        #d[1:10][] %..% apply.and.do.call("cbind",..,function(l){format(justify="none",l)}) %..% {rownames(..)<- 1:nrow(..); print(.., quote=F, right=T)}
        apply.and.do.call("cbind",dt,function(l){format(justify="none",l)}) -> cmat #%..% {rownames(..)<- 1:nrow(..); print(.., quote=F, right=T)}
        stopifnot(nrow(cmat)==11)
        rownames(cmat) <- format(justify="right", c(paste0(1:5,':'), "---", paste0(format((-4:0)+N,scientific=F), ':')) )
        cmat[6,] = ""
        print(cmat, quote=F, right=T)
    }
    return(invisible(x))
}

as.vector.mmapdt.one.column <- function(one.column, mode) {
    to.return = NULL
    if("char" == typeof(one.column$bm)) {
        stopifnot(length(one.column) == 2)
        bm = one.column$bm
        bm.cindex = one.column$bm.cindex
        #print(cindex)
        sapply(seq_len(ncol(bm.cindex)), function(r) {
               start.i = bm.cindex[1,r]
               end.i   = bm.cindex[2,r]
               #PP(r, start.i,  end.i)
               stopifnot(end.i >= start.i)
               if(end.i == 0 && start.i == 0) {
                   NA
               } else if(end.i == start.i) {
                   ""
               } else {
                   bm[(start.i+1):end.i,1] -> one.word.bytes
                   one.word.bytes[one.word.bytes<0] <- one.word.bytes[one.word.bytes<0] + 256
                   one.word.bytes <- as.raw(one.word.bytes)
                   rawToChar(one.word.bytes, multiple=F) -> one.word
                   Encoding(one.word) <- "UTF-8"
                   one.word
               }
    }) -> to.return
    }
    else {
        stopifnot(length(one.column) == 1)
        one.column$bm[] -> to.return
    }
    as.vector(to.return, mode=mode)
}
as.data.frame.mmapdt <- function(x) {
    # only the character one is 'special', everything else is easy
    lapply(x, function(one.column) {
           as.vector(one.column)
    }) -> l
    data.frame(l, stringsAsFactors=F, check.names=F)
}
as.data.table.mmapdt <- function(x) {
    data.table(as.data.frame.mmapdt(x))
}

`[.mmapdt` <- function(x, i,j, by){
            mc = match.call()
            mc[[1]] = real.implementation.of.mmapdt

            k=NA # keep this line, usefuls for ensuring it doens't infect
                 # other environments during testing
            #new.enclosure = new.env(parent = parent.frame())
            #assign("MMAPDTCURRENTX", 1:4, new.enclosure)

            return(eval       (mc
                               , list( .N      = mmapdt.one.column.nrow(x[[1]])
                                     , .ord = function(...) mmap.ordered.region(x,...)
                                     )
                               , parent.frame(1) # this is needed explicitly, to avoid locals here being relevant
                               #, new.enclosure
                               ))
            return(eval.parent(mc))
}
`real.implementation.of.mmapdt` <- function(x, i,j, by){
    stopifnot("mmapdt"==class(x))

    # plain [] will convert to a raw data.table
    if( missing(i)     && missing(j) && missing(by) ) {
        return(as.data.table(x))
    }

    if( missing(i)     && !missing(j) && missing(by) ) {
        JJ = as.list(substitute(j))
        stopifnot(deparse(JJ[[1]]) %in% c(".","list"))

        JJ=JJ[-1]
        stopifnot(length(JJ) >= 1)
        names.of.columns = c()

        lapply(1:length(JJ), function(colindex) {
            new.name.for.this <- names(JJ)[colindex]
            if(is.null(new.name.for.this)) {
                new.name.for.this = (JJ[[colindex]] %|%deparse)
            }
            names.of.columns <<- c(names.of.columns, new.name.for.this)

            eval(   JJ[[colindex]]   ,x) -> one.column
            stopifnot('mmapdt.one.column' == class(one.column))
            one.column
        }) -> ll
        names(ll) <-  names.of.columns
        class(ll) <- 'mmapdt'
        attributes(ll)$directory = attributes(x)$directory
        return(ll)
    }

    if( !missing(i) && length(i) == 0 ) {
        i = rep(0,times=0) # instead of c() which seems to have no useful class
        stopifnot(is.vector(i, mode = "numeric")) # ‘is.vector(x, mode = "numeric")’ can be true for vectors of types ‘"integer"’ or ‘"double"’
    }


    # first, if requesting zero rows, just return a raw data.table,
    # this is because big.matrix doesn't support empty matrices
    if( length(i) == 0 && missing(by) ) {
        lapply(x, function(one.column) {
            switch(typeof(one.column$bm)
                  ,integer = rep(times=0, 5L  )
                  ,char    = rep(times=0, ""  )
                  ,double  = rep(times=0, 3.14)
                  )
        }) %..% data.table(data.frame(..,stringsAsFactors=F,check.names=F)) -> ls
        if(missing(j)) {
            return(ls)
        } else {
            mc = match.call()
            stopifnot(""==names(mc)[1])
            stopifnot("x"==names(mc)[2])
            stopifnot("i"==names(mc)[3])
            stopifnot("j"==names(mc)[4])
            mc[[1]] <- `[`  # to go back to the generic function
            mc[[2]] <- ls   # data.table, not my type any more
            mc[[3]] <- i
            return(eval.parent(mc))
        }
    }

    stopifnot(missing(by))
    stopifnot(missing(j))
    stopifnot(!missing(i)) # at first, we only support row lookup on i
    stopifnot(is.vector(i, mode = "numeric")) # ‘is.vector(x, mode = "numeric")’ can be true for vectors of types ‘"integer"’ or ‘"double"’
    # ... as we're not ready for logical yet

    # and just consecutive ones at that
    stopifnot(length(i) >= 1)

    (i[1]-1+seq_along(i)) -> expected.i
    if(!all( !is.na(i) & i == expected.i)) {
        # non-consecutive i - must go for real data.table now
        lapply(x, function(one.column) {
            if("char" == typeof(one.column$bm)) {
                list(bm=one.column$bm
                    ,bm.cindex =
                      if(any(is.na(i))) {
                        rbind( sapply(i, function(ii) { if(is.na(ii)) {0} else {one.column$bm.cindex[1,ii] }})
                             , sapply(i, function(ii) { if(is.na(ii)) {0} else {one.column$bm.cindex[2,ii] }})
                        )
                      }else{
                          na.fail(i)
                          one.column$bm.cindex[,i]
                      }
                    ) -> one.column.subbed
                as.vector.mmapdt.one.column(one.column.subbed,"any")
            } else {
                if(any(is.na(i))) {
                    sapply(i, function(ii){ if(is.na(ii)){NA}else{one.column$bm[ii,1]}  })
                } else {
                    na.fail(i)
                    one.column$bm[i,1]
                }
            }
        }) %..% data.table(data.frame(..,stringsAsFactors=F,check.names=F)) -> ls
        return(ls)
    }
    stopifnot(i==expected.i)
    firstRow = head(n=1,i)
    lastRow  = tail(n=1,i)

    lapply(x, function(one.column) {
        stopifnot(class(one.column) == 'mmapdt.one.column')
        directory = attributes(x)$directory
        if(1==length(one.column)) {
            sub.bm = suppressWarnings(sub.big.matrix(one.column$bm,firstRow=firstRow,lastRow=lastRow, backingpath=directory))
            list(bm = sub.bm) -> l
            class(l) <- 'mmapdt.one.column'
            l
        } else {
            stopifnot(2==length(one.column)) # must be a char
            sub.bm.cindex = suppressWarnings(sub.big.matrix(one.column$bm.cindex,firstCol=firstRow,lastCol=lastRow, backingpath=directory))
            list(bm = one.column$bm
                ,bm.cindex = sub.bm.cindex
                ) -> l
            class(l) <- 'mmapdt.one.column'
            l
        }
    }) -> ls
    class(ls) <- 'mmapdt'
    attributes(ls)$directory = attributes(x)$directory
    ls
}

`$.mmapdt` <- function(x, column) {
    `$.method.is.undefined`
    #stopifnot("mmapdt"==class(x))
    #x[[column]] -> one.column
    #stopifnot("mmapdt.one.column"==class(one.column))
    #if(typeof(one.column$bm) == "char") {
        #as.vector(one.column)
    #} else {
        #one.column$bm # return the (sub)bigmatrix to the outside. I don't really like this though
    #}
}

lower_bound <- function( f, begin, past.end, val ) { # the first i such that f(i) >= val, with i <= past.end
    if(begin == past.end) {
        return(begin)
    }
    stopifnot(begin<past.end)
    mid = floor((begin+past.end) / 2L)
    stopifnot( mid >= begin )
    stopifnot( mid <  past.end )
    mid.x = f(mid)
    if(mid.x < val) { # skip everything up to, and including, mid
        return(lower_bound(f, mid+1, past.end, val))
    } else {
        # mid.x >= val
        return(lower_bound(f, begin, mid, val))
    }
}
upper_bound <- function( f, begin, past.end, val ) { # the first i such that f(i) >  val, with i <= past.end
    if(begin == past.end) {
        return(begin)
    }
    stopifnot(begin<past.end)
    mid = floor((begin+past.end) / 2L)
    stopifnot( mid >= begin )
    stopifnot( mid <  past.end )
    mid.x = f(mid)
    if(mid.x <= val) { # skip everything up to, and including, mid
        return(upper_bound(f, mid+1, past.end, val))
    } else {
        # mid.x >= val
        return(upper_bound(f, begin, mid, val))
    }
}

mmap.ordered.region <- function(x, column.name, lower.bound, upper.bound = NULL) {
    # both bounds are inclusive, as appears to be standard in R
    if(is.null(upper.bound)) {
        upper.bound <- lower.bound
    }

    n       = mmapdt.one.column.nrow(x[[1]])
    stopifnot(n>=1) # an mmapdt can never be empty

    #PP(lower.bound, upper.bound)
    deparse(substitute(column.name)) -> column.name.as.string
    x[[ column.name.as.string ]] -> the.column
    if(is.null(the.column)) {
        stop('mmapdt: missing column ', column.name.as.string )
        return(NULL)
    }
    stopifnot("char" != typeof(the.column$bm)) # not implemented yet

    lwr.new = lower_bound ( function(i) {the.column$bm[i]}, 1, n+1, lower.bound)
    upr.new = upper_bound ( function(i) {the.column$bm[i]}, 1, n+1, upper.bound)

    if(lwr.new != n+1) { stopifnot(the.column$bm[lwr.new]   >= lower.bound) }
    if(lwr.new > 1)  { stopifnot(the.column$bm[lwr.new-1] <  lower.bound) }
    if(upr.new != n+1) { stopifnot(the.column$bm[upr.new]   >  upper.bound) }
    if(upr.new > 1)  { stopifnot(the.column$bm[upr.new-1] <= upper.bound) }

    my.seq.int( lwr.new, upr.new-1 )
}

deep.check.mmapdt <- function(x) {
    stopifnot( class(x) == 'mmapdt')
    n = nrow(x)
    PP(n)
    lapply(x, function(one.column) {
        stopifnot( class(x) == 'mmapdt')
        bm = one.column$bm
        stopifnot(class(bm) %in% commas("bigmemory,big.matrix"))
        stopifnot(1==ncol(bm))
        if(typeof(bm)=="char") {
            stopifnot(2==length(one.column))
            stopifnot(1==ncol(bm))

            bm.cindex = one.column$bm.cindex
            stopifnot(2==nrow(bm.cindex))
            stopifnot(n==ncol(bm.cindex))

            stopifnot(0==bm.cindex[1,1])
            stopifnot(nrow(bm) == bm.cindex[2,n])
            data.frame(starts=head(bm.cindex[1,]),ends=head(bm.cindex[2,])) %|%print
            data.frame(starts=tail(bm.cindex[1,]),ends=tail(bm.cindex[2,])) %..%print(..,row.names=F)
            #bm.cindex %|%tail %|%print
            bm.cindex[1,-1] %|% head %|%print
            bm.cindex[2,-n] %|% head %|%print
            bm.cindex[1,-1] %|% tail %|%print
            bm.cindex[2,-n] %|% tail %|%print
            stopifnot( head (bm.cindex[1,-1]) == head(bm.cindex[2,-n]) )
            stopifnot( tail (bm.cindex[1,-1]) == tail(bm.cindex[2,-n]) )
        } else {
            stopifnot(1==length(one.column))
            stopifnot(1==ncol(bm))
            stopifnot(n==nrow(bm))
        }
    })
    str(x)
    #print(x)
invisible(NULL)}

mmapdt.save <- function(directory, dt) {
    dir.create(directory, recursive=T)
    lapply(seq_len(ncol(dt)), function(J) {
            one.column.of.dt = dt[[J]]
            my.class = class(one.column.of.dt)
            my.name  = names(dt)[J]
            #PP(J, my.name, my.class)
            stopifnot( my.class %in% c("integer","character","numeric") )
            switch(my.class
                   ,integer = "integer"
                   ,character = "char"
                   ,numeric = "double"
                   ) -> bm.type
            if(bm.type=="char") { # very special
                lapply( one.column.of.dt , function(x){nchar(x,'bytes')} ) %|%unlist %|%as.numeric -> lengths.of.strings.in.bytes
                cumsum(lengths.of.strings.in.bytes)              -> ends.of.strings
                c(0.0,ends.of.strings[-length(ends.of.strings)]) -> starts.of.strings

                stopifnot(class(starts.of.strings) == "numeric")
                simple.save.two.rows(directory, paste0(my.name,'.cindex'), "double", starts.of.strings, ends.of.strings)

                lapply( one.column.of.dt , charToRaw ) %|%unlist -> long.utf8
                long.utf8 = as.integer(long.utf8)
                one.column.of.dt = long.utf8
                one.column.of.dt[one.column.of.dt >= 128] <- one.column.of.dt[one.column.of.dt >= 128] - 256
            }
            simple.save.one.column(directory, my.name, bm.type, one.column.of.dt)
    }) -> meta.data.to.store.on.disk
    #print(meta.data.to.store.on.disk)
    dput( names(dt)                 , paste0(directory,'/','mmapdt.colnames'))
}

simple.save.one.column <- function(directory, my.name, bm.type, one.column.of.dt) {
            big.matrix(  nrow=length(one.column.of.dt)
                       , ncol=1
                       , type=bm.type
                       , backingpath    = directory
                       , backingfile    = my.name
                       , descriptorfile = paste0(my.name,'.desc')
                       ) -> bm
            bm[,1] = one.column.of.dt
            bm
}
simple.save.two.rows    <- function(directory, my.name, bm.type, left ,right) {
            stopifnot(length(left) == length(right))
            big.matrix(  nrow=2
                       , ncol=length(left)
                       , type=bm.type
                       , backingpath    = directory
                       , backingfile    = my.name
                       , descriptorfile = paste0(my.name,'.desc')
                       ) -> bm
            bm[1,] = left
            bm[2,] = right
            bm
}
