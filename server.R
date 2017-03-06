library(shiny)
library(leaflet)

source('./data.R')

shinyServer(function(input, output)  {
  
  output$map <- renderLeaflet({
    
    map <- leaflet() %>% 
      addTiles() %>% 
      addCircles(neighborhood.lng, neighborhood.lat, count, neighborhood, "Overview", FALSE, fillOpacity = 0.5) %>%
      addCircleMarkers(~Longitude, ~Latitude, 4, NULL, "Ballard", FALSE, data = ballard.disp(), fillOpacity = 0.3) %>% 
      hideGroup("Ballard") %>% 
      addCircleMarkers(~Longitude, ~Latitude, 4, NULL, "Phinney Ridge", FALSE, data = phinney.ridge.disp(), fillOpacity = 0.3) %>%  
      hideGroup("Phinney Ridge") %>% 
      addCircleMarkers(~Longitude, ~Latitude, 4, NULL, "Fremont", FALSE, data = fremont.disp(), fillOpacity = 0.3) %>% 
      hideGroup("Fremont") %>% 
      addCircleMarkers(~Longitude, ~Latitude, 4, NULL, "Greenwood", FALSE, data = greenwood.disp(), fillOpacity = 0.3) %>% 
      hideGroup("Greenwood") %>% 
      addCircleMarkers(~Longitude, ~Latitude, 4, NULL, "University District", FALSE, data = university.district.disp(), fillOpacity = 0.3) %>% 
      hideGroup("University District") %>% 
      addCircleMarkers(~Longitude, ~Latitude, 4, NULL, "Green Lake", FALSE, data = green.lake.disp(), fillOpacity = 0.3) %>% 
      hideGroup("Green Lake") %>% 
      addCircleMarkers(~Longitude, ~Latitude, 4, NULL, "Northgate", FALSE, data = northgate.disp(), fillOpacity = 0.3) %>% 
      hideGroup("Northgate") %>% 
      addCircleMarkers(~Longitude, ~Latitude, 4, NULL, "Magnolia", FALSE, data = magnolia.disp(), fillOpacity = 0.3) %>%  
      hideGroup("Magnolia") %>% 
      addCircleMarkers(~Longitude, ~Latitude, 4, NULL, "Queen Anne", FALSE, data = queen.anne.disp(), fillOpacity = 0.3) %>%  
      hideGroup("Queen Anne") %>% 
      addCircleMarkers(~Longitude, ~Latitude, 4, NULL, "Capitol Hill", FALSE, data = capitol.hill.disp(), fillOpacity = 0.3) %>% 
      hideGroup("Capitol Hill") %>% 
      setView(-122.339220, 47.677622, 12)
    
    current.group <- "Overview"
    
    
    #for loop through all the cities.
    #for loop through all of the state.variable.properties.
    #sigh.
    #well.. maybe per city is necessary, ^ to not break up the structuring for plotting to the map
    #
    #still need a state variable i think
    #or just many of them? and the reactive function just observes them all.
    
    
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
  
  data.disp <- reactive({
    #dummy <- input$raining
    
    
    
    #print(input$raining)
    
    #ret <- if(input$raining) collision.data %>% 
        #filter(Longitude < fremont.limits$upper.lng & Longitude > fremont.limits$lower.lng) %>% 
        #filter(Latitude < fremont.limits$upper.lat & Latitude > fremont.limits$lower.lat) else 
          #collision.data %>% 
             #filter(Longitude < fremont.limits$upper.lng & Longitude > fremont.limits$lower.lng) %>% 
             #filter(Latitude < fremont.limits$upper.lat & Latitude > fremont.limits$lower.lat) %>% 
             #filter(WEATHER == "Raining")
    
    
    #omg it works vvvv holy shit
    #ret <- if(input$raining) (eval(parse(text = " collision.data %>% 
#filter(Longitude < fremont.limits$upper.lng & Longitude > fremont.limits$lower.lng) %>% 
                                  #  filter(Latitude < fremont.limits$upper.lat & Latitude > fremont.limits$lower.lat)"))) else 
                                  #  (eval(parse(text = "collision.data %>% 
                                  #  filter(Longitude < fremont.limits$upper.lng & Longitude > fremont.limits$lower.lng) %>% 
                                  #  filter(Latitude < fremont.limits$upper.lat & Latitude > fremont.limits$lower.lat) %>% 
                                  #  filter(WEATHER == 'Raining')")))
    
    #print(ret)
    #print(all.equal(ret, fremont.data))
    
    #YESS WOW it works.
    ret <- eval(parse(text = gen.string2("fremont")))
    
    return(ret)
  })
  
  
  #greenwood.disp <- reactive({
    
  #})
  
  fremont.disp <- reactive({
    ret <- eval(parse(text = gen.string2("fremont")))
    return(ret)
  })
  phinney.ridge.disp <- reactive({
    ret <- eval(parse(text = gen.string2("phinney.ridge")))
    return(ret)
  })
  ballard.disp <- reactive({
    ret <- eval(parse(text = gen.string2("ballard")))
    return(ret)
  })
  
  greenwood.disp <- reactive({
    ret <- eval(parse(text = gen.string2("greenwood")))
    return(ret)
  })
  
  university.district.disp <- reactive({
    ret <- eval(parse(text = gen.string2("university.district")))
    return(ret)
  })
  
  green.lake.disp <- reactive({
    ret <- eval(parse(text = gen.string2("green.lake")))
    return(ret)
  })
  
  queen.anne.disp <- reactive({
    ret <- eval(parse(text = gen.string2("queen.anne")))
    return(ret)
  })
  
  magnolia.disp <- reactive({
    ret <- eval(parse(text = gen.string2("magnolia")))
    return(ret)
  })
  
  northgate.disp <- reactive({
    ret <- eval(parse(text = gen.string2("northgate")))
    return(ret)
  })
  capitol.hill.disp <- reactive({
    ret <- eval(parse(text = gen.string2("capitol.hill")))
    return(ret)
  })
  

  
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
    
    str <- "collision.data"
    str <- paste(str, "%>%", sprintf("filter(Longitude < %1$s.limits$upper.lng & Longitude > %1$s.limits$lower.lng)", city))
    str <- paste(str, "%>%", sprintf("filter(Latitude < %1$s.limits$upper.lat & Latitude > %1$s.limits$lower.lat)", city))
    if(input$raining){str <- paste(str, "%>%", "filter(WEATHER == 'Raining')")}
    
    #^ beautiful
    #SHOULD NOW BACKUP THIS COMMIT THIS CODE AND THEN REMOVE THE FAT.
    
    #str <- sprintf("if(input$raining) collision.data %%>%%
                     #filter(Longitude < %1$s.limits$upper.lng & Longitude > %1$s.limits$lower.lng) %%>%% 
                     #filter(Latitude < %1$s.limits$upper.lat & Latitude > %1$s.limits$lower.lat) else 
                     #collision.data %%>%% 
                     #filter(Longitude < %1$s.limits$upper.lng & Longitude > %1$s.limits$lower.lng) %%>%% 
                     #filter(Latitude < %1$s.limits$upper.lat & Latitude > %1$s.limits$lower.lat) %%>%% 
                     #filter(WEATHER == 'Raining')", city)
    return(str)
  }
  
  #vv no.. this doesn't really work. parse can only generate one expression. not +2
  #gen.string3 <- function(){
   # return("if(TRUE){print('5')} if(TRUE){print('6')}")
  #}
  #print(eval(parse(text = gen.string3())))
  
  #OLD SHIT
  #gen.string <- function(city){
   # buildup <- sprintf("collision.data %%>%% filter(Longitude < %1$s.limits$upper.lng & Longitude > %1$s.limits$lower.lat)) else (collision.data %%>%% filter(Longitude < %1$s.limits$upper.lng & Longitude > %1$s.limits$lower.lng) %%>%% filter(Latitude < %1$s.limits$upper.lat & Latitude > %1$s.limits$lower.lat) %%>%% filter(WEATHER == 'Raining')", city)
    
   # print(buildup)
#filter(Longitude < fremont.limits$upper.lng & Longitude > fremont.limits$lower.lng) %>% 
#    filter(Latitude < fremont.limits$upper.lat & Latitude > fremont.limits$lower.lat)) else 
#    (collision.data %>% 
#    filter(Longitude < fremont.limits$upper.lng & Longitude > fremont.limits$lower.lng) %>% 
#    filter(Latitude < fremont.limits$upper.lat & Latitude > fremont.limits$lower.lat) %>% 
#    filter(WEATHER == 'Raining')"
    
    #return(buildup)
  #}
  
  
  
  #gen.string.
  #^ yeah. it works.
  #i could have this function that generates the appropriate string that is precisely all the filtering necessary.
  
  #how do i keep this from being redundant for each city?
  #this is really annoying
  #
  
  clicks <- reactiveValues(map.click = NULL, shape.click = NULL)
  
  observeEvent(input$map_shape_click, {
    clicks$shape.click <- input$map_shape_click
    clicks$map.click <- NULL
  })
  
  
  
  observeEvent(input$map_click, {
    clicks$map.click <- input$map_click
    clicks$shape.click <- NULL
  })
  
  
  #data.disp <- reactive({
    #dummy <- input$raining
    #print(input$raining)
   # ret <- if(input$raining) (collision.data %>% 
                              #  filter(Longitude < fremont.limits$upper.lng & Longitude > fremont.limits$lower.lng) %>% 
                              #  filter(Latitude < fremont.limits$upper.lat & Latitude > fremont.limits$lower.lat)) else 
                              #    (collision.data %>% 
                              #       filter(Longitude < fremont.limits$upper.lng & Longitude > fremont.limits$lower.lng) %>% 
                              #       filter(Latitude < fremont.limits$upper.lat & Latitude > fremont.limits$lower.lat) %>% 
                              #       filter(WEATHER == "Raining"))
    #print(ret)
    #print(all.equal(ret, fremont.data))
  #  return(ret)
  #})
  
  

  
  
  
  
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
