model{
  for (i in 1:n){
    y[i] ~ dnorm(mu, tau)
  }

  mu ~ dnorm(0, 1e-6)
  tau ~ dunif(0,1e6)
  sd = tau^(-0.5)
}
