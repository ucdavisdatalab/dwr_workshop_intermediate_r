# Intermediate R: Data Viz

# Get the Palmer penguins data.
# install.packages("tidyverse")
# install.packages("palmerpenguins")

library("ggplot2")
library("palmerpenguins")

head(penguins)

# Check data types and shape (before plotting).
str(penguins)

# Start making the plot.
ggplot(penguins) +
  geom_point() +
  aes(
    x = flipper_length_mm,
    y = bill_length_mm,
    color = species
  )

# Regression lines
ggplot(penguins) +
  geom_point() +
  aes(
    x = flipper_length_mm,
    y = bill_length_mm,
    color = species
  ) +
  geom_smooth(
    method = "lm",
    se = FALSE
  )

summary(penguins)


# Foreground colors
# We could use an eyedropper or color picker tool
# to get the colors, but these colors are common
# built-in named colors in R:
# darkorange purple cyan4
ggplot(penguins) +
  geom_point() +
  aes(
    x = flipper_length_mm,
    y = bill_length_mm,
    color = species,
    shape = species
  ) +
  geom_smooth(
    method = "lm",
    se = FALSE
  ) +
  scale_color_manual(
    # You can also use hexadecimal color codes here:
    # These look like #6a7b22 using digits
    # 0-9 and A-F
    values = c("darkorange", "purple", "cyan4")
  )

# Background color
ggplot(penguins) +
  geom_point() +
  aes(
    x = flipper_length_mm,
    y = bill_length_mm,
    color = species,
    shape = species
  ) +
  geom_smooth(
    method = "lm",
    se = FALSE
  ) +
  scale_color_manual(
    values = c("darkorange", "purple", "cyan4")
  ) +
  theme_minimal()


# Legend
ggplot(penguins) +
  geom_point() +
  aes(
    x = flipper_length_mm,
    y = bill_length_mm,
    color = species,
    shape = species
  ) +
  geom_smooth(
    method = "lm",
    se = FALSE
  ) +
  scale_color_manual(
    values = c("darkorange", "purple", "cyan4")
  ) +
  theme_minimal() +
  theme(
    legend.position = "inside",
    legend.position.inside = c(0.85, 0.15)
  )


# Add titles, labels
ggplot(penguins) +
  geom_point() +
  aes(
    x = flipper_length_mm,
    y = bill_length_mm,
    color = species,
    shape = species
  ) +
  geom_smooth(
    method = "lm",
    se = FALSE
  ) +
  scale_color_manual(
    values = c("darkorange", "purple", "cyan4")
  ) +
  theme_minimal() +
  theme(
    legend.position = "inside",
    legend.position.inside = c(0.85, 0.15)
  ) +
  labs(
    title = "Flipper and bill length",
    subtitle = "Dimensions for Adelie, Chinstrap, and Gentoo Penguins at Palmer Station LTER",
    x = "Flipper length (mm)",
    y = "Bill length (mm)"
  )


# Point size and transparency
ggplot(penguins) +
  geom_point(
    size = 3.5,
    alpha = 0.75
  ) +
  aes(
    x = flipper_length_mm,
    y = bill_length_mm,
    color = species,
    shape = species
  ) +
  geom_smooth(
    method = "lm",
    se = FALSE
  ) +
  scale_color_manual(
    values = c("darkorange", "purple", "cyan4")
  ) +
  theme_minimal() +
  theme(
    legend.position = "inside",
    legend.position.inside = c(0.85, 0.15)
  ) +
  labs(
    title = "Flipper and bill length",
    subtitle = "Dimensions for Adelie, Chinstrap, and Gentoo Penguins at Palmer Station LTER",
    x = "Flipper length (mm)",
    y = "Bill length (mm)"
  )


# Case Study: Categorical Data
# How can we get more insight into the number
# of birds of each species of penguin?

table(penguins$species)

ggplot(penguins) +
  geom_bar() +
  aes(x = species) +
  labs(x = "Species", y = "Count")

# There's more info:
str(penguins)

ggplot(penguins) +
  geom_bar() +
  aes(
    x = species,
    fill = sex
  ) +
  labs(x = "Species", y = "Count")

summary(penguins)

# How would we make the bars side-by-side
# instead of stacked?
ggplot(penguins) +
  geom_bar(position = "dodge") +
  aes(
    x = species,
    fill = sex
  ) +
  labs(x = "Species", y = "Count")

# What if we also want to take island into
# account?
# To add categorical variables to a plot
# that already has 1-2, use facets.

ggplot(penguins) +
  geom_bar(position = "dodge") +
  aes(
    x = species,
    fill = sex
  ) +
  labs(x = "Species", y = "Count") +
  facet_wrap(
    ~ island, nrow = 2, ncol = 2
  )

?facet_wrap

# What about facet_grid?

ggplot(penguins) +
  geom_bar(position = "dodge") +
  aes(
    x = species
  ) +
  labs(x = "Species", y = "Count") +
  facet_grid(
    sex ~ island
  )


# Case Study: Time Series
# install.packages("tidyverse")
library("readr")
library("lubridate")
library("dplyr")

birds = read_csv("hpai-wild-birds-ver2.csv")
head(birds)

str(birds)

# Fix the data type of the dates.
birds$date = mdy(birds$`Date Detected`)
str(birds)

# Let's also fix the other data types.
birds = mutate(birds, across(c(-date, -`Date Detected`), factor))


count(birds, date)

# Let's make a bar plot to show the counts
# over time.
# We'll make the x-axis time.
# y-axis is count.
ggplot(birds) +
  aes(
    x = date,
    fill = `Sampling Method`
  ) +
  geom_histogram(
    color = "black"
  )
