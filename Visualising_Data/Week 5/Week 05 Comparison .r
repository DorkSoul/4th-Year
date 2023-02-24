library(ggplot2)

data(airquality)

str(airquality)

# basic histogram
p <- ggplot(airquality, aes(x=Temp)) + 
  geom_histogram(bins=10)
p

ggplot(airquality, aes(x=Ozone, na.rm = TRUE)) + 
  geom_histogram(bins=25)

p <- ggplot(airquality, aes(x=Wind)) + 
  geom_histogram(bins=20,fill="Yellow", color="Blue") +
  geom_freqpoly(binwidth=1,color="Red")
p

ggplot(airquality, aes(x=Solar.R)) + 
  geom_histogram(bins=50)

ggplot(faithful, aes(x = waiting)) +
    geom_histogram(bins=30, fill = "yellow", color = "black", aes(y =..density..)) +
geom_density(col="black", linewidth=2) + theme_bw() +
theme(
legend.position='none')


str(mtcars)

ggplot(mtcars, aes(x=as.factor(cyl), y=mpg)) + 
    geom_boxplot(fill="slateblue", alpha=0.2) + 
    xlab("cyl")

lst <- sort(mtcars[mtcars$cyl==8,]$mpg)

median(lst)
quantile (lst)
qs <-quantile (lst)
IQR (lst)
qs[2] # Q3
qs[4] # Q1

IQR <- qs[4] - qs[2]
IQR * 1.5

min = 14.3 - 2.775
min

max = 15.8 + 2.775
max

ggplot(mtcars, aes(x=as.factor(gear), y=mpg, fill=gear)) + geom_boxplot()

str(mpg)

theme_set(theme_classic())

# Plot
g <- ggplot(mpg, aes(class, cty))
g + geom_boxplot(varwidth=T, fill="plum") + 
    labs(title="Box plot", 
         subtitle="City Mileage grouped by Class of vehicle",
         caption="Source: mpg",
         x="Class of Vehicle",
         y="City Mileage")


theme_set(theme_classic())

# Plot
g <- ggplot(mpg, aes(cty))
g + geom_density(aes(fill=factor(cyl)), alpha=0.8) + 
    labs(title="Density plot", 
         subtitle="City Mileage Grouped by Number of cylinders",
         caption="Source: mpg",
         x="City Mileage",
         fill="# Cylinders")

# Library
#install.packages("fmsb")
library(fmsb)
 
# Create data: set up max and min results in each subjectl
data <- as.data.frame(matrix( sample( 2:20 , 10 , replace=T) , ncol=10))
colnames(data) <- c(
    "math" , "english" , "biology" ,
    "music" , "R-coding", "data-viz" ,
    "french" , "physic", "statistic", "sport" )
 
# To use the fmsb package, I have to add 2 lines to the dataframe: 
# the max and min of each topic to show on the plot!
data <- rbind(rep(20,10) , rep(0,10) , data)
 
# Check your data, it has to look like this!
head(data)

# The default radar chart 
radarchart(data)

# library
#install.packages("treemap")
library(treemap)
 
# Create data
group <- c("group-1","group-2","group-3")
value <- c(13,5,22)
data <- data.frame(group,value)

data

 
# treemap
treemap(data,
            index="group",
            vSize="value",
            type="index"
            )


# Build hierarchical Dataset
group <- c(rep("group-1",4),rep("group-2",2),rep("group-3",3))
subgroup <- paste("subgroup" , c(1,2,3,4,1,2,1,2,3), sep="-")
value <- c(13,5,22,12,11,7,3,1,23)
data <- data.frame(group,subgroup,value)
 

data

# treemap
treemap(data,
            index=c("group","subgroup"),
            vSize="value",
            type="index"
            ) 

library(gapminder)
str(gapminder)

library(sqldf)
gm1952=sqldf("select continent, country,
pop/10000 pop from gapminder where year = 1952")
gm2007=sqldf("select continent, country,
pop/10000 pop from gapminder where year = 2007")

treemap(gm1952,
            index=c("continent","country"),
            vSize="pop",
            type="index"
            ) 

treemap(gm2007,
            index=c("continent","country"),
            vSize="pop",
            type="index"
            ) 

str(mtcars)

mtcars$group = as.factor(mtcars$gear)
ggplot(mtcars, aes(x = hp, fill = group)) +   
# Draw overlaying histogram
  geom_histogram(position = "identity", alpha = 0.2, bins = 50)

str(diamonds)

ggplot(diamonds, aes(x = price, fill = cut)) +   
# Draw overlaying histogram
  geom_histogram(position = "identity", alpha = 0.2, bins = 50)

theme_set(theme_bw())  

 # create new column for car names
mtcars$carname <- rownames(mtcars) 
# compute normalized mpg
mtcars$mpg_z <- round((mtcars$mpg - mean(mtcars$mpg))/sd(mtcars$mpg), 2)

# above / below avg flag
mtcars$mpg_type <- ifelse(mtcars$mpg_z < 0, "below", "above") 
# sort
mtcars <- mtcars[order(mtcars$mpg_z), ] 
# convert to factor to retain sorted order in plot.
mtcars$carname <- factor(mtcars$carname, levels = mtcars$carname)  

str(mtcars)

# Diverging Barcharts
ggplot(mtcars, aes(x=carname, y=mpg_z, label=mpg_z)) + 
  geom_bar(stat='identity', aes(fill=mpg_type), width=.5)  +
  scale_fill_manual(name="Mileage", 
                    labels = c("Above Average", "Below Average"), 
                    values = c("above"="#00ba38", "below"="#f8766d")) + 
  labs(subtitle="Normalised mileage from 'mtcars'", 
       title= "Diverging Bars") + 
  coord_flip()

str(diamonds)


ggplot(data=diamonds, aes(x=price)) +
  geom_histogram(binwidth=500) +
  facet_wrap(~cut)

