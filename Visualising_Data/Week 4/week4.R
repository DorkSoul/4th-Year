install.packages("tweenr")
# install.packages("gganimate")
library(devtools)
# devtools::install_github("dgrtwo/gganimate")
devtools::install_github("hrbrmstr/streamgraph")

library(tidyverse)
library(gganimate)
library(streamgraph)
library(ggplot2)
library(usethis)

install.packages("gifski")
library("gifski")


# Set the working directory to where the CSV file is located
setwd("C:/Users/lukeh/Documents/College/4th-Year/Visualising_Data")

# Load the CSV file into a data frame
data <- read.csv("mly2615.csv")

# View the first few rows of the data frame
head(data)

str(data)

data %>% summarise_all(n_distinct)

# Set the plot dimensions
options(repr.plot.width=15, repr.plot.height=8)

# Aggregate the data by month to get the total rainfall
summarized_data <- aggregate(rain ~ month, data, sum)

# Print the summarized data
print(summarized_data)

# Filter the data to include only observations from a single year
year_data <- subset(data, year == 1960)

# Create a line chart of the monthly rainfall with color and linewidth parameters
ggplot(year_data, aes(x = month, y = rain, color = factor(month), group = 1)) + 
  geom_line(aes(linewidth = rain)) +
  scale_color_discrete(name = "Month") +
  labs(title = "Monthly Rainfall in 1960",
       x = "Month",
       y = "Rainfall (mm)")

# Filter the data to include only observations from 1960
year_data <- subset(data, year == 1960)

# Create a point chart of the monthly rainfall with color and size parameters
ggplot(year_data, aes(x = month, y = rain, color = factor(month), size = rain)) +
  geom_point() +
  scale_color_discrete(name = "Month") +
  labs(title = "Monthly Rainfall in 1960",
       x = "Month",
       y = "Rainfall (mm)")

# Convert the month column to month names
data_edited <- data %>%
  mutate(month = month.name[month])

head(data_edited)

# Filter the data to include only observations from 1960
year_data <- subset(data_edited, year == 1960)

# Create a point chart of the monthly rainfall with color and size parameters and apply the theme
ggplot(year_data, aes(x = month, y = rain, color = factor(month), size = rain)) +
  geom_point() +
  scale_color_discrete(name = "Month") +
  labs(title = "Monthly Rainfall in 1960",
       x = "Month",
       y = "Rainfall (mm)") +
  theme_minimal()

data_filtered <- na.omit(data_edited)

# Create a point chart of the monthly rainfall with color and size parameters and apply the animation
p <- ggplot(data_edited, aes(x = month, y = rain, color = factor(month), size = rain)) +
  geom_point() +
  scale_color_discrete(name = "Month") +
  labs(title = "Monthly Rainfall by Year",
       x = "Month",
       y = "Rainfall (mm)") +
  transition_time(year)

# Animate the chart and set the animation parameters
animate(p, fps = 10, duration = 10, width = 800, height = 600)



# Set the working directory to the folder where the file is located
setwd("C:/Users/lukeh/Documents/College/4th-Year/Visualising_Data")

# Install and load the necessary packages
# install.packages("readr")   # If not already installed
library(readr)
library(babynames)


# Read in the file
vaccine_data <- read_csv("vaccine-preventable-disease-cases-by-county-and-year-2.csv")

head(vaccine_data)

vaccine_summary <- vaccine_data %>%
  group_by(year, disease) %>%
  summarize(count = sum(count))

# Create the streamgraph and wrap it in an HTML object
vaccine_sg <- vaccine_summary %>%
  streamgraph("disease", "count", "year", offset="zero", interpolate="linear") %>%
  sg_legend(show=TRUE, label="Vaccine-preventable Diseases: ")

# Display the streamgraph
vaccine_sg
