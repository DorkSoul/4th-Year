# Load required packages
library(sf)
library(dplyr)
library(readr)
# install.packages("gridExtra")
library(gridExtra)
library(ggplot2)

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

# Read CSV data into data.frames
co2_data <- read_csv(world_co2_data)
energy_data <- read_csv(world_energy_data)

# Select only the relevant columns
co2_data <- co2_data %>%
  select(country, year, iso_code, population, gdp, co2, co2_per_capita, 
         co2_per_gdp, co2_per_unit_energy, coal_co2, gas_co2, oil_co2)

energy_data <- energy_data %>%
  select(year, iso_code, electricity_generation, energy_per_capita, energy_per_gdp,
         fossil_electricity, fossil_energy_per_capita, renewables_electricity, renewables_energy_per_capita)

# Merge co2_data and energy_data data.frames
merged_data <- inner_join(co2_data, energy_data, by = c("iso_code", "year"))

# Read world geometries


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








# Subset the data for a specific country (e.g., United States)
country <- "United States"
us_data <- co2_data_4326[co2_data_4326$country == country,]

# Create the four plots
plot1 <- ggplot(us_data, aes(x = year, y = co2_pr_cap)) +
  geom_line() +
  labs(title = paste("CO2 Emissions per Capita for", country),
       x = "Year",
       y = "CO2 Emissions per Capita")

plot2 <- ggplot(us_data, aes(x = year, y = en_per_cap)) +
  geom_line(color = "orange") +
  labs(title = paste("Energy Consumption per Capita for", country),
       x = "Year",
       y = "Energy Consumption per Capita")

plot3 <- ggplot(us_data, aes(x = year, y = fl_per_cap)) +
  geom_line(color = "darkgreen") +
  labs(title = paste("Fossil Fuel Consumption per Capita for", country),
       x = "Year",
       y = "Fossil Fuel Consumption per Capita")

plot4 <- ggplot(us_data, aes(x = year, y = re_per_cap)) +
  geom_line(color = "red") +
  labs(title = paste("Renewable Energy Consumption per Capita for", country),
       x = "Year",
       y = "Renewable Energy Consumption per Capita")

# Combine and display the four plots using the gridExtra package
grid.arrange(plot1, plot2, plot3, plot4, nrow = 2)








# Install and load required packages
if (!requireNamespace("leaflet", quietly = TRUE)) {
  install.packages("leaflet")
}
library(leaflet)

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




