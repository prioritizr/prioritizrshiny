function(input, output, session) {
  
  
  pu <- reactive({
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
    pu <- readOGR(dsn=shpPath,layer=substr(shpName, 1, nchar(shpName) - 4) , stringsAsFactors = FALSE)
    vars <- names(pu)
    #selectizeInput("singlespp", "Select single speices from the List", 
    #               choices = names(output.pu),
                   
    updateSelectInput(session, "cost_col", choices = vars)
    updateSelectInput(session, "feat_col", choices = vars)
    
    return (pu)
  })

  
  #################################################################################################################
  #shinyjs checks
  #################################################################################################################
  observe({
    if (class(pu()) == "SpatialPolygonsDataFrame") {
      shinyjs::show("cost_col")
    } else {
      shinyjs::hide("cost_col")
    }
  })

  observe({
    if (class(pu()) == "SpatialPolygonsDataFrame") {
      shinyjs::show("feat_col")
    } else {
      shinyjs::hide("feat_col")
    }
  })
  
  observe({
    if (input$objective != "min_set") {
      shinyjs::show("budget")
    } else {
      shinyjs::hide("budget")
    }
  })
  
  observe({
    if (input$objective == "max_phylo") {
      shinyjs::show("phylo")
    } else {
      shinyjs::hide("phylo")
    }
  })
  
  observe({
    if (input$objective %in% c("min_set", "max_feat", "max_phylo")) {
      shinyjs::show("targets")
    } else {
      shinyjs::hide("targets")
    }
  })
  
  observe({
    if (input$glob_tar == "global") {
      shinyjs::show("tar_all")
    } else {
      shinyjs::hide("tar_all")
    }
  })
  

  observe({
    if (input$penalty == "bound") {
      shinyjs::show("pen_bound")
    } else {
      shinyjs::hide("pen_bound")
    }
  })
  
  observe({
    if (input$penalty == "conn") {
      shinyjs::show("pen_conn")
    } else {
      shinyjs::hide("pen_conn")
    }
  })

  observe({
    if (input$Bproblem) {
      shinyjs::show("to_solve")
    } else {
      shinyjs::hide("to_solve")
    }
  })
  
  
  
  
  #################################################################################################################
  #End shinyjs checks
  #################################################################################################################
  
  output$contents <- renderTable({
    
    req(input$x)
    out <- pu()@data
    return(out)
  })
  
  
  
  
}