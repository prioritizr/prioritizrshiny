
header <- dashboardHeader(
  
  title = "prioritzrshiny"
)

body <-  dashboardBody(
  fluidRow(
    column(width = 5,
           tabBox(
             title = "Inputs",
             # The id lets us use input$tabset1 on the server to find the current tab
             id = "tabset1", width = NULL,height = "600px", 
             tabPanel("Problem", 
               h4("Create a conservation problem"),
               p("By specifying the inputs below you can supply data to generate the problem"),
               br(),
               fileInput('x', 'x',multiple=TRUE),
               fileInput('features', 'features',multiple=TRUE),
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
             tabPanel("About the tool", 
                      h4("Systematic conservation prioritization in R"),
                      p("Prioritizr is an R package for solving systematic conservation prioritization problems 
                        using integer linear programming (ILP) techniques. The package offers a flexible interface 
                        for creating conservation problems using a range of different objectives and constraints that 
                        can be tailored to the specific needs of the conservation planner. Conservation problems can 
                        be solved using a variety of commercial and open-source exact algorithm solvers. In contrast 
                        to the algorithms conventionally used to solve conservation problems, such as greedy heuristics 
                        or simulated annealing, the exact algorithms used by prioritizr are guaranteed to find optimal 
                        solutions. This package also has the functionality to read Marxan input data and find much 
                        cheaper solutions in a much shorter period of time than Marxan (Beyer et al. 2016). Check out the 
                        prioritizrshiny R package to interactively build and customize conservation planning problems."),
                      h4("Disclaimer"),
                      p("The web tool and its scientific framework has been created over the past 4-years based on 
                        input and feedback from >100 interested groups and parties engaged in the development of 
                        Run-of-River hydropower in British Columbia. The tool represents an evidence-based framework 
                        that aims for a value-neutral presentation of the issues, and the project team has prioritized 
                        transparency and the inclusion of diverse perspectives.")),
                      
             tabPanel("Problem", 
                      leafletOutput("mymap")#,height=600)
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