install.packages("tweenr")
install.packages("devtools")
# install.packages("gganimate")
library(devtools)
devtools::install_github("dgrtwo/gganimate")
devtools::install_github("hrbrmstr/streamgraph")

library(tidyverse)
library(gganimate)
library(streamgraph)

install.packages("gifski")
library("gifski")

mydata = file.path("C:","Users","lukeh","Documents","College","4th-Year","Visualising_Data")
datapath = file.path(mydata,"seaice.csv")
df <- read.csv(datapath)
str(df)

df <- subset(df, select= (-c(Source.Data)))

head(df)

df <- 
df %>%
group_by(Year, Month, hemisphere) %>%
summarise_at (vars(Extent), list(Monthly_Extent=sum))
dfice <- df

head(dfice)

unique(df$hemisphere)
unique(df$Year)
unique(df$Month)

p <- ggplot(dfice[dfice$Year==1979,], aes(x=Month, y= Monthly_Extent, color=hemisphere)) + geom_line(linewidth=2) + theme_bw() + 
scale_x_continuous(breaks=c(1,2,3,4,5,6,7,8,9,10,11,12)) +
labs(x = "Month", y = "Ice Extent")
p


head(dfice)

colnames(dfice)
unique(df$hemisphere)

head(dfice[dfice$Year==1980,],2)

options(repr.plot.width=12,repr.plot.height=6)
ggplot(dfice, aes(x = Month, y = Monthly_Extent,  color=hemisphere, size=2))+theme_bw() +
 geom_point(aes(size=2))+
 guides(size = FALSE)+  
 labs(subtitle = 'Year: {frame_time}',
       title = 'Sea Ice Extents',
       x = 'Month', y = 'Ice Extent (10^6 sq km)',  fill='hemisphere')+
  transition_time(Year) +
scale_x_continuous(breaks=c(1,2,3,4,5,6,7,8,9,10,11,12)) 

anim_save("GP5.gif", animation = last_animation())
display_gif <- function(raw){
    contents <- base64enc::base64encode(raw)
    tag <- '<img src="data:image/gif;base64,%s">'
    IRdisplay::display_html(sprintf(tag, contents))
}
display_gif("GP5.gif")

#install.packages("babynames")
library(babynames)

str(babynames)

babynames %>%
  filter(grepl("^Pat", name)) %>%
  group_by(year, name) %>%
  tally(wt=n) %>%
  streamgraph("name", "n", "year", offset="zero", interpolate="linear") %>%
  sg_legend(show=TRUE, label="Pat - names: ")



list1950 <- c("Linda","James","Mary","Robert","Patricia","John","Barbara","Michael","Susan","David")

names1950s <- babynames[babynames$name %in% list1950,]
names1950s <-names1950s %>%
group_by(name,year) %>%
summarise_at(vars(n), list(total=sum))
#head(names1950s)
ggplot (names1950s, aes(x=year, y=total, fill=name)) + geom_stream()


names1950s%>% 
  streamgraph(key="name", value="total", date="year") %>%
  sg_fill_brewer("PuOr")


list1990 <- c("Michael", "Jessica", "Christopher", "Ashley", "Matthew", "Emily", "Joshua", "Sarah", "Jacob", "Samantha")
names1990s <- babynames[babynames$name %in% list1990,]
names1990s <-names1990s %>%
group_by(name,year) %>%
summarise_at(vars(n), list(total=sum))
#head(names1990s)
names1990s%>% 
  streamgraph(key="name", value="total", date="year") %>%
  sg_fill_brewer("PuOr")

ggplot (names1990s, aes(x=year, y=total, fill=name)) + geom_stream()


list2023 <- c("Luxury", "Maeve", "Aurelia", "Isla", "Luna", "Kylian", "Theodore", "Atticus", "Felix", "Silas")
names2023 <- babynames[babynames$name %in% list2023,]
names2023 <-names2023 %>%
group_by(name,year) %>%
summarise_at(vars(n), list(total=sum))
#head(names2023)
ggplot (names2023, aes(x=year, y=total, fill=name)) + geom_stream()

names2023%>% 
  streamgraph(key="name", value="total", date="year") %>%
  sg_fill_brewer("PuOr")

