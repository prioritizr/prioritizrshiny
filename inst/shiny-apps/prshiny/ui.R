
header <- shinydashboard::dashboardHeader(
  
  title = "prioritzrshiny"
)

body <-  shinydashboard::dashboardBody(
  shinyjs::useShinyjs(),
  shiny::fluidRow(
    shiny::column(width = 5,
           shinydashboard::tabBox(
             title = "Inputs",
             # The id lets us use input$tabset1 on the server to find the current tab
             id = "tabset1", width = NULL,height = "600px", 
             
             ## DATA
             shiny::tabPanel("Data", 
               shiny::h4("Upload your data"),
               shiny::p("By specifying the inputs below you can supply data to generate the problem"),
               shiny::br(),
               shiny::selectInput('input_choice', 'Choose Input data type', 
                                   choices = c("Upload data" = "upload",
                                               "Example data" = "example"
                                               )),
               shinyjs::hidden(
                shiny::selectInput('example', 'What dataset would you like to use?',
                                  choices = c("Tasmania" = "tas",
                                              "Salt Spring Island" = "salt"
                                              ))
               ),
               
               # shinyjs::hidden(
                shiny::fileInput('file', 'Input files',multiple=TRUE),
               # ),
               
               shinyjs::hidden(
                 shiny::selectizeInput("cost_col", "Select cost column", choices = NULL, # no choices before uploading 
                               selected = NULL, multiple = FALSE)
                ),
               
               shinyjs::hidden(
                 shiny::selectizeInput("feat_col", "Select colum names of features", choices = NULL, # no choices before uploading 
                                selected = NULL, multiple = TRUE)
               ),
               
               #fileInput('features', 'features',multiple=TRUE),
          #drop-down based on x type to optionally selct cost column
               
               #fileInput('rij', 'rij (optional)',multiple=TRUE),
               #fileInput('rij_matrix', 'rij_matrix (optional)',multiple=TRUE),
               
               tags$hr(),
          
              "Once"  
               ),
          
               ## OBJECTIVES
               shiny::tabPanel("Objective",
                        shiny::selectizeInput("objective", "What objective function do you want to use?", 
                                       choices = c("Minimum set" = "min_set",
                                                   "Maximum cover" = "max_cov",
                                                   "Maximum features" = "max_feat",
                                                   "Maximum phylogeny" = "max_phylo",
                                                   "Maximum untility" = "max_util"),
                                       selected = 'min_set', multiple = FALSE),
                        shinyjs::hidden(
                          shiny::div(id = "targets",
                              shiny::selectizeInput("tar_type", "What target type do you want to use?", 
                                             choices = c("Relative target" = "rel_tar",
                                                         "Absolute target" = "abs_tar",
                                                         "Loglinear target" = "log_tar"),
                                             selected = 'rel_tar', multiple = FALSE),
                              shiny::radioButtons('glob_tar', 'Use one target for all?',
                                           c("Yes, global Target" = 'global',
                                             "No, individual Targets" = 'ind_tar'),'global'),
                              shinyjs::hidden(
                                shiny::numericInput("tar_all", "Set the global target", value = 0.1)
                                )
                              )
                          ),
                        shinyjs::hidden(
                          shiny::numericInput("budget", "Set the budget", value = 0)
                        ),
                        shinyjs::hidden(
                          shiny::textAreaInput("phylo", "Add Maximum Phylogenetic Representation Objective", value = "Not sure what we need here")
                        )
                        
               ),
            
            ## CONSTRAINTS
            tabPanel("Constraints", "Tab content Constraints"),
            
            ## PENALTIES
            shiny::tabPanel("Penalties", 
                        shiny::p("A penalty can be applied to a conservation planning 
                        problem to penalize solutions according to a specific metric. 
                        Penalties---unlike constraints---act as an explicit trade-off with the 
                        objective being minimized or maximized (e.g. total solution cost given 
                        add_min_set_objective)."),
                      shiny::selectizeInput("penalty", "Do you want to use a penalty function?", 
                                     choices = c("No penalty" = "none",
                                                 "Boundary penalty" = "bound",
                                                 "Connectivity penalty" = "conn"),
                                     selected = NULL, multiple = FALSE),
                      shinyjs::hidden(
                        shiny::div(id = "pen_bound",
                            shiny::numericInput("bound_penalty", "Penalty", 0),
                            shiny::numericInput("edge_factor", "Edge factor", 0),
                            shiny::fileInput('boundary_data', 'Boundary data (optional)',multiple=TRUE)
                            )
                      ),
                      
                      shinyjs::hidden(
                        shiny::div(id = "pen_conn",
                            shiny::numericInput("conn_penalty", "Penalty", 0),
                            shiny::fileInput('connectivity_data', 'Connectivity data',multiple=TRUE)
                        )
                      )

                      )

                      
           )
    ),
    shiny::column(width = 7,
           shinydashboard::tabBox(
             #title = "Oyt",
             id = "tabset2", width = NULL,height = "600px", 
             about_panel,
             howto_panel,
             shiny::tabPanel("Outputs",
                      shinydashboard::box(
                        #                    solidHeader = TRUE,status = "primary",
                        leaflet::leafletOutput("mymap", height=500),
                        width = NULL,
                        collapsible = FALSE),#,collapsed=TRUE),
                      shinydashboard::box(
                        solidHeader = FALSE,#,status = "primary",
                        #background = "light-blue",
                        DT::DTOutput("contents"),
                        width = NULL)
                      
                      #leafletOutput("mymap")#,height=600)
           )
    ))
    
  ),

  shiny::fluidRow(
    shiny::column(width = 5,
    shinydashboard::box(width = NULL, solidHeader = TRUE,
      # Title can include an icon
      title = tagList(shiny::icon("gear"), "Setup and solve the problem"),
      shiny::actionButton("Bproblem","Create the prioritizr problem"),
      shiny::tags$hr(),
      shinyjs::hidden(
        shiny::div(id = "to_solve",
          shiny::p("If you are happy with your specification, go ahead and solve your conservation problem."),
          shiny::actionButton("Bsolve","Solve the prioritizr problem")
        )
      )
      
    ))
  )
)


shinydashboard::dashboardPage(
  header,
  shinydashboard::dashboardSidebar(disable = TRUE),
  body
)