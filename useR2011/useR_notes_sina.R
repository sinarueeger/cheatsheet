## > useR! 2011 Notes 
## > of sina rueeger
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

## -------------------------------
## Using the Google Visualisation API with R
## >> (motion)chart in html / charts google API
## -------------------------------
## used for lloyds.com/stats
## http://code.google.com/p/google-motion-charts-with-r/
## vignette("googleVis")
library(googleVis)
demo(googleVis)

## -------------------------------
## R2wd
## Word & R: produce Word files with plots etc in R
## -------------------------------
## works only on windows
library(R2wd)
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

## -------------------------------
## Nomograms for visualising relationships between three variables
## -------------------------------
## pynomo.org
## reference : ron doerfler
## in library(rms) are also nomograms

## -------------------------------
## animatoR: dynamic graphics in R
## -------------------------------
library(animatoR) 
## my R crashed when I tried...
## to include in pdf combinde it with animate package of latex

## -------------------------------
## switch order of mosaicplot
## -------------------------------
## Agresti: categorial data analysis
library(ENmisc)
data(Titanic)
myTitanic <- structable(Titanic)
mosaicPermDialog(myTitanic)

## -------------------------------
## RMB:: relative multiple barplots
## combination of mosaicplot (relative frequency) and barplot (absolut frequency)
## mainly to check data for the influence of many explanatory variables on the target variable
## -------------------------------
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

## ---------------
## sparkTable
## following an idea of tufte
## ---------------
library(sparkTable)

## --------------
## compare Groups
## for classical tables used in papers
## also available as gui
## output in txt, csv or latex
## ---------------
library(help = compareGroups)
## http://www.texample.net/tikz/

## ---------------
## IwebPlot (html)
## ---------------
library(iWebPlot)
## http://datatables.net/
## sendplots

## ------
## focus2
## ------
## meetup.com/R-users-sydney >> package Rocessing (interface for R and processing)
## gwidget(pkg)

## -----------------
## RnavGraph and the tk canvas widget
## >> similar to ggobi
## -----------------
library(RnavGraph) ## eher kompliziert zu installieren

## -------
## poster
## -------
library(directlabels)

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


## ---------------
## Simon Urbanek
## ---------------
library(iplots)
library(Acinonyx) ## extension of iplots: faster, better, ... http://www.rforge.net/Acinonyx/
dev.hold() ## currently in R devel
dev.flush() ## dito

    
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
