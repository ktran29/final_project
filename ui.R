source('./data.R')

shinyUI(
  fluidPage(
    titlePanel("Seattle Traffic Collisions in the Last 10 Years"),
    sidebarLayout(
      sidebarPanel(
        conditionalPanel( # Input panel that shows only when the map tab is selected
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
        conditionalPanel( # Input panel that shows only when the chart tab is selected
          condition = "input.tabs == 'plot'",
          selectInput("conditions", "Sort Collisions By:", 
                      c("Road Conditions" = "ROADCOND", "Weather" = "WEATHER", "Light Conditions" = "LIGHTCOND")),
          selectInput("location", "Look at data in:",
                      c("All" = "all",
                        "Ballard" = "ballard", "Capitol Hill" = "capitol.hill", "Fremont" = "fremont",
                        "Green Lake" = "green.lake", "Greenwood" = "greenwood", "Magnolia" = "magnolia",
                        "Maple Leaf" = "maple.leaf", "Phinney Ridge" = "phinney.ridge", 
                        "Queen Anne" = "queen.anne", "University District" = "university.district"))
        )
      ),
      mainPanel(
        tabsetPanel(id = "tabs",
          tabPanel("Map", # Tab for leaflet map
                   value = "leaflet",
                   leafletOutput("map")
          ),
          tabPanel("Chart", # Tab for bar charts
                   value = "plot",
                   h3("This visual displays the number of car crashes against the factor of your choosing using the tools 
                      on the left: Road conditions, Weather, and Light Conditions and shows the severity of the crashes"),
                   h5("SDOT Severity Key: 0 = Unknown, 1 = Prop Damage, 2 = Injury, 2b = Serious Injury, 3 = Fatality"),
                   tabsetPanel(id = "subtabs",
                      tabPanel("Counts", plotlyOutput("plotly"), 
                               h5("Scroll over each bar color to get more details. You can also zoom in by dragging over a certain 
                                area. Double click to return to the original viewing size.")),
                      tabPanel("Ratios", plotOutput("ggplot"))
                  )
          )
        )
      )
    )
  )
)


