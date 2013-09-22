#
# Unit 3: Working with Stock History
#
# Copyright 2013, Quant Development, LLC and nway solutions, inc
#
# Written by:
#   Paul Teetor
#   http://quantdevel.com/public
#

# Load the quantmod library
library(quantmod)
search()

symbol <- "GOOG"
ls()
getSymbols(symbol)
ls()
head(GOOG)
tail(GOOG)
px <- GOOG$GOOG.Close
head(px)
tail(px)

# Interlude: Q: What did getSymbols() create? A: An xts object
class(px)
str(px)
str(GOOG)

#
# You can index an xts object like a matrix
#
px[1,1]
px[2,1]
px[1:5,1]

GOOG[1,c(1,5)]
GOOG[2,c(1,5)]
GOOG[1:5,c(1,5)]

#
# Use coredata and index to extract the parts
#
head(coredata(px))
head(index(px))

#
# Cool xts feature: symbolic indexing via last()
#
# Try these:
#
last(px, "1 week")
last(px, "2 months")
last(px, "1 year")

#
# Cool xts feature: Plotting is pretty simple
#
plot(px)

# Interlude: Very often, price changes are more important than prices.
# Price matters when you buy and sell.
# In between, price *changes* matter.
NA

#
# Calculating and plotting differences
#
difs <- diff(px)
head(difs)

#
# Characterizing price differences: plotting the data
#
plot(difs)
hist(coredata(difs), 20)

#
# Characterizing price differences: quick summary
#
summary(difs)
summary(coredata(difs))

# Q: How many NA's does the data contain?
NA

#
# Characterizing price differences:
# numerical measures
#
mean(difs)
mean(difs, na.rm=TRUE)
median(difs)
median(difs, na.rm=TRUE)
quantile(difs, na.rm=TRUE)

#
# The scale of price differences changes over time
#
summary(first(difs,"1 year"))
summary(last(difs,"1 year"))

# Why? Price growth. The changing scale causes problems
# with the math.
# Idea: Use Dow Industrial long-term chart here
# plot(px)
NA

# Interlude: Mathmatically define "return" (warning: other defintions)
NA

#
# Easiest way to construct P[i-1]: the lag function.
# It shifts data so that older observations appears later (delayed, lagged)
#
NA

head(px)
head(lag(px))

#
# Calculating and plotting returns: divide today's change by yesterday's price
#
rets <- diff(px) / lag(px)
head(rets)

# Interlude: xts and "aligned" arithmetic - SKIP
#
# Interlude: This does not perform the translation you expect - SKIP
#   px - px[1,1]
# Try this instead:
#   px - coredata(px[1,1])
NA

#
# Characterizing returns: quick summary
#
summary(rets)
summary(coredata(rets))
summary(coredata(100 * 252 * rets))

# Q: How many NA's does the data contain?

#
# Side bar: We calculated daily returns.
# Most investors think in terms of annualized returns,
# expressed in percent.
# That's an easy transformation
#
NA

summary(100 * 253 * rets)

#
# Characterizing returns: graphics
#
plot(rets)
hist(coredata(rets), 20)

qqnorm(coredata(rets))
qqline(coredata(rets))

#
# Characterizing returns: numerics
#
mean(rets, na.rm=TRUE)
median(rets, na.rm=TRUE)
quantile(rets, na.rm=TRUE)

#
# Comparing risk vs reward
#

#
# Standard deviation of returns is a good proxy for risk:
# volatile returns make investors nervous
#
NA

sd(rets)
sd(rets, na.rm=TRUE)
sd(as.vector(rets), na.rm=TRUE)
sd(as.vector(100 * rets), na.rm=TRUE)

#
# Interlude: Risk, return, and Sharpe ratios
#
NA

#
# Calculating Sharpe ratios
#
NA

gmean <- mean(rets, na.rm=TRUE)
gsd <- sd(as.vector(rets), na.rm=TRUE)
sharpe <- gmean / gsd
sharpe
sqrt(252) * sharpe

#
# Let's make a one-line function to calculate Sharpe Ratio
#
sharpeRatio = function(r) {
  mu <- mean(r, na.rm=TRUE)
  sigma <- sd(as.vector(r), na.rm=TRUE)
  sqrt(252) * mu / sigma
}

#
# Check: Does the function give you the same result?
#
print(sqrt(252) * sharpe)
sharpeRatio(rets)

#
# Experiment: Does Sharpe Ratio change over time?
#
sharpeRatio(first(rets,"3 years"))
sharpeRatio(last(rets,"3 years"))

# The moral of the story: Markets are always changing.
# Past performance might tell you nothing about future performance.
# Be careful.
NA

# Look what we did!
ls()

# -------------------------- END OF LECTURE

#
# Aux material: Plot two assets, one low-risk and one high-risk
#

N_DAYS = 100
ANN_PL = 100.0
HIGH_VOL = 200.0
LOW_VOL = 20.0

signal = seq(0, ANN_PL, length.out=N_DAYS)
highVolNoise = rnorm(N_DAYS, mean=0, sd=HIGH_VOL/sqrt(N_DAYS))
lowVolNoise = rnorm(N_DAYS, mean=0, sd=LOW_VOL/sqrt(N_DAYS))

highVolPL = signal + highVolNoise
lowVolPL = signal + lowVolNoise

plot(lowVolPL, typ='l', col="green", ylim=range(c(highVolPL, lowVolPL)),
     main="Two Investments", xlab="Time", ylab="P&L")
lines(highVolPL, col="red")
