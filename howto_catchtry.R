

  out <- tryCatch(
        {
            message("This is the 'try' part")
            library(fastVCF)          

     	},
        error=function(cond) {
            message(paste("URL does not seem to exist:", lib))
            message("Here's the original error message:")
            message(cond)
            # Choose a return value in case of error
            return(NA)
        },
        warning=function(cond) {
            message(paste("URL caused a warning:",lib))
            message("Here's the original warning message:")
            message(cond)
            # Choose a return value in case of warning
            return(NULL)
        },
        finally={
        # NOTE:
        # Here goes everything that should be executed at the end,
        # regardless of success or error.
        # If you want more than one expression to be executed, then you 
        # need to wrap them in curly brackets ({...}); otherwise you could
        # just have written 'finally=<expression>' 
            message(paste("Processed URL:",lib))
            message("Some other message at the end")
        }
    )    
