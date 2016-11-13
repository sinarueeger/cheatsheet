## 24 november 2011
## sina rueeger
## help from http://cran.r-project.org/web/packages/RnavGraph/vignettes/RnavGraph.pdf
## /////////////////////////////////////////////////////////////////////////////////////

## 1st step: install graphviz and ggobi
## ----------------------------------------

## http://www.ggobi.org/downloads/
## http://www.graphviz.org/Download_windows.php

## 2nd step: install rggobi and Rgraphviz
## ----------------------------------------
install.packages("rggobi", dependencies = TRUE)
source("http://www.bioconductor.org/biocLite.R")
biocLite("Rgraphviz")

## 3rd step: install rest
## ----------------------------------------
install.packages(c("PairViz", "scagnostics", "rgl", "grid", 
                   "MASS", "RGtk2", "hexbin", "vegan"), dependencies = TRUE)

source("http://www.bioconductor.org/biocLite.R")
biocLite("graph")
biocLite("RBGL")
biocLite("RDRToolbox")
# RnavGraph and RnavGraphImageData are then installed as follows
install.packages("RnavGraph")
install.packages("RnavGraphImageData")


## start with RnavGraph
## ---------------------
library(RnavGraph)
library(help = RnavGraph)

## data from diamonds
library(ggplot2)
ng.iris <- ng_data(name = "iris", data = iris[,1:4],
  	shortnames = c('s.L', 's.W', 'p.L', 'p.W'),
		group = iris$Species,
		labels = substr(iris$Species,1,2))
# ng.diamonds <- ng_data(name = "diamonds", data = diamonds[,-c(2:4)],
#     #shortnames = c('s.L', 's.W', 'p.L', 'p.W'),
# 		group = diamonds$cut,
# 		labels = substr(diamonds$cut,1,2))

## Start navGraph
nav1 <- navGraph(ng.iris)


## verbunden mit ggobi
## -----------------------

## NG_data
ng.iris <- ng_data(name = "iris", data = iris[,1:4],
  	shortnames = c('s.L', 's.W', 'p.L', 'p.W'),
		group = iris$Species)

## NG_graph
G <- completegraph(shortnames(ng.iris))
LG <- linegraph(G, sep = "::")
ng.lg <- ng_graph("3d transition", LG, "::", "kamadaKawaiSpring" )

## Visualization instruction

viz1 <- ng_2d_ggobi(ng.iris, ng.lg) 
viz1

## Start a navGraph session

nav <- navGraph(ng.iris, ng.lg, viz1)

## walk
## -----------
## Define a NG_data object
ng.iris <- ng_data(name = "iris", data = iris[,1:4],
  	shortnames = c('s.L', 's.W', 'p.L', 'p.W'))

## start a navGraph session
nav <- navGraph(ng.iris)

## Find linegraph
LG <- linegraph(completegraph(shortnames(ng.iris)))

## find a path
library(PairViz)
path = eulerian(LG)
path = etour(LG)

## walk the path
ng_walk(nav,path)