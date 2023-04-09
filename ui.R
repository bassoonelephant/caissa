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
      menuItem("Overview", tabName = "overview", icon = icon("info-circle")),
      menuItem("Bad Moves", tabName = "bad_moves", icon = icon("exclamation-triangle")),
      menuItem("Time", tabName = "time", icon = icon("clock")),
      menuItem("Openings", tabName = "openings", icon = icon("chess-board"))
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
                            step = 100),
                fluidRow(column(8, plotOutput("badmoves")))
                )
              ),
      tabItem(tabName = "time",
              fluidPage(
                tabsetPanel(
                  tabPanel("Time Management",
                           h2("Time Management by Player Strength"),
                           radioButtons("time_type",
                                        label = "Timed Move Types",
                                        choices = c("Time Scramble" = "ts",
                                                    "Long Moves" = "long moves"),
                                        selected = "ts"
                                        ),
                           sliderInput("elo_range_2",
                                       label = "ELO Range",
                                       min = 500,
                                       max = 3500,
                                       value = c(800, 2800),
                                       step = 100),
                           fluidRow(column(8, plotOutput("timed_moves_plot")))
                           ),
                  tabPanel("Moves",
                           h2("Number of Moves Per Game by Player Strength"),
                           fluidRow(column(6, plotlyOutput("num_moves_plot"))),
                           p("Notes:",
                             br(),
                             "n = 10,000 sample")
                           ),
                  tabPanel("Time Trouble",
                           h2("Effect of Time Scrambles on Blunders"),
                           tabsetPanel(
                             tabPanel("Summary",
                                      fluidRow(column(8, plotlyOutput("ts_sum_plot"))),
                                      p("Notes:",
                                        br(),
                                        "GM = 2400+, High = 1900-2400, Low = less than 1900")
                                      ),
                             tabPanel("Distribution",
                                      fluidRow(column(8, plotlyOutput("ts_dist_plot"))),
                                      p("Notes:",
                                        br(),
                                        "GM = 2400+, High = 1900-2400, Low = less than 1900",
                                        br(),
                                        "n = 10,000 sample")
                                      )
                             )
                           ),
                  tabPanel("Long Thinks")
                  )
                )
              ),
      tabItem(tabName = "openings",
              fluidPage(
                tabsetPanel(
                  tabPanel("Popularity"),
                  tabPanel("Adversary"),
                  tabPanel("Stats")
                )
              )
      )
    )
  )
  
))
    

     