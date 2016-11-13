## * * * * * * * *
## Mixed Models 
## 10-March-2010
## * * * * * * * *

## = = = = = = = = =
## Data
## = = = = = = = = =

N <- 20
dat <- data.frame(Y=rnorm(N*4), ID=as.factor(rep(1:N, rep(4, N))), Group=as.factor(rep(c('Cont','PD'), c(N,N))), Test=as.factor(rep(c('A','A','B','B'), N/2)), Cond=as.factor(rep(c('VD','VDD'), N)))

str(dat)

## Factor ID is nested in Group. Group, Test, Cond are crossed factors. Group is therefore a between-subject factor, Cond and Test are within-subject factors. 

## = = = = = = = = =
## aov() + Error()
## = = = = = = = = =

mod <- aov(Y ~ Group*Test*Cond + Error(ID), data=dat)
summary(mod)

#Error: ID
#          Df  Sum Sq Mean Sq F value Pr(>F)
#Group      1  2.6336  2.6336  2.2047 0.1549
#Residuals 18 21.5017  1.1945               
#
#Error: Within
#                Df Sum Sq Mean Sq F value Pr(>F)  
#Test             1  0.000  0.0002  0.0001 0.9909  
#Cond             1  4.197  4.1971  2.9133 0.0936 .
#Group:Test       1  0.032  0.0319  0.0222 0.8822  
#Group:Cond       1  1.969  1.9687  1.3665 0.2475  
#Test:Cond        1  0.531  0.5306  0.3683 0.5465  
#Group:Test:Cond  1  0.111  0.1115  0.0774 0.7820  
#Residuals       54 77.796  1.4407  

## = = = = = 
## lmer
## = = = = = 
library(lme4)

## Comments: 
## ---------
## a.) The function lmer() fit a general linear mixed model. 

## b.) Some advantages: you don't have to care about nested or crossed factors. Easy formula writing. You can add intercept and slope errorterms. Fast computing, ...

## c.) Somehow a disadvantage: There are NO p-values provided. If you are interested to know WHY, read this: https://stat.ethz.ch/pipermail/r-help/2006-May/094765.html

## d.) The 'old' version of this package is 'nlme', which contains an other formula-writing. 

## Further reading: 
## ----------------
##		- Information in the R News of 2005 
##		www.r-project.org/doc/Rnews/Rnews_2005-1.pdf  (page 27)
##    http://www.maths.bath.ac.uk/~jjf23/ELM/mixchange.pdf
## 		- Webpage of the Package
##		http://lme4.r-forge.r-project.org/
## 		They provide a lot of helpful slides from presentations and tutorials and a draft of the new book.


## Model 
## ----------------

mod.lmer <- lmer(Y ~ Group*Test*Cond + (1|ID), data=dat)
#anova(mod.lmer)
#Analysis of Variance Table
#                Df Sum Sq Mean Sq F value
#Group            1 2.6336  2.6336  1.9096
#Test             1 0.0002  0.0002  0.0001
#Cond             1 4.1971  4.1971  3.0433
#Group:Test       1 0.0319  0.0319  0.0231
#Group:Cond       1 1.9687  1.9687  1.4275
#Test:Cond        1 0.5306  0.5306  0.3847
#Group:Test:Cond  1 0.1115  0.1115  0.0808

summary(mod.lmer)
#Linear mixed model fit by REML 
#Formula: Y ~ Group * Test * Cond + (1 | ID) 
#   Data: dat 
#   AIC   BIC logLik deviance REMLdev
# 265.9 289.7 -122.9    244.3   245.9
#Random effects:
# Groups   Name        Variance Std.Dev.
# ID       (Intercept) 0.0000   0.0000  
# Residual             1.3791   1.1744  
#Number of obs: 80, groups: ID, 20
#
#Fixed effects:
#                      Estimate Std. Error t value
#(Intercept)             0.1232     0.3714   0.332
#GroupPD                -0.1637     0.5252  -0.312
#TestB                  -0.2744     0.5252  -0.522
#CondVDD                 0.5343     0.5252   1.017
#GroupPD:TestB           0.2292     0.7427   0.309
#GroupPD:CondVDD        -0.4782     0.7427  -0.644
#TestB:CondVDD           0.4751     0.7427   0.640
#GroupPD:TestB:CondVDD  -0.2986     1.0504  -0.284
#
#Correlation of Fixed Effects:
#            (Intr) GropPD TestB  CndVDD GrPD:TB GPD:CV TB:CVD
#GroupPD     -0.707                                           
#TestB       -0.707  0.500                                    
#CondVDD     -0.707  0.500  0.500                             
#GropPD:TstB  0.500 -0.707 -0.707 -0.354                      
#GrpPD:CnVDD  0.500 -0.707 -0.354 -0.707  0.500               
#TstB:CndVDD  0.500 -0.354 -0.707 -0.707  0.500   0.500       
#GPD:TB:CVDD -0.354  0.500  0.500  0.500 -0.707  -0.707 -0.707