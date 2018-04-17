
## comparison of two means
## -----------------------

mu1 <- 1
mu2 <- 2
mudiff <- 0.5 ##mu1 - mu2
sd1 <- 1
sd2 <- sd1

power <- 0.9
alpha <- 1e-08
u <- qnorm(power)
v <- qnorm(1 - alpha/2)
n <- 42

f.power <- function(mudiff, sd, n = 42, v = qnorm(0.975))
{
	u <- n*(mudiff)^2/(sd^2 + sd^2) - v
	pnorm(u)
}	
	
pnorm(u)

df <- expand.grid(mudiff = seq(0.01, 1.5, by = 0.01), sd = seq(0.5, 3, 0.05)) 

df$power<- f.power(df$mudiff, df$sd)

library(ggplot2)
qplot(mudiff, sd, data = df, fill = power, geom = "tile")+ scale_fill_gradient2(midpoint = 0.8)




## regression
## -----------

beta <- 1:42
n <- 42

f.linreg <- function(beta, n)
{
	
Z <- beta/sqrt(n)
pnorm(Z - 1.28)
	
}

power <- alpha <- 2*(1-pnorm(Z))


plot(beta, power)
plot(beta,-log10(alpha))


## together
## ------------

## sim data
genex <- runif(100, -2, 2)
sd(genex)
mudiff <- 1.5
## 

mudiff <- 0.3
slope <- (mudiff/3*4)
n <- 42

f.power(mudiff, sd = 1.8)

f.linreg(slope, n)
































