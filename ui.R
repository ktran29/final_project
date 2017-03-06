library(shiny)
library(leaflet)

ui <- fluidPage(
  titlePanel("Seattle Collision Data"),
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("inattention",
                         "Inattentive Driving",
                         c("Yes" = "yes",
                           "No" = "no"),
                         c("yes", "no")),
      checkboxInput("year",
                    "Sort By Year",
                    FALSE),
      #sliderInput("hour", "time of day", min=, max=4, value=2, step=.1),

      h3("filters:"),
      selectInput("roadcond",
                  "road condition",
                  choices = c("Off", "Dry", "Wet", "Snow/Slush", "Unknown", "Ice", "Sand/Mud/Dirt", "Other", "Oil", "Standing Water")
      ),
      selectInput("weather",
                  "weather",
                  choices = c("Off", "Clear or Partly Cloudy", "Overcast", "Raining", "Unknown", "Fog/Smog/Smoke", "Snowing", "Other", 
                              "Sleet/Hail/Freezing Rain", "Severe Crosswind", "Blowing Sand or Dirt or Snow")
      ),
      selectInput("lightcond",
                  "light condition",
                  choices = c("Off", "DayLight", "Dark - Street Lights On", "Dusk", 
                              "Dark - Street Lights Off", "Unknown", "Dawn", "Dark - No Street Lights", "Other")
      )
    ),
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("Map", leafletOutput("map"))
      )
    )
  )
)
shinyUI(ui)