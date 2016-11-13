## ///////////////////////////////
## howto choose colors
## ///////////////////////////////

library(dichromat) ## nur colorblind simulation

library(help = colorspace)

?colorRamp
?colorRampPalette
?IDPcolorRamp

filled.contour(volcano,
               color.palette =
                   colorRampPalette(c("#984EA3", "#E41A1C", "#FF7F00", "#FFFF33",  "#4DAF4A", "#377EB8"),
                                    space = "Lab"),
               asp = 1)

f.diverge <- function(n)
colorRamp(c("red", "white", "black", "blue"), space = "Lab")

  filled.contour(volcano,
               color.palette = f.diverge,
               asp = 1)

pal(diverge_hcl(12, h = c(0, 360)))

plot(1:10, col = hex(polarLUV(L = 30, C = 75, H = 0)), pch = 16)



