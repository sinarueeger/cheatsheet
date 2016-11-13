## ///////////////////////////////
## howto use survival
## ///////////////////////////////

library(survival)
library(help = survival)

## logrank test
## --------------
p.mod <-  survreg(Surv(futime, fustat) ~ ecog.ps + rx, ovarian, dist='weibull',
                                         scale=1)
summary(p.mod)

## kaplan meier curves
## --------------
kap.mod <-  survfit(Surv(futime, fustat) ~ ecog.ps + rx, ovarian)
plot(kap.mod)

## cox regression
## --------------
cox.mod <-  coxph(Surv(futime, fustat) ~ ecog.ps + rx, ovarian, dist='weibull',
                                         scale=1)

summary(cox.mod)


