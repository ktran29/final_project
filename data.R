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

northgate.data <- collision.data %>% 
  filter(Longitude < northgate.limits$upper.lng & Longitude > northgate.limits$lower.lng) %>% 
  filter(Latitude < northgate.limits$upper.lat & Latitude > northgate.limits$lower.lat)

magnolia.data <- collision.data %>% 
  filter(Longitude < magnolia.limits$upper.lng & Longitude > magnolia.limits$lower.lng) %>% 
  filter(Latitude < magnolia.limits$upper.lat & Latitude > magnolia.limits$lower.lat)

queen.anne.data <- collision.data %>% 
  filter(Longitude < queen.anne.limits$upper.lng & Longitude > queen.anne.limits$lower.lng) %>% 
  filter(Latitude < queen.anne.limits$upper.lat & Latitude > queen.anne.limits$lower.lat)

capitol.hill.data <- collision.data %>% 
  filter(Longitude < capitol.hill.limits$upper.lng & Longitude > capitol.hill.limits$lower.lng) %>% 
  filter(Latitude < capitol.hill.limits$upper.lat & Latitude > capitol.hill.limits$lower.lat)

neighborhood.lng <- c(-122.385, -122.359722, -122.3499, -122.3553, -122.303333, -122.327778, 
                      -122.328333, -122.400833, -122.356944, -122.316456)
neighborhood.lat <- c(47.677, 47.674167, 47.6505, 47.690612, 47.655, 47.680278, 47.708333, 
                      47.650556, 47.637222, 47.622942)
neighborhood <- c("Ballard", "Phinney Ridge", "Fremont", "Greenwood", "University District", "Green Lake", 
                  "Northgate", "Magnolia", "Queen Anne", "Capitol Hill")
count <- c(nrow(ballard.data)/5, nrow(phinney.ridge.data)/3, nrow(fremont.data)/3, nrow(greenwood.data)/3, 
           nrow(university.district.data)/4, nrow(green.lake.data)/3, nrow(northgate.data)/4, nrow(magnolia.data),
           nrow(queen.anne.data), nrow(capitol.hill.data))

