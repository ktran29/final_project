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
                    FALSE)
    ),
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("Map", leafletOutput("map"))
      )
    )
  )
)
shinyUI(ui)