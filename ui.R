dashboardPage(
  skin = "purple",
  
  # Header
  dashboardHeader(title = "Lichess Blitz Games"),
  
  # Sidebar
  dashboardSidebar(
    tags$style(HTML
    ("
    .skin-purple .main-sidebar .sidebar .sidebar-menu .active a {
    background-color: #9370DB;
    color: white;
    }
    .skin-purple .sidebar-menu .active > a:hover {
    background-color: #0056b3;
    color: white;
    }
      ")),
    sidebarUserPanel("Data Explorer v1.0",
                     image = "chess_cyber.jpg"),
    conditionalPanel(
        condition = "input.tabs == 'overview'",
        sidebarMenu(id = "overview_sidebar",
                  menuItem("About", tabName = "about_tab"),
                  menuItem("Research Questions", tabName = "researchq_tab"),
                  menuItem("FAQ", tabName = "faq_tab")
                  )
      ),
    conditionalPanel(
      condition = "input.tabs == 'time'",
      sidebarMenu(id = "time_sidebar",
                  menuItem("Time Management", tabName = "time_mgmt_tab"),
                  menuItem("Time Scramble Trouble", tabName = "time_trouble_tab"),
                  menuItem("Long Thinks", tabName = "long_think_tab")
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
                         h2("Bad Moves by Player Strength"),
                         radioButtons("bad_move_types",
                                      label = "Bad Move Types",
                                      choices = c("Blunders" = "blunders",
                                                  "Mistakes" = "mistakes",
                                                  "Inaccuracies" = "inaccuracies",
                                                  "All" = "inferior"),
                                            selected = "blunders"),
                         sliderInput("elo_range",
                                     label = "ELO Range",
                                     min = 500, 
                                     max = 3500, 
                                     value = c(800, 2800),
                                     step = 100
                                     ),
                         fluidRow(
                           column(8, plotOutput("badmoves"))
                         )),
                tabPanel("Time",
                         value = "time",
                         uiOutput("time_content")
                         ),
                tabPanel("Openings",
                         fluidRow(
                           column(12, tags$div("Opening Analysis Plot placeholder"))
                         ))
    )
  )
)



