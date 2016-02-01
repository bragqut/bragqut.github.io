library(tidymcmc)
library(rjags)

n <- 100
mu <- 5
sd <- 2

example.d <- list(n=n, y=rnorm(n=n, mean=mu, sd=sd))

example.m <- rjags::jags.model(file = "model.R", data = example.d)

example.b <- rjags::jags.samples(model = example.m,
                          n.iter = 1e4,
                          variable.names=c("mu","sd"))

example.p <- rjags::coda.samples(model = example.m,
                          n.iter = 1e4,
                          variable.names=c("mu","sd"))

example.s <- tidy.mcmc(example.p)
