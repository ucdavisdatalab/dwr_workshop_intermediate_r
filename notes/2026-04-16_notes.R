
# To install tidyr:
# install.packages("tidyverse")
# OR
# install.packages("tidyr")


library("tidyr")

# RDS is R's native data format
# Can create .rds files with `saveRDS`
# The `save` function saves to .rda
# We recommened `saveRDS` over `save`
bikes = readRDS("2020_davis_bikes.rds")
head(bikes)

# This dataset is untidy
# (different units in the same column)
# Violates rule 1, 2

# What should a tidy version look like?
#  date  third  loyola  awnd  prcp
bikes2 = pivot_wider(
  bikes,  # the dataset
  values_from = value,  # values that go in the new cols
  names_from = variable  # names for the new cols
  # id_cols = identifier columns that stay the same
)
bikes2


# What's the relationship between counts
# at 3rd St and Loyola Drive?

# install.packages("ggplot2")
library("ggplot2")

ggplot(bikes2) +
  aes(x = third, y = loyola) +
  geom_point()

# What's tidy depends on the unit
# of observation as well as three rules.
#
# For bikes2, the unit is days.
#
# But what if we want to study
# day-location as the unit?

# We need to reshape again:
#  date  location  count  awnd prcp
#        third     ###
#        ...       ...
#        loyola    ###
#        ...       ...

bikes3 = pivot_longer(
  bikes2,  # the data to reshape
  cols = c(third, loyola),  # columns to stack
  values_to = "count",  # name of column of values
  names_to = "location"  # name of column of identifiers
)

bikes3

ggplot(bikes3) +
  geom_line() +
  aes(
    x = date, y = count,
    color = location, linetype = location
  )


# SMART Case Study (3.6)

# install.packages("readxl")
library("readxl")

smart = read_excel(
  "2026-01_smart_ridership.xlsx",
  range = "B4:K16"
)
head(smart)

# Fix the first column so that it contains
# missing values and numbers (rather than
# "-" and text)
smart$FY18[smart$FY18 == "-"] = NA
smart$FY18 = as.numeric(smart$FY18)

head(smart)

# Rename the columns (except `Month`) to years.
# (removing "FY")
# Keep in mind that these are fiscal years

names(smart)[-1] = 2018:2026

head(smart)

# Now we need to reshape.
# To:
#  month  fiscal_year  count
smart2 = pivot_longer(
  smart,
  cols = -Month,
  values_to = "count",
  names_to = "fiscal_year"
)

head(smart2)

# Convert fiscal_year to numbers.
smart2$fiscal_year = as.numeric(smart2$fiscal_year)


head(smart2)

library("lubridate")

# To make dates, we use make_date()
# Inputs are numbers
make_date(2025, 3)

# We need to convert the months into numbers

head(smart2)

month_num = month(fast_strptime(smart2$Month, "%m"))
smart2$Month


# FY 2018 goes from Jul '17 to Jun '18
# So we need to subtract 1 from the year
# for months Jul - Dec (7 - 12)

cal_year = smart2$fiscal_year - ifelse(month_num >= 7, 1, 0)

cal_year
month_num
smart2$fiscal_year

smart2$date = make_date(cal_year, month_num)
head(smart2)

# How does SMART ridership vary over time?
ggplot(smart2) +
  geom_line() +
  aes(x = date, y = count)


# Merging/Combining Data (4)

# Code for the data in 4.1
restaurants = data.frame(
  id = c(1, 2, 3),
  name = c("Alice's Restaurant", "The Original Beef", "The Pie Hole"),
  phone = c("555-3213", "555-1111", "555-9983")
)
restaurants

reviews = data.frame(
  id = c(4, 2, 1, 2, 2),
  score = c(4.2, 3.5, 4.7, 4.8, 4.0)
)
reviews

# Use joins to recombine relational data

# install.packages("dplyr")
library("dplyr")

# Inner joins (4.3)

# Joins take rows from each of the two tables
# by matching on the key column(s)

# Inner joins specifically only keep rows
# where there's a match

restaurants
reviews

inner_join(
  restaurants,
  reviews
)

inner_join(
  restaurants,
  reviews,
  by = "id"
)

inner_join(
  restaurants,
  reviews,
  # by = join_by(LEFT == RIGHT)
  by = join_by(id == id)
)


# Left/Right Join (4.4)

# Left join keeps all rows in the left table
# Only keeps matching in the right table

left_join(restaurants, reviews)
left_join(reviews, restaurants)

right_join(restaurants, reviews)

# Full join (4.5)

# Keep everything from both tables
full_join(restaurants, reviews)
