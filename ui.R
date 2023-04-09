shinyUI(dashboardPage(
  # Color Scheme
  skin = "purple",
  
  # Header
  dashboardHeader(title = "Lichess Blitz Games"),
  
  # Sidebar
  dashboardSidebar(
    tags$style(
      HTML(
      ".skin-purple .main-sidebar .sidebar .sidebar-menu .active a {
      background-color: #9370DB;
      color: white;
      }
      .skin-purple .sidebar-menu .active > a:hover {
      background-color: #0056b3;
      color: white;
      }")
      ),
    sidebarUserPanel("Data Explorer v1.0",
                     image = "chess_cyber.jpg"),
    sidebarMenu(
      menuItem("Overview", tabName = "overview", icon = icon("info")),
      menuItem("Bad Moves", tabName = "bad_moves"),
      menuItem("Time", tabName = "time"),
      menuItem("Openings", tabName = "openings")
    )
  ),
    
  # Body
  dashboardBody(
    tabItems(
      tabItem(tabName = "overview",
              fluidPage(
                tabsetPanel(
                  tabPanel("About",
                           h2("About"),
                           p("Content for About")
                           ),
                  tabPanel("The Data",
                           h2("The Data"),
                           tags$div(
                             p("Link to dataset: https://www.kaggle.com/datasets/noobiedatascientist/lichess-september-2020-data"),
                             p("This data is taken from over 5m games played on www.lichess.org in the month of Sep 2020.")
                             )
                           )
                  )
                )
              ),
      tabItem(tabName = "bad_moves",
              fluidPage(
                h2("Bad Moves by ELO"),
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
                            step = 100),
                fluidRow(column(8, plotOutput("badmoves")))
                )
              ),
      tabItem(tabName = "time",
              fluidPage(
                h2("Time")
                )
              ),
      tabItem(tabName = "openings",
              fluidPage(
                h2("Openings")
                )
              )
    )
  )
  
))

  
  
  
  # # Sidebar
  # dashboardSidebar(
  #   tags$style(HTML
  #   ("
  #   .skin-purple .main-sidebar .sidebar .sidebar-menu .active a {
  #   background-color: #9370DB;
  #   color: white;
  #   }
  #   .skin-purple .sidebar-menu .active > a:hover {
  #   background-color: #0056b3;
  #   color: white;
  #   }
  #     ")),
  #   sidebarUserPanel("Data Explorer v1.0",
  #                    image = "chess_cyber.jpg"),
  #   conditionalPanel(
  #       condition = "input.tabs == 'overview'",
  #       sidebarMenu(id = "overview_sidebar",
  #                 menuItem("About", tabName = "about_tab"),
  #                 menuItem("Research Questions", tabName = "researchq_tab"),
  #                 menuItem("FAQ", tabName = "faq_tab")
  #                 )
  #     ),
  #   conditionalPanel(
  #     condition = "input.tabs == 'time'",
  #     sidebarMenu(id = "time_sidebar",
  #                 menuItem("Time Management", tabName = "time_mgmt_tab"),
  #                 menuItem("Number of Moves", tabName = "num_moves_tab"),
  #                 menuItem("Time Scramble Trouble", tabName = "time_trouble_tab"),
  #                 menuItem("Long Thinks", tabName = "long_think_tab")
  #                 )
  #   )
  # ),
  
  # Body
#   dashboardBody(
#     tabsetPanel(id = "tabs", 
#                 tabPanel("Overview", 
#                          value = "overview",
#                          uiOutput("overview_content")
#                          ),
#                 tabPanel("Bad Moves", value = "bad_moves",
#                          h2("Bad Moves by Player Strength"),
#                          radioButtons("bad_move_types",
#                                       label = "Bad Move Types",
#                                       choices = c("Blunders" = "blunders",
#                                                   "Mistakes" = "mistakes",
#                                                   "Inaccuracies" = "inaccuracies",
#                                                   "All" = "inferior"),
#                                             selected = "blunders"),
#                          sliderInput("elo_range",
#                                      label = "ELO Range",
#                                      min = 500, 
#                                      max = 3500, 
#                                      value = c(800, 2800),
#                                      step = 100
#                                      ),
#                          fluidRow(
#                            column(8, plotOutput("badmoves"))
#                          )),
#                 tabPanel("Time",
#                          value = "time",
#                          uiOutput("time_content")
#                          ),
#                 tabPanel("Openings",
#                          fluidRow(
#                            column(12, tags$div("Opening Analysis Plot placeholder"))
#                          ))
#     )
#   )
# )



