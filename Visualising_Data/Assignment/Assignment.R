# Install and load required packages
if (!requireNamespace("leaflet", quietly = TRUE)) {
  install.packages("leaflet")
}
if (!requireNamespace("gridExtra", quietly = TRUE)) {
  install.packages("gridExtra")
}
if (!requireNamespace("sf", quietly = TRUE)) {
  install.packages("sf")
}
if (!requireNamespace("dplyr", quietly = TRUE)) {
  install.packages("dplyr")
}
if (!requireNamespace("readr", quietly = TRUE)) {
  install.packages("readr")
}
if (!requireNamespace("ggplot2", quietly = TRUE)) {
  install.packages("ggplot2")
}
if (!requireNamespace("viridis", quietly = TRUE)) {
  install.packages("viridis")
}
if (!requireNamespace("viridisLite", quietly = TRUE)) {
  install.packages("viridisLite")
}
if (!requireNamespace("animation", quietly = TRUE)) {
  install.packages("animation")
}
if (!requireNamespace("tidyverse", quietly = TRUE)) {
  install.packages("tidyverse")
}
if (!requireNamespace("ggpubr", quietly = TRUE)) {
  install.packages("ggpubr")
}

library(sf)
library(dplyr)
library(readr)
library(leaflet)
library(gridExtra)
library(ggplot2)
library(sf)
library(viridis)
library(animation)
library(tidyverse)
library(ggpubr)
 

# Download the shapefile
url <- "https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_0_countries.zip"
download_path <- "C:/Users/lukeh/Documents/College/4th-Year/Environmental_Analytics/Assignment/ne_10m_admin_0_countries.zip"
download.file(url, download_path)

# Unzip the shapefile
unzip(download_path, exdir = "C:/Users/lukeh/Documents/College/4th-Year/Environmental_Analytics/Assignment/ne_10m_admin_0_countries")

# Read world geometries
shapefile_path <- "C:/Users/lukeh/Documents/College/4th-Year/Environmental_Analytics/Assignment/ne_10m_admin_0_countries/ne_10m_admin_0_countries.shp"
world <- st_read(shapefile_path, quiet = TRUE)

# Print column names
print(names(world))

world <- world %>%
  select(ISO_A3, geometry)

# File paths
world_co2_data <- "C:/Users/lukeh/Documents/College/4th-Year/Environmental_Analytics/Assignment/owid-co2-data.csv"
world_energy_data <- "C:/Users/lukeh/Documents/College/4th-Year/Environmental_Analytics/Assignment/owid-energy-data.csv"
world_powerplant_data <- "C:/Users/lukeh/Documents/College/4th-Year/Environmental_Analytics/Assignment/global_power_plant_database.csv"

# specify the data types as needed
dtype_dict <- list(commissioning_year = "numeric",
                   other_fuel3 = "character")

# Read CSV data into data.frames
co2_data <- read.csv(world_co2_data)
energy_data <- read.csv(world_energy_data)
powerplant_data <- read.csv(world_powerplant_data, colClasses = dtype_dict)

# Examine data
dim(co2_data)
names(co2_data)

dim(energy_data)
names(energy_data)

dim(powerplant_data)
names(powerplant_data)

# Far to many columns. Cut down to the relivant ones.
co2_data <- co2_data[, c('country', 'year', 'iso_code', 'population', 'gdp', 'co2', 'co2_per_capita', 
                         'co2_per_gdp', 'co2_per_unit_energy', 'coal_co2', 'gas_co2', 'oil_co2')]

energy_data <- energy_data[, c('year', 'iso_code', 'electricity_generation', 'energy_per_capita', 'energy_per_gdp', 
                               'fossil_electricity', 'fossil_energy_per_capita', 'renewables_electricity', 'renewables_energy_per_capita')]

powerplant_data <- powerplant_data[, c('country_long', 'name', 'capacity_mw', 'latitude', 'longitude', 'primary_fuel', 
                                       'estimated_generation_gwh_2013', 'estimated_generation_gwh_2015', 'estimated_generation_gwh_2017')]

names(co2_data)
names(energy_data)
names(powerplant_data)

# Much better. Now continue exploring the data.
# Show the column data types
str(co2_data)
str(energy_data)
str(powerplant_data)

# Show unique values of the 'country' column
unique(co2_data$country)

# Show the first few rows of the data frame
head(co2_data)

# Show summary statistics for the data frame
summary(co2_data)
summary(energy_data)
summary(powerplant_data)

# Show the number of missing values for each column
colSums(is.na(co2_data))
colSums(is.na(energy_data))
colSums(is.na(powerplant_data))

# Merge co2_data and energy_data data.frames
merged_data <- inner_join(co2_data, energy_data, by = c("iso_code", "year"))

# Merge merged_data data.frame with world data.frame
final_merged_data <- world %>%
  left_join(merged_data, by = c("ISO_A3" = "iso_code"))

# Shorten the column names
final_merged_data <- final_merged_data %>%
  rename(electr_gen = electricity_generation,
         en_per_cap = energy_per_capita,
         en_per_gdp = energy_per_gdp,
         fossil_el = fossil_electricity,
         fl_per_cap = fossil_energy_per_capita,
         renew_el = renewables_electricity,
         re_per_cap = renewables_energy_per_capita,
         co2_pr_cap = co2_per_capita,
         co2_pr_gdp = co2_per_gdp,
         co2_per_el = co2_per_unit_energy)

# Save the final_merged_data data.frame as a shapefile
output_path <- "C:/Users/lukeh/Documents/College/4th-Year/Environmental_Analytics/Assignment/co2_data_4326.shp"
st_write(final_merged_data, output_path, delete_layer = TRUE)

# Print the head of final_merged_data
head(final_merged_data)

co2_data_4326 <- final_merged_data

# Get dimensions of the data
print(dim(co2_data_4326))

# Get column names
print(colnames(co2_data_4326))

# Get column data types
print(sapply(co2_data_4326, class))

# Get unique countries
print(unique(co2_data_4326$country))

# Check the first five rows
head(co2_data_4326)

# Check the data statistics
summary(co2_data_4326)




# Reproject the sf object to a projected CRS
co2_data_projected <- st_transform(co2_data_4326, 3857)

# Compute the area of each polygon
co2_data_projected$area <- st_area(co2_data_projected)

# Compute the centroid of each polygon
co2_data_projected$centroid <- st_centroid(co2_data_projected)

# Compute the distance between each point and the centroid of its associated polygon
# co2_data_projected$distance <- st_distance(co2_data_projected, co2_data_projected$centroid)

# Filter the sf object for the year 2020
gdf_2020 <- co2_data_4326[co2_data_4326$year == 2020, ]

# Normalize the CO2 emissions for better visualization
norm_co2 <- scale_color_gradient(limits = c(min(gdf_2020$co2), max(gdf_2020$co2)), low = "yellow", high = "red")

# Create a ggplot2 object for the plot
ggplot() + 
  geom_sf(data = gdf_2020, aes(fill = co2)) +
  scale_fill_gradientn(colors = c("yellow", "red")) +
  labs(title = "CO2 Emissions in 2020 (tonnes)", fill = "CO2 (tonnes)") +
  theme_void()



# Create interactive map of co2 per country in 2020
# Filter the co2_data_4326 for the year 2020
co2_data_4326_2000 <- co2_data_4326[co2_data_4326$year == 2020,]

# Create a color palette for the CO2 emissions
co2_color_palette <- colorNumeric("YlOrRd", domain = co2_data_4326_2000$co2, na.color = "white")

# Create a leaflet map
m <- leaflet(co2_data_4326_2000) %>%
  setView(0, 0, zoom = 2) %>%
  addTiles() %>%
  addPolygons(
    fillColor = ~co2_color_palette(co2),
    weight = 2,
    opacity = 1,
    color = "white",
    dashArray = "3",
    fillOpacity = 0.7,
    highlight = highlightOptions(
      weight = 5,
      color = "#666",
      dashArray = "",
      fillOpacity = 0.7,
      bringToFront = TRUE
    ),
    label = ~sprintf("%s: %s", country, co2)
  ) %>%
  addLegend(
    "bottomright",
    pal = co2_color_palette,
    values = ~co2,
    title = "CO2 Emissions in 2020 (tonnes)",
    opacity = 1
  )

# Display the leaflet map
m

# As you can see on the map China is easily the highest produces of CO2 in the world by volume followed by the US. 
# This however does not take into account undeveloped areas with lower populations or the size of the country. 
# To rectify this the CO2 per capita will be used.

# Create interactive map of co2 per capita per country in 2020
# Create a color palette for the CO2 emissions per capita
co2_per_capita_color_palette <- colorNumeric("YlOrRd", domain = co2_data_4326_2000$co2_pr_cap, na.color = "white")

# Create a leaflet map
m2 <- leaflet(co2_data_4326_2000) %>%
  setView(0, 0, zoom = 2) %>%
  addTiles() %>%
  addPolygons(
    fillColor = ~co2_per_capita_color_palette(co2_pr_cap),
    weight = 2,
    opacity = 1,
    color = "white",
    dashArray = "3",
    fillOpacity = 0.7,
    highlight = highlightOptions(
      weight = 5,
      color = "#666",
      dashArray = "",
      fillOpacity = 0.7,
      bringToFront = TRUE
    ),
    label = ~sprintf("%s: %s", country, co2_pr_cap)
  ) %>%
  addLegend(
    "bottomright",
    pal = co2_per_capita_color_palette,
    values = ~co2_pr_cap,
    title = "CO2 Emissions per Capita in 2020 (tonnes)",
    opacity = 1
  )

# Display the leaflet map
m2

# Map of co2 per capita per country on a logarithmic scale in 2020
# Create a copy of the data frame
co2_data_4326_2000_copy <- co2_data_4326_2000

# Apply the natural logarithm transformation to the CO2 per capita column
co2_data_4326_2000_copy$log_co2_pr_cap <- log(co2_data_4326_2000_copy$co2_pr_cap)

# Create a color palette for the logarithmic CO2 emissions per capita
log_co2_per_capita_color_palette <- colorNumeric("YlOrRd", domain = co2_data_4326_2000_copy$log_co2_pr_cap, na.color = "white")

# Create a leaflet map
m_log <- leaflet(co2_data_4326_2000_copy) %>%
  setView(0, 0, zoom = 2) %>%
  addTiles() %>%
  addPolygons(
    fillColor = ~log_co2_per_capita_color_palette(log_co2_pr_cap),
    weight = 2,
    opacity = 1,
    color = "white",
    dashArray = "3",
    fillOpacity = 0.7,
    highlight = highlightOptions(
      weight = 5,
      color = "#666",
      dashArray = "",
      fillOpacity = 0.7,
      bringToFront = TRUE
    ),
    label = ~sprintf("%s: %s", country, co2_pr_cap)
  ) %>%
  addLegend(
    "bottomright",
    pal = log_co2_per_capita_color_palette,
    values = ~log_co2_pr_cap,
    title = "Logarithmic CO2 Emissions per Capita in 2020 (tonnes)",
    opacity = 1
  )

# Display the leaflet map
m_log




# Create interactive map of co2 per capita per country on a logarithmic scale in 2000
# Filter the co2_data_4326 for the year 2020
co2_data_4326_2000 <- co2_data_4326[co2_data_4326$year == 2000,]

# Create a copy of the data frame
co2_data_4326_2000_copy <- co2_data_4326_2000

# Apply the natural logarithm transformation to the CO2 per capita column
co2_data_4326_2000_copy$log_co2_pr_cap <- log(co2_data_4326_2000_copy$co2_pr_cap)

# Create a color palette for the logarithmic CO2 emissions per capita
log_co2_per_capita_color_palette <- colorNumeric("YlOrRd", domain = co2_data_4326_2000_copy$log_co2_pr_cap, na.color = "white")

# Create a leaflet map
m_log <- leaflet(co2_data_4326_2000_copy) %>%
  setView(0, 0, zoom = 2) %>%
  addTiles() %>%
  addPolygons(
    fillColor = ~log_co2_per_capita_color_palette(log_co2_pr_cap),
    weight = 2,
    opacity = 1,
    color = "white",
    dashArray = "3",
    fillOpacity = 0.7,
    highlight = highlightOptions(
      weight = 5,
      color = "#666",
      dashArray = "",
      fillOpacity = 0.7,
      bringToFront = TRUE
    ),
    label = ~sprintf("%s: %s", country, co2_pr_cap)
  ) %>%
  addLegend(
    "bottomright",
    pal = log_co2_per_capita_color_palette,
    values = ~log_co2_pr_cap,
    title = "Logarithmic CO2 Emissions per Capita in 2000 (tonnes)",
    opacity = 1
  )

# Display the leaflet map
m_log



# Animation of rise in CO2 per capita from 1970 to 2020
# WARNING this will take a minute or two
co2_data_4326 <- co2_data_4326 %>%
  mutate(co2_pr_cap_log = log(pmax(co2_pr_cap, 0) + 1e-8)) %>%
  replace_na(list(co2_pr_cap_log = 0))

# Remove Antarctica using the dplyr package
co2_data_4326 <- co2_data_4326 %>% filter(ISO_A3 != "ATA")

global_min <- 0
global_max <- log(max(co2_data_4326$co2_pr_cap) + 1e-8)

# Set ani.options for larger GIF and 0.5-second interval
ani.options(interval = 0.5, fig.width = 40, fig.height = 24)

plot_choropleth <- function(year) {
  data_year <- co2_data_4326[co2_data_4326$year == year,]
  
  p <- ggplot() +
    geom_sf(data = data_year, aes(fill = co2_pr_cap_log), color = "black", size = 0.1) +
    scale_fill_viridis_c(limits = c(global_min, global_max), name = NULL) +  # Remove legend title
    theme_void() +
    theme(
      legend.position = "right",
      plot.title = element_text(hjust = 0.5)
    ) +
    labs(title = sprintf("Logarithm of CO2 Emissions per Capita in %s (tonnes)", year))
  
  return(p)
}

# Save the images as a GIF with a duration of 0.5 seconds per frame
saveGIF({
  for (year in 1970:2020) {
    p <- plot_choropleth(year)
    print(p)
    ggsave(sprintf("frame_%04d.png", year), width = 20, height = 12, dpi = 100)  # Set the desired width and height here
  }
}, "co2_emissions.gif", cmd.fun = function(filename, extra) {
  png_files <- sprintf("frame_%04d.png", 1970:2020)
  system(sprintf("convert %s %s", paste(png_files, collapse = " "), filename))
  file.remove(png_files)
})

# From this we can see the large rise in CO2 production after about the year 2000 as well as the rise then fall of the US in later years. 
# Due to this for the next section where needed I will be focusing on the US while looking at specific renewable power generations in countries.






# Growth in Countries and CO2
# scatter plot of GDP vs CO2 emissions
ggplot(co2_data_4326, aes(x = gdp, y = co2)) +
  geom_point() +
  labs(x = "GDP", y = "CO2 emissions", title = "GDP vs CO2 emissions") +
  theme_minimal()

# Plot of CO2 emissions per capita over time for the US
us_data <- co2_data_4326 %>%
  filter(country == "United States" & year >= 1970 & year <= 2020)

ggplot(us_data, aes(x = year, y = co2_pr_cap)) +
  geom_line() +
  labs(x = "Year", y = "CO2 emissions per capita", title = sprintf("CO2 emissions per capita over time for %s", country)) +
  theme_minimal()


# Plot of CO2 emissions per capita and Population over time for the US
co2_plot <- ggplot(us_data) +
  geom_line(aes(x = year, y = co2_pr_cap, color = "CO2 emissions per capita")) +
  labs(x = "Year", y = "CO2 emissions per capita") +
  scale_color_manual(values = c("CO2 emissions per capita" = "#D62728")) +
  theme_minimal() +
  theme(legend.position = "none")

population_plot <- ggplot(us_data) +
  geom_line(aes(x = year, y = population, color = "Population")) +
  labs(x = "Year", y = "Population") +
  scale_color_manual(values = c("Population" = "#1F77B4")) +
  theme_minimal() +
  theme(legend.position = "none")

gridExtra::grid.arrange(co2_plot, population_plot, ncol = 1)

# Plot of CO2 emissions per capita and Population over time for the US
ggplot(us_data) +
  geom_line(aes(x = year, y = co2_pr_cap, color = "CO2 emissions per capita")) +
  geom_line(aes(x = year, y = fl_per_cap, color = "Fossil fuel consumption per capita")) +
  labs(x = "Year", y = "", title = sprintf("CO2 emissions per capita and Fossil fuel consumption per capita over time for %s", country)) +
  scale_color_manual(values = c("CO2 emissions per capita" = "tab:red", "Fossil fuel consumption per capita" = "tab:blue")) +
  theme_minimal() +
  theme(legend.title = element_blank())

# Plot of CO2 emissions per capita and Fossil fuel consumption per capita over time for the US
co2_plot <- ggplot(us_data) +
  geom_line(aes(x = year, y = co2_pr_cap, color = "CO2 emissions per capita")) +
  labs(x = "Year", y = "CO2 emissions per capita") +
  scale_color_manual(values = c("CO2 emissions per capita" = "#D62728")) +
  theme_minimal() +
  theme(legend.position = "none")

fossil_fuel_plot <- ggplot(us_data) +
  geom_line(aes(x = year, y = fl_per_cap, color = "Fossil fuel consumption per capita")) +
  labs(x = "Year", y = "Fossil fuel consumption per capita") +
  scale_color_manual(values = c("Fossil fuel consumption per capita" = "#1F77B4")) +
  theme_minimal() +
  theme(legend.position = "none")

ggarrange(co2_plot, fossil_fuel_plot, ncol = 1, nrow = 2)


# Plot of CO2 emissions per capita vs Renewable energy consumption per capita over time for the US
co2_plot <- ggplot(us_data) +
  geom_line(aes(x = year, y = co2_pr_cap, color = "CO2 emissions per capita")) +
  labs(x = "Year", y = "CO2 emissions per capita") +
  scale_color_manual(values = c("CO2 emissions per capita" = "#D62728")) +
  theme_minimal() +
  theme(legend.position = "none")

renewable_energy_plot <- ggplot(us_data) +
  geom_line(aes(x = year, y = re_per_cap, color = "Renewable energy consumption per capita")) +
  labs(x = "Year", y = "Renewable energy consumption per capita") +
  scale_color_manual(values = c("Renewable energy consumption per capita" = "#1F77B4")) +
  theme_minimal() +
  theme(legend.position = "none")

ggarrange(co2_plot, renewable_energy_plot, ncol = 1, nrow = 2)










# Power plants in the world
# WARNING R cannot run this because of the size.
# I had to run this in python to get the image but you can try on your machine

# Create a new data frame with only the necessary columns
powerplant_geo <- powerplant_data %>%
  select(name, primary_fuel, capacity_mw, latitude, longitude)

# Define a function to determine the color based on the primary fuel type
fuel_color <- function(fuel) {
  fossil_fuels <- c("Gas", "Other", "Oil", "Nuclear", "Coal", "Petcoke", "Storage", "Cogeneration")
  renewable_fuels <- c("Waste", "Hydro", "Solar", "Wind", "Wave and Tidal", "Biomass", "Geothermal")
  
  if (fuel %in% fossil_fuels) {
    return("red")
  } else if (fuel %in% renewable_fuels) {
    return("green")
  } else {
    return("gray")
  }
}

# Initialize a leaflet map
map_powerplants <- leaflet() %>%
  addTiles() %>%
  setView(lng = 0, lat = 0, zoom = 2)

# Add power plant markers to the map
for (i in 1:nrow(powerplant_geo)) {
  row <- powerplant_geo[i, ]
  color <- fuel_color(row$primary_fuel)
  map_powerplants <- map_powerplants %>%
    addCircleMarkers(
      lng = row$longitude,
      lat = row$latitude,
      radius = row$capacity_mw / 1000,
      color = color,
      fillColor = color,
      fillOpacity = 0.5,
      popup = sprintf("%s (%s) - %s MW", row$name, row$primary_fuel, row$capacity_mw)
    )
}

# Display the map
map_powerplants





# Filter data by year
co2_data_4326_2019 <- co2_data_4326 %>% filter(year == 2020)

# Create a leaflet map object
m <- leaflet() %>%
  addTiles() %>%
  setView(lng = 0, lat = 30, zoom = 2)

# Create color scales for each layer
co2_color_scale <- colorQuantile("OrRd", co2_data_4326_2019$co2_pr_cap, n = 7)
re_color_scale <- colorQuantile("YlGn", co2_data_4326_2019$re_per_cap, n = 7)
ff_color_scale <- colorQuantile("PuBu", co2_data_4326_2019$fl_per_cap, n = 7)

# Add a layer for CO2 emissions per capita
m <- m %>% addPolygons(data = co2_data_4326_2019,
                       fillColor = ~co2_color_scale(co2_pr_cap),
                       fillOpacity = 0.7,
                       weight = 1,
                       color = "white",
                       opacity = 0.2,
                       label = ~paste(country, ":", round(co2_pr_cap, 2)),
                       group = "CO2 Emissions per Capita")

# Add a layer for renewable energy consumption per capita
m <- m %>% addPolygons(data = co2_data_4326_2019,
                       fillColor = ~re_color_scale(re_per_cap),
                       fillOpacity = 0.7,
                       weight = 1,
                       color = "white",
                       opacity = 0.2,
                       label = ~paste(country, ":", round(re_per_cap, 2)),
                       group = "Renewable Energy Consumption per Capita")

# Add a layer for fossil fuel consumption per capita
m <- m %>% addPolygons(data = co2_data_4326_2019,
                       fillColor = ~ff_color_scale(fl_per_cap),
                       fillOpacity = 0.7,
                       weight = 1,
                       color = "white",
                       opacity = 0.2,
                       label = ~paste(country, ":", round(fl_per_cap, 2)),
                       group = "Fossil Fuel Consumption per Capita")

# Add legends for each layer
m <- m %>% addLegend(pal = co2_color_scale, values = co2_data_4326_2019$co2_pr_cap,
                     title = "CO2 Emissions per Capita (metric tons)",
                     position = "bottomleft",
                     group = "CO2 Emissions per Capita")

m <- m %>% addLegend(pal = re_color_scale, values = co2_data_4326_2019$re_per_cap,
                     title = "Renewable Energy Consumption per Capita (kWh)",
                     position = "bottomleft",
                     group = "Renewable Energy Consumption per Capita")

m <- m %>% addLegend(pal = ff_color_scale, values = co2_data_4326_2019$fl_per_cap,
                     title = "Fossil Fuel Consumption per Capita (kWh)",
                     position = "bottomleft",
                     group = "Fossil Fuel Consumption per Capita")

# Add layer controls to the map
m <- m %>% addLayersControl(
  overlayGroups = c("CO2 Emissions per Capita",
                    "Renewable Energy Consumption per Capita",
                    "Fossil Fuel Consumption per Capita"),
  options = layersControlOptions(collapsed = FALSE)
)

# Display the map
m




