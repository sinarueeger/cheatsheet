
dat <- data.frame(x = 1:10, y = runif(10)*100)
dat$low <- dat$y - 2 * runif(10)
dat$up <- dat$y + 2 * runif(10)

## variante (1)
## ------------
library(gplots)
plotCI(x = dat$x, y = dat$y, ui = dat$up, li = dat$low)

## variante (2)
## --------------
library(ggplot2)

theme_set(theme_bw())

qp <- ggplot(dat, aes(factor(x), y, ymax = up, ymin = low ))

qp + geom_point() + geom_errorbar()

qp + geom_bar(stat = "identity", fill = I(gray(0.8)),
                                 color = I(gray(0.8))) + geom_errorbar(width = 0.25)

