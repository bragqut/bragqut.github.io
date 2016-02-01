#' tidy.mcmc
#'
#' @description A function that behaves like those from "broom", tidy.mcmc will take an mcmc.list object from coda.samples and return a data frame that summarises each parameters with its mean and quantiles and returns the output as a data.frame object. It does not yet work as though it were a function in broom, e.g. tidy(an.mcmc.list) doesn't work
#'
#' @param x an MCMC list from, e.g. coda.samples()
#'
#' @param q a list of quantiles, such as those corresponding to a 95\% credible and its median
#'
#' @import coda
#'
#' @export

tidy.mcmc <- function(x, q=c(0.025, 0.5, 0.975)){

  # generate summary statistics
  x.s <- summary(x, q=q)

  # pull out mean and quantiles
  x.df <- data.frame(Mean=x.s$statistics[, "Mean"],
                     x.s$quantiles)

  # a variable is more important than a row name
  x.df$term <- factor(row.names(x.df),
                      levels=row.names(x.df),
                      ordered = F)

  row.names(x.df) <- NULL # no one wants row names

  ncols <- ncol(x.df) # need to permute the columns

  return(x.df[, c(ncols, 1:(ncols-1))])
}
