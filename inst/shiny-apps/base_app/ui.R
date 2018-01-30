
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
               #Single Species selection
               #selectInput("columns", "Select Columns", choices = NULL), # no choices before uploading 
               shinyjs::hidden(
                selectizeInput("columns", "Select Columns", choices = NULL, # no choices before uploading 
                               selected = NULL, multiple = FALSE,
                               options = list(placeholder = 'select a single species'))
                ),
               fileInput('features', 'features',multiple=TRUE),
          #drop-down based on x type to optionally selct cost column
               
               fileInput('rij', 'rij (optional)',multiple=TRUE),
               fileInput('rij_matrix', 'rij_matrix (optional)',multiple=TRUE),
               
               tags$hr(),
               actionButton("mrun","Create the prioritizr problem")
               

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
      title = tagList(shiny::icon("gear"), "Solve the problem"),
      p("If you are happy with your specification, go ahead and solve your conservation problem."),
      actionButton("mrun","Solve teh prioritizr problem")
      
    ))
  )
)


dashboardPage(
  header,
  dashboardSidebar(disable = TRUE),
  body
)