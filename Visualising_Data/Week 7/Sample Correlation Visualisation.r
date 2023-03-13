#?mtcars

library(tidyverse)
library(corrplot)
library(GGally)
library(ggExtra)

options(repr.plot.width=12, repr.plot.height=12)
df <- mtcars
df
plot(df)

summary(df)

colnames(df)

df1 <- subset(df, select=c(mpg, cyl, wt, am))

options(repr.plot.width=8, repr.plot.height=8)
plot(df1)

ggpairs(df)


M = cor(df1)
corrplot(M)

corrplot(M, method = 'number') # colorful number

corrplot(M, method = 'color', order = 'alphabet')

corrplot.mixed(M, lower = 'shade', upper = 'pie', order = 'hclust')

# if(!require(devtools)) install.packages("devtools")
# devtools::install_github("kassambara/ggpubr")

library(ggpubr)

ggscatter(df, x = "mpg", y = "wt", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "pearson",
          xlab = "Miles/(US) gallon", ylab = "Weight (1000 lbs)")

# mpg
ggqqplot(df$mpg, ylab = "MPG")
# wt
ggqqplot(df$wt, ylab = "WT")

str(df)

df %>% summarise_all(list(~n_distinct(.)))

unique(df$gear)
unique(df$cyl)
unique(df$am)

df$NumberOfGears <- as.factor(df$gear)
df$Cylinders <- as.factor(df$cyl)
df$TransmissionMode <- as.factor(df$am)



p <- ggplot(df, aes(x=wt, y=mpg, shape = Cylinders, color = TransmissionMode, size = NumberOfGears)) +  # shape = color
  geom_point()+ theme_bw()+
theme(legend.position="bottom") 
p

ggMarginal(p, type="density")

ggMarginal(p, type="histogram",fill = "slateblue", xparams = list(  bins=10))

ggMarginal(p, type="boxplot")




