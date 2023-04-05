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
    sidebarUserPanel("Explorer v1.0",
                     image = "chess_cyber.jpg"),
    conditionalPanel(
      condition = "input.tabs == 'overview'",
      sidebarMenu(id = "overview_sidebar",
        menuItem("The Data", tabName = "data_tab"),
        menuItem("Research Questions", tabName = "researchq_tab"),
        menuItem("FAQ", tabName = "faq_tab")
      )
    ),
    conditionalPanel(
      condition = "input.tabs == 'bad_moves'",
      radioButtons("player_color",
                   label = "Player Color",
                   choices = c("Black" = "black",
                               "White" = "white",
                               "Both" = "both"),
                   selected = "both"),
      sliderInput("elo_range",
                  label = "ELO Range",
                  min = 1000, max = 3000, value = c(1500, 2500),
                  step = 100)
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
                                      choices = c("Inaccuracies" = "inaccuracies",
                                                  "Mistakes" = "mistakes",
                                                  "Blunders" = "blunders",
                                                  "All" = "all bad"),
                                            selected = "all bad"),
                         fluidRow(
                           column(12, tags$div("Bad Moves Plot placeholder"))
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



