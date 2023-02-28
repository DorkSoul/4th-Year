library(tidyverse)

# Get an average value for MPG for cyl (number of cylinders) and am (transmission type (automatic or manual))
avg_mpg <- mtcars %>%
        group_by(cyl, am) %>%
        summarize_at(vars(mpg),list(mpg=mean))

avg_mpg

avg_mpg$Transmission = as.character(avg_mpg$am)
avg_mpg[avg_mpg$am==0,]$Transmission='Manual'
avg_mpg[avg_mpg$am==1,]$Transmission='Automatic'
p2 <- ggplot(avg_mpg, aes(factor(cyl), mpg, fill = Transmission)) +
        geom_bar(stat = "identity", position = "dodge", color = "grey40") +
        ggtitle("Default color comparison")
p2



