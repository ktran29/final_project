library(shiny)
library(leaflet)

shinyUI(
  navbarPage("Seattle Collisions in the Last 10 Years", id = "nav",
             tabPanel("Map",
                      leafletOutput("map"),
                      checkboxGroupInput("inattention", "Inattentive Driving", c("Yes" = "yes", "No" = "no"), c("yes", "no")),
                      checkboxInput("year", "Sort By Year", FALSE)
             ),
             tabPanel("Chart"),
             tabPanel("About", 
                      "The presentation deals with the dataset obtained from the Seattle Department of Transportation (https://data.seattle.gov/Transportation/SDOT-Collisions/v7k9-7dn4/data). 
                       This dataset consists of an annual traffic report on the locations and attributes of collisions that occur within Seattle.
                       For our presentation, we will be focusing om the U-District region in Seattle. We will compare the frequency of accidents in each sub-region of the U-District (Ballard, Phinney Ridge, Fremont, Greenwood, University District, Green Lake, Northgate, Magnolia, Queen Anne, Capitol Hill).

                       The primary feature of the data application is a leaflet map containing data points with information on collisions, such as the collision type, the amount of injuries, and the amount of fatalities. The first layer of the map contains an overview with a circle representing each sub-region of the U-District. The size of the circle correspond to the number of collisions. Clicking on any circle would expand that sub-region with individual data points representing collisions at specific locations.
                      
                       The second feature is a stacked bar graph with a summarized view of the collision data. The graph would show the relationship between the number of collisions and the severity of the collisions as well as a specific condition the user can choose using the widget.")
  )
)