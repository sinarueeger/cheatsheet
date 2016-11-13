#####################################################################################
## Author: Sina Rueeger [sina *.* rueger *a*t* unil *.* ch]
## Project: 
##        
## Time-stamp: <[howto_hist_color_beryl.R] by SR Wed 08/01/2014 15:41 (CET)>
##
## Description:
## 
##
## History:
## 
#####################################################################################

n <- 100
dat <- data.frame(x = 1:100, y = rnorm(100), gr = rep(c("A", "B"), n/2))

library(ggplot2)
theme_set(theme_bw())
## qplot(x, y, data  = dat, color = gr)

## qplot(y, data  = dat, color = gr) + stat_bin(aes(fill = gr))+ scale_colour_gradient(limits=c(3, 4))
## qp <- qplot(y, data  = dat) + stat_bin() + facet_wrap(~gr)
## qp

x <- hist(dat$y, plot = FALSE)

x.A <- hist(dat$y[dat$gr == "A"], breaks = x$breaks, plot = FALSE)
x.B <- hist(dat$y[dat$gr == "B"], breaks = x$breaks, plot = FALSE)

dat.sm <- data.frame(mids = x$mids, y = x$counts, freq = (x.A$counts+ 1)/(x$counts+1))

ggplot(dat.sm, aes(mids, y, fill = freq))+ geom_bar(stat = "identity") + geom

#scale_colour_continuous(..., low = "#132B43", high = "#56B1F7", space = "Lab", na.value = "grey50", 
#      guide = "colourbar")
