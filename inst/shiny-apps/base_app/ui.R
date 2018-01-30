
header <- dashboardHeader(
  
  title = "prioritzrshiny"
)

body <-  dashboardBody(
  useShinyjs(),
  fluidRow(
    column(width = 5,
           tabBox(
             title = "Inputs",
             # The id lets us use input$tabset1 on the server to find the current tab
             id = "tabset1", width = NULL,height = "600px", 
             tabPanel("Data", 
               h4("Upload your data"),
               p("By specifying the inputs below you can supply data to generate the problem"),
               br(),
               fileInput('x', 'x',multiple=TRUE),
               shinyjs::hidden(
                 selectizeInput("cost_col", "Select cost column", choices = NULL, # no choices before uploading 
                               selected = NULL, multiple = FALSE)
                ),
               
               shinyjs::hidden(
                 selectizeInput("feat_col", "Select colum names of features", choices = NULL, # no choices before uploading 
                                selected = NULL, multiple = TRUE)
               ),
               
               #fileInput('features', 'features',multiple=TRUE),
          #drop-down based on x type to optionally selct cost column
               
               #fileInput('rij', 'rij (optional)',multiple=TRUE),
               #fileInput('rij_matrix', 'rij_matrix (optional)',multiple=TRUE),
               
               tags$hr()
               
               

               ),
             tabPanel("Objective", "Tab content Objective"),
             tabPanel("Constraints", "Tab content Constraints"),
             tabPanel("Penalties", "Tab content Penalties")
             
           )
    ),
    column(width = 7,
           tabBox(
             #title = "Oyt",
             id = "tabset2", width = NULL,height = "600px", 
             about_panel,
             howto_panel,
             tabPanel("Problem",
                      tableOutput("contents")
                      #leafletOutput("mymap")#,height=600)
           )
    ))
    
  ),

  fluidRow(
    column(width = 5,
    box(width = NULL, solidHeader = TRUE,
      # Title can include an icon
      title = tagList(shiny::icon("gear"), "Setup and solve the problem"),
      actionButton("mcreate","Create the prioritizr problem"),
      tags$hr(),
      p("If you are happy with your specification, go ahead and solve your conservation problem."),
      actionButton("mrun","Solve the prioritizr problem")
      
    ))
  )
)


dashboardPage(
  header,
  dashboardSidebar(disable = TRUE),
  body
)