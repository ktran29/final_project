library(shiny)
library(leaflet)

shinyUI(
  navbarPage("Seattle Collisions in the Last 10 Years", id = "nav",
    tabPanel("Map",
      leafletOutput("map"),
      checkboxGroupInput("inattention", "Inattentive Driving", c("Yes" = "yes", "No" = "no"), c("yes", "no")),
      checkboxInput("year", "Sort By Year", FALSE)
    ),
    tabPanel("Chart")
  )
)