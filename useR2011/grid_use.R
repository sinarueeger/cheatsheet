## grid
cprop <- function(x) {
    prop <- x/sum(x)
    cumsum(prop)
}


prop <- function(x) {
    x/sum(x)
}


spine <- function(x, gp = gpar(), name = NULL) {
    px <- prop(x)
    cpx <- cprop(x)
    grid.rect(y=cpx, height=px, just="top", gp = gp, name = name)
}


connector <- function(x1, x2, gp = gpar(), name = NULL) {
    cp1 <- cprop(x1)
    cp2 <- cprop(x2)
    grid.segments(0, cp1, 1, cp2, gp = gp, name = name)
}




## line segments
## -------------

y1 <- 1:10
y2 <- 10:1

cp1 <- cprop(y1)
cp2 <- cprop(y2)

grid.segments(0, cp1, 1, cp2)

## stack rectangles
## -----------------
p1 <- prop(y1)
dev.off()
grid.rect(unit(3.5, 'in') - unit(1, 'in'), y = cp1, width = unit(1, 'in'), height = p1, just = "top", gp = gpar(fill = hcl(240, 60, seq(10, 100, 10))))

pushViewport(plotViewport())

fills <- hcl(240, 60, seq(10, 100, length = length(cp1)))
grid.rect(y=cp1, height=p1, width=unit(1, "in"), 
          just="top", gp=gpar(fill=fills))

## excercise 3
## ------------
p1 <- prop(y1)
p2 <- prop(y2)
dev.off()

pushViewport(viewport(x = 0, width = unit(1/3, "npc"), just = 'left'))
grid.rect(x = 0, y=cp1, height=p1, width=unit(1, "in"), 
          just="top")
popViewport()
pushViewport(viewport(x = unit(1/3, "npc"), width = unit(1/3, "npc"), just = 'left'))
grid.segments(0, cp1, 1, cp2)
popViewport()

pushViewport(viewport(x = unit(2/3, "npc"), width = unit(1/3, "npc"), just = 'left'))
grid.rect(x = 1, y=cp2, height=p2, width=unit(1, "in"), 
          just="top")
popViewport()

## excercise 4
## -----------
library(lattice)
install.packages('latticeExtra', dependencies = TRUE)
grid.newpage()
mtcarsExp <- rbind(apply(mtcars[c("mpg", "disp")], 2, log),
                   mtcars[c("mpg", "disp")])
mtcarsExp$am <- rep(ifelse(mtcars$am, "manual", "automatic"), 2)
mtcarsExp$logged <- rep(c("logged", "untransformed"), 
                        each=nrow(mtcars))
library(lattice)
plot <- xyplot(mpg ~ disp | am*logged, mtcarsExp,
               scales=list(relation="free",
                           x=list(at=list(TRUE, TRUE, NULL, NULL)),
                           y=list(limits=list(c(2.2, 3.6), c(2.2, 3.6),
                                              c(10, 35), c(10, 35)),
                                  at=list(TRUE, NULL, TRUE, NULL))),
               par.settings=list(layout.heights=list(axis.panel=c(1, 0),
                                                     top.padding=3),
                                 layout.widths=list(axis.panel=c(1, 0))))
library(latticeExtra)
print(useOuterStrips(plot))

current.viewport()
current.vpTree()

downViewport('plot_01.strip.2.2.off.vp')
grid.xaxis(main=FALSE, gp=gpar(cex=.8))
upViewport(0)
downViewport('plot_01.strip.1.2.off.vp')
grid.xaxis(main=FALSE, gp=gpar(cex=.8))
upViewport(0)

## exercise 5 
## -----------
densityplot(~weight|group, PlantGrowth, layout = c(1,3))
current.viewport()
current.vpTree()
grid.ls()
downViewport('plot_01.strip.1.1.off.vp')
grid.edit('plot_01.bg.strip.1.1', gp = gpar(fill = 'green3'))
upViewport(0)
downViewport('plot_01.strip.1.2.off.vp')
grid.edit('plot_01.bg.strip.1.2', gp = gpar(fill = 'red'))
upViewport(0)
downViewport('plot_01.strip.1.3.off.vp')
grid.edit('plot_01.bg.strip.1.3', gp = gpar(fill = 'blue3'))
upViewport(0)

## showViewport()
showViewport()
showGrob()

## exercise 6
## -----------
grid.newpage()
connector(1:10,10:1,gp=gpar(col = grey(1:10/11), lwd = 3), name = 'conn1')

grid.newpage()
spine(1:10, gp = gpar(fill = grey(1:10/11)), name = 'spine1')


