library(shiny)
library(leaflet)

source('./data.R')

shinyServer(function(input, output)  {
  
  output$map <- renderLeaflet({
    
    map <- leaflet() %>% 
      addTiles() %>% 
      addCircles(neighborhood.lng, neighborhood.lat, count, neighborhood, "Overview", FALSE, fillOpacity = 0.5) %>%
      addCircleMarkers(~Longitude, ~Latitude, 4, NULL, "Ballard", FALSE, data = ballard.data, fillOpacity = 0.3) %>% 
      hideGroup("Ballard") %>% 
      addCircleMarkers(~Longitude, ~Latitude, 4, NULL, "Phinney Ridge", FALSE, data = phinney.ridge.data, fillOpacity = 0.3) %>%  
      hideGroup("Phinney Ridge") %>% 
      addCircleMarkers(~Longitude, ~Latitude, 4, NULL, "Fremont", FALSE, data = fremont.data, fillOpacity = 0.3) %>% 
      hideGroup("Fremont") %>% 
      addCircleMarkers(~Longitude, ~Latitude, 4, NULL, "Greenwood", FALSE, data = greenwood.data, fillOpacity = 0.3) %>% 
      hideGroup("Greenwood") %>% 
      addCircleMarkers(~Longitude, ~Latitude, 4, NULL, "University District", FALSE, data = university.district.data, fillOpacity = 0.3) %>% 
      hideGroup("University District") %>% 
      addCircleMarkers(~Longitude, ~Latitude, 4, NULL, "Green Lake", FALSE, data = green.lake.data, fillOpacity = 0.3) %>% 
      hideGroup("Green Lake") %>% 
      addCircleMarkers(~Longitude, ~Latitude, 4, NULL, "Northgate", FALSE, data = northgate.data, fillOpacity = 0.3) %>% 
      hideGroup("Northgate") %>% 
      addCircleMarkers(~Longitude, ~Latitude, 4, NULL, "Magnolia", FALSE, data = magnolia.data, fillOpacity = 0.3) %>%  
      hideGroup("Magnolia") %>% 
      addCircleMarkers(~Longitude, ~Latitude, 4, NULL, "Queen Anne", FALSE, data = queen.anne.data, fillOpacity = 0.3) %>%  
      hideGroup("Queen Anne") %>% 
      addCircleMarkers(~Longitude, ~Latitude, 4, NULL, "Capitol Hill", FALSE, data = capitol.hill.data, fillOpacity = 0.3) %>% 
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
  
  # MAKE A PLOT
  output$plot <- renderPlotly({
    p <- ggplot(data = collision.data, aes_string(x = input$conditions, fill = "SEVERITYCODE")) +
      geom_bar() + 
      labs(title = "How Many Collisions and Their Severity for Certain Conditions",
           x = if(input$conditions == "ROADCOND") {"Road Conditions"} else if(input$conditions == "WEATHER"){"Weather"}
                else {"Light Conditions"},
           y = "Number of Collisions")
    
    p <- plotly_build(p)
    return(p)
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
  
  showCollisionInfo <- function(collision, lat, lng) {
    selectedCollisions <- filter(collision.data, Latitude == lat, Longitude == lng)
    selectedCollision <- sample_n(selectedCollisions, 1)
    content <- as.character(tagList(
      tags$h4("Location: ", selectedCollision$LOCATION),
      tags$h5("Number of collisions at this location: ", tags$em(nrow(selectedCollisions))),
      tags$strong("Collision Type: "), tags$em(selectedCollision$COLLISIONTYPE), tags$br(),
      tags$strong("SDOT description: "), tags$em(selectedCollision$SDOT_COLDESC), tags$br(),
      tags$strong("Number of people: "), tags$em(selectedCollision$PERSONCOUNT), tags$br(),
      tags$strong("Number of injuries: "), tags$em(selectedCollision$INJURIES), tags$br(),
      tags$strong("Distance: "), tags$em(selectedCollision$DISTANCE)
    ))
    leafletProxy("map") %>% addPopups(lng, lat, content)
  }
  
  observe({
    leafletProxy("map") %>% clearPopups()
    click <- input$map_marker_click
    if (!is.null(click)) {
      isolate({
        showCollisionInfo(click$id, click$lat, click$lng)
      })
    }
  })
})
