dashboardPage(
  skin = "blue",
  
  # Header
  dashboardHeader(title = "Lichess Blitz Games"),
  
  # Sidebar
  dashboardSidebar(
    tags$style(HTML
    ("
    .skin-blue .main-sidebar .sidebar .sidebar-menu .active a {
    background-color: #2E8BC0;
    color: white;
    }
    .skin-blue .sidebar-menu .active > a:hover {
    background-color: #0056b3;
    color: white;
    }
      ")),
    sidebarUserPanel("Data Explorer v1.0",
                     image = "chess_cyber.jpg"),
    conditionalPanel(
      condition = "input.tabs == 'overview'",
      sidebarMenu(id = "overview_sidebar",
        menuItem("The Data", tabName = "data_tab"),
        menuItem("Research Questions", tabName = "researchq_tab"),
        menuItem("FAQ", tabName = "faq_tab")
      )
    )
  ),
  
  # Body
  dashboardBody(
    tabsetPanel(id = "tabs", 
                tabPanel("Overview", 
                         value = "overview",
                         uiOutput("overview_content")
                         ),
                tabPanel("Bad Moves", value = "bad_moves",      
                         radioButtons("bad_move_types",
                                      label = "Bad Move Types",
                                      choices = c("Blunders" = "blunders",
                                                  "Mistakes" = "mistakes",
                                                  "Inaccuracies" = "inaccuracies",
                                                  "All" = "all bad"),
                                            selected = "blunders"),
                         sliderInput("elo_range",
                                     label = "ELO Range",
                                     min = 500, 
                                     max = 3500, 
                                     value = c(1500, 2500),
                                     step = 100
                                     ),
                         fluidRow(
                           column(8, plotOutput("badmoves"))
                         )),
                tabPanel("Time",
                         fluidRow(
                           column(12, tags$div("Time Management Plot placeholder"))
                         )),
                tabPanel("Openings",
                         fluidRow(
                           column(12, tags$div("Opening Analysis Plot placeholder"))
                         ))
    )
  )
)



