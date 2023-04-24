# Installs
if (!requireNamespace("ggplot2", quietly = TRUE)) {
  install.packages("ggplot2")
}

if (!requireNamespace("magrittr", quietly = TRUE)) {
  install.packages("magrittr")
}

if (!requireNamespace("dplyr", quietly = TRUE)) {
  install.packages("dplyr")
}

if (!requireNamespace("scales", quietly = TRUE)) {
  install.packages("scales")
}

# Load packages
library(ggplot2)
library(magrittr)
library(dplyr)
library(scales)


setwd("C:/Users/lukeh/Documents/College/4th-Year/Visualising_Data/Week 11")

Titanic_Data <- read.csv("bigtitanic.csv")

colnames(Titanic_Data)
head(Titanic_Data)
summary(Titanic_Data)
colSums(is.na(Titanic_Data))
unique(Titanic_Data$embarked)
unique(Titanic_Data$sex)
unique(Titanic_Data$age)
table(Titanic_Data$sex)
sum(Titanic_Data$sex == "")
mean(Titanic_Data$age, na.rm = TRUE)
median(Titanic_Data$age, na.rm = TRUE)
sd(Titanic_Data$age, na.rm = TRUE)

Titanic_Data_filtered <- Titanic_Data %>%
  filter(sex %in% c("male", "female"))

unique(Titanic_Data_filtered$age)

Titanic_Data_filtered <- Titanic_Data_filtered %>% 
  filter(!is.na(age))

unique(Titanic_Data_filtered$age)

# Add age groups
Titanic_Data_filtered$age_group <- cut(Titanic_Data_filtered$age, breaks = seq(0, 80, 10), right = FALSE, include.lowest = TRUE)

unique(Titanic_Data_filtered$sex)
unique(Titanic_Data_filtered$survived)

survival_counts_class <- Titanic_Data_filtered %>%
  group_by(sex, age_group, pclass) %>%
  summarise(total_count = n(),
            survivor_count = sum(survived, na.rm = TRUE)) %>%
  mutate(total_age_sex_group = sum(total_count, na.rm = TRUE)) %>%
  ungroup()

survival_rates_class <- survival_counts_class %>%
  mutate(survival_rate = (survivor_count / total_age_sex_group))

ggplot(survival_rates_class, aes(x = age_group, y = survival_rate, fill = factor(pclass))) +
  geom_bar(stat = "identity", position = "stack") +
  scale_y_continuous(labels = percent_format()) +
  facet_grid(.~sex) +
  labs(x = "Age group", y = "Survival Rate", fill = "Class") +
  theme_minimal()




# Graph type: Stacked bar chart
# 
# The stacked bar chart is an appropriate choice for this data, as it allows for a clear comparison of the survival rates across age groups, separated by sex and class. 
# It effectively shows the distribution of survival rates for different passenger classes within each age group and sex, providing insights into the impact of age, sex, and class on survival rates.
# 
# ACCENT principles:
#   
# A: Aspects - The aspects of the visualization (age group, sex, and class) are clearly displayed using color, facets, and the x-axis.
# C: Consistency - The visualization uses a consistent format, making it easy to interpret and compare the survival rates for each age group, sex, and class.
# C: Clarity - The chart is clear and easy to understand, with axis labels, legend, and percent formatting on the y-axis.
# E: Emphasis - The use of color to differentiate between passenger classes allows the viewer to focus on the differences in survival rates based on class.
# N: Necessity - All visual elements in the chart are necessary for understanding the relationship between age, sex, class, and survival rate.
# T: Truthfulness - The chart accurately represents the survival rates for each age group, sex, and class based on the given data.
# 
# GESTÄLT principles:
#   
# Proximity: Related data (age groups within the same sex) are grouped close together in the chart, making it easy to compare and identify trends.
# Similarity: The use of color for passenger classes is consistent across the entire chart, helping the viewer to easily recognize the relationship between class and survival rate.
# Continuity: The x-axis is continuous, showing the progression of age groups in a logical order.
# Closure: The chart is well-contained and easy to interpret, with clearly defined age groups, sex, and class categories.
# Figure/Ground: The visualization clearly distinguishes between the data (figure) and the background (ground), making the information easily accessible to the viewer.
# 
# Overall, the visualization effectively communicates the relationship between age, sex, class, and survival rate on the Titanic. 
# The stacked bar chart is a suitable choice for this type of data, and the application of ACCENT and GESTÄLT principles helps ensure that the chart is clear, consistent, and easy to interpret.




