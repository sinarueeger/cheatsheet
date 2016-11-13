

QQplot <- function(p, neff = NULL, main = "", col = "black", add = FALSE, ...) {
  p <- p[!is.na(p)]
  N <- length(p)
  
  if (is.null(neff))
  {
      p0 <- sort(-log10((1:N)/N-1/(2*N)))
      col <- ifelse(length(col) > 1, order(-log10((1:N)/N-1/(2*N))), col)

  }else
  {
      p0.tmp <- seq(1/neff, 1, length.out = N)
      p0 <- sort(-log10(p0.tmp))
      col <- ifelse(length(col) > 1, order(-log10(p0.tmp)), col)
  }

  if(add)
  {
      points(p0,sort(-log10(p)),col=col, pch=16, ...)
  }else{
      plot(p0,sort(-log10(p)),col=col, pch=16,xlab="Expected -log10(P)",ylab="Observed -log10(P)",
  main = main, las = 1, ...)
  }
  
  lines(-log10(p0),-log10(p0),type="l",col=gray(0.3))
}



## PARAMETERS --------------------------------------

giant <- read.table("/home/sina/Documents/DGM/Projects/Tagging/data/GIANT_Yang2012Nature_publicrelease_HapMapCeuFreq_Height.txt", sep = "\t",
                  header = TRUE)
map <- read.table("/home/sina/Documents/DGM/Projects/Tagging/data/hapmap3_r2_b36_fwd.consensus.qc.poly.map", sep = "\t", header = FALSE)
names(map) <- c("Chr", "SNP.name", "NULL", "Pos")

dat <- merge(map, giant, by.y = "MarkerName", by.x = "SNP.name", all.x = TRUE)
head(dat)


data <- dat[sample(1:nrow(dat), 10000), c("SNP.name", "p", "Chr", "Pos")]
POSITION <- data$Pos
P <- data$p
#P <- -log10(P.raw)
CHROMOSOME <- data$Chr
RS <- data$SNP.name
neff <- NULL
## -------------------------------------------------

QQplot()


## misc parameters ---------------------------------
cutoff <- -log10(1e-8)
col <- c("black", "gray")
size <- unit(0.2, "char")
h.delta <- 1e8
ylim <- NULL
## -------------------------------------------------

## not important parameters for the end users ------
    border.left <- 4
    border.right <- border.left
    border.top <- border.left
    border.bottom <- border.left
    


## build up the plot
## ------------------
grid.newpage()

vp <- viewport(name = "base")
pushViewport(vp)
grid.rect()
seekViewport(name = "base")

yscale <- ylim
yscale[1] <- round(yscale[1])
yscale[2] <- ceiling(yscale[2])

vp.points <- viewport(x = unit(border.left, "lines"),
                      y = unit(border.bottom, "lines"),
                      width = unit(1, "npc")- unit(border.left + border.right, "lines"),
                      height = unit(1, "npc") - unit(border.top + border.bottom, "lines"),
                      just = c("left", "bottom"),
                      yscale = yscale,
                      xscale = yscale,
                      name = "points") # , xscale = n + c(-0.05, 0.05), 
    
pushViewport(vp.points)
grid.rect()
grid.yaxis()
grid.xaxis()
seekViewport(name = "base")

## plot prep
## ------------------
p <- na.omit(P)
N <- length(p)
  
if(is.null(neff))
{
    p0 <- sort(-log10((1:N)/N-1/(2*N)))
    
}else{
    p0.tmp <- seq(1/neff, 1, length.out = N)
    p0 <- sort(-log10(p0.tmp))
}

## points
## ----------
xlab="Expected -log10(P)",ylab="Observed -log10(P)"

if(is.null(ylim)) ylim <- range(c(-log10(p), -log10(p0), cutoff), na.rm = TRUE)

seekViewport(name = "points")
grid.points(unit(p0, "native"), unit(sort(-log10(p)), "native"), pch = 16, size = size)

## lines
## ------------------
seekViewport(name = "points")
grid.lines(unit(-log10(p0), "native"), unit(-log10(p0), "native"), gp = gpar(lty = 1, col = gray(0.2)))

## xlab
## -------
seekViewport(name = "base")
vp.xlab <- viewport(x = unit(border.left, "lines"),
                    y = unit(0, "lines"),
                    height = unit(border.bottom, "lines") - unit(2, "lines"),
                    width = unit(1, "npc") - unit(border.left + border.right, "lines"),
                    just = c("left", "bottom"),
                    name = "xlab") # , xscale = n + c(-0.05, 0.05), 
    
pushViewport(vp.xlab)
#grid.rect(gp = gpar(col = "red"))
grid.text("xlab")

## ylab
## -------
seekViewport(name = "base")
vp.ylab <- viewport(x = unit(0, "lines"),
                    y = unit(border.bottom, "lines"),
                    height = unit(1, "npc") - unit(border.bottom + border.top, "lines"),
                    width = unit(2, "lines"),
                    just = c("left", "bottom"),
                    name = "ylab") # , xscale = n + c(-0.05, 0.05), 
    
pushViewport(vp.ylab)
#grid.rect(gp = gpar(col = "red"))
grid.text("ylab", rot = 90)



set.seed(3)
dat <- data.frame(id = sample(paste0("id", 1:10), 30, replace = TRUE), time = 1)
dat <- dat[order(dat$id), ]
dat$time <- unlist(tapply(rep(1, nrow(dat)), dat$id, function(x) 1:length(x)))

dat[dat$time == 1, ]
