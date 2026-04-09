# To install the entire Tidyverse:
install.packages("tidyverse")

# Alternative:
install.packages("lubridate")

# To load the package:
library("lubridate")

# Parsing dates (1.3)

date_strings = c(
  "Jan 10, 2021",
  "Sep 3, 2018",
  "Feb 28, 1982"
)

date_strings
class(date_strings)

sort(date_strings)

date_strings + 1


dates = mdy(date_strings)
dates

class(dates)

sort(dates)

# as.POSIXlt
# To convert between POSIXlt, POSIXct, Date:
as.POSIXlt()
as.POSIXct()
class(dates)
as.POSIXct(dates)
as.POSIXlt(dates)

time_string = "6 minutes, 32 seconds, after 10 o'clock"
time = fast_strptime(time_string, "%M minutes, %S seconds, after %H o'clock")
time

?fast_strptime

class(time)

# For more info about R's datetime formats:
?POSIXlt
?POSIXct

# Creating dates (1.4)
events = make_datetime(
  year = c(2023, 2002),
  month = c(1, 8),
  day = c(10, 16),
  hour = c(8, 14),
  min = c(3, 59)
)
events

class(events)

# Extracting components (1.5)
# NOTE: Always choose the non-plural function
year(events)
minute(events)

events
minute(events) = c(10, 15)


# Durations & periods (1.6)
dates

# A duration is a fixed-length offset
# (in seconds).
dates + duration(30, "days")

# To make a duration use `d` and plural component:
dates + dminutes(20)

# A period is a calendar offset
# (varies in length depending on context)
dates + period(1, "month")

# The plural time component functions make
# periods.
dates + months(1)


# What if we do this?
dates + duration(1, "month")


# Case Study: CA Parks & Recreation Fleet (1.7)
fleet = read.csv("2015-2023_ca_parks_fleet.csv")
head(fleet)

str(fleet)

dates = mdy(fleet$acquisition_delivery_date)
dates

# Why did parsing fail for 4000?

sum(is.na(dates))  # count of trues (missing values)

bad_dates = fleet$acquisition_delivery_date[is.na(dates)]
head(bad_dates, 20)

# These are Excel date offsets
# Excel uses Dec 31 1899 as the reference date (day 0)
# But Excel has bug -- they misunderstood
# 1900 as a leap year (it isn't)
# Everyone else works around this
# by using Dec 30 1899 as reference
start_date = make_date(1899, 12, 30)
start_date

day_offsets = as.numeric(bad_dates)
table(is.na(day_offsets))
# We might want to figure out why there are 9 missing

fixed_dates = start_date + days(day_offsets)
fixed_dates

range(fixed_dates, na.rm = TRUE)

# Insert the fixed dates into the parsed dates from earlier:
dates[is.na(dates)] = fixed_dates
table(is.na(dates))


# String Fundamentals (2.1)
x = "Hello
Nick"

x

message(x)
x
print(x)

"She said, \"Hi\""
'She said, "Hi"'

"She said \"Don't do it!\""


# The stringr package (2.2)
# Optionally (only needed if you didn't install Tidyverse):
install.packages("stringr")

# To load:
library("stringr")

# Regular expressions (2.3)
str_detect("hello", "el")
str_detect("hello", "le")
str_detect("hello", "EL")

# . is the wildcard
str_detect("hello", ".")

# The fixed function disables regular expressions:
str_detect("hello", fixed("."))

# In general, in regular expressions,
# punctuation has special meaning.

# You can also disable special meanings
# by escaping a character with backslash \
# But \ is also an escape code for R
# So we end having to write 2
str_detect("hello", "\\.")

str_detect("hello", "^e")
str_detect("hello", "e")

# Replacing parts of strings (2.4)
# Useful e.g., for commas in numbers

x = c("1,000,000", "525,000", "42")
as.numeric(x)

# str_replace replaces the 1st match
str_replace(x, fixed(","), "")

# str_replace_all replaces all matches
num_strs = str_replace_all(x, fixed(","), "")
as.numeric(num_strs)


# Splitting strings (2.5)
# str_split

x = "21, 32.3, 5, 64"
result = str_split(x, fixed(", "))
result

result[[1]]

str_split_fixed(x, fixed(", "), 4)
