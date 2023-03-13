# Run any of the install.packages() commands below for packages that are not yet on your system
#install.packages("shiny") 
#install.packages("urltools")
#install.packages("tmap")
#install.packages("leaflet")
#install.packages("leaflet.extras")
#install.packages("rio")
#install.packages("scales")
#install.packages("htmlwidgets")
#install.packages("sf")
#install.packages("dplyr")
#install.packages("rgdal")
library(raster)
library(rgdal)
library(ggplot2)
library(broom)
library(RColorBrewer)
library(dplyr)
library(ggsn)
# set factors to false
options(stringsAsFactors = FALSE)
library("tmap")
library("scales")
library("leaflet")
library("sf")
library("leaflet.extras")
library("stringr")

setwd("C:/Users/lukeh/Documents/College/4th-Year/Visualising_Data/Week 6")

if (Sys.info()["sysname"][1]=="Darwin"){
  mydata = file.path("~","Dropbox","City","pobyrne","Contents","Datasets")
} else {
  mydata = file.path("C:","Users","lukeh","Documents","College","4th-Year","Visualising_Data","week 6")
}
mydata

datapath <-file.path(mydata,'IRCountyPop.csv')

irshapefile <- file.path(mydata,'IRshapefile')

ogrListLayers(dsn=irshapefile)

IRgeo <-readOGR(irshapefile,layer="IRL_adm1") #We only want x and y dimensions.

str(IRgeo)

qtm(IRgeo)

IRgeo

colnames(IRgeo@data)[5]

colnames(IRgeo@data)[5] = 'County'

qtm(IRgeo,  text="County")

IRgeo@data$Province <- sapply(IRgeo@data$County, switch, 
                              
                              'Carlow' = 'Leinster',
                              'Cavan' = 'Ulster',
                              'Clare' = 'Munster',
                              'Cork' = 'Munster',
                              'Donegal' = 'Ulster',
                              'Dublin' = 'Leinster',
                              'Galway' = 'Connaught',
                              'Kerry' =  'Munster',
                              'Kildare' = 'Leinster',
                              'Kilkenny' = 'Leinster',
                              'Laoighis' = 'Leinster',
                              'Leitrim' = 'Connaught',
                              'Limerick' =  'Munster',
                              'Longford' = 'Leinster',
                              'Louth' = 'Leinster',
                              'Mayo' = 'Connaught',
                              'Meath' = 'Leinster',
                              'Monaghan' = 'Ulster',
                              'Offaly' = 'Leinster',
                              'Roscommon' = 'Connaught',
                              'Sligo' = 'Connaught',
                              'Tipperary' =  'Munster',
                              'Waterford' =  'Munster',
                              'Westmeath' = 'Leinster',
                              'Wexford' = 'Leinster',
                              'Wicklow' = 'Leinster')

qtm(IRgeo, fill = 'Province', text = 'County', text.size = 0.5)










popdata<-read.csv(datapath)
print(head(popdata,10))
print("Number of NAs per column")
sapply(popdata, function(x) sum(is.na(x)))

# Rename 'county' column to 'County'
colnames(popdata)[1] <- 'County'

# Order each data set by county name
IRgeo <- IRgeo[order(IRgeo$County),]
popdata <- popdata[order(popdata$County),]

popdata <- popdata%>% filter(!County =="Antrim")
popdata <- popdata%>% filter(!County =="Armagh")
popdata <- popdata%>% filter(!County =="Derry")
popdata <- popdata%>% filter(!County =="Down")
popdata <- popdata%>% filter(!County =="Fermanagh")
popdata <- popdata%>% filter(!County =="Tyrone")

# Are the two county columns identical now? They should be:
identical(IRgeo$County,popdata$County )


# Merge data to associate the election data (nhdata) with the spatial polygon dataframe
IRmap <- merge(IRgeo, popdata, by.x="County", by.y="County")
# See the new data structure with
str(IRmap)

# Quick and easy maps as static images with tmap's qtm() function:
qtm(IRmap, fill = 'Province', text = 'County', text.size = 0.5)

qtm(IRmap, fill = 'pop1841', text = 'County', text.size = 0.5)

qtm(IRmap, fill = 'pop1901', text = 'County', text.size = 0.5)

qtm(IRmap, fill = 'pop2001', text = 'County', text.size = 0.5)

# For more control over look and feel, use the tm_shape() function:
IRstaticmap <-tm_shape(IRmap) +
  tm_fill("pop1841", title="population in 1841", palette = "OrRd")+
  tm_borders(alpha=.5) +
  tm_text("County",size=0.8) +
  tm_style("classic")
IRstaticmap


# For more control over look and feel, use the tm_shape() function:
IRstaticmap <-tm_shape(IRmap) +
  tm_fill("pop1901", title="population in 1901", palette = "OrRd")+
  tm_borders(alpha=.5) +
  tm_text("County",size=0.8) +
  tm_style("classic")
IRstaticmap

# For more control over look and feel, use the tm_shape() function:
IRstaticmap <-tm_shape(IRmap) +
  tm_fill("pop2001", title="population in 2001", palette = "OrRd")+
  tm_borders(alpha=.5) +
  tm_text("County",size=0.8) +
  tm_style("classic")
IRstaticmap




# subset of years
yeardata <- subset(popdata, select=c('County','pop1841','pop1901','pop1951','pop1981','pop2001'))
yeardata

# create a min and max and pallete for each year
maxpop <- max(c(yeardata$pop1841, yeardata$pop1901, yeardata$pop1951, yeardata$pop1981, yeardata$pop2001))


minpop <- min(c(yeardata$pop1841, yeardata$pop1901, yeardata$pop1951, yeardata$pop1981, yeardata$pop2001))

# create palette for each
PaletteReds <- colorNumeric(palette = "Reds", domain=c(minpop, maxpop))
PaletteGreens <- colorNumeric(palette = "Greens", domain = c(minpop, maxpop))
PaletteBlues <- colorNumeric(palette = "Blues", domain = c(minpop, maxpop))
PaletteOranges <- colorNumeric(palette = "Oranges", domain = c(minpop, maxpop))
PalettePurples <- colorNumeric(palette = "Purples", domain = c(minpop, maxpop))

# and a pop-up window
#library(scales)
IRpopup <- paste0("<b>County: ", 
                  yeardata$county, 
                  "</b><br />Population 1841: ", 
                  yeardata$pop1841,
                  "</b><br />Population 1901: ",
                  yeardata$pop1901,
                  "</b><br />Population 1951: ",
                  yeardata$pop1951,
                  "</b><br />Population 1981: ",
                  yeardata$pop1981,
                  "</b><br />Population 2001: ",
                  yeardata$pop2001)

IRpopup

# Add the projection we know from the NH map we'll need for this data on a Leaflet map:
IRmap <- sf::st_transform(IRmap, "+proj=longlat +datum=WGS84")

# Put top 5 candidates in their own layers and add education layer, store in scGOPmap2 variable
library(tidyverse)
IRGOPmap2 <- leaflet(IRmap) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(stroke=TRUE,
              weight=1,
              smoothFactor = 0.2, 
              fillOpacity = .75, 
              popup=IRpopup, 
              color= ~PaletteReds(yeardata$pop1841),
              group="1841"
  ) %>% 
  addLegend(position="bottomleft", colors=c("#DC143C", "#32CD32", "#4169E1", "#FF8C00", "#9370DB"),
            labels=c("Population 1841","Population 1901", "Population 1951", "Population 1981", "Population 2001"))   %>%
  
  addPolygons(stroke=TRUE,
              weight=1,
              smoothFactor = 0.2, 
              fillOpacity = .75, 
              popup=IRpopup, 
              color= ~PaletteGreens(yeardata$pop1901),
              group="1901"
  ) %>%
  
  addPolygons(stroke=TRUE,
              weight=1,
              smoothFactor = 0.2, 
              fillOpacity = .75, 
              popup=IRpopup, 
              color= ~PaletteBlues(yeardata$pop1951),
              group="1951"
  ) %>%
  
  addPolygons(stroke=TRUE,
              weight=1,
              smoothFactor = 0.2, 
              fillOpacity = .75, 
              popup=IRpopup, 
              color= ~PaletteOranges(yeardata$pop1981),
              group="1981"
  ) %>%
  
  addPolygons(stroke=TRUE,
              weight=1,
              smoothFactor = 0.2, 
              fillOpacity = .75, 
              popup=IRpopup, 
              color= ~PalettePurples(yeardata$pop2001),
              group="2001"
  ) %>%
  
addLayersControl(
  baseGroups=c("1841", "1901", "1951", "1981", "2001"),
  position = "bottomleft",
  options = layersControlOptions(collapsed = FALSE)
) 
IRGOPmap2


#install.packages('htmlwidgets')
library(htmlwidgets)
#install.packages('pandoc')
library(pandoc)

saveWidget(IRGOPmap2, 'IRGOPmap2.html', selfcontained = FALSE,)
tmap_save(IRGOPmap2, filename="IRGOPmap2.html")s





