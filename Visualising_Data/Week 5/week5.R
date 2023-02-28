library(ggplot2)
library(dplyr)


# Set the working directory to where the CSV file is located
setwd("C:/Users/lukeh/Documents/College/4th-Year/Visualising_Data/Week 5")

# Load the CSV file into a data frame
airport <- read.csv("airports.csv")

# View the first few rows of the data frame
head(airport)

# Create a histogram of the altitude of flights
ggplot(airport, aes(x = altitude_ft)) +
  geom_histogram(color = "black", fill = "lightblue", bins = 12) +
  labs(title = "altitude", x = "altitude", y = "Frequency")

ggplot(airport, aes(x=as.factor(Timezone), y=altitude_ft)) + 
  geom_boxplot(fill="slateblue", alpha=0.2) + 
  xlab("timezone")




avg_altitude <- airport %>%
  group_by(Timezone) %>%
  summarize_at(vars(altitude_ft),list(altitude_ft=mean))
avg_altitude

#Create a new column for time zone label
avg_altitude$Time_Zone_Label <- ifelse(avg_altitude$Timezone < 0, "Negative", "Positive")

#Create a side-by-side bar chart
p <- ggplot(avg_altitude, aes(x = Time_Zone_Label, y = altitude_ft, fill = Time_Zone_Label)) +
  geom_bar(stat = "identity", position = "dodge", color = "black") +
  labs(x = "Time Zone", y = "Average Altitude") +
  ggtitle("Comparison of Average Altitude by Time Zone")
p








airport$hour <- airport$Timezone / abs(airport$Timezone)

#Calculate average altitude by hour and timezone
avg_altitude <- airport %>%
  group_by(hour, Timezone) %>%
  summarize(mean_altitude = mean(altitude_ft))

#Add a new column for negative timezones
avg_altitude$NegativeTimezone <- paste0("-", abs(avg_altitude$Timezone))

#Bind the data for positive and negative timezones
combined_data <- rbind(avg_altitude[avg_altitude$Timezone > 0,],
                       avg_altitude[avg_altitude$Timezone < 0,])

#Create side-by-side bar chart
ggplot(combined_data, aes(x = Timezone, y = mean_altitude, fill = factor(hour),
                          group = paste0(hour, ifelse(Timezone > 0, "+", "-"), abs(Timezone)))) +
  geom_bar(stat = "identity", position = "dodge", color = "grey40") +
  ggtitle("Average Altitude by Hour and Timezone") +
  xlab("Timezone") +
  ylab("Average Altitude") +
  scale_fill_discrete(name = "Hour") +
  theme(legend.title = element_blank())



#install.packages("highcharter")
data("pokemon", package = "highcharter")
head(pokemon)

library(treemap)

data <- pokemon

# Subset the first 151 rows
pokemon <- pokemon[1:151,]


# Define the hierarchy
hierarchy <- c("type_1", "type_2", "pokemon")

# create treemap
treemap(pokemon,
        index=c("type_1", "type_2"),
        vSize="weight",
        type="index",
        width = 1600,
        height = 1200)

# Summarize data by type_1 and type_2
type_counts <- aggregate(. ~ type_1 + type_2, data = pokemon, FUN = length)





# Create hour column
airport$hour <- airport$Timezone / abs(airport$Timezone)
#airport$hour

# Round hour to the nearest integer
avg_altitude <- airport %>%
  group_by(Timezone, hour = round(Timezone * 24)) %>%
  summarize(mean_altitude = mean(altitude_ft))
#avg_altitude

# Split the data into positive and negative timezones
pos_data <- avg_altitude[avg_altitude$Timezone > 0,]
neg_data <- avg_altitude[avg_altitude$Timezone < 0,]

# Combine the positive and negative data into a single data frame
combined_data <- data.frame(Timezone = c(pos_data$Timezone, -neg_data$Timezone),
                            mean_altitude = c(pos_data$mean_altitude, neg_data$mean_altitude),
                            hour = c(pos_data$hour, neg_data$hour))

combined_data




# Create the side-by-side bar chart
ggplot(combined_data, aes(x = Timezone, y = mean_altitude, fill = factor(hour))) +
  geom_bar(stat = "identity", position = "dodge", color = "grey40") +
  ggtitle("Average Altitude by Hour and Timezone") +
  xlab("Timezone") +
  ylab("Average Altitude") +
  scale_fill_discrete(name = "Hour") +
  theme(legend.title = element_blank())


# continutity example using a density line of 
p <- ggplot(airport, aes(x=Timezone)) + 
  geom_histogram(bins=20,fill="Yellow", color="Blue") +
  geom_freqpoly(binwidth=1,color="Red")
p

