library(shiny)
library(leaflet)

source('./data.R')

shinyServer(function(input, output)  {
  
  output$map <- renderLeaflet({
    
    map <- leaflet() %>% 
      addTiles() %>% 
      addCircles(neighborhood.lng, neighborhood.lat, 
                 c(computeDiameter(nrow(ballard.disp())), computeDiameter(nrow(phinney.ridge.disp())), 
                   computeDiameter(nrow(fremont.disp())), computeDiameter(nrow(greenwood.disp())), 
                   computeDiameter(nrow(university.district.disp())), computeDiameter(nrow(green.lake.disp())), 
                   computeDiameter(nrow(northgate.disp())), computeDiameter(nrow(magnolia.disp())),
                   computeDiameter(nrow(queen.anne.disp())), computeDiameter(nrow(capitol.hill.disp())))
                 , neighborhood, "Overview", FALSE, fillOpacity = 0.5) %>%
      setView(-122.339220, 47.677622, 12)
    
    current.group <- "placeholder"
    
    if(!is.null(clicks$map.click) & is.null(clicks$shape.click)) {
      removeMarker(map, current.group)
      map <- map %>% showGroup("Overview") %>% 
        setView(-122.339220, 47.677622, 12)
    } else if(!is.null(clicks$shape.click) & is.null(clicks$map.click)) {
      current.group <- clicks$shape.click$id
      
      data.res <- eval(parse(text = paste0(gsub(" ", ".", tolower(current.group)), ".disp()")))
      
      map <- map %>% hideGroup("Overview") %>% addCircleMarkers(~Longitude, ~Latitude, 4, NULL, current.group, FALSE, data = data.res, fillOpacity = 0.3) %>% 
          setView(lat = clicks$shape.click$lat, lng = clicks$shape.click$lng, zoom = 14) %>% showGroup(current.group)
    }
    return(map)
  })
  
  fremont.disp <- reactive({return(eval(parse(text = filt("fremont"))))})
  phinney.ridge.disp <- reactive({return(eval(parse(text = filt("phinney.ridge"))))})
  ballard.disp <- reactive({return(eval(parse(text = filt("ballard"))))})
  greenwood.disp <- reactive({return(eval(parse(text = filt("greenwood"))))})
  university.district.disp <- reactive({return(eval(parse(text = filt("university.district"))))})
  green.lake.disp <- reactive({return(eval(parse(text = filt("green.lake"))))})
  queen.anne.disp <- reactive({return(eval(parse(text = filt("queen.anne"))))})
  magnolia.disp <- reactive({return(eval(parse(text = filt("magnolia"))))})
  northgate.disp <- reactive({return(eval(parse(text = filt("northgate"))))})
  capitol.hill.disp <- reactive({return(eval(parse(text = filt("capitol.hill"))))})
  
  filt <- function(city){
    str <- sprintf("%1$s.data", city)
    str <- paste(str, "%>%", "filter(TRUE")
    if(input$weather != "Off"){str <- paste(str, "& WEATHER == input$weather")}
    if(input$roadcond != "Off"){str <- paste(str, "& ROADCOND == input$roadcond")}
    if(input$lightcond != "Off"){str <- paste(str, "& LIGHTCOND == input$lightcond")}
    str <- paste(str, ")")
    return(str)
  }
  
  #compute diameter of circle based on area (w/ magnitude adjustment)
  computeDiameter <- function(area){ return(sqrt(area/pi)*2*13) }
  
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
