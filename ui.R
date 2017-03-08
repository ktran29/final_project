library(shiny)
library(leaflet)
library(plotly)

source('./data.R')

shinyUI(
  fluidPage(
    titlePanel("Seattle Traffic Collisions in the Last 10 Years"),
    sidebarLayout(
      sidebarPanel(
        conditionalPanel(
          condition = "input.tabs == 'leaflet'",
          h3("Sort By:"),
          sliderInput("year.slider", "Years", min(collision.data$YEAR), max(collision.data$YEAR), range(collision.data$YEAR), 1),
          sliderInput("hour.slider", "Hours (24-hour Format)", min(collision.data$HOUR), max(collision.data$HOUR), range(collision.data$HOUR), 1),
          checkboxGroupInput("inattention", "Driving Attention", c("Attentive" = "N", "Inattentive" = "Y"), c("Y", "N")),
          selectInput("roadcond", "Road Condition",
                      choices = c("All", "Dry", "Wet", "Snow/Slush", "Unknown", "Ice", "Sand/Mud/Dirt", "Other", "Oil", "Standing Water")
          ),
          selectInput("weather", "Weather",
                      choices = c("All", "Clear or Partly Cloudy", "Overcast", "Raining", "Unknown", "Fog/Smog/Smoke", "Snowing", "Other", 
                                  "Sleet/Hail/Freezing Rain", "Severe Crosswind", "Blowing Sand or Dirt or Snow")
          ),
          selectInput("lightcond", "Lighting",
                      choices = c("All", "Daylight", "Dark - Street Lights On", "Dusk", "Dark - Street Lights Off", "Unknown", 
                                  "Dawn", "Dark - No Street Lights", "Other")
          )
        ),
        conditionalPanel(
          condition = "input.tabs == 'plotly'",
          selectInput("conditions", "Sort Collisions By:", 
                      c("Road Conditions" = "ROADCOND", "Weather" = "WEATHER", "Light Conditions" = "LIGHTCOND")),
          selectInput("location", "Look at data in:",
                      c("All" = "collision.data",
                        "Ballard" = "ballard.data", "Capitol Hill" = "capitol.hill.data", "Fremont" = "fremont.data",
                        "Green Lake" = "green.lake.data", "Greenwood" = "greenwood.data", "Magnolia" = "magnolia.data",
                        "Maple Leaf" = "maple.leaf.data", "Phinney Ridge" = "phinney.ridge.data", 
                        "Queen Anne" = "queen.anne.data", "University District" = "university.district.data"))
        )
      ),
      mainPanel(
        tabsetPanel(id = "tabs",
          tabPanel("Map",
                   value = "leaflet",
                   leafletOutput("map")
          ),
          tabPanel("Chart",
                   value = "plotly",
                   h3("This visual displays the number of car crashes against the factor of your choosing using the tools 
                      on the left: Road conditions, Weather, and Light Conditions and shows the severity of the crashes"),
                   h5("SDOT Severity Key: 0 = Unknown, 1 = Prop Damage, 2 = Injury, 2b = Serious Injury, 3 = Fatality"),
                   tabsetPanel(id = "subtabs",
                      tabPanel("Counts", plotlyOutput("plot"), 
                               h5("Scroll over each bar color to get more details. You can also zoom in by dragging over a certain 
                                area. Double click to return to the original viewing size.")),
                      tabPanel("Ratios", plotOutput("plot2"))
                  )
          )
        )
      )
    )
  )
)


