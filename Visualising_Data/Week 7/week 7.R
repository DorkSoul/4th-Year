library(tidyverse)
library(corrplot)
library(GGally)
library(ggExtra)
library(dplyr)
library(ggplot2)
library(ggpubr)
library(reshape2)



setwd("C:/Users/lukeh/Documents/College/4th-Year/Visualising_Data/Week 7")

College_Data <- read.csv("College_Data.csv")


options(repr.plot.width=12, repr.plot.height=12)
College_Data
plot(College_Data)

# Select six columns to plot
subCollege_Data <- subset(College_Data, select=c('Apps', 'Accept', 'Enroll', 'Top25perc', 'F.Undergrad', 'P.Undergrad', 'Grad.Rate'))
subCollege_Data
plot(subCollege_Data)

ggpairs(subCollege_Data)

M = cor(subCollege_Data)
corrplot(M)

corrplot(M, method = 'number') # colorful number

corrplot(M, method = 'color', order = 'alphabet')

corrplot.mixed(M, lower = 'shade', upper = 'pie', order = 'hclust')

options(repr.plot.width=8, repr.plot.height=8)

subCollege_Data <- subset(College_Data, select=c('X', 'Private', 'Apps', 'Accept', 'Enroll', 'Top25perc', 'F.Undergrad', 'P.Undergrad', 'Grad.Rate'))
subCollege_Data

ggscatter(subCollege_Data, x = "Apps", y = "Enroll", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "pearson",
          xlab = "Applications", ylab = "Enrollment")

# mpg
ggqqplot(subCollege_Data$Apps, ylab = "Apps")
# wt
ggqqplot(subCollege_Data$Enroll, ylab = "Enroll")

str(subCollege_Data)

subCollege_Data %>% summarise_all(list(~n_distinct(.)))

unique(subCollege_Data$Apps)
unique(subCollege_Data$Accept)
unique(subCollege_Data$Enroll)

subCollege_Data$Apps <- as.factor(subCollege_Data$Apps)
subCollege_Data$Accept <- as.factor(subCollege_Data$Accept)
subCollege_Data$Enroll <- as.factor(subCollege_Data$Enroll)

newsubCollege_Data <- subCollege_Data[-c(1:740), ]
newsubCollege_Data

p <- ggplot(newsubCollege_Data, aes(x=Apps, y=Enroll, shape = Private, color = X, size = Top25perc)) + 
  geom_point() + 
  labs(x = "Number of Applications", y = "Number of Enrollments", size = "Top 25% Percentage",
       color = "College Names", shape = "Private College") +
  guides(color = guide_legend(order = 1), size = guide_legend(order = 2),
         shape = guide_legend(order = 3),
         fill = guide_legend(order = 4),
         shape.position = "bottom", size.position = "bottom", color.position = "bottom",
         fill.position = "bottom",
         legend.position = "right") +
  ggtitle("Applications vs Enrollments by College Type") +
  theme_bw() 
p

ggMarginal(p, type="density")

ggMarginal(p, type="histogram",fill = "slateblue", xparams = list(  bins=10))

ggMarginal(p, type="boxplot")

#this shows that private colleges not only accept far less applications though mroe that apply do enroll.
#the size shows that the private colleges also reach the top 25% more often.
