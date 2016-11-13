## graphical models
## ===================

library(gRim)
library(gRbase)

data(cad1)
head(cad1)
data(cad2)

iplot(UG <- ug(~Heartfail:CAD+Smoker:CAD+Hyperchol:CAD+AngPec:CAD))

## finding best model
## ------------------
dm1 <- dmod(~Heartfail:CAD:Smoker+Smoker:CAD:AngPec+Hyperchol:CAD+AngPec:CAD, data = cad1)
dm.new <- stepwise(dm1, direction = "forward") ## , criterion = "test")
## working

dm1 <- dmod(~.^., data = cad1)
dm.new <- stepwise(dm1) # , direction = "forward") ## , criterion = "test")
## not working: aperm.default(a, perm, resize) : 'perm' hat falsche Länge
 
dm1 <- dmod(~., data = cad1)
dm.new <- stepwise(dm1) # , direction = "forward") ## , criterion = "test")
## not working: aperm.default(a, perm, resize) : 'perm' hat falsche Länge

iplot(dm.new)
iplot(dm1)

## fit
## ------------------
iplot(UG <- ug(~Heartfail:CAD+Smoker:CAD+Hyperchol:CAD+AngPec:CAD))

cadmod1 <- compile(grain(UG, cad1))
querygrain(cadmod1, nodes = "CAD")
pred1 <- predict(cadmod1, resp = "CAD", newdata = cad2, type = "class")

## crossvalidation
## ---------------

