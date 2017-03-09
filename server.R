shinyServer(function(input, output)  {
  
  output$map <- renderLeaflet({
    
    # Creates a leaflet object
    map <- leaflet() %>% 
      addTiles() %>% # Adds the world map overlay
      # Creates a circle for each neighborhood
      addCircles(neighborhood.lng, neighborhood.lat, 
                 c(computeDiameter(nrow(ballard.disp())), computeDiameter(nrow(phinney.ridge.disp())), 
                   computeDiameter(nrow(fremont.disp())), computeDiameter(nrow(greenwood.disp())), 
                   computeDiameter(nrow(university.district.disp())), computeDiameter(nrow(green.lake.disp())), 
                   computeDiameter(nrow(maple.leaf.disp())), computeDiameter(nrow(magnolia.disp())),
                   computeDiameter(nrow(queen.anne.disp())), computeDiameter(nrow(capitol.hill.disp()))),
                 neighborhood, "Overview", FALSE, fillOpacity = 0.5, label = paste0(neighborhood, ": ", # Adds a label that computes the number of collisions for each neighboorhood
                   c(nrow(ballard.disp()), nrow(phinney.ridge.disp()), nrow(greenwood.disp()), nrow(greenwood.disp()),
                    nrow(university.district.disp()), nrow(green.lake.disp()), nrow(maple.leaf.disp()), 
                    nrow(magnolia.disp()), nrow(queen.anne.disp()), nrow(capitol.hill.disp)), " collisions")) %>%
      setView(-122.340098, 47.665702, 12)
    
    current.group <- "placeholder"
    
    if(!is.null(clicks$map.click)) { # Resets the map when it's clicked on, not including points
      removeMarker(map, current.group)
      map <- showGroup(map, "Overview") %>% 
        setView(-122.340098, 47.665702, 12)
    } else if(!is.null(clicks$shape.click)) { # Views data for the clicked neighborhood
      current.group <- clicks$shape.click$id
      
      data.res <- eval(parse(text = paste0(gsub(" ", ".", tolower(current.group)), ".disp()")))
      
      map <- hideGroup(map, "Overview") %>% 
        addCircleMarkers(~Longitude, ~Latitude, 4, NULL, current.group, FALSE, data = data.res, fillOpacity = 0.3) %>% 
          setView(lat = clicks$shape.click$lat, lng = clicks$shape.click$lng, zoom = 14) %>% showGroup(current.group)
    }
    return(map)
  })
  
  # Reactive values for map inputs
  clicks <- reactiveValues(map.click = NULL, shape.click = NULL)
  
  observeEvent(input$map_shape_click, { # Listens to when a neighborhood circle is clicked
    clicks$shape.click <- input$map_shape_click
    clicks$map.click <- NULL
  })
  
  observeEvent(input$map_click, { # Listens to when when the map is clicked
    clicks$map.click <- input$map_click
    clicks$shape.click <- NULL
  })
  
  # Reactive functions for displaying the neighborhood data 
  fremont.disp <- reactive({return(eval(parse(text = filt("fremont"))))})
  phinney.ridge.disp <- reactive({return(eval(parse(text = filt("phinney.ridge"))))})
  ballard.disp <- reactive({return(eval(parse(text = filt("ballard"))))})
  greenwood.disp <- reactive({return(eval(parse(text = filt("greenwood"))))})
  university.district.disp <- reactive({return(eval(parse(text = filt("university.district"))))})
  green.lake.disp <- reactive({return(eval(parse(text = filt("green.lake"))))})
  queen.anne.disp <- reactive({return(eval(parse(text = filt("queen.anne"))))})
  magnolia.disp <- reactive({return(eval(parse(text = filt("magnolia"))))})
  maple.leaf.disp <- reactive({return(eval(parse(text = filt("maple.leaf"))))})
  capitol.hill.disp <- reactive({return(eval(parse(text = filt("capitol.hill"))))})
  
  # Function that creates a filter variable string based on shiny input
  filt <- function(city){
    str <- sprintf("%s.data", city)
    str <- paste(str, "%>%", "filter(TRUE")
    str <- paste(str, "& YEAR >= input$year.slider[1] & YEAR <= input$year.slider[2]")
    str <- paste(str, "& HOUR >= input$hour.slider[1] & HOUR <= input$hour.slider[2]")
    if(!is.null(input$inattention)) {
      str <- paste(str, "& INATTENTIONIND %in% input$inattention")
    }
    if(input$weather != "All"){str <- paste(str, "& WEATHER == input$weather")}
    if(input$roadcond != "All"){str <- paste(str, "& ROADCOND == input$roadcond")}
    if(input$lightcond != "All"){str <- paste(str, "& LIGHTCOND == input$lightcond")}
    str <- paste0(str, ")")
    return(str)
  }
  
  # Computes circle size based on the size of the neighborhood data
  computeDiameter <- function(area){ return(sqrt(area/pi)*2*13) }
  
  # Function that shows collision information when a point is clicked
  showCollisionInfo <- function(name, lat, lng) {
    neighborhood.data <- eval(parse(text = paste0(gsub(" ", ".", tolower(name)), ".disp()")))
    selectedCollisions <- filter(neighborhood.data, Latitude == lat, Longitude == lng)
    selectedCollision <- sample_n(selectedCollisions, 1)
    content <- as.character(tagList(
      tags$h4("Location: ", selectedCollision$LOCATION),
      tags$h5("Number of collisions at this location: ", tags$em(nrow(selectedCollisions))),
      tags$strong(sprintf("Collision on %1$s at %2$s:", selectedCollision$DATE, selectedCollision$TIME)), tags$br(),
      tags$strong("Description: "), tags$em(selectedCollision$SDOT_COLDESC), tags$br(),
      tags$strong("People involved: "), tags$em(selectedCollision$PERSONCOUNT), tags$br(),
      tags$strong("Injuries: "), tags$em(selectedCollision$INJURIES), tags$br(),
      tags$strong("Fatalities: "), tags$em(selectedCollision$FATALITIES)
    ))
    leafletProxy("map") %>% addPopups(lng, lat, content)
  }
  
  # Event that listens to when a point is clicked
  observe({
    leafletProxy("map") %>% clearPopups()
    click <- input$map_marker_click
    if (!is.null(click)) {
      isolate({
        showCollisionInfo(click$group, click$lat, click$lng)
      })
    }
  })
  
  # Reactive function that picks plot data based on the plot input
  plot.filt <- reactive({
    specific.plot <- switch(
      input$location,
      all = collision.data,
      ballard = ballard.data,
      capitol.hill = capitol.hill.data,
      fremont = fremont.data,
      green.lake = green.lake.data,
      greenwood = greenwood.data,
      magnolia = magnolia.data,
      maple.leaf = maple.leaf.data,
      phinney.ridge = phinney.ridge.data,
      queen.anne = queen.anne.data,
      university.district = university.district.data
    )
    return(specific.plot)
  })
  
  # Creates a plotly output
  output$plotly <- renderPlotly({
    # position = "fill" inside the geom_bar
    p <- ggplot(data = plot.filt(), aes_string(x = input$conditions, fill = "SEVERITYCODE")) +
      geom_bar() + 
      labs(title = "How Many Collisions and Their Severity for Certain Conditions",
           x = if(input$conditions == "ROADCOND") {"Road Conditions"} else if(input$conditions == "WEATHER"){"Weather"}
                else {"Light Conditions"},
           y = "Number of Collisions")
    
    p <- plotly_build(p)
    return(p)
  })
  
  # Creates a ggplot output
  output$ggplot <- renderPlot({
    q <- ggplot(data = plot.filt(), aes_string(x = input$conditions, fill="SEVERITYCODE")) +
      geom_bar(position = "fill") +
      labs(title = "How Many Collisions and Their Severity for Certain Conditions",
           x = if(input$conditions == "ROADCOND") {"Road Conditions"} else if(input$conditions == "WEATHER"){"Weather"}
           else {"Light Conditions"},
           y = "Percentage of Collisions")
    return(q)
  })

})
