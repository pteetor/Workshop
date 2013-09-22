#
# Unit 1: Finger Exercises
#
# Copyright 2013, Quant Development, LLC and nway solutions, inc
#
# Written by:
#   Paul Teetor
#   http://quantdevel.com/public
#

#
# Basic stuff: Numbers and arithmetic
#
2 + 3
2 - 3
2 * 3
2 / 3
2 %% 3
2 %/% 3
2 ^ 3
2 ** 3

#
# Basic stuff: Special values
#
NA
0 / 0
1 / 0
-1 / 0

#
# Basic stuff: Variables and the workspace
#
x <- 2
print(x)
x
y <- 3
y

ls()
rm(x)
ls()
rm(y)
ls()

#
# Basic stuff: Command line editing
# up, down, left, right, enter
#

# --------------------------------------
NA

#
# Much of the power of R
# derives from pervasive use of
# vectors and vectorized functions
#
NA

#
# Sequence operators can create vectors
# of sequencial values
#
1:7
7:1
seq(from=1, to=7, by=2)
seq(from=0.0, to=1.0, length.out=11)
rep(pi, 5)

#
# Use the c() operator to construct a vector
# from its elements
#
c(1, 5)
c(1, 5, 3, 7)
c(1, c(5, 3), 7)
c(1, 3:5, 7)

#
# Another special value:
# NULL represents the empty vector
#
NULL
c()
c(1, NULL, 7)
c(1, c(), 7)

#
# Scalars and vectors play well together
#
3 + 0:4

# Create a sequence of multiples of 3:
3 * 0:4

# Apply a linear transform to x:
x <- 1:10
2 + 3*x

# Take an entire vector modulo 2:
0:4 %% 2
3 ^ 0:4     # OOPS! What happens?
3 ^ (0:4)
(0:4) ^ 3

#
# Vectorized arithmetic is done element-by-element
#
v <- c(100, 200, 300, 400, 500)   # Or: seq(100, 500, 100)
print(v)
-v
v + 0:4
v * 0:4
v %% 0:4
v ^ 0:4    # OOPS! What happened?

# Did you mean this?...
(v ^ 0):4

# Or this?
v ^ (0:4)

#
# Vectorized math functions work element-by-element, too
#
sqrt(1:5)
log(1:5)
exp(1:5)

#
# Most statistical functions work on vectors
#
sum(v)
mean(v)
median(v)
sd(v)
var(v)
max(v)
min(v)

#
# There are special purpose functions for vectors, too
#
cumsum(v)
cumprod(v)
range(v)
diff(v)

#
# Interlude: Getting help on functions
#
?paste
??concatenate

#
# Subscripting vectors
#
v <- c(100, 200, 300, 400, 500)    # Same as before
print(v)

v[1]
v[3]
v[c(3,4,5)]
v[3:5]
v[-1]
v[c(-1,-2)]
### Try this: v[c(1,-2)]

# --------------------------------------
#
# logical (boolean) is an atomic type
#
TRUE; T
FALSE; F

# Logical operators include negation, and, or
!T
!F
T & F
T | F

#
# c() can create vectors of logical values, too
#
c(T, F, T)

#
# Comparisons produce logical values
#
2 == 2
2 != 2
2 > 3
2 < 3

#
# Comparing two vectors is done element-by-element,
# producing a vector of logicals
#
v <- c(100, 200, 300, 400, 500)    # Same as before
v == 200
v != 200
v > 200

#
# Uber cool feature: Vector of logicals can index another
# vector
#
v <- c(100, 200, 300, 400, 500)     # Previous value
v < 300
v[ v < 300 ]
v[ v > 300 ]
v[ v < mean(v) ]

# --------------------------------------

#
# "character" is an atomic type
#
"hello"
### Try this:  "hello" + "world"
paste("hello", "world")
"hello" == "hello"
"hello" == "world"

#
# The c() operator can create vectors of
# character values
#
NA

# Q: What is the difference between these?
"hello world"
c("hello", "world")

#
# All the subscripting operations work on
# vectors of character values, too
#
s <- c("moe", "larry", "curley")
s[1]
s[c(1,3)]
s[-1]

# --------------------------------------

#
# Data structure: matrix
#
# To create a matrix, start with a simple vector
1:6

# Form the vector into a 2x3 matrix...
matrix(1:6, 2, 3)

# Or a 3x2 matrix
matrix(1:6, 3, 2)

# To have a clear layout, use byrow=TRUE
matrix(c(1, 2,
         3, 4,
         5, 6), 3, 2, byrow=TRUE)

# Initialize a matrix to one value
matrix(1, 3, 2)

#
# Like vectors, matrices support element-by-element
# operations.
#
M <- matrix(1:9, 3, 3)
M
2 * M
M ^ 2
sqrt(M)

#
# Subscripting matrices allows selection of
# multiple rows and columns
#
M <- matrix(1:9, 3, 3)    # Same as before
M[1,1];  M[3,3]           # Select one element
M[,c(1,2)]
M[c(1,2),]

#
# Like vectors, use a negative index to exclude
# a value
#
M[,-3]
M[c(1,2),]
M[-3,]

#
# Some R weirdness: Dropping dimensions
# of a matrix
#
M[,3]
M[,3,drop=FALSE]

#
# There are matrix-specific operations, too
#
B <- matrix(1:4, 2, 2)
B
diag(B)
t(B)
solve(B)
B %*% solve(B)

#
# Some R weirdness: dimensions vs length
#
dim(B)
length(B)

# --------------------------------------

#
# More R weirdness: There are no scalars,
# only 1-element vectors
#
# Consider the built-in constant pi:
pi

# It's a vector of length 1
length(pi)

# You can subscript it
pi[1]
pi[-1]

#
# More R weirdness: The Recycling Rule
#
# Try this: Create two vectors of unequal length
x <- 1:8
y <- 1:2

# What happens here when you try these?
x + y
x - y
x > y

# What's going on?

# What happens if the vectors lengths don't play well together?
# Here's what happens:
(1:8) + (1:5)

#
# Fun Tricks with the Recycling Rule
#

# Select every-other element by recycling
# a logical index vector
x[c(F,T)]

# Select every 10th element by recycling a
# mask of 1-in-10 elements
y <- 1:100
idx <- c(rep(FALSE,9), TRUE)
print(idx)
y[idx]

# This operation actually uses the recycling rule:
2 + 0:4

# And this one, too:
matrix(1, 3, 2)

# --------------------------------------

#
# Data structure: Data frames
#

# Description and features
NA

# Example:
NA

dfrm <- data.frame(
  who=c("Moe", "Larry", "Curley"),
  weight=c(190, 180, 250),
  height=c(68, 65, 70) )

print(dfrm)

# Working with data frames:
dfrm[ 1,]
dfrm[-1,]
dfrm[, 1]
dfrm[,-1]
dfrm[,c(2,3)]

# New way to select by column: by name or names
dfrm$who
dfrm$weight
dfrm[,c("who","height")]

#
# Some useful data frame functions
#
# The dimensions of the data frame (rows, columns)
dim(dfrm)

# The names of the columns
colnames(dfrm)

# Convert the numeric columns to a matrix
as.matrix(dfrm[,c("height", "weight")])

# Don't try that on character columns!

#
# X-ray Vision
#
class(cars)
str(cars)
dim(cars)
nrow(cars)
ncol(cars)

#
# Stuff we didn't cover:
# complex numbers, multidimensional arrays, factors, lists
#

# --------------------------------------
NA

# Intentional errors:
###  "hello" + "world"
###  v[c(1,-2)]
