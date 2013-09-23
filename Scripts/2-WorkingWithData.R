#
# Unit 2: Working with Data
#
# Copyright 2013, Quant Development, LLC and nway solutions, inc
#
# Written by:
#   Q Ethan McCallum
#   http://qethanm.cc/
#


# For this unit, we'll learn how to load, modify, and inspect a sample dataset.
#
# The sample data is a logfile of downloads from a CRAN mirror.
# You can download the file from our Git repo at:
#
#   https://github.com/pteetor/Workshop/blob/master/data-WorkingWithData.csv.bz2
#
# Right-click the link that reads "View Raw" and save the file to your computer.
#
# Of note:
#
# - Make sure the sample data file is in the same directory
#   where RStudio is running.  By default, this will be your home directory.
#
# - Please do not decompress the file.  It must still have the ".bz2"
#   extension for the rest of this script to work.
#


# The sample data file is in comma-separated value (CSV) format, and compressed (.bz2).

# The fields in the file are as follows:

# "date" and "time": represent the date and time of the request
# "size": amount of data transferred, in bytes
# "r_version" , "r_arch" , and "r_os": the version of R, hardware architecture,
#      and OS, respectively, of the machine that made the request
# "package": name of the package that was downloaded
# "country": two-letter country from which the request was made
# "ip_id": anonymized, unique identifier of each machine




# Loading the data file: R has no trouble reading a compressed CSV file. Simply
# call read.csv():
# *  header=TRUE --> read column names from the first line of the file
# *  stringsAsFactors=FALSE --> treat string (character) data as plain strings,
#    not R's special "factor" data type

data_file <- "data-WorkingWithData.csv.bz2"
data_raw <- read.csv(
	data_file ,
	header=TRUE ,
	stringsAsFactors=FALSE
)



# show the structure of data_raw:
# (data types are (int) or string/character (chr))
str( data_raw )

# summarize each column of data_raw:
summary( data_raw )


# data_raw is a "data.frame" object.
# Think of a data.frame as a table in a database, or as a spreadsheet:
# you have one row per observation, and columns for attributes.

# show the first few rows of data_raw:

head( data_raw )


# two ways to fetch the entire "r_os" column of the data_raw data.frame:

data_raw[ , "r_os" ]  # bracket syntax
data_raw$r_os  # dollar-sign syntax

# fetch the entire third row:
data_raw[ 3 , ]

# fetch element at third row, "r_os" column:
data_raw[ 3 , "r_os" ]

# fetch the column names:
colnames( data_raw )


# Given the questions we want to answer -- general inspection of the number of
# downloads, and from what country, by date -- a number of these columns are of
# no use to us.

# Remove a data.frame column by assigning NULL to it:

data_raw$time <- NULL
data_raw$r_version <- NULL
data_raw$r_arch <- NULL
data_raw$package <- NULL
data_raw$version <- NULL
data_raw$ip_id <- NULL

# It's also possible to remove a column using a negative index:
# sample_df <- sample_df[ , -2 ]


# We also want the "date" column to actually be a Date data type.
# (read.csv() will not do this for us, unfortunately)

data_raw$date <- as.Date( data_raw$date )


# If you know in advance the column data types and/or which columns you'll drop,
# you can pass the "colClasses" argument to read.csv:

data_raw <- read.csv(
	data_file ,
	header=TRUE ,
	stringsAsFactors=FALSE ,
	colClasses=c(
		date="Date" ,
		time="NULL" ,
		r_version="NULL" ,
		r_arch="NULL" ,
		package="NULL" ,
		version="NULL" ,
		ip_id="NULL"
	)
)



# Answering questions based on our dataset:
# what is the download count, broken down by OS, day, country, etc?


# In other words, we want to count up the number of times a given OS, day,
# country, etc appears in the data.frame ...

# Call xtabs() to create a contingency table -- that is, count the number
# of occurrences of each value in a column:

xtabs( ~ r_os , data_raw ) # breakdown by OS
xtabs( ~ country , data_raw ) # breakdown by country
xtabs( ~ date , data_raw ) # breakdown by date
xtabs( ~ date + r_os , data_raw ) # breakdown by date _and_ OS


# Use a barplot to make this easier to follow:

downloads_count_os  <- xtabs( ~ r_os , data_raw )
barplot( downloads_count_os )

# Add labels to make your chart easier to understand:
barplot(
	downloads_count_os ,
	main="package download counts by OS" ,
	xlab="operating system" ,
	ylab="number of downloads"
)

# If the range of values is too large, call log10() to take the base-10
# logarithm of the numeric values
barplot(
	log10(downloads_count_os) ,
	main="package download counts by OS" ,
	xlab="operating system" ,
	ylab="log10(number of downloads)"
)


# plot downloads by date
downloads_count_date <- xtabs( ~ date , data_raw )
plot(
	downloads_count_date ,
	main="download counts, by day" ,
	xlab="date" ,
	ylab="number of downloads"
)

# specifying type="l" (that's a lowercase "L") tells R to create a _line_
# chart, instead of a spike chart
plot(
	downloads_count_date ,
	main="download counts, by day" ,
	type="l" ,
	xlab="date" ,
	ylab="number of downloads"
)


