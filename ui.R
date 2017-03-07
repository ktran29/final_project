library(shiny)
library(leaflet)
library(plotly)

shinyUI(
  navbarPage("Seattle Collisions in the Last 10 Years", id = "nav",
    tabPanel("Map",
      leafletOutput("map"),
      
      checkboxGroupInput("inattention", "Inattentive Driving", c("Yes" = "yes", "No" = "no"), c("yes", "no")),
      checkboxInput("year", "Sort By Year", FALSE),
      conditionalPanel(
        condition = "input.year",
        sliderInput("year.slider",
                    "Years",
                    2007,
                    2017,
                    2007:1
        )
      )
    ),
    tabPanel("Chart", h3("This visual displays the number of car crashes
                                     against the factor of your choosing using the tools on the left
                         : Road conditions, Weather, and Light Conditions
                         and shows the severity of the crashes"),
             h5("SDOT Severity Key: 0 = Unknown, 1 = Prop Damage, 2 = Injury,
                2b = Serious Injury, 3 = Fatality"),
             h5("Scroll over each bar color to get more details. You can also zoom in by
                dragging over a certain area. Double click to return to the original
                viewing size."), plotlyOutput("plot"))
  )
)


