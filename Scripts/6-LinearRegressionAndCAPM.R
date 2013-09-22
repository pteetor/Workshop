#
# Unit 6: Linear Regression and CAPM
#
# Copyright 2013, Quant Development, LLC and nway solutions, inc
#
# Written by:
#   Paul Teetor
#   http://quantdevel.com/public
#

# Background to the CAPM model
#   What is a stock index?
#   What's the big deal with indexes?
#   How can we compare a stock to an index?
NA

# CAPM model: the regression
#   The underlying regression equation
#   Intepreting the regression results
NA

# Linear regression in R
#   The lm() function
#   Syntax and meaning of the formula
#   Putting data in a data frame
NA

# Let's try the model on MCD (McDonald's)
# This should look familiar:
#   Download two histories: S&P500 and MCD (McDonald's)
#   Merge the histories
#   Calculate the returns
NA

library(quantmod)
getSymbols("^GSPC")     # Weird symbol for S&P500
getSymbols("MCD")
prices <- merge(Cl(GSPC), Cl(MCD))
returns <- diff(prices) / lag(prices)

# Create a data frame from the returns (why?)
dfrm <- as.data.frame(returns)
colnames(dfrm) <- c("sp500", "mcd")

# Fit the data to the model: MCD ~ SP500
lm(mcd ~ sp500, data=dfrm)

# Interpretation for CAPM model
# [here: lm() output, the regression equation,
# alpha and beta from coef]
NA

# Full model summary
# Capture the regression results

# Summarize the regression results
model_m <- lm(mcd ~ sp500, data=dfrm)
summary(model_m)

# Pulling details from the linear regression
formula(model_m)
coef(model_m)
confint(model_m)
round(confint(model_m, level=0.90), 6)
251 * coef(model_m)[1]

# Do it again:
# Download AA (Alcoa Aluminum) and create the data
getSymbols("AA")
prices_aa <- merge(Cl(GSPC), Cl(AA))
returns_aa <- diff(prices_aa) / lag(prices_aa)
dfrm_aa <- as.data.frame(returns_aa)
colnames(dfrm_aa) <- c("sp500", "aa")

# Fit to model: AA ~ SP500
model_aa <- lm(aa ~ sp500, data=dfrm_aa)

# What is the result?
# Compare it to the MCD result; what do you conclude?
coef(model_m)
coef(model_aa)

# Model diagnostics for linear regression
confint(model_m)
coef(summary(model_m))
summary(aov(model_m))

# Some of the most powerful diagnosics are plots
par(mfcol=c(2,2))
plot(model_m)
par(mfcol=c(1,1))

plot(model_m, ask=FALSE)

# Experiment: Do betas vary over time?
# Fit old data and recent dataa for MCD
lm(mcd ~ sp500, data=head(dfrm, 2*251))
lm(mcd ~ sp500, data=tail(dfrm, 2*251))

# Repeat for AA
lm(aa ~ sp500, data=head(dfrm_aa, 2*251))
lm(aa ~ sp500, data=tail(dfrm_aa, 2*251))

# Question: Does the model work better with log returns?
NA

logModel <- lm(mcd ~ sp500, data=log(dfrm + 1))
summary(logModel)
plot(logModel, which=2)

# Full Disclosure: OK, the regression data CAN
# be an xts object.
colnames(returns) <- c("sp500", "mcd")
lm(mcd ~ sp500, data=returns)

# .... because lm() will call as.data.frame for you.
# We did the conversion explicitly.
# I just wanted to make a point.
