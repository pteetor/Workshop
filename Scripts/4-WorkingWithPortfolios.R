#
# Unit 4: Working with Portfolios
#
# Copyright 2013, Quant Development, LLC and nway solutions, inc
#
# Written by:
#   Paul Teetor
#   http://quantdevel.com/public
#

library(quantmod)

#
# Download history for multiple stocks (if possible), or read from CSV (otherwise)
# Note: We limit this to three stocks, to keep things manageable (eg, AAPL, GOOG, MSFT)
#
NA

symbols <- c("AAPL", "GOOG", "MSFT")
if (any(!sapply(c(symbols), exists))) {
  getSymbols(symbols)
}
ls()

#
# The Cl() function is a convenience function from
# quantmod for extracting the Close price
#
head(Cl(AAPL))
head(Cl(GOOG))
head(Cl(MSFT))

#
# Assemble price history of the portfolio
#
portf <- merge(Cl(AAPL), Cl(GOOG), Cl(MSFT))
head(portf)

#
# Remember: First we look at the data.
# So plot this histories.
#
plot(portf)                                # What do you get?
plot(as.zoo(portf))                        # Now what?
plot(as.zoo(portf), plot.type="single")    # Different

#
# Calculate history of changes (diff)
#
difs <- diff(portf)
head(difs)

#
# Calculate history of returns = (price change) / price
#
rets <- diff(portf) / lag(portf)
head(rets)

#
# Calculate performance stats of returns: mean, median,  standard deviation
#
# Summary statistics:
#
summary(rets)

#
# We need individual statistics, too
#
# The old fashion way:
#
mean(rets[,1], na.rm=TRUE)
mean(rets$GOOG.Close, na.rm=TRUE)
median(rets[,"MSFT.Close"], na.rm=TRUE)

# .... this gets tedious
# and it does not scale to large portfolios!

#
# First, let's remove that troublesome, leading NA
# to keep life simple
#
NA

rets <- rets[-1,]
head(rets)                        # Ah. That's better.

#
# Stock-by-stock statistics: The cool R way, vectorized
#
colMeans(rets)
apply(rets, 2, median)
apply(rets, 2, sd)

#
# Scatterplots of returns: Individual pairs
#
# First extract the pure data.
# If we don't, plot() thinks we want a time series plot
#
NA

core <- coredata(rets)
head(core)

#
# Now we can produce a scatter plot (not line plot)
#
plot(core[,1], core[,2])

#
# Let's add some axes to further clarify the relationship
#
abline(v=0.0)
abline(h=0.0)

#
# Scatterplots of returns: Matrix of pairs
#
plot(as.data.frame(rets))

#
# Calculate covariance matrix and correlation matrix
#
cor(rets)
cov(rets)

#
# Calculate Sharpe Ratio of each stock: The old-fashioned way
#
mean(rets[,1]) / sd(rets[,1])
mean(rets$GOOG.Close) / sd(rets$GOOG.Close)

# Again, it's tedious and error prone

#
# So calculate Sharpe Ratio of each stock the cool R way:
# with vectorized arithmetic
#
NA

colMeans(rets) / apply(rets, 2, sd)

# Annualized Sharpe Ratio (not daily):
sqrt(252) * colMeans(rets) / apply(rets, 2, sd)

#
# Let's capture that in a function
#
sharpeRatio = function(r) {
  colMeans(r) / apply(r, 2, sd)
}

# Check: Do you get the same result:
sharpeRatio(rets)
  
# Most robust version:
# colMeans(r, na.rm=TRUE) / apply(r, 2, sd, na.rm=TRUE)

#
# Interlude: We want to create a portfolio.
#   Why?
#   Which stocks should we own?
#   How much of each?
#   Is it a good portfolio or a bad portfolio?
#
NA

#
# Let's go with a risk parity portfolio: Stocks are weighted to have equal risk.
# Weight the returns according to standard deviation
#
NA

weights <- 1 / apply(rets, 2, sd)
weights <- weights / sum(weights)
print(weights)

#
# Weight the returns accordingly and
# calculate the portfolio returns
# R idiom is: t(WEIGHT * t(returns))
#
NA

wrets <- t(weights %*% t(rets))
head(wrets)

#
# Calculate the Sharpe ratio of the portfolio - Did diversification help or hurt?
#
sharpeRatio(wrets)

#
# Let's calculate and plot the portfolio's P&L
#
NA

# Start with $1.
# Compound the returns to see the growth.
NA

cumpl <- cumprod(c(1, 1 + wrets))
plot(cumpl, typ='l')

#
# Now build a portfolio analysis function.
# Parameter is an xts object of price history
#
riskParityPortf = function(prices) {

  # From stock prices, calculate stock returns
  
  # From stock returns, calculate risk-parity weights
  
  # Print the weights (for the user's benefit)
  
  # From weights (and stock returns), calculate portfolio returns
  
  # From portfolio returns, calculate portfolio Sharpe Ratio
  
  # From portfolio returns, calculate portfolio P&L
  # (assuming you start with $1)
  
  # Plot the portfolio P&L
}

# Here is my version of the function

riskParityPortfolio = function(prices) {
  r <- diff(prices) / lag(prices)
  r <- r[-1,]
  w <- 1 / apply(r, 2, sd, na.rm=TRUE)
  w <- w / sum(w)
  print("Portfolio weights are:");  print(w)
  pr <- t(w %*% t(r))
  sharpe <- mean(pr, na.rm=TRUE) / sd(pr, na.rm=TRUE)
  print("Daily Sharpe Ratio is:");  print(sharpe)
  print("Annualized Sharpe Ratio is:");  print(sqrt(252) * sharpe)
  cumpl <- cumprod(c(1, 1+pr))
  plot(cumpl, typ='l', main="Cumulative P&L")  
}

# Now do it all again, with a new set of stocks: SPY, IEF, DBC
#
# Download stock histories
symbols2 <- c("SPY", "IEF", "DBC")
if (any(!sapply(c(symbols2), exists))) {
  getSymbols(symbols2)
}

# Merge the closing prices into one xts object
portf2 <- merge(Cl(SPY), Cl(IEF), Cl(DBC))

# Try your cool, new function
riskParityPortf(portf2)
