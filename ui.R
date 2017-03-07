library(shiny)
library(leaflet)
library(plotly)

shinyUI(
  navbarPage("Seattle Collisions in the Last 10 Years", id = "nav",
    tabPanel("Map",
      leafletOutput("map"),
      h3("Sort By:"),
      checkboxGroupInput("inattention", "Inattentive Driving", c("Yes" = "Y", "No" = "N"), c("Y", "N")),
      strong("Time"),
      checkboxInput("year", "By Year", FALSE),
      checkboxInput("hour", "By Hour", FALSE),
      conditionalPanel(
        condition = "input.year",
        sliderInput("year.slider", "Years", 2007, 2017, 2007:1)
      ),
      conditionalPanel(
        condition = "input.hour",
        sliderInput("hour.slider", "Hours (24-hour Format)", 1, 24, 1:0)
      ),
      selectInput("roadcond",
                  "Road Condition",
                  choices = c("All", "Dry", "Wet", "Snow/Slush", "Unknown", "Ice", "Sand/Mud/Dirt", "Other", "Oil", "Standing Water")
      ),
      selectInput("weather",
                  "Weather",
                  choices = c("All", "Clear or Partly Cloudy", "Overcast", "Raining", "Unknown", "Fog/Smog/Smoke", "Snowing", "Other", 
                              "Sleet/Hail/Freezing Rain", "Severe Crosswind", "Blowing Sand or Dirt or Snow")
      ),
      selectInput("lightcond",
                  "Lighting",
                  choices = c("All", "DayLight", "Dark - Street Lights On", "Dusk", 
                              "Dark - Street Lights Off", "Unknown", "Dawn", "Dark - No Street Lights", "Other")
      )
    ),
    tabPanel("Chart", 
      h3("This visual displays the number of car crashes against the factor of your choosing using the tools 
          on the left: Road conditions, Weather, and Light Conditions and shows the severity of the crashes"),
      h5("SDOT Severity Key: 0 = Unknown, 1 = Prop Damage, 2 = Injury, 2b = Serious Injury, 3 = Fatality"),
      h5("Scroll over each bar color to get more details. You can also zoom in by dragging over a certain 
          area. Double click to return to the original viewing size."), 
      plotlyOutput("plot"),
      selectInput("conditions", "Sort Collisions By:", 
                  c("Road Conditions" = "ROADCOND", "Weather" = "WEATHER", "Light Conditions" = "LIGHTCOND")
      )
    )
  )
)


