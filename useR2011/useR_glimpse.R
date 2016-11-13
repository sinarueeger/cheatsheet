## > useR! 2011 Notes 
## > sina rueeger
## > booklet: http://www.warwick.ac.uk/statsdept/user-2011/user2011_booklet.pdf

## ////////////////////////
## ///// M O N D A Y //////
## ////////////////////////

## Tutorial "Graphical Models and Bayesian Networks", Soren Hojsgaard
## Notes, slides & examples here: http://genetics.agrsci.dk/~sorenh/public/R/useR2011-GMBN/

## Tutorial "Introduction to Grid Graphics", Paul Murrell
## Slides & excercises here: http://www.stat.auckland.ac.nz/~paul/useR2011-grid/


## ////////////////////////
## ///// T H U R S D A Y //
## ////////////////////////

unname()
use()

## -------------------------------
## Using the Google Visualisation API with R
## >> (motion)chart in html / charts google API
## -------------------------------

## used for lloyds.com/stats
## http://code.google.com/p/google-motion-charts-with-r/
## vignette("googleVis")

library(googleVis)
library(help = googleVis)

library(ggplot2)
# demo(googleVis)

## barplot
dat.cast <- data.frame(cast(diamonds, cut ~ color))
bar1 <- gvisBarChart(dat.cast, xvar = "cut", yvar = c("D", "E"))
plot(bar1)

## annotated time line
data(Stock)
Stock
A1 <- gvisAnnotatedTimeLine(Stock, datevar="Date",
                           numvar="Value", idvar="Device",
                           titlevar="Title", annotationvar="Annotation",
                           options=list(displayAnnotations=TRUE,
                            legendPosition='newRow',
                            width=600, height=350)
                           )
plot(A1)

## interaktiver scatterplot
library(SwissAir)  
dat.ad <- AirQual[,c("start", grep("ad", names(AirQual), value = TRUE))]
names(dat.ad) <- gsub("ad.","", names(dat.ad))
                            
dat.sz <- AirQual[,c("start",grep("sz", names(AirQual), value = TRUE))]
names(dat.sz) <- gsub("sz.","", names(dat.sz))
                            
dat.lu <- AirQual[,c("start",grep("lu", names(AirQual), value = TRUE))]
names(dat.lu) <- gsub("lu.","", names(dat.lu))
dat <- rbind(data.frame(ort = "ad", dat.ad),data.frame(ort = "sz", dat.sz), data.frame(ort = "lu", dat.lu))
dat$start <- as.Date(strptime(dat$start, "%d.%m.%Y %H:%M"))
                            ## timevar Year
#id <- unique(dat[,1:2])
#dat <- dat[rownames(dat) %in% rownames(id), ]
dat.cast.O3 <- cast(dat, start+ort~., median, value = c("O3"))
names(dat.cast.O3)[3] <- "O3"
dat.cast.NOx <- cast(dat, start+ort~., median, value = c("NOx"))
names(dat.cast.NOx)[3] <- "NOx"
dat.cast.NO <- cast(dat, start+ort~., median, value = c("NO"))
names(dat.cast.NO)[3] <- "NO"
dat.cast.WS <- cast(dat, start+ort~., median, value = c("WS"))
names(dat.cast.WS)[3] <- "WS"
dat.cast.WD <- cast(dat, start+ort~., median, value = c("WD"))
names(dat.cast.WD)[3] <- "WD"
dat.cast.T <- cast(dat, start+ort~., median, value = c("T"))
names(dat.cast.T)[3] <- "T"
dat.cast.Td <- cast(dat, start+ort~., median, value = c("Td"))
names(dat.cast.Td)[3] <- "Td"

dat.cast <- merge(dat.cast.O3, merge(dat.cast.NOx, merge(dat.cast.NO, merge(dat.cast.WS, merge(dat.cast.WD, merge(dat.cast.T, dat.cast.Td, by = c("start", "ort")), by = c("start", "ort")), by = c("start", "ort")), by = c("start", "ort")), by = c("start", "ort")), by = c("start", "ort"))

M1 <- gvisMotionChart(dat, idvar="ort", timevar="start", date.format = "%d.%m.%Y")
str(M1)

plot(M1)
                            
                          

## -------------------------------
## R2wd
## Word & R: produce Word files with plots etc in R
## -------------------------------
## only working on windows

library(R2wd)
wdGet()
wdTitle("Example R2wd")

mod <- lm(Ozone ~ Solar.R + Wind + Temp, data = airquality)


## verbatim text
wdSection("Summary Verbatim")
tt <- capture.output(summary(mod))
wdVerbatim(tt)

## text
wdSection("Text")
wdWrite(tt)

## tabelle
wdSection("Tabelle")
wdTable(format(summary(mod)$coef))

## plot
wdSection("Plot: Hist")
wdPlot(airquality$Ozone, plotfun = hist)

wdSection("Plot: Residuen")

plot.mod <- function()
{
  par(mfrow = c(2,2)) 
  plot(mod)
}

wdPlot(plotfun = plot.mod)
wdQuit()

## wdGet()
## wdTitle(), Body, Footnote, Plot, Theme, Table, Equation, Save

## -------------------------------
## emacs org-mode 
## reproducible research in emacs
## -------------------------------

## reproducible research = methods + data + code + parameters
## existing approaches: ReDoc, Sweave (compendium), orgmode.org

## as far as I understood org-mode is different to sweave that it can contain other languages than R
## furthermore other output than pdf can be choosen (e.g. html, email...)

## -------------------------------
## Design of Experiment 
## ulrike groempling
## -------------------------------

library(DOE.base)
library(DOE.wrapper)
library(FrF2)

## block what you can, randomize what you cant (box, hunter&hunter)
## repeated measurements != replication 

## -------------------------------
## Nomograms for visualising relationships between three variables
## -------------------------------
## pynomo.org
## reference : ron doerfler

## -------------------------------
## animatoR: dynamic graphics in R
## -------------------------------
library(animatoR) ## my R crashed when I tried...
## to include in pdf combinde it with animate package of latex

## -------------------------------
## switch order of mosaicplot
## -------------------------------
## Agresti: categorial data analysis

library(ENmisc)
data(Titanic)
myTitanic <- structable(Titanic)
mosaicPermDialog(myTitanic)

## structable()

## -------------------------------
## RMB:: relative multiple barplots
## combination of mosaicplot (relative frequency) and barplot (absolut frequency)
## mainly to check data for the influence of many explanatory variables on the target variable
## -------------------------------
install.packages("extracat")
library(extracat)

data(housing)
rmb(formula = ~Type+Infl+Cont+Sat, data = housing, gap.mult = 2,
        col.vars = c(FALSE,TRUE,TRUE,FALSE), abbrev = 3)


## ////////////////////////
## /// W E D N E S D A Y //
## ////////////////////////

## -------------------------------
## Tricks and Traps for Young Players
## -------------------------------

## postscript()
## .Internal() ## faster computing
## all.equal()
## curve()

## -------------------------------
## Software design patterns in R
## -------------------------------
## closures
## HMS - Analytical software

## -------------------------------
## Random input testing
## -------------------------------
## do.call()
## trycatch()

## -------------------------------
## Debugging
## -------------------------------
## Tobias Verbeke 
## Open Analytics
## WalWave

## -------------------------------
## Neuro Imaging 
## -------------------------------
library(rpanel)
## send tracy the link of the presentation and task view.


## ////////////////////////
## ///// T H U R S D A Y //
## ////////////////////////

## sparkTable
## following an idea of tufte: in latex oder html
## ---------------
install.packages("sparkTable", dep = TRUE)
library(help = sparkTable)


## compare Groups
## for classical tables used in papers
## also available as gui
## output in txt, csv or latex
## ---------------
library(help = compareGroups)
## http://www.texample.net/tikz/

## IwebPlot (html)
## ---------------
library(iWebPlot)
## http://datatables.net/
## sendplots

## focus2
## ------
## meetup.com/R-users-sydney >> package Rocessing (interface for R and processing)
## gwidget(pkg)

## -----------------
## RnavGraph and the tk canvas widget
## >> similar to ggobi
## -----------------
library(RnavGraph) ## eher kompliziert zu installieren

## poster
## -------
install.packages("directlabels", dep = TRUE)
library(directlabels)

library(lattice)
library(ggplot2)
theme_set(theme_bw())
direct.label(xyplot(Petal.Length ~Petal.Width , data = iris, groups= Species))
direct.label(qplot(Petal.Width, Petal.Length, data = iris, colour = Species, geom = "point"))

## Acinonyx
## ----------
install.packages("Acinonyx",repos = "http://rforge.net")
library(Acinonyx)

## ---- start: 
## go to R console!
library(Acinonyx)
library(ggplot2)
p.b <- ibar(diamonds$cut)
p.h <- ihist(diamonds$price) ## upper arrow                   
p.p <- iplot(diamonds$carat, diamonds$price)
p.l <- iabline(lm(price~carat, dat = diamonds))
p.l$color = 3

## parallel coordinate plot
ipcp(iris[,1:4])  # use curser!!

## --- end

## ---------------------
## paul murrell
## Vector Image Processing
## ---------------------
library(grImport)
library(gridSVG)

PostScriptTrace('campus_map.pdf')
x <- readPicture('campus_map.pdf.xml')
grid.picture(x)
## you end up with this: http://www.stat.auckland.ac.nz/~paul/Talks/UseR2011/city-gridSVG-interactive.svg.html
## (if you are paul murrell)

## TEACHING
## ---------
## packages: googleVis, animatoR, RMB, mosaicplots
## datasets: gRbase, grid, donkey, mathmark, mtcars

## considering for uniplot
## -----------------------

## library(roxygen)
## R forge
## task of visualization
## remove NOTE
## library(roxygen)

## ---------------
## further notes
## ---------------
## http://www.qubitgroup.com/
## cloudnumbers.com
## RGoogleDocs
## RForge
## http://www.gnu.org/software/make/
## google summer of code R: http://rwiki.sciviews.org/doku.php?id=developers:projects:gsoc2011
## library(roxygen)
## http://www.texample.net/tikz/
## packages: ctv, codetools

## http://www.revolutionanalytics.com/
## http://www.mango-solutions.com/
## 
