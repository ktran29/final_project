library(shiny)
library(leaflet)

ui <- fluidPage(
  titlePanel("Seattle Collision Data"),
  sidebarLayout(
    sidebarPanel(
      checkboxInput("test", "Test", TRUE)
    ),
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("Map", leafletOutput("map"))
      )
    )
  )
)
shinyUI(ui)