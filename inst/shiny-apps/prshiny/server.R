base::options(shiny.maxRequestSize=10000*1024^2)

function(input, output, session) {
  
  
  pu <- shiny::reactive({
    shpDF <- input$x
    
    req(shpDF)
    
    #shpDF <- input$x
    prevWD <- getwd()
    uploadDirectory <- dirname(shpDF$datapath[1])
    setwd(uploadDirectory)
    for (i in 1:nrow(shpDF)){
      file.rename(shpDF$datapath[i], shpDF$name[i])
    }
    shpName <- shpDF$name[grep(x=shpDF$name, pattern="*.shp")]
    shpPath <- paste(uploadDirectory)#, shpName, sep="/")
    setwd(prevWD)
    pu <- rgdal::readOGR(dsn=shpPath,layer=substr(shpName, 1, nchar(shpName) - 4) , stringsAsFactors = FALSE, GDAL1_integer64=TRUE)
    if(!is.na(raster::projection(pu))){
      pu <- sp::spTransform(pu, sp::CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs "))
    }
    vars <- names(pu)
    #selectizeInput("singlespp", "Select single speices from the List", 
    #               choices = names(output.pu),
    
    shiny::updateSelectInput(session, "cost_col", choices = vars)
    shiny::updateSelectInput(session, "feat_col", choices = vars)
    
    return (pu)
  })
  
  
  prob <- shiny::eventReactive(input$Bproblem, {
    pu <- pu()
    
    p <- prioritizr::problem(pu, features = input$feat_col, cost_column = input$cost_col)
    
    return(p)
  })
  
  solv <- reactive({ 
    # Don't do anything until after the first button push.
    input$Bsolve
    # Note that just by virtue of checking the value of input$recalcButton,
    # we're now going to get called whenever it is pushed.    
    if(input$Bsolve == 0)
      return(NULL)    
    
    return(shiny::isolate({
      
      p <- prob()
      
      #add objective  
      if (input$objective == "min_set"){
        p <- p %>% prioritizr::add_min_set_objective()
        
      } else if (input$objective == "max_cov"){
        p <- p %>% prioritizr::add_max_cover_objective(input$budget)
        
      } else if (input$objective == "max_feat"){
        p <- p %>% prioritizr::add_max_features_objective(input$budget)
        
      } else if (input$objective == "max_phylo"){
        p <- p %>% prioritizr::add_max_phylo_objective(input$budget, input$phylo)
        
      } else if (input$objective == "max_util"){
        p <- p %>% prioritizr::add_max_utility_objective(input$budget)
        
      } #else{
      #Throw error or show warning
      #}
      
      
      #add targets
      if (input$objective %in% c("min_set", "max_feat", "max_phylo")){
        
        if(input$glob_tar == "global"){
          tmp_tar <- input$tar_all
        } else {
          tmp_tar <- 1 #get target values from rhandsontable
        }
        
        if(input$tar_type == "rel_tar"){
          p <- p %>% prioritizr::add_relative_targets(tmp_tar)
          
        } else if(input$tar_type == "abs_tar"){
          p <- p %>% prioritizr::add_relative_targets(tmp_tar)
          
        } else if(input$tar_type == "log_tar"){
          p <- p %>% prioritizr::add_loglinear_targets(tmp_tar)
          
        }
      }
      
      
      s <- prioritizr::solve(p)
      
      return(s)
    }))
    
  })
  
  shiny::observe ({  solv()
  }) 
  #################################################################################################################
  #shinyjs checks
  #################################################################################################################
  shiny::observe({
    if (class(pu()) == "SpatialPolygonsDataFrame") {
      shinyjs::show("cost_col")
    } else {
      shinyjs::hide("cost_col")
    }
  })
  
  shiny::observe({
    if (class(pu()) == "SpatialPolygonsDataFrame") {
      shinyjs::show("feat_col")
    } else {
      shinyjs::hide("feat_col")
    }
  })
  
  shiny::observe({
    if (input$objective != "min_set") {
      shinyjs::show("budget")
    } else {
      shinyjs::hide("budget")
    }
  })
  
  shiny::observe({
    if (input$objective == "max_phylo") {
      shinyjs::show("phylo")
    } else {
      shinyjs::hide("phylo")
    }
  })
  
  shiny::observe({
    if (input$objective %in% c("min_set", "max_feat", "max_phylo")) {
      shinyjs::show("targets")
    } else {
      shinyjs::hide("targets")
    }
  })
  
  shiny::observe({
    if (input$glob_tar == "global") {
      shinyjs::show("tar_all")
    } else {
      shinyjs::hide("tar_all")
    }
  })
  
  
  shiny::observe({
    if (input$penalty == "bound") {
      shinyjs::show("pen_bound")
    } else {
      shinyjs::hide("pen_bound")
    }
  })
  
  shiny::observe({
    if (input$penalty == "conn") {
      shinyjs::show("pen_conn")
    } else {
      shinyjs::hide("pen_conn")
    }
  })
  
  shiny::observe({
    if (input$Bproblem) {
      shinyjs::show("to_solve")
    } else {
      shinyjs::hide("to_solve")
    }
  })
  
  
  
  
  #################################################################################################################
  #End shinyjs checks
  #################################################################################################################
  
  output$contents <- shiny::renderPrint({
    
    #req(input$x)
    #pp <- prob()
    ss <- solv()
    
    ss
    
  })
  
  ########################################################
  ## Output map
  ########################################################
  
  output$mymap <- leaflet::renderLeaflet({
    
    sol <- solv()
    sol$solution_1 <- factor(sol$solution_1)
    
    pal.sol <- leaflet::colorFactor("YlOrRd", sol$solution_1)
    
    leaflet::leaflet(sol) %>% leaflet::addTiles() %>%
      # Base groups
      leaflet::addProviderTiles("Esri.WorldStreetMap",group = "StreetMap") %>%
      leaflet::addProviderTiles("Esri.WorldImagery", group = "Aerial") %>%
      leaflet::addProviderTiles("Stamen.Terrain", group = "Terrain") %>%
      leaflet::addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5, group = "solution",
                  opacity = 1.0, fillOpacity = 1,
                  fillColor = leaflet::colorFactor("YlOrRd", sol$solution_1)(sol$solution_1),
                  highlightOptions = leaflet::highlightOptions(color = "white", weight = 2,
                                                      bringToFront = TRUE)) %>%
      leaflet::addScaleBar(position = "topleft") %>%
      leaflet::addLayersControl(baseGroups = c("StreetMap", "Aerial", "Terrain"),
                       overlayGroups = c("solution"),
                       options = leaflet::layersControlOptions(collapsed = FALSE)) %>%
      leaflet::addLegend(pal = pal.sol, values = sol$solution_1, 
               position = "topright",title = "Solution", group = "solution") 
  })
  
  
 
  
  
  
  
}