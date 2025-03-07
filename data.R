library(shiny)
library(leaflet)
library(dplyr)
library(ggplot2)
library(plotly)

# Our process in deciding how we wanted to manipulate the data
# We wrote the modified data set to a new csv to decrease the app load time

# collision.data <- read.csv("./SDOT_Collisions.csv", stringsAsFactors = FALSE)
# collision.data[collision.data==""] <- NA
# collision.data$INATTENTIONIND[is.na(collision.data$INATTENTIONIND)] <- "N"
# 
# coordinates <- collision.data$Shape
# lat <- sapply(strsplit(coordinates, split=", "), "[", 1)
# lng <- sapply(strsplit(coordinates, split=", "), "[", 2)
# lat <- gsub("\\(", "", lat)
# lng <- gsub(")", "", lng)
# lat <- signif(as.numeric(lat), 8)
# lng <- signif(as.numeric(lng), 8)
# 
# date <- collision.data$INCDTTM
# time <- sapply(strsplit(date, split=" "), "[", 2)
# hour <- sapply(strsplit(time, split=":"), "[", 1)
# time.of.day <- sapply(strsplit(date, split=" "), "[", 3)
# date <- sapply(strsplit(date, split=" "), "[", 1)
# year <- as.numeric(sapply(strsplit(date, split="/"), "[", 3))
# 
# collision.data <- mutate(collision.data, "Latitude" = lat, "Longitude" = lng, "YEAR" = year, "DATE" = date,
#                          "TIME" = time, "HOUR" = hour, "TIME_OF_DAY" = time.of.day) %>%
#   select(FATALITIES, INATTENTIONIND, INJURIES, LIGHTCOND, LOCATION, PERSONCOUNT,
#          ROADCOND, SDOT_COLDESC, SEVERITYCODE, SEVERITYDESC, WEATHER, Latitude,
#          Longitude, DATE, YEAR, TIME, HOUR, TIME_OF_DAY)
# 
# collision.data <- na.omit(collision.data)
# 
# hour <- as.numeric(collision.data$HOUR)
# time.of.day <- (collision.data$TIME_OF_DAY)
# time <- data.frame(time.of.day, hour, stringsAsFactors = FALSE)
# 
# time <- within(time, hour[time.of.day == "PM"] <- hour[time.of.day == "PM"] + 12)
# time <- within(time, hour[hour == "24"] <- 0)
# 
# hour <- time$hour
# minute <- sapply(strsplit(collision.data$TIME, split=":"), "[", 2)
# time <- paste0(hour, ":", minute)
# 
# collision.data <- mutate(collision.data, "TIME" = time, "HOUR" = hour, "MINUTE" = minute) %>%
#   filter(YEAR >= 2007)
# 
# write.csv(collision.data, "Filtered_SDOT_Collisions.csv")


# Reads in the modified data set csv file
collision.data <- read.csv("./Filtered_SDOT_Collisions.csv", stringsAsFactors = FALSE)

# Set the coordinate limits for the relevant Seattle neighborhoods
ballard.limits <- list(upper.lng = -122.360702, upper.lat = 47.690566, lower.lng = -122.410012, lower.lat = 47.655839)
phinney.ridge.limits <- list(upper.lng = -122.344423, upper.lat = 47.686954, lower.lng = -122.366053, lower.lat = 47.662190)
fremont.limits <- list(upper.lng = -122.342510, upper.lat = 47.665045, lower.lng = -122.367444, lower.lat = 47.648536)
greenwood.limits <- list(upper.lng = -122.344608, upper.lat = 47.705067, lower.lng = -122.365980, lower.lat = 47.683229)
university.district.limits <- list(upper.lng = -122.286484, upper.lat = 47.671793, lower.lng = -122.322104, lower.lat = 47.647687)
green.lake.limits <- list(upper.lng = -122.320072, upper.lat = 47.690502, lower.lng = -122.347323, lower.lat = 47.671085)
maple.leaf.limits <- list(upper.lng = -122.304198, upper.lat = 47.708535, lower.lng = -122.328403, lower.lat = 47.683058)
magnolia.limits <- list(upper.lng = -122.393264, upper.lat = 47.661892, lower.lng = -122.409122, lower.lat = 47.648398)
queen.anne.limits <- list(upper.lng = -122.356687, upper.lat = 47.644524, lower.lng = -122.373650, lower.lat = 47.637816)
capitol.hill.limits <- list(upper.lng = -122.318215, upper.lat = 47.629830, lower.lng = -122.321305, lower.lat = 47.621153)


# Selects data sets for each neighborhood based on their latitude and longitude limits
ballard.data <- collision.data %>% 
  filter(Longitude < ballard.limits$upper.lng & Longitude > ballard.limits$lower.lng) %>% 
  filter(Latitude < ballard.limits$upper.lat & Latitude > ballard.limits$lower.lat)

phinney.ridge.data <- collision.data %>% 
  filter(Longitude < phinney.ridge.limits$upper.lng & Longitude > phinney.ridge.limits$lower.lng) %>% 
  filter(Latitude < phinney.ridge.limits$upper.lat & Latitude > phinney.ridge.limits$lower.lat)

fremont.data <- collision.data %>% 
  filter(Longitude < fremont.limits$upper.lng & Longitude > fremont.limits$lower.lng) %>% 
  filter(Latitude < fremont.limits$upper.lat & Latitude > fremont.limits$lower.lat)

greenwood.data <- collision.data %>% 
  filter(Longitude < greenwood.limits$upper.lng & Longitude > greenwood.limits$lower.lng) %>% 
  filter(Latitude < greenwood.limits$upper.lat & Latitude > greenwood.limits$lower.lat)

university.district.data <- collision.data %>% 
  filter(Longitude < university.district.limits$upper.lng & Longitude > university.district.limits$lower.lng) %>% 
  filter(Latitude < university.district.limits$upper.lat & Latitude > university.district.limits$lower.lat)

green.lake.data <- collision.data %>% 
  filter(Longitude < green.lake.limits$upper.lng & Longitude > green.lake.limits$lower.lng) %>% 
  filter(Latitude < green.lake.limits$upper.lat & Latitude > green.lake.limits$lower.lat)

maple.leaf.data <- collision.data %>% 
  filter(Longitude < maple.leaf.limits$upper.lng & Longitude > maple.leaf.limits$lower.lng) %>% 
  filter(Latitude < maple.leaf.limits$upper.lat & Latitude > maple.leaf.limits$lower.lat)

magnolia.data <- collision.data %>% 
  filter(Longitude < magnolia.limits$upper.lng & Longitude > magnolia.limits$lower.lng) %>% 
  filter(Latitude < magnolia.limits$upper.lat & Latitude > magnolia.limits$lower.lat)

queen.anne.data <- collision.data %>% 
  filter(Longitude < queen.anne.limits$upper.lng & Longitude > queen.anne.limits$lower.lng) %>% 
  filter(Latitude < queen.anne.limits$upper.lat & Latitude > queen.anne.limits$lower.lat)

capitol.hill.data <- collision.data %>% 
  filter(Longitude < capitol.hill.limits$upper.lng & Longitude > capitol.hill.limits$lower.lng) %>% 
  filter(Latitude < capitol.hill.limits$upper.lat & Latitude > capitol.hill.limits$lower.lat)

# Sets the latitude and longitude for the center of the neighborhoods
neighborhood.lng <- c(-122.385, -122.35438, -122.3499, -122.3553, -122.306158, -122.327778, 
                      -122.316873, -122.400833, -122.356944, -122.316456)
neighborhood.lat <- c(47.677, 47.672139, 47.6505, 47.690612, 47.661427, 47.680278, 
                      47.695833, 47.650556, 47.637222, 47.622942)

# Names of neighborhoods to be used in grouping data
neighborhood <- c("Ballard", "Phinney Ridge", "Fremont", "Greenwood", "University District", "Green Lake", 
                  "Maple Leaf", "Magnolia", "Queen Anne", "Capitol Hill")

