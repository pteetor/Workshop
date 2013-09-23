
#
# Unit 5: Random numbers and Monte Carlo simulation
#
# Copyright 2013, Quant Development, LLC and nway solutions, inc
#
# Written by:
#   Q Ethan McCallum
#   http://qethanm.cc/
#



# In R, we don't simply generate random numbers.  Instead, we ask R for a
# random number from a particular statistical distribution.


# Draw a single random value from the uniform distribution:
runif( 1 )

# Draw ten more random numbers from the uniform distribution:
runif( 10 )


# Convince ourselves that, collectively, these values fit the uniform
# distribution ...
rand_unif <- runif( 100 )

# ... using summary statistics:
mean( rand_unif )
median( rand_unif )
sd( rand_unif )

# ... by plotting the data
plot( rand_unif )
stripchart( rand_unif )
hist( rand_unif )

# Try with a larger set of random values (should be a better fit of the uniform
# distribution):
rand_unif_big <- runif( 10000 )


# Try that histogram with 10 bins, instead of the default:
hist( rand_unif_big )
hist( rand_unif_big , breaks=10 )

# there are plenty of other ways to tweak the binning.  Check the hist() help
# page for details, and note the "breaks" parameter.



mean( rand_unif_big )
median( rand_unif_big )
sd( rand_unif_big )

# ... by plotting the data
plot( rand_unif_big )
stripchart( rand_unif_big )
hist( rand_unif_big )


# R supports several random distributions beyond the uniform.  For example:
# exponential: rexp()
# gamma: rgamma()
# normal: rnorm()


# We can perform a similar analysis using the normal distribution:

rand_norm <- rnorm( 100 , mean=50 , sd=25 )

mean( rand_norm )
median( rand_norm )
sd( rand_norm )

plot( rand_norm )
stripchart( rand_norm )
hist( rand_norm )


# Putting random numbers to use: generating synthetic data to simulate Profit
# and Loss (PNL) from trading strategies.

# Here, the variable "pnl" represents one trading strategy's profit/loss over
# 500 days.
cashflows <- rnorm( 500 , sd=200 )
pnl <- cumsum( cashflows )


# It's easier to generate PNL if we wrap those to lines into a function:
path <- function(){
	cashflows <- rnorm( 500 , sd=200 )
	result <- cumsum( cashflows )
	return( result )
}


# invoke path() to create a vector of PNL data:
pnl <- path()


# visual inspection of PNL data:
plot( pnl , type="l" , main="PNL" , xlab="day" , ylab="Profit / Loss (USD)" )


# Generate 1000 sets of PNL data:

all_paths <- replicate( 1000 , path() )


# Notice, we use matplot() to plot a matrix (not plot())
matplot( all_paths )


# By default, matplot() will plot all of the data in the matrix. We can also
# plot subsets of the data:

# plot first vector of PNL data (the first column of the matrix):
matplot( all_paths[,1] , main="PNL" , xlab="day" , ylab="Profit / Loss (USD)" )


# plot second and tenth columns: 
matplot( all_paths[, c(2,10) ] , main="PNL" , xlab="day" , ylab="Profit / Loss (USD)" )


# Plot some columns at random

# First, we use the sample() function to give us three numbers, chosen at
# random from the range 1:1000
sample( 1:1000 , 3 )


# Next, we know there are 1000 columns in the matrix, but it's more flexible to
# let R dynamically determine the number of columns (in case we later decide to
# create more or fewer sets of PNL data).  Use ncol() to get the number of
# columns in a matrix:

ncol( all_paths )

# Finally, we put this all together:

cols_to_plot <- sample( 1:ncol( all_paths ) , 3 )
matplot( all_paths[ , cols_to_plot ] , main="PNL" , xlab="day" , ylab="Profit / Loss (USD)" )


# Assesssing the outcome: the last row in the matrix represents the end result
# of each of our fictional, randomly-generated strategies.

# We call nrow() to fetch the number of rows in the matrix ...

nrow( all_paths )

# ... so we can fetch the last row:

outcomes <- all_paths[ nrow( all_paths ) , ]


# Finally, we can review the outcomes:

mean( outcomes )
median( outcomes )
sd( outcomes )


hist( outcomes )

