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
                   
    updateSelectInput(session, "columns","Select Columns", choices = vars)

    return (pu)
  })

  
  observe({
    if (class(pu()) == "SpatialPolygonsDataFrame") {
      shinyjs::show("columns")
    } else {
      shinyjs::hide("columns")
    }
  })
  
  output$contents <- renderTable({
    
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, head of that data file by default,
    # or all rows if selected, will be shown.
    
    req(input$x)
    
    out <- pu()@data
    
    
    
      return(out)
  })
}