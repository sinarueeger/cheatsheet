## How to ... iplot
## ------------------

install.packages('iplots','http://www.rforge.net/')
library(iplots)

library(ggplot2)  ## for mosaicplot
dat <- diamonds[sample(1:nrow(diamonds), 1000),]
iplot(dat$carat, dat$price)
ihist(dat$price)
imosaic(dat$cut, dat$color)

iplot.backend()
iplot.zoomIn(0.8, 2000, 1.4, 4000)
