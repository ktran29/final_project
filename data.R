library(dplyr)
#setwd("~/Dropbox/Classes/INFO201/Project/final_project")

collision.data <- read.csv("./SDOT_Collisions.csv", stringsAsFactors = FALSE)
collision.data[collision.data==""] <- NA

coordinates <- collision.data$Shape
date <- collision.data$INCDATE

lat <- sapply(strsplit(coordinates, split=", "), "[", 1)
lng <- sapply(strsplit(coordinates, split=", "), "[", 2)

lat <- gsub("\\(", "", lat)
lng <- gsub(")", "", lng)

lat <- signif(as.numeric(lat), 8)
lng <- signif(as.numeric(lng), 8)

date <- sapply(strsplit(date, split=" "), "[", 1)
year <- sapply(strsplit(date, split="/"), "[", 3)

collision.data <- mutate(collision.data, "Latitude" = lat, "Longitude" = lng, "Year" = year, "Date" = date) %>%
  select(ADDRTYPE, COLLISIONTYPE, DISTANCE, INATTENTIONIND, INCDTTM, INJURIES, JUNCTIONTYPE, 
         LIGHTCOND, LOCATION, PERSONCOUNT, ROADCOND, SDOT_COLDESC, SEVERITYDESC, ST_COLDESC, 
         VEHCOUNT, WEATHER, Latitude, Longitude, Year, Date)

collision.data$INATTENTIONIND[is.na(collision.data$INATTENTIONIND)] <- "N" 
collision.data <- na.omit(collision.data)
options(digits=16)

ballard.limits <- list(upper.lng = -122.360702, upper.lat = 47.690566, lower.lng = -122.410012, lower.lat = 47.655839)
phinney.ridge.limits <- list(upper.lng = -122.344423, upper.lat = 47.686954, lower.lng = -122.366053, lower.lat = 47.662190)
fremont.limits <- list(upper.lng = -122.342510, upper.lat = 47.665045, lower.lng = -122.367444, lower.lat = 47.648536)
greenwood.limits <- list(upper.lng = -122.344608, upper.lat = 47.705067, lower.lng = -122.365980, lower.lat = 47.683229)
university.district.limits <- list(upper.lng = -122.286484, upper.lat = 47.671793, lower.lng = -122.322104, lower.lat = 47.647687)
green.lake.limits <- list(upper.lng = -122.320072, upper.lat = 47.690502, lower.lng = -122.347323, lower.lat = 47.671085)
northgate.limits <- list(upper.lng = -122.305710, upper.lat = 47.734097, lower.lng = -122.344677, lower.lat = 47.683056)
magnolia.limits <- list(upper.lng = -122.393264, upper.lat = 47.661892, lower.lng = -122.409122, lower.lat = 47.648398)
queen.anne.limits <- list(upper.lng = -122.356687, upper.lat = 47.644524, lower.lng = -122.373650, lower.lat = 47.637816)
capitol.hill.limits <- list(upper.lng = -122.318215, upper.lat = 47.629830, lower.lng = -122.321305, lower.lat = 47.621153)


