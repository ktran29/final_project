library(shiny)
library(leaflet)

source('./data.R')

shinyServer(function(input, output)  {
  
  output$map <- renderLeaflet({
    
    map <- leaflet() %>% 
      addTiles() %>% 
      addCircles(neighborhood.lng, neighborhood.lat, 
                 c(nrow(ballard.disp())/5, nrow(phinney.ridge.disp())/3, nrow(fremont.disp())/3, nrow(greenwood.disp())/3, 
                   nrow(university.district.disp())/4, nrow(green.lake.disp())/3, nrow(northgate.disp())/4, nrow(magnolia.disp()),
                   nrow(queen.anne.disp()), nrow(capitol.hill.disp()))
                 , neighborhood, "Overview", FALSE, fillOpacity = 0.5) %>%
      #addCircleMarkers(~Longitude, ~Latitude, 4, NULL, "Ballard", FALSE, data = ballard.disp(), fillOpacity = 0.3) %>% 
      #hideGroup("Ballard") %>% 
      #addCircleMarkers(~Longitude, ~Latitude, 4, NULL, "Phinney Ridge", FALSE, data = phinney.ridge.disp(), fillOpacity = 0.3) %>%  
      #hideGroup("Phinney Ridge") %>% 
      #addCircleMarkers(~Longitude, ~Latitude, 4, NULL, "Fremont", FALSE, data = fremont.disp(), fillOpacity = 0.3) %>% 
      #hideGroup("Fremont") %>% 
      #addCircleMarkers(~Longitude, ~Latitude, 4, NULL, "Greenwood", FALSE, data = greenwood.disp(), fillOpacity = 0.3) %>% 
      #hideGroup("Greenwood") %>% 
      #addCircleMarkers(~Longitude, ~Latitude, 4, NULL, "University District", FALSE, data = university.district.disp(), fillOpacity = 0.3) %>% 
      #hideGroup("University District") %>% 
      #addCircleMarkers(~Longitude, ~Latitude, 4, NULL, "Green Lake", FALSE, data = green.lake.disp(), fillOpacity = 0.3) %>% 
      #hideGroup("Green Lake") %>% 
      #addCircleMarkers(~Longitude, ~Latitude, 4, NULL, "Northgate", FALSE, data = northgate.disp(), fillOpacity = 0.3) %>% 
      #hideGroup("Northgate") %>% 
      #addCircleMarkers(~Longitude, ~Latitude, 4, NULL, "Magnolia", FALSE, data = magnolia.disp(), fillOpacity = 0.3) %>%  
      #hideGroup("Magnolia") %>% 
      #addCircleMarkers(~Longitude, ~Latitude, 4, NULL, "Queen Anne", FALSE, data = queen.anne.disp(), fillOpacity = 0.3) %>%  
      #hideGroup("Queen Anne") %>% 
      #addCircleMarkers(~Longitude, ~Latitude, 4, NULL, "Capitol Hill", FALSE, data = capitol.hill.disp(), fillOpacity = 0.3) %>% 
      #hideGroup("Capitol Hill") %>% 
      setView(-122.339220, 47.677622, 12)
    
    current.group <- "placeholder"
    
    if(!is.null(clicks$map.click) & is.null(clicks$shape.click)) {
      #current.group
      #map <- map %>% hideGroup("Ballard") %>% showGroup("Overview") %>%
      #  setView(-122.339220, 47.677622, 12)
      #map.removeLayer(current.group)
      #removeMarker(map, )
      removeMarker(map, current.group)
      map <- map %>% showGroup("Overview") %>% 
        setView(-122.339220, 47.677622, 12)
    } else if(!is.null(clicks$shape.click) & is.null(clicks$map.click)) {
      current.group <- clicks$shape.click$id
      
      print(current.group)
      #map <- map %>% hideGroup("Overview") %>% showGroup("Ballard") %>% 
        #setView(lat = clicks$shape.click$lat, lng = clicks$shape.click$lng, zoom = 14)
      #map.removeLayer("Overview")
      #print(getLayer())
      
      print(gsub(" ", ".", tolower(current.group)))
      
      data.res <- eval(parse(text = paste0(gsub(" ", ".", tolower(current.group)), ".disp()")))
      
      map <- map %>% hideGroup("Overview") %>% addCircleMarkers(~Longitude, ~Latitude, 4, NULL, current.group, FALSE, data = data.res, fillOpacity = 0.3) %>% 
          setView(lat = clicks$shape.click$lat, lng = clicks$shape.click$lng, zoom = 14) %>% showGroup(current.group)
      #map <- map %>% showGroup(current.group) %>% hideGroup("Overview") %>% 
        #setView(lat = clicks$shape.click$lat, lng = clicks$shape.click$lng, zoom = 14)
    }
    
    return(map)
  })
  
  
  
  
  fremont.disp <- reactive({return(eval(parse(text = gen.string2("fremont"))))})
  phinney.ridge.disp <- reactive({return(eval(parse(text = gen.string2("phinney.ridge"))))})
  ballard.disp <- reactive({return(eval(parse(text = gen.string2("ballard"))))})
  greenwood.disp <- reactive({return(eval(parse(text = gen.string2("greenwood"))))})
  university.district.disp <- reactive({return(eval(parse(text = gen.string2("university.district"))))})
  green.lake.disp <- reactive({return(eval(parse(text = gen.string2("green.lake"))))})
  queen.anne.disp <- reactive({return(eval(parse(text = gen.string2("queen.anne"))))})
  magnolia.disp <- reactive({return(eval(parse(text = gen.string2("magnolia"))))})
  northgate.disp <- reactive({return(eval(parse(text = gen.string2("northgate"))))})
  capitol.hill.disp <- reactive({return(eval(parse(text = gen.string2("capitol.hill"))))})

  
  gen.string2 <- function(city){
    #roadcond 
    #weather
    #lightcond
    #^ allow to filter on these yo.
    #do NOT push to master branch. our code is very different
    #todo: structure
    #each city.data.disp randomly stores every element input variable (weather, lightcond, roadcond widgets), but doesn't do anything w/them
    #^ this way, it detects need to update
    #^ WOAH nvm. apparently shiny is smart enough to notice that the input variable is requested in this generated string!
    #^ so i guess it isn't necessary after all.
    #^ the update then calls gen.string2 on that city.
    #thats... basically it.
    #
    #^ you can turn all the above code for .disp into 1-liners btw.
    
    #you know... i can paste the string... together... have the if statements outside of the function. like right here....
    
    
    #you PIPE if it is necessary yo.
    #^ you can string trim... i guess... to remove the last filter's pipe.
    
    #or wait. no. you can inject   " %%>%% filter(whatever you wanna filter on) "
    # ^ that works i think
    #prepend it all with collisions.data :)
    #
    #allowing users to set variables as "YES/NO/OFF" will be kind of annoying.... sigh.
    
    #overview.count <- c(nrow(ballard.disp())/5, nrow(phinney.ridge.disp())/3, nrow(fremont.disp())/3, nrow(greenwood.disp())/3, 
                        #nrow(university.district.disp())/4, nrow(green.lake.disp())/3, nrow(northgate.disp())/4, nrow(magnolia.disp()),
                        #nrow(queen.anne.disp()), nrow(capitol.hill.disp()))
    
    str <- sprintf("%1$s.data", city)
    #str <- paste(str, "%>%", sprintf("filter(Longitude < %1$s.limits$upper.lng & Longitude > %1$s.limits$lower.lng)", city))
    #str <- paste(str, "%>%", sprintf("filter(Latitude < %1$s.limits$upper.lat & Latitude > %1$s.limits$lower.lat)", city))
    #if(input$raining){str <- paste(str, "%>%", "filter(WEATHER == 'Raining')")}
    str <- paste(str, "%>%", "filter(TRUE")
    if(input$weather != "Off"){str <- paste(str, "& WEATHER == input$weather")}
    if(input$roadcond != "Off"){str <- paste(str, "& ROADCOND == input$roadcond")}
    if(input$lightcond != "Off"){str <- paste(str, "& LIGHTCOND == input$lightcond")}
    str <- paste(str, ")")
    #if(input$weather != "Off"){str <- paste(str, "%>%", "filter(WEATHER == input$weather)")}
    #if(input$roadcond != "Off"){str <- paste(str, "%>%", "filter(ROADCOND == input$roadcond)")}
    #if(input$lightcond != "Off"){str <- paste(str, "%>%", "filter(LIGHTCOND == input$lightcond)")}
    
    return(str)
  }
  
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
