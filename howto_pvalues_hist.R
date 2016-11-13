## 24 november 2011
## sina rueeger
## /////////////////////////////////////////////////////////////////////////////////////
library(ggplot2)
theme_set(theme_bw())

## kein signifikanter effekt
## >> uniform verteilt
I <- 1000
N <- 10000
mat <- matrix(rnorm(N*I), ncol = I, nrow = N)
pval <- rep(NA, I)
for ( i in 1:I)
{
  pval[i] <- t.test(mat[,i])$p.value
}

qplot(pval)

## signifikanter effekt
## >> uniform verteilt + werte bei kleiner 0.01 oder 0.05
mod <- lm(price ~.^2, data = diamonds)
summary(mod)
qplot((summary(mod)$coef)[,4])

