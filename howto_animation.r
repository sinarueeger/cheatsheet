# animations

## caTools package
## write.gif()
## -------------
library(caTools)
?write.gif()


# create simple animated GIF (using image function in a loop is very rough,
# but only way I know of displaying 'animation" in R)
x <- y <- seq(-4*pi, 4*pi, len=200)
r <- sqrt(outer(x^2, y^2, "+"))
image = array(0, c(200, 200, 10))
for(i in 1:10) image[,,i] = cos(r-(2*pi*i/10))/(r^.25)
write.gif(image, "wave.gif", col="rainbow")
y = read.gif("wave.gif")
for(i in 1:10) image(y$image[,,i], col=y$col, breaks=(0:256)-0.5, asp=1)
# browseURL("file://wave.gif") # inspect GIF file on your hard disk


jpeg(filename = "something%03d.jpg")
for(i in 1:10){
  plot(i)
} 
dev.off()

dat <- data.frame(TIPO = factor(rep(c("A", "B"), 3)), Avariato = c(0.05, 0.09, 9, 8, 9, 3))
dat$id <- rep(c(1, 2, 3), rep(2, 3))
library(reshape)
cast(dat, TIPO~.)
reshape1(dat, vars="TIPO")
reshape(dat, timevar = "TIPO", direction = "wide", idvar = "id")

dat.new <- dat[dat$TIPO=="A"]