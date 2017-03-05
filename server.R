library(shiny)
library(leaflet)
#setwd("~/Dropbox/Classes/INFO201/Project/final_project")

source('./data.R')

shinyServer(function(input, output)  {
  
  output$map <- renderLeaflet({
    
    map <- leaflet(neighborhood.coordinates) %>% 
      addTiles() %>% 
      addCircles(~neighborhood.lng, ~neighborhood.lat, ~count, ~neighborhood, "Overview", FALSE, fillOpacity = 0.6) %>%
      addCircleMarkers(~Longitude, ~Latitude, 3, group = "Ballard", data = ballard.data) %>% 
      hideGroup("Ballard") %>% 
      addCircleMarkers(~Longitude, ~Latitude, 3, group = "Phinney Ridge", data = phinney.ridge.data) %>%  
      hideGroup("Phinney Ridge") %>% 
      addCircleMarkers(~Longitude, ~Latitude, 3, group = "Fremont", data = fremont.data) %>% 
      hideGroup("Fremont") %>% 
      addCircleMarkers(~Longitude, ~Latitude, 3, group = "Greenwood", data = greenwood.data) %>% 
      hideGroup("Greenwood") %>% 
      addCircleMarkers(~Longitude, ~Latitude, 3, group = "University District", data = university.district.data) %>% 
      hideGroup("University District") %>% 
      addCircleMarkers(~Longitude, ~Latitude, 3, group = "Green Lake", data = green.lake.data) %>% 
      hideGroup("Green Lake") %>% 
      addCircleMarkers(~Longitude, ~Latitude, 3, group = "Northgate", data = northgate.data) %>% 
      hideGroup("Northgate") %>% 
      addCircleMarkers(~Longitude, ~Latitude, 3, group = "Magnolia", data = magnolia.data) %>%  
      hideGroup("Magnolia") %>% 
      addCircleMarkers(~Longitude, ~Latitude, 3, group = "Queen Anne", data = queen.anne.data) %>%  
      hideGroup("Queen Anne") %>% 
      addCircleMarkers(~Longitude, ~Latitude, 3, group = "Capitol Hill", data = capitol.hill.data) %>% 
      hideGroup("Capitol Hill") %>% 
      setView(-122.339220, 47.677622, 12)
    
    current.group <- "Overview"
    
    if(!is.null(clicks$map.click) & is.null(clicks$shape.click)) {
      map <- map %>% hideGroup(current.group) %>% showGroup("Overview") %>%
        setView(-122.339220, 47.677622, 12)
    } else if(!is.null(clicks$shape.click) & is.null(clicks$map.click)) {
      current.group <- clicks$shape.click$id
      map <- map %>% hideGroup("Overview") %>% showGroup(current.group) %>% 
        setView(lat = clicks$shape.click$lat, lng = clicks$shape.click$lng, zoom = 14)
    }
    
    return(map)
  })
  
  clicks <- reactiveValues(map.click = NULL, shape.click = NULL)
  
  observeEvent(input$map_shape_click, {
    clicks$shape.click <- input$map_shape_click
    clicks$map.click <- NULL
  })
  
  observeEvent(input$map_click, {
    clicks$map.click <- input$map_click
    clicks$shape.click <- NULL
  })
  
})

