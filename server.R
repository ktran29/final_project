#install.packages("leaflet")
library(leaflet)
library(dplyr)
#setwd("~/Dropbox/Classes/INFO201/Project/final_project")


collision.data <- read.csv("./SDOT_Collisions.csv", stringsAsFactors = FALSE)

coordinates <- collision.data$Shape

lat <- sapply(strsplit(coordinates, split=", "), "[", 1)
lng <- sapply(strsplit(coordinates, split=", "), "[", 2)

lat <- gsub("\\(", "", lat)
lng <- gsub(")", "", lng)

collision.data <- mutate(collision.data, "Latitude" = as.numeric(lat), "Longitude" = as.numeric(lng))

server <- function(input, output)  {
  
}

shinyServer(server)
