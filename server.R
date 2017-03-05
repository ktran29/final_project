library(shiny)
library(leaflet)

source('./data.R')

shinyServer(function(input, output)  {
  
  ballard.data <- collision.data %>% 
    filter(Longitude < ballard.limits$upper.lng & Longitude > ballard.limits$lower.lng) %>% 
    filter(Latitude < ballard.limits$upper.lat & Latitude > ballard.limits$lower.lat)
  
  phinney.ridge.data <- collision.data %>% 
    filter(Longitude < phinney.ridge.limits$upper.lng & Longitude > phinney.ridge.limits$lower.lng) %>% 
    filter(Latitude < phinney.ridge.limits$upper.lat & Latitude > phinney.ridge.limits$lower.lat)
  
  fremont.data <- collision.data %>% 
    filter(Longitude < fremont.limits$upper.lng & Longitude > fremont.limits$lower.lng) %>% 
    filter(Latitude < fremont.limits$upper.lat & Latitude > fremont.limits$lower.lat)
  
  greenwood.data <- collision.data %>% 
    filter(Longitude < greenwood.limits$upper.lng & Longitude > greenwood.limits$lower.lng) %>% 
    filter(Latitude < greenwood.limits$upper.lat & Latitude > greenwood.limits$lower.lat)
  
  university.district.data <- collision.data %>% 
    filter(Longitude < university.district.limits$upper.lng & Longitude > university.district.limits$lower.lng) %>% 
    filter(Latitude < university.district.limits$upper.lat & Latitude > university.district.limits$lower.lat)
  
  green.lake.data <- collision.data %>% 
    filter(Longitude < green.lake.limits$upper.lng & Longitude > green.lake.limits$lower.lng) %>% 
    filter(Latitude < green.lake.limits$upper.lat & Latitude > green.lake.limits$lower.lat)
  
  northgate.data <- collision.data %>% 
    filter(Longitude < northgate.limits$upper.lng & Longitude > northgate.limits$lower.lng) %>% 
    filter(Latitude < northgate.limits$upper.lat & Latitude > northgate.limits$lower.lat)
  
  magnolia.data <- collision.data %>% 
    filter(Longitude < magnolia.limits$upper.lng & Longitude > magnolia.limits$lower.lng) %>% 
    filter(Latitude < magnolia.limits$upper.lat & Latitude > magnolia.limits$lower.lat)
  
  queen.anne.data <- collision.data %>% 
    filter(Longitude < queen.anne.limits$upper.lng & Longitude > queen.anne.limits$lower.lng) %>% 
    filter(Latitude < queen.anne.limits$upper.lat & Latitude > queen.anne.limits$lower.lat)
  
  capitol.hill.data <- collision.data %>% 
    filter(Longitude < capitol.hill.limits$upper.lng & Longitude > capitol.hill.limits$lower.lng) %>% 
    filter(Latitude < capitol.hill.limits$upper.lat & Latitude > capitol.hill.limits$lower.lat)
  
  
  
  neighborhood.lng <- c(-122.385, -122.359722, -122.3499, -122.3553, -122.303333, -122.327778, 
                        -122.328333, -122.400833, -122.356944, -122.316456)
  neighborhood.lat <- c(47.677, 47.674167, 47.6505, 47.690612, 47.655, 47.680278, 47.708333, 
                        47.650556, 47.637222, 47.622942)
  neighborhood <- c("Ballard", "Phinney Ridge", "Fremont", "Greenwood", "University District", "Green Lake", 
                    "Northgate", "Magnolia", "Queen Anne", "Capitol Hill")
  count <- c(nrow(ballard.data)/5, nrow(phinney.ridge.data)/3, nrow(fremont.data)/3, nrow(greenwood.data)/3, 
             nrow(university.district.data)/4, nrow(green.lake.data)/3, nrow(northgate.data)/4, nrow(magnolia.data),
             nrow(queen.anne.data), nrow(capitol.hill.data))
  
  neighborhood.coordinates <- data.frame(neighborhood.lng, neighborhood.lat, neighborhood, count)
  
  
  
  output$map <- renderLeaflet({
    
    map <- leaflet(neighborhood.coordinates) %>% 
      addTiles() %>% 
      addCircles(~neighborhood.lng, ~neighborhood.lat, ~count, ~neighborhood, "Overview", FALSE, fillOpacity = 0.6) %>%
      addCircleMarkers(~Longitude, ~Latitude, 2, group = "Ballard", data = ballard.data) %>% 
      hideGroup("Ballard") %>% 
      addCircleMarkers(~Longitude, ~Latitude, 2, group = "Phinney Ridge", data = phinney.ridge.data) %>%  
      hideGroup("Phinney Ridge") %>% 
      addCircleMarkers(~Longitude, ~Latitude, 2, group = "Fremont", data = fremont.data) %>% 
      hideGroup("Fremont") %>% 
      addCircleMarkers(~Longitude, ~Latitude, 2, group = "Greenwood", data = greenwood.data) %>% 
      hideGroup("Greenwood") %>% 
      addCircleMarkers(~Longitude, ~Latitude, 2, group = "University District", data = university.district.data) %>% 
      hideGroup("University District") %>% 
      addCircleMarkers(~Longitude, ~Latitude, 2, group = "Green Lake", data = green.lake.data) %>% 
      hideGroup("Green Lake") %>% 
      addCircleMarkers(~Longitude, ~Latitude, 2, group = "Northgate", data = northgate.data) %>% 
      hideGroup("Northgate") %>% 
      addCircleMarkers(~Longitude, ~Latitude, 2, group = "Magnolia", data = magnolia.data) %>%  
      hideGroup("Magnolia") %>% 
      addCircleMarkers(~Longitude, ~Latitude, 2, group = "Queen Anne", data = queen.anne.data) %>%  
      hideGroup("Queen Anne") %>% 
      addCircleMarkers(~Longitude, ~Latitude, 2, group = "Capitol Hill", data = capitol.hill.data) %>% 
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



















